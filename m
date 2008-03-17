Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYCQMff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYCQMff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 08:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYCQMf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:35:26 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46883 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbYCQMfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:35:25 -0400
Date: Mon, 17 Mar 2008 08:35:24 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080317123524.GA22741@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Notes:
* the devres change is included here because the ahci fix needs it

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |   72 ++++++++++++++++++++++-----------
 drivers/ata/libata-acpi.c |   96 ++++++++++++++++++++++++++++++++-------------
 drivers/ata/pata_ali.c    |    2 +-
 include/linux/pci.h       |    2 +
 lib/devres.c              |   25 ++++++++++++
 5 files changed, 145 insertions(+), 52 deletions(-)

Jose Alberto Reguero (1):
      ahci: Add Marvell 6121 SATA support

Tejun Heo (5):
      libata-acpi: improve dock event handling
      devres: implement pcim_iomap_regions_request_all()
      ahci: request all PCI BARs
      ahci: implement skip_host_reset parameter
      pata_ali: use atapi_cmd_type() to determine cmd type instead of transfer size

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6978469..17ee6ed 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -49,6 +49,10 @@
 #define DRV_NAME	"ahci"
 #define DRV_VERSION	"3.0"
 
+static int ahci_skip_host_reset;
+module_param_named(skip_host_reset, ahci_skip_host_reset, int, 0444);
+MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)");
+
 static int ahci_enable_alpm(struct ata_port *ap,
 		enum link_pm policy);
 static void ahci_disable_alpm(struct ata_port *ap);
@@ -587,6 +591,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 
 	/* Marvell */
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
+	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
 
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
@@ -661,6 +666,7 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 	void __iomem *mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
 	u32 cap, port_map;
 	int i;
+	int mv;
 
 	/* make sure AHCI mode is enabled before accessing CAP */
 	ahci_enable_ahci(mmio);
@@ -696,12 +702,16 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 	 * presence register, as bit 4 (counting from 0)
 	 */
 	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
+		if (pdev->device == 0x6121)
+			mv = 0x3;
+		else
+			mv = 0xf;
 		dev_printk(KERN_ERR, &pdev->dev,
 			   "MV_AHCI HACK: port_map %x -> %x\n",
-			   hpriv->port_map,
-			   hpriv->port_map & 0xf);
+			   port_map,
+			   port_map & mv);
 
-		port_map &= 0xf;
+		port_map &= mv;
 	}
 
 	/* cross check port_map and cap.n_ports */
@@ -1088,29 +1098,35 @@ static int ahci_reset_controller(struct ata_host *host)
 	ahci_enable_ahci(mmio);
 
 	/* global controller reset */
-	tmp = readl(mmio + HOST_CTL);
-	if ((tmp & HOST_RESET) == 0) {
-		writel(tmp | HOST_RESET, mmio + HOST_CTL);
-		readl(mmio + HOST_CTL); /* flush */
-	}
+	if (!ahci_skip_host_reset) {
+		tmp = readl(mmio + HOST_CTL);
+		if ((tmp & HOST_RESET) == 0) {
+			writel(tmp | HOST_RESET, mmio + HOST_CTL);
+			readl(mmio + HOST_CTL); /* flush */
+		}
 
-	/* reset must complete within 1 second, or
-	 * the hardware should be considered fried.
-	 */
-	ssleep(1);
+		/* reset must complete within 1 second, or
+		 * the hardware should be considered fried.
+		 */
+		ssleep(1);
 
-	tmp = readl(mmio + HOST_CTL);
-	if (tmp & HOST_RESET) {
-		dev_printk(KERN_ERR, host->dev,
-			   "controller reset failed (0x%x)\n", tmp);
-		return -EIO;
-	}
+		tmp = readl(mmio + HOST_CTL);
+		if (tmp & HOST_RESET) {
+			dev_printk(KERN_ERR, host->dev,
+				   "controller reset failed (0x%x)\n", tmp);
+			return -EIO;
+		}
 
-	/* turn on AHCI mode */
-	ahci_enable_ahci(mmio);
+		/* turn on AHCI mode */
+		ahci_enable_ahci(mmio);
 
-	/* some registers might be cleared on reset.  restore initial values */
-	ahci_restore_initial_config(host);
+		/* Some registers might be cleared on reset.  Restore
+		 * initial values.
+		 */
+		ahci_restore_initial_config(host);
+	} else
+		dev_printk(KERN_INFO, host->dev,
+			   "skipping global host reset\n");
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
 		u16 tmp16;
@@ -1162,9 +1178,14 @@ static void ahci_init_controller(struct ata_host *host)
 	int i;
 	void __iomem *port_mmio;
 	u32 tmp;
+	int mv;
 
 	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
-		port_mmio = __ahci_port_base(host, 4);
+		if (pdev->device == 0x6121)
+			mv = 2;
+		else
+			mv = 4;
+		port_mmio = __ahci_port_base(host, mv);
 
 		writel(0, port_mmio + PORT_IRQ_MASK);
 
@@ -2241,7 +2262,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	rc = pcim_iomap_regions(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
+	/* AHCI controllers often implement SFF compatible interface.
+	 * Grab all PCI BARs just in case.
+	 */
+	rc = pcim_iomap_regions_request_all(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
 	if (rc == -EBUSY)
 		pcim_pin_device(pdev);
 	if (rc)
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 0770cb7..bf98a56 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -118,45 +118,77 @@ static void ata_acpi_associate_ide_port(struct ata_port *ap)
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 }
 
-static void ata_acpi_handle_hotplug(struct ata_port *ap, struct kobject *kobj,
+static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
 				    u32 event)
 {
 	char event_string[12];
 	char *envp[] = { event_string, NULL };
-	struct ata_eh_info *ehi = &ap->link.eh_info;
-
-	if (event == 0 || event == 1) {
-	       unsigned long flags;
-	       spin_lock_irqsave(ap->lock, flags);
-	       ata_ehi_clear_desc(ehi);
-	       ata_ehi_push_desc(ehi, "ACPI event");
-	       ata_ehi_hotplugged(ehi);
-	       ata_port_freeze(ap);
-	       spin_unlock_irqrestore(ap->lock, flags);
+	struct ata_eh_info *ehi;
+	struct kobject *kobj = NULL;
+	int wait = 0;
+	unsigned long flags;
+
+	if (!ap)
+		ap = dev->link->ap;
+	ehi = &ap->link.eh_info;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	switch (event) {
+	case ACPI_NOTIFY_BUS_CHECK:
+	case ACPI_NOTIFY_DEVICE_CHECK:
+		ata_ehi_push_desc(ehi, "ACPI event");
+		ata_ehi_hotplugged(ehi);
+		ata_port_freeze(ap);
+		break;
+
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		ata_ehi_push_desc(ehi, "ACPI event");
+		if (dev)
+			dev->flags |= ATA_DFLAG_DETACH;
+		else {
+			struct ata_link *tlink;
+			struct ata_device *tdev;
+
+			ata_port_for_each_link(tlink, ap)
+				ata_link_for_each_dev(tdev, tlink)
+					tdev->flags |= ATA_DFLAG_DETACH;
+		}
+
+		ata_port_schedule_eh(ap);
+		wait = 1;
+		break;
 	}
 
+	if (dev) {
+		if (dev->sdev)
+			kobj = &dev->sdev->sdev_gendev.kobj;
+	} else
+		kobj = &ap->dev->kobj;
+
 	if (kobj) {
 		sprintf(event_string, "BAY_EVENT=%d", event);
 		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
 	}
+
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	if (wait)
+		ata_port_wait_eh(ap);
 }
 
 static void ata_acpi_dev_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_device *dev = data;
-	struct kobject *kobj = NULL;
 
-	if (dev->sdev)
-		kobj = &dev->sdev->sdev_gendev.kobj;
-
-	ata_acpi_handle_hotplug(dev->link->ap, kobj, event);
+	ata_acpi_handle_hotplug(NULL, dev, event);
 }
 
 static void ata_acpi_ap_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_port *ap = data;
 
-	ata_acpi_handle_hotplug(ap, &ap->dev->kobj, event);
+	ata_acpi_handle_hotplug(ap, NULL, event);
 }
 
 /**
@@ -191,20 +223,30 @@ void ata_acpi_associate(struct ata_host *host)
 		else
 			ata_acpi_associate_ide_port(ap);
 
-		if (ap->acpi_handle)
-			acpi_install_notify_handler (ap->acpi_handle,
-						     ACPI_SYSTEM_NOTIFY,
-						     ata_acpi_ap_notify,
-						     ap);
+		if (ap->acpi_handle) {
+			acpi_install_notify_handler(ap->acpi_handle,
+						    ACPI_SYSTEM_NOTIFY,
+						    ata_acpi_ap_notify, ap);
+#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
+			/* we might be on a docking station */
+			register_hotplug_dock_device(ap->acpi_handle,
+						     ata_acpi_ap_notify, ap);
+#endif
+		}
 
 		for (j = 0; j < ata_link_max_devices(&ap->link); j++) {
 			struct ata_device *dev = &ap->link.device[j];
 
-			if (dev->acpi_handle)
-				acpi_install_notify_handler (dev->acpi_handle,
-							     ACPI_SYSTEM_NOTIFY,
-							     ata_acpi_dev_notify,
-							     dev);
+			if (dev->acpi_handle) {
+				acpi_install_notify_handler(dev->acpi_handle,
+						ACPI_SYSTEM_NOTIFY,
+						ata_acpi_dev_notify, dev);
+#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
+				/* we might be on a docking station */
+				register_hotplug_dock_device(dev->acpi_handle,
+						ata_acpi_dev_notify, dev);
+#endif
+			}
 		}
 	}
 }
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 7e68edf..8786455 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -295,7 +295,7 @@ static void ali_lock_sectors(struct ata_device *adev)
 static int ali_check_atapi_dma(struct ata_queued_cmd *qc)
 {
 	/* If its not a media command, its not worth it */
-	if (qc->nbytes < 2048)
+	if (atapi_cmd_type(qc->cdb[0]) == ATAPI_MISC)
 		return -EOPNOTSUPP;
 	return 0;
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9010f54..b7e4b63 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1045,6 +1045,8 @@ void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
 void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
 void __iomem * const *pcim_iomap_table(struct pci_dev *pdev);
 int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name);
+int pcim_iomap_regions_request_all(struct pci_dev *pdev, u16 mask,
+				   const char *name);
 void pcim_iounmap_regions(struct pci_dev *pdev, u16 mask);
 
 extern int pci_pci_problems;
diff --git a/lib/devres.c b/lib/devres.c
index b1d336c..edc27a5 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -298,6 +298,31 @@ int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name)
 EXPORT_SYMBOL(pcim_iomap_regions);
 
 /**
+ * pcim_iomap_regions_request_all - Request all BARs and iomap specified ones
+ * @pdev: PCI device to map IO resources for
+ * @mask: Mask of BARs to iomap
+ * @name: Name used when requesting regions
+ *
+ * Request all PCI BARs and iomap regions specified by @mask.
+ */
+int pcim_iomap_regions_request_all(struct pci_dev *pdev, u16 mask,
+				   const char *name)
+{
+	int request_mask = ((1 << 6) - 1) & ~mask;
+	int rc;
+
+	rc = pci_request_selected_regions(pdev, request_mask, name);
+	if (rc)
+		return rc;
+
+	rc = pcim_iomap_regions(pdev, mask, name);
+	if (rc)
+		pci_release_selected_regions(pdev, request_mask);
+	return rc;
+}
+EXPORT_SYMBOL(pcim_iomap_regions_request_all);
+
+/**
  * pcim_iounmap_regions - Unmap and release PCI BARs
  * @pdev: PCI device to map IO resources for
  * @mask: Mask of BARs to unmap and release

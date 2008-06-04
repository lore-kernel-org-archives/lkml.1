Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbYFDKpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbYFDKpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbYFDKpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:45:39 -0400
Received: from havoc.gtf.org ([69.61.125.42]:41850 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbYFDKph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:45:37 -0400
Date: Wed, 4 Jun 2008 06:45:35 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080604104535.GA10665@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan's next-to-last patch revision, a much-needed ACPI fix-a-rama, ...


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c      |    2 +
 drivers/ata/libata-acpi.c   |  165 +++++++++++++++++++++++++++++-------------
 drivers/ata/libata-sff.c    |  115 ++++++++++++++++++++++++++----
 drivers/ata/pata_icside.c   |    2 +-
 drivers/ata/pata_rb532_cf.c |    4 +-
 drivers/ata/pata_scc.c      |    5 +-
 drivers/ata/sata_mv.c       |   24 ++++---
 include/linux/libata.h      |   19 +-----
 8 files changed, 239 insertions(+), 97 deletions(-)

Alan Cox (1):
      libata-sff: Fix oops reported in kerneloops.org for pnp devices with no ctl

Colin Ian King (1):
      [libata] ata_piix: more acer short cable quirks

Holger Macht (1):
      [libata] ACPI: Properly handle bay devices in dock stations

Mark Lord (1):
      sata_mv: PHY_MODE4 cleanups

Tejun Heo (1):
      libata: kill unused constants

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 3548ee7..81b7ae3 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -574,6 +574,8 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on ACER Aspire 2023WLMi */
+	{ 0x24CA, 0x1025, 0x003d },	/* ICH4 on ACER TM290 */
+	{ 0x266F, 0x1025, 0x0066 },	/* ICH6 on ACER Aspire 1694WLMi */
 	{ 0x2653, 0x1043, 0x82D8 },	/* ICH6M on Asus Eee 701 */
 	/* end marker */
 	{ 0, }
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index dbf6ca7..3ff8b14 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -118,12 +118,62 @@ static void ata_acpi_associate_ide_port(struct ata_port *ap)
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 }
 
-static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device
-				    *dev, u32 event)
+static void ata_acpi_eject_device(acpi_handle handle)
+{
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = 1;
+
+	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_EJ0",
+					      &arg_list, NULL)))
+		printk(KERN_ERR "Failed to evaluate _EJ0!\n");
+}
+
+/* @ap and @dev are the same as ata_acpi_handle_hotplug() */
+static void ata_acpi_detach_device(struct ata_port *ap, struct ata_device *dev)
+{
+	if (dev)
+		dev->flags |= ATA_DFLAG_DETACH;
+	else {
+		struct ata_link *tlink;
+		struct ata_device *tdev;
+
+		ata_port_for_each_link(tlink, ap)
+			ata_link_for_each_dev(tdev, tlink)
+				tdev->flags |= ATA_DFLAG_DETACH;
+	}
+
+	ata_port_schedule_eh(ap);
+}
+
+/**
+ * ata_acpi_handle_hotplug - ACPI event handler backend
+ * @ap: ATA port ACPI event occurred
+ * @dev: ATA device ACPI event occurred (can be NULL)
+ * @event: ACPI event which occurred
+ * @is_dock_event: boolean indicating whether the event was a dock one
+ *
+ * All ACPI bay / device realted events end up in this function.  If
+ * the event is port-wide @dev is NULL.  If the event is specific to a
+ * device, @dev points to it.
+ *
+ * Hotplug (as opposed to unplug) notification is always handled as
+ * port-wide while unplug only kills the target device on device-wide
+ * event.
+ *
+ * LOCKING:
+ * ACPI notify handler context.  May sleep.
+ */
+static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
+				    u32 event, int is_dock_event)
 {
 	char event_string[12];
 	char *envp[] = { event_string, NULL };
-	struct ata_eh_info *ehi;
+	struct ata_eh_info *ehi = &ap->link.eh_info;
 	struct kobject *kobj = NULL;
 	int wait = 0;
 	unsigned long flags;
@@ -131,87 +181,100 @@ static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device
 	unsigned long sta;
 	acpi_status status;
 
-	if (!ap)
-		ap = dev->link->ap;
-	ehi = &ap->link.eh_info;
-
-	spin_lock_irqsave(ap->lock, flags);
-
-	if (dev)
+	if (dev) {
+		if (dev->sdev)
+			kobj = &dev->sdev->sdev_gendev.kobj;
 		handle = dev->acpi_handle;
-	else
+	} else {
+		kobj = &ap->dev->kobj;
 		handle = ap->acpi_handle;
+	}
 
 	status = acpi_get_handle(handle, "_EJ0", &tmphandle);
-	if (ACPI_FAILURE(status)) {
-		/* This device is not ejectable */
-		spin_unlock_irqrestore(ap->lock, flags);
+	if (ACPI_FAILURE(status))
+		/* This device does not support hotplug */
 		return;
-	}
 
-	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
-	if (ACPI_FAILURE(status)) {
-		printk ("Unable to determine bay status\n");
-		spin_unlock_irqrestore(ap->lock, flags);
-		return;
-	}
+	spin_lock_irqsave(ap->lock, flags);
 
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		ata_ehi_push_desc(ehi, "ACPI event");
-		if (!sta) {
-                /* Device has been unplugged */
-			if (dev)
-				dev->flags |= ATA_DFLAG_DETACH;
-			else {
-				struct ata_link *tlink;
-				struct ata_device *tdev;
-
-				ata_port_for_each_link(tlink, ap) {
-					ata_link_for_each_dev(tdev, tlink) {
-						tdev->flags |=
-							ATA_DFLAG_DETACH;
-					}
-				}
-			}
-			ata_port_schedule_eh(ap);
-			wait = 1;
-		} else {
+
+		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+		if (ACPI_FAILURE(status)) {
+			ata_port_printk(ap, KERN_ERR,
+				"acpi: failed to determine bay status (0x%x)\n",
+				status);
+			break;
+		}
+
+		if (sta) {
 			ata_ehi_hotplugged(ehi);
 			ata_port_freeze(ap);
+		} else {
+			/* The device has gone - unplug it */
+			ata_acpi_detach_device(ap, dev);
+			wait = 1;
 		}
+		break;
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		ata_ehi_push_desc(ehi, "ACPI event");
+
+		if (!is_dock_event)
+			break;
+
+		/* undock event - immediate unplug */
+		ata_acpi_detach_device(ap, dev);
+		wait = 1;
+		break;
 	}
 
+	/* make sure kobj doesn't go away while ap->lock is released */
+	kobject_get(kobj);
+
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	if (wait)
+	if (wait) {
 		ata_port_wait_eh(ap);
+		ata_acpi_eject_device(handle);
+	}
 
-	if (dev) {
-		if (dev->sdev)
-			kobj = &dev->sdev->sdev_gendev.kobj;
-	} else
-		kobj = &ap->dev->kobj;
-
-	if (kobj) {
+	if (kobj && !is_dock_event) {
 		sprintf(event_string, "BAY_EVENT=%d", event);
 		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
 	}
+
+	kobject_put(kobj);
+}
+
+static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
+{
+	struct ata_device *dev = data;
+
+	ata_acpi_handle_hotplug(dev->link->ap, dev, event, 1);
+}
+
+static void ata_acpi_ap_notify_dock(acpi_handle handle, u32 event, void *data)
+{
+	struct ata_port *ap = data;
+
+	ata_acpi_handle_hotplug(ap, NULL, event, 1);
 }
 
 static void ata_acpi_dev_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_device *dev = data;
 
-	ata_acpi_handle_hotplug(NULL, dev, event);
+	ata_acpi_handle_hotplug(dev->link->ap, dev, event, 0);
 }
 
 static void ata_acpi_ap_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_port *ap = data;
 
-	ata_acpi_handle_hotplug(ap, NULL, event);
+	ata_acpi_handle_hotplug(ap, NULL, event, 0);
 }
 
 /**
@@ -252,7 +315,7 @@ void ata_acpi_associate(struct ata_host *host)
 						    ata_acpi_ap_notify, ap);
 			/* we might be on a docking station */
 			register_hotplug_dock_device(ap->acpi_handle,
-						     ata_acpi_ap_notify, ap);
+					     ata_acpi_ap_notify_dock, ap);
 		}
 
 		for (j = 0; j < ata_link_max_devices(&ap->link); j++) {
@@ -264,7 +327,7 @@ void ata_acpi_associate(struct ata_host *host)
 						ata_acpi_dev_notify, dev);
 				/* we might be on a docking station */
 				register_hotplug_dock_device(dev->acpi_handle,
-						ata_acpi_dev_notify, dev);
+					     ata_acpi_dev_notify_dock, dev);
 			}
 		}
 	}
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 3c2d228..90d20c6 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -247,7 +247,7 @@ u8 ata_sff_check_status(struct ata_port *ap)
  *	LOCKING:
  *	Inherited from caller.
  */
-u8 ata_sff_altstatus(struct ata_port *ap)
+static u8 ata_sff_altstatus(struct ata_port *ap)
 {
 	if (ap->ops->sff_check_altstatus)
 		return ap->ops->sff_check_altstatus(ap);
@@ -256,6 +256,93 @@ u8 ata_sff_altstatus(struct ata_port *ap)
 }
 
 /**
+ *	ata_sff_irq_status - Check if the device is busy
+ *	@ap: port where the device is
+ *
+ *	Determine if the port is currently busy. Uses altstatus
+ *	if available in order to avoid clearing shared IRQ status
+ *	when finding an IRQ source. Non ctl capable devices don't
+ *	share interrupt lines fortunately for us.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+static u8 ata_sff_irq_status(struct ata_port *ap)
+{
+	u8 status;
+
+	if (ap->ops->sff_check_altstatus || ap->ioaddr.altstatus_addr) {
+		status = ata_sff_altstatus(ap);
+		/* Not us: We are busy */
+		if (status & ATA_BUSY)
+		    	return status;
+	}
+	/* Clear INTRQ latch */
+	status = ata_sff_check_status(ap);
+	return status;
+}
+
+/**
+ *	ata_sff_sync - Flush writes
+ *	@ap: Port to wait for.
+ *
+ *	CAUTION:
+ *	If we have an mmio device with no ctl and no altstatus
+ *	method this will fail. No such devices are known to exist.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+static void ata_sff_sync(struct ata_port *ap)
+{
+	if (ap->ops->sff_check_altstatus)
+		ap->ops->sff_check_altstatus(ap);
+	else if (ap->ioaddr.altstatus_addr)
+		ioread8(ap->ioaddr.altstatus_addr);
+}
+
+/**
+ *	ata_sff_pause		-	Flush writes and wait 400nS
+ *	@ap: Port to pause for.
+ *
+ *	CAUTION:
+ *	If we have an mmio device with no ctl and no altstatus
+ *	method this will fail. No such devices are known to exist.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+void ata_sff_pause(struct ata_port *ap)
+{
+	ata_sff_sync(ap);
+	ndelay(400);
+}
+
+/**
+ *	ata_sff_dma_pause	-	Pause before commencing DMA
+ *	@ap: Port to pause for.
+ *
+ *	Perform I/O fencing and ensure sufficient cycle delays occur
+ *	for the HDMA1:0 transition
+ */
+ 
+void ata_sff_dma_pause(struct ata_port *ap)
+{
+	if (ap->ops->sff_check_altstatus || ap->ioaddr.altstatus_addr) {
+		/* An altstatus read will cause the needed delay without
+		   messing up the IRQ status */
+		ata_sff_altstatus(ap);
+		return;
+	}
+	/* There are no DMA controllers without ctl. BUG here to ensure
+	   we never violate the HDMA1:0 transition timing and risk
+	   corruption. */
+	BUG();
+}
+
+/**
  *	ata_sff_busy_sleep - sleep until BSY clears, or timeout
  *	@ap: port containing status register to be polled
  *	@tmout_pat: impatience timeout
@@ -742,7 +829,7 @@ static void ata_pio_sectors(struct ata_queued_cmd *qc)
 	} else
 		ata_pio_sector(qc);
 
-	ata_sff_altstatus(qc->ap); /* flush */
+	ata_sff_sync(qc->ap); /* flush */
 }
 
 /**
@@ -763,8 +850,9 @@ static void atapi_send_cdb(struct ata_port *ap, struct ata_queued_cmd *qc)
 	WARN_ON(qc->dev->cdb_len < 12);
 
 	ap->ops->sff_data_xfer(qc->dev, qc->cdb, qc->dev->cdb_len, 1);
-	ata_sff_altstatus(ap); /* flush */
-
+	ata_sff_sync(ap);
+	/* FIXME: If the CDB is for DMA do we need to do the transition delay
+	   or is bmdma_start guaranteed to do it ? */
 	switch (qc->tf.protocol) {
 	case ATAPI_PROT_PIO:
 		ap->hsm_task_state = HSM_ST;
@@ -905,7 +993,7 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
 
 	if (unlikely(__atapi_pio_bytes(qc, bytes)))
 		goto err_out;
-	ata_sff_altstatus(ap); /* flush */
+	ata_sff_sync(ap); /* flush */
 
 	return;
 
@@ -1489,14 +1577,10 @@ inline unsigned int ata_sff_host_intr(struct ata_port *ap,
 		goto idle_irq;
 	}
 
-	/* check altstatus */
-	status = ata_sff_altstatus(ap);
-	if (status & ATA_BUSY)
-		goto idle_irq;
 
-	/* check main status, clearing INTRQ */
-	status = ap->ops->sff_check_status(ap);
-	if (unlikely(status & ATA_BUSY))
+	/* check main status, clearing INTRQ if needed */
+	status = ata_sff_irq_status(ap);
+	if (status & ATA_BUSY)
 		goto idle_irq;
 
 	/* ack bmdma irq events */
@@ -2030,7 +2114,7 @@ void ata_sff_error_handler(struct ata_port *ap)
 		ap->ops->bmdma_stop(qc);
 	}
 
-	ata_sff_altstatus(ap);
+	ata_sff_sync(ap);		/* FIXME: We don't need this */
 	ap->ops->sff_check_status(ap);
 	ap->ops->sff_irq_clear(ap);
 
@@ -2203,7 +2287,7 @@ void ata_bmdma_stop(struct ata_queued_cmd *qc)
 		 mmio + ATA_DMA_CMD);
 
 	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_sff_altstatus(ap);        /* dummy read */
+	ata_sff_dma_pause(ap);
 }
 
 /**
@@ -2722,7 +2806,8 @@ EXPORT_SYMBOL_GPL(ata_sff_qc_prep);
 EXPORT_SYMBOL_GPL(ata_sff_dumb_qc_prep);
 EXPORT_SYMBOL_GPL(ata_sff_dev_select);
 EXPORT_SYMBOL_GPL(ata_sff_check_status);
-EXPORT_SYMBOL_GPL(ata_sff_altstatus);
+EXPORT_SYMBOL_GPL(ata_sff_dma_pause);
+EXPORT_SYMBOL_GPL(ata_sff_pause);
 EXPORT_SYMBOL_GPL(ata_sff_busy_sleep);
 EXPORT_SYMBOL_GPL(ata_sff_wait_ready);
 EXPORT_SYMBOL_GPL(ata_sff_tf_load);
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 1713843..cf9e984 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -270,7 +270,7 @@ static void pata_icside_bmdma_stop(struct ata_queued_cmd *qc)
 	disable_dma(state->dma);
 
 	/* see ata_bmdma_stop */
-	ata_sff_altstatus(ap);
+	ata_sff_dma_pause(ap);
 }
 
 static u8 pata_icside_bmdma_status(struct ata_port *ap)
diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index a108d25..f8b3ffc 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -57,7 +57,9 @@ static inline void rb532_pata_finish_io(struct ata_port *ap)
 	struct ata_host *ah = ap->host;
 	struct rb532_cf_info *info = ah->private_data;
 
-	ata_sff_altstatus(ap);
+	/* FIXME: Keep previous delay. If this is merely a fence then
+	   ata_sff_sync might be sufficient. */
+	ata_sff_dma_pause(ap);
 	ndelay(RB500_CF_IO_DELAY);
 
 	set_irq_type(info->irq, IRQ_TYPE_LEVEL_HIGH);
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index e965b25..bbf5aa3 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -726,7 +726,7 @@ static void scc_bmdma_stop (struct ata_queued_cmd *qc)
 		 in_be32(bmid_base + SCC_DMA_CMD) & ~ATA_DMA_START);
 
 	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_sff_altstatus(ap);	/* dummy read */
+	ata_sff_dma_pause(ap);	/* dummy read */
 }
 
 /**
@@ -747,7 +747,8 @@ static u8 scc_bmdma_status (struct ata_port *ap)
 		return host_stat;
 
 	/* errata A252,A308 workaround: Step4 */
-	if ((ata_sff_altstatus(ap) & ATA_ERR) && (int_status & INTSTS_INTRQ))
+	if ((scc_check_altstatus(ap) & ATA_ERR)
+					&& (int_status & INTSTS_INTRQ))
 		return (host_stat | ATA_DMA_INTR);
 
 	/* errata A308 workaround Step5 */
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index acf347f..60391e9 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -224,6 +224,11 @@ enum {
 
 	PHY_MODE3		= 0x310,
 	PHY_MODE4		= 0x314,
+	PHY_MODE4_CFG_MASK	= 0x00000003,	/* phy internal config field */
+	PHY_MODE4_CFG_VALUE	= 0x00000001,	/* phy internal config field */
+	PHY_MODE4_RSVD_ZEROS	= 0x5de3fffa,	/* Gen2e always write zeros */
+	PHY_MODE4_RSVD_ONES	= 0x00000005,	/* Gen2e always write ones */
+
 	PHY_MODE2		= 0x330,
 	SATA_IFCTL_OFS		= 0x344,
 	SATA_TESTCTL_OFS	= 0x348,
@@ -2563,17 +2568,16 @@ static void mv6_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
 		m3 &= ~0x1c;
 
 	if (fix_phy_mode4) {
-		u32 m4;
-
-		m4 = readl(port_mmio + PHY_MODE4);
-
-		/* workaround for errata FEr SATA#10 (part 1) */
-		m4 = (m4 & ~(1 << 1)) | (1 << 0);
-
-		/* enforce bit restrictions on GenIIe devices */
+		u32 m4 = readl(port_mmio + PHY_MODE4);
+		/*
+		 * Enforce reserved-bit restrictions on GenIIe devices only.
+		 * For earlier chipsets, force only the internal config field
+		 *  (workaround for errata FEr SATA#10 part 1).
+		 */
 		if (IS_GEN_IIE(hpriv))
-			m4 = (m4 & ~0x5DE3FFFC) | (1 << 2);
-
+			m4 = (m4 & ~PHY_MODE4_RSVD_ZEROS) | PHY_MODE4_RSVD_ONES;
+		else
+			m4 = (m4 & ~PHY_MODE4_CFG_MASK) | PHY_MODE4_CFG_VALUE;
 		writel(m4, port_mmio + PHY_MODE4);
 	}
 	/*
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 4a92fba..e57e5d0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -111,13 +111,10 @@ enum {
 	/* various global constants */
 	LIBATA_MAX_PRD		= ATA_MAX_PRD / 2,
 	LIBATA_DUMB_MAX_PRD	= ATA_MAX_PRD / 4,	/* Worst case */
-	ATA_MAX_PORTS		= 8,
 	ATA_DEF_QUEUE		= 1,
 	/* tag ATA_MAX_QUEUE - 1 is reserved for internal commands */
 	ATA_MAX_QUEUE		= 32,
 	ATA_TAG_INTERNAL	= ATA_MAX_QUEUE - 1,
-	ATA_MAX_BUS		= 2,
-	ATA_DEF_BUSY_WAIT	= 10000,
 	ATA_SHORT_PAUSE		= (HZ >> 6) + 1,
 
 	ATAPI_MAX_DRAIN		= 16 << 10,
@@ -1435,7 +1432,8 @@ extern void ata_sff_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sff_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sff_dev_select(struct ata_port *ap, unsigned int device);
 extern u8 ata_sff_check_status(struct ata_port *ap);
-extern u8 ata_sff_altstatus(struct ata_port *ap);
+extern void ata_sff_pause(struct ata_port *ap);
+extern void ata_sff_dma_pause(struct ata_port *ap);
 extern int ata_sff_busy_sleep(struct ata_port *ap,
 			      unsigned long timeout_pat, unsigned long timeout);
 extern int ata_sff_wait_ready(struct ata_link *link, unsigned long deadline);
@@ -1496,19 +1494,6 @@ extern int ata_pci_sff_init_one(struct pci_dev *pdev,
 #endif /* CONFIG_PCI */
 
 /**
- *	ata_sff_pause - Flush writes and pause 400 nanoseconds.
- *	@ap: Port to wait for.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-static inline void ata_sff_pause(struct ata_port *ap)
-{
-	ata_sff_altstatus(ap);
-	ndelay(400);
-}
-
-/**
  *	ata_sff_busy_wait - Wait for a port status register
  *	@ap: Port to wait for.
  *	@bits: bits that must be clear

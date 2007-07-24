Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbXGXU43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbXGXU43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763325AbXGXU4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:56:11 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57627 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260AbXGXU4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:56:04 -0400
Date: Tue, 24 Jul 2007 16:56:02 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070724205602.GA17547@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c    |  113 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/ata/pata_ali.c    |    2 +-
 drivers/ata/pata_hpt37x.c |   14 +++---
 drivers/pci/pci.c         |    1 +
 drivers/pci/pci.h         |    1 -
 include/linux/libata.h    |    2 +
 include/linux/pci.h       |    1 +
 7 files changed, 123 insertions(+), 11 deletions(-)

Alan Cox (2):
      pata_ali: Correct HP detect
      pata_hpt37x: Fix 2.6.22 clock PLL regression

Tejun Heo (2):
      PCI: export __pci_reenable_device()
      ata_piix: fix suspend/resume for some TOSHIBA laptops

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index d9fa329..ad07086 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -91,6 +91,7 @@
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
+#include <linux/dmi.h>
 
 #define DRV_NAME	"ata_piix"
 #define DRV_VERSION	"2.11"
@@ -140,6 +141,9 @@ enum {
 	RV			= -3, /* reserved */
 
 	PIIX_AHCI_DEVICE	= 6,
+
+	/* host->flags bits */
+	PIIX_HOST_BROKEN_SUSPEND = (1 << 24),
 };
 
 struct piix_map_db {
@@ -159,6 +163,10 @@ static void piix_set_piomode (struct ata_port *ap, struct ata_device *adev);
 static void piix_set_dmamode (struct ata_port *ap, struct ata_device *adev);
 static void ich_set_dmamode (struct ata_port *ap, struct ata_device *adev);
 static int ich_pata_cable_detect(struct ata_port *ap);
+#ifdef CONFIG_PM
+static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
+static int piix_pci_device_resume(struct pci_dev *pdev);
+#endif
 
 static unsigned int in_module_init = 1;
 
@@ -255,8 +263,8 @@ static struct pci_driver piix_pci_driver = {
 	.probe			= piix_init_one,
 	.remove			= ata_pci_remove_one,
 #ifdef CONFIG_PM
-	.suspend		= ata_pci_device_suspend,
-	.resume			= ata_pci_device_resume,
+	.suspend		= piix_pci_device_suspend,
+	.resume			= piix_pci_device_resume,
 #endif
 };
 
@@ -881,6 +889,107 @@ static void ich_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	do_pata_set_dmamode(ap, adev, 1);
 }
 
+#ifdef CONFIG_PM
+static struct dmi_system_id piix_broken_suspend_dmi_table[] = {
+	{
+		.ident = "TECRA M5",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TECRA M5"),
+		},
+	},
+	{
+		.ident = "Satellite U200",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite U200"),
+		},
+	},
+	{
+		.ident = "Satellite U205",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite U205"),
+		},
+	},
+	{
+		.ident = "Portege M500",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE M500"),
+		},
+	},
+	{ }
+};
+
+static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	unsigned long flags;
+	int rc = 0;
+
+	rc = ata_host_suspend(host, mesg);
+	if (rc)
+		return rc;
+
+	/* Some braindamaged ACPI suspend implementations expect the
+	 * controller to be awake on entry; otherwise, it burns cpu
+	 * cycles and power trying to do something to the sleeping
+	 * beauty.
+	 */
+	if (dmi_check_system(piix_broken_suspend_dmi_table) &&
+	    mesg.event == PM_EVENT_SUSPEND) {
+		pci_save_state(pdev);
+
+		/* mark its power state as "unknown", since we don't
+		 * know if e.g. the BIOS will change its device state
+		 * when we suspend.
+		 */
+		if (pdev->current_state == PCI_D0)
+			pdev->current_state = PCI_UNKNOWN;
+
+		/* tell resume that it's waking up from broken suspend */
+		spin_lock_irqsave(&host->lock, flags);
+		host->flags |= PIIX_HOST_BROKEN_SUSPEND;
+		spin_unlock_irqrestore(&host->lock, flags);
+	} else
+		ata_pci_device_do_suspend(pdev, mesg);
+
+	return 0;
+}
+
+static int piix_pci_device_resume(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	unsigned long flags;
+	int rc;
+
+	if (host->flags & PIIX_HOST_BROKEN_SUSPEND) {
+		spin_lock_irqsave(&host->lock, flags);
+		host->flags &= ~PIIX_HOST_BROKEN_SUSPEND;
+		spin_unlock_irqrestore(&host->lock, flags);
+
+		pci_set_power_state(pdev, PCI_D0);
+		pci_restore_state(pdev);
+
+		/* PCI device wasn't disabled during suspend.  Use
+		 * __pci_reenable_device() to avoid affecting the
+		 * enable count.
+		 */
+		rc = __pci_reenable_device(pdev);
+		if (rc)
+			dev_printk(KERN_ERR, &pdev->dev, "failed to enable "
+				   "device after resume (%d)\n", rc);
+	} else
+		rc = ata_pci_device_do_resume(pdev);
+
+	if (rc == 0)
+		ata_host_resume(host);
+
+	return rc;
+}
+#endif
+
 #define AHCI_PCI_BAR 5
 #define AHCI_GLOBAL_CTL 0x04
 #define AHCI_ENABLE (1 << 31)
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 0104367..e8a28e9 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -45,7 +45,7 @@ static struct dmi_system_id cable_dmi_table[] = {
 		.ident = "HP Pavilion N5430",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_BOARD_NAME, "OmniBook N32N-736"),
+			DMI_MATCH(DMI_BOARD_VERSION, "OmniBook N32N-736"),
 		},
 	},
 	{ }
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index b0af65a..84d9c55 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -26,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.6"
+#define DRV_VERSION	"0.6.7"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -1103,17 +1103,17 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 
 		/* Select the DPLL clock. */
 		pci_write_config_byte(dev, 0x5b, 0x21);
-		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
+		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low | 0x100);
 
 		for(adjust = 0; adjust < 8; adjust++) {
 			if (hpt37x_calibrate_dpll(dev))
 				break;
 			/* See if it'll settle at a fractionally different clock */
-			if ((adjust & 3) == 3) {
-				f_low --;
-				f_high ++;
-			}
-			pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
+			if (adjust & 1)
+				f_low -= adjust >> 1;
+			else
+				f_high += adjust >> 1;
+			pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low | 0x100);
 		}
 		if (adjust == 8) {
 			printk(KERN_WARNING "hpt37x: DPLL did not stabilize.\n");
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 03fd59e..c954853 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1604,6 +1604,7 @@ early_param("pci", pci_setup);
 device_initcall(pci_init);
 
 EXPORT_SYMBOL_GPL(pci_restore_bars);
+EXPORT_SYMBOL(__pci_reenable_device);
 EXPORT_SYMBOL(pci_enable_device_bars);
 EXPORT_SYMBOL(pci_enable_device);
 EXPORT_SYMBOL(pcim_enable_device);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 3fec13d..7b696cd 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1,6 +1,5 @@
 /* Functions internal to the PCI core code */
 
-extern int __must_check __pci_reenable_device(struct pci_dev *);
 extern int pci_uevent(struct device *dev, char **envp, int num_envp,
 		      char *buffer, int buffer_size);
 extern int pci_create_sysfs_dev_files(struct pci_dev *pdev);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 9aa6c10..41978a5 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -216,6 +216,8 @@ enum {
 	ATA_HOST_SIMPLEX	= (1 << 0),	/* Host is simplex, one DMA channel per host only */
 	ATA_HOST_STARTED	= (1 << 1),	/* Host started */
 
+	/* bits 24:31 of host->flags are reserved for LLD specific flags */
+
 	/* various lengths of time */
 	ATA_TMOUT_BOOT		= 30 * HZ,	/* heuristic */
 	ATA_TMOUT_BOOT_QUICK	= 7 * HZ,	/* heuristic */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5e84f2e..d8f8a3a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -534,6 +534,7 @@ static inline int pci_write_config_dword(struct pci_dev *dev, int where, u32 val
 
 int __must_check pci_enable_device(struct pci_dev *dev);
 int __must_check pci_enable_device_bars(struct pci_dev *dev, int mask);
+int __must_check __pci_reenable_device(struct pci_dev *);
 int __must_check pcim_enable_device(struct pci_dev *pdev);
 void pcim_pin_device(struct pci_dev *pdev);
 

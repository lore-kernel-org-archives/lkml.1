Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbXERBiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbXERBiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 21:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbXERBiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 21:38:09 -0400
Received: from havoc.gtf.org ([69.61.125.42]:36385 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031AbXERBiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 21:38:07 -0400
Date: Thu, 17 May 2007 21:38:05 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070518013805.GA4673@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Main thing of note: still sorting out the shutdown mess.  See the
extended commit texts for more info.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 Documentation/feature-removal-schedule.txt |   25 ++++++++++++-------------
 drivers/ata/libata-core.c                  |    6 ------
 drivers/ata/libata-scsi.c                  |    9 ++++-----
 drivers/ata/libata.h                       |    1 -
 drivers/ata/sata_nv.c                      |   18 +-----------------
 drivers/ata/sata_via.c                     |    2 +-
 6 files changed, 18 insertions(+), 43 deletions(-)

Peer Chen (1):
      drivers/ata: remove the wildcard from sata_nv driver

Tejun Heo (3):
      sata_nv: fix fallout of devres conversion
      libata: remove libata.spindown_compat
      sata_via: pcim_iomap_regions() conversion missed BAR5

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 498ff31..5c8695a 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -328,21 +328,20 @@ Who:   Adrian Bunk <bunk@stusta.de>
 
 ---------------------------
 
-What: libata.spindown_compat module parameter
+What: libata spindown skipping and warning
 When: Dec 2008
-Why:  halt(8) synchronizes caches for and spins down libata disks
-      because libata didn't use to spin down disk on system halt
-      (only synchronized caches).
-      Spin down on system halt is now implemented and can be tested
-      using sysfs node /sys/class/scsi_disk/h:c:i:l/manage_start_stop.
+Why:  Some halt(8) implementations synchronize caches for and spin
+      down libata disks because libata didn't use to spin down disk on
+      system halt (only synchronized caches).
+      Spin down on system halt is now implemented.  sysfs node
+      /sys/class/scsi_disk/h:c:i:l/manage_start_stop is present if
+      spin down support is available.
       Because issuing spin down command to an already spun down disk
-      makes some disks spin up just to spin down again, the old
-      behavior needs to be maintained till userspace tool is updated
-      to check the sysfs node and not to spin down disks with the
-      node set to one.
-      This module parameter is to give userspace tool the time to
-      get updated and should be removed after userspace is
-      reasonably updated.
+      makes some disks spin up just to spin down again, libata tracks
+      device spindown status to skip the extra spindown command and
+      warn about it.
+      This is to give userspace tools the time to get updated and will
+      be removed after userspace is reasonably updated.
 Who:  Tejun Heo <htejun@gmail.com>
 
 ---------------------------
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d5939e6..d3ea7f5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -101,12 +101,6 @@ int libata_noacpi = 1;
 module_param_named(noacpi, libata_noacpi, int, 0444);
 MODULE_PARM_DESC(noacpi, "Disables the use of ACPI in suspend/resume when set");
 
-int ata_spindown_compat = 1;
-module_param_named(spindown_compat, ata_spindown_compat, int, 0644);
-MODULE_PARM_DESC(spindown_compat, "Enable backward compatible spindown "
-		 "behavior.  Will be removed.  More info can be found in "
-		 "Documentation/feature-removal-schedule.txt\n");
-
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Library module for ATA devices");
 MODULE_LICENSE("GPL");
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b6a1de8..242c43e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -893,7 +893,7 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 	return queue_depth;
 }
 
-/* XXX: for ata_spindown_compat */
+/* XXX: for spindown warning */
 static void ata_delayed_done_timerfn(unsigned long arg)
 {
 	struct scsi_cmnd *scmd = (void *)arg;
@@ -901,7 +901,7 @@ static void ata_delayed_done_timerfn(unsigned long arg)
 	scmd->scsi_done(scmd);
 }
 
-/* XXX: for ata_spindown_compat */
+/* XXX: for spindown warning */
 static void ata_delayed_done(struct scsi_cmnd *scmd)
 {
 	static struct timer_list timer;
@@ -966,8 +966,7 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 		 * removed.  Read Documentation/feature-removal-schedule.txt
 		 * for more info.
 		 */
-		if (ata_spindown_compat &&
-		    (qc->dev->flags & ATA_DFLAG_SPUNDOWN) &&
+		if ((qc->dev->flags & ATA_DFLAG_SPUNDOWN) &&
 		    (system_state == SYSTEM_HALT ||
 		     system_state == SYSTEM_POWER_OFF)) {
 			static unsigned long warned = 0;
@@ -1395,7 +1394,7 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 		}
 	}
 
-	/* XXX: track spindown state for spindown_compat */
+	/* XXX: track spindown state for spindown skipping and warning */
 	if (unlikely(qc->tf.command == ATA_CMD_STANDBY ||
 		     qc->tf.command == ATA_CMD_STANDBYNOW1))
 		qc->dev->flags |= ATA_DFLAG_SPUNDOWN;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 13cb0c9..5e24666 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -58,7 +58,6 @@ extern int atapi_enabled;
 extern int atapi_dmadir;
 extern int libata_fua;
 extern int libata_noacpi;
-extern int ata_spindown_compat;
 extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev);
 extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 4cea3ef..1a49c77 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -229,7 +229,6 @@ struct nv_host_priv {
 #define NV_ADMA_CHECK_INTR(GCTL, PORT) ((GCTL) & ( 1 << (19 + (12 * (PORT)))))
 
 static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
-static void nv_remove_one (struct pci_dev *pdev);
 #ifdef CONFIG_PM
 static int nv_pci_device_resume(struct pci_dev *pdev);
 #endif
@@ -288,12 +287,6 @@ static const struct pci_device_id nv_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), GENERIC },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
-		PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_IDE<<8, 0xffff00, GENERIC },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
-		PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_RAID<<8, 0xffff00, GENERIC },
 
 	{ } /* terminate list */
 };
@@ -306,7 +299,7 @@ static struct pci_driver nv_pci_driver = {
 	.suspend		= ata_pci_device_suspend,
 	.resume			= nv_pci_device_resume,
 #endif
-	.remove			= nv_remove_one,
+	.remove			= ata_pci_remove_one,
 };
 
 static struct scsi_host_template nv_sht = {
@@ -1613,15 +1606,6 @@ static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 				 IRQF_SHARED, ppi[0]->sht);
 }
 
-static void nv_remove_one (struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	struct nv_host_priv *hpriv = host->private_data;
-
-	ata_pci_remove_one(pdev);
-	kfree(hpriv);
-}
-
 #ifdef CONFIG_PM
 static int nv_pci_device_resume(struct pci_dev *pdev)
 {
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index d105d2c..ac4f43c 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -441,7 +441,7 @@ static int vt6421_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
 		return -ENOMEM;
 	}
 
-	rc = pcim_iomap_regions(pdev, 0x1f, DRV_NAME);
+	rc = pcim_iomap_regions(pdev, 0x3f, DRV_NAME);
 	if (rc) {
 		dev_printk(KERN_ERR, &pdev->dev, "failed to request/iomap "
 			   "PCI BARs (errno=%d)\n", rc);

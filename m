Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbXC1HcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbXC1HcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 03:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXC1HcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 03:32:25 -0400
Received: from havoc.gtf.org ([69.61.125.42]:45841 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbXC1HcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 03:32:21 -0400
Date: Wed, 28 Mar 2007 03:32:19 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070328073219.GA26024@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This disables libata ACPI, among other things.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c              |   21 +++++++++++-
 drivers/ata/libata-acpi.c       |    8 ++--
 drivers/ata/libata-core.c       |    6 ++-
 drivers/ata/libata-eh.c         |   66 ++++++++++++++++++++++++--------------
 drivers/ata/libata.h            |    2 +-
 drivers/ata/pata_pdc202xx_old.c |    2 +-
 6 files changed, 71 insertions(+), 34 deletions(-)

Alan Cox (1):
      pata_pdc202xx_old: LBA48 bug

Conke Hu (1):
      ahci.c: walkaround for SB600 SATA internal error issue

Jeff Garzik (1):
      [libata] Disable ACPI by default; fix namespace problems

Paul Rolland (1):
      ata: NCQ is broken on Maxtor 6L250S0

Tejun Heo (1):
      libata: IDENTIFY backwards for drive side cable detection

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index dc7b562..fd27227 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -80,6 +80,7 @@ enum {
 	board_ahci_pi		= 1,
 	board_ahci_vt8251	= 2,
 	board_ahci_ign_iferr	= 3,
+	board_ahci_sb600	= 4,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -168,6 +169,7 @@ enum {
 	AHCI_FLAG_NO_NCQ		= (1 << 24),
 	AHCI_FLAG_IGN_IRQ_IF_ERR	= (1 << 25), /* ignore IRQ_IF_ERR */
 	AHCI_FLAG_HONOR_PI		= (1 << 26), /* honor PORTS_IMPL */
+	AHCI_FLAG_IGN_SERR_INTERNAL	= (1 << 27), /* ignore SERR_INTERNAL */
 };
 
 struct ahci_cmd_hdr {
@@ -362,6 +364,18 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
 		.port_ops	= &ahci_ops,
 	},
+	/* board_ahci_sb600 */
+	{
+		.sht		= &ahci_sht,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+				  ATA_FLAG_SKIP_D2H_BSY |
+				  AHCI_FLAG_IGN_SERR_INTERNAL,
+		.pio_mask	= 0x1f, /* pio0-4 */
+		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.port_ops	= &ahci_ops,
+	},
+
 };
 
 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -399,7 +413,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },
 
 	/* ATI */
-	{ PCI_VDEVICE(ATI, 0x4380), board_ahci }, /* ATI SB600 non-raid */
+	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 non-raid */
 	{ PCI_VDEVICE(ATI, 0x4381), board_ahci }, /* ATI SB600 raid */
 
 	/* VIA */
@@ -1067,8 +1081,11 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 	if (ap->flags & AHCI_FLAG_IGN_IRQ_IF_ERR)
 		irq_stat &= ~PORT_IRQ_IF_ERR;
 
-	if (irq_stat & PORT_IRQ_TF_ERR)
+	if (irq_stat & PORT_IRQ_TF_ERR) {
 		err_mask |= AC_ERR_DEV;
+		if (ap->flags & AHCI_FLAG_IGN_SERR_INTERNAL)
+			serror &= ~SERR_INTERNAL;
+	}
 
 	if (irq_stat & (PORT_IRQ_HBUS_ERR | PORT_IRQ_HBUS_DATA_ERR)) {
 		err_mask |= AC_ERR_HOST_BUS;
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index c428a56..03a0acf 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -305,7 +305,7 @@ static int do_drive_get_GTF(struct ata_port *ap, int ix,
 	*gtf_address = 0UL;
 	*obj_loc = 0UL;
 
-	if (noacpi)
+	if (libata_noacpi)
 		return 0;
 
 	if (ata_msg_probe(ap))
@@ -531,7 +531,7 @@ static int do_drive_set_taskfiles(struct ata_port *ap,
 		ata_dev_printk(atadev, KERN_DEBUG, "%s: ENTER: port#: %d\n",
 			       __FUNCTION__, ap->port_no);
 
-	if (noacpi || !(ap->cbl == ATA_CBL_SATA))
+	if (libata_noacpi || !(ap->cbl == ATA_CBL_SATA))
 		return 0;
 
 	if (!ata_dev_enabled(atadev) || (ap->flags & ATA_FLAG_DISABLED))
@@ -574,7 +574,7 @@ int ata_acpi_exec_tfs(struct ata_port *ap)
 	unsigned long	gtf_address;
 	unsigned long	obj_loc;
 
-	if (noacpi)
+	if (libata_noacpi)
 		return 0;
 	/*
 	 * TBD - implement PATA support.  For now,
@@ -636,7 +636,7 @@ int ata_acpi_push_id(struct ata_port *ap, unsigned int ix)
 	struct acpi_object_list         input;
 	union acpi_object               in_params[1];
 
-	if (noacpi)
+	if (libata_noacpi)
 		return 0;
 
 	if (ata_msg_probe(ap))
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index bf327d4..f1f595f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -93,8 +93,8 @@ static int ata_probe_timeout = ATA_TMOUT_INTERNAL / HZ;
 module_param(ata_probe_timeout, int, 0444);
 MODULE_PARM_DESC(ata_probe_timeout, "Set ATA probing timeout (seconds)");
 
-int noacpi;
-module_param(noacpi, int, 0444);
+int libata_noacpi = 1;
+module_param_named(noacpi, libata_noacpi, int, 0444);
 MODULE_PARM_DESC(noacpi, "Disables the use of ACPI in suspend/resume when set");
 
 MODULE_AUTHOR("Jeff Garzik");
@@ -3359,6 +3359,8 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
         { "WDC WD740ADFD-00",   NULL,		ATA_HORKAGE_NONCQ },
 	/* http://thread.gmane.org/gmane.linux.ide/14907 */
 	{ "FUJITSU MHT2060BH",	NULL,		ATA_HORKAGE_NONCQ },
+	/* NCQ is broken */
+	{ "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
 
 	/* Devices with NCQ limits */
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 361953a..c89664a 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1743,12 +1743,17 @@ static int ata_eh_revalidate_and_attach(struct ata_port *ap,
 {
 	struct ata_eh_context *ehc = &ap->eh_context;
 	struct ata_device *dev;
+	unsigned int new_mask = 0;
 	unsigned long flags;
 	int i, rc = 0;
 
 	DPRINTK("ENTER\n");
 
-	for (i = 0; i < ATA_MAX_DEVICES; i++) {
+	/* For PATA drive side cable detection to work, IDENTIFY must
+	 * be done backwards such that PDIAG- is released by the slave
+	 * device before the master device is identified.
+	 */
+	for (i = ATA_MAX_DEVICES - 1; i >= 0; i--) {
 		unsigned int action, readid_flags = 0;
 
 		dev = &ap->device[i];
@@ -1760,13 +1765,13 @@ static int ata_eh_revalidate_and_attach(struct ata_port *ap,
 		if (action & ATA_EH_REVALIDATE && ata_dev_ready(dev)) {
 			if (ata_port_offline(ap)) {
 				rc = -EIO;
-				break;
+				goto err;
 			}
 
 			ata_eh_about_to_do(ap, dev, ATA_EH_REVALIDATE);
 			rc = ata_dev_revalidate(dev, readid_flags);
 			if (rc)
-				break;
+				goto err;
 
 			ata_eh_done(ap, dev, ATA_EH_REVALIDATE);
 
@@ -1784,40 +1789,53 @@ static int ata_eh_revalidate_and_attach(struct ata_port *ap,
 
 			rc = ata_dev_read_id(dev, &dev->class, readid_flags,
 					     dev->id);
-			if (rc == 0) {
-				ehc->i.flags |= ATA_EHI_PRINTINFO;
-				rc = ata_dev_configure(dev);
-				ehc->i.flags &= ~ATA_EHI_PRINTINFO;
-			} else if (rc == -ENOENT) {
+			switch (rc) {
+			case 0:
+				new_mask |= 1 << i;
+				break;
+			case -ENOENT:
 				/* IDENTIFY was issued to non-existent
 				 * device.  No need to reset.  Just
 				 * thaw and kill the device.
 				 */
 				ata_eh_thaw_port(ap);
 				dev->class = ATA_DEV_UNKNOWN;
-				rc = 0;
-			}
-
-			if (rc) {
-				dev->class = ATA_DEV_UNKNOWN;
 				break;
+			default:
+				dev->class = ATA_DEV_UNKNOWN;
+				goto err;
 			}
+		}
+	}
 
-			if (ata_dev_enabled(dev)) {
-				spin_lock_irqsave(ap->lock, flags);
-				ap->pflags |= ATA_PFLAG_SCSI_HOTPLUG;
-				spin_unlock_irqrestore(ap->lock, flags);
+	/* Configure new devices forward such that user doesn't see
+	 * device detection messages backwards.
+	 */
+	for (i = 0; i < ATA_MAX_DEVICES; i++) {
+		dev = &ap->device[i];
 
-				/* new device discovered, configure xfermode */
-				ehc->i.flags |= ATA_EHI_SETMODE;
-			}
-		}
+		if (!(new_mask & (1 << i)))
+			continue;
+
+		ehc->i.flags |= ATA_EHI_PRINTINFO;
+		rc = ata_dev_configure(dev);
+		ehc->i.flags &= ~ATA_EHI_PRINTINFO;
+		if (rc)
+			goto err;
+
+		spin_lock_irqsave(ap->lock, flags);
+		ap->pflags |= ATA_PFLAG_SCSI_HOTPLUG;
+		spin_unlock_irqrestore(ap->lock, flags);
+
+		/* new device discovered, configure xfermode */
+		ehc->i.flags |= ATA_EHI_SETMODE;
 	}
 
-	if (rc)
-		*r_failed_dev = dev;
+	return 0;
 
-	DPRINTK("EXIT\n");
+ err:
+	*r_failed_dev = dev;
+	DPRINTK("EXIT rc=%d\n", rc);
 	return rc;
 }
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index c426714..1f1e3a5 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -56,7 +56,7 @@ extern struct workqueue_struct *ata_aux_wq;
 extern int atapi_enabled;
 extern int atapi_dmadir;
 extern int libata_fua;
-extern int noacpi;
+extern int libata_noacpi;
 extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev);
 extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index acdc52c..0a14933 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -195,7 +195,7 @@ static void pdc2026x_bmdma_start(struct ata_queued_cmd *qc)
 	/* Cases the state machine will not complete correctly without help */
 	if ((tf->flags & ATA_TFLAG_LBA48) ||  tf->protocol == ATA_PROT_ATAPI_DMA)
 	{
-		len = qc->nbytes;
+		len = qc->nbytes / 2;
 
 		if (tf->flags & ATA_TFLAG_WRITE)
 			len |= 0x06000000;

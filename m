Return-Path: <linux-kernel-owner+w=401wt.eu-S1761808AbZDQXIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808AbZDQXIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZDQXHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:07:51 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42381 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbZDQXHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 19:07:50 -0400
Date: Fri, 17 Apr 2009 19:07:49 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090417230749.GA24506@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I accidentally pulled the trigger too soon on Alan's 32-bit PIO ioctl
patch, leading to build breakage.  This fixes that, plus some other
minor fixes.


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/pata_legacy.c |   13 ++++----
 drivers/ata/pata_via.c    |   74 ++++++++++++++++++++++++++++++++++++++++----
 drivers/ata/sata_mv.c     |   58 +++++++++++++++++++++++++++++------
 3 files changed, 122 insertions(+), 23 deletions(-)

Alan Cox (1):
      pata_via: Cache and rewrite the device bit

Mark Lord (2):
      sata_mv: tidy up qc->tf usage in qc_prep() functions
      sata_mv: workaround for multi_count errata sata24

Zhenwen Xu (1):
      [libata] fix build error on drivers/ata/pata_legacy.c

diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 6f985be..f72c6c5 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -285,10 +285,11 @@ static unsigned int pdc_data_xfer_vlb(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw)
 {
 	int slop = buflen & 3;
+	struct ata_port *ap = dev->link->ap;
+
 	/* 32bit I/O capable *and* we need to write a whole number of dwords */
 	if (ata_id_has_dword_io(dev->id) && (slop == 0 || slop == 3)
 					&& (ap->pflags & ATA_PFLAG_PIO32)) {
-		struct ata_port *ap = dev->link->ap;
 		unsigned long flags;
 
 		local_irq_save(flags);
@@ -866,7 +867,7 @@ static struct legacy_controller controllers[] = {
 			0,			0,			NULL },
 	{"PDC20230",	&pdc20230_port_ops,	0x7,
 			ATA_FLAG_NO_IORDY,
-			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE,	NULL },
+			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,	NULL },
 	{"HT6560A",	&ht6560a_port_ops,	0x07,
 			ATA_FLAG_NO_IORDY,	0,			NULL },
 	{"HT6560B",	&ht6560b_port_ops,	0x1F,
@@ -877,13 +878,13 @@ static struct legacy_controller controllers[] = {
 			0,			0,			NULL },
 	{"QDI6500",	&qdi6500_port_ops,	0x07,
 			ATA_FLAG_NO_IORDY,
-			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE,    qdi_port },
+			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,    qdi_port },
 	{"QDI6580",	&qdi6580_port_ops,	0x1F,
-			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE, qdi_port },
+			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE, qdi_port },
 	{"QDI6580DP",	&qdi6580dp_port_ops,	0x1F,
-			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE, qdi_port },
+			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE, qdi_port },
 	{"W83759A",	&winbond_port_ops,	0x1F,
-			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE,
+			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,
 								winbond_port }
 };
 
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index b08e6e0..45657ca 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -62,7 +62,7 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME "pata_via"
-#define DRV_VERSION "0.3.3"
+#define DRV_VERSION "0.3.4"
 
 /*
  *	The following comes directly from Vojtech Pavlik's ide/pci/via82cxxx
@@ -136,6 +136,9 @@ static const struct via_isa_bridge {
 	{ NULL }
 };
 
+struct via_port {
+	u8 cached_device;
+};
 
 /*
  *	Cable special cases
@@ -346,14 +349,70 @@ static void via_set_dmamode(struct ata_port *ap, struct ata_device *adev)
  */
 static void via_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 {
-	struct ata_taskfile tmp_tf;
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	struct via_port *vp = ap->private_data;
+	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;
+	int newctl = 0;
+
+	if (tf->ctl != ap->last_ctl) {
+		iowrite8(tf->ctl, ioaddr->ctl_addr);
+		ap->last_ctl = tf->ctl;
+		ata_wait_idle(ap);
+		newctl = 1;
+	}
+
+	if (tf->flags & ATA_TFLAG_DEVICE) {
+		iowrite8(tf->device, ioaddr->device_addr);
+		vp->cached_device = tf->device;
+	} else if (newctl)
+		iowrite8(vp->cached_device, ioaddr->device_addr);
+
+	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
+		WARN_ON_ONCE(!ioaddr->ctl_addr);
+		iowrite8(tf->hob_feature, ioaddr->feature_addr);
+		iowrite8(tf->hob_nsect, ioaddr->nsect_addr);
+		iowrite8(tf->hob_lbal, ioaddr->lbal_addr);
+		iowrite8(tf->hob_lbam, ioaddr->lbam_addr);
+		iowrite8(tf->hob_lbah, ioaddr->lbah_addr);
+		VPRINTK("hob: feat 0x%X nsect 0x%X, lba 0x%X 0x%X 0x%X\n",
+			tf->hob_feature,
+			tf->hob_nsect,
+			tf->hob_lbal,
+			tf->hob_lbam,
+			tf->hob_lbah);
+	}
 
-	if (ap->ctl != ap->last_ctl && !(tf->flags & ATA_TFLAG_DEVICE)) {
-		tmp_tf = *tf;
-		tmp_tf.flags |= ATA_TFLAG_DEVICE;
-		tf = &tmp_tf;
+	if (is_addr) {
+		iowrite8(tf->feature, ioaddr->feature_addr);
+		iowrite8(tf->nsect, ioaddr->nsect_addr);
+		iowrite8(tf->lbal, ioaddr->lbal_addr);
+		iowrite8(tf->lbam, ioaddr->lbam_addr);
+		iowrite8(tf->lbah, ioaddr->lbah_addr);
+		VPRINTK("feat 0x%X nsect 0x%X lba 0x%X 0x%X 0x%X\n",
+			tf->feature,
+			tf->nsect,
+			tf->lbal,
+			tf->lbam,
+			tf->lbah);
 	}
-	ata_sff_tf_load(ap, tf);
+
+	ata_wait_idle(ap);
+}
+
+static int via_port_start(struct ata_port *ap)
+{
+	struct via_port *vp;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	int ret = ata_sff_port_start(ap);
+	if (ret < 0)
+		return ret;
+
+	vp = devm_kzalloc(&pdev->dev, sizeof(struct via_port), GFP_KERNEL);
+	if (vp == NULL)
+		return -ENOMEM;
+	ap->private_data = vp;
+	return 0;
 }
 
 static struct scsi_host_template via_sht = {
@@ -367,6 +426,7 @@ static struct ata_port_operations via_port_ops = {
 	.set_dmamode	= via_set_dmamode,
 	.prereset	= via_pre_reset,
 	.sff_tf_load	= via_tf_load,
+	.port_start	= via_port_start,
 };
 
 static struct ata_port_operations via_port_ops_noirq = {
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 37ae5dc..870dcfd 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1881,6 +1881,39 @@ static u8 mv_bmdma_status(struct ata_port *ap)
 	return status;
 }
 
+static void mv_rw_multi_errata_sata24(struct ata_queued_cmd *qc)
+{
+	struct ata_taskfile *tf = &qc->tf;
+	/*
+	 * Workaround for 88SX60x1 FEr SATA#24.
+	 *
+	 * Chip may corrupt WRITEs if multi_count >= 4kB.
+	 * Note that READs are unaffected.
+	 *
+	 * It's not clear if this errata really means "4K bytes",
+	 * or if it always happens for multi_count > 7
+	 * regardless of device sector_size.
+	 *
+	 * So, for safety, any write with multi_count > 7
+	 * gets converted here into a regular PIO write instead:
+	 */
+	if ((tf->flags & ATA_TFLAG_WRITE) && is_multi_taskfile(tf)) {
+		if (qc->dev->multi_count > 7) {
+			switch (tf->command) {
+			case ATA_CMD_WRITE_MULTI:
+				tf->command = ATA_CMD_PIO_WRITE;
+				break;
+			case ATA_CMD_WRITE_MULTI_FUA_EXT:
+				tf->flags &= ~ATA_TFLAG_FUA; /* ugh */
+				/* fall through */
+			case ATA_CMD_WRITE_MULTI_EXT:
+				tf->command = ATA_CMD_PIO_WRITE_EXT;
+				break;
+			}
+		}
+	}
+}
+
 /**
  *      mv_qc_prep - Host specific command preparation.
  *      @qc: queued command to prepare
@@ -1898,17 +1931,24 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	struct mv_port_priv *pp = ap->private_data;
 	__le16 *cw;
-	struct ata_taskfile *tf;
+	struct ata_taskfile *tf = &qc->tf;
 	u16 flags = 0;
 	unsigned in_index;
 
-	if ((qc->tf.protocol != ATA_PROT_DMA) &&
-	    (qc->tf.protocol != ATA_PROT_NCQ))
+	switch (tf->protocol) {
+	case ATA_PROT_DMA:
+	case ATA_PROT_NCQ:
+		break;	/* continue below */
+	case ATA_PROT_PIO:
+		mv_rw_multi_errata_sata24(qc);
+		return;
+	default:
 		return;
+	}
 
 	/* Fill in command request block
 	 */
-	if (!(qc->tf.flags & ATA_TFLAG_WRITE))
+	if (!(tf->flags & ATA_TFLAG_WRITE))
 		flags |= CRQB_FLAG_READ;
 	WARN_ON(MV_MAX_Q_DEPTH <= qc->tag);
 	flags |= qc->tag << CRQB_TAG_SHIFT;
@@ -1924,7 +1964,6 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 	pp->crqb[in_index].ctrl_flags = cpu_to_le16(flags);
 
 	cw = &pp->crqb[in_index].ata_cmd[0];
-	tf = &qc->tf;
 
 	/* Sadly, the CRQB cannot accomodate all registers--there are
 	 * only 11 bytes...so we must pick and choose required
@@ -1990,16 +2029,16 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	struct mv_port_priv *pp = ap->private_data;
 	struct mv_crqb_iie *crqb;
-	struct ata_taskfile *tf;
+	struct ata_taskfile *tf = &qc->tf;
 	unsigned in_index;
 	u32 flags = 0;
 
-	if ((qc->tf.protocol != ATA_PROT_DMA) &&
-	    (qc->tf.protocol != ATA_PROT_NCQ))
+	if ((tf->protocol != ATA_PROT_DMA) &&
+	    (tf->protocol != ATA_PROT_NCQ))
 		return;
 
 	/* Fill in Gen IIE command request block */
-	if (!(qc->tf.flags & ATA_TFLAG_WRITE))
+	if (!(tf->flags & ATA_TFLAG_WRITE))
 		flags |= CRQB_FLAG_READ;
 
 	WARN_ON(MV_MAX_Q_DEPTH <= qc->tag);
@@ -2015,7 +2054,6 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
 	crqb->addr_hi = cpu_to_le32((pp->sg_tbl_dma[qc->tag] >> 16) >> 16);
 	crqb->flags = cpu_to_le32(flags);
 
-	tf = &qc->tf;
 	crqb->ata_cmd[0] = cpu_to_le32(
 			(tf->command << 16) |
 			(tf->feature << 24)

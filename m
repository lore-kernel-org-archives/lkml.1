Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYE3WNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYE3WNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYE3WNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:13:25 -0400
Received: from havoc.gtf.org ([69.61.125.42]:54469 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYE3WNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:13:22 -0400
Date: Fri, 30 May 2008 18:13:21 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080530221321.GA26211@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |    8 +-
 drivers/ata/ata_piix.c    |    7 +-
 drivers/ata/libata-core.c |    2 +-
 drivers/ata/libata-pmp.c  |    7 +-
 drivers/ata/libata-scsi.c |    3 +-
 drivers/ata/sata_fsl.c    |  224 ++++++++++++++++++++++++++++++++------------
 drivers/ata/sata_mv.c     |   83 ++++++++---------
 7 files changed, 217 insertions(+), 117 deletions(-)

Ashish Kalra (1):
      [libata] sata_fsl: Fix broken driver, add port multiplier (PMP) support

Mark Lord (5):
      sata_mv: move SOC_FLAG to hpriv
      sata_mv: PHY_MODEx errata fixes
      sata_mv: nuke unreleased GenIIe revisions
      sata_mv: workaround for 60x1 errata sata13
      sata_mv: implement SoC guideline SATA_S11

Pradeep Singh Rautela (1):
      ata: Convert to static DEFINE_SPINLOCK(lock)

Randy Dunlap (1):
      libata: fix libata-scsi kernel-doc notation

Tejun Heo (2):
      ata_piix: fix macbook ich8m problems
      libata: SRST can't be trusted on PMP sil3726

peerchen (1):
      ahci: change the Device IDs of nvidia MCP7B AHCI controller in ahci.c

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 97f83fb..544b7d6 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -502,10 +502,10 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, 0x0bcd), board_ahci },		/* MCP7B */
 	{ PCI_VDEVICE(NVIDIA, 0x0bce), board_ahci },		/* MCP7B */
 	{ PCI_VDEVICE(NVIDIA, 0x0bcf), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bd0), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bd1), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bd2), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bd3), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc4), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc5), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc6), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc7), board_ahci },		/* MCP7B */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci }, /* SiS 966 */
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index a9027b8..3548ee7 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -247,10 +247,11 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x2820, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller 2 IDE (ICH8) */
 	{ 0x8086, 0x2825, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
-	/* Mobile SATA Controller IDE (ICH8M) */
-	{ 0x8086, 0x2828, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* Mobile SATA Controller IDE (ICH8M), Apple */
 	{ 0x8086, 0x2828, 0x106b, 0x00a0, 0, 0, ich8m_apple_sata },
+	{ 0x8086, 0x2828, 0x106b, 0x00a1, 0, 0, ich8m_apple_sata },
+	/* Mobile SATA Controller IDE (ICH8M) */
+	{ 0x8086, 0x2828, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller IDE (ICH9) */
 	{ 0x8086, 0x2920, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller IDE (ICH9) */
@@ -526,7 +527,7 @@ static struct ata_port_info piix_port_info[] = {
 
 	[ich8m_apple_sata] =
 	{
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR,
+		.flags		= PIIX_SATA_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3c89f20..cc816ca 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5403,7 +5403,7 @@ static void ata_host_stop(struct device *gendev, void *res)
  */
 static void ata_finalize_port_ops(struct ata_port_operations *ops)
 {
-	static spinlock_t lock = SPIN_LOCK_UNLOCKED;
+	static DEFINE_SPINLOCK(lock);
 	const struct ata_port_operations *cur;
 	void **begin = (void **)ops;
 	void **end = (void **)&ops->inherits;
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 0f9386d..7daf4c0 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -322,9 +322,12 @@ static void sata_pmp_quirks(struct ata_port *ap)
 	if (vendor == 0x1095 && devid == 0x3726) {
 		/* sil3726 quirks */
 		ata_port_for_each_link(link, ap) {
-			/* class code report is unreliable */
+			/* Class code report is unreliable and SRST
+			 * times out under certain configurations.
+			 */
 			if (link->pmp < 5)
-				link->flags |= ATA_LFLAG_ASSUME_ATA;
+				link->flags |= ATA_LFLAG_NO_SRST |
+					       ATA_LFLAG_ASSUME_ATA;
 
 			/* port 5 is for SEMB device and it doesn't like SRST */
 			if (link->pmp == 5)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index aeb6e01..2e6e162 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1637,6 +1637,7 @@ defer:
 
 /**
  *	ata_scsi_rbuf_get - Map response buffer.
+ *	@cmd: SCSI command containing buffer to be mapped.
  *	@flags: unsigned long variable to store irq enable status
  *	@copy_in: copy in from user buffer
  *
@@ -1954,7 +1955,7 @@ static unsigned int ata_msense_ctl_mode(u8 *buf)
 
 /**
  *	ata_msense_rw_recovery - Simulate MODE SENSE r/w error recovery page
- *	@bufp: output buffer
+ *	@buf: output buffer
  *
  *	Generate a generic MODE SENSE r/w error recovery page.
  *
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 853559e..3924e72 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -34,7 +34,7 @@ enum {
 
 	SATA_FSL_HOST_FLAGS	= (ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-				ATA_FLAG_NCQ),
+				ATA_FLAG_PMP | ATA_FLAG_NCQ),
 
 	SATA_FSL_MAX_CMDS	= SATA_FSL_QUEUE_DEPTH,
 	SATA_FSL_CMD_HDR_SIZE	= 16,	/* 4 DWORDS */
@@ -395,7 +395,7 @@ static void sata_fsl_qc_prep(struct ata_queued_cmd *qc)
 	cd = (struct command_desc *)pp->cmdentry + tag;
 	cd_paddr = pp->cmdentry_paddr + tag * SATA_FSL_CMD_DESC_SIZE;
 
-	ata_tf_to_fis(&qc->tf, 0, 1, (u8 *) &cd->cfis);
+	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, (u8 *) &cd->cfis);
 
 	VPRINTK("Dumping cfis : 0x%x, 0x%x, 0x%x\n",
 		cd->cfis[0], cd->cfis[1], cd->cfis[2]);
@@ -438,6 +438,8 @@ static unsigned int sata_fsl_qc_issue(struct ata_queued_cmd *qc)
 		ioread32(CA + hcr_base),
 		ioread32(CE + hcr_base), ioread32(CC + hcr_base));
 
+	iowrite32(qc->dev->link->pmp, CQPMP + hcr_base);
+
 	/* Simply queue command to the controller/device */
 	iowrite32(1 << tag, CQ + hcr_base);
 
@@ -558,11 +560,36 @@ static void sata_fsl_thaw(struct ata_port *ap)
 		ioread32(hcr_base + HCONTROL), ioread32(hcr_base + HSTATUS));
 }
 
+static void sata_fsl_pmp_attach(struct ata_port *ap)
+{
+	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
+	void __iomem *hcr_base = host_priv->hcr_base;
+	u32 temp;
+
+	temp = ioread32(hcr_base + HCONTROL);
+	iowrite32((temp | HCONTROL_PMP_ATTACHED), hcr_base + HCONTROL);
+}
+
+static void sata_fsl_pmp_detach(struct ata_port *ap)
+{
+	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
+	void __iomem *hcr_base = host_priv->hcr_base;
+	u32 temp;
+
+	temp = ioread32(hcr_base + HCONTROL);
+	temp &= ~HCONTROL_PMP_ATTACHED;
+	iowrite32(temp, hcr_base + HCONTROL);
+
+	/* enable interrupts on the controller/port */
+	temp = ioread32(hcr_base + HCONTROL);
+	iowrite32((temp | DEFAULT_PORT_IRQ_ENABLE_MASK), hcr_base + HCONTROL);
+
+}
+
 static int sata_fsl_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->host->dev;
 	struct sata_fsl_port_priv *pp;
-	int retval;
 	void *mem;
 	dma_addr_t mem_dma;
 	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
@@ -688,12 +715,13 @@ static int sata_fsl_prereset(struct ata_link *link, unsigned long deadline)
 }
 
 static int sata_fsl_softreset(struct ata_link *link, unsigned int *class,
-			      unsigned long deadline)
+					unsigned long deadline)
 {
 	struct ata_port *ap = link->ap;
 	struct sata_fsl_port_priv *pp = ap->private_data;
 	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
 	void __iomem *hcr_base = host_priv->hcr_base;
+	int pmp = sata_srst_pmp(link);
 	u32 temp;
 	struct ata_taskfile tf;
 	u8 *cfis;
@@ -703,6 +731,9 @@ static int sata_fsl_softreset(struct ata_link *link, unsigned int *class,
 
 	DPRINTK("in xx_softreset\n");
 
+	if (pmp != SATA_PMP_CTRL_PORT)
+		goto issue_srst;
+
 try_offline_again:
 	/*
 	 * Force host controller to go off-line, aborting current operations
@@ -746,6 +777,7 @@ try_offline_again:
 
 	temp = ioread32(hcr_base + HCONTROL);
 	temp |= (HCONTROL_ONLINE_PHY_RST | HCONTROL_SNOOP_ENABLE);
+	temp |= HCONTROL_PMP_ATTACHED;
 	iowrite32(temp, hcr_base + HCONTROL);
 
 	temp = ata_wait_register(hcr_base + HSTATUS, ONLINE, 0, 1, 500);
@@ -771,7 +803,8 @@ try_offline_again:
 		ata_port_printk(ap, KERN_WARNING,
 				"No Device OR PHYRDY change,Hstatus = 0x%x\n",
 				ioread32(hcr_base + HSTATUS));
-		goto err;
+		*class = ATA_DEV_NONE;
+		goto out;
 	}
 
 	/*
@@ -783,7 +816,8 @@ try_offline_again:
 
 	if ((temp & 0xFF) != 0x18) {
 		ata_port_printk(ap, KERN_WARNING, "No Signature Update\n");
-		goto err;
+		*class = ATA_DEV_NONE;
+		goto out;
 	} else {
 		ata_port_printk(ap, KERN_INFO,
 				"Signature Update detected @ %d msecs\n",
@@ -798,6 +832,7 @@ try_offline_again:
 	 * reached here, we can send a command to the target device
 	 */
 
+issue_srst:
 	DPRINTK("Sending SRST/device reset\n");
 
 	ata_tf_init(link->device, &tf);
@@ -808,7 +843,7 @@ try_offline_again:
 				     SRST_CMD | CMD_DESC_SNOOP_ENABLE, 0, 0, 5);
 
 	tf.ctl |= ATA_SRST;	/* setup SRST bit in taskfile control reg */
-	ata_tf_to_fis(&tf, 0, 0, cfis);
+	ata_tf_to_fis(&tf, pmp, 0, cfis);
 
 	DPRINTK("Dumping cfis : 0x%x, 0x%x, 0x%x, 0x%x\n",
 		cfis[0], cfis[1], cfis[2], cfis[3]);
@@ -854,8 +889,10 @@ try_offline_again:
 	sata_fsl_setup_cmd_hdr_entry(pp, 0, CMD_DESC_SNOOP_ENABLE, 0, 0, 5);
 
 	tf.ctl &= ~ATA_SRST;	/* 2nd H2D Ctl. register FIS */
-	ata_tf_to_fis(&tf, 0, 0, cfis);
+	ata_tf_to_fis(&tf, pmp, 0, cfis);
 
+	if (pmp != SATA_PMP_CTRL_PORT)
+		iowrite32(pmp, CQPMP + hcr_base);
 	iowrite32(1, CQ + hcr_base);
 	msleep(150);		/* ?? */
 
@@ -886,12 +923,21 @@ try_offline_again:
 		VPRINTK("cereg = 0x%x\n", ioread32(hcr_base + CE));
 	}
 
+out:
 	return 0;
 
 err:
 	return -EIO;
 }
 
+static void sata_fsl_error_handler(struct ata_port *ap)
+{
+
+	DPRINTK("in xx_error_handler\n");
+	sata_pmp_error_handler(ap);
+
+}
+
 static void sata_fsl_post_internal_cmd(struct ata_queued_cmd *qc)
 {
 	if (qc->flags & ATA_QCFLAG_FAILED)
@@ -905,18 +951,21 @@ static void sata_fsl_post_internal_cmd(struct ata_queued_cmd *qc)
 
 static void sata_fsl_error_intr(struct ata_port *ap)
 {
-	struct ata_link *link = &ap->link;
-	struct ata_eh_info *ehi = &link->eh_info;
 	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
 	void __iomem *hcr_base = host_priv->hcr_base;
-	u32 hstatus, dereg, cereg = 0, SError = 0;
+	u32 hstatus, dereg=0, cereg = 0, SError = 0;
 	unsigned int err_mask = 0, action = 0;
-	struct ata_queued_cmd *qc;
-	int freeze = 0;
+	int freeze = 0, abort=0;
+	struct ata_link *link = NULL;
+	struct ata_queued_cmd *qc = NULL;
+	struct ata_eh_info *ehi;
 
 	hstatus = ioread32(hcr_base + HSTATUS);
 	cereg = ioread32(hcr_base + CE);
 
+	/* first, analyze and record host port events */
+	link = &ap->link;
+	ehi = &link->eh_info;
 	ata_ehi_clear_desc(ehi);
 
 	/*
@@ -926,42 +975,28 @@ static void sata_fsl_error_intr(struct ata_port *ap)
 	sata_fsl_scr_read(ap, SCR_ERROR, &SError);
 	if (unlikely(SError & 0xFFFF0000)) {
 		sata_fsl_scr_write(ap, SCR_ERROR, SError);
-		err_mask |= AC_ERR_ATA_BUS;
 	}
 
 	DPRINTK("error_intr,hStat=0x%x,CE=0x%x,DE =0x%x,SErr=0x%x\n",
 		hstatus, cereg, ioread32(hcr_base + DE), SError);
 
-	/* handle single device errors */
-	if (cereg) {
-		/*
-		 * clear the command error, also clears queue to the device
-		 * in error, and we can (re)issue commands to this device.
-		 * When a device is in error all commands queued into the
-		 * host controller and at the device are considered aborted
-		 * and the queue for that device is stopped. Now, after
-		 * clearing the device error, we can issue commands to the
-		 * device to interrogate it to find the source of the error.
-		 */
-		dereg = ioread32(hcr_base + DE);
-		iowrite32(dereg, hcr_base + DE);
-		iowrite32(cereg, hcr_base + CE);
+	/* handle fatal errors */
+	if (hstatus & FATAL_ERROR_DECODE) {
+		ehi->err_mask |= AC_ERR_ATA_BUS;
+		ehi->action |= ATA_EH_SOFTRESET;
 
-		DPRINTK("single device error, CE=0x%x, DE=0x%x\n",
-			ioread32(hcr_base + CE), ioread32(hcr_base + DE));
 		/*
-		 * We should consider this as non fatal error, and TF must
-		 * be updated as done below.
+		 * Ignore serror in case of fatal errors as we always want
+		 * to do a soft-reset of the FSL SATA controller. Analyzing
+		 * serror may cause libata to schedule a hard-reset action,
+		 * and hard-reset currently does not do controller
+		 * offline/online, causing command timeouts and leads to an
+		 * un-recoverable state, hence make libATA ignore
+		 * autopsy in case of fatal errors.
 		 */
 
-		err_mask |= AC_ERR_DEV;
-	}
+		ehi->flags |= ATA_EHI_NO_AUTOPSY;
 
-	/* handle fatal errors */
-	if (hstatus & FATAL_ERROR_DECODE) {
-		err_mask |= AC_ERR_ATA_BUS;
-		action |= ATA_EH_RESET;
-		/* how will fatal error interrupts be completed ?? */
 		freeze = 1;
 	}
 
@@ -971,30 +1006,83 @@ static void sata_fsl_error_intr(struct ata_port *ap)
 
 		/* Setup a soft-reset EH action */
 		ata_ehi_hotplugged(ehi);
+		ata_ehi_push_desc(ehi, "%s", "PHY RDY changed");
 		freeze = 1;
 	}
 
-	/* record error info */
-	qc = ata_qc_from_tag(ap, link->active_tag);
+	/* handle single device errors */
+	if (cereg) {
+		/*
+		 * clear the command error, also clears queue to the device
+		 * in error, and we can (re)issue commands to this device.
+		 * When a device is in error all commands queued into the
+		 * host controller and at the device are considered aborted
+		 * and the queue for that device is stopped. Now, after
+		 * clearing the device error, we can issue commands to the
+		 * device to interrogate it to find the source of the error.
+		 */
+		abort = 1;
+
+		DPRINTK("single device error, CE=0x%x, DE=0x%x\n",
+			ioread32(hcr_base + CE), ioread32(hcr_base + DE));
 
-	if (qc)
+		/* find out the offending link and qc */
+		if (ap->nr_pmp_links) {
+			dereg = ioread32(hcr_base + DE);
+			iowrite32(dereg, hcr_base + DE);
+			iowrite32(cereg, hcr_base + CE);
+
+			if (dereg < ap->nr_pmp_links) {
+				link = &ap->pmp_link[dereg];
+				ehi = &link->eh_info;
+				qc = ata_qc_from_tag(ap, link->active_tag);
+				/*
+				 * We should consider this as non fatal error,
+                                 * and TF must be updated as done below.
+		                 */
+
+				err_mask |= AC_ERR_DEV;
+
+			} else {
+				err_mask |= AC_ERR_HSM;
+				action |= ATA_EH_HARDRESET;
+				freeze = 1;
+			}
+		} else {
+			dereg = ioread32(hcr_base + DE);
+			iowrite32(dereg, hcr_base + DE);
+			iowrite32(cereg, hcr_base + CE);
+
+			qc = ata_qc_from_tag(ap, link->active_tag);
+			/*
+			 * We should consider this as non fatal error,
+                         * and TF must be updated as done below.
+	                */
+			err_mask |= AC_ERR_DEV;
+		}
+	}
+
+	/* record error info */
+	if (qc) {
 		qc->err_mask |= err_mask;
-	else
+	} else
 		ehi->err_mask |= err_mask;
 
 	ehi->action |= action;
-	ehi->serror |= SError;
 
 	/* freeze or abort */
 	if (freeze)
 		ata_port_freeze(ap);
-	else
-		ata_port_abort(ap);
+	else if (abort) {
+		if (qc)
+			ata_link_abort(qc->dev->link);
+		else
+			ata_port_abort(ap);
+	}
 }
 
 static void sata_fsl_host_intr(struct ata_port *ap)
 {
-	struct ata_link *link = &ap->link;
 	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
 	void __iomem *hcr_base = host_priv->hcr_base;
 	u32 hstatus, qc_active = 0;
@@ -1017,10 +1105,19 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 		return;
 	}
 
-	if (link->sactive) {	/* only true for NCQ commands */
+	/* Read command completed register */
+	qc_active = ioread32(hcr_base + CC);
+
+	VPRINTK("Status of all queues :\n");
+	VPRINTK("qc_active/CC = 0x%x, CA = 0x%x, CE=0x%x,CQ=0x%x,apqa=0x%x\n",
+		qc_active,
+		ioread32(hcr_base + CA),
+		ioread32(hcr_base + CE),
+		ioread32(hcr_base + CQ),
+		ap->qc_active);
+
+	if (qc_active & ap->qc_active) {
 		int i;
-		/* Read command completed register */
-		qc_active = ioread32(hcr_base + CC);
 		/* clear CC bit, this will also complete the interrupt */
 		iowrite32(qc_active, hcr_base + CC);
 
@@ -1032,8 +1129,9 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 		for (i = 0; i < SATA_FSL_QUEUE_DEPTH; i++) {
 			if (qc_active & (1 << i)) {
 				qc = ata_qc_from_tag(ap, i);
-				if (qc)
+				if (qc) {
 					ata_qc_complete(qc);
+				}
 				DPRINTK
 				    ("completing ncq cmd,tag=%d,CC=0x%x,CA=0x%x\n",
 				     i, ioread32(hcr_base + CC),
@@ -1042,19 +1140,21 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 		}
 		return;
 
-	} else if (ap->qc_active) {
+	} else if ((ap->qc_active & (1 << ATA_TAG_INTERNAL))) {
 		iowrite32(1, hcr_base + CC);
-		qc = ata_qc_from_tag(ap, link->active_tag);
+		qc = ata_qc_from_tag(ap, ATA_TAG_INTERNAL);
 
-		DPRINTK("completing non-ncq cmd, tag=%d,CC=0x%x\n",
-			link->active_tag, ioread32(hcr_base + CC));
+		DPRINTK("completing non-ncq cmd, CC=0x%x\n",
+			 ioread32(hcr_base + CC));
 
-		if (qc)
+		if (qc) {
 			ata_qc_complete(qc);
+		}
 	} else {
 		/* Spurious Interrupt!! */
 		DPRINTK("spurious interrupt!!, CC = 0x%x\n",
 			ioread32(hcr_base + CC));
+		iowrite32(qc_active, hcr_base + CC);
 		return;
 	}
 }
@@ -1130,9 +1230,6 @@ static int sata_fsl_init_controller(struct ata_host *host)
 	iowrite32(0x00000FFFF, hcr_base + CE);
 	iowrite32(0x00000FFFF, hcr_base + DE);
 
-	/* initially assuming no Port multiplier, set CQPMP to 0 */
-	iowrite32(0x0, hcr_base + CQPMP);
-
 	/*
 	 * host controller will be brought on-line, during xx_port_start()
 	 * callback, that should also initiate the OOB, COMINIT sequence
@@ -1154,8 +1251,8 @@ static struct scsi_host_template sata_fsl_sht = {
 	.dma_boundary = ATA_DMA_BOUNDARY,
 };
 
-static const struct ata_port_operations sata_fsl_ops = {
-	.inherits = &sata_port_ops,
+static struct ata_port_operations sata_fsl_ops = {
+	.inherits		= &sata_pmp_port_ops,
 
 	.qc_prep = sata_fsl_qc_prep,
 	.qc_issue = sata_fsl_qc_issue,
@@ -1168,10 +1265,15 @@ static const struct ata_port_operations sata_fsl_ops = {
 	.thaw = sata_fsl_thaw,
 	.prereset = sata_fsl_prereset,
 	.softreset = sata_fsl_softreset,
+	.pmp_softreset = sata_fsl_softreset,
+	.error_handler = sata_fsl_error_handler,
 	.post_internal_cmd = sata_fsl_post_internal_cmd,
 
 	.port_start = sata_fsl_port_start,
 	.port_stop = sata_fsl_port_stop,
+
+	.pmp_attach = sata_fsl_pmp_attach,
+	.pmp_detach = sata_fsl_pmp_detach,
 };
 
 static const struct ata_port_info sata_fsl_port_info[] = {
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index fb81f0c..acf347f 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -72,7 +72,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_mv"
-#define DRV_VERSION	"1.21"
+#define DRV_VERSION	"1.24"
 
 enum {
 	/* BAR's are enumerated in terms of pci_resource_start() terms */
@@ -122,8 +122,6 @@ enum {
 	/* Host Flags */
 	MV_FLAG_DUAL_HC		= (1 << 30),  /* two SATA Host Controllers */
 	MV_FLAG_IRQ_COALESCE	= (1 << 29),  /* IRQ coalescing capability */
-	/* SoC integrated controllers, no PCI interface */
-	MV_FLAG_SOC		= (1 << 28),
 
 	MV_COMMON_FLAGS		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | ATA_FLAG_NO_ATAPI |
@@ -356,12 +354,12 @@ enum {
 	MV_HP_ERRATA_50XXB2	= (1 << 2),
 	MV_HP_ERRATA_60X1B2	= (1 << 3),
 	MV_HP_ERRATA_60X1C0	= (1 << 4),
-	MV_HP_ERRATA_XX42A0	= (1 << 5),
 	MV_HP_GEN_I		= (1 << 6),	/* Generation I: 50xx */
 	MV_HP_GEN_II		= (1 << 7),	/* Generation II: 60xx */
 	MV_HP_GEN_IIE		= (1 << 8),	/* Generation IIE: 6042/7042 */
 	MV_HP_PCIE		= (1 << 9),	/* PCIe bus/regs: 7042 */
 	MV_HP_CUT_THROUGH	= (1 << 10),	/* can use EDMA cut-through */
+	MV_HP_FLAG_SOC		= (1 << 11),	/* SystemOnChip, no PCI */
 
 	/* Port private flags (pp_flags) */
 	MV_PP_FLAG_EDMA_EN	= (1 << 0),	/* is EDMA engine enabled? */
@@ -374,7 +372,7 @@ enum {
 #define IS_GEN_II(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_II)
 #define IS_GEN_IIE(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_IIE)
 #define IS_PCIE(hpriv) ((hpriv)->hp_flags & MV_HP_PCIE)
-#define HAS_PCI(host) (!((host)->ports[0]->flags & MV_FLAG_SOC))
+#define IS_SOC(hpriv) ((hpriv)->hp_flags & MV_HP_FLAG_SOC)
 
 #define WINDOW_CTRL(i)		(0x20030 + ((i) << 4))
 #define WINDOW_BASE(i)		(0x20034 + ((i) << 4))
@@ -652,7 +650,7 @@ static const struct ata_port_info mv_port_info[] = {
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_soc */
-		.flags		= MV_GENIIE_FLAGS | MV_FLAG_SOC,
+		.flags		= MV_GENIIE_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
@@ -812,12 +810,7 @@ static void mv_set_edma_ptrs(void __iomem *port_mmio,
 	writel((pp->crqb_dma >> 16) >> 16, port_mmio + EDMA_REQ_Q_BASE_HI_OFS);
 	writelfl((pp->crqb_dma & EDMA_REQ_Q_BASE_LO_MASK) | index,
 		 port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
-
-	if (hpriv->hp_flags & MV_HP_ERRATA_XX42A0)
-		writelfl((pp->crqb_dma & 0xffffffff) | index,
-			 port_mmio + EDMA_REQ_Q_OUT_PTR_OFS);
-	else
-		writelfl(index, port_mmio + EDMA_REQ_Q_OUT_PTR_OFS);
+	writelfl(index, port_mmio + EDMA_REQ_Q_OUT_PTR_OFS);
 
 	/*
 	 * initialize response queue
@@ -827,13 +820,7 @@ static void mv_set_edma_ptrs(void __iomem *port_mmio,
 
 	WARN_ON(pp->crpb_dma & 0xff);
 	writel((pp->crpb_dma >> 16) >> 16, port_mmio + EDMA_RSP_Q_BASE_HI_OFS);
-
-	if (hpriv->hp_flags & MV_HP_ERRATA_XX42A0)
-		writelfl((pp->crpb_dma & 0xffffffff) | index,
-			 port_mmio + EDMA_RSP_Q_IN_PTR_OFS);
-	else
-		writelfl(index, port_mmio + EDMA_RSP_Q_IN_PTR_OFS);
-
+	writelfl(index, port_mmio + EDMA_RSP_Q_IN_PTR_OFS);
 	writelfl((pp->crpb_dma & EDMA_RSP_Q_BASE_LO_MASK) | index,
 		 port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
 }
@@ -1254,7 +1241,7 @@ static void mv_edma_cfg(struct ata_port *ap, int want_ncq)
 
 		cfg |= (1 << 23);	/* do not mask PM field in rx'd FIS */
 		cfg |= (1 << 22);	/* enab 4-entry host queue cache */
-		if (HAS_PCI(ap->host))
+		if (!IS_SOC(hpriv))
 			cfg |= (1 << 18);	/* enab early completion */
 		if (hpriv->hp_flags & MV_HP_CUT_THROUGH)
 			cfg |= (1 << 17); /* enab cut-thru (dis stor&forwrd) */
@@ -2225,7 +2212,7 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 	 * a bogus register value which can indicate HW removal or PCI fault.
 	 */
 	if (pending_irqs && main_irq_cause != 0xffffffffU) {
-		if (unlikely((pending_irqs & PCI_ERR) && HAS_PCI(host)))
+		if (unlikely((pending_irqs & PCI_ERR) && !IS_SOC(hpriv)))
 			handled = mv_pci_error(host, hpriv->base);
 		else
 			handled = mv_host_intr(host, pending_irqs);
@@ -2547,7 +2534,7 @@ static void mv6_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
 		hp_flags & (MV_HP_ERRATA_60X1B2 | MV_HP_ERRATA_60X1C0);
 	int fix_phy_mode4 =
 		hp_flags & (MV_HP_ERRATA_60X1B2 | MV_HP_ERRATA_60X1C0);
-	u32 m2, tmp;
+	u32 m2, m3;
 
 	if (fix_phy_mode2) {
 		m2 = readl(port_mmio + PHY_MODE2);
@@ -2564,28 +2551,37 @@ static void mv6_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
 		udelay(200);
 	}
 
-	/* who knows what this magic does */
-	tmp = readl(port_mmio + PHY_MODE3);
-	tmp &= ~0x7F800000;
-	tmp |= 0x2A800000;
-	writel(tmp, port_mmio + PHY_MODE3);
+	/*
+	 * Gen-II/IIe PHY_MODE3 errata RM#2:
+	 * Achieves better receiver noise performance than the h/w default:
+	 */
+	m3 = readl(port_mmio + PHY_MODE3);
+	m3 = (m3 & 0x1f) | (0x5555601 << 5);
+
+	/* Guideline 88F5182 (GL# SATA-S11) */
+	if (IS_SOC(hpriv))
+		m3 &= ~0x1c;
 
 	if (fix_phy_mode4) {
 		u32 m4;
 
 		m4 = readl(port_mmio + PHY_MODE4);
 
-		if (hp_flags & MV_HP_ERRATA_60X1B2)
-			tmp = readl(port_mmio + PHY_MODE3);
-
 		/* workaround for errata FEr SATA#10 (part 1) */
 		m4 = (m4 & ~(1 << 1)) | (1 << 0);
 
-		writel(m4, port_mmio + PHY_MODE4);
+		/* enforce bit restrictions on GenIIe devices */
+		if (IS_GEN_IIE(hpriv))
+			m4 = (m4 & ~0x5DE3FFFC) | (1 << 2);
 
-		if (hp_flags & MV_HP_ERRATA_60X1B2)
-			writel(tmp, port_mmio + PHY_MODE3);
+		writel(m4, port_mmio + PHY_MODE4);
 	}
+	/*
+	 * Workaround for 60x1-B2 errata SATA#13:
+	 * Any write to PHY_MODE4 (above) may corrupt PHY_MODE3,
+	 * so we must always rewrite PHY_MODE3 after PHY_MODE4.
+	 */
+	writel(m3, port_mmio + PHY_MODE3);
 
 	/* Revert values of pre-emphasis and signal amps to the saved ones */
 	m2 = readl(port_mmio + PHY_MODE2);
@@ -2876,7 +2872,7 @@ static unsigned int mv_in_pcix_mode(struct ata_host *host)
 	void __iomem *mmio = hpriv->base;
 	u32 reg;
 
-	if (!HAS_PCI(host) || !IS_PCIE(hpriv))
+	if (IS_SOC(hpriv) || !IS_PCIE(hpriv))
 		return 0;	/* not PCI-X capable */
 	reg = readl(mmio + MV_PCI_MODE_OFS);
 	if ((reg & MV_PCI_MODE_MASK) == 0)
@@ -3003,10 +2999,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 			hp_flags |= MV_HP_CUT_THROUGH;
 
 		switch (pdev->revision) {
-		case 0x0:
-			hp_flags |= MV_HP_ERRATA_XX42A0;
-			break;
-		case 0x1:
+		case 0x2: /* Rev.B0: the first/only public release */
 			hp_flags |= MV_HP_ERRATA_60X1C0;
 			break;
 		default:
@@ -3018,7 +3011,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 		break;
 	case chip_soc:
 		hpriv->ops = &mv_soc_ops;
-		hp_flags |= MV_HP_ERRATA_60X1C0;
+		hp_flags |= MV_HP_FLAG_SOC | MV_HP_ERRATA_60X1C0;
 		break;
 
 	default:
@@ -3062,12 +3055,12 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 	if (rc)
 		goto done;
 
-	if (HAS_PCI(host)) {
-		hpriv->main_irq_cause_addr = mmio + PCI_HC_MAIN_IRQ_CAUSE_OFS;
-		hpriv->main_irq_mask_addr  = mmio + PCI_HC_MAIN_IRQ_MASK_OFS;
-	} else {
+	if (IS_SOC(hpriv)) {
 		hpriv->main_irq_cause_addr = mmio + SOC_HC_MAIN_IRQ_CAUSE_OFS;
 		hpriv->main_irq_mask_addr  = mmio + SOC_HC_MAIN_IRQ_MASK_OFS;
+	} else {
+		hpriv->main_irq_cause_addr = mmio + PCI_HC_MAIN_IRQ_CAUSE_OFS;
+		hpriv->main_irq_mask_addr  = mmio + PCI_HC_MAIN_IRQ_MASK_OFS;
 	}
 
 	/* global interrupt mask: 0 == mask everything */
@@ -3093,7 +3086,7 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 		mv_port_init(&ap->ioaddr, port_mmio);
 
 #ifdef CONFIG_PCI
-		if (HAS_PCI(host)) {
+		if (!IS_SOC(hpriv)) {
 			unsigned int offset = port_mmio - mmio;
 			ata_port_pbar_desc(ap, MV_PRIMARY_BAR, -1, "mmio");
 			ata_port_pbar_desc(ap, MV_PRIMARY_BAR, offset, "port");
@@ -3113,7 +3106,7 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 		writelfl(0, hc_mmio + HC_IRQ_CAUSE_OFS);
 	}
 
-	if (HAS_PCI(host)) {
+	if (!IS_SOC(hpriv)) {
 		/* Clear any currently outstanding host interrupt conditions */
 		writelfl(0, mmio + hpriv->irq_cause_ofs);
 

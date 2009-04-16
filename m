Return-Path: <linux-kernel-owner+w=401wt.eu-S1758375AbZDPTj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbZDPTj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 15:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758372AbZDPTj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 15:39:28 -0400
Received: from havoc.gtf.org ([69.61.125.42]:44792 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785AbZDPTj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 15:39:26 -0400
Date: Thu, 16 Apr 2009 15:39:24 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090416193924.GA27823@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Various minor fixes, and a small libata.h cleanup.

Alan's fix is mildly notable because we missed a userland-visible
change:  when 32-bit PIO data xfer support was merged
(871af1210f13966ab911ed2166e4ab2ce775b99d), the userland ioctl reporting
and controlling 32-bit PIO remained hardcoded to 16-bit.

This is an old and increasingly irrelevant feature, so application
impact is likely none-to-minimal...  you couldn't change from the
hardcoded 16-bit PIO prior to Alan's change, which guaranteed that no
one ever tried :)

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c  |   25 ++++++++++++++++++++-----
 drivers/ata/libata-scsi.c  |   30 ++++++++++++++++++++++++++----
 drivers/ata/libata-sff.c   |   27 +++++++++++++++++++++++++++
 drivers/ata/pata_hpt37x.c  |   22 ++--------------------
 drivers/ata/pata_legacy.c  |   34 +++++++++++++++++++++-------------
 drivers/ata/pata_ninja32.c |    4 +++-
 include/linux/libata.h     |    8 ++++++++
 7 files changed, 107 insertions(+), 43 deletions(-)

Alan Cox (1):
      ata: Report 16/32bit PIO as best we can

Sergei Shtylyov (2):
      pata_hpt37x: fix HPT370 DMA timeouts
      libata: use ATA_ID_CFA_*

Tejun Heo (2):
      libata: handle SEMB signature better
      pata_legacy: fix no device fail path

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 065507c..17c5d48 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1231,6 +1231,9 @@ unsigned int ata_dev_classify(const struct ata_taskfile *tf)
 	 *
 	 * We follow the current spec and consider that 0x69/0x96
 	 * identifies a port multiplier and 0x3c/0xc3 a SEMB device.
+	 * Unfortunately, WDC WD1600JS-62MHB5 (a hard drive) reports
+	 * SEMB signature.  This is worked around in
+	 * ata_dev_read_id().
 	 */
 	if ((tf->lbam == 0) && (tf->lbah == 0)) {
 		DPRINTK("found ATA device by sig\n");
@@ -1248,8 +1251,8 @@ unsigned int ata_dev_classify(const struct ata_taskfile *tf)
 	}
 
 	if ((tf->lbam == 0x3c) && (tf->lbah == 0xc3)) {
-		printk(KERN_INFO "ata: SEMB device ignored\n");
-		return ATA_DEV_SEMB_UNSUP; /* not yet */
+		DPRINTK("found SEMB device by sig (could be ATA device)\n");
+		return ATA_DEV_SEMB;
 	}
 
 	DPRINTK("unknown device\n");
@@ -1653,8 +1656,8 @@ unsigned long ata_id_xfermask(const u16 *id)
 		/*
 		 *	Process compact flash extended modes
 		 */
-		int pio = id[163] & 0x7;
-		int dma = (id[163] >> 3) & 7;
+		int pio = (id[ATA_ID_CFA_MODES] >> 0) & 0x7;
+		int dma = (id[ATA_ID_CFA_MODES] >> 3) & 0x7;
 
 		if (pio)
 			pio_mask |= (1 << 5);
@@ -2080,6 +2083,7 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 	struct ata_taskfile tf;
 	unsigned int err_mask = 0;
 	const char *reason;
+	bool is_semb = class == ATA_DEV_SEMB;
 	int may_fallback = 1, tried_spinup = 0;
 	int rc;
 
@@ -2090,6 +2094,8 @@ retry:
 	ata_tf_init(dev, &tf);
 
 	switch (class) {
+	case ATA_DEV_SEMB:
+		class = ATA_DEV_ATA;	/* some hard drives report SEMB sig */
 	case ATA_DEV_ATA:
 		tf.command = ATA_CMD_ID_ATA;
 		break;
@@ -2126,6 +2132,14 @@ retry:
 			return -ENOENT;
 		}
 
+		if (is_semb) {
+			ata_dev_printk(dev, KERN_INFO, "IDENTIFY failed on "
+				       "device w/ SEMB sig, disabled\n");
+			/* SEMB is not supported yet */
+			*p_class = ATA_DEV_SEMB_UNSUP;
+			return 0;
+		}
+
 		if ((err_mask == AC_ERR_DEV) && (tf.feature & ATA_ABORTED)) {
 			/* Device or controller might have reported
 			 * the wrong device class.  Give a shot at the
@@ -2412,7 +2426,8 @@ int ata_dev_configure(struct ata_device *dev)
 	/* ATA-specific feature tests */
 	if (dev->class == ATA_DEV_ATA) {
 		if (ata_id_is_cfa(id)) {
-			if (id[162] & 1) /* CPRM may make this media unusable */
+			/* CPRM may make this media unusable */
+			if (id[ATA_ID_CFA_KEY_MGMT] & 1)
 				ata_dev_printk(dev, KERN_WARNING,
 					       "supports DRM functions and may "
 					       "not be fully accessable.\n");
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9747fa..2733b0c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -647,23 +647,45 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	return rc;
 }
 
+static int ata_ioc32(struct ata_port *ap)
+{
+	if (ap->flags & ATA_FLAG_PIO_DMA)
+		return 1;
+	if (ap->pflags & ATA_PFLAG_PIO32)
+		return 1;
+	return 0;
+}
+
 int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *scsidev,
 		     int cmd, void __user *arg)
 {
 	int val = -EINVAL, rc = -EINVAL;
+	unsigned long flags;
 
 	switch (cmd) {
 	case ATA_IOC_GET_IO32:
-		val = 0;
+		spin_lock_irqsave(ap->lock, flags);
+		val = ata_ioc32(ap);
+		spin_unlock_irqrestore(ap->lock, flags);
 		if (copy_to_user(arg, &val, 1))
 			return -EFAULT;
 		return 0;
 
 	case ATA_IOC_SET_IO32:
 		val = (unsigned long) arg;
-		if (val != 0)
-			return -EINVAL;
-		return 0;
+		rc = 0;
+		spin_lock_irqsave(ap->lock, flags);
+		if (ap->pflags & ATA_PFLAG_PIO32CHANGE) {
+			if (val)
+				ap->pflags |= ATA_PFLAG_PIO32;
+			else
+				ap->pflags &= ~ATA_PFLAG_PIO32;
+		} else {
+			if (val != ata_ioc32(ap))
+				rc = -EINVAL;
+		}
+		spin_unlock_irqrestore(ap->lock, flags);
+		return rc;
 
 	case HDIO_GET_IDENTITY:
 		return ata_get_identity(ap, scsidev, arg);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 8332e97..bb18415 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -87,6 +87,7 @@ const struct ata_port_operations ata_bmdma32_port_ops = {
 	.inherits		= &ata_bmdma_port_ops,
 
 	.sff_data_xfer		= ata_sff_data_xfer32,
+	.port_start		= ata_sff_port_start32,
 };
 EXPORT_SYMBOL_GPL(ata_bmdma32_port_ops);
 
@@ -769,6 +770,9 @@ unsigned int ata_sff_data_xfer32(struct ata_device *dev, unsigned char *buf,
 	void __iomem *data_addr = ap->ioaddr.data_addr;
 	unsigned int words = buflen >> 2;
 	int slop = buflen & 3;
+	
+	if (!(ap->pflags & ATA_PFLAG_PIO32))
+		return ata_sff_data_xfer(dev, buf, buflen, rw);
 
 	/* Transfer multiple of 4 bytes */
 	if (rw == READ)
@@ -2402,6 +2406,29 @@ int ata_sff_port_start(struct ata_port *ap)
 EXPORT_SYMBOL_GPL(ata_sff_port_start);
 
 /**
+ *	ata_sff_port_start32 - Set port up for dma.
+ *	@ap: Port to initialize
+ *
+ *	Called just after data structures for each port are
+ *	initialized.  Allocates space for PRD table if the device
+ *	is DMA capable SFF.
+ *
+ *	May be used as the port_start() entry in ata_port_operations for
+ *	devices that are capable of 32bit PIO.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+int ata_sff_port_start32(struct ata_port *ap)
+{
+	ap->pflags |= ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE;
+	if (ap->ioaddr.bmdma_addr)
+		return ata_port_start(ap);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ata_sff_port_start32);
+
+/**
  *	ata_sff_std_ports - initialize ioaddr with standard port offsets.
  *	@ioaddr: IO address structure to be initialized
  *
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 81ab570..122c786 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -8,7 +8,7 @@
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
- * Portions Copyright (C) 2005-2007	MontaVista Software, Inc.
+ * Portions Copyright (C) 2005-2009	MontaVista Software, Inc.
  *
  * TODO
  *	Look into engine reset on timeout errors. Should not be	required.
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.11"
+#define DRV_VERSION	"0.6.12"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -445,23 +445,6 @@ static void hpt370_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
- *	hpt370_bmdma_start		-	DMA engine begin
- *	@qc: ATA command
- *
- *	The 370 and 370A want us to reset the DMA engine each time we
- *	use it. The 372 and later are fine.
- */
-
-static void hpt370_bmdma_start(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
-	udelay(10);
-	ata_bmdma_start(qc);
-}
-
-/**
  *	hpt370_bmdma_end		-	DMA engine stop
  *	@qc: ATA command
  *
@@ -598,7 +581,6 @@ static struct scsi_host_template hpt37x_sht = {
 static struct ata_port_operations hpt370_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 
-	.bmdma_start 	= hpt370_bmdma_start,
 	.bmdma_stop	= hpt370_bmdma_stop,
 
 	.mode_filter	= hpt370_filter,
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 3f830f0..6f985be 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -108,6 +108,7 @@ struct legacy_controller {
 	struct ata_port_operations *ops;
 	unsigned int pio_mask;
 	unsigned int flags;
+	unsigned int pflags;
 	int (*setup)(struct platform_device *, struct legacy_probe *probe,
 		struct legacy_data *data);
 };
@@ -285,7 +286,8 @@ static unsigned int pdc_data_xfer_vlb(struct ata_device *dev,
 {
 	int slop = buflen & 3;
 	/* 32bit I/O capable *and* we need to write a whole number of dwords */
-	if (ata_id_has_dword_io(dev->id) && (slop == 0 || slop == 3)) {
+	if (ata_id_has_dword_io(dev->id) && (slop == 0 || slop == 3)
+					&& (ap->pflags & ATA_PFLAG_PIO32)) {
 		struct ata_port *ap = dev->link->ap;
 		unsigned long flags;
 
@@ -736,7 +738,8 @@ static unsigned int vlb32_data_xfer(struct ata_device *adev, unsigned char *buf,
 	struct ata_port *ap = adev->link->ap;
 	int slop = buflen & 3;
 
-	if (ata_id_has_dword_io(adev->id) && (slop == 0 || slop == 3)) {
+	if (ata_id_has_dword_io(adev->id) && (slop == 0 || slop == 3)
+					&& (ap->pflags & ATA_PFLAG_PIO32)) {
 		if (rw == WRITE)
 			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 		else
@@ -858,27 +861,30 @@ static struct ata_port_operations winbond_port_ops = {
 
 static struct legacy_controller controllers[] = {
 	{"BIOS",	&legacy_port_ops, 	0x1F,
-						ATA_FLAG_NO_IORDY,	NULL },
+			ATA_FLAG_NO_IORDY,	0,			NULL },
 	{"Snooping", 	&simple_port_ops, 	0x1F,
-						0	       ,	NULL },
+			0,			0,			NULL },
 	{"PDC20230",	&pdc20230_port_ops,	0x7,
-						ATA_FLAG_NO_IORDY,	NULL },
+			ATA_FLAG_NO_IORDY,
+			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE,	NULL },
 	{"HT6560A",	&ht6560a_port_ops,	0x07,
-						ATA_FLAG_NO_IORDY,	NULL },
+			ATA_FLAG_NO_IORDY,	0,			NULL },
 	{"HT6560B",	&ht6560b_port_ops,	0x1F,
-						ATA_FLAG_NO_IORDY,	NULL },
+			ATA_FLAG_NO_IORDY,	0,			NULL },
 	{"OPTI82C611A",	&opti82c611a_port_ops,	0x0F,
-						0	       ,	NULL },
+			0,			0,			NULL },
 	{"OPTI82C46X",	&opti82c46x_port_ops,	0x0F,
-						0	       ,	NULL },
+			0,			0,			NULL },
 	{"QDI6500",	&qdi6500_port_ops,	0x07,
-					ATA_FLAG_NO_IORDY,	qdi_port },
+			ATA_FLAG_NO_IORDY,
+			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE,    qdi_port },
 	{"QDI6580",	&qdi6580_port_ops,	0x1F,
-					0	       ,	qdi_port },
+			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE, qdi_port },
 	{"QDI6580DP",	&qdi6580dp_port_ops,	0x1F,
-					0	       ,	qdi_port },
+			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE, qdi_port },
 	{"W83759A",	&winbond_port_ops,	0x1F,
-					0	       ,	winbond_port }
+			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE,
+								winbond_port }
 };
 
 /**
@@ -1008,6 +1014,7 @@ static __init int legacy_init_one(struct legacy_probe *probe)
 	ap->ops = ops;
 	ap->pio_mask = pio_modes;
 	ap->flags |= ATA_FLAG_SLAVE_POSS | iordy;
+	ap->pflags |= controller->pflags;
 	ap->ioaddr.cmd_addr = io_addr;
 	ap->ioaddr.altstatus_addr = ctrl_addr;
 	ap->ioaddr.ctl_addr = ctrl_addr;
@@ -1032,6 +1039,7 @@ static __init int legacy_init_one(struct legacy_probe *probe)
 			return 0;
 		}
 	}
+	ata_host_detach(host);
 fail:
 	platform_device_unregister(pdev);
 	return ret;
diff --git a/drivers/ata/pata_ninja32.c b/drivers/ata/pata_ninja32.c
index 0fb6b1b..dd53a66 100644
--- a/drivers/ata/pata_ninja32.c
+++ b/drivers/ata/pata_ninja32.c
@@ -44,7 +44,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_ninja32"
-#define DRV_VERSION "0.1.3"
+#define DRV_VERSION "0.1.5"
 
 
 /**
@@ -86,6 +86,7 @@ static struct ata_port_operations ninja32_port_ops = {
 	.sff_dev_select = ninja32_dev_select,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= ninja32_set_piomode,
+	.sff_data_xfer	= ata_sff_data_xfer32
 };
 
 static void ninja32_program(void __iomem *base)
@@ -144,6 +145,7 @@ static int ninja32_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	ap->ioaddr.altstatus_addr = base + 0x1E;
 	ap->ioaddr.bmdma_addr = base;
 	ata_sff_std_ports(&ap->ioaddr);
+	ap->pflags = ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE;
 
 	ninja32_program(base);
 	/* FIXME: Should we disable them at remove ? */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b450a26..3d501db 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -209,6 +209,7 @@ enum {
 
 	/* bits 24:31 of ap->flags are reserved for LLD specific flags */
 
+
 	/* struct ata_port pflags */
 	ATA_PFLAG_EH_PENDING	= (1 << 0), /* EH pending */
 	ATA_PFLAG_EH_IN_PROGRESS = (1 << 1), /* EH in progress */
@@ -225,6 +226,9 @@ enum {
 	ATA_PFLAG_PM_PENDING	= (1 << 18), /* PM operation pending */
 	ATA_PFLAG_INIT_GTM_VALID = (1 << 19), /* initial gtm data valid */
 
+	ATA_PFLAG_PIO32		= (1 << 20),  /* 32bit PIO */
+	ATA_PFLAG_PIO32CHANGE	= (1 << 21),  /* 32bit PIO can be turned on/off */
+
 	/* struct ata_queued_cmd flags */
 	ATA_QCFLAG_ACTIVE	= (1 << 0), /* cmd not yet ack'd to scsi lyer */
 	ATA_QCFLAG_DMAMAP	= (1 << 1), /* SG table is DMA mapped */
@@ -689,7 +693,10 @@ struct ata_port {
 	struct Scsi_Host	*scsi_host; /* our co-allocated scsi host */
 	struct ata_port_operations *ops;
 	spinlock_t		*lock;
+	/* Flags owned by the EH context. Only EH should touch these once the
+	   port is active */
 	unsigned long		flags;	/* ATA_FLAG_xxx */
+	/* Flags that change dynamically, protected by ap->lock */
 	unsigned int		pflags; /* ATA_PFLAG_xxx */
 	unsigned int		print_id; /* user visible unique port ID */
 	unsigned int		port_no; /* 0 based port no. inside the host */
@@ -1595,6 +1602,7 @@ extern void ata_sff_drain_fifo(struct ata_queued_cmd *qc);
 extern void ata_sff_error_handler(struct ata_port *ap);
 extern void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc);
 extern int ata_sff_port_start(struct ata_port *ap);
+extern int ata_sff_port_start32(struct ata_port *ap);
 extern void ata_sff_std_ports(struct ata_ioports *ioaddr);
 extern unsigned long ata_bmdma_mode_filter(struct ata_device *dev,
 					   unsigned long xfer_mask);

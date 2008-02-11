Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbYBKTvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbYBKTvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757987AbYBKTvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:51:13 -0500
Received: from havoc.gtf.org ([69.61.125.42]:58797 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408AbYBKTvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:51:11 -0500
Date: Mon, 11 Feb 2008 14:51:10 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080211195110.GA23991@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-fixes' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-fixes

to receive the following updates:

 drivers/ata/libata-core.c  |   48 +++++++++++++++++++++++++++++-------------
 drivers/ata/pata_amd.c     |    2 +-
 drivers/ata/pata_legacy.c  |    2 +-
 drivers/ata/pata_ninja32.c |    9 ++++++-
 drivers/ata/pata_via.c     |    6 ++++-
 drivers/ata/sata_mv.c      |   50 ++++++++++++++++++++++++-------------------
 6 files changed, 75 insertions(+), 42 deletions(-)

Alan Cox (3):
      pata_amd: Note in the module description it handles Nvidia
      pata_legacy: typo fix
      pata_ninja32: setup changes

Byron Bradley (1):
      sata_mv: platform driver allocs dma without create

Tejun Heo (2):
      pata_via: fix SATA cable detection on cx700
      libata: ignore deverr on SETXFER if mode is configured

Yinghai Lu (1):
      sata_mv: fix loop with last port

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3011919..004dae4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3048,6 +3048,8 @@ int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel)
 static int ata_dev_set_mode(struct ata_device *dev)
 {
 	struct ata_eh_context *ehc = &dev->link->eh_context;
+	const char *dev_err_whine = "";
+	int ign_dev_err = 0;
 	unsigned int err_mask;
 	int rc;
 
@@ -3057,41 +3059,57 @@ static int ata_dev_set_mode(struct ata_device *dev)
 
 	err_mask = ata_dev_set_xfermode(dev);
 
+	if (err_mask & ~AC_ERR_DEV)
+		goto fail;
+
+	/* revalidate */
+	ehc->i.flags |= ATA_EHI_POST_SETMODE;
+	rc = ata_dev_revalidate(dev, ATA_DEV_UNKNOWN, 0);
+	ehc->i.flags &= ~ATA_EHI_POST_SETMODE;
+	if (rc)
+		return rc;
+
 	/* Old CFA may refuse this command, which is just fine */
 	if (dev->xfer_shift == ATA_SHIFT_PIO && ata_id_is_cfa(dev->id))
-		err_mask &= ~AC_ERR_DEV;
+		ign_dev_err = 1;
 
 	/* Some very old devices and some bad newer ones fail any kind of
 	   SET_XFERMODE request but support PIO0-2 timings and no IORDY */
 	if (dev->xfer_shift == ATA_SHIFT_PIO && !ata_id_has_iordy(dev->id) &&
 			dev->pio_mode <= XFER_PIO_2)
-		err_mask &= ~AC_ERR_DEV;
+		ign_dev_err = 1;
 
 	/* Early MWDMA devices do DMA but don't allow DMA mode setting.
 	   Don't fail an MWDMA0 set IFF the device indicates it is in MWDMA0 */
 	if (dev->xfer_shift == ATA_SHIFT_MWDMA &&
 	    dev->dma_mode == XFER_MW_DMA_0 &&
 	    (dev->id[63] >> 8) & 1)
-		err_mask &= ~AC_ERR_DEV;
+		ign_dev_err = 1;
 
-	if (err_mask) {
-		ata_dev_printk(dev, KERN_ERR, "failed to set xfermode "
-			       "(err_mask=0x%x)\n", err_mask);
-		return -EIO;
-	}
+	/* if the device is actually configured correctly, ignore dev err */
+	if (dev->xfer_mode == ata_xfer_mask2mode(ata_id_xfermask(dev->id)))
+		ign_dev_err = 1;
 
-	ehc->i.flags |= ATA_EHI_POST_SETMODE;
-	rc = ata_dev_revalidate(dev, ATA_DEV_UNKNOWN, 0);
-	ehc->i.flags &= ~ATA_EHI_POST_SETMODE;
-	if (rc)
-		return rc;
+	if (err_mask & AC_ERR_DEV) {
+		if (!ign_dev_err)
+			goto fail;
+		else
+			dev_err_whine = " (device error ignored)";
+	}
 
 	DPRINTK("xfer_shift=%u, xfer_mode=0x%x\n",
 		dev->xfer_shift, (int)dev->xfer_mode);
 
-	ata_dev_printk(dev, KERN_INFO, "configured for %s\n",
-		       ata_mode_string(ata_xfer_mode2mask(dev->xfer_mode)));
+	ata_dev_printk(dev, KERN_INFO, "configured for %s%s\n",
+		       ata_mode_string(ata_xfer_mode2mask(dev->xfer_mode)),
+		       dev_err_whine);
+
 	return 0;
+
+ fail:
+	ata_dev_printk(dev, KERN_ERR, "failed to set xfermode "
+		       "(err_mask=0x%x)\n", err_mask);
+	return -EIO;
 }
 
 /**
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 761a666..ea567e2 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -772,7 +772,7 @@ static void __exit amd_exit(void)
 }
 
 MODULE_AUTHOR("Alan Cox");
-MODULE_DESCRIPTION("low-level driver for AMD PATA IDE");
+MODULE_DESCRIPTION("low-level driver for AMD and Nvidia PATA IDE");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, amd);
 MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 333dc15..6c59969 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -127,7 +127,7 @@ static int opti82c611a;		/* Opti82c611A on primary 1, sec 2, both 3 */
 static int opti82c46x;		/* Opti 82c465MV present(pri/sec autodetect) */
 static int qdi;			/* Set to probe QDI controllers */
 static int winbond;		/* Set to probe Winbond controllers,
-					give I/O port if non stdanard */
+					give I/O port if non standard */
 static int autospeed;		/* Chip present which snoops speed changes */
 static int pio_mask = 0x1F;	/* PIO range for autospeed devices */
 static int iordy_mask = 0xFFFFFFFF;	/* Use iordy if available */
diff --git a/drivers/ata/pata_ninja32.c b/drivers/ata/pata_ninja32.c
index 1c1b835..15dd649 100644
--- a/drivers/ata/pata_ninja32.c
+++ b/drivers/ata/pata_ninja32.c
@@ -17,6 +17,7 @@
  *	Base + 0x00 IRQ Status
  *	Base + 0x01 IRQ control
  *	Base + 0x02 Chipset control
+ *	Base + 0x03 Unknown
  *	Base + 0x04 VDMA and reset control + wait bits
  *	Base + 0x08 BMIMBA
  *	Base + 0x0C DMA Length
@@ -174,8 +175,12 @@ static int ninja32_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	ata_std_ports(&ap->ioaddr);
 
 	iowrite8(0x05, base + 0x01);	/* Enable interrupt lines */
-	iowrite8(0xB3, base + 0x02);	/* Burst, ?? setup */
-	iowrite8(0x00, base + 0x04);	/* WAIT0 ? */
+	iowrite8(0xBE, base + 0x02);	/* Burst, ?? setup */
+	iowrite8(0x01, base + 0x03);	/* Unknown */
+	iowrite8(0x20, base + 0x04);	/* WAIT0 */
+	iowrite8(0x8f, base + 0x05);	/* Unknown */
+	iowrite8(0xa4, base + 0x1c);	/* Unknown */
+	iowrite8(0x83, base + 0x1d);	/* BMDMA control: WAIT0 */
 	/* FIXME: Should we disable them at remove ? */
 	return ata_host_activate(host, dev->irq, ata_interrupt,
 				 IRQF_SHARED, &ninja32_sht);
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 39627ab..d119a68 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -84,6 +84,7 @@ enum {
 	VIA_BAD_ID	= 0x100, /* Has wrong vendor ID (0x1107) */
 	VIA_BAD_AST	= 0x200, /* Don't touch Address Setup Timing */
 	VIA_NO_ENABLES	= 0x400, /* Has no enablebits */
+	VIA_SATA_PATA	= 0x800, /* SATA/PATA combined configuration */
 };
 
 /*
@@ -100,7 +101,7 @@ static const struct via_isa_bridge {
 	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
+	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
 	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES},
 	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
@@ -172,6 +173,9 @@ static int via_cable_detect(struct ata_port *ap) {
 	if (via_cable_override(pdev))
 		return ATA_CBL_PATA40_SHORT;
 
+	if ((config->flags & VIA_SATA_PATA) && ap->port_no == 0)
+		return ATA_CBL_SATA;
+
 	/* Early chips are 40 wire */
 	if ((config->flags & VIA_UDMA) < VIA_UDMA_66)
 		return ATA_CBL_PATA40;
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 080b836..04b5717 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1716,14 +1716,16 @@ static void mv_host_intr(struct ata_host *host, u32 relevant, unsigned int hc)
 	VPRINTK("ENTER, hc%u relevant=0x%08x HC IRQ cause=0x%08x\n",
 		hc, relevant, hc_irq_cause);
 
-	for (port = port0; port < port0 + last_port; port++) {
+	for (port = port0; port < last_port; port++) {
 		struct ata_port *ap = host->ports[port];
-		struct mv_port_priv *pp = ap->private_data;
+		struct mv_port_priv *pp;
 		int have_err_bits, hard_port, shift;
 
 		if ((!ap) || (ap->flags & ATA_FLAG_DISABLED))
 			continue;
 
+		pp = ap->private_data;
+
 		shift = port << 1;		/* (port * 2) */
 		if (port >= MV_PORTS_PER_HC) {
 			shift++;	/* skip bit 8 in the HC Main IRQ reg */
@@ -2879,6 +2881,26 @@ done:
 	return rc;
 }
 
+static int mv_create_dma_pools(struct mv_host_priv *hpriv, struct device *dev)
+{
+	hpriv->crqb_pool   = dmam_pool_create("crqb_q", dev, MV_CRQB_Q_SZ,
+							     MV_CRQB_Q_SZ, 0);
+	if (!hpriv->crqb_pool)
+		return -ENOMEM;
+
+	hpriv->crpb_pool   = dmam_pool_create("crpb_q", dev, MV_CRPB_Q_SZ,
+							     MV_CRPB_Q_SZ, 0);
+	if (!hpriv->crpb_pool)
+		return -ENOMEM;
+
+	hpriv->sg_tbl_pool = dmam_pool_create("sg_tbl", dev, MV_SG_TBL_SZ,
+							     MV_SG_TBL_SZ, 0);
+	if (!hpriv->sg_tbl_pool)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /**
  *      mv_platform_probe - handle a positive probe of an soc Marvell
  *      host
@@ -2932,6 +2954,10 @@ static int mv_platform_probe(struct platform_device *pdev)
 	hpriv->base = ioremap(res->start, res->end - res->start + 1);
 	hpriv->base -= MV_SATAHC0_REG_BASE;
 
+	rc = mv_create_dma_pools(hpriv, &pdev->dev);
+	if (rc)
+		return rc;
+
 	/* initialize adapter */
 	rc = mv_init_host(host, chip_soc);
 	if (rc)
@@ -3068,26 +3094,6 @@ static void mv_print_info(struct ata_host *host)
 	       scc_s, (MV_HP_FLAG_MSI & hpriv->hp_flags) ? "MSI" : "INTx");
 }
 
-static int mv_create_dma_pools(struct mv_host_priv *hpriv, struct device *dev)
-{
-	hpriv->crqb_pool   = dmam_pool_create("crqb_q", dev, MV_CRQB_Q_SZ,
-							     MV_CRQB_Q_SZ, 0);
-	if (!hpriv->crqb_pool)
-		return -ENOMEM;
-
-	hpriv->crpb_pool   = dmam_pool_create("crpb_q", dev, MV_CRPB_Q_SZ,
-							     MV_CRPB_Q_SZ, 0);
-	if (!hpriv->crpb_pool)
-		return -ENOMEM;
-
-	hpriv->sg_tbl_pool = dmam_pool_create("sg_tbl", dev, MV_SG_TBL_SZ,
-							     MV_SG_TBL_SZ, 0);
-	if (!hpriv->sg_tbl_pool)
-		return -ENOMEM;
-
-	return 0;
-}
-
 /**
  *      mv_pci_init_one - handle a positive probe of a PCI Marvell host
  *      @pdev: PCI device found

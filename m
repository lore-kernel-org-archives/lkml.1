Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbXBWKwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbXBWKwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932256AbXBWKwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:52:41 -0500
Received: from havoc.gtf.org ([69.61.125.42]:55319 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249AbXBWKwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:52:35 -0500
Date: Fri, 23 Feb 2007 05:52:34 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes for -rc
Message-ID: <20070223105234.GA3160@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is what is pending for upstream, when patch flow restarts.

The 'upstream-fixes' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-fixes

contains the following updates:

 drivers/ata/Kconfig          |    9 +
 drivers/ata/Makefile         |    1 +
 drivers/ata/ahci.c           |   28 +-
 drivers/ata/ata_piix.c       |    2 -
 drivers/ata/libata-acpi.c    |   20 +-
 drivers/ata/libata-core.c    |  200 ++++---
 drivers/ata/libata-eh.c      |  220 +++++---
 drivers/ata/libata-scsi.c    |   44 +-
 drivers/ata/libata-sff.c     |    2 +-
 drivers/ata/libata.h         |   13 +-
 drivers/ata/pata_cs5520.c    |   26 +-
 drivers/ata/pata_ixp4xx_cf.c |    7 +-
 drivers/ata/pata_oldpiix.c   |    5 +-
 drivers/ata/pata_pcmcia.c    |    7 +-
 drivers/ata/pata_platform.c  |    1 +
 drivers/ata/pata_rz1000.c    |    1 +
 drivers/ata/pata_scc.c       | 1228 ++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/pata_sil680.c    |   14 +-
 drivers/ata/pata_sis.c       |    7 +-
 drivers/ata/pata_sl82c105.c  |   39 +-
 drivers/ata/pdc_adma.c       |    2 +-
 drivers/ata/sata_mv.c        |    4 +-
 drivers/ata/sata_nv.c        |  226 ++++-----
 drivers/ata/sata_qstor.c     |    2 +-
 drivers/ata/sata_sil.c       |    2 +-
 drivers/ata/sata_sis.c       |    3 +-
 drivers/ata/sata_sx4.c       |   14 +-
 drivers/ata/sata_via.c       |   22 +-
 drivers/ata/sis.h            |    5 +
 include/linux/ata.h          |    8 +-
 include/linux/libata.h       |   25 +-
 31 files changed, 1783 insertions(+), 404 deletions(-)
 create mode 100644 drivers/ata/pata_scc.c
 create mode 100644 drivers/ata/sis.h

Akira Iguchi (1):
      libata: PATA driver for Celleb

Alan Cox (7):
      SiS warning fixes
      pata: Display Configuring .. lines for devices with private set_mode methods
      pata_cs5520: suspend/resume
      pata_ixp4xx: Fix up set_mode() function and display Configured for PIO info
      pata_oldpiix: Call both PIO and DMA setup functions on switch as they are called on set up
      pata_sil680: Assorted fixes
      pata_sl82c105: remove un-needed code paths

Jeff Garzik (2):
      libata: Fix Cell SATA driver dependencies
      [libata] ata_piix: remove duplicate PCI IDs

Magnus Damm (2):
      pata_pcmcia: Update device table
      libata: Remove duplicate dma blacklist entry

Mark Lord (1):
      libata bugfix: HDIO_DRIVE_TASK

Randy Dunlap (1):
      SATA: use NULL for ptrs

Robert Hancock (9):
      sata_nv: add back some verbosity into ADMA error_handler
      sata_nv: delay on switching between NCQ and non-NCQ commands
      sata_nv: Add CPB register info to error_handler output
      sata_nv: cleanup CPB and APRD initialization
      sata_nv: Cleanup taskfile setup
      sata_nv: Use notifier for completion checks
      sata_nv: enable hotplug interrupt and fix some readl/readw mismatches
      sata_nv: kill old private BMDMA helper functions
      sata_nv: complain on spurious completion notifiers

Tejun Heo (14):
      libata: improve ata_down_xfermask_limit()
      libata: improve probe failure handling
      libata: put some intelligence into EH speed down sequence
      libata: kill ATA_DNXFER_ANY
      libata: fix probe_ent alloc/free bugs
      libata: disable pdev on all suspend events
      libata: separate out ata_ncq_enabled()
      libata: fix ata_scmd_need_defer()
      libata: fix ata_scsi_change_queue_depth()
      sata_via: fix resource-managed iomap conversion
      libata: s/ap->id/ap->print_id/g
      ahci: consider SDB FIS containing spurious NCQ completions HSM violation (regenerated)
      libata: fix remaining ap->id
      libata: test major version in ata_id_is_sata()

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 4af0a4b..d16b5b0 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -562,6 +562,15 @@ config PATA_IXP4XX_CF
 
 	  If unsure, say N.
 
+config PATA_SCC
+	tristate "Toshiba's Cell Reference Set IDE support"
+	depends on PCI && PPC_IBM_CELL_BLADE
+	help
+	  This option enables support for the built-in IDE controller on
+	  Toshiba Cell Reference Board.
+
+	  If unsure, say N.
+
 endif
 endmenu
 
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 74298af..13d7397 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_PATA_WINBOND_VLB)	+= pata_winbond.o
 obj-$(CONFIG_PATA_SIS)		+= pata_sis.o
 obj-$(CONFIG_PATA_TRIFLEX)	+= pata_triflex.o
 obj-$(CONFIG_PATA_IXP4XX_CF)	+= pata_ixp4xx_cf.o
+obj-$(CONFIG_PATA_SCC)		+= pata_scc.o
 obj-$(CONFIG_PATA_PLATFORM)	+= pata_platform.o
 # Should be last but one libata driver
 obj-$(CONFIG_ATA_GENERIC)	+= ata_generic.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6a3543e..334f54c 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -198,7 +198,6 @@ struct ahci_port_priv {
 	void			*rx_fis;
 	dma_addr_t		rx_fis_dma;
 	/* for NCQ spurious interrupt analysis */
-	int			ncq_saw_spurious_sdb_cnt;
 	unsigned int		ncq_saw_d2h:1;
 	unsigned int		ncq_saw_dmas:1;
 };
@@ -1160,23 +1159,24 @@ static void ahci_host_intr(struct ata_port *ap)
 		known_irq = 1;
 	}
 
-	if (status & PORT_IRQ_SDB_FIS &&
-		   pp->ncq_saw_spurious_sdb_cnt < 10) {
+	if (status & PORT_IRQ_SDB_FIS) {
 		/* SDB FIS containing spurious completions might be
-		 * dangerous, we need to know more about them.  Print
-		 * more of it.
-		 */
+		 * dangerous, whine and fail commands with HSM
+		 * violation.  EH will turn off NCQ after several such
+		 * failures.
+  		 */
 		const __le32 *f = pp->rx_fis + RX_FIS_SDB;
 
-		ata_port_printk(ap, KERN_INFO, "Spurious SDB FIS during NCQ "
-				"issue=0x%x SAct=0x%x FIS=%08x:%08x%s\n",
-				readl(port_mmio + PORT_CMD_ISSUE),
-				readl(port_mmio + PORT_SCR_ACT),
-				le32_to_cpu(f[0]), le32_to_cpu(f[1]),
-				pp->ncq_saw_spurious_sdb_cnt < 10 ?
-				"" : ", shutting up");
+		ata_ehi_push_desc(ehi, "spurious completion during NCQ "
+				  "issue=0x%x SAct=0x%x FIS=%08x:%08x",
+				  readl(port_mmio + PORT_CMD_ISSUE),
+				  readl(port_mmio + PORT_SCR_ACT),
+				  le32_to_cpu(f[0]), le32_to_cpu(f[1]));
+
+		ehi->err_mask |= AC_ERR_HSM;
+		ehi->action |= ATA_EH_SOFTRESET;
+		ata_port_freeze(ap);
 
-		pp->ncq_saw_spurious_sdb_cnt++;
 		known_irq = 1;
 	}
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 4d716c7..97bad15 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -169,8 +169,6 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* Intel PIIX4 for the 430TX/440BX/MX chipset: UDMA 33 */
 	/* Also PIIX4E (fn3 rev 2) and PIIX4M (fn3 rev 3) */
 	{ 0x8086, 0x7111, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_33 },
-	{ 0x8086, 0x24db, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
-	{ 0x8086, 0x25a2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* Intel PIIX4 */
 	{ 0x8086, 0x7199, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_33 },
 	/* Intel PIIX4 */
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index b4e8be5..1bdf7a2 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -294,9 +294,8 @@ static int do_drive_get_GTF(struct ata_port *ap, int ix,
 		return 0;
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(atadev, KERN_DEBUG,
-			"%s: ENTER: ap->id: %d, port#: %d\n",
-			__FUNCTION__, ap->id, ap->port_no);
+		ata_dev_printk(atadev, KERN_DEBUG, "%s: ENTER: port#: %d\n",
+			       __FUNCTION__, ap->port_no);
 
 	if (!ata_dev_enabled(atadev) || (ap->flags & ATA_FLAG_DISABLED)) {
 		if (ata_msg_probe(ap))
@@ -521,9 +520,8 @@ static int do_drive_set_taskfiles(struct ata_port *ap,
 	struct taskfile_array	*gtf;
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(atadev, KERN_DEBUG,
-			"%s: ENTER: ap->id: %d, port#: %d\n",
-			__FUNCTION__, ap->id, ap->port_no);
+		ata_dev_printk(atadev, KERN_DEBUG, "%s: ENTER: port#: %d\n",
+			       __FUNCTION__, ap->port_no);
 
 	if (noacpi || !(ap->cbl == ATA_CBL_SATA))
 		return 0;
@@ -627,9 +625,8 @@ int ata_acpi_push_id(struct ata_port *ap, unsigned int ix)
 		return 0;
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(atadev, KERN_DEBUG,
-			"%s: ap->id: %d, ix = %d, port#: %d\n",
-			__FUNCTION__, ap->id, ix, ap->port_no);
+		ata_dev_printk(atadev, KERN_DEBUG, "%s: ix = %d, port#: %d\n",
+			       __FUNCTION__, ix, ap->port_no);
 
 	/* Don't continue if not a SATA device. */
 	if (!(ap->cbl == ATA_CBL_SATA)) {
@@ -685,9 +682,8 @@ int ata_acpi_push_id(struct ata_port *ap, unsigned int ix)
 	if (err < 0) {
 		if (ata_msg_probe(ap))
 			ata_dev_printk(atadev, KERN_DEBUG,
-				"ata%u(%u): %s _SDD error: status = 0x%x\n",
-				ap->id, ap->device->devno,
-				__FUNCTION__, status);
+				       "%s _SDD error: status = 0x%x\n",
+				       __FUNCTION__, status);
 	}
 
 	/* always return success */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index e900c5e..d3b4e25 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -72,7 +72,7 @@ static unsigned int ata_dev_init_params(struct ata_device *dev,
 static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
 static void ata_dev_xfermask(struct ata_device *dev);
 
-static unsigned int ata_unique_id = 1;
+static unsigned int ata_print_id = 1;
 static struct workqueue_struct *ata_wq;
 
 struct workqueue_struct *ata_aux_wq;
@@ -315,9 +315,7 @@ int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf->flags |= tf_flags;
 
-	if ((dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ_OFF |
-			   ATA_DFLAG_NCQ)) == ATA_DFLAG_NCQ &&
-	    likely(tag != ATA_TAG_INTERNAL)) {
+	if (ata_ncq_enabled(dev) && likely(tag != ATA_TAG_INTERNAL)) {
 		/* yay, NCQ */
 		if (!lba_48_ok(block, n_block))
 			return -ERANGE;
@@ -600,6 +598,8 @@ void ata_dev_disable(struct ata_device *dev)
 {
 	if (ata_dev_enabled(dev) && ata_msg_drv(dev->ap)) {
 		ata_dev_printk(dev, KERN_WARNING, "disabled\n");
+		ata_down_xfermask_limit(dev, ATA_DNXFER_FORCE_PIO0 |
+					     ATA_DNXFER_QUIET);
 		dev->class++;
 	}
 }
@@ -708,7 +708,7 @@ unsigned int ata_dev_classify(const struct ata_taskfile *tf)
  *	Device type - %ATA_DEV_ATA, %ATA_DEV_ATAPI or %ATA_DEV_NONE.
  */
 
-static unsigned int
+unsigned int
 ata_dev_try_classify(struct ata_port *ap, unsigned int device, u8 *r_err)
 {
 	struct ata_taskfile tf;
@@ -891,8 +891,8 @@ void ata_dev_select(struct ata_port *ap, unsigned int device,
 			   unsigned int wait, unsigned int can_sleep)
 {
 	if (ata_msg_probe(ap))
-		ata_port_printk(ap, KERN_INFO, "ata_dev_select: ENTER, ata%u: "
-				"device %u, wait %u\n", ap->id, device, wait);
+		ata_port_printk(ap, KERN_INFO, "ata_dev_select: ENTER, "
+				"device %u, wait %u\n", device, wait);
 
 	if (wait)
 		ata_wait_idle(ap);
@@ -1392,8 +1392,7 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 	int rc;
 
 	if (ata_msg_ctl(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER, host %u, dev %u\n",
-			       __FUNCTION__, ap->id, dev->devno);
+		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __FUNCTION__);
 
 	ata_dev_select(ap, dev->devno, 1, 1); /* select device 0/1 */
 
@@ -1430,7 +1429,7 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 	if (err_mask) {
 		if (err_mask & AC_ERR_NODEV_HINT) {
 			DPRINTK("ata%u.%d: NODEV after polling detection\n",
-				ap->id, dev->devno);
+				ap->print_id, dev->devno);
 			return -ENOENT;
 		}
 
@@ -1558,15 +1557,13 @@ int ata_dev_configure(struct ata_device *dev)
 	int rc;
 
 	if (!ata_dev_enabled(dev) && ata_msg_info(ap)) {
-		ata_dev_printk(dev, KERN_INFO,
-			       "%s: ENTER/EXIT (host %u, dev %u) -- nodev\n",
-			       __FUNCTION__, ap->id, dev->devno);
+		ata_dev_printk(dev, KERN_INFO, "%s: ENTER/EXIT -- nodev\n",
+			       __FUNCTION__);
 		return 0;
 	}
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER, host %u, dev %u\n",
-			       __FUNCTION__, ap->id, dev->devno);
+		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __FUNCTION__);
 
 	/* set _SDD */
 	rc = ata_acpi_push_id(ap, dev->devno);
@@ -1610,8 +1607,9 @@ int ata_dev_configure(struct ata_device *dev)
 	if (dev->class == ATA_DEV_ATA) {
 		if (ata_id_is_cfa(id)) {
 			if (id[162] & 1) /* CPRM may make this media unusable */
-				ata_dev_printk(dev, KERN_WARNING, "ata%u: device %u  supports DRM functions and may not be fully accessable.\n",
-					ap->id, dev->devno);
+				ata_dev_printk(dev, KERN_WARNING,
+					       "supports DRM functions and may "
+					       "not be fully accessable.\n");
 			snprintf(revbuf, 7, "CFA");
 		}
 		else
@@ -1778,7 +1776,7 @@ int ata_bus_probe(struct ata_port *ap)
 {
 	unsigned int classes[ATA_MAX_DEVICES];
 	int tries[ATA_MAX_DEVICES];
-	int i, rc, down_xfermask;
+	int i, rc;
 	struct ata_device *dev;
 
 	ata_port_probe(ap);
@@ -1787,8 +1785,6 @@ int ata_bus_probe(struct ata_port *ap)
 		tries[i] = ATA_PROBE_MAX_TRIES;
 
  retry:
-	down_xfermask = 0;
-
 	/* reset and determine device classes */
 	ap->ops->phy_reset(ap);
 
@@ -1836,10 +1832,8 @@ int ata_bus_probe(struct ata_port *ap)
 
 	/* configure transfer mode */
 	rc = ata_set_mode(ap, &dev);
-	if (rc) {
-		down_xfermask = 1;
+	if (rc)
 		goto fail;
-	}
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++)
 		if (ata_dev_enabled(&ap->device[i]))
@@ -1851,25 +1845,29 @@ int ata_bus_probe(struct ata_port *ap)
 	return -ENODEV;
 
  fail:
+	tries[dev->devno]--;
+
 	switch (rc) {
 	case -EINVAL:
-	case -ENODEV:
+		/* eeek, something went very wrong, give up */
 		tries[dev->devno] = 0;
 		break;
+
+	case -ENODEV:
+		/* give it just one more chance */
+		tries[dev->devno] = min(tries[dev->devno], 1);
 	case -EIO:
-		sata_down_spd_limit(ap);
-		/* fall through */
-	default:
-		tries[dev->devno]--;
-		if (down_xfermask &&
-		    ata_down_xfermask_limit(dev, tries[dev->devno] == 1))
-			tries[dev->devno] = 0;
+		if (tries[dev->devno] == 1) {
+			/* This is the last chance, better to slow
+			 * down than lose it.
+			 */
+			sata_down_spd_limit(ap);
+			ata_down_xfermask_limit(dev, ATA_DNXFER_PIO);
+		}
 	}
 
-	if (!tries[dev->devno]) {
-		ata_down_xfermask_limit(dev, 1);
+	if (!tries[dev->devno])
 		ata_dev_disable(dev);
-	}
 
 	goto retry;
 }
@@ -2300,7 +2298,7 @@ int ata_timing_compute(struct ata_device *adev, unsigned short speed,
 /**
  *	ata_down_xfermask_limit - adjust dev xfer masks downward
  *	@dev: Device to adjust xfer masks
- *	@force_pio0: Force PIO0
+ *	@sel: ATA_DNXFER_* selector
  *
  *	Adjust xfer masks of @dev downward.  Note that this function
  *	does not apply the change.  Invoking ata_set_mode() afterwards
@@ -2312,37 +2310,78 @@ int ata_timing_compute(struct ata_device *adev, unsigned short speed,
  *	RETURNS:
  *	0 on success, negative errno on failure
  */
-int ata_down_xfermask_limit(struct ata_device *dev, int force_pio0)
+int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel)
 {
-	unsigned long xfer_mask;
-	int highbit;
+	char buf[32];
+	unsigned int orig_mask, xfer_mask;
+	unsigned int pio_mask, mwdma_mask, udma_mask;
+	int quiet, highbit;
 
-	xfer_mask = ata_pack_xfermask(dev->pio_mask, dev->mwdma_mask,
-				      dev->udma_mask);
+	quiet = !!(sel & ATA_DNXFER_QUIET);
+	sel &= ~ATA_DNXFER_QUIET;
 
-	if (!xfer_mask)
-		goto fail;
-	/* don't gear down to MWDMA from UDMA, go directly to PIO */
-	if (xfer_mask & ATA_MASK_UDMA)
-		xfer_mask &= ~ATA_MASK_MWDMA;
+	xfer_mask = orig_mask = ata_pack_xfermask(dev->pio_mask,
+						  dev->mwdma_mask,
+						  dev->udma_mask);
+	ata_unpack_xfermask(xfer_mask, &pio_mask, &mwdma_mask, &udma_mask);
 
-	highbit = fls(xfer_mask) - 1;
-	xfer_mask &= ~(1 << highbit);
-	if (force_pio0)
-		xfer_mask &= 1 << ATA_SHIFT_PIO;
-	if (!xfer_mask)
-		goto fail;
+	switch (sel) {
+	case ATA_DNXFER_PIO:
+		highbit = fls(pio_mask) - 1;
+		pio_mask &= ~(1 << highbit);
+		break;
+
+	case ATA_DNXFER_DMA:
+		if (udma_mask) {
+			highbit = fls(udma_mask) - 1;
+			udma_mask &= ~(1 << highbit);
+			if (!udma_mask)
+				return -ENOENT;
+		} else if (mwdma_mask) {
+			highbit = fls(mwdma_mask) - 1;
+			mwdma_mask &= ~(1 << highbit);
+			if (!mwdma_mask)
+				return -ENOENT;
+		}
+		break;
+
+	case ATA_DNXFER_40C:
+		udma_mask &= ATA_UDMA_MASK_40C;
+		break;
+
+	case ATA_DNXFER_FORCE_PIO0:
+		pio_mask &= 1;
+	case ATA_DNXFER_FORCE_PIO:
+		mwdma_mask = 0;
+		udma_mask = 0;
+		break;
+
+	default:
+		BUG();
+	}
+
+	xfer_mask &= ata_pack_xfermask(pio_mask, mwdma_mask, udma_mask);
+
+	if (!(xfer_mask & ATA_MASK_PIO) || xfer_mask == orig_mask)
+		return -ENOENT;
+
+	if (!quiet) {
+		if (xfer_mask & (ATA_MASK_MWDMA | ATA_MASK_UDMA))
+			snprintf(buf, sizeof(buf), "%s:%s",
+				 ata_mode_string(xfer_mask),
+				 ata_mode_string(xfer_mask & ATA_MASK_PIO));
+		else
+			snprintf(buf, sizeof(buf), "%s",
+				 ata_mode_string(xfer_mask));
+
+		ata_dev_printk(dev, KERN_WARNING,
+			       "limiting speed to %s\n", buf);
+	}
 
 	ata_unpack_xfermask(xfer_mask, &dev->pio_mask, &dev->mwdma_mask,
 			    &dev->udma_mask);
 
-	ata_dev_printk(dev, KERN_WARNING, "limiting speed to %s\n",
-		       ata_mode_string(xfer_mask));
-
 	return 0;
-
- fail:
-	return -EINVAL;
 }
 
 static int ata_dev_set_mode(struct ata_device *dev)
@@ -2609,7 +2648,7 @@ static unsigned int ata_bus_softreset(struct ata_port *ap,
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 
-	DPRINTK("ata%u: bus reset via SRST\n", ap->id);
+	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
 
 	/* software reset.  causes dev0 to be selected */
 	iowrite8(ap->ctl, ioaddr->ctl_addr);
@@ -2669,7 +2708,7 @@ void ata_bus_reset(struct ata_port *ap)
 	u8 err;
 	unsigned int dev0, dev1 = 0, devmask = 0;
 
-	DPRINTK("ENTER, host %u, port %u\n", ap->id, ap->port_no);
+	DPRINTK("ENTER, host %u, port %u\n", ap->print_id, ap->port_no);
 
 	/* determine if device 0/1 are present */
 	if (ap->flags & ATA_FLAG_SATA_RESET)
@@ -3256,7 +3295,6 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "WPI CDD-820", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "SAMSUNG CD-ROM SC-148C", NULL,	ATA_HORKAGE_NODMA },
 	{ "SAMSUNG CD-ROM SC",	NULL,		ATA_HORKAGE_NODMA },
-	{ "SanDisk SDP3B-64", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",NULL,ATA_HORKAGE_NODMA },
 	{ "_NEC DV5800A", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "SAMSUNG CD-ROM SN-124","N001",	ATA_HORKAGE_NODMA },
@@ -3739,7 +3777,7 @@ static int ata_sg_setup(struct ata_queued_cmd *qc)
 	struct scatterlist *lsg = &sg[qc->n_elem - 1];
 	int n_elem, pre_n_elem, dir, trim_sg = 0;
 
-	VPRINTK("ENTER, ata%u\n", ap->id);
+	VPRINTK("ENTER, ata%u\n", ap->print_id);
 	WARN_ON(!(qc->flags & ATA_QCFLAG_SG));
 
 	/* we must lengthen transfers to end on a 32-bit boundary */
@@ -4140,7 +4178,7 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
 	if (do_write != i_write)
 		goto err_out;
 
-	VPRINTK("ata%u: xfering %d bytes\n", ap->id, bytes);
+	VPRINTK("ata%u: xfering %d bytes\n", ap->print_id, bytes);
 
 	__atapi_pio_bytes(qc, bytes);
 
@@ -4257,7 +4295,7 @@ int ata_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,
 
 fsm_start:
 	DPRINTK("ata%u: protocol %d task_state %d (dev_stat 0x%X)\n",
-		ap->id, qc->tf.protocol, ap->hsm_task_state, status);
+		ap->print_id, qc->tf.protocol, ap->hsm_task_state, status);
 
 	switch (ap->hsm_task_state) {
 	case HSM_ST_FIRST:
@@ -4290,8 +4328,8 @@ fsm_start:
 		 * let the EH abort the command or reset the device.
 		 */
 		if (unlikely(status & (ATA_ERR | ATA_DF))) {
-			printk(KERN_WARNING "ata%d: DRQ=1 with device error, dev_stat 0x%X\n",
-			       ap->id, status);
+			ata_port_printk(ap, KERN_WARNING, "DRQ=1 with device "
+					"error, dev_stat 0x%X\n", status);
 			qc->err_mask |= AC_ERR_HSM;
 			ap->hsm_task_state = HSM_ST_ERR;
 			goto fsm_start;
@@ -4348,8 +4386,9 @@ fsm_start:
 			 * let the EH abort the command or reset the device.
 			 */
 			if (unlikely(status & (ATA_ERR | ATA_DF))) {
-				printk(KERN_WARNING "ata%d: DRQ=1 with device error, dev_stat 0x%X\n",
-				       ap->id, status);
+				ata_port_printk(ap, KERN_WARNING, "DRQ=1 with "
+						"device error, dev_stat 0x%X\n",
+						status);
 				qc->err_mask |= AC_ERR_HSM;
 				ap->hsm_task_state = HSM_ST_ERR;
 				goto fsm_start;
@@ -4435,7 +4474,7 @@ fsm_start:
 
 		/* no more data to transfer */
 		DPRINTK("ata%u: dev %u command complete, drv_stat 0x%x\n",
-			ap->id, qc->dev->devno, status);
+			ap->print_id, qc->dev->devno, status);
 
 		WARN_ON(qc->err_mask);
 
@@ -4977,7 +5016,7 @@ inline unsigned int ata_host_intr (struct ata_port *ap,
 	u8 status, host_stat = 0;
 
 	VPRINTK("ata%u: protocol %d task_state %d\n",
-		ap->id, qc->tf.protocol, ap->hsm_task_state);
+		ap->print_id, qc->tf.protocol, ap->hsm_task_state);
 
 	/* Check whether we are expecting interrupt in this state */
 	switch (ap->hsm_task_state) {
@@ -4998,7 +5037,8 @@ inline unsigned int ata_host_intr (struct ata_port *ap,
 		    qc->tf.protocol == ATA_PROT_ATAPI_DMA) {
 			/* check status of DMA engine */
 			host_stat = ap->ops->bmdma_status(ap);
-			VPRINTK("ata%u: host_stat 0x%X\n", ap->id, host_stat);
+			VPRINTK("ata%u: host_stat 0x%X\n",
+				ap->print_id, host_stat);
 
 			/* if it's not our irq... */
 			if (!(host_stat & ATA_DMA_INTR))
@@ -5457,7 +5497,7 @@ void ata_port_init(struct ata_port *ap, struct ata_host *host,
 
 	ap->lock = &host->lock;
 	ap->flags = ATA_FLAG_DISABLED;
-	ap->id = ata_unique_id++;
+	ap->print_id = ata_print_id++;
 	ap->ctl = ATA_DEVCTL_OBS;
 	ap->host = host;
 	ap->dev = ent->dev;
@@ -5528,7 +5568,7 @@ static void ata_port_init_shost(struct ata_port *ap, struct Scsi_Host *shost)
 {
 	ap->scsi_host = shost;
 
-	shost->unique_id = ap->id;
+	shost->unique_id = ap->print_id;
 	shost->max_id = 16;
 	shost->max_lun = 1;
 	shost->max_channel = 1;
@@ -5792,9 +5832,9 @@ int ata_device_add(const struct ata_probe_ent *ent)
 			/* wait for EH to finish */
 			ata_port_wait_eh(ap);
 		} else {
-			DPRINTK("ata%u: bus probe begin\n", ap->id);
+			DPRINTK("ata%u: bus probe begin\n", ap->print_id);
 			rc = ata_bus_probe(ap);
-			DPRINTK("ata%u: bus probe end\n", ap->id);
+			DPRINTK("ata%u: bus probe end\n", ap->print_id);
 
 			if (rc) {
 				/* FIXME: do something useful here?
@@ -5905,11 +5945,7 @@ ata_probe_ent_alloc(struct device *dev, const struct ata_port_info *port)
 {
 	struct ata_probe_ent *probe_ent;
 
-	/* XXX - the following if can go away once all LLDs are managed */
-	if (!list_empty(&dev->devres_head))
-		probe_ent = devm_kzalloc(dev, sizeof(*probe_ent), GFP_KERNEL);
-	else
-		probe_ent = kzalloc(sizeof(*probe_ent), GFP_KERNEL);
+	probe_ent = devm_kzalloc(dev, sizeof(*probe_ent), GFP_KERNEL);
 	if (!probe_ent) {
 		printk(KERN_ERR DRV_NAME "(%s): out of memory\n",
 		       kobject_name(&(dev->kobj)));
@@ -6015,11 +6051,10 @@ int pci_test_config_bits(struct pci_dev *pdev, const struct pci_bits *bits)
 void ata_pci_device_do_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	pci_save_state(pdev);
+	pci_disable_device(pdev);
 
-	if (mesg.event == PM_EVENT_SUSPEND) {
-		pci_disable_device(pdev);
+	if (mesg.event == PM_EVENT_SUSPEND)
 		pci_set_power_state(pdev, PCI_D3hot);
-	}
 }
 
 int ata_pci_device_do_resume(struct pci_dev *pdev)
@@ -6311,3 +6346,4 @@ EXPORT_SYMBOL_GPL(ata_irq_on);
 EXPORT_SYMBOL_GPL(ata_dummy_irq_on);
 EXPORT_SYMBOL_GPL(ata_irq_ack);
 EXPORT_SYMBOL_GPL(ata_dummy_irq_ack);
+EXPORT_SYMBOL_GPL(ata_dev_try_classify);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 52c85af..cad0d6d 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -44,6 +44,12 @@
 
 #include "libata.h"
 
+enum {
+	ATA_EH_SPDN_NCQ_OFF		= (1 << 0),
+	ATA_EH_SPDN_SPEED_DOWN		= (1 << 1),
+	ATA_EH_SPDN_FALLBACK_TO_PIO	= (1 << 2),
+};
+
 static void __ata_port_freeze(struct ata_port *ap);
 static void ata_eh_finish(struct ata_port *ap);
 static void ata_eh_handle_port_suspend(struct ata_port *ap);
@@ -65,12 +71,9 @@ static void ata_ering_record(struct ata_ering *ering, int is_io,
 	ent->timestamp = get_jiffies_64();
 }
 
-static struct ata_ering_entry * ata_ering_top(struct ata_ering *ering)
+static void ata_ering_clear(struct ata_ering *ering)
 {
-	struct ata_ering_entry *ent = &ering->ring[ering->cursor];
-	if (!ent->err_mask)
-		return NULL;
-	return ent;
+	memset(ering, 0, sizeof(*ering));
 }
 
 static int ata_ering_map(struct ata_ering *ering,
@@ -585,7 +588,7 @@ static void __ata_port_freeze(struct ata_port *ap)
 
 	ap->pflags |= ATA_PFLAG_FROZEN;
 
-	DPRINTK("ata%u port frozen\n", ap->id);
+	DPRINTK("ata%u port frozen\n", ap->print_id);
 }
 
 /**
@@ -658,7 +661,7 @@ void ata_eh_thaw_port(struct ata_port *ap)
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	DPRINTK("ata%u port thawed\n", ap->id);
+	DPRINTK("ata%u port thawed\n", ap->print_id);
 }
 
 static void ata_eh_scsidone(struct scsi_cmnd *scmd)
@@ -1159,87 +1162,99 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc,
 	return action;
 }
 
-static int ata_eh_categorize_ering_entry(struct ata_ering_entry *ent)
+static int ata_eh_categorize_error(int is_io, unsigned int err_mask)
 {
-	if (ent->err_mask & (AC_ERR_ATA_BUS | AC_ERR_TIMEOUT))
+	if (err_mask & AC_ERR_ATA_BUS)
 		return 1;
 
-	if (ent->is_io) {
-		if (ent->err_mask & AC_ERR_HSM)
-			return 1;
-		if ((ent->err_mask &
-		     (AC_ERR_DEV|AC_ERR_MEDIA|AC_ERR_INVALID)) == AC_ERR_DEV)
+	if (err_mask & AC_ERR_TIMEOUT)
+		return 2;
+
+	if (is_io) {
+		if (err_mask & AC_ERR_HSM)
 			return 2;
+		if ((err_mask &
+		     (AC_ERR_DEV|AC_ERR_MEDIA|AC_ERR_INVALID)) == AC_ERR_DEV)
+			return 3;
 	}
 
 	return 0;
 }
 
-struct speed_down_needed_arg {
+struct speed_down_verdict_arg {
 	u64 since;
-	int nr_errors[3];
+	int nr_errors[4];
 };
 
-static int speed_down_needed_cb(struct ata_ering_entry *ent, void *void_arg)
+static int speed_down_verdict_cb(struct ata_ering_entry *ent, void *void_arg)
 {
-	struct speed_down_needed_arg *arg = void_arg;
+	struct speed_down_verdict_arg *arg = void_arg;
+	int cat = ata_eh_categorize_error(ent->is_io, ent->err_mask);
 
 	if (ent->timestamp < arg->since)
 		return -1;
 
-	arg->nr_errors[ata_eh_categorize_ering_entry(ent)]++;
+	arg->nr_errors[cat]++;
 	return 0;
 }
 
 /**
- *	ata_eh_speed_down_needed - Determine wheter speed down is necessary
+ *	ata_eh_speed_down_verdict - Determine speed down verdict
  *	@dev: Device of interest
  *
  *	This function examines error ring of @dev and determines
- *	whether speed down is necessary.  Speed down is necessary if
- *	there have been more than 3 of Cat-1 errors or 10 of Cat-2
- *	errors during last 15 minutes.
+ *	whether NCQ needs to be turned off, transfer speed should be
+ *	stepped down, or falling back to PIO is necessary.
  *
- *	Cat-1 errors are ATA_BUS, TIMEOUT for any command and HSM
- *	violation for known supported commands.
+ *	Cat-1 is ATA_BUS error for any command.
  *
- *	Cat-2 errors are unclassified DEV error for known supported
+ *	Cat-2 is TIMEOUT for any command or HSM violation for known
+ *	supported commands.
+ *
+ *	Cat-3 is is unclassified DEV error for known supported
  *	command.
  *
+ *	NCQ needs to be turned off if there have been more than 3
+ *	Cat-2 + Cat-3 errors during last 10 minutes.
+ *
+ *	Speed down is necessary if there have been more than 3 Cat-1 +
+ *	Cat-2 errors or 10 Cat-3 errors during last 10 minutes.
+ *
+ *	Falling back to PIO mode is necessary if there have been more
+ *	than 10 Cat-1 + Cat-2 + Cat-3 errors during last 5 minutes.
+ *
  *	LOCKING:
  *	Inherited from caller.
  *
  *	RETURNS:
- *	1 if speed down is necessary, 0 otherwise
+ *	OR of ATA_EH_SPDN_* flags.
  */
-static int ata_eh_speed_down_needed(struct ata_device *dev)
+static unsigned int ata_eh_speed_down_verdict(struct ata_device *dev)
 {
-	const u64 interval = 15LLU * 60 * HZ;
-	static const int err_limits[3] = { -1, 3, 10 };
-	struct speed_down_needed_arg arg;
-	struct ata_ering_entry *ent;
-	int err_cat;
-	u64 j64;
+	const u64 j5mins = 5LLU * 60 * HZ, j10mins = 10LLU * 60 * HZ;
+	u64 j64 = get_jiffies_64();
+	struct speed_down_verdict_arg arg;
+	unsigned int verdict = 0;
 
-	ent = ata_ering_top(&dev->ering);
-	if (!ent)
-		return 0;
+	/* scan past 10 mins of error history */
+	memset(&arg, 0, sizeof(arg));
+	arg.since = j64 - min(j64, j10mins);
+	ata_ering_map(&dev->ering, speed_down_verdict_cb, &arg);
 
-	err_cat = ata_eh_categorize_ering_entry(ent);
-	if (err_cat == 0)
-		return 0;
+	if (arg.nr_errors[2] + arg.nr_errors[3] > 3)
+		verdict |= ATA_EH_SPDN_NCQ_OFF;
+	if (arg.nr_errors[1] + arg.nr_errors[2] > 3 || arg.nr_errors[3] > 10)
+		verdict |= ATA_EH_SPDN_SPEED_DOWN;
 
+	/* scan past 3 mins of error history */
 	memset(&arg, 0, sizeof(arg));
+	arg.since = j64 - min(j64, j5mins);
+	ata_ering_map(&dev->ering, speed_down_verdict_cb, &arg);
 
-	j64 = get_jiffies_64();
-	if (j64 >= interval)
-		arg.since = j64 - interval;
-	else
-		arg.since = 0;
-
-	ata_ering_map(&dev->ering, speed_down_needed_cb, &arg);
+	if (arg.nr_errors[1] + arg.nr_errors[2] + arg.nr_errors[3] > 10)
+		verdict |= ATA_EH_SPDN_FALLBACK_TO_PIO;
 
-	return arg.nr_errors[err_cat] > err_limits[err_cat];
+	return verdict;
 }
 
 /**
@@ -1257,31 +1272,80 @@ static int ata_eh_speed_down_needed(struct ata_device *dev)
  *	Kernel thread context (may sleep).
  *
  *	RETURNS:
- *	0 on success, -errno otherwise
+ *	Determined recovery action.
  */
-static int ata_eh_speed_down(struct ata_device *dev, int is_io,
-			     unsigned int err_mask)
+static unsigned int ata_eh_speed_down(struct ata_device *dev, int is_io,
+				      unsigned int err_mask)
 {
-	if (!err_mask)
+	unsigned int verdict;
+	unsigned int action = 0;
+
+	/* don't bother if Cat-0 error */
+	if (ata_eh_categorize_error(is_io, err_mask) == 0)
 		return 0;
 
 	/* record error and determine whether speed down is necessary */
 	ata_ering_record(&dev->ering, is_io, err_mask);
+	verdict = ata_eh_speed_down_verdict(dev);
 
-	if (!ata_eh_speed_down_needed(dev))
-		return 0;
+	/* turn off NCQ? */
+	if ((verdict & ATA_EH_SPDN_NCQ_OFF) &&
+	    (dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ |
+			   ATA_DFLAG_NCQ_OFF)) == ATA_DFLAG_NCQ) {
+		dev->flags |= ATA_DFLAG_NCQ_OFF;
+		ata_dev_printk(dev, KERN_WARNING,
+			       "NCQ disabled due to excessive errors\n");
+		goto done;
+	}
 
-	/* speed down SATA link speed if possible */
-	if (sata_down_spd_limit(dev->ap) == 0)
-		return ATA_EH_HARDRESET;
+	/* speed down? */
+	if (verdict & ATA_EH_SPDN_SPEED_DOWN) {
+		/* speed down SATA link speed if possible */
+		if (sata_down_spd_limit(dev->ap) == 0) {
+			action |= ATA_EH_HARDRESET;
+			goto done;
+		}
 
-	/* lower transfer mode */
-	if (ata_down_xfermask_limit(dev, 0) == 0)
-		return ATA_EH_SOFTRESET;
+		/* lower transfer mode */
+		if (dev->spdn_cnt < 2) {
+			static const int dma_dnxfer_sel[] =
+				{ ATA_DNXFER_DMA, ATA_DNXFER_40C };
+			static const int pio_dnxfer_sel[] =
+				{ ATA_DNXFER_PIO, ATA_DNXFER_FORCE_PIO0 };
+			int sel;
+
+			if (dev->xfer_shift != ATA_SHIFT_PIO)
+				sel = dma_dnxfer_sel[dev->spdn_cnt];
+			else
+				sel = pio_dnxfer_sel[dev->spdn_cnt];
+
+			dev->spdn_cnt++;
+
+			if (ata_down_xfermask_limit(dev, sel) == 0) {
+				action |= ATA_EH_SOFTRESET;
+				goto done;
+			}
+		}
+	}
+
+	/* Fall back to PIO?  Slowing down to PIO is meaningless for
+	 * SATA.  Consider it only for PATA.
+	 */
+	if ((verdict & ATA_EH_SPDN_FALLBACK_TO_PIO) && (dev->spdn_cnt >= 2) &&
+	    (dev->ap->cbl != ATA_CBL_SATA) &&
+	    (dev->xfer_shift != ATA_SHIFT_PIO)) {
+		if (ata_down_xfermask_limit(dev, ATA_DNXFER_FORCE_PIO) == 0) {
+			dev->spdn_cnt = 0;
+			action |= ATA_EH_SOFTRESET;
+			goto done;
+		}
+	}
 
-	ata_dev_printk(dev, KERN_ERR,
-		       "speed down requested but no transfer mode left\n");
 	return 0;
+ done:
+	/* device has been slowed down, blow error history */
+	ata_ering_clear(&dev->ering);
+	return action;
 }
 
 /**
@@ -1964,7 +2028,7 @@ static int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 {
 	struct ata_eh_context *ehc = &ap->eh_context;
 	struct ata_device *dev;
-	int down_xfermask, i, rc;
+	int i, rc;
 
 	DPRINTK("ENTER\n");
 
@@ -1993,7 +2057,6 @@ static int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 	}
 
  retry:
-	down_xfermask = 0;
 	rc = 0;
 
 	/* if UNLOADING, finish immediately */
@@ -2038,10 +2101,8 @@ static int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 	/* configure transfer mode if necessary */
 	if (ehc->i.flags & ATA_EHI_SETMODE) {
 		rc = ata_set_mode(ap, &dev);
-		if (rc) {
-			down_xfermask = 1;
+		if (rc)
 			goto dev_fail;
-		}
 		ehc->i.flags &= ~ATA_EHI_SETMODE;
 	}
 
@@ -2053,20 +2114,27 @@ static int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 	goto out;
 
  dev_fail:
+	ehc->tries[dev->devno]--;
+
 	switch (rc) {
-	case -ENODEV:
-		/* device missing, schedule probing */
-		ehc->i.probe_mask |= (1 << dev->devno);
 	case -EINVAL:
+		/* eeek, something went very wrong, give up */
 		ehc->tries[dev->devno] = 0;
 		break;
+
+	case -ENODEV:
+		/* device missing or wrong IDENTIFY data, schedule probing */
+		ehc->i.probe_mask |= (1 << dev->devno);
+		/* give it just one more chance */
+		ehc->tries[dev->devno] = min(ehc->tries[dev->devno], 1);
 	case -EIO:
-		sata_down_spd_limit(ap);
-	default:
-		ehc->tries[dev->devno]--;
-		if (down_xfermask &&
-		    ata_down_xfermask_limit(dev, ehc->tries[dev->devno] == 1))
-			ehc->tries[dev->devno] = 0;
+		if (ehc->tries[dev->devno] == 1) {
+			/* This is the last chance, better to slow
+			 * down than lose it.
+			 */
+			sata_down_spd_limit(ap);
+			ata_down_xfermask_limit(dev, ATA_DNXFER_PIO);
+		}
 	}
 
 	if (ata_dev_enabled(dev) && !ehc->tries[dev->devno]) {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0009818..00a9a6c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -333,6 +333,7 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	scsi_cmd[8]  = args[3];
 	scsi_cmd[10] = args[4];
 	scsi_cmd[12] = args[5];
+	scsi_cmd[13] = args[6] & 0x0f;
 	scsi_cmd[14] = args[0];
 
 	/* Good values for timeout and retries?  Values below
@@ -781,7 +782,7 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 	 */
 	if (qc->err_mask ||
 	    tf->command & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
-		ata_to_sense_error(qc->ap->id, tf->command, tf->feature,
+		ata_to_sense_error(qc->ap->print_id, tf->command, tf->feature,
 				   &sb[1], &sb[2], &sb[3], verbose);
 		sb[1] &= 0x0f;
 	}
@@ -854,7 +855,7 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	 */
 	if (qc->err_mask ||
 	    tf->command & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
-		ata_to_sense_error(qc->ap->id, tf->command, tf->feature,
+		ata_to_sense_error(qc->ap->print_id, tf->command, tf->feature,
 				   &sb[1], &sb[2], &sb[3], verbose);
 		sb[1] &= 0x0f;
 	}
@@ -986,29 +987,32 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev;
 	unsigned long flags;
-	int max_depth;
 
-	if (queue_depth < 1)
+	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
 		return sdev->queue_depth;
 
 	dev = ata_scsi_find_dev(ap, sdev);
 	if (!dev || !ata_dev_enabled(dev))
 		return sdev->queue_depth;
 
-	max_depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
-	max_depth = min(ATA_MAX_QUEUE - 1, max_depth);
-	if (queue_depth > max_depth)
-		queue_depth = max_depth;
-
-	scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, queue_depth);
-
+	/* NCQ enabled? */
 	spin_lock_irqsave(ap->lock, flags);
-	if (queue_depth > 1)
-		dev->flags &= ~ATA_DFLAG_NCQ_OFF;
-	else
+	dev->flags &= ~ATA_DFLAG_NCQ_OFF;
+	if (queue_depth == 1 || !ata_ncq_enabled(dev)) {
 		dev->flags |= ATA_DFLAG_NCQ_OFF;
+		queue_depth = 1;
+	}
 	spin_unlock_irqrestore(ap->lock, flags);
 
+	/* limit and apply queue depth */
+	queue_depth = min(queue_depth, sdev->host->can_queue);
+	queue_depth = min(queue_depth, ata_id_queue_depth(dev->id));
+	queue_depth = min(queue_depth, ATA_MAX_QUEUE - 1);
+
+	if (sdev->queue_depth == queue_depth)
+		return -EINVAL;
+
+	scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, queue_depth);
 	return queue_depth;
 }
 
@@ -1469,7 +1473,7 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 	}
 
 	if (need_sense && !ap->ops->error_handler)
-		ata_dump_status(ap->id, &qc->result_tf);
+		ata_dump_status(ap->print_id, &qc->result_tf);
 
 	qc->scsidone(cmd);
 
@@ -1495,11 +1499,9 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 static int ata_scmd_need_defer(struct ata_device *dev, int is_io)
 {
 	struct ata_port *ap = dev->ap;
+	int is_ncq = is_io && ata_ncq_enabled(dev);
 
-	if (!(dev->flags & ATA_DFLAG_NCQ))
-		return 0;
-
-	if (is_io) {
+	if (is_ncq) {
 		if (!ata_tag_valid(ap->active_tag))
 			return 0;
 	} else {
@@ -2774,7 +2776,7 @@ static inline void ata_scsi_dump_cdb(struct ata_port *ap,
 	u8 *scsicmd = cmd->cmnd;
 
 	DPRINTK("CDB (%u:%d,%d,%d) %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
-		ap->id,
+		ap->print_id,
 		scsidev->channel, scsidev->id, scsidev->lun,
 		scsicmd[0], scsicmd[1], scsicmd[2], scsicmd[3],
 		scsicmd[4], scsicmd[5], scsicmd[6], scsicmd[7],
@@ -3234,7 +3236,7 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
 
 	ata_port_init(ap, host, ent, 0);
 	ap->lock = shost->host_lock;
-	kfree(ent);
+	devm_kfree(host->dev, ent);
 	return ap;
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 16bc3e3..7fea094 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -175,7 +175,7 @@ void ata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
  */
 void ata_exec_command(struct ata_port *ap, const struct ata_taskfile *tf)
 {
-	DPRINTK("ata%u: cmd 0x%X\n", ap->id, tf->command);
+	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
 
 	iowrite8(tf->command, ap->ioaddr.command_addr);
 	ata_pause(ap);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 0ad7781..c426714 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -41,6 +41,15 @@ struct ata_scsi_args {
 enum {
 	/* flags for ata_dev_read_id() */
 	ATA_READID_POSTRESET	= (1 << 0), /* reading ID after reset */
+
+	/* selector for ata_down_xfermask_limit() */
+	ATA_DNXFER_PIO		= 0,	/* speed down PIO */
+	ATA_DNXFER_DMA		= 1,	/* speed down DMA */
+	ATA_DNXFER_40C		= 2,	/* apply 40c cable limit */
+	ATA_DNXFER_FORCE_PIO	= 3,	/* force PIO */
+	ATA_DNXFER_FORCE_PIO0	= 4,	/* force PIO0 */
+
+	ATA_DNXFER_QUIET	= (1 << 31),
 };
 
 extern struct workqueue_struct *ata_aux_wq;
@@ -69,7 +78,7 @@ extern int ata_dev_revalidate(struct ata_device *dev, unsigned int flags);
 extern int ata_dev_configure(struct ata_device *dev);
 extern int sata_down_spd_limit(struct ata_port *ap);
 extern int sata_set_spd_needed(struct ata_port *ap);
-extern int ata_down_xfermask_limit(struct ata_device *dev, int force_pio0);
+extern int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel);
 extern int ata_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev);
 extern void ata_sg_clean(struct ata_queued_cmd *qc);
 extern void ata_qc_free(struct ata_queued_cmd *qc);
@@ -150,7 +159,5 @@ extern void ata_qc_schedule_eh(struct ata_queued_cmd *qc);
 /* libata-sff.c */
 extern u8 ata_irq_on(struct ata_port *ap);
 
-/* pata_sis.c */
-extern struct ata_port_info sis_info133;
 
 #endif /* __LIBATA_H__ */
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 1ce8fcf..b49d8b7 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -325,6 +325,30 @@ static int cs5520_reinit_one(struct pci_dev *pdev)
 		pci_write_config_byte(pdev, 0x60, pcicfg | 0x40);
 	return ata_pci_device_resume(pdev);
 }
+
+/**
+ *	cs5520_pci_device_suspend	-	device suspend
+ *	@pdev: PCI device
+ *
+ *	We have to cut and waste bits from the standard method because
+ *	the 5520 is a bit odd and not just a pure ATA device. As a result
+ *	we must not disable it. The needed code is short and this avoids
+ *	chip specific mess in the core code.
+ */
+
+static int cs5520_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc = 0;
+
+	rc = ata_host_suspend(host, mesg);
+	if (rc)
+		return rc;
+
+	pci_save_state(pdev);
+	return 0;
+}
+ 
 /* For now keep DMA off. We can set it for all but A rev CS5510 once the
    core ATA code can handle it */
 
@@ -340,7 +364,7 @@ static struct pci_driver cs5520_pci_driver = {
 	.id_table	= pata_cs5520,
 	.probe 		= cs5520_init_one,
 	.remove		= cs5520_remove_one,
-	.suspend	= ata_pci_device_suspend,
+	.suspend	= cs5520_pci_device_suspend,
 	.resume		= cs5520_reinit_one,
 };
 
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 3222ac7..bd8aaaf 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -23,15 +23,16 @@
 #include <scsi/scsi_host.h>
 
 #define DRV_NAME	"pata_ixp4xx_cf"
-#define DRV_VERSION	"0.1.1ac1"
+#define DRV_VERSION	"0.1.1ac3"
 
-static int ixp4xx_set_mode(struct ata_port *ap, struct ata_device *adev)
+static int ixp4xx_set_mode(struct ata_port *ap, struct ata_device **error)
 {
 	int i;
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
-		if (ata_dev_enabled(dev)) {
+		if (ata_dev_ready(dev)) {
+			ata_dev_printk(dev, KERN_INFO, "configured for PIO0\n");
 			dev->pio_mode = XFER_PIO_0;
 			dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 45215aa..2389107 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -25,7 +25,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_oldpiix"
-#define DRV_VERSION	"0.5.3"
+#define DRV_VERSION	"0.5.4"
 
 /**
  *	oldpiix_pre_reset		-	probe begin
@@ -209,10 +209,9 @@ static unsigned int oldpiix_qc_issue_prot(struct ata_queued_cmd *qc)
 	struct ata_device *adev = qc->dev;
 
 	if (adev != ap->private_data) {
+		oldpiix_set_piomode(ap, adev);
 		if (adev->dma_mode)
 			oldpiix_set_dmamode(ap, adev);
-		else if (adev->pio_mode)
-			oldpiix_set_piomode(ap, adev);
 	}
 	return ata_qc_issue_prot(qc);
 }
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 36468ec..d10ae3e 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -320,14 +320,17 @@ static void pcmcia_remove_one(struct pcmcia_device *pdev)
 static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_FUNC_ID(4),
 	PCMCIA_DEVICE_MANF_CARD(0x0007, 0x0000),	/* Hitachi */
+	PCMCIA_DEVICE_MANF_CARD(0x000a, 0x0000),	/* I-O Data CFA */
+	PCMCIA_DEVICE_MANF_CARD(0x001c, 0x0001),	/* Mitsubishi CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x0704),
-	PCMCIA_DEVICE_MANF_CARD(0x0045, 0x0401),
+	PCMCIA_DEVICE_MANF_CARD(0x0045, 0x0401),	/* SanDisk CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x0098, 0x0000),	/* Toshiba */
 	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x002d),
 	PCMCIA_DEVICE_MANF_CARD(0x00ce, 0x0000),	/* Samsung */
  	PCMCIA_DEVICE_MANF_CARD(0x0319, 0x0000),	/* Hitachi */
 	PCMCIA_DEVICE_MANF_CARD(0x2080, 0x0001),
-	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0200),	/* Lexar */
+	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0100),	/* Viking CFA */
+	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0200),	/* Lexar, Viking CFA */
 	PCMCIA_DEVICE_PROD_ID123("Caravelle", "PSC-IDE ", "PSC000", 0x8c36137c, 0xd0693ab8, 0x2768a9f0),
 	PCMCIA_DEVICE_PROD_ID123("CDROM", "IDE", "MCD-601p", 0x1b9179ca, 0xede88951, 0x0d902f74),
 	PCMCIA_DEVICE_PROD_ID123("PCMCIA", "IDE CARD", "F1", 0x281f1c5d, 0x1907960c, 0xf7fde8b9),
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 479a326..02ea95f 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -42,6 +42,7 @@ static int pata_platform_set_mode(struct ata_port *ap, struct ata_device **unuse
 			dev->pio_mode = dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
 			dev->flags |= ATA_DFLAG_PIO;
+			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
 		}
 	}
 	return 0;
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 71a2bac..60fc598 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -71,6 +71,7 @@ static int rz1000_set_mode(struct ata_port *ap, struct ata_device **unused)
 			dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
 			dev->flags |= ATA_DFLAG_PIO;
+			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
 		}
 	}
 	return 0;
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
new file mode 100644
index 0000000..de04042
--- /dev/null
+++ b/drivers/ata/pata_scc.c

[---snip due to size; get from git repository---]

diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index ed79fab..5f10a33 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -33,7 +33,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_sil680"
-#define DRV_VERSION "0.4.1"
+#define DRV_VERSION "0.4.5"
 
 /**
  *	sil680_selreg		-	return register base
@@ -139,10 +139,13 @@ static void sil680_set_piomode(struct ata_port *ap, struct ata_device *adev)
 
 	unsigned long tfaddr = sil680_selreg(ap, 0x02);
 	unsigned long addr = sil680_seldev(ap, adev, 0x04);
+	unsigned long addr_mask = 0x80 + 4 * ap->port_no;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int pio = adev->pio_mode - XFER_PIO_0;
 	int lowest_pio = pio;
+	int port_shift = 4 * adev->devno;
 	u16 reg;
+	u8 mode;
 
 	struct ata_device *pair = ata_dev_pair(adev);
 
@@ -153,10 +156,17 @@ static void sil680_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	pci_write_config_word(pdev, tfaddr, speed_t[lowest_pio]);
 
 	pci_read_config_word(pdev, tfaddr-2, &reg);
+	pci_read_config_byte(pdev, addr_mask, &mode);
+	
 	reg &= ~0x0200;			/* Clear IORDY */
-	if (ata_pio_need_iordy(adev))
+	mode &= ~(3 << port_shift);	/* Clear IORDY and DMA bits */
+	
+	if (ata_pio_need_iordy(adev)) {
 		reg |= 0x0200;		/* Enable IORDY */
+		mode |= 1 << port_shift;
+	}
 	pci_write_config_word(pdev, tfaddr-2, reg);
+	pci_write_config_byte(pdev, addr_mask, mode);
 }
 
 /**
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 560103d..efa530b 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -32,9 +32,8 @@
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 #include <linux/ata.h>
-#include "libata.h"
+#include "sis.h"
 
-#undef DRV_NAME		/* already defined in libata.h, for libata-core */
 #define DRV_NAME	"pata_sis"
 #define DRV_VERSION	"0.4.5"
 
@@ -151,7 +150,7 @@ static int sis_66_pre_reset(struct ata_port *ap)
 
 	if (!pci_test_config_bits(pdev, &sis_enable_bits[ap->port_no])) {
 		ata_port_disable(ap);
-		printk(KERN_INFO "ata%u: port disabled. ignoring.\n", ap->id);
+		ata_port_printk(ap, KERN_INFO, "port disabled. ignoring.\n");
 		return 0;
 	}
 	/* Older chips keep cable detect in bits 4/5 of reg 0x48 */
@@ -197,7 +196,7 @@ static int sis_old_pre_reset(struct ata_port *ap)
 
 	if (!pci_test_config_bits(pdev, &sis_enable_bits[ap->port_no])) {
 		ata_port_disable(ap);
-		printk(KERN_INFO "ata%u: port disabled. ignoring.\n", ap->id);
+		ata_port_printk(ap, KERN_INFO, "port disabled. ignoring.\n");
 		return 0;
 	}
 	ap->cbl = ATA_CBL_PATA40;
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 96e890f..0720461 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -7,6 +7,13 @@
  * 		SL82C105/Winbond 553 IDE driver
  *
  * and in part on the documentation and errata sheet
+ *
+ *
+ * Note: The controller like many controllers has shared timings for
+ * PIO and DMA. We thus flip to the DMA timings in dma_start and flip back
+ * in the dma_stop function. Thus we actually don't need a set_dmamode
+ * method as the PIO method is always called and will set the right PIO
+ * timing parameters.
  */
 
 #include <linux/kernel.h>
@@ -19,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_sl82c105"
-#define DRV_VERSION "0.2.3"
+#define DRV_VERSION "0.2.5"
 
 enum {
 	/*
@@ -126,33 +133,6 @@ static void sl82c105_configure_dmamode(struct ata_port *ap, struct ata_device *a
 }
 
 /**
- *	sl82c105_set_dmamode	-	set initial DMA mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Called to do the DMA mode setup. This replaces the PIO timings
- *	for the device in question. Set appropriate PIO timings not DMA
- *	timings at this point.
- */
-
-static void sl82c105_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	switch(adev->dma_mode) {
-		case XFER_MW_DMA_0:
-			sl82c105_configure_piomode(ap, adev, 0);
-			break;
-		case XFER_MW_DMA_1:
-			sl82c105_configure_piomode(ap, adev, 3);
-			break;
-		case XFER_MW_DMA_2:
-			sl82c105_configure_piomode(ap, adev, 4);
-			break;
-		default:
-			BUG();
-	}
-}
-
-/**
  *	sl82c105_reset_engine	-	Reset the DMA engine
  *	@ap: ATA interface
  *
@@ -222,7 +202,7 @@ static void sl82c105_bmdma_stop(struct ata_queued_cmd *qc)
 
 	/* This will redo the initial setup of the DMA device to matching
 	   PIO timings */
-	sl82c105_set_dmamode(ap, qc->dev);
+	sl82c105_set_piomode(ap, qc->dev);
 }
 
 static struct scsi_host_template sl82c105_sht = {
@@ -246,7 +226,6 @@ static struct scsi_host_template sl82c105_sht = {
 static struct ata_port_operations sl82c105_port_ops = {
 	.port_disable	= ata_port_disable,
 	.set_piomode	= sl82c105_set_piomode,
-	.set_dmamode	= sl82c105_set_dmamode,
 	.mode_filter	= ata_pci_default_filter,
 
 	.tf_load	= ata_tf_load,
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 857ac23..37bab32 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -498,7 +498,7 @@ static inline unsigned int adma_intr_mmio(struct ata_host *host)
 				if ((status & ATA_BUSY))
 					continue;
 				DPRINTK("ata%u: protocol %d (dev_stat 0x%X)\n",
-					ap->id, qc->tf.protocol, status);
+					ap->print_id, qc->tf.protocol, status);
 
 				/* complete taskfile transaction */
 				pp->state = adma_state_idle;
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index d689df5..06867b9 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1276,7 +1276,7 @@ static void mv_err_intr(struct ata_port *ap, int reset_allowed)
 		pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
 	}
 	DPRINTK(KERN_ERR "ata%u: port error; EDMA err cause: 0x%08x "
-		"SERR: 0x%08x\n", ap->id, edma_err_cause, serr);
+		"SERR: 0x%08x\n", ap->print_id, edma_err_cause, serr);
 
 	/* Clear EDMA now that SERR cleanup done */
 	writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
@@ -2052,7 +2052,7 @@ static void mv_port_init(struct ata_ioports *port,  void __iomem *port_mmio)
 	port->altstatus_addr = port->ctl_addr = shd_base + SHD_CTL_AST_OFS;
 
 	/* unused: */
-	port->cmd_addr = port->bmdma_addr = port->scr_addr = 0;
+	port->cmd_addr = port->bmdma_addr = port->scr_addr = NULL;
 
 	/* Clear any currently outstanding port interrupt conditions */
 	serr_ofs = mv_scr_offset(SCR_ERROR);
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index ab92f20..783281e 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -219,6 +219,7 @@ struct nv_adma_port_priv {
 	void __iomem *		gen_block;
 	void __iomem *		notifier_clear_block;
 	u8			flags;
+	int			last_issue_ncq;
 };
 
 struct nv_host_priv {
@@ -254,10 +255,7 @@ static int nv_adma_port_suspend(struct ata_port *ap, pm_message_t mesg);
 static int nv_adma_port_resume(struct ata_port *ap);
 static void nv_adma_error_handler(struct ata_port *ap);
 static void nv_adma_host_stop(struct ata_host *host);
-static void nv_adma_bmdma_setup(struct ata_queued_cmd *qc);
-static void nv_adma_bmdma_start(struct ata_queued_cmd *qc);
-static void nv_adma_bmdma_stop(struct ata_queued_cmd *qc);
-static u8 nv_adma_bmdma_status(struct ata_port *ap);
+static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc);
 
 enum nv_host_type
 {
@@ -432,16 +430,16 @@ static const struct ata_port_operations nv_adma_ops = {
 	.exec_command		= ata_exec_command,
 	.check_status		= ata_check_status,
 	.dev_select		= ata_std_dev_select,
-	.bmdma_setup		= nv_adma_bmdma_setup,
-	.bmdma_start		= nv_adma_bmdma_start,
-	.bmdma_stop		= nv_adma_bmdma_stop,
-	.bmdma_status		= nv_adma_bmdma_status,
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
 	.qc_prep		= nv_adma_qc_prep,
 	.qc_issue		= nv_adma_qc_issue,
 	.freeze			= nv_ck804_freeze,
 	.thaw			= nv_ck804_thaw,
 	.error_handler		= nv_adma_error_handler,
-	.post_internal_cmd	= nv_adma_bmdma_stop,
+	.post_internal_cmd	= nv_adma_post_internal_cmd,
 	.data_xfer		= ata_data_xfer,
 	.irq_handler		= nv_adma_interrupt,
 	.irq_clear		= nv_adma_irq_clear,
@@ -661,29 +659,30 @@ static unsigned int nv_adma_tf_to_cpb(struct ata_taskfile *tf, __le16 *cpb)
 {
 	unsigned int idx = 0;
 
-	cpb[idx++] = cpu_to_le16((ATA_REG_DEVICE << 8) | tf->device | WNB);
-
-	if ((tf->flags & ATA_TFLAG_LBA48) == 0) {
-		cpb[idx++] = cpu_to_le16(IGN);
-		cpb[idx++] = cpu_to_le16(IGN);
-		cpb[idx++] = cpu_to_le16(IGN);
-		cpb[idx++] = cpu_to_le16(IGN);
-		cpb[idx++] = cpu_to_le16(IGN);
-	}
-	else {
-		cpb[idx++] = cpu_to_le16((ATA_REG_ERR   << 8) | tf->hob_feature);
-		cpb[idx++] = cpu_to_le16((ATA_REG_NSECT << 8) | tf->hob_nsect);
-		cpb[idx++] = cpu_to_le16((ATA_REG_LBAL  << 8) | tf->hob_lbal);
-		cpb[idx++] = cpu_to_le16((ATA_REG_LBAM  << 8) | tf->hob_lbam);
-		cpb[idx++] = cpu_to_le16((ATA_REG_LBAH  << 8) | tf->hob_lbah);
+	if(tf->flags & ATA_TFLAG_ISADDR) {
+		if (tf->flags & ATA_TFLAG_LBA48) {
+			cpb[idx++] = cpu_to_le16((ATA_REG_ERR   << 8) | tf->hob_feature | WNB);
+			cpb[idx++] = cpu_to_le16((ATA_REG_NSECT << 8) | tf->hob_nsect);
+			cpb[idx++] = cpu_to_le16((ATA_REG_LBAL  << 8) | tf->hob_lbal);
+			cpb[idx++] = cpu_to_le16((ATA_REG_LBAM  << 8) | tf->hob_lbam);
+			cpb[idx++] = cpu_to_le16((ATA_REG_LBAH  << 8) | tf->hob_lbah);
+			cpb[idx++] = cpu_to_le16((ATA_REG_ERR    << 8) | tf->feature);
+		} else
+			cpb[idx++] = cpu_to_le16((ATA_REG_ERR    << 8) | tf->feature | WNB);
+			
+		cpb[idx++] = cpu_to_le16((ATA_REG_NSECT  << 8) | tf->nsect);
+		cpb[idx++] = cpu_to_le16((ATA_REG_LBAL   << 8) | tf->lbal);
+		cpb[idx++] = cpu_to_le16((ATA_REG_LBAM   << 8) | tf->lbam);
+		cpb[idx++] = cpu_to_le16((ATA_REG_LBAH   << 8) | tf->lbah);
 	}
-	cpb[idx++] = cpu_to_le16((ATA_REG_ERR    << 8) | tf->feature);
-	cpb[idx++] = cpu_to_le16((ATA_REG_NSECT  << 8) | tf->nsect);
-	cpb[idx++] = cpu_to_le16((ATA_REG_LBAL   << 8) | tf->lbal);
-	cpb[idx++] = cpu_to_le16((ATA_REG_LBAM   << 8) | tf->lbam);
-	cpb[idx++] = cpu_to_le16((ATA_REG_LBAH   << 8) | tf->lbah);
+	
+	if(tf->flags & ATA_TFLAG_DEVICE)
+		cpb[idx++] = cpu_to_le16((ATA_REG_DEVICE << 8) | tf->device);
 
 	cpb[idx++] = cpu_to_le16((ATA_REG_CMD    << 8) | tf->command | CMDEND);
+	
+	while(idx < 12)
+		cpb[idx++] = cpu_to_le16(IGN);
 
 	return idx;
 }
@@ -741,6 +740,17 @@ static int nv_adma_check_cpb(struct ata_port *ap, int cpb_num, int force_err)
 			DPRINTK("Completing qc from tag %d with err_mask %u\n",cpb_num,
 				qc->err_mask);
 			ata_qc_complete(qc);
+		} else {
+			struct ata_eh_info *ehi = &ap->eh_info;
+			/* Notifier bits set without a command may indicate the drive
+			   is misbehaving. Raise host state machine violation on this
+			   condition. */
+			ata_port_printk(ap, KERN_ERR, "notifier for tag %d with no command?\n",
+				cpb_num);
+			ehi->err_mask |= AC_ERR_HSM;
+			ehi->action |= ATA_EH_SOFTRESET;
+			ata_port_freeze(ap);
+			return 1;
 		}
 	}
 	return 0;
@@ -852,22 +862,14 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 
 			if (status & (NV_ADMA_STAT_DONE |
 				      NV_ADMA_STAT_CPBERR)) {
+				u32 check_commands = notifier | notifier_error;
+				int pos, error = 0;
 				/** Check CPBs for completed commands */
-
-				if (ata_tag_valid(ap->active_tag)) {
-					/* Non-NCQ command */
-					nv_adma_check_cpb(ap, ap->active_tag,
-						notifier_error & (1 << ap->active_tag));
-				} else {
-					int pos, error = 0;
-					u32 active = ap->sactive;
-
-					while ((pos = ffs(active)) && !error) {
-						pos--;
-						error = nv_adma_check_cpb(ap, pos,
-							notifier_error & (1 << pos) );
-						active &= ~(1 << pos );
-					}
+				while ((pos = ffs(check_commands)) && !error) {
+					pos--;
+					error = nv_adma_check_cpb(ap, pos,
+						notifier_error & (1 << pos) );
+					check_commands &= ~(1 << pos );
 				}
 			}
 		}
@@ -905,73 +907,12 @@ static void nv_adma_irq_clear(struct ata_port *ap)
 	iowrite8(ioread8(dma_stat_addr), dma_stat_addr);
 }
 
-static void nv_adma_bmdma_setup(struct ata_queued_cmd *qc)
+static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc)
 {
-	struct ata_port *ap = qc->ap;
-	unsigned int rw = (qc->tf.flags & ATA_TFLAG_WRITE);
-	struct nv_adma_port_priv *pp = ap->private_data;
-	u8 dmactl;
-
-	if(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE)) {
-		WARN_ON(1);
-		return;
-	}
-
-	/* load PRD table addr. */
-	iowrite32(ap->prd_dma, ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
-
-	/* specify data direction, triple-check start bit is clear */
-	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-	dmactl &= ~(ATA_DMA_WR | ATA_DMA_START);
-	if (!rw)
-		dmactl |= ATA_DMA_WR;
-
-	iowrite8(dmactl, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
-	/* issue r/w command */
-	ata_exec_command(ap, &qc->tf);
-}
-
-static void nv_adma_bmdma_start(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct nv_adma_port_priv *pp = ap->private_data;
-	u8 dmactl;
-
-	if(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE)) {
-		WARN_ON(1);
-		return;
-	}
-
-	/* start host DMA transaction */
-	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-	iowrite8(dmactl | ATA_DMA_START,
-		 ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-}
-
-static void nv_adma_bmdma_stop(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct nv_adma_port_priv *pp = ap->private_data;
-
-	if(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE))
-		return;
-
-	/* clear start/stop bit */
-	iowrite8(ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD) & ~ATA_DMA_START,
-		 ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
-	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_altstatus(ap);        /* dummy read */
-}
-
-static u8 nv_adma_bmdma_status(struct ata_port *ap)
-{
-	struct nv_adma_port_priv *pp = ap->private_data;
-
-	WARN_ON(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE));
+	struct nv_adma_port_priv *pp = qc->ap->private_data;
 
-	return ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+	if(pp->flags & NV_ADMA_PORT_REGISTER_MODE)
+		ata_bmdma_post_internal_cmd(qc);
 }
 
 static int nv_adma_port_start(struct ata_port *ap)
@@ -1040,14 +981,15 @@ static int nv_adma_port_start(struct ata_port *ap)
 
 	/* clear GO for register mode, enable interrupt */
 	tmp = readw(mmio + NV_ADMA_CTL);
-	writew( (tmp & ~NV_ADMA_CTL_GO) | NV_ADMA_CTL_AIEN, mmio + NV_ADMA_CTL);
+	writew( (tmp & ~NV_ADMA_CTL_GO) | NV_ADMA_CTL_AIEN |
+		 NV_ADMA_CTL_HOTPLUG_IEN, mmio + NV_ADMA_CTL);
 
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readl( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
 	udelay(1);
 	writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readl( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
 
 	return 0;
 }
@@ -1099,14 +1041,15 @@ static int nv_adma_port_resume(struct ata_port *ap)
 
 	/* clear GO for register mode, enable interrupt */
 	tmp = readw(mmio + NV_ADMA_CTL);
-	writew((tmp & ~NV_ADMA_CTL_GO) | NV_ADMA_CTL_AIEN, mmio + NV_ADMA_CTL);
+	writew( (tmp & ~NV_ADMA_CTL_GO) | NV_ADMA_CTL_AIEN |
+		 NV_ADMA_CTL_HOTPLUG_IEN, mmio + NV_ADMA_CTL);
 
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readl( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
 	udelay(1);
 	writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-	readl( mmio + NV_ADMA_CTL );	/* flush posted write */
+	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
 
 	return 0;
 }
@@ -1163,11 +1106,7 @@ static void nv_adma_fill_aprd(struct ata_queued_cmd *qc,
 			      int idx,
 			      struct nv_adma_prd *aprd)
 {
-	u8 flags;
-
-	memset(aprd, 0, sizeof(struct nv_adma_prd));
-
-	flags = 0;
+	u8 flags = 0;
 	if (qc->tf.flags & ATA_TFLAG_WRITE)
 		flags |= NV_APRD_WRITE;
 	if (idx == qc->n_elem - 1)
@@ -1178,6 +1117,7 @@ static void nv_adma_fill_aprd(struct ata_queued_cmd *qc,
 	aprd->addr  = cpu_to_le64(((u64)sg_dma_address(sg)));
 	aprd->len   = cpu_to_le32(((u32)sg_dma_len(sg))); /* len in bytes */
 	aprd->flags = flags;
+	aprd->packet_len = 0;
 }
 
 static void nv_adma_fill_sg(struct ata_queued_cmd *qc, struct nv_adma_cpb *cpb)
@@ -1198,6 +1138,8 @@ static void nv_adma_fill_sg(struct ata_queued_cmd *qc, struct nv_adma_cpb *cpb)
 	}
 	if (idx > 5)
 		cpb->next_aprd = cpu_to_le64(((u64)(pp->aprd_dma + NV_ADMA_SGTBL_SZ * qc->tag)));
+	else
+		cpb->next_aprd = cpu_to_le64(0);
 }
 
 static int nv_adma_use_reg_mode(struct ata_queued_cmd *qc)
@@ -1230,7 +1172,10 @@ static void nv_adma_qc_prep(struct ata_queued_cmd *qc)
 		return;
 	}
 
-	memset(cpb, 0, sizeof(struct nv_adma_cpb));
+	cpb->resp_flags = NV_CPB_RESP_DONE;
+	wmb();
+	cpb->ctl_flags = 0;
+	wmb();
 
 	cpb->len		= 3;
 	cpb->tag		= qc->tag;
@@ -1254,12 +1199,15 @@ static void nv_adma_qc_prep(struct ata_queued_cmd *qc)
 	   finished filling in all of the contents */
 	wmb();
 	cpb->ctl_flags = ctl_flags;
+	wmb();
+	cpb->resp_flags = 0;
 }
 
 static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc)
 {
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 	void __iomem *mmio = pp->ctl_block;
+	int curr_ncq = (qc->tf.protocol == ATA_PROT_NCQ);
 
 	VPRINTK("ENTER\n");
 
@@ -1274,6 +1222,14 @@ static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc)
 	/* write append register, command tag in lower 8 bits
 	   and (number of cpbs to append -1) in top 8 bits */
 	wmb();
+
+	if(curr_ncq != pp->last_issue_ncq) {
+	   	/* Seems to need some delay before switching between NCQ and non-NCQ
+		   commands, else we get command timeouts and such. */
+		udelay(20);
+		pp->last_issue_ncq = curr_ncq;
+	}
+
 	writew(qc->tag, mmio + NV_ADMA_APPEND);
 
 	DPRINTK("Issued tag %u\n",qc->tag);
@@ -1446,6 +1402,30 @@ static void nv_adma_error_handler(struct ata_port *ap)
 		void __iomem *mmio = pp->ctl_block;
 		int i;
 		u16 tmp;
+		
+		if(ata_tag_valid(ap->active_tag) || ap->sactive) {
+			u32 notifier = readl(mmio + NV_ADMA_NOTIFIER);
+			u32 notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
+			u32 gen_ctl = readl(pp->gen_block + NV_ADMA_GEN_CTL);
+			u32 status = readw(mmio + NV_ADMA_STAT);
+			u8 cpb_count = readb(mmio + NV_ADMA_CPB_COUNT);
+			u8 next_cpb_idx = readb(mmio + NV_ADMA_NEXT_CPB_IDX);
+
+			ata_port_printk(ap, KERN_ERR, "EH in ADMA mode, notifier 0x%X "
+				"notifier_error 0x%X gen_ctl 0x%X status 0x%X "
+				"next cpb count 0x%X next cpb idx 0x%x\n",
+				notifier, notifier_error, gen_ctl, status,
+				cpb_count, next_cpb_idx);
+
+			for( i=0;i<NV_ADMA_MAX_CPBS;i++) {
+				struct nv_adma_cpb *cpb = &pp->cpb[i];
+				if( (ata_tag_valid(ap->active_tag) && i == ap->active_tag) ||
+				    ap->sactive & (1 << i) )
+					ata_port_printk(ap, KERN_ERR,
+						"CPB %d: ctl_flags 0x%x, resp_flags 0x%x\n",
+						i, cpb->ctl_flags, cpb->resp_flags);
+			}
+		}
 
 		/* Push us back into port register mode for error handling. */
 		nv_adma_register_mode(ap);
@@ -1460,10 +1440,10 @@ static void nv_adma_error_handler(struct ata_port *ap)
 		/* Reset channel */
 		tmp = readw(mmio + NV_ADMA_CTL);
 		writew(tmp | NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-		readl( mmio + NV_ADMA_CTL );	/* flush posted write */
+		readw( mmio + NV_ADMA_CTL );	/* flush posted write */
 		udelay(1);
 		writew(tmp & ~NV_ADMA_CTL_CHANNEL_RESET, mmio + NV_ADMA_CTL);
-		readl( mmio + NV_ADMA_CTL );	/* flush posted write */
+		readw( mmio + NV_ADMA_CTL );	/* flush posted write */
 	}
 
 	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset,
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 6097d8f..1558571 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -446,7 +446,7 @@ static inline unsigned int qs_intr_mmio(struct ata_host *host)
 				if ((status & ATA_BUSY))
 					continue;
 				DPRINTK("ata%u: protocol %d (dev_stat 0x%X)\n",
-					ap->id, qc->tf.protocol, status);
+					ap->print_id, qc->tf.protocol, status);
 
 				/* complete taskfile transaction */
 				pp->state = qs_state_idle;
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index dca3d37..1487255 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -339,7 +339,7 @@ static inline void __iomem *sil_scr_addr(struct ata_port *ap, unsigned int sc_re
 		break;
 	}
 
-	return 0;
+	return NULL;
 }
 
 static u32 sil_scr_read (struct ata_port *ap, unsigned int sc_reg)
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 49c9e2b..fd694b6 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -40,9 +40,8 @@
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include "libata.h"
+#include "sis.h"
 
-#undef DRV_NAME		/* already defined in libata.h, for libata-core */
 #define DRV_NAME	"sata_sis"
 #define DRV_VERSION	"0.7"
 
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 0ebd77b..4fb8bfc 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -421,7 +421,7 @@ static void pdc20621_dma_prep(struct ata_queued_cmd *qc)
 
 	WARN_ON(!(qc->flags & ATA_QCFLAG_DMAMAP));
 
-	VPRINTK("ata%u: ENTER\n", ap->id);
+	VPRINTK("ata%u: ENTER\n", ap->print_id);
 
 	/* hard-code chip #0 */
 	mmio += PDC_CHIP0_OFS;
@@ -478,7 +478,7 @@ static void pdc20621_nodata_prep(struct ata_queued_cmd *qc)
 	unsigned int portno = ap->port_no;
 	unsigned int i;
 
-	VPRINTK("ata%u: ENTER\n", ap->id);
+	VPRINTK("ata%u: ENTER\n", ap->print_id);
 
 	/* hard-code chip #0 */
 	mmio += PDC_CHIP0_OFS;
@@ -605,7 +605,7 @@ static void pdc20621_packet_start(struct ata_queued_cmd *qc)
 	/* hard-code chip #0 */
 	mmio += PDC_CHIP0_OFS;
 
-	VPRINTK("ata%u: ENTER\n", ap->id);
+	VPRINTK("ata%u: ENTER\n", ap->print_id);
 
 	wmb();			/* flush PRD, pkt writes */
 
@@ -672,7 +672,7 @@ static inline unsigned int pdc20621_host_intr( struct ata_port *ap,
 
 		/* step two - DMA from DIMM to host */
 		if (doing_hdma) {
-			VPRINTK("ata%u: read hdma, 0x%x 0x%x\n", ap->id,
+			VPRINTK("ata%u: read hdma, 0x%x 0x%x\n", ap->print_id,
 				readl(mmio + 0x104), readl(mmio + PDC_HDMA_CTLSTAT));
 			/* get drive status; clear intr; complete txn */
 			qc->err_mask |= ac_err_mask(ata_wait_idle(ap));
@@ -683,7 +683,7 @@ static inline unsigned int pdc20621_host_intr( struct ata_port *ap,
 		/* step one - exec ATA command */
 		else {
 			u8 seq = (u8) (port_no + 1 + 4);
-			VPRINTK("ata%u: read ata, 0x%x 0x%x\n", ap->id,
+			VPRINTK("ata%u: read ata, 0x%x 0x%x\n", ap->print_id,
 				readl(mmio + 0x104), readl(mmio + PDC_HDMA_CTLSTAT));
 
 			/* submit hdma pkt */
@@ -698,7 +698,7 @@ static inline unsigned int pdc20621_host_intr( struct ata_port *ap,
 		/* step one - DMA from host to DIMM */
 		if (doing_hdma) {
 			u8 seq = (u8) (port_no + 1);
-			VPRINTK("ata%u: write hdma, 0x%x 0x%x\n", ap->id,
+			VPRINTK("ata%u: write hdma, 0x%x 0x%x\n", ap->print_id,
 				readl(mmio + 0x104), readl(mmio + PDC_HDMA_CTLSTAT));
 
 			/* submit ata pkt */
@@ -711,7 +711,7 @@ static inline unsigned int pdc20621_host_intr( struct ata_port *ap,
 
 		/* step two - execute ATA command */
 		else {
-			VPRINTK("ata%u: write ata, 0x%x 0x%x\n", ap->id,
+			VPRINTK("ata%u: write ata, 0x%x 0x%x\n", ap->print_id,
 				readl(mmio + 0x104), readl(mmio + PDC_HDMA_CTLSTAT));
 			/* get drive status; clear intr; complete txn */
 			qc->err_mask |= ac_err_mask(ata_wait_idle(ap));
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index baca6d7..fe9101a 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -423,16 +423,21 @@ static struct ata_probe_ent *vt6420_init_probe_ent(struct pci_dev *pdev)
 {
 	struct ata_probe_ent *probe_ent;
 	struct ata_port_info *ppi[2];
-	void __iomem * const *iomap;
+	void __iomem *bar5;
 
 	ppi[0] = ppi[1] = &vt6420_port_info;
 	probe_ent = ata_pci_init_native_mode(pdev, ppi, ATA_PORT_PRIMARY | ATA_PORT_SECONDARY);
 	if (!probe_ent)
 		return NULL;
 
-	iomap = pcim_iomap_table(pdev);
-	probe_ent->port[0].scr_addr = svia_scr_addr(iomap[5], 0);
-	probe_ent->port[1].scr_addr = svia_scr_addr(iomap[5], 1);
+	bar5 = pcim_iomap(pdev, 5, 0);
+	if (!bar5) {
+		dev_printk(KERN_ERR, &pdev->dev, "failed to iomap PCI BAR 5\n");
+		return NULL;
+	}
+
+	probe_ent->port[0].scr_addr = svia_scr_addr(bar5, 0);
+	probe_ent->port[1].scr_addr = svia_scr_addr(bar5, 1);
 
 	return probe_ent;
 }
@@ -460,6 +465,13 @@ static struct ata_probe_ent *vt6421_init_probe_ent(struct pci_dev *pdev)
 	probe_ent->mwdma_mask	= 0x07;
 	probe_ent->udma_mask	= 0x7f;
 
+	for (i = 0; i < 6; i++)
+		if (!pcim_iomap(pdev, i, 0)) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "failed to iomap PCI BAR %d\n", i);
+			return NULL;
+		}
+
 	for (i = 0; i < N_PORTS; i++)
 		vt6421_init_addrs(probe_ent, pcim_iomap_table(pdev), i);
 
@@ -522,7 +534,7 @@ static int svia_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	rc = pcim_iomap_regions(pdev, 0x1f, DRV_NAME);
+	rc = pci_request_regions(pdev, DRV_NAME);
 	if (rc) {
 		pcim_pin_device(pdev);
 		return rc;
diff --git a/drivers/ata/sis.h b/drivers/ata/sis.h
new file mode 100644
index 0000000..231da8f
--- /dev/null
+++ b/drivers/ata/sis.h
@@ -0,0 +1,5 @@
+
+struct ata_port_info;
+
+/* pata_sis.c */
+extern struct ata_port_info sis_info133;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 272736e..c331da2 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -282,7 +282,6 @@ struct ata_taskfile {
 };
 
 #define ata_id_is_ata(id)	(((id)[0] & (1 << 15)) == 0)
-#define ata_id_is_sata(id)	((id)[93] == 0)
 #define ata_id_rahead_enabled(id) ((id)[85] & (1 << 6))
 #define ata_id_wcache_enabled(id) ((id)[85] & (1 << 5))
 #define ata_id_hpa_enabled(id)	((id)[85] & (1 << 10))
@@ -324,6 +323,11 @@ static inline unsigned int ata_id_major_version(const u16 *id)
 	return mver;
 }
 
+static inline int ata_id_is_sata(const u16 *id)
+{
+	return ata_id_major_version(id) >= 5 && id[93] == 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
@@ -350,7 +354,7 @@ static inline int ata_id_is_cfa(const u16 *id)
 
 static inline int ata_drive_40wire(const u16 *dev_id)
 {
-	if (ata_id_major_version(dev_id) >= 5 && ata_id_is_sata(dev_id))
+	if (ata_id_is_sata(dev_id))
 		return 0;	/* SATA */
 	if ((dev_id[93] & 0xE000) == 0x6000)
 		return 0;	/* 80 wire */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 86762a9..1f2099d 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -495,6 +495,7 @@ struct ata_device {
 
 	/* error history */
 	struct ata_ering	ering;
+	int			spdn_cnt;
 	unsigned int		horkage;	/* List of broken features */
 #ifdef CONFIG_SATA_ACPI
 	/* ACPI objects info */
@@ -535,8 +536,8 @@ struct ata_port {
 	spinlock_t		*lock;
 	unsigned long		flags;	/* ATA_FLAG_xxx */
 	unsigned int		pflags; /* ATA_PFLAG_xxx */
-	unsigned int		id;	/* unique id req'd by scsi midlyr */
-	unsigned int		port_no; /* unique port #; from zero */
+	unsigned int		print_id; /* user visible unique port ID */
+	unsigned int		port_no; /* 0 based port no. inside the host */
 
 	struct ata_prd		*prd;	 /* our SG list */
 	dma_addr_t		prd_dma; /* and its DMA mapping */
@@ -759,6 +760,7 @@ extern void ata_port_queue_task(struct ata_port *ap, work_func_t fn,
 extern u32 ata_wait_register(void __iomem *reg, u32 mask, u32 val,
 			     unsigned long interval_msec,
 			     unsigned long timeout_msec);
+extern unsigned int ata_dev_try_classify(struct ata_port *, unsigned int, u8 *);
 
 /*
  * Default driver ops implementations
@@ -890,10 +892,10 @@ extern void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
  * printk helpers
  */
 #define ata_port_printk(ap, lv, fmt, args...) \
-	printk(lv"ata%u: "fmt, (ap)->id , ##args)
+	printk(lv"ata%u: "fmt, (ap)->print_id , ##args)
 
 #define ata_dev_printk(dev, lv, fmt, args...) \
-	printk(lv"ata%u.%02u: "fmt, (dev)->ap->id, (dev)->devno , ##args)
+	printk(lv"ata%u.%02u: "fmt, (dev)->ap->print_id, (dev)->devno , ##args)
 
 /*
  * ata_eh_info helpers
@@ -1031,6 +1033,21 @@ static inline u8 ata_chk_status(struct ata_port *ap)
 	return ap->ops->check_status(ap);
 }
 
+/**
+ *	ata_ncq_enabled - Test whether NCQ is enabled
+ *	@dev: ATA device to test for
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	1 if NCQ is enabled for @dev, 0 otherwise.
+ */
+static inline int ata_ncq_enabled(struct ata_device *dev)
+{
+	return (dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ_OFF |
+			      ATA_DFLAG_NCQ)) == ATA_DFLAG_NCQ;
+}
 
 /**
  *	ata_pause - Flush writes and pause 400 nanoseconds.

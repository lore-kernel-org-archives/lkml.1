Return-Path: <linux-kernel-owner+w=401wt.eu-S938732AbXGTRiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938732AbXGTRiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763733AbXGTRgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:36:18 -0400
Received: from havoc.gtf.org ([69.61.125.42]:38709 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937423AbXGTRgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:36:10 -0400
X-Greylist: delayed 4497 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2007 13:36:09 EDT
Date: Fri, 20 Jul 2007 11:00:18 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20070720150018.GA20643@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Bug fixes, and 1/4 of Tejun's port multiplier work.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c          |  255 +++++++++++++++++++++++++------------------
 drivers/ata/libata-core.c   |   79 +++++++++-----
 drivers/ata/libata-eh.c     |  204 ++++++++++++++++++++++++++++++++---
 drivers/ata/libata-scsi.c   |   63 ++++++++---
 drivers/ata/libata-sff.c    |    4 +-
 drivers/ata/libata.h        |    3 +-
 drivers/ata/pata_platform.c |    5 +-
 drivers/ata/pata_scc.c      |   29 +++--
 drivers/ata/sata_inic162x.c |   16 ++--
 drivers/ata/sata_mv.c       |  203 ++++++++++++++++++++--------------
 drivers/ata/sata_nv.c       |   38 ++++---
 drivers/ata/sata_promise.c  |   25 +++--
 drivers/ata/sata_qstor.c    |   18 ++--
 drivers/ata/sata_sil.c      |   25 +++--
 drivers/ata/sata_sil24.c    |  139 ++++++++++++++++-------
 drivers/ata/sata_sis.c      |   22 ++--
 drivers/ata/sata_svw.c      |   13 +-
 drivers/ata/sata_uli.c      |   16 ++-
 drivers/ata/sata_via.c      |   27 +++--
 drivers/ata/sata_vsc.c      |   13 +-
 include/linux/libata.h      |   35 +++---
 21 files changed, 816 insertions(+), 416 deletions(-)

Akira Iguchi (1):
      pata_scc.c: small fixes (Workaround for errata A308)

Alexey Dobriyan (1):
      ahci.c: fix CONFIG_PM=n compilation

Dave Jones (1):
      Correct comment in libata-sff.c

Jeff Garzik (2):
      [libata] sata_mv: Micro-optimization and cleanups
      [libata] sata_mv: minor cleanups

Magnus Damm (1):
      pata_platform: Fix NULL pointer dereference

Petr Vandrovec (1):
      [libata] Fix reported task file values in sense data

Tejun Heo (21):
      libata: add ST9160821AS 3.CLF to NONCQ blacklist
      libata: add @is_cmd to ata_tf_to_fis()
      ahci: use deadline instead of fixed timeout for 1st FIS for SRST
      ahci: separate out ahci_kick_engine()
      ahci: separate out ahci_exec_polled_cmd()
      ahci: separate out ahci_do_softreset()
      sata_sil24: replace sil24_update_tf() with sil24_read_tf()
      sata_sil24: separate out sil24_exec_polled_cmd()
      sata_sil24: separate out sil24_do_softreset()
      libata: improve EH report formatting
      libata: implement AC_ERR_NCQ
      libata: make ->scr_read/write callbacks return error code
      ahci: make NO_NCQ handling more consistent
      ahci: implement SCR_NOTIFICATION r/w
      libata: improve SATA PHY speed down logic
      libata: quickly trigger SATA SPD down after debouncing failed
      libata: improve SCSI scan failure handling
      libata: reorganize ata_ehi_hotplugged()
      libata: clear HOTPLUG flag after a reset
      libata: schedule probing after SError access failure during autopsy
      libata: implement EH fast drain

su henry (1):
      The SATA controller device ID is different according to

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 11e4eb9..06f212f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -99,6 +99,7 @@ enum {
 	HOST_CAP_SSC		= (1 << 14), /* Slumber capable */
 	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
 	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
+	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
 	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
 	HOST_CAP_64		= (1 << 31), /* PCI DAC (64-bit DMA) support */
 
@@ -113,11 +114,11 @@ enum {
 	PORT_TFDATA		= 0x20,	/* taskfile data */
 	PORT_SIG		= 0x24,	/* device TF signature */
 	PORT_CMD_ISSUE		= 0x38, /* command issue */
-	PORT_SCR		= 0x28, /* SATA phy register block */
 	PORT_SCR_STAT		= 0x28, /* SATA phy register: SStatus */
 	PORT_SCR_CTL		= 0x2c, /* SATA phy register: SControl */
 	PORT_SCR_ERR		= 0x30, /* SATA phy register: SError */
 	PORT_SCR_ACT		= 0x34, /* SATA phy register: SActive */
+	PORT_SCR_NTF		= 0x3c, /* SATA phy register: SNotification */
 
 	/* PORT_IRQ_{STAT,MASK} bits */
 	PORT_IRQ_COLD_PRES	= (1 << 31), /* cold presence detect */
@@ -216,8 +217,8 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_sdb:1;
 };
 
-static u32 ahci_scr_read (struct ata_port *ap, unsigned int sc_reg);
-static void ahci_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
+static int ahci_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 static int ahci_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
 static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 static void ahci_irq_clear(struct ata_port *ap);
@@ -417,7 +418,10 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 
 	/* ATI */
 	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 */
-	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb600 }, /* ATI SB700 */
+	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb600 }, /* ATI SB700 IDE */
+	{ PCI_VDEVICE(ATI, 0x4391), board_ahci_sb600 }, /* ATI SB700 AHCI */
+	{ PCI_VDEVICE(ATI, 0x4392), board_ahci_sb600 }, /* ATI SB700 nraid5 */
+	{ PCI_VDEVICE(ATI, 0x4393), board_ahci_sb600 }, /* ATI SB700 raid5 */
 
 	/* VIA */
 	{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */
@@ -545,13 +549,19 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 	hpriv->saved_cap = cap = readl(mmio + HOST_CAP);
 	hpriv->saved_port_map = port_map = readl(mmio + HOST_PORTS_IMPL);
 
-	/* some chips lie about 64bit support */
+	/* some chips have errata preventing 64bit use */
 	if ((cap & HOST_CAP_64) && (pi->flags & AHCI_FLAG_32BIT_ONLY)) {
 		dev_printk(KERN_INFO, &pdev->dev,
 			   "controller can't do 64bit DMA, forcing 32bit\n");
 		cap &= ~HOST_CAP_64;
 	}
 
+	if ((cap & HOST_CAP_NCQ) && (pi->flags & AHCI_FLAG_NO_NCQ)) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "controller can't do NCQ, turning off CAP_NCQ\n");
+		cap &= ~HOST_CAP_NCQ;
+	}
+
 	/* fixup zero port_map */
 	if (!port_map) {
 		port_map = (1 << ahci_nr_ports(cap)) - 1;
@@ -625,38 +635,45 @@ static void ahci_restore_initial_config(struct ata_host *host)
 	(void) readl(mmio + HOST_PORTS_IMPL);	/* flush */
 }
 
-static u32 ahci_scr_read (struct ata_port *ap, unsigned int sc_reg_in)
+static unsigned ahci_scr_offset(struct ata_port *ap, unsigned int sc_reg)
 {
-	unsigned int sc_reg;
-
-	switch (sc_reg_in) {
-	case SCR_STATUS:	sc_reg = 0; break;
-	case SCR_CONTROL:	sc_reg = 1; break;
-	case SCR_ERROR:		sc_reg = 2; break;
-	case SCR_ACTIVE:	sc_reg = 3; break;
-	default:
-		return 0xffffffffU;
-	}
+	static const int offset[] = {
+		[SCR_STATUS]		= PORT_SCR_STAT,
+		[SCR_CONTROL]		= PORT_SCR_CTL,
+		[SCR_ERROR]		= PORT_SCR_ERR,
+		[SCR_ACTIVE]		= PORT_SCR_ACT,
+		[SCR_NOTIFICATION]	= PORT_SCR_NTF,
+	};
+	struct ahci_host_priv *hpriv = ap->host->private_data;
 
-	return readl(ap->ioaddr.scr_addr + (sc_reg * 4));
+	if (sc_reg < ARRAY_SIZE(offset) &&
+	    (sc_reg != SCR_NOTIFICATION || (hpriv->cap & HOST_CAP_SNTF)))
+		return offset[sc_reg];
+	return 0;
 }
 
-
-static void ahci_scr_write (struct ata_port *ap, unsigned int sc_reg_in,
-			       u32 val)
+static int ahci_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
-	unsigned int sc_reg;
-
-	switch (sc_reg_in) {
-	case SCR_STATUS:	sc_reg = 0; break;
-	case SCR_CONTROL:	sc_reg = 1; break;
-	case SCR_ERROR:		sc_reg = 2; break;
-	case SCR_ACTIVE:	sc_reg = 3; break;
-	default:
-		return;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	int offset = ahci_scr_offset(ap, sc_reg);
+
+	if (offset) {
+		*val = readl(port_mmio + offset);
+		return 0;
 	}
+	return -EINVAL;
+}
 
-	writel(val, ap->ioaddr.scr_addr + (sc_reg * 4));
+static int ahci_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	int offset = ahci_scr_offset(ap, sc_reg);
+
+	if (offset) {
+		writel(val, port_mmio + offset);
+		return 0;
+	}
+	return -EINVAL;
 }
 
 static void ahci_start_engine(struct ata_port *ap)
@@ -948,37 +965,87 @@ static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 	pp->cmd_slot[tag].tbl_addr_hi = cpu_to_le32((cmd_tbl_dma >> 16) >> 16);
 }
 
-static int ahci_clo(struct ata_port *ap)
+static int ahci_kick_engine(struct ata_port *ap, int force_restart)
 {
 	void __iomem *port_mmio = ap->ioaddr.cmd_addr;
 	struct ahci_host_priv *hpriv = ap->host->private_data;
 	u32 tmp;
+	int busy, rc;
+
+	/* do we need to kick the port? */
+	busy = ahci_check_status(ap) & (ATA_BUSY | ATA_DRQ);
+	if (!busy && !force_restart)
+		return 0;
+
+	/* stop engine */
+	rc = ahci_stop_engine(ap);
+	if (rc)
+		goto out_restart;
 
-	if (!(hpriv->cap & HOST_CAP_CLO))
-		return -EOPNOTSUPP;
+	/* need to do CLO? */
+	if (!busy) {
+		rc = 0;
+		goto out_restart;
+	}
 
+	if (!(hpriv->cap & HOST_CAP_CLO)) {
+		rc = -EOPNOTSUPP;
+		goto out_restart;
+	}
+
+	/* perform CLO */
 	tmp = readl(port_mmio + PORT_CMD);
 	tmp |= PORT_CMD_CLO;
 	writel(tmp, port_mmio + PORT_CMD);
 
+	rc = 0;
 	tmp = ata_wait_register(port_mmio + PORT_CMD,
 				PORT_CMD_CLO, PORT_CMD_CLO, 1, 500);
 	if (tmp & PORT_CMD_CLO)
-		return -EIO;
+		rc = -EIO;
 
-	return 0;
+	/* restart engine */
+ out_restart:
+	ahci_start_engine(ap);
+	return rc;
 }
 
-static int ahci_softreset(struct ata_port *ap, unsigned int *class,
-			  unsigned long deadline)
+static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
+				struct ata_taskfile *tf, int is_cmd, u16 flags,
+				unsigned long timeout_msec)
 {
+	const u32 cmd_fis_len = 5; /* five dwords */
 	struct ahci_port_priv *pp = ap->private_data;
 	void __iomem *port_mmio = ahci_port_base(ap);
-	const u32 cmd_fis_len = 5; /* five dwords */
+	u8 *fis = pp->cmd_tbl;
+	u32 tmp;
+
+	/* prep the command */
+	ata_tf_to_fis(tf, pmp, is_cmd, fis);
+	ahci_fill_cmd_slot(pp, 0, cmd_fis_len | flags | (pmp << 12));
+
+	/* issue & wait */
+	writel(1, port_mmio + PORT_CMD_ISSUE);
+
+	if (timeout_msec) {
+		tmp = ata_wait_register(port_mmio + PORT_CMD_ISSUE, 0x1, 0x1,
+					1, timeout_msec);
+		if (tmp & 0x1) {
+			ahci_kick_engine(ap, 1);
+			return -EBUSY;
+		}
+	} else
+		readl(port_mmio + PORT_CMD_ISSUE);	/* flush */
+
+	return 0;
+}
+
+static int ahci_do_softreset(struct ata_port *ap, unsigned int *class,
+			     int pmp, unsigned long deadline)
+{
 	const char *reason = NULL;
+	unsigned long now, msecs;
 	struct ata_taskfile tf;
-	u32 tmp;
-	u8 *fis;
 	int rc;
 
 	DPRINTK("ENTER\n");
@@ -990,43 +1057,22 @@ static int ahci_softreset(struct ata_port *ap, unsigned int *class,
 	}
 
 	/* prepare for SRST (AHCI-1.1 10.4.1) */
-	rc = ahci_stop_engine(ap);
-	if (rc) {
-		reason = "failed to stop engine";
-		goto fail_restart;
-	}
-
-	/* check BUSY/DRQ, perform Command List Override if necessary */
-	if (ahci_check_status(ap) & (ATA_BUSY | ATA_DRQ)) {
-		rc = ahci_clo(ap);
-
-		if (rc == -EOPNOTSUPP) {
-			reason = "port busy but CLO unavailable";
-			goto fail_restart;
-		} else if (rc) {
-			reason = "port busy but CLO failed";
-			goto fail_restart;
-		}
-	}
-
-	/* restart engine */
-	ahci_start_engine(ap);
+	rc = ahci_kick_engine(ap, 1);
+	if (rc)
+		ata_port_printk(ap, KERN_WARNING,
+				"failed to reset engine (errno=%d)", rc);
 
 	ata_tf_init(ap->device, &tf);
-	fis = pp->cmd_tbl;
 
 	/* issue the first D2H Register FIS */
-	ahci_fill_cmd_slot(pp, 0,
-			   cmd_fis_len | AHCI_CMD_RESET | AHCI_CMD_CLR_BUSY);
+	msecs = 0;
+	now = jiffies;
+	if (time_after(now, deadline))
+		msecs = jiffies_to_msecs(deadline - now);
 
 	tf.ctl |= ATA_SRST;
-	ata_tf_to_fis(&tf, fis, 0);
-	fis[1] &= ~(1 << 7);	/* turn off Command FIS bit */
-
-	writel(1, port_mmio + PORT_CMD_ISSUE);
-
-	tmp = ata_wait_register(port_mmio + PORT_CMD_ISSUE, 0x1, 0x1, 1, 500);
-	if (tmp & 0x1) {
+	if (ahci_exec_polled_cmd(ap, pmp, &tf, 0,
+				 AHCI_CMD_RESET | AHCI_CMD_CLR_BUSY, msecs)) {
 		rc = -EIO;
 		reason = "1st FIS failed";
 		goto fail;
@@ -1036,14 +1082,8 @@ static int ahci_softreset(struct ata_port *ap, unsigned int *class,
 	msleep(1);
 
 	/* issue the second D2H Register FIS */
-	ahci_fill_cmd_slot(pp, 0, cmd_fis_len);
-
 	tf.ctl &= ~ATA_SRST;
-	ata_tf_to_fis(&tf, fis, 0);
-	fis[1] &= ~(1 << 7);	/* turn off Command FIS bit */
-
-	writel(1, port_mmio + PORT_CMD_ISSUE);
-	readl(port_mmio + PORT_CMD_ISSUE);	/* flush */
+	ahci_exec_polled_cmd(ap, pmp, &tf, 0, 0, 0);
 
 	/* spec mandates ">= 2ms" before checking status.
 	 * We wait 150ms, because that was the magic delay used for
@@ -1066,13 +1106,17 @@ static int ahci_softreset(struct ata_port *ap, unsigned int *class,
 	DPRINTK("EXIT, class=%u\n", *class);
 	return 0;
 
- fail_restart:
-	ahci_start_engine(ap);
  fail:
 	ata_port_printk(ap, KERN_ERR, "softreset failed (%s)\n", reason);
 	return rc;
 }
 
+static int ahci_softreset(struct ata_port *ap, unsigned int *class,
+			  unsigned long deadline)
+{
+	return ahci_do_softreset(ap, class, 0, deadline);
+}
+
 static int ahci_hardreset(struct ata_port *ap, unsigned int *class,
 			  unsigned long deadline)
 {
@@ -1088,7 +1132,7 @@ static int ahci_hardreset(struct ata_port *ap, unsigned int *class,
 	/* clear D2H reception area to properly wait for D2H FIS */
 	ata_tf_init(ap->device, &tf);
 	tf.command = 0x80;
-	ata_tf_to_fis(&tf, d2h_fis, 0);
+	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
 
 	rc = sata_std_hardreset(ap, class, deadline);
 
@@ -1106,6 +1150,7 @@ static int ahci_hardreset(struct ata_port *ap, unsigned int *class,
 static int ahci_vt8251_hardreset(struct ata_port *ap, unsigned int *class,
 				 unsigned long deadline)
 {
+	u32 serror;
 	int rc;
 
 	DPRINTK("ENTER\n");
@@ -1116,7 +1161,8 @@ static int ahci_vt8251_hardreset(struct ata_port *ap, unsigned int *class,
 				 deadline);
 
 	/* vt8251 needs SError cleared for the port to operate */
-	ahci_scr_write(ap, SCR_ERROR, ahci_scr_read(ap, SCR_ERROR));
+	ahci_scr_read(ap, SCR_ERROR, &serror);
+	ahci_scr_write(ap, SCR_ERROR, serror);
 
 	ahci_start_engine(ap);
 
@@ -1205,7 +1251,7 @@ static void ahci_qc_prep(struct ata_queued_cmd *qc)
 	 */
 	cmd_tbl = pp->cmd_tbl + qc->tag * AHCI_CMD_TBL_SZ;
 
-	ata_tf_to_fis(&qc->tf, cmd_tbl, 0);
+	ata_tf_to_fis(&qc->tf, 0, 1, cmd_tbl);
 	if (is_atapi) {
 		memset(cmd_tbl + AHCI_CMD_TBL_CDB, 0, 32);
 		memcpy(cmd_tbl + AHCI_CMD_TBL_CDB, qc->cdb, qc->dev->cdb_len);
@@ -1238,7 +1284,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 	ata_ehi_clear_desc(ehi);
 
 	/* AHCI needs SError cleared; otherwise, it might lock up */
-	serror = ahci_scr_read(ap, SCR_ERROR);
+	ahci_scr_read(ap, SCR_ERROR, &serror);
 	ahci_scr_write(ap, SCR_ERROR, serror);
 
 	/* analyze @irq_stat */
@@ -1262,12 +1308,12 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 	if (irq_stat & PORT_IRQ_IF_ERR) {
 		err_mask |= AC_ERR_ATA_BUS;
 		action |= ATA_EH_SOFTRESET;
-		ata_ehi_push_desc(ehi, ", interface fatal error");
+		ata_ehi_push_desc(ehi, "interface fatal error");
 	}
 
 	if (irq_stat & (PORT_IRQ_CONNECT | PORT_IRQ_PHYRDY)) {
 		ata_ehi_hotplugged(ehi);
-		ata_ehi_push_desc(ehi, ", %s", irq_stat & PORT_IRQ_CONNECT ?
+		ata_ehi_push_desc(ehi, "%s", irq_stat & PORT_IRQ_CONNECT ?
 			"connection status changed" : "PHY RDY changed");
 	}
 
@@ -1276,7 +1322,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 
 		err_mask |= AC_ERR_HSM;
 		action |= ATA_EH_SOFTRESET;
-		ata_ehi_push_desc(ehi, ", unknown FIS %08x %08x %08x %08x",
+		ata_ehi_push_desc(ehi, "unknown FIS %08x %08x %08x %08x",
 				  unk[0], unk[1], unk[2], unk[3]);
 	}
 
@@ -1512,11 +1558,17 @@ static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 
-	if (qc->flags & ATA_QCFLAG_FAILED) {
-		/* make DMA engine forget about the failed command */
-		ahci_stop_engine(ap);
-		ahci_start_engine(ap);
-	}
+	/* make DMA engine forget about the failed command */
+	if (qc->flags & ATA_QCFLAG_FAILED)
+		ahci_kick_engine(ap, 1);
+}
+
+static int ahci_port_resume(struct ata_port *ap)
+{
+	ahci_power_up(ap);
+	ahci_start_port(ap);
+
+	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -1536,14 +1588,6 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 	return rc;
 }
 
-static int ahci_port_resume(struct ata_port *ap)
-{
-	ahci_power_up(ap);
-	ahci_start_port(ap);
-
-	return 0;
-}
-
 static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
@@ -1734,12 +1778,13 @@ static void ahci_print_info(struct ata_host *host)
 
 	dev_printk(KERN_INFO, &pdev->dev,
 		"flags: "
-	       	"%s%s%s%s%s%s"
-	       	"%s%s%s%s%s%s%s\n"
+		"%s%s%s%s%s%s%s"
+		"%s%s%s%s%s%s%s\n"
 	       	,
 
 		cap & (1 << 31) ? "64bit " : "",
 		cap & (1 << 30) ? "ncq " : "",
+		cap & (1 << 29) ? "sntf " : "",
 		cap & (1 << 28) ? "ilck " : "",
 		cap & (1 << 27) ? "stag " : "",
 		cap & (1 << 26) ? "pm " : "",
@@ -1794,7 +1839,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ahci_save_initial_config(pdev, &pi, hpriv);
 
 	/* prepare host */
-	if (!(pi.flags & AHCI_FLAG_NO_NCQ) && (hpriv->cap & HOST_CAP_NCQ))
+	if (hpriv->cap & HOST_CAP_NCQ)
 		pi.flags |= ATA_FLAG_NCQ;
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, fls(hpriv->port_map));
@@ -1808,10 +1853,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		void __iomem *port_mmio = ahci_port_base(ap);
 
 		/* standard SATA port setup */
-		if (hpriv->port_map & (1 << i)) {
+		if (hpriv->port_map & (1 << i))
 			ap->ioaddr.cmd_addr = port_mmio;
-			ap->ioaddr.scr_addr = port_mmio + PORT_SCR;
-		}
 
 		/* disabled/not-implemented port */
 		else
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 88e2dd0..6001aae 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -111,8 +111,9 @@ MODULE_VERSION(DRV_VERSION);
 /**
  *	ata_tf_to_fis - Convert ATA taskfile to SATA FIS structure
  *	@tf: Taskfile to convert
- *	@fis: Buffer into which data will output
  *	@pmp: Port multiplier port
+ *	@is_cmd: This FIS is for command
+ *	@fis: Buffer into which data will output
  *
  *	Converts a standard ATA taskfile to a Serial ATA
  *	FIS structure (Register - Host to Device).
@@ -120,12 +121,13 @@ MODULE_VERSION(DRV_VERSION);
  *	LOCKING:
  *	Inherited from caller.
  */
-
-void ata_tf_to_fis(const struct ata_taskfile *tf, u8 *fis, u8 pmp)
+void ata_tf_to_fis(const struct ata_taskfile *tf, u8 pmp, int is_cmd, u8 *fis)
 {
-	fis[0] = 0x27;	/* Register - Host to Device FIS */
-	fis[1] = (pmp & 0xf) | (1 << 7); /* Port multiplier number,
-					    bit 7 indicates Command FIS */
+	fis[0] = 0x27;			/* Register - Host to Device FIS */
+	fis[1] = pmp & 0xf;		/* Port multiplier number*/
+	if (is_cmd)
+		fis[1] |= (1 << 7);	/* bit 7 indicates Command FIS */
+
 	fis[2] = tf->command;
 	fis[3] = tf->feature;
 
@@ -2387,21 +2389,35 @@ int sata_down_spd_limit(struct ata_port *ap)
 	u32 sstatus, spd, mask;
 	int rc, highbit;
 
+	if (!sata_scr_valid(ap))
+		return -EOPNOTSUPP;
+
+	/* If SCR can be read, use it to determine the current SPD.
+	 * If not, use cached value in ap->sata_spd.
+	 */
 	rc = sata_scr_read(ap, SCR_STATUS, &sstatus);
-	if (rc)
-		return rc;
+	if (rc == 0)
+		spd = (sstatus >> 4) & 0xf;
+	else
+		spd = ap->sata_spd;
 
 	mask = ap->sata_spd_limit;
 	if (mask <= 1)
 		return -EINVAL;
+
+	/* unconditionally mask off the highest bit */
 	highbit = fls(mask) - 1;
 	mask &= ~(1 << highbit);
 
-	spd = (sstatus >> 4) & 0xf;
-	if (spd <= 1)
-		return -EINVAL;
-	spd--;
-	mask &= (1 << spd) - 1;
+	/* Mask off all speeds higher than or equal to the current
+	 * one.  Force 1.5Gbps if current SPD is not available.
+	 */
+	if (spd > 1)
+		mask &= (1 << (spd - 1)) - 1;
+	else
+		mask &= 1;
+
+	/* were we already at the bottom? */
 	if (!mask)
 		return -EINVAL;
 
@@ -3251,9 +3267,11 @@ int sata_phy_debounce(struct ata_port *ap, const unsigned long *params,
 		last = cur;
 		last_jiffies = jiffies;
 
-		/* check deadline */
+		/* Check deadline.  If debouncing failed, return
+		 * -EPIPE to tell upper layer to lower link speed.
+		 */
 		if (time_after(jiffies, deadline))
-			return -EBUSY;
+			return -EPIPE;
 	}
 }
 
@@ -3769,6 +3787,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
 	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 	{ "FUJITSU MHV2080BH",	"00840028",	ATA_HORKAGE_NONCQ, },
+	{ "ST9160821AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
 
 	/* Devices with NCQ limits */
 
@@ -5729,10 +5748,8 @@ int sata_scr_valid(struct ata_port *ap)
  */
 int sata_scr_read(struct ata_port *ap, int reg, u32 *val)
 {
-	if (sata_scr_valid(ap)) {
-		*val = ap->ops->scr_read(ap, reg);
-		return 0;
-	}
+	if (sata_scr_valid(ap))
+		return ap->ops->scr_read(ap, reg, val);
 	return -EOPNOTSUPP;
 }
 
@@ -5754,10 +5771,8 @@ int sata_scr_read(struct ata_port *ap, int reg, u32 *val)
  */
 int sata_scr_write(struct ata_port *ap, int reg, u32 val)
 {
-	if (sata_scr_valid(ap)) {
-		ap->ops->scr_write(ap, reg, val);
-		return 0;
-	}
+	if (sata_scr_valid(ap))
+		return ap->ops->scr_write(ap, reg, val);
 	return -EOPNOTSUPP;
 }
 
@@ -5778,10 +5793,13 @@ int sata_scr_write(struct ata_port *ap, int reg, u32 val)
  */
 int sata_scr_write_flush(struct ata_port *ap, int reg, u32 val)
 {
+	int rc;
+
 	if (sata_scr_valid(ap)) {
-		ap->ops->scr_write(ap, reg, val);
-		ap->ops->scr_read(ap, reg);
-		return 0;
+		rc = ap->ops->scr_write(ap, reg, val);
+		if (rc == 0)
+			rc = ap->ops->scr_read(ap, reg, &val);
+		return rc;
 	}
 	return -EOPNOTSUPP;
 }
@@ -5993,6 +6011,7 @@ void ata_dev_init(struct ata_device *dev)
 
 	/* SATA spd limit is bound to the first device */
 	ap->sata_spd_limit = ap->hw_sata_spd_limit;
+	ap->sata_spd = 0;
 
 	/* High bits of dev->flags are used to record warm plug
 	 * requests which occur asynchronously.  Synchronize using
@@ -6058,6 +6077,9 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
 	INIT_LIST_HEAD(&ap->eh_done_q);
 	init_waitqueue_head(&ap->eh_wait_q);
+	init_timer_deferrable(&ap->fastdrain_timer);
+	ap->fastdrain_timer.function = ata_eh_fastdrain_timerfn;
+	ap->fastdrain_timer.data = (unsigned long)ap;
 
 	ap->cbl = ATA_CBL_NONE;
 
@@ -6434,7 +6456,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
-		ata_scsi_scan_host(ap);
+		ata_scsi_scan_host(ap, 1);
 	}
 
 	return 0;
@@ -6942,6 +6964,9 @@ EXPORT_SYMBOL_GPL(ata_pci_default_filter);
 EXPORT_SYMBOL_GPL(ata_pci_clear_simplex);
 #endif /* CONFIG_PCI */
 
+EXPORT_SYMBOL_GPL(__ata_ehi_push_desc);
+EXPORT_SYMBOL_GPL(ata_ehi_push_desc);
+EXPORT_SYMBOL_GPL(ata_ehi_clear_desc);
 EXPORT_SYMBOL_GPL(ata_eng_timeout);
 EXPORT_SYMBOL_GPL(ata_port_schedule_eh);
 EXPORT_SYMBOL_GPL(ata_port_abort);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 9aa62a0..ac6ceed 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -56,6 +56,7 @@ enum {
  */
 enum {
 	ATA_EH_PRERESET_TIMEOUT		= 10 * HZ,
+	ATA_EH_FASTDRAIN_INTERVAL	= 3 * HZ,
 };
 
 /* The following table determines how we sequence resets.  Each entry
@@ -85,6 +86,71 @@ static void ata_eh_handle_port_resume(struct ata_port *ap)
 { }
 #endif /* CONFIG_PM */
 
+static void __ata_ehi_pushv_desc(struct ata_eh_info *ehi, const char *fmt,
+				 va_list args)
+{
+	ehi->desc_len += vscnprintf(ehi->desc + ehi->desc_len,
+				     ATA_EH_DESC_LEN - ehi->desc_len,
+				     fmt, args);
+}
+
+/**
+ *	__ata_ehi_push_desc - push error description without adding separator
+ *	@ehi: target EHI
+ *	@fmt: printf format string
+ *
+ *	Format string according to @fmt and append it to @ehi->desc.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void __ata_ehi_push_desc(struct ata_eh_info *ehi, const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	__ata_ehi_pushv_desc(ehi, fmt, args);
+	va_end(args);
+}
+
+/**
+ *	ata_ehi_push_desc - push error description with separator
+ *	@ehi: target EHI
+ *	@fmt: printf format string
+ *
+ *	Format string according to @fmt and append it to @ehi->desc.
+ *	If @ehi->desc is not empty, ", " is added in-between.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_ehi_push_desc(struct ata_eh_info *ehi, const char *fmt, ...)
+{
+	va_list args;
+
+	if (ehi->desc_len)
+		__ata_ehi_push_desc(ehi, ", ");
+
+	va_start(args, fmt);
+	__ata_ehi_pushv_desc(ehi, fmt, args);
+	va_end(args);
+}
+
+/**
+ *	ata_ehi_clear_desc - clean error description
+ *	@ehi: target EHI
+ *
+ *	Clear @ehi->desc.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_ehi_clear_desc(struct ata_eh_info *ehi)
+{
+	ehi->desc[0] = '\0';
+	ehi->desc_len = 0;
+}
+
 static void ata_ering_record(struct ata_ering *ering, int is_io,
 			     unsigned int err_mask)
 {
@@ -296,6 +362,9 @@ void ata_scsi_error(struct Scsi_Host *host)
  repeat:
 	/* invoke error handler */
 	if (ap->ops->error_handler) {
+		/* kill fast drain timer */
+		del_timer_sync(&ap->fastdrain_timer);
+
 		/* process port resume request */
 		ata_eh_handle_port_resume(ap);
 
@@ -511,6 +580,94 @@ void ata_eng_timeout(struct ata_port *ap)
 	DPRINTK("EXIT\n");
 }
 
+static int ata_eh_nr_in_flight(struct ata_port *ap)
+{
+	unsigned int tag;
+	int nr = 0;
+
+	/* count only non-internal commands */
+	for (tag = 0; tag < ATA_MAX_QUEUE - 1; tag++)
+		if (ata_qc_from_tag(ap, tag))
+			nr++;
+
+	return nr;
+}
+
+void ata_eh_fastdrain_timerfn(unsigned long arg)
+{
+	struct ata_port *ap = (void *)arg;
+	unsigned long flags;
+	int cnt;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	cnt = ata_eh_nr_in_flight(ap);
+
+	/* are we done? */
+	if (!cnt)
+		goto out_unlock;
+
+	if (cnt == ap->fastdrain_cnt) {
+		unsigned int tag;
+
+		/* No progress during the last interval, tag all
+		 * in-flight qcs as timed out and freeze the port.
+		 */
+		for (tag = 0; tag < ATA_MAX_QUEUE - 1; tag++) {
+			struct ata_queued_cmd *qc = ata_qc_from_tag(ap, tag);
+			if (qc)
+				qc->err_mask |= AC_ERR_TIMEOUT;
+		}
+
+		ata_port_freeze(ap);
+	} else {
+		/* some qcs have finished, give it another chance */
+		ap->fastdrain_cnt = cnt;
+		ap->fastdrain_timer.expires =
+			jiffies + ATA_EH_FASTDRAIN_INTERVAL;
+		add_timer(&ap->fastdrain_timer);
+	}
+
+ out_unlock:
+	spin_unlock_irqrestore(ap->lock, flags);
+}
+
+/**
+ *	ata_eh_set_pending - set ATA_PFLAG_EH_PENDING and activate fast drain
+ *	@ap: target ATA port
+ *	@fastdrain: activate fast drain
+ *
+ *	Set ATA_PFLAG_EH_PENDING and activate fast drain if @fastdrain
+ *	is non-zero and EH wasn't pending before.  Fast drain ensures
+ *	that EH kicks in in timely manner.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+static void ata_eh_set_pending(struct ata_port *ap, int fastdrain)
+{
+	int cnt;
+
+	/* already scheduled? */
+	if (ap->pflags & ATA_PFLAG_EH_PENDING)
+		return;
+
+	ap->pflags |= ATA_PFLAG_EH_PENDING;
+
+	if (!fastdrain)
+		return;
+
+	/* do we have in-flight qcs? */
+	cnt = ata_eh_nr_in_flight(ap);
+	if (!cnt)
+		return;
+
+	/* activate fast drain */
+	ap->fastdrain_cnt = cnt;
+	ap->fastdrain_timer.expires = jiffies + ATA_EH_FASTDRAIN_INTERVAL;
+	add_timer(&ap->fastdrain_timer);
+}
+
 /**
  *	ata_qc_schedule_eh - schedule qc for error handling
  *	@qc: command to schedule error handling for
@@ -528,7 +685,7 @@ void ata_qc_schedule_eh(struct ata_queued_cmd *qc)
 	WARN_ON(!ap->ops->error_handler);
 
 	qc->flags |= ATA_QCFLAG_FAILED;
-	qc->ap->pflags |= ATA_PFLAG_EH_PENDING;
+	ata_eh_set_pending(ap, 1);
 
 	/* The following will fail if timeout has already expired.
 	 * ata_scsi_error() takes care of such scmds on EH entry.
@@ -555,7 +712,7 @@ void ata_port_schedule_eh(struct ata_port *ap)
 	if (ap->pflags & ATA_PFLAG_INITIALIZING)
 		return;
 
-	ap->pflags |= ATA_PFLAG_EH_PENDING;
+	ata_eh_set_pending(ap, 1);
 	scsi_schedule_eh(ap->scsi_host);
 
 	DPRINTK("port EH scheduled\n");
@@ -579,6 +736,9 @@ int ata_port_abort(struct ata_port *ap)
 
 	WARN_ON(!ap->ops->error_handler);
 
+	/* we're gonna abort all commands, no need for fast drain */
+	ata_eh_set_pending(ap, 0);
+
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		struct ata_queued_cmd *qc = ata_qc_from_tag(ap, tag);
 
@@ -1130,7 +1290,7 @@ static void ata_eh_analyze_ncq_error(struct ata_port *ap)
 	/* we've got the perpetrator, condemn it */
 	qc = __ata_qc_from_tag(ap, tag);
 	memcpy(&qc->result_tf, &tf, sizeof(tf));
-	qc->err_mask |= AC_ERR_DEV;
+	qc->err_mask |= AC_ERR_DEV | AC_ERR_NCQ;
 	ehc->i.err_mask &= ~AC_ERR_DEV;
 }
 
@@ -1413,8 +1573,12 @@ static void ata_eh_autopsy(struct ata_port *ap)
 	if (rc == 0) {
 		ehc->i.serror |= serror;
 		ata_eh_analyze_serror(ap);
-	} else if (rc != -EOPNOTSUPP)
+	} else if (rc != -EOPNOTSUPP) {
+		/* SError read failed, force hardreset and probing */
+		ata_ehi_schedule_probe(&ehc->i);
 		ehc->i.action |= ATA_EH_HARDRESET;
+		ehc->i.err_mask |= AC_ERR_OTHER;
+	}
 
 	/* analyze NCQ failure */
 	ata_eh_analyze_ncq_error(ap);
@@ -1524,14 +1688,14 @@ static void ata_eh_report(struct ata_port *ap)
 			       ehc->i.err_mask, ap->sactive, ehc->i.serror,
 			       ehc->i.action, frozen);
 		if (desc)
-			ata_dev_printk(ehc->i.dev, KERN_ERR, "(%s)\n", desc);
+			ata_dev_printk(ehc->i.dev, KERN_ERR, "%s\n", desc);
 	} else {
 		ata_port_printk(ap, KERN_ERR, "exception Emask 0x%x "
 				"SAct 0x%x SErr 0x%x action 0x%x%s\n",
 				ehc->i.err_mask, ap->sactive, ehc->i.serror,
 				ehc->i.action, frozen);
 		if (desc)
-			ata_port_printk(ap, KERN_ERR, "(%s)\n", desc);
+			ata_port_printk(ap, KERN_ERR, "%s\n", desc);
 	}
 
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
@@ -1551,7 +1715,7 @@ static void ata_eh_report(struct ata_port *ap)
 			"cmd %02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x "
 			"tag %d cdb 0x%x data %u %s\n         "
 			"res %02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x "
-			"Emask 0x%x (%s)\n",
+			"Emask 0x%x (%s)%s\n",
 			cmd->command, cmd->feature, cmd->nsect,
 			cmd->lbal, cmd->lbam, cmd->lbah,
 			cmd->hob_feature, cmd->hob_nsect,
@@ -1562,7 +1726,8 @@ static void ata_eh_report(struct ata_port *ap)
 			res->lbal, res->lbam, res->lbah,
 			res->hob_feature, res->hob_nsect,
 			res->hob_lbal, res->hob_lbam, res->hob_lbah,
-			res->device, qc->err_mask, ata_err_string(qc->err_mask));
+			res->device, qc->err_mask, ata_err_string(qc->err_mask),
+			qc->err_mask & AC_ERR_NCQ ? " <F>" : "");
 	}
 }
 
@@ -1648,7 +1813,7 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 			} else
 				ata_port_printk(ap, KERN_ERR,
 					"prereset failed (errno=%d)\n", rc);
-			return rc;
+			goto out;
 		}
 	}
 
@@ -1661,7 +1826,8 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 		/* prereset told us not to reset, bang classes and return */
 		for (i = 0; i < ATA_MAX_DEVICES; i++)
 			classes[i] = ATA_DEV_NONE;
-		return 0;
+		rc = 0;
+		goto out;
 	}
 
 	/* did prereset() screw up?  if so, fix up to avoid oopsing */
@@ -1697,7 +1863,8 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 			ata_port_printk(ap, KERN_ERR,
 					"follow-up softreset required "
 					"but no softreset avaliable\n");
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out;
 		}
 
 		ata_eh_about_to_do(ap, NULL, ATA_EH_RESET_MASK);
@@ -1707,7 +1874,8 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 		    classes[0] == ATA_DEV_UNKNOWN) {
 			ata_port_printk(ap, KERN_ERR,
 					"classification failed\n");
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out;
 		}
 	}
 
@@ -1724,7 +1892,7 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 			schedule_timeout_uninterruptible(delta);
 		}
 
-		if (reset == hardreset &&
+		if (rc == -EPIPE ||
 		    try == ARRAY_SIZE(ata_eh_reset_timeouts) - 1)
 			sata_down_spd_limit(ap);
 		if (hardreset)
@@ -1733,12 +1901,18 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 	}
 
 	if (rc == 0) {
+		u32 sstatus;
+
 		/* After the reset, the device state is PIO 0 and the
 		 * controller state is undefined.  Record the mode.
 		 */
 		for (i = 0; i < ATA_MAX_DEVICES; i++)
 			ap->device[i].pio_mode = XFER_PIO_0;
 
+		/* record current link speed */
+		if (sata_scr_read(ap, SCR_STATUS, &sstatus) == 0)
+			ap->sata_spd = (sstatus >> 4) & 0xf;
+
 		if (postreset)
 			postreset(ap, classes);
 
@@ -1746,7 +1920,9 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 		ata_eh_done(ap, NULL, ehc->i.action & ATA_EH_RESET_MASK);
 		ehc->i.action |= ATA_EH_REVALIDATE;
 	}
-
+ out:
+	/* clear hotplug flag */
+	ehc->i.flags &= ~ATA_EHI_HOTPLUGGED;
 	return rc;
 }
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index cfde22d..12ac0b5 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2947,17 +2947,22 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 	return rc;
 }
 
-void ata_scsi_scan_host(struct ata_port *ap)
+void ata_scsi_scan_host(struct ata_port *ap, int sync)
 {
+	int tries = 5;
+	struct ata_device *last_failed_dev = NULL;
+	struct ata_device *dev;
 	unsigned int i;
 
 	if (ap->flags & ATA_FLAG_DISABLED)
 		return;
 
+ repeat:
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
-		struct ata_device *dev = &ap->device[i];
 		struct scsi_device *sdev;
 
+		dev = &ap->device[i];
+
 		if (!ata_dev_enabled(dev) || dev->sdev)
 			continue;
 
@@ -2967,6 +2972,45 @@ void ata_scsi_scan_host(struct ata_port *ap)
 			scsi_device_put(sdev);
 		}
 	}
+
+	/* If we scanned while EH was in progress or allocation
+	 * failure occurred, scan would have failed silently.  Check
+	 * whether all devices are attached.
+	 */
+	for (i = 0; i < ATA_MAX_DEVICES; i++) {
+		dev = &ap->device[i];
+		if (ata_dev_enabled(dev) && !dev->sdev)
+			break;
+	}
+	if (i == ATA_MAX_DEVICES)
+		return;
+
+	/* we're missing some SCSI devices */
+	if (sync) {
+		/* If caller requested synchrnous scan && we've made
+		 * any progress, sleep briefly and repeat.
+		 */
+		if (dev != last_failed_dev) {
+			msleep(100);
+			last_failed_dev = dev;
+			goto repeat;
+		}
+
+		/* We might be failing to detect boot device, give it
+		 * a few more chances.
+		 */
+		if (--tries) {
+			msleep(100);
+			goto repeat;
+		}
+
+		ata_port_printk(ap, KERN_ERR, "WARNING: synchronous SCSI scan "
+				"failed without making any progress,\n"
+				"                  switching to async\n");
+	}
+
+	queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
+			   round_jiffies_relative(HZ));
 }
 
 /**
@@ -3093,20 +3137,7 @@ void ata_scsi_hotplug(struct work_struct *work)
 	}
 
 	/* scan for new ones */
-	ata_scsi_scan_host(ap);
-
-	/* If we scanned while EH was in progress, scan would have
-	 * failed silently.  Requeue if there are enabled but
-	 * unattached devices.
-	 */
-	for (i = 0; i < ATA_MAX_DEVICES; i++) {
-		struct ata_device *dev = &ap->device[i];
-		if (ata_dev_enabled(dev) && !dev->sdev) {
-			queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
-				round_jiffies_relative(HZ));
-			break;
-		}
-	}
+	ata_scsi_scan_host(ap, 0);
 
 	DPRINTK("EXIT\n");
 }
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index ca7d224..6c289c7 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1,5 +1,5 @@
 /*
- *  libata-bmdma.c - helper library for PCI IDE BMDMA
+ *  libata-sff.c - helper library for PCI IDE BMDMA
  *
  *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
  *    		    Please ALWAYS copy linux-ide@vger.kernel.org
@@ -211,6 +211,8 @@ void ata_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 		tf->hob_lbal = ioread8(ioaddr->lbal_addr);
 		tf->hob_lbam = ioread8(ioaddr->lbam_addr);
 		tf->hob_lbah = ioread8(ioaddr->lbah_addr);
+		iowrite8(tf->ctl, ioaddr->ctl_addr);
+		ap->last_ctl = tf->ctl;
 	}
 }
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index ba17fc5..564cd23 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -112,7 +112,7 @@ static inline int ata_acpi_on_devcfg(struct ata_device *adev) { return 0; }
 /* libata-scsi.c */
 extern int ata_scsi_add_hosts(struct ata_host *host,
 			      struct scsi_host_template *sht);
-extern void ata_scsi_scan_host(struct ata_port *ap);
+extern void ata_scsi_scan_host(struct ata_port *ap, int sync);
 extern int ata_scsi_offline_dev(struct ata_device *dev);
 extern void ata_scsi_hotplug(struct work_struct *work);
 extern unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf,
@@ -151,6 +151,7 @@ extern int ata_bus_probe(struct ata_port *ap);
 extern enum scsi_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
 extern void ata_scsi_error(struct Scsi_Host *host);
 extern void ata_port_wait_eh(struct ata_port *ap);
+extern void ata_eh_fastdrain_timerfn(unsigned long arg);
 extern void ata_qc_schedule_eh(struct ata_queued_cmd *qc);
 
 /* libata-sff.c */
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 79f841b..a909f79 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -213,8 +213,9 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 	pata_platform_setup_port(&ap->ioaddr, pp_info);
 
 	/* activate */
-	return ata_host_activate(host, platform_get_irq(pdev, 0), ata_interrupt,
-				 pp_info->irq_flags, &pata_platform_sht);
+	return ata_host_activate(host, platform_get_irq(pdev, 0),
+				 ata_interrupt, pp_info ? pp_info->irq_flags
+				 : 0, &pata_platform_sht);
 }
 
 /**
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index c55667e..36cdbd2 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -238,12 +238,6 @@ static void scc_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	else
 		offset = 0;	/* 100MHz */
 
-	/* errata A308 workaround: limit ATAPI UDMA mode to UDMA4 */
-	if (adev->class == ATA_DEV_ATAPI && speed > XFER_UDMA_4) {
-		printk(KERN_INFO "%s: limit ATAPI UDMA to UDMA4\n", DRV_NAME);
-		speed = XFER_UDMA_4;
-	}
-
 	if (speed >= XFER_UDMA_0)
 		idx = speed - XFER_UDMA_0;
 	else
@@ -264,6 +258,17 @@ static void scc_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 		 JCTSStbl[offset][idx] << 16 | JCENVTtbl[offset][idx]);
 }
 
+unsigned long scc_mode_filter(struct ata_device *adev, unsigned long mask)
+{
+	/* errata A308 workaround: limit ATAPI UDMA mode to UDMA4 */
+	if (adev->class == ATA_DEV_ATAPI &&
+	    (mask & (0xE0 << ATA_SHIFT_UDMA))) {
+		printk(KERN_INFO "%s: limit ATAPI UDMA to UDMA4\n", DRV_NAME);
+		mask &= ~(0xE0 << ATA_SHIFT_UDMA);
+	}
+	return ata_pci_default_filter(adev, mask);
+}
+
 /**
  *	scc_tf_load - send taskfile registers to host controller
  *	@ap: Port to which output is sent
@@ -358,6 +363,8 @@ static void scc_tf_read (struct ata_port *ap, struct ata_taskfile *tf)
 		tf->hob_lbal = in_be32(ioaddr->lbal_addr);
 		tf->hob_lbam = in_be32(ioaddr->lbam_addr);
 		tf->hob_lbah = in_be32(ioaddr->lbah_addr);
+		out_be32(ioaddr->ctl_addr, tf->ctl);
+		ap->last_ctl = tf->ctl;
 	}
 }
 
@@ -741,7 +748,7 @@ static u8 scc_bmdma_status (struct ata_port *ap)
 		return host_stat;
 
 	/* errata A252,A308 workaround: Step4 */
-	if (ata_altstatus(ap) & ATA_ERR && int_status & INTSTS_INTRQ)
+	if ((ata_altstatus(ap) & ATA_ERR) && (int_status & INTSTS_INTRQ))
 		return (host_stat | ATA_DMA_INTR);
 
 	/* errata A308 workaround Step5 */
@@ -752,11 +759,11 @@ static u8 scc_bmdma_status (struct ata_port *ap)
 		if ((qc->tf.protocol == ATA_PROT_DMA &&
 		     qc->dev->xfer_mode > XFER_UDMA_4)) {
 			if (!(int_status & INTSTS_ACTEINT)) {
-				printk(KERN_WARNING "ata%u: data lost occurred. (ACTEINT==0, retry:%d)\n",
-				       ap->print_id, retry);
+				printk(KERN_WARNING "ata%u: operation failed (transfer data loss)\n",
+				       ap->print_id);
 				host_stat |= ATA_DMA_ERR;
 				if (retry++)
-					ap->udma_mask >>= 1;
+					ap->udma_mask &= ~(1 << qc->dev->xfer_mode);
 			} else
 				retry = 0;
 		}
@@ -1016,7 +1023,7 @@ static const struct ata_port_operations scc_pata_ops = {
 	.port_disable		= ata_port_disable,
 	.set_piomode		= scc_set_piomode,
 	.set_dmamode		= scc_set_dmamode,
-	.mode_filter		= ata_pci_default_filter,
+	.mode_filter		= scc_mode_filter,
 
 	.tf_load		= scc_tf_load,
 	.tf_read		= scc_tf_read,
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 3de1834..a9c948d 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -190,34 +190,34 @@ static void inic_reset_port(void __iomem *port_base)
 	writew(ctl, idma_ctl);
 }
 
-static u32 inic_scr_read(struct ata_port *ap, unsigned sc_reg)
+static int inic_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val)
 {
 	void __iomem *scr_addr = ap->ioaddr.scr_addr;
 	void __iomem *addr;
-	u32 val;
 
 	if (unlikely(sc_reg >= ARRAY_SIZE(scr_map)))
-		return 0xffffffffU;
+		return -EINVAL;
 
 	addr = scr_addr + scr_map[sc_reg] * 4;
-	val = readl(scr_addr + scr_map[sc_reg] * 4);
+	*val = readl(scr_addr + scr_map[sc_reg] * 4);
 
 	/* this controller has stuck DIAG.N, ignore it */
 	if (sc_reg == SCR_ERROR)
-		val &= ~SERR_PHYRDY_CHG;
-	return val;
+		*val &= ~SERR_PHYRDY_CHG;
+	return 0;
 }
 
-static void inic_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val)
+static int inic_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val)
 {
 	void __iomem *scr_addr = ap->ioaddr.scr_addr;
 	void __iomem *addr;
 
 	if (unlikely(sc_reg >= ARRAY_SIZE(scr_map)))
-		return;
+		return -EINVAL;
 
 	addr = scr_addr + scr_map[sc_reg] * 4;
 	writel(val, scr_addr + scr_map[sc_reg] * 4);
+	return 0;
 }
 
 /*
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index fb8a749..8ec5208 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -35,8 +35,6 @@
 
   6) Add port multiplier support (intermediate)
 
-  7) Test and verify 3.0 Gbps support
-
   8) Develop a low-power-consumption strategy, and implement it.
 
   9) [Experiment, low priority] See if ATAPI can be supported using
@@ -227,26 +225,26 @@ enum {
 
 	EDMA_ERR_IRQ_CAUSE_OFS	= 0x8,
 	EDMA_ERR_IRQ_MASK_OFS	= 0xc,
-	EDMA_ERR_D_PAR		= (1 << 0),
-	EDMA_ERR_PRD_PAR	= (1 << 1),
-	EDMA_ERR_DEV		= (1 << 2),
-	EDMA_ERR_DEV_DCON	= (1 << 3),
-	EDMA_ERR_DEV_CON	= (1 << 4),
-	EDMA_ERR_SERR		= (1 << 5),
+	EDMA_ERR_D_PAR		= (1 << 0),	/* UDMA data parity err */
+	EDMA_ERR_PRD_PAR	= (1 << 1),	/* UDMA PRD parity err */
+	EDMA_ERR_DEV		= (1 << 2),	/* device error */
+	EDMA_ERR_DEV_DCON	= (1 << 3),	/* device disconnect */
+	EDMA_ERR_DEV_CON	= (1 << 4),	/* device connected */
+	EDMA_ERR_SERR		= (1 << 5),	/* SError bits [WBDST] raised */
 	EDMA_ERR_SELF_DIS	= (1 << 7),	/* Gen II/IIE self-disable */
 	EDMA_ERR_SELF_DIS_5	= (1 << 8),	/* Gen I self-disable */
-	EDMA_ERR_BIST_ASYNC	= (1 << 8),
+	EDMA_ERR_BIST_ASYNC	= (1 << 8),	/* BIST FIS or Async Notify */
 	EDMA_ERR_TRANS_IRQ_7	= (1 << 8),	/* Gen IIE transprt layer irq */
-	EDMA_ERR_CRBQ_PAR	= (1 << 9),
-	EDMA_ERR_CRPB_PAR	= (1 << 10),
-	EDMA_ERR_INTRL_PAR	= (1 << 11),
-	EDMA_ERR_IORDY		= (1 << 12),
-	EDMA_ERR_LNK_CTRL_RX	= (0xf << 13),
+	EDMA_ERR_CRQB_PAR	= (1 << 9),	/* CRQB parity error */
+	EDMA_ERR_CRPB_PAR	= (1 << 10),	/* CRPB parity error */
+	EDMA_ERR_INTRL_PAR	= (1 << 11),	/* internal parity error */
+	EDMA_ERR_IORDY		= (1 << 12),	/* IORdy timeout */
+	EDMA_ERR_LNK_CTRL_RX	= (0xf << 13),	/* link ctrl rx error */
 	EDMA_ERR_LNK_CTRL_RX_2	= (1 << 15),
-	EDMA_ERR_LNK_DATA_RX	= (0xf << 17),
-	EDMA_ERR_LNK_CTRL_TX	= (0x1f << 21),
-	EDMA_ERR_LNK_DATA_TX	= (0x1f << 26),
-	EDMA_ERR_TRANS_PROTO	= (1 << 31),
+	EDMA_ERR_LNK_DATA_RX	= (0xf << 17),	/* link data rx error */
+	EDMA_ERR_LNK_CTRL_TX	= (0x1f << 21),	/* link ctrl tx error */
+	EDMA_ERR_LNK_DATA_TX	= (0x1f << 26),	/* link data tx error */
+	EDMA_ERR_TRANS_PROTO	= (1 << 31),	/* transport protocol error */
 	EDMA_ERR_OVERRUN_5	= (1 << 5),
 	EDMA_ERR_UNDERRUN_5	= (1 << 6),
 	EDMA_EH_FREEZE		= EDMA_ERR_D_PAR |
@@ -255,7 +253,7 @@ enum {
 				  EDMA_ERR_DEV_CON |
 				  EDMA_ERR_SERR |
 				  EDMA_ERR_SELF_DIS |
-				  EDMA_ERR_CRBQ_PAR |
+				  EDMA_ERR_CRQB_PAR |
 				  EDMA_ERR_CRPB_PAR |
 				  EDMA_ERR_INTRL_PAR |
 				  EDMA_ERR_IORDY |
@@ -270,7 +268,7 @@ enum {
 				  EDMA_ERR_OVERRUN_5 |
 				  EDMA_ERR_UNDERRUN_5 |
 				  EDMA_ERR_SELF_DIS_5 |
-				  EDMA_ERR_CRBQ_PAR |
+				  EDMA_ERR_CRQB_PAR |
 				  EDMA_ERR_CRPB_PAR |
 				  EDMA_ERR_INTRL_PAR |
 				  EDMA_ERR_IORDY,
@@ -286,10 +284,10 @@ enum {
 	EDMA_RSP_Q_OUT_PTR_OFS	= 0x24,		/* also contains BASE_LO */
 	EDMA_RSP_Q_PTR_SHIFT	= 3,
 
-	EDMA_CMD_OFS		= 0x28,
-	EDMA_EN			= (1 << 0),
-	EDMA_DS			= (1 << 1),
-	ATA_RST			= (1 << 2),
+	EDMA_CMD_OFS		= 0x28,		/* EDMA command register */
+	EDMA_EN			= (1 << 0),	/* enable EDMA */
+	EDMA_DS			= (1 << 1),	/* disable EDMA; self-negated */
+	ATA_RST			= (1 << 2),	/* reset trans/link/phy */
 
 	EDMA_IORDY_TMOUT	= 0x34,
 	EDMA_ARB_CFG		= 0x38,
@@ -301,14 +299,13 @@ enum {
 	MV_HP_ERRATA_60X1B2	= (1 << 3),
 	MV_HP_ERRATA_60X1C0	= (1 << 4),
 	MV_HP_ERRATA_XX42A0	= (1 << 5),
-	MV_HP_GEN_I		= (1 << 6),
-	MV_HP_GEN_II		= (1 << 7),
-	MV_HP_GEN_IIE		= (1 << 8),
+	MV_HP_GEN_I		= (1 << 6),	/* Generation I: 50xx */
+	MV_HP_GEN_II		= (1 << 7),	/* Generation II: 60xx */
+	MV_HP_GEN_IIE		= (1 << 8),	/* Generation IIE: 6042/7042 */
 
 	/* Port private flags (pp_flags) */
-	MV_PP_FLAG_EDMA_EN	= (1 << 0),
-	MV_PP_FLAG_EDMA_DS_ACT	= (1 << 1),
-	MV_PP_FLAG_HAD_A_RESET	= (1 << 2),
+	MV_PP_FLAG_EDMA_EN	= (1 << 0),	/* is EDMA engine enabled? */
+	MV_PP_FLAG_HAD_A_RESET	= (1 << 2),	/* 1st hard reset complete? */
 };
 
 #define IS_GEN_I(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_I)
@@ -318,8 +315,12 @@ enum {
 enum {
 	MV_DMA_BOUNDARY		= 0xffffffffU,
 
+	/* mask of register bits containing lower 32 bits
+	 * of EDMA request queue DMA address
+	 */
 	EDMA_REQ_Q_BASE_LO_MASK	= 0xfffffc00U,
 
+	/* ditto, for response queue */
 	EDMA_RSP_Q_BASE_LO_MASK	= 0xffffff00U,
 };
 
@@ -403,10 +404,10 @@ struct mv_host_priv {
 };
 
 static void mv_irq_clear(struct ata_port *ap);
-static u32 mv_scr_read(struct ata_port *ap, unsigned int sc_reg_in);
-static void mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
-static u32 mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in);
-static void mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
+static int mv_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val);
+static int mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
+static int mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val);
+static int mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
 static int mv_port_start(struct ata_port *ap);
 static void mv_port_stop(struct ata_port *ap);
 static void mv_qc_prep(struct ata_queued_cmd *qc);
@@ -823,7 +824,7 @@ static void mv_start_dma(void __iomem *base, struct mv_host_priv *hpriv,
 }
 
 /**
- *      mv_stop_dma - Disable eDMA engine
+ *      __mv_stop_dma - Disable eDMA engine
  *      @ap: ATA channel to manipulate
  *
  *      Verify the local cache of the eDMA state is accurate with a
@@ -832,7 +833,7 @@ static void mv_start_dma(void __iomem *base, struct mv_host_priv *hpriv,
  *      LOCKING:
  *      Inherited from caller.
  */
-static int mv_stop_dma(struct ata_port *ap)
+static int __mv_stop_dma(struct ata_port *ap)
 {
 	void __iomem *port_mmio = mv_ap_base(ap);
 	struct mv_port_priv *pp	= ap->private_data;
@@ -865,6 +866,18 @@ static int mv_stop_dma(struct ata_port *ap)
 	return err;
 }
 
+static int mv_stop_dma(struct ata_port *ap)
+{
+	unsigned long flags;
+	int rc;
+
+	spin_lock_irqsave(&ap->host->lock, flags);
+	rc = __mv_stop_dma(ap);
+	spin_unlock_irqrestore(&ap->host->lock, flags);
+
+	return rc;
+}
+
 #ifdef ATA_DEBUG
 static void mv_dump_mem(void __iomem *start, unsigned bytes)
 {
@@ -961,22 +974,26 @@ static unsigned int mv_scr_offset(unsigned int sc_reg_in)
 	return ofs;
 }
 
-static u32 mv_scr_read(struct ata_port *ap, unsigned int sc_reg_in)
+static int mv_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val)
 {
 	unsigned int ofs = mv_scr_offset(sc_reg_in);
 
-	if (0xffffffffU != ofs)
-		return readl(mv_ap_base(ap) + ofs);
-	else
-		return (u32) ofs;
+	if (ofs != 0xffffffffU) {
+		*val = readl(mv_ap_base(ap) + ofs);
+		return 0;
+	} else
+		return -EINVAL;
 }
 
-static void mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
+static int mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
 {
 	unsigned int ofs = mv_scr_offset(sc_reg_in);
 
-	if (0xffffffffU != ofs)
+	if (ofs != 0xffffffffU) {
 		writelfl(val, mv_ap_base(ap) + ofs);
+		return 0;
+	} else
+		return -EINVAL;
 }
 
 static void mv_edma_cfg(struct ata_port *ap, struct mv_host_priv *hpriv,
@@ -1029,6 +1046,7 @@ static int mv_port_start(struct ata_port *ap)
 	void __iomem *port_mmio = mv_ap_base(ap);
 	void *mem;
 	dma_addr_t mem_dma;
+	unsigned long flags;
 	int rc;
 
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
@@ -1067,10 +1085,14 @@ static int mv_port_start(struct ata_port *ap)
 	pp->sg_tbl = mem;
 	pp->sg_tbl_dma = mem_dma;
 
+	spin_lock_irqsave(&ap->host->lock, flags);
+
 	mv_edma_cfg(ap, hpriv, port_mmio);
 
 	mv_set_edma_ptrs(port_mmio, hpriv, pp);
 
+	spin_unlock_irqrestore(&ap->host->lock, flags);
+
 	/* Don't turn on EDMA here...do it before DMA commands only.  Else
 	 * we'll be unable to send non-data, PIO, etc due to restricted access
 	 * to shadow regs.
@@ -1090,11 +1112,7 @@ static int mv_port_start(struct ata_port *ap)
  */
 static void mv_port_stop(struct ata_port *ap)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&ap->host->lock, flags);
 	mv_stop_dma(ap);
-	spin_unlock_irqrestore(&ap->host->lock, flags);
 }
 
 /**
@@ -1325,7 +1343,7 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 		 * port.  Turn off EDMA so there won't be problems accessing
 		 * shadow block, etc registers.
 		 */
-		mv_stop_dma(ap);
+		__mv_stop_dma(ap);
 		return ata_qc_issue_prot(qc);
 	}
 
@@ -1393,16 +1411,16 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 	if (edma_err_cause & EDMA_ERR_DEV)
 		err_mask |= AC_ERR_DEV;
 	if (edma_err_cause & (EDMA_ERR_D_PAR | EDMA_ERR_PRD_PAR |
-			EDMA_ERR_CRBQ_PAR | EDMA_ERR_CRPB_PAR |
+			EDMA_ERR_CRQB_PAR | EDMA_ERR_CRPB_PAR |
 			EDMA_ERR_INTRL_PAR)) {
 		err_mask |= AC_ERR_ATA_BUS;
 		action |= ATA_EH_HARDRESET;
-		ata_ehi_push_desc(ehi, ", parity error");
+		ata_ehi_push_desc(ehi, "parity error");
 	}
 	if (edma_err_cause & (EDMA_ERR_DEV_DCON | EDMA_ERR_DEV_CON)) {
 		ata_ehi_hotplugged(ehi);
 		ata_ehi_push_desc(ehi, edma_err_cause & EDMA_ERR_DEV_DCON ?
-			", dev disconnect" : ", dev connect");
+			"dev disconnect" : "dev connect");
 	}
 
 	if (IS_GEN_I(hpriv)) {
@@ -1411,7 +1429,7 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 		if (edma_err_cause & EDMA_ERR_SELF_DIS_5) {
 			struct mv_port_priv *pp	= ap->private_data;
 			pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
-			ata_ehi_push_desc(ehi, ", EDMA self-disable");
+			ata_ehi_push_desc(ehi, "EDMA self-disable");
 		}
 	} else {
 		eh_freeze_mask = EDMA_EH_FREEZE;
@@ -1419,7 +1437,7 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 		if (edma_err_cause & EDMA_ERR_SELF_DIS) {
 			struct mv_port_priv *pp	= ap->private_data;
 			pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
-			ata_ehi_push_desc(ehi, ", EDMA self-disable");
+			ata_ehi_push_desc(ehi, "EDMA self-disable");
 		}
 
 		if (edma_err_cause & EDMA_ERR_SERR) {
@@ -1489,33 +1507,30 @@ static void mv_intr_edma(struct ata_port *ap)
 
 	while (1) {
 		u16 status;
+		unsigned int tag;
 
 		/* get s/w response queue last-read pointer, and compare */
 		out_index = pp->resp_idx & MV_MAX_Q_DEPTH_MASK;
 		if (in_index == out_index)
 			break;
 
-		 
 		/* 50xx: get active ATA command */
-		if (IS_GEN_I(hpriv)) 
-			qc = ata_qc_from_tag(ap, ap->active_tag);
+		if (IS_GEN_I(hpriv))
+			tag = ap->active_tag;
 
-		/* 60xx: get active ATA command via tag, to enable support
-		 * for queueing.  this works transparently for queued and
-		 * non-queued modes.
+		/* Gen II/IIE: get active ATA command via tag, to enable
+		 * support for queueing.  this works transparently for
+		 * queued and non-queued modes.
 		 */
-		else {
-			unsigned int tag;
+		else if (IS_GEN_II(hpriv))
+			tag = (le16_to_cpu(pp->crpb[out_index].id)
+				>> CRPB_IOID_SHIFT_6) & 0x3f;
 
-			if (IS_GEN_II(hpriv))
-				tag = (le16_to_cpu(pp->crpb[out_index].id)
-					>> CRPB_IOID_SHIFT_6) & 0x3f;
-			else
-				tag = (le16_to_cpu(pp->crpb[out_index].id)
-					>> CRPB_IOID_SHIFT_7) & 0x3f;
+		else /* IS_GEN_IIE */
+			tag = (le16_to_cpu(pp->crpb[out_index].id)
+				>> CRPB_IOID_SHIFT_7) & 0x3f;
 
-			qc = ata_qc_from_tag(ap, tag);
-		}
+		qc = ata_qc_from_tag(ap, tag);
 
 		/* lower 8 bits of status are EDMA_ERR_IRQ_CAUSE_OFS
 		 * bits (WARNING: might not necessarily be associated
@@ -1535,7 +1550,7 @@ static void mv_intr_edma(struct ata_port *ap)
 			ata_qc_complete(qc);
 		}
 
-		/* advance software response queue pointer, to 
+		/* advance software response queue pointer, to
 		 * indicate (after the loop completes) to hardware
 		 * that we have consumed a response queue entry.
 		 */
@@ -1741,26 +1756,30 @@ static unsigned int mv5_scr_offset(unsigned int sc_reg_in)
 	return ofs;
 }
 
-static u32 mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in)
+static int mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val)
 {
 	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
 	void __iomem *addr = mv5_phy_base(mmio, ap->port_no);
 	unsigned int ofs = mv5_scr_offset(sc_reg_in);
 
-	if (ofs != 0xffffffffU)
-		return readl(addr + ofs);
-	else
-		return (u32) ofs;
+	if (ofs != 0xffffffffU) {
+		*val = readl(addr + ofs);
+		return 0;
+	} else
+		return -EINVAL;
 }
 
-static void mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
+static int mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
 {
 	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
 	void __iomem *addr = mv5_phy_base(mmio, ap->port_no);
 	unsigned int ofs = mv5_scr_offset(sc_reg_in);
 
-	if (ofs != 0xffffffffU)
+	if (ofs != 0xffffffffU) {
 		writelfl(val, addr + ofs);
+		return 0;
+	} else
+		return -EINVAL;
 }
 
 static void mv5_reset_bus(struct pci_dev *pdev, void __iomem *mmio)
@@ -2138,9 +2157,17 @@ static void mv_phy_reset(struct ata_port *ap, unsigned int *class,
 
 	VPRINTK("ENTER, port %u, mmio 0x%p\n", ap->port_no, port_mmio);
 
-	DPRINTK("S-regs after ATA_RST: SStat 0x%08x SErr 0x%08x "
-		"SCtrl 0x%08x\n", mv_scr_read(ap, SCR_STATUS),
-		mv_scr_read(ap, SCR_ERROR), mv_scr_read(ap, SCR_CONTROL));
+#ifdef DEBUG
+	{
+		u32 sstatus, serror, scontrol;
+
+		mv_scr_read(ap, SCR_STATUS, &sstatus);
+		mv_scr_read(ap, SCR_ERROR, &serror);
+		mv_scr_read(ap, SCR_CONTROL, &scontrol);
+		DPRINTK("S-regs after ATA_RST: SStat 0x%08x SErr 0x%08x "
+			"SCtrl 0x%08x\n", status, serror, scontrol);
+	}
+#endif
 
 	/* Issue COMRESET via SControl */
 comreset_retry:
@@ -2164,9 +2191,17 @@ comreset_retry:
 	    (retry-- > 0))
 		goto comreset_retry;
 
-	DPRINTK("S-regs after PHY wake: SStat 0x%08x SErr 0x%08x "
-		"SCtrl 0x%08x\n", mv_scr_read(ap, SCR_STATUS),
-		mv_scr_read(ap, SCR_ERROR), mv_scr_read(ap, SCR_CONTROL));
+#ifdef DEBUG
+	{
+		u32 sstatus, serror, scontrol;
+
+		mv_scr_read(ap, SCR_STATUS, &sstatus);
+		mv_scr_read(ap, SCR_ERROR, &serror);
+		mv_scr_read(ap, SCR_CONTROL, &scontrol);
+		DPRINTK("S-regs after PHY wake: SStat 0x%08x SErr 0x%08x "
+			"SCtrl 0x%08x\n", sstatus, serror, scontrol);
+	}
+#endif
 
 	if (ata_port_offline(ap)) {
 		*class = ATA_DEV_NONE;
@@ -2209,7 +2244,7 @@ static int mv_prereset(struct ata_port *ap, unsigned long deadline)
 	struct mv_port_priv *pp	= ap->private_data;
 	struct ata_eh_context *ehc = &ap->eh_context;
 	int rc;
-	
+
 	rc = mv_stop_dma(ap);
 	if (rc)
 		ehc->i.action |= ATA_EH_HARDRESET;
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index db81e3e..0b58c4d 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -236,8 +236,8 @@ static void nv_ck804_host_stop(struct ata_host *host);
 static irqreturn_t nv_generic_interrupt(int irq, void *dev_instance);
 static irqreturn_t nv_nf2_interrupt(int irq, void *dev_instance);
 static irqreturn_t nv_ck804_interrupt(int irq, void *dev_instance);
-static u32 nv_scr_read (struct ata_port *ap, unsigned int sc_reg);
-static void nv_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int nv_scr_read (struct ata_port *ap, unsigned int sc_reg, u32 *val);
+static int nv_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 
 static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
@@ -715,19 +715,20 @@ static int nv_adma_check_cpb(struct ata_port *ap, int cpb_num, int force_err)
 		int freeze = 0;
 
 		ata_ehi_clear_desc(ehi);
-		ata_ehi_push_desc(ehi, "CPB resp_flags 0x%x", flags );
+		__ata_ehi_push_desc(ehi, "CPB resp_flags 0x%x: ", flags );
 		if (flags & NV_CPB_RESP_ATA_ERR) {
-			ata_ehi_push_desc(ehi, ": ATA error");
+			ata_ehi_push_desc(ehi, "ATA error");
 			ehi->err_mask |= AC_ERR_DEV;
 		} else if (flags & NV_CPB_RESP_CMD_ERR) {
-			ata_ehi_push_desc(ehi, ": CMD error");
+			ata_ehi_push_desc(ehi, "CMD error");
 			ehi->err_mask |= AC_ERR_DEV;
 		} else if (flags & NV_CPB_RESP_CPB_ERR) {
-			ata_ehi_push_desc(ehi, ": CPB error");
+			ata_ehi_push_desc(ehi, "CPB error");
 			ehi->err_mask |= AC_ERR_SYSTEM;
 			freeze = 1;
 		} else {
 			/* notifier error, but no error in CPB flags? */
+			ata_ehi_push_desc(ehi, "unknown");
 			ehi->err_mask |= AC_ERR_OTHER;
 			freeze = 1;
 		}
@@ -854,20 +855,21 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 				struct ata_eh_info *ehi = &ap->eh_info;
 
 				ata_ehi_clear_desc(ehi);
-				ata_ehi_push_desc(ehi, "ADMA status 0x%08x", status );
+				__ata_ehi_push_desc(ehi, "ADMA status 0x%08x: ", status );
 				if (status & NV_ADMA_STAT_TIMEOUT) {
 					ehi->err_mask |= AC_ERR_SYSTEM;
-					ata_ehi_push_desc(ehi, ": timeout");
+					ata_ehi_push_desc(ehi, "timeout");
 				} else if (status & NV_ADMA_STAT_HOTPLUG) {
 					ata_ehi_hotplugged(ehi);
-					ata_ehi_push_desc(ehi, ": hotplug");
+					ata_ehi_push_desc(ehi, "hotplug");
 				} else if (status & NV_ADMA_STAT_HOTUNPLUG) {
 					ata_ehi_hotplugged(ehi);
-					ata_ehi_push_desc(ehi, ": hot unplug");
+					ata_ehi_push_desc(ehi, "hot unplug");
 				} else if (status & NV_ADMA_STAT_SERROR) {
 					/* let libata analyze SError and figure out the cause */
-					ata_ehi_push_desc(ehi, ": SError");
-				}
+					ata_ehi_push_desc(ehi, "SError");
+				} else
+					ata_ehi_push_desc(ehi, "unknown");
 				ata_port_freeze(ap);
 				continue;
 			}
@@ -1391,20 +1393,22 @@ static irqreturn_t nv_ck804_interrupt(int irq, void *dev_instance)
 	return ret;
 }
 
-static u32 nv_scr_read (struct ata_port *ap, unsigned int sc_reg)
+static int nv_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
-		return 0xffffffffU;
+		return -EINVAL;
 
-	return ioread32(ap->ioaddr.scr_addr + (sc_reg * 4));
+	*val = ioread32(ap->ioaddr.scr_addr + (sc_reg * 4));
+	return 0;
 }
 
-static void nv_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int nv_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
-		return;
+		return -EINVAL;
 
 	iowrite32(val, ap->ioaddr.scr_addr + (sc_reg * 4));
+	return 0;
 }
 
 static void nv_nf2_freeze(struct ata_port *ap)
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index d2fcb9a..d39ebc2 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -128,8 +128,8 @@ struct pdc_port_priv {
 	dma_addr_t		pkt_dma;
 };
 
-static u32 pdc_sata_scr_read (struct ata_port *ap, unsigned int sc_reg);
-static void pdc_sata_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int pdc_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
+static int pdc_sata_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 static int pdc_ata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
 static int pdc_common_port_start(struct ata_port *ap);
 static int pdc_sata_port_start(struct ata_port *ap);
@@ -427,19 +427,20 @@ static int pdc_sata_cable_detect(struct ata_port *ap)
 	return ATA_CBL_SATA;
 }
 
-static u32 pdc_sata_scr_read (struct ata_port *ap, unsigned int sc_reg)
+static int pdc_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
-		return 0xffffffffU;
-	return readl(ap->ioaddr.scr_addr + (sc_reg * 4));
+		return -EINVAL;
+	*val = readl(ap->ioaddr.scr_addr + (sc_reg * 4));
+	return 0;
 }
 
-static void pdc_sata_scr_write (struct ata_port *ap, unsigned int sc_reg,
-			       u32 val)
+static int pdc_sata_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
-		return;
+		return -EINVAL;
 	writel(val, ap->ioaddr.scr_addr + (sc_reg * 4));
+	return 0;
 }
 
 static void pdc_atapi_pkt(struct ata_queued_cmd *qc)
@@ -642,8 +643,12 @@ static void pdc_error_intr(struct ata_port *ap, struct ata_queued_cmd *qc,
 			   | PDC_PCI_SYS_ERR | PDC1_PCI_PARITY_ERR))
 		ac_err_mask |= AC_ERR_HOST_BUS;
 
-	if (sata_scr_valid(ap))
-		ehi->serror |= pdc_sata_scr_read(ap, SCR_ERROR);
+	if (sata_scr_valid(ap)) {
+		u32 serror;
+
+		pdc_sata_scr_read(ap, SCR_ERROR, &serror);
+		ehi->serror |= serror;
+	}
 
 	qc->err_mask |= ac_err_mask;
 
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 9ab554d..c8f9242 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -111,8 +111,8 @@ struct qs_port_priv {
 	qs_state_t		state;
 };
 
-static u32 qs_scr_read (struct ata_port *ap, unsigned int sc_reg);
-static void qs_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int qs_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
+static int qs_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 static int qs_ata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
 static int qs_port_start(struct ata_port *ap);
 static void qs_host_stop(struct ata_host *host);
@@ -255,18 +255,20 @@ static void qs_eng_timeout(struct ata_port *ap)
 	ata_eng_timeout(ap);
 }
 
-static u32 qs_scr_read (struct ata_port *ap, unsigned int sc_reg)
+static int qs_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
-		return ~0U;
-	return readl(ap->ioaddr.scr_addr + (sc_reg * 8));
+		return -EINVAL;
+	*val = readl(ap->ioaddr.scr_addr + (sc_reg * 8));
+	return 0;
 }
 
-static void qs_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int qs_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
-		return;
+		return -EINVAL;
 	writel(val, ap->ioaddr.scr_addr + (sc_reg * 8));
+	return 0;
 }
 
 static unsigned int qs_fill_sg(struct ata_queued_cmd *qc)
@@ -337,7 +339,7 @@ static void qs_qc_prep(struct ata_queued_cmd *qc)
 	buf[28] = dflags;
 
 	/* frame information structure (FIS) */
-	ata_tf_to_fis(&qc->tf, &buf[32], 0);
+	ata_tf_to_fis(&qc->tf, 0, 1, &buf[32]);
 }
 
 static inline void qs_packet_start(struct ata_queued_cmd *qc)
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 2a86dc4..db67637 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -115,8 +115,8 @@ static int sil_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
 static int sil_pci_device_resume(struct pci_dev *pdev);
 #endif
 static void sil_dev_config(struct ata_device *dev);
-static u32 sil_scr_read (struct ata_port *ap, unsigned int sc_reg);
-static void sil_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int sil_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
+static int sil_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 static int sil_set_mode (struct ata_port *ap, struct ata_device **r_failed);
 static void sil_freeze(struct ata_port *ap);
 static void sil_thaw(struct ata_port *ap);
@@ -350,19 +350,26 @@ static inline void __iomem *sil_scr_addr(struct ata_port *ap, unsigned int sc_re
 	return NULL;
 }
 
-static u32 sil_scr_read (struct ata_port *ap, unsigned int sc_reg)
+static int sil_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
 	void __iomem *mmio = sil_scr_addr(ap, sc_reg);
-	if (mmio)
-		return readl(mmio);
-	return 0xffffffffU;
+
+	if (mmio) {
+		*val = readl(mmio);
+		return 0;
+	}
+	return -EINVAL;
 }
 
-static void sil_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int sil_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
 	void __iomem *mmio = sil_scr_addr(ap, sc_reg);
-	if (mmio)
+
+	if (mmio) {
 		writel(val, mmio);
+		return 0;
+	}
+	return -EINVAL;
 }
 
 static void sil_host_intr(struct ata_port *ap, u32 bmdma2)
@@ -378,7 +385,7 @@ static void sil_host_intr(struct ata_port *ap, u32 bmdma2)
 		 * controllers continue to assert IRQ as long as
 		 * SError bits are pending.  Clear SError immediately.
 		 */
-		serror = sil_scr_read(ap, SCR_ERROR);
+		sil_scr_read(ap, SCR_ERROR, &serror);
 		sil_scr_write(ap, SCR_ERROR, serror);
 
 		/* Trigger hotplug and accumulate SError only if the
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index ac43a30..46fbbe7 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -326,8 +326,8 @@ struct sil24_port_priv {
 
 static void sil24_dev_config(struct ata_device *dev);
 static u8 sil24_check_status(struct ata_port *ap);
-static u32 sil24_scr_read(struct ata_port *ap, unsigned sc_reg);
-static void sil24_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val);
+static int sil24_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val);
+static int sil24_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val);
 static void sil24_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
 static void sil24_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int sil24_qc_issue(struct ata_queued_cmd *qc);
@@ -464,15 +464,15 @@ static void sil24_dev_config(struct ata_device *dev)
 		writel(PORT_CS_CDB16, port + PORT_CTRL_CLR);
 }
 
-static inline void sil24_update_tf(struct ata_port *ap)
+static void sil24_read_tf(struct ata_port *ap, int tag, struct ata_taskfile *tf)
 {
-	struct sil24_port_priv *pp = ap->private_data;
 	void __iomem *port = ap->ioaddr.cmd_addr;
-	struct sil24_prb __iomem *prb = port;
+	struct sil24_prb __iomem *prb;
 	u8 fis[6 * 4];
 
-	memcpy_fromio(fis, prb->fis, 6 * 4);
-	ata_tf_from_fis(fis, &pp->tf);
+	prb = port + PORT_LRAM + sil24_tag(tag) * PORT_LRAM_SLOT_SZ;
+	memcpy_fromio(fis, prb->fis, sizeof(fis));
+	ata_tf_from_fis(fis, tf);
 }
 
 static u8 sil24_check_status(struct ata_port *ap)
@@ -488,25 +488,30 @@ static int sil24_scr_map[] = {
 	[SCR_ACTIVE]	= 3,
 };
 
-static u32 sil24_scr_read(struct ata_port *ap, unsigned sc_reg)
+static int sil24_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val)
 {
 	void __iomem *scr_addr = ap->ioaddr.scr_addr;
+
 	if (sc_reg < ARRAY_SIZE(sil24_scr_map)) {
 		void __iomem *addr;
 		addr = scr_addr + sil24_scr_map[sc_reg] * 4;
-		return readl(scr_addr + sil24_scr_map[sc_reg] * 4);
+		*val = readl(scr_addr + sil24_scr_map[sc_reg] * 4);
+		return 0;
 	}
-	return 0xffffffffU;
+	return -EINVAL;
 }
 
-static void sil24_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val)
+static int sil24_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val)
 {
 	void __iomem *scr_addr = ap->ioaddr.scr_addr;
+
 	if (sc_reg < ARRAY_SIZE(sil24_scr_map)) {
 		void __iomem *addr;
 		addr = scr_addr + sil24_scr_map[sc_reg] * 4;
 		writel(val, scr_addr + sil24_scr_map[sc_reg] * 4);
+		return 0;
 	}
+	return -EINVAL;
 }
 
 static void sil24_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
@@ -531,15 +536,60 @@ static int sil24_init_port(struct ata_port *ap)
 	return 0;
 }
 
-static int sil24_softreset(struct ata_port *ap, unsigned int *class,
-			   unsigned long deadline)
+static int sil24_exec_polled_cmd(struct ata_port *ap, int pmp,
+				 const struct ata_taskfile *tf,
+				 int is_cmd, u32 ctrl,
+				 unsigned long timeout_msec)
 {
 	void __iomem *port = ap->ioaddr.cmd_addr;
 	struct sil24_port_priv *pp = ap->private_data;
 	struct sil24_prb *prb = &pp->cmd_block[0].ata.prb;
 	dma_addr_t paddr = pp->cmd_block_dma;
-	u32 mask, irq_stat;
+	u32 irq_enabled, irq_mask, irq_stat;
+	int rc;
+
+	prb->ctrl = cpu_to_le16(ctrl);
+	ata_tf_to_fis(tf, pmp, is_cmd, prb->fis);
+
+	/* temporarily plug completion and error interrupts */
+	irq_enabled = readl(port + PORT_IRQ_ENABLE_SET);
+	writel(PORT_IRQ_COMPLETE | PORT_IRQ_ERROR, port + PORT_IRQ_ENABLE_CLR);
+
+	writel((u32)paddr, port + PORT_CMD_ACTIVATE);
+	writel((u64)paddr >> 32, port + PORT_CMD_ACTIVATE + 4);
+
+	irq_mask = (PORT_IRQ_COMPLETE | PORT_IRQ_ERROR) << PORT_IRQ_RAW_SHIFT;
+	irq_stat = ata_wait_register(port + PORT_IRQ_STAT, irq_mask, 0x0,
+				     10, timeout_msec);
+
+	writel(irq_mask, port + PORT_IRQ_STAT); /* clear IRQs */
+	irq_stat >>= PORT_IRQ_RAW_SHIFT;
+
+	if (irq_stat & PORT_IRQ_COMPLETE)
+		rc = 0;
+	else {
+		/* force port into known state */
+		sil24_init_port(ap);
+
+		if (irq_stat & PORT_IRQ_ERROR)
+			rc = -EIO;
+		else
+			rc = -EBUSY;
+	}
+
+	/* restore IRQ enabled */
+	writel(irq_enabled, port + PORT_IRQ_ENABLE_SET);
+
+	return rc;
+}
+
+static int sil24_do_softreset(struct ata_port *ap, unsigned int *class,
+			      int pmp, unsigned long deadline)
+{
+	unsigned long timeout_msec = 0;
+	struct ata_taskfile tf;
 	const char *reason;
+	int rc;
 
 	DPRINTK("ENTER\n");
 
@@ -556,29 +606,22 @@ static int sil24_softreset(struct ata_port *ap, unsigned int *class,
 	}
 
 	/* do SRST */
-	prb->ctrl = cpu_to_le16(PRB_CTRL_SRST);
-	prb->fis[1] = 0; /* no PMP yet */
-
-	writel((u32)paddr, port + PORT_CMD_ACTIVATE);
-	writel((u64)paddr >> 32, port + PORT_CMD_ACTIVATE + 4);
-
-	mask = (PORT_IRQ_COMPLETE | PORT_IRQ_ERROR) << PORT_IRQ_RAW_SHIFT;
-	irq_stat = ata_wait_register(port + PORT_IRQ_STAT, mask, 0x0,
-				     100, jiffies_to_msecs(deadline - jiffies));
-
-	writel(irq_stat, port + PORT_IRQ_STAT); /* clear IRQs */
-	irq_stat >>= PORT_IRQ_RAW_SHIFT;
-
-	if (!(irq_stat & PORT_IRQ_COMPLETE)) {
-		if (irq_stat & PORT_IRQ_ERROR)
-			reason = "SRST command error";
-		else
-			reason = "timeout";
+	if (time_after(deadline, jiffies))
+		timeout_msec = jiffies_to_msecs(deadline - jiffies);
+
+	ata_tf_init(ap->device, &tf);	/* doesn't really matter */
+	rc = sil24_exec_polled_cmd(ap, pmp, &tf, 0, PRB_CTRL_SRST,
+				   timeout_msec);
+	if (rc == -EBUSY) {
+		reason = "timeout";
+		goto err;
+	} else if (rc) {
+		reason = "SRST command error";
 		goto err;
 	}
 
-	sil24_update_tf(ap);
-	*class = ata_dev_classify(&pp->tf);
+	sil24_read_tf(ap, 0, &tf);
+	*class = ata_dev_classify(&tf);
 
 	if (*class == ATA_DEV_UNKNOWN)
 		*class = ATA_DEV_NONE;
@@ -592,6 +635,12 @@ static int sil24_softreset(struct ata_port *ap, unsigned int *class,
 	return -EIO;
 }
 
+static int sil24_softreset(struct ata_port *ap, unsigned int *class,
+			   unsigned long deadline)
+{
+	return sil24_do_softreset(ap, class, 0, deadline);
+}
+
 static int sil24_hardreset(struct ata_port *ap, unsigned int *class,
 			   unsigned long deadline)
 {
@@ -699,7 +748,7 @@ static void sil24_qc_prep(struct ata_queued_cmd *qc)
 	}
 
 	prb->ctrl = cpu_to_le16(ctrl);
-	ata_tf_to_fis(&qc->tf, prb->fis, 0);
+	ata_tf_to_fis(&qc->tf, 0, 1, prb->fis);
 
 	if (qc->flags & ATA_QCFLAG_DMAMAP)
 		sil24_fill_sg(qc, sge);
@@ -754,6 +803,7 @@ static void sil24_thaw(struct ata_port *ap)
 static void sil24_error_intr(struct ata_port *ap)
 {
 	void __iomem *port = ap->ioaddr.cmd_addr;
+	struct sil24_port_priv *pp = ap->private_data;
 	struct ata_eh_info *ehi = &ap->eh_info;
 	int freeze = 0;
 	u32 irq_stat;
@@ -769,16 +819,16 @@ static void sil24_error_intr(struct ata_port *ap)
 
 	if (irq_stat & (PORT_IRQ_PHYRDY_CHG | PORT_IRQ_DEV_XCHG)) {
 		ata_ehi_hotplugged(ehi);
-		ata_ehi_push_desc(ehi, ", %s",
-			       irq_stat & PORT_IRQ_PHYRDY_CHG ?
-			       "PHY RDY changed" : "device exchanged");
+		ata_ehi_push_desc(ehi, "%s",
+				  irq_stat & PORT_IRQ_PHYRDY_CHG ?
+				  "PHY RDY changed" : "device exchanged");
 		freeze = 1;
 	}
 
 	if (irq_stat & PORT_IRQ_UNK_FIS) {
 		ehi->err_mask |= AC_ERR_HSM;
 		ehi->action |= ATA_EH_SOFTRESET;
-		ata_ehi_push_desc(ehi , ", unknown FIS");
+		ata_ehi_push_desc(ehi, "unknown FIS");
 		freeze = 1;
 	}
 
@@ -797,18 +847,18 @@ static void sil24_error_intr(struct ata_port *ap)
 		if (ci && ci->desc) {
 			err_mask |= ci->err_mask;
 			action |= ci->action;
-			ata_ehi_push_desc(ehi, ", %s", ci->desc);
+			ata_ehi_push_desc(ehi, "%s", ci->desc);
 		} else {
 			err_mask |= AC_ERR_OTHER;
 			action |= ATA_EH_SOFTRESET;
-			ata_ehi_push_desc(ehi, ", unknown command error %d",
+			ata_ehi_push_desc(ehi, "unknown command error %d",
 					  cerr);
 		}
 
 		/* record error info */
 		qc = ata_qc_from_tag(ap, ap->active_tag);
 		if (qc) {
-			sil24_update_tf(ap);
+			sil24_read_tf(ap, qc->tag, &pp->tf);
 			qc->err_mask |= err_mask;
 		} else
 			ehi->err_mask |= err_mask;
@@ -825,8 +875,11 @@ static void sil24_error_intr(struct ata_port *ap)
 
 static void sil24_finish_qc(struct ata_queued_cmd *qc)
 {
+	struct ata_port *ap = qc->ap;
+	struct sil24_port_priv *pp = ap->private_data;
+
 	if (qc->flags & ATA_QCFLAG_RESULT_TF)
-		sil24_update_tf(qc->ap);
+		sil24_read_tf(ap, qc->tag, &pp->tf);
 }
 
 static inline void sil24_host_intr(struct ata_port *ap)
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 33716b0..31a2f55 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -64,8 +64,8 @@ enum {
 };
 
 static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
-static u32 sis_scr_read (struct ata_port *ap, unsigned int sc_reg);
-static void sis_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int sis_scr_read (struct ata_port *ap, unsigned int sc_reg, u32 *val);
+static int sis_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 
 static const struct pci_device_id sis_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x0180), sis_180 },		/* SiS 964/180 */
@@ -207,36 +207,37 @@ static void sis_scr_cfg_write (struct ata_port *ap, unsigned int sc_reg, u32 val
 		pci_write_config_dword(pdev, cfg_addr+0x10, val);
 }
 
-static u32 sis_scr_read (struct ata_port *ap, unsigned int sc_reg)
+static int sis_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u32 val, val2 = 0;
 	u8 pmr;
 
 	if (sc_reg > SCR_CONTROL)
-		return 0xffffffffU;
+		return -EINVAL;
 
 	if (ap->flags & SIS_FLAG_CFGSCR)
 		return sis_scr_cfg_read(ap, sc_reg);
 
 	pci_read_config_byte(pdev, SIS_PMR, &pmr);
 
-	val = ioread32(ap->ioaddr.scr_addr + (sc_reg * 4));
+	*val = ioread32(ap->ioaddr.scr_addr + (sc_reg * 4));
 
 	if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
 	    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
-		val2 = ioread32(ap->ioaddr.scr_addr + (sc_reg * 4) + 0x10);
+		*val |= ioread32(ap->ioaddr.scr_addr + (sc_reg * 4) + 0x10);
+
+	*val &= 0xfffffffb;
 
-	return (val | val2) &  0xfffffffb;
+	return 0;
 }
 
-static void sis_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int sis_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 pmr;
 
 	if (sc_reg > SCR_CONTROL)
-		return;
+		return -EINVAL;
 
 	pci_read_config_byte(pdev, SIS_PMR, &pmr);
 
@@ -248,6 +249,7 @@ static void sis_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
 		    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
 			iowrite32(val, ap->ioaddr.scr_addr + (sc_reg * 4)+0x10);
 	}
+	return 0;
 }
 
 static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 63fe99a..92e8770 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -103,20 +103,21 @@ static int k2_sata_check_atapi_dma(struct ata_queued_cmd *qc)
 	return 0;
 }
 
-static u32 k2_sata_scr_read (struct ata_port *ap, unsigned int sc_reg)
+static int k2_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
-		return 0xffffffffU;
-	return readl(ap->ioaddr.scr_addr + (sc_reg * 4));
+		return -EINVAL;
+	*val = readl(ap->ioaddr.scr_addr + (sc_reg * 4));
+	return 0;
 }
 
 
-static void k2_sata_scr_write (struct ata_port *ap, unsigned int sc_reg,
-			       u32 val)
+static int k2_sata_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
-		return;
+		return -EINVAL;
 	writel(val, ap->ioaddr.scr_addr + (sc_reg * 4));
+	return 0;
 }
 
 
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index b52f83a..78c2851 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -57,8 +57,8 @@ struct uli_priv {
 };
 
 static int uli_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
-static u32 uli_scr_read (struct ata_port *ap, unsigned int sc_reg);
-static void uli_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int uli_scr_read (struct ata_port *ap, unsigned int sc_reg, u32 *val);
+static int uli_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 
 static const struct pci_device_id uli_pci_tbl[] = {
 	{ PCI_VDEVICE(AL, 0x5289), uli_5289 },
@@ -164,20 +164,22 @@ static void uli_scr_cfg_write (struct ata_port *ap, unsigned int scr, u32 val)
 	pci_write_config_dword(pdev, cfg_addr, val);
 }
 
-static u32 uli_scr_read (struct ata_port *ap, unsigned int sc_reg)
+static int uli_scr_read (struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
-		return 0xffffffffU;
+		return -EINVAL;
 
-	return uli_scr_cfg_read(ap, sc_reg);
+	*val = uli_scr_cfg_read(ap, sc_reg);
+	return 0;
 }
 
-static void uli_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int uli_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)	//SCR_CONTROL=2, SCR_ERROR=1, SCR_STATUS=0
-		return;
+		return -EINVAL;
 
 	uli_scr_cfg_write(ap, sc_reg, val);
+	return 0;
 }
 
 static int uli_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index c412447..86b7bfc 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -72,8 +72,8 @@ enum {
 };
 
 static int svia_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
-static u32 svia_scr_read (struct ata_port *ap, unsigned int sc_reg);
-static void svia_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
+static int svia_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
+static int svia_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 static void svia_noop_freeze(struct ata_port *ap);
 static void vt6420_error_handler(struct ata_port *ap);
 static int vt6421_pata_cable_detect(struct ata_port *ap);
@@ -249,18 +249,20 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, svia_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
-static u32 svia_scr_read (struct ata_port *ap, unsigned int sc_reg)
+static int svia_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
-		return 0xffffffffU;
-	return ioread32(ap->ioaddr.scr_addr + (4 * sc_reg));
+		return -EINVAL;
+	*val = ioread32(ap->ioaddr.scr_addr + (4 * sc_reg));
+	return 0;
 }
 
-static void svia_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
+static int svia_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
-		return;
+		return -EINVAL;
 	iowrite32(val, ap->ioaddr.scr_addr + (4 * sc_reg));
+	return 0;
 }
 
 static void svia_noop_freeze(struct ata_port *ap)
@@ -305,18 +307,19 @@ static int vt6420_prereset(struct ata_port *ap, unsigned long deadline)
 
 	/* Resume phy.  This is the old SATA resume sequence */
 	svia_scr_write(ap, SCR_CONTROL, 0x300);
-	svia_scr_read(ap, SCR_CONTROL); /* flush */
+	svia_scr_read(ap, SCR_CONTROL, &scontrol); /* flush */
 
 	/* wait for phy to become ready, if necessary */
 	do {
 		msleep(200);
-		if ((svia_scr_read(ap, SCR_STATUS) & 0xf) != 1)
+		svia_scr_read(ap, SCR_STATUS, &sstatus);
+		if ((sstatus & 0xf) != 1)
 			break;
 	} while (time_before(jiffies, timeout));
 
 	/* open code sata_print_link_status() */
-	sstatus = svia_scr_read(ap, SCR_STATUS);
-	scontrol = svia_scr_read(ap, SCR_CONTROL);
+	svia_scr_read(ap, SCR_STATUS, &sstatus);
+	svia_scr_read(ap, SCR_CONTROL, &scontrol);
 
 	online = (sstatus & 0xf) == 0x3;
 
@@ -325,7 +328,7 @@ static int vt6420_prereset(struct ata_port *ap, unsigned long deadline)
 			online ? "up" : "down", sstatus, scontrol);
 
 	/* SStatus is read one more time */
-	svia_scr_read(ap, SCR_STATUS);
+	svia_scr_read(ap, SCR_STATUS, &sstatus);
 
 	if (!online) {
 		/* tell EH to bail */
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 1b5d81f..24344d0 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -98,20 +98,21 @@ enum {
 			      VSC_SATA_INT_PHY_CHANGE),
 };
 
-static u32 vsc_sata_scr_read (struct ata_port *ap, unsigned int sc_reg)
+static int vsc_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
 	if (sc_reg > SCR_CONTROL)
-		return 0xffffffffU;
-	return readl(ap->ioaddr.scr_addr + (sc_reg * 4));
+		return -EINVAL;
+	*val = readl(ap->ioaddr.scr_addr + (sc_reg * 4));
+	return 0;
 }
 
 
-static void vsc_sata_scr_write (struct ata_port *ap, unsigned int sc_reg,
-			       u32 val)
+static int vsc_sata_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
-		return;
+		return -EINVAL;
 	writel(val, ap->ioaddr.scr_addr + (sc_reg * 4));
+	return 0;
 }
 
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 47cd2a1..be5a439 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -323,6 +323,7 @@ enum ata_completion_errors {
 	AC_ERR_INVALID		= (1 << 7), /* invalid argument */
 	AC_ERR_OTHER		= (1 << 8), /* unknown */
 	AC_ERR_NODEV_HINT	= (1 << 9), /* polling device detection hint */
+	AC_ERR_NCQ		= (1 << 10), /* marker for offending NCQ qc */
 };
 
 /* forward declarations */
@@ -530,6 +531,7 @@ struct ata_port {
 	unsigned int		cbl;	/* cable type; ATA_CBL_xxx */
 	unsigned int		hw_sata_spd_limit;
 	unsigned int		sata_spd_limit;	/* SATA PHY speed limit */
+	unsigned int		sata_spd;	/* current SATA PHY speed */
 
 	/* record runtime error info, protected by host lock */
 	struct ata_eh_info	eh_info;
@@ -563,6 +565,9 @@ struct ata_port {
 	pm_message_t		pm_mesg;
 	int			*pm_result;
 
+	struct timer_list	fastdrain_timer;
+	unsigned long		fastdrain_cnt;
+
 	void			*private_data;
 
 #ifdef CONFIG_ATA_ACPI
@@ -619,9 +624,8 @@ struct ata_port_operations {
 	u8 (*irq_on) (struct ata_port *);
 	u8 (*irq_ack) (struct ata_port *ap, unsigned int chk_drq);
 
-	u32 (*scr_read) (struct ata_port *ap, unsigned int sc_reg);
-	void (*scr_write) (struct ata_port *ap, unsigned int sc_reg,
-			   u32 val);
+	int (*scr_read) (struct ata_port *ap, unsigned int sc_reg, u32 *val);
+	int (*scr_write) (struct ata_port *ap, unsigned int sc_reg, u32 val);
 
 	int (*port_suspend) (struct ata_port *ap, pm_message_t mesg);
 	int (*port_resume) (struct ata_port *ap);
@@ -764,7 +768,8 @@ extern unsigned int ata_dev_try_classify(struct ata_port *, unsigned int, u8 *);
  */
 extern void ata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf);
 extern void ata_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
-extern void ata_tf_to_fis(const struct ata_taskfile *tf, u8 *fis, u8 pmp);
+extern void ata_tf_to_fis(const struct ata_taskfile *tf,
+			  u8 pmp, int is_cmd, u8 *fis);
 extern void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf);
 extern void ata_noop_dev_select (struct ata_port *ap, unsigned int device);
 extern void ata_std_dev_select (struct ata_port *ap, unsigned int device);
@@ -909,27 +914,21 @@ extern void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
 /*
  * ata_eh_info helpers
  */
-#define ata_ehi_push_desc(ehi, fmt, args...) do { \
-	(ehi)->desc_len += scnprintf((ehi)->desc + (ehi)->desc_len, \
-				     ATA_EH_DESC_LEN - (ehi)->desc_len, \
-				     fmt , ##args); \
-} while (0)
-
-#define ata_ehi_clear_desc(ehi) do { \
-	(ehi)->desc[0] = '\0'; \
-	(ehi)->desc_len = 0; \
-} while (0)
-
-static inline void __ata_ehi_hotplugged(struct ata_eh_info *ehi)
+extern void __ata_ehi_push_desc(struct ata_eh_info *ehi, const char *fmt, ...);
+extern void ata_ehi_push_desc(struct ata_eh_info *ehi, const char *fmt, ...);
+extern void ata_ehi_clear_desc(struct ata_eh_info *ehi);
+
+static inline void ata_ehi_schedule_probe(struct ata_eh_info *ehi)
 {
-	ehi->flags |= ATA_EHI_HOTPLUGGED | ATA_EHI_RESUME_LINK;
+	ehi->flags |= ATA_EHI_RESUME_LINK;
 	ehi->action |= ATA_EH_SOFTRESET;
 	ehi->probe_mask |= (1 << ATA_MAX_DEVICES) - 1;
 }
 
 static inline void ata_ehi_hotplugged(struct ata_eh_info *ehi)
 {
-	__ata_ehi_hotplugged(ehi);
+	ata_ehi_schedule_probe(ehi);
+	ehi->flags |= ATA_EHI_HOTPLUGGED;
 	ehi->err_mask |= AC_ERR_ATA_BUS;
 }
 

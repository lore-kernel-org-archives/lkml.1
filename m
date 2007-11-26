Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbXKZQQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbXKZQQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbXKZQQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:16:32 -0500
Received: from havoc.gtf.org ([69.61.125.42]:47480 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbXKZQQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:16:30 -0500
Date: Mon, 26 Nov 2007 11:16:29 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20071126161629.GA15517@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


NOTE:  This includes 100% of the fixes collected during the week I
was on vacation, by Tejun... rebased.  So all the commit ids are
different from his push.

If you have not pulled from Tejun, then pull this.

If you have pulled from Tejun, then do not pull this (I will rebase once
Tejun's pull is pushed out).

Other notes:  I have a sata_nv ATAPI fix that needs to go in too, should
push that in the next push (day or two).


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c     |   93 ++++++++++++++++++++++++++------------
 drivers/ata/libata-core.c  |  108 ++++++++++----------------------------------
 drivers/ata/libata-eh.c    |   95 --------------------------------------
 drivers/ata/libata-scsi.c  |   38 ++++++++++++++--
 drivers/ata/pata_ali.c     |   20 ++++++++
 drivers/ata/pata_bf54x.c   |    6 +-
 drivers/ata/pata_hpt37x.c  |    2 +-
 drivers/ata/pata_isapnp.c  |   11 +++--
 drivers/ata/pata_jmicron.c |    9 ++--
 drivers/ata/pata_sil680.c  |   32 +------------
 drivers/ata/pata_sis.c     |    1 +
 drivers/ata/sata_sil24.c   |   26 +++++++++-
 include/linux/libata.h     |    5 +--
 13 files changed, 184 insertions(+), 262 deletions(-)

Adrian Bunk (1):
      libata: remove unused functions

Alan Cox (6):
      ata_piix: Invalid use of writel/readl with iomap
      libata-core: List more documentation sources for reference
      pata_ali: Add Mitac 8317 and derivatives
      pata_ali: Lots of problems still showing up with small ATAPI DMA
      pata_hpt37x: Fix cable detect bug spotted by Sergei
      pata_isapnp: Polled devices

Albert Lee (2):
      libata: workaround DRQ=1 ERR=1 for ATAPI tape drives
      libata: use ATA_HORKAGE_STUCK_ERR for ATAPI tape drives

Gabriel C (1):
      pata_sis.c: Add Packard Bell EasyNote K5305 to laptops

Jeff Garzik (1):
      pata_ali: trim trailing whitespace (fix checkpatch complaints)

Mark Lord (1):
      libata-scsi: be tolerant of 12-byte ATAPI commands in 16-byte CDBs

Sergei Shtylyov (1):
      pata_sil680: kill bogus reset code (take 2)

Tejun Heo (6):
      ata_piix: add SATELLITE U205 to broken suspend list
      ata_piix: reorganize controller IDs
      ata_piix: port enable for the first SATA controller of ICH8 is 0xf not 0x3
      pata_jmicron: fix disabled port handling in jmicron_pre_reset()
      sata_sil24: fix sg table sizing
      libata: bump transfer chunk size if it's odd

Thomas Rohwer (1):
      ata_piix: only enable the first port on apple macbook pro

sonic zhang (1):
      libata: Return proper ATA INT status in pata_bf54x driver

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 328ce8a..483269d 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -119,18 +119,19 @@ enum {
 	PIIX_80C_SEC		= (1 << 7) | (1 << 6),
 
 	/* controller IDs */
-	piix_pata_33		= 0,	/* PIIX4 at 33Mhz */
-	ich_pata_33		= 1,	/* ICH up to UDMA 33 only */
-	ich_pata_66		= 2,	/* ICH up to 66 Mhz */
-	ich_pata_100		= 3,	/* ICH up to UDMA 100 */
-	ich5_sata		= 5,
-	ich6_sata		= 6,
-	ich6_sata_ahci		= 7,
-	ich6m_sata_ahci		= 8,
-	ich8_sata_ahci		= 9,
-	piix_pata_mwdma		= 10,	/* PIIX3 MWDMA only */
-	tolapai_sata_ahci	= 11,
-	ich9_2port_sata		= 12,
+	piix_pata_mwdma		= 0,	/* PIIX3 MWDMA only */
+	piix_pata_33,			/* PIIX4 at 33Mhz */
+	ich_pata_33,			/* ICH up to UDMA 33 only */
+	ich_pata_66,			/* ICH up to 66 Mhz */
+	ich_pata_100,			/* ICH up to UDMA 100 */
+	ich5_sata,
+	ich6_sata,
+	ich6_sata_ahci,
+	ich6m_sata_ahci,
+	ich8_sata_ahci,
+	ich8_2port_sata,
+	ich8m_apple_sata_ahci,		/* locks up on second port enable */
+	tolapai_sata_ahci,
 
 	/* constants for mapping table */
 	P0			= 0,  /* port 0 */
@@ -239,19 +240,21 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* SATA Controller 1 IDE (ICH8) */
 	{ 0x8086, 0x2820, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller 2 IDE (ICH8) */
-	{ 0x8086, 0x2825, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
+	{ 0x8086, 0x2825, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* Mobile SATA Controller IDE (ICH8M) */
 	{ 0x8086, 0x2828, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	/* Mobile SATA Controller IDE (ICH8M), Apple */
+	{ 0x8086, 0x2828, 0x106b, 0x00a0, 0, 0, ich8m_apple_sata_ahci },
 	/* SATA Controller IDE (ICH9) */
 	{ 0x8086, 0x2920, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (ICH9) */
-	{ 0x8086, 0x2921, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
+	{ 0x8086, 0x2921, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (ICH9) */
-	{ 0x8086, 0x2926, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
+	{ 0x8086, 0x2926, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (ICH9M) */
-	{ 0x8086, 0x2928, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
+	{ 0x8086, 0x2928, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (ICH9M) */
-	{ 0x8086, 0x292d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich9_2port_sata },
+	{ 0x8086, 0x292d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (ICH9M) */
 	{ 0x8086, 0x292e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (Tolapai) */
@@ -427,7 +430,7 @@ static const struct piix_map_db ich6m_map_db = {
 
 static const struct piix_map_db ich8_map_db = {
 	.mask = 0x3,
-	.port_enable = 0x3,
+	.port_enable = 0xf,
 	.map = {
 		/* PM   PS   SM   SS       MAP */
 		{  P0,  P2,  P1,  P3 }, /* 00b (hardwired when in AHCI) */
@@ -437,7 +440,7 @@ static const struct piix_map_db ich8_map_db = {
 	},
 };
 
-static const struct piix_map_db tolapai_map_db = {
+static const struct piix_map_db ich8_2port_map_db = {
 	.mask = 0x3,
 	.port_enable = 0x3,
 	.map = {
@@ -449,7 +452,19 @@ static const struct piix_map_db tolapai_map_db = {
 	},
 };
 
-static const struct piix_map_db ich9_2port_map_db = {
+static const struct piix_map_db ich8m_apple_map_db = {
+	.mask = 0x3,
+	.port_enable = 0x1,
+	.map = {
+		/* PM   PS   SM   SS       MAP */
+		{  P0,  NA,  NA,  NA }, /* 00b */
+		{  RV,  RV,  RV,  RV },
+		{  P0,  P2, IDE, IDE }, /* 10b */
+		{  RV,  RV,  RV,  RV },
+	},
+};
+
+static const struct piix_map_db tolapai_map_db = {
 	.mask = 0x3,
 	.port_enable = 0x3,
 	.map = {
@@ -467,11 +482,21 @@ static const struct piix_map_db *piix_map_db_table[] = {
 	[ich6_sata_ahci]	= &ich6_map_db,
 	[ich6m_sata_ahci]	= &ich6m_map_db,
 	[ich8_sata_ahci]	= &ich8_map_db,
+	[ich8_2port_sata]	= &ich8_2port_map_db,
+	[ich8m_apple_sata_ahci]	= &ich8m_apple_map_db,
 	[tolapai_sata_ahci]	= &tolapai_map_db,
-	[ich9_2port_sata]	= &ich9_2port_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
+	[piix_pata_mwdma] = 	/* PIIX3 MWDMA only */
+	{
+		.sht		= &piix_sht,
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= 0x1f,	/* pio0-4 */
+		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.port_ops	= &piix_pata_ops,
+	},
+
 	[piix_pata_33] =	/* PIIX4 at 33MHz */
 	{
 		.sht		= &piix_sht,
@@ -565,13 +590,15 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_sata_ops,
 	},
 
-	[piix_pata_mwdma] = 	/* PIIX3 MWDMA only */
+	[ich8_2port_sata] =
 	{
 		.sht		= &piix_sht,
-		.flags		= PIIX_PATA_FLAGS,
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
+				  PIIX_FLAG_AHCI,
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
-		.port_ops	= &piix_pata_ops,
+		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
 	},
 
 	[tolapai_sata_ahci] =
@@ -585,7 +612,7 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_sata_ops,
 	},
 
-	[ich9_2port_sata] =
+	[ich8m_apple_sata_ahci] =
 	{
 		.sht		= &piix_sht,
 		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
@@ -595,6 +622,7 @@ static struct ata_port_info piix_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
+
 };
 
 static struct pci_bits piix_enable_bits[] = {
@@ -974,6 +1002,13 @@ static int piix_broken_suspend(void)
 			},
 		},
 		{
+			.ident = "SATELLITE U205",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE U205"),
+			},
+		},
+		{
 			.ident = "Portege M500",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
@@ -1086,12 +1121,12 @@ static int piix_disable_ahci(struct pci_dev *pdev)
 	if (!mmio)
 		return -ENOMEM;
 
-	tmp = readl(mmio + AHCI_GLOBAL_CTL);
+	tmp = ioread32(mmio + AHCI_GLOBAL_CTL);
 	if (tmp & AHCI_ENABLE) {
 		tmp &= ~AHCI_ENABLE;
-		writel(tmp, mmio + AHCI_GLOBAL_CTL);
+		iowrite32(tmp, mmio + AHCI_GLOBAL_CTL);
 
-		tmp = readl(mmio + AHCI_GLOBAL_CTL);
+		tmp = ioread32(mmio + AHCI_GLOBAL_CTL);
 		if (tmp & AHCI_ENABLE)
 			rc = -EIO;
 	}
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8189803..33f0627 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -30,6 +30,14 @@
  *  Hardware documentation available from http://www.t13.org/ and
  *  http://www.sata-io.org/
  *
+ *  Standards documents from:
+ *	http://www.t13.org (ATA standards, PCI DMA IDE spec)
+ *	http://www.t10.org (SCSI MMC - for ATAPI MMC)
+ *	http://www.sata-io.org (SATA)
+ *	http://www.compactflash.org (CF)
+ *	http://www.qic.org (QIC157 - Tape and DSC)
+ *	http://www.ce-ata.org (CE-ATA: not supported)
+ *
  */
 
 #include <linux/kernel.h>
@@ -2307,8 +2315,10 @@ int ata_dev_configure(struct ata_device *dev)
 	}
 
 	if ((dev->class == ATA_DEV_ATAPI) &&
-	    (atapi_command_packet_set(id) == TYPE_TAPE))
+	    (atapi_command_packet_set(id) == TYPE_TAPE)) {
 		dev->max_sectors = ATA_MAX_SECTORS_TAPE;
+		dev->horkage |= ATA_HORKAGE_STUCK_ERR;
+	}
 
 	if (dev->horkage & ATA_HORKAGE_MAX_SEC_128)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
@@ -2581,81 +2591,6 @@ void sata_print_link_status(struct ata_link *link)
 }
 
 /**
- *	__sata_phy_reset - Wake/reset a low-level SATA PHY
- *	@ap: SATA port associated with target SATA PHY.
- *
- *	This function issues commands to standard SATA Sxxx
- *	PHY registers, to wake up the phy (and device), and
- *	clear any reset condition.
- *
- *	LOCKING:
- *	PCI/etc. bus probe sem.
- *
- */
-void __sata_phy_reset(struct ata_port *ap)
-{
-	struct ata_link *link = &ap->link;
-	unsigned long timeout = jiffies + (HZ * 5);
-	u32 sstatus;
-
-	if (ap->flags & ATA_FLAG_SATA_RESET) {
-		/* issue phy wake/reset */
-		sata_scr_write_flush(link, SCR_CONTROL, 0x301);
-		/* Couldn't find anything in SATA I/II specs, but
-		 * AHCI-1.1 10.4.2 says at least 1 ms. */
-		mdelay(1);
-	}
-	/* phy wake/clear reset */
-	sata_scr_write_flush(link, SCR_CONTROL, 0x300);
-
-	/* wait for phy to become ready, if necessary */
-	do {
-		msleep(200);
-		sata_scr_read(link, SCR_STATUS, &sstatus);
-		if ((sstatus & 0xf) != 1)
-			break;
-	} while (time_before(jiffies, timeout));
-
-	/* print link status */
-	sata_print_link_status(link);
-
-	/* TODO: phy layer with polling, timeouts, etc. */
-	if (!ata_link_offline(link))
-		ata_port_probe(ap);
-	else
-		ata_port_disable(ap);
-
-	if (ap->flags & ATA_FLAG_DISABLED)
-		return;
-
-	if (ata_busy_sleep(ap, ATA_TMOUT_BOOT_QUICK, ATA_TMOUT_BOOT)) {
-		ata_port_disable(ap);
-		return;
-	}
-
-	ap->cbl = ATA_CBL_SATA;
-}
-
-/**
- *	sata_phy_reset - Reset SATA bus.
- *	@ap: SATA port associated with target SATA PHY.
- *
- *	This function resets the SATA bus, and then probes
- *	the bus for devices.
- *
- *	LOCKING:
- *	PCI/etc. bus probe sem.
- *
- */
-void sata_phy_reset(struct ata_port *ap)
-{
-	__sata_phy_reset(ap);
-	if (ap->flags & ATA_FLAG_DISABLED)
-		return;
-	ata_bus_reset(ap);
-}
-
-/**
  *	ata_dev_pair		-	return other device on cable
  *	@adev: device
  *
@@ -5490,11 +5425,19 @@ fsm_start:
 		 * let the EH abort the command or reset the device.
 		 */
 		if (unlikely(status & (ATA_ERR | ATA_DF))) {
-			ata_port_printk(ap, KERN_WARNING, "DRQ=1 with device "
-					"error, dev_stat 0x%X\n", status);
-			qc->err_mask |= AC_ERR_HSM;
-			ap->hsm_task_state = HSM_ST_ERR;
-			goto fsm_start;
+			/* Some ATAPI tape drives forget to clear the ERR bit
+			 * when doing the next command (mostly request sense).
+			 * We ignore ERR here to workaround and proceed sending
+			 * the CDB.
+			 */
+			if (!(qc->dev->horkage & ATA_HORKAGE_STUCK_ERR)) {
+				ata_port_printk(ap, KERN_WARNING,
+						"DRQ=1 with device error, "
+						"dev_stat 0x%X\n", status);
+				qc->err_mask |= AC_ERR_HSM;
+				ap->hsm_task_state = HSM_ST_ERR;
+				goto fsm_start;
+			}
 		}
 
 		/* Send the CDB (atapi) or the first data block (ata pio out).
@@ -7653,8 +7596,6 @@ EXPORT_SYMBOL_GPL(ata_dev_disable);
 EXPORT_SYMBOL_GPL(sata_set_spd);
 EXPORT_SYMBOL_GPL(sata_link_debounce);
 EXPORT_SYMBOL_GPL(sata_link_resume);
-EXPORT_SYMBOL_GPL(sata_phy_reset);
-EXPORT_SYMBOL_GPL(__sata_phy_reset);
 EXPORT_SYMBOL_GPL(ata_bus_reset);
 EXPORT_SYMBOL_GPL(ata_std_prereset);
 EXPORT_SYMBOL_GPL(ata_std_softreset);
@@ -7725,7 +7666,6 @@ EXPORT_SYMBOL_GPL(ata_port_desc);
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(ata_port_pbar_desc);
 #endif /* CONFIG_PCI */
-EXPORT_SYMBOL_GPL(ata_eng_timeout);
 EXPORT_SYMBOL_GPL(ata_port_schedule_eh);
 EXPORT_SYMBOL_GPL(ata_link_abort);
 EXPORT_SYMBOL_GPL(ata_port_abort);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index ed8813b..0dac69d 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -559,101 +559,6 @@ void ata_port_wait_eh(struct ata_port *ap)
 	}
 }
 
-/**
- *	ata_qc_timeout - Handle timeout of queued command
- *	@qc: Command that timed out
- *
- *	Some part of the kernel (currently, only the SCSI layer)
- *	has noticed that the active command on port @ap has not
- *	completed after a specified length of time.  Handle this
- *	condition by disabling DMA (if necessary) and completing
- *	transactions, with error if necessary.
- *
- *	This also handles the case of the "lost interrupt", where
- *	for some reason (possibly hardware bug, possibly driver bug)
- *	an interrupt was not delivered to the driver, even though the
- *	transaction completed successfully.
- *
- *	TODO: kill this function once old EH is gone.
- *
- *	LOCKING:
- *	Inherited from SCSI layer (none, can sleep)
- */
-static void ata_qc_timeout(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	u8 host_stat = 0, drv_stat;
-	unsigned long flags;
-
-	DPRINTK("ENTER\n");
-
-	ap->hsm_task_state = HSM_ST_IDLE;
-
-	spin_lock_irqsave(ap->lock, flags);
-
-	switch (qc->tf.protocol) {
-
-	case ATA_PROT_DMA:
-	case ATA_PROT_ATAPI_DMA:
-		host_stat = ap->ops->bmdma_status(ap);
-
-		/* before we do anything else, clear DMA-Start bit */
-		ap->ops->bmdma_stop(qc);
-
-		/* fall through */
-
-	default:
-		ata_altstatus(ap);
-		drv_stat = ata_chk_status(ap);
-
-		/* ack bmdma irq events */
-		ap->ops->irq_clear(ap);
-
-		ata_dev_printk(qc->dev, KERN_ERR, "command 0x%x timeout, "
-			       "stat 0x%x host_stat 0x%x\n",
-			       qc->tf.command, drv_stat, host_stat);
-
-		/* complete taskfile transaction */
-		qc->err_mask |= AC_ERR_TIMEOUT;
-		break;
-	}
-
-	spin_unlock_irqrestore(ap->lock, flags);
-
-	ata_eh_qc_complete(qc);
-
-	DPRINTK("EXIT\n");
-}
-
-/**
- *	ata_eng_timeout - Handle timeout of queued command
- *	@ap: Port on which timed-out command is active
- *
- *	Some part of the kernel (currently, only the SCSI layer)
- *	has noticed that the active command on port @ap has not
- *	completed after a specified length of time.  Handle this
- *	condition by disabling DMA (if necessary) and completing
- *	transactions, with error if necessary.
- *
- *	This also handles the case of the "lost interrupt", where
- *	for some reason (possibly hardware bug, possibly driver bug)
- *	an interrupt was not delivered to the driver, even though the
- *	transaction completed successfully.
- *
- *	TODO: kill this function once old EH is gone.
- *
- *	LOCKING:
- *	Inherited from SCSI layer (none, can sleep)
- */
-void ata_eng_timeout(struct ata_port *ap)
-{
-	DPRINTK("ENTER\n");
-
-	ata_qc_timeout(ata_qc_from_tag(ap, ap->link.active_tag));
-
-	DPRINTK("EXIT\n");
-}
-
 static int ata_eh_nr_in_flight(struct ata_port *ap)
 {
 	unsigned int tag;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 94144ed..a883bb0 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2485,11 +2485,40 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	if (!using_pio && ata_check_atapi_dma(qc))
 		using_pio = 1;
 
-	/* Some controller variants snoop this value for Packet transfers
-	   to do state machine and FIFO management. Thus we want to set it
-	   properly, and for DMA where it is effectively meaningless */
+	/* Some controller variants snoop this value for Packet
+	 * transfers to do state machine and FIFO management.  Thus we
+	 * want to set it properly, and for DMA where it is
+	 * effectively meaningless.
+	 */
 	nbytes = min(qc->nbytes, (unsigned int)63 * 1024);
 
+	/* Most ATAPI devices which honor transfer chunk size don't
+	 * behave according to the spec when odd chunk size which
+	 * matches the transfer length is specified.  If the number of
+	 * bytes to transfer is 2n+1.  According to the spec, what
+	 * should happen is to indicate that 2n+1 is going to be
+	 * transferred and transfer 2n+2 bytes where the last byte is
+	 * padding.
+	 *
+	 * In practice, this doesn't happen.  ATAPI devices first
+	 * indicate and transfer 2n bytes and then indicate and
+	 * transfer 2 bytes where the last byte is padding.
+	 *
+	 * This inconsistency confuses several controllers which
+	 * perform PIO using DMA such as Intel AHCIs and sil3124/32.
+	 * These controllers use actual number of transferred bytes to
+	 * update DMA poitner and transfer of 4n+2 bytes make those
+	 * controller push DMA pointer by 4n+4 bytes because SATA data
+	 * FISes are aligned to 4 bytes.  This causes data corruption
+	 * and buffer overrun.
+	 *
+	 * Always setting nbytes to even number solves this problem
+	 * because then ATAPI devices don't have to split data at 2n
+	 * boundaries.
+	 */
+	if (nbytes & 0x1)
+		nbytes++;
+
 	qc->tf.lbam = (nbytes & 0xFF);
 	qc->tf.lbah = (nbytes >> 8);
 
@@ -2869,7 +2898,8 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 		xlat_func = NULL;
 		if (likely((scsi_op != ATA_16) || !atapi_passthru16)) {
 			/* relay SCSI command to ATAPI device */
-			if (unlikely(scmd->cmd_len > dev->cdb_len))
+			int len = COMMAND_SIZE(scsi_op);
+			if (unlikely(len > scmd->cmd_len || len > dev->cdb_len))
 				goto bad_cdb_len;
 
 			xlat_func = atapi_xlat;
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 364534e..8caf9af 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -63,6 +63,9 @@ static int ali_cable_override(struct pci_dev *pdev)
 	/* Fujitsu P2000 */
 	if (pdev->subsystem_vendor == 0x10CF && pdev->subsystem_device == 0x10AF)
 	   	return 1;
+	/* Mitac 8317 (Winbook-A) and relatives */
+	if (pdev->subsystem_vendor == 0x1071  && pdev->subsystem_device == 0x8317)
+		return 1;
 	/* Systems by DMI */
 	if (dmi_check_system(cable_dmi_table))
 		return 1;
@@ -282,6 +285,21 @@ static void ali_lock_sectors(struct ata_device *adev)
 	adev->max_sectors = 255;
 }
 
+/**
+ *	ali_check_atapi_dma	-	DMA check for most ALi controllers
+ *	@adev: Device
+ *
+ *	Called to decide whether commands should be sent by DMA or PIO
+ */
+
+static int ali_check_atapi_dma(struct ata_queued_cmd *qc)
+{
+	/* If its not a media command, its not worth it */
+	if (qc->nbytes < 2048)
+		return -EOPNOTSUPP;
+	return 0;
+}
+
 static struct scsi_host_template ali_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -378,6 +396,7 @@ static struct ata_port_operations ali_c2_port_ops = {
 	.mode_filter	= ata_pci_default_filter,
 	.tf_load	= ata_tf_load,
 	.tf_read	= ata_tf_read,
+	.check_atapi_dma = ali_check_atapi_dma,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
@@ -415,6 +434,7 @@ static struct ata_port_operations ali_c5_port_ops = {
 	.mode_filter	= ata_pci_default_filter,
 	.tf_load	= ata_tf_load,
 	.tf_read	= ata_tf_read,
+	.check_atapi_dma = ali_check_atapi_dma,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index b5e3842..81db405 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1145,13 +1145,13 @@ static unsigned char bfin_bmdma_status(struct ata_port *ap)
 	unsigned short int_status = ATAPI_GET_INT_STATUS(base);
 
 	if (ATAPI_GET_STATUS(base) & (MULTI_XFER_ON|ULTRA_XFER_ON)) {
-		host_stat = ATA_DMA_ACTIVE;
+		host_stat |= ATA_DMA_ACTIVE;
 	}
 	if (int_status & (MULTI_DONE_INT|UDMAIN_DONE_INT|UDMAOUT_DONE_INT)) {
-		host_stat = ATA_DMA_INTR;
+		host_stat |= ATA_DMA_INTR;
 	}
 	if (int_status & (MULTI_TERM_INT|UDMAIN_TERM_INT|UDMAOUT_TERM_INT)) {
-		host_stat = ATA_DMA_ERR;
+		host_stat |= ATA_DMA_ERR;
 	}
 
 	return host_stat;
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 3816b86..46dc70e 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -329,7 +329,7 @@ static int hpt37x_pre_reset(struct ata_link *link, unsigned long deadline)
 	/* Restore state */
 	pci_write_config_byte(pdev, 0x5B, scr2);
 
-	if (ata66 & (1 << ap->port_no))
+	if (ata66 & (2 >> ap->port_no))
 		ap->cbl = ATA_CBL_PATA40;
 	else
 		ap->cbl = ATA_CBL_PATA80;
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 88ab0e1..4320e79 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -75,13 +75,16 @@ static int isapnp_init_one(struct pnp_dev *idev, const struct pnp_device_id *dev
 	struct ata_host *host;
 	struct ata_port *ap;
 	void __iomem *cmd_addr, *ctl_addr;
+	int irq = 0;
+	irq_handler_t handler = NULL;
 
 	if (pnp_port_valid(idev, 0) == 0)
 		return -ENODEV;
 
-	/* FIXME: Should selected polled PIO here not fail */
-	if (pnp_irq_valid(idev, 0) == 0)
-		return -ENODEV;
+	if (pnp_irq_valid(idev, 0)) {
+		irq = pnp_irq(idev, 0);
+		handler = ata_interrupt;
+	}
 
 	/* allocate host */
 	host = ata_host_alloc(&idev->dev, 1);
@@ -115,7 +118,7 @@ static int isapnp_init_one(struct pnp_dev *idev, const struct pnp_device_id *dev
 		      (unsigned long long)pnp_port_start(idev, 1));
 
 	/* activate */
-	return ata_host_activate(host, pnp_irq(idev, 0), ata_interrupt, 0,
+	return ata_host_activate(host, irq, handler, 0,
 				 &isapnp_sht);
 }
 
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 225a722..5b8174d 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -80,11 +80,10 @@ static int jmicron_pre_reset(struct ata_link *link, unsigned long deadline)
 	 *	actually do our cable checking etc. Thankfully we don't need
 	 *	to do the plumbing for other cases.
 	 */
-	switch (port_map[port])
-	{
+	switch (port_map[port]) {
 	case PORT_PATA0:
-		if (control & (1 << 5))
-			return 0;
+		if ((control & (1 << 5)) == 0)
+			return -ENOENT;
 		if (control & (1 << 3))	/* 40/80 pin primary */
 			ap->cbl = ATA_CBL_PATA40;
 		else
@@ -93,7 +92,7 @@ static int jmicron_pre_reset(struct ata_link *link, unsigned long deadline)
 	case PORT_PATA1:
 		/* Bit 21 is set if the port is enabled */
 		if ((control5 & (1 << 21)) == 0)
-			return 0;
+			return -ENOENT;
 		if (control5 & (1 << 19))	/* 40/80 pin secondary */
 			ap->cbl = ATA_CBL_PATA40;
 		else
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 5c1e9cb..503245a 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -33,7 +33,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_sil680"
-#define DRV_VERSION "0.4.7"
+#define DRV_VERSION "0.4.8"
 
 #define SIL680_MMIO_BAR		5
 
@@ -94,34 +94,6 @@ static int sil680_cable_detect(struct ata_port *ap) {
 }
 
 /**
- *	sil680_bus_reset	-	reset the SIL680 bus
- *	@link: ATA link to reset
- *	@deadline: deadline jiffies for the operation
- *
- *	Perform the SIL680 housekeeping when doing an ATA bus reset
- */
-
-static int sil680_bus_reset(struct ata_link *link, unsigned int *classes,
-			    unsigned long deadline)
-{
-	struct ata_port *ap = link->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned long addr = sil680_selreg(ap, 0);
-	u8 reset;
-
-	pci_read_config_byte(pdev, addr, &reset);
-	pci_write_config_byte(pdev, addr, reset | 0x03);
-	udelay(25);
-	pci_write_config_byte(pdev, addr, reset);
-	return ata_std_softreset(link, classes, deadline);
-}
-
-static void sil680_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, ata_std_prereset, sil680_bus_reset, NULL, ata_std_postreset);
-}
-
-/**
  *	sil680_set_piomode	-	set initial PIO mode data
  *	@ap: ATA interface
  *	@adev: ATA device
@@ -249,7 +221,7 @@ static struct ata_port_operations sil680_port_ops = {
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= sil680_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 	.cable_detect	= sil680_cable_detect,
 
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 3b5be77..87546d9 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -55,6 +55,7 @@ static const struct sis_laptop sis_laptop[] = {
 	/* devid, subvendor, subdev */
 	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
 	{ 0x5513, 0x1734, 0x105F },	/* FSC Amilo A1630 */
+	{ 0x5513, 0x1071, 0x8640 },     /* EasyNote K5305 */
 	/* end marker */
 	{ 0, }
 };
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 187dcb0..96fd526 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -63,6 +63,21 @@ enum {
 	SIL24_HOST_BAR		= 0,
 	SIL24_PORT_BAR		= 2,
 
+	/* sil24 fetches in chunks of 64bytes.  The first block
+	 * contains the PRB and two SGEs.  From the second block, it's
+	 * consisted of four SGEs and called SGT.  Calculate the
+	 * number of SGTs that fit into one page.
+	 */
+	SIL24_PRB_SZ		= sizeof(struct sil24_prb)
+				  + 2 * sizeof(struct sil24_sge),
+	SIL24_MAX_SGT		= (PAGE_SIZE - SIL24_PRB_SZ)
+				  / (4 * sizeof(struct sil24_sge)),
+
+	/* This will give us one unused SGEs for ATA.  This extra SGE
+	 * will be used to store CDB for ATAPI devices.
+	 */
+	SIL24_MAX_SGE		= 4 * SIL24_MAX_SGT + 1,
+
 	/*
 	 * Global controller registers (128 bytes @ BAR0)
 	 */
@@ -247,13 +262,13 @@ enum {
 
 struct sil24_ata_block {
 	struct sil24_prb prb;
-	struct sil24_sge sge[LIBATA_MAX_PRD];
+	struct sil24_sge sge[SIL24_MAX_SGE];
 };
 
 struct sil24_atapi_block {
 	struct sil24_prb prb;
 	u8 cdb[16];
-	struct sil24_sge sge[LIBATA_MAX_PRD - 1];
+	struct sil24_sge sge[SIL24_MAX_SGE];
 };
 
 union sil24_cmd_block {
@@ -378,7 +393,7 @@ static struct scsi_host_template sil24_sht = {
 	.change_queue_depth	= ata_scsi_change_queue_depth,
 	.can_queue		= SIL24_MAX_CMDS,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= SIL24_MAX_SGE,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -1284,6 +1299,7 @@ static void sil24_init_controller(struct ata_host *host)
 
 static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
+	extern int __MARKER__sil24_cmd_block_is_sized_wrongly;
 	static int printed_version;
 	struct ata_port_info pi = sil24_port_info[ent->driver_data];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
@@ -1292,6 +1308,10 @@ static int sil24_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int i, rc;
 	u32 tmp;
 
+	/* cause link error if sil24_cmd_block is sized wrongly */
+	if (sizeof(union sil24_cmd_block) != PAGE_SIZE)
+		__MARKER__sil24_cmd_block_is_sized_wrongly = 1;
+
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 56a5673..ef52a07 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -340,6 +340,7 @@ enum {
 	ATA_HORKAGE_HPA_SIZE	= (1 << 6),	/* native size off by one */
 	ATA_HORKAGE_IPM		= (1 << 7),	/* Link PM problems */
 	ATA_HORKAGE_IVB		= (1 << 8),	/* cbl det validity bit bugs */
+	ATA_HORKAGE_STUCK_ERR	= (1 << 9),	/* stuck ERR on next PACKET */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
@@ -771,8 +772,6 @@ static inline int ata_port_is_dummy(struct ata_port *ap)
 
 extern void sata_print_link_status(struct ata_link *link);
 extern void ata_port_probe(struct ata_port *);
-extern void __sata_phy_reset(struct ata_port *ap);
-extern void sata_phy_reset(struct ata_port *ap);
 extern void ata_bus_reset(struct ata_port *ap);
 extern int sata_set_spd(struct ata_link *link);
 extern int sata_link_debounce(struct ata_link *link,
@@ -994,8 +993,6 @@ extern void sata_pmp_do_eh(struct ata_port *ap,
 /*
  * EH
  */
-extern void ata_eng_timeout(struct ata_port *ap);
-
 extern void ata_port_schedule_eh(struct ata_port *ap);
 extern int ata_link_abort(struct ata_link *link);
 extern int ata_port_abort(struct ata_port *ap);

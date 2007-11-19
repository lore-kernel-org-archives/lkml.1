Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbXKSEgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbXKSEgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 23:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXKSEg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 23:36:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:30262 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbXKSEgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 23:36:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=pzvqYILPIx8C1OvEKFG5xbet2AI80rpVlJrOVzWiYrDn1oEiWdlHvK4vnf8NgZrN7ldIH7iYH6H7coH25p4ig4IMmNc2Qmp3FW1vEDkPACro2OsFTZ9P53J8ss481/wM+tMTd5EOmPRCRgoCxFxYCXKTBe3ePGusSx4kDXTZI3E=
Message-ID: <474112B8.6050505@gmail.com>
Date: Mon, 19 Nov 2007 13:36:08 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org
CC: Jeff Garzik <jgarzik@pobox.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are upstream patches I collected while Jeff is away.  Thanks.

* workaround for ATAPI tape drives
* detection/suspend workarounds for several laptops
* ICH8/9 port_enable fix

ata_piix controller ID reorganization is included to ease the fixes.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/tj/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c    |   87 ++++++++++++++++++++++++++++------------
 drivers/ata/libata-core.c |  100 +++++++---------------------------------------
 drivers/ata/libata-eh.c   |   95 -------------------------------------------
 drivers/ata/libata-scsi.c |    3 -
 drivers/ata/pata_sis.c    |    1 
 include/linux/libata.h    |    5 --
 6 files changed, 81 insertions(+), 210 deletions(-)

Adrian Bunk (1):
      libata: remove unused functions

Albert Lee (2):
      libata: workaround DRQ=1 ERR=1 for ATAPI tape drives
      libata: use ATA_HORKAGE_STUCK_ERR for ATAPI tape drives

Gabriel C (1):
      pata_sis.c: Add Packard Bell EasyNote K5305 to laptops

Mark Lord (1):
      libata-scsi: be tolerant of 12-byte ATAPI commands in 16-byte CDBs

Tejun Heo (3):
      ata_piix: add SATELLITE U205 to broken suspend list
      ata_piix: reorganize controller IDs
      ata_piix: port enable for the first SATA controller of ICH8 is 0xf not 0x3

Thomas Rohwer (1):
      ata_piix: only enable the first port on apple macbook pro

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 328ce8a..671e796 100644
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
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8189803..f7f6ca9 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2307,8 +2307,10 @@ int ata_dev_configure(struct ata_device *dev)
 	}
 
 	if ((dev->class == ATA_DEV_ATAPI) &&
-	    (atapi_command_packet_set(id) == TYPE_TAPE))
+	    (atapi_command_packet_set(id) == TYPE_TAPE)) {
 		dev->max_sectors = ATA_MAX_SECTORS_TAPE;
+		dev->horkage |= ATA_HORKAGE_STUCK_ERR;
+	}
 
 	if (dev->horkage & ATA_HORKAGE_MAX_SEC_128)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
@@ -2581,81 +2583,6 @@ void sata_print_link_status(struct ata_link *link)
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
@@ -5490,11 +5417,19 @@ fsm_start:
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
@@ -7653,8 +7588,6 @@ EXPORT_SYMBOL_GPL(ata_dev_disable);
 EXPORT_SYMBOL_GPL(sata_set_spd);
 EXPORT_SYMBOL_GPL(sata_link_debounce);
 EXPORT_SYMBOL_GPL(sata_link_resume);
-EXPORT_SYMBOL_GPL(sata_phy_reset);
-EXPORT_SYMBOL_GPL(__sata_phy_reset);
 EXPORT_SYMBOL_GPL(ata_bus_reset);
 EXPORT_SYMBOL_GPL(ata_std_prereset);
 EXPORT_SYMBOL_GPL(ata_std_softreset);
@@ -7725,7 +7658,6 @@ EXPORT_SYMBOL_GPL(ata_port_desc);
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
index 94144ed..a45f6ac 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2869,7 +2869,8 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 		xlat_func = NULL;
 		if (likely((scsi_op != ATA_16) || !atapi_passthru16)) {
 			/* relay SCSI command to ATAPI device */
-			if (unlikely(scmd->cmd_len > dev->cdb_len))
+			int len = COMMAND_SIZE(scsi_op);
+			if (unlikely(len > scmd->cmd_len || len > dev->cdb_len))
 				goto bad_cdb_len;
 
 			xlat_func = atapi_xlat;
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

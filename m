Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbYD2WJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbYD2WJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYD2WJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:09:36 -0400
Received: from havoc.gtf.org ([69.61.125.42]:38684 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbYD2WJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:09:35 -0400
Date: Tue, 29 Apr 2008 18:09:34 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080429220934.GA26422@havoc.gtf.org>
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

 drivers/ata/ahci.c        |    2 +-
 drivers/ata/libata-core.c |    3 +++
 drivers/ata/pata_atiixp.c |    4 ++--
 drivers/ata/pata_via.c    |   11 ++++++-----
 include/linux/libata.h    |   12 ++++++------
 5 files changed, 18 insertions(+), 14 deletions(-)

Alan Cox (2):
      pata_via: Fix 6410 misdetect
      libata: More TSSTcorp pain, keep in sync with legacy IDE

Jeff Garzik (2):
      [libata] pata_atiixp: fix PIO timing data misprogramming
      [libata] linux/libata.h: reorganize ata_device struct members a bit

Tejun Heo (1):
      ahci: SB600 ahci can't do MSI, blacklist that capability

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 7c4f886..8cace9a 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -358,7 +358,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci_sb600 */
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
-				 AHCI_HFLAG_32BIT_ONLY |
+				 AHCI_HFLAG_32BIT_ONLY | AHCI_HFLAG_NO_MSI |
 				 AHCI_HFLAG_SECT255 | AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= 0x1f, /* pio0-4 */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 51b7d2f..3bc4885 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3933,6 +3933,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* Devices which get the IVB wrong */
 	{ "QUANTUM FIREBALLlct10 05", "A03.0900", ATA_HORKAGE_IVB, },
+	/* Maybe we should just blacklist TSSTcorp... */
+	{ "TSSTcorp CDDVDW SH-S202H", "SB00",	  ATA_HORKAGE_IVB, },
+	{ "TSSTcorp CDDVDW SH-S202H", "SB01",	  ATA_HORKAGE_IVB, },
 	{ "TSSTcorp CDDVDW SH-S202J", "SB00",	  ATA_HORKAGE_IVB, },
 	{ "TSSTcorp CDDVDW SH-S202J", "SB01",	  ATA_HORKAGE_IVB, },
 	{ "TSSTcorp CDDVDW SH-S202N", "SB00",	  ATA_HORKAGE_IVB, },
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 78738fb..d7de7ba 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -88,8 +88,8 @@ static void atiixp_set_pio_timing(struct ata_port *ap, struct ata_device *adev,
 	pci_write_config_word(pdev, ATIIXP_IDE_PIO_MODE, pio_mode_data);
 
 	pci_read_config_word(pdev, ATIIXP_IDE_PIO_TIMING, &pio_timing_data);
-	pio_mode_data &= ~(0xFF << timing_shift);
-	pio_mode_data |= (pio_timings[pio] << timing_shift);
+	pio_timing_data &= ~(0xFF << timing_shift);
+	pio_timing_data |= (pio_timings[pio] << timing_shift);
 	pci_write_config_word(pdev, ATIIXP_IDE_PIO_TIMING, pio_timing_data);
 }
 
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index d484074..2fea6cb 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -464,11 +464,12 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	pci_dev_put(isa);
 
-	/* 0x40 low bits indicate enabled channels */
-	pci_read_config_byte(pdev, 0x40 , &enable);
-	enable &= 3;
-	if (enable == 0) {
-		return -ENODEV;
+	if (!(config->flags & VIA_NO_ENABLES)) {
+		/* 0x40 low bits indicate enabled channels */
+		pci_read_config_byte(pdev, 0x40 , &enable);
+		enable &= 3;
+		if (enable == 0)
+			return -ENODEV;
 	}
 
 	/* Initialise the FIFO for the enabled channels. */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 395a523..d1dfe87 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -548,11 +548,6 @@ struct ata_device {
 	u64			n_sectors;	/* size of device, if ATA */
 	unsigned int		class;		/* ATA_DEV_xxx */
 
-	union {
-		u16		id[ATA_ID_WORDS]; /* IDENTIFY xxx DEVICE data */
-		u32		gscr[SATA_PMP_GSCR_DWORDS]; /* PMP GSCR block */
-	};
-
 	u8			pio_mode;
 	u8			dma_mode;
 	u8			xfer_mode;
@@ -574,8 +569,13 @@ struct ata_device {
 	u16			sectors;	/* Number of sectors per track */
 
 	/* error history */
-	struct ata_ering	ering;
 	int			spdn_cnt;
+	struct ata_ering	ering;
+
+	union {
+		u16		id[ATA_ID_WORDS]; /* IDENTIFY xxx DEVICE data */
+		u32		gscr[SATA_PMP_GSCR_DWORDS]; /* PMP GSCR block */
+	};
 };
 
 /* Offset into struct ata_device.  Fields above it are maintained

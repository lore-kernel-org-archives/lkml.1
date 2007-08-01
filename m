Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbXHAVyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbXHAVyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbXHAVyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:54:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:32313 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbXHAVyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LZWBeEIXZKrvIjhyJvFl3ujJJaQts3UQQrqiWzEQhmpkIQaH+cL2kMoRCbQu2DTrdlVgczFFA7aE4gm8pPHZ3lMIYptkq9I3ytg/nqE6bBlbxOMldzP0ky4pz0KZCwkDb2YTmQDhtuu1V10SF2/Eq9yLml+BhZIUk4Qkl51A3gM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Wed, 1 Aug 2007 23:52:14 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708012352.15150.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/arm/icside.c   |    3 +-
 drivers/ide/ide-tape.c     |    2 +-
 drivers/ide/pci/alim15x3.c |    2 +-
 drivers/ide/pci/cmd64x.c   |    4 +-
 drivers/ide/pci/cs5520.c   |    2 +-
 drivers/ide/pci/cs5535.c   |   42 +++++++++++++-----------------
 drivers/ide/pci/it8213.c   |   33 ++++++++++++-----------
 drivers/ide/pci/jmicron.c  |   21 +++------------
 drivers/ide/pci/piix.c     |   17 ++++++------
 drivers/ide/pci/scc_pata.c |   61 ++++++++++++++-----------------------------
 drivers/ide/pci/sis5513.c  |    1 +
 drivers/ide/pci/slc90e66.c |   15 +++++------
 drivers/scsi/ide-scsi.c    |   10 +++----
 13 files changed, 85 insertions(+), 128 deletions(-)


Bartlomiej Zolnierkiewicz (7):
      alim15x3: Correct HP detect
      cs5520: fix PIO auto-tuning in ->ide_dma_check method
      cs5535: PIO fixes
      it8213: PIO fixes (take 2)
      jmicron: PIO fixes
      piix/slc90e66: fix PIO1 handling in ->speedproc method (take 2)
      scc_pata: PIO fixes

David Lamparter (1):
      sis5513: Add FSC Amilo A1630 PCI subvendor/dev to laptops

Jordan Crouse (1):
      ide: Fix an overrun found in the CS5535 IDE driver

Mariusz Kozlowski (2):
      drivers/ide/arm/icside.c: kmalloc + memset conversion to kzalloc
      drivers/scsi/ide-scsi.c: kmalloc + memset conversion to kzalloc

Meelis Roos (1):
      ide: fix runtogether printk's in cmd64x IDE driver

Stephen Rothwell (1):
      ide: eliminate warnings in ide-tape.c


diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index c89b5f4..8a9b98f 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -693,13 +693,12 @@ icside_probe(struct expansion_card *ec, const struct ecard_id *id)
 	if (ret)
 		goto out;
 
-	state = kmalloc(sizeof(struct icside_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct icside_state), GFP_KERNEL);
 	if (!state) {
 		ret = -ENOMEM;
 		goto release;
 	}
 
-	memset(state, 0, sizeof(state));
 	state->type	= ICS_TYPE_NOTYPE;
 	state->dev	= &ec->dev;
 
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index e82bfa5..1fa5794 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -640,7 +640,7 @@ typedef enum {
 } idetape_chrdev_direction_t;
 
 struct idetape_bh {
-	unsigned short b_size;
+	u32 b_size;
 	atomic_t b_count;
 	struct idetape_bh *b_reqnext;
 	char *b_data;
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 5511c86..025689d 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -593,7 +593,7 @@ static struct dmi_system_id cable_dmi_table[] = {
 		.ident = "HP Pavilion N5430",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_BOARD_NAME, "OmniBook N32N-736"),
+			DMI_MATCH(DMI_BOARD_VERSION, "OmniBook N32N-736"),
 		},
 	},
 	{ }
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 19633c5..0e3b5de 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -475,11 +475,11 @@ static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev, const cha
 		switch (rev) {
 		case 0x07:
 		case 0x05:
-			printk("%s: UltraDMA capable", name);
+			printk("%s: UltraDMA capable\n", name);
 			break;
 		case 0x03:
 		default:
-			printk("%s: MultiWord DMA force limited", name);
+			printk("%s: MultiWord DMA force limited\n", name);
 			break;
 		case 0x01:
 			printk("%s: MultiWord DMA limited, "
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index bccedf9..b89e816 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -133,7 +133,7 @@ static void cs5520_tune_drive(ide_drive_t *drive, u8 pio)
 static int cs5520_config_drive_xfer_rate(ide_drive_t *drive)
 {
 	/* Tune the drive for PIO modes up to PIO 4 */	
-	cs5520_tune_drive(drive, 4);
+	cs5520_tune_drive(drive, 255);
 
 	/* Then tell the core to use DMA operations */
 	return 0;
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index ce44e38..082ca7d 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -2,6 +2,7 @@
  * linux/drivers/ide/pci/cs5535.c
  *
  * Copyright (C) 2004-2005 Advanced Micro Devices, Inc.
+ * Copyright (C)      2007 Bartlomiej Zolnierkiewicz
  *
  * History:
  * 09/20/2005 - Jaya Kumar <jayakumar.ide@gmail.com>
@@ -83,14 +84,17 @@ static void cs5535_set_speed(ide_drive_t *drive, u8 speed)
 
 	/* Set the PIO timings */
 	if ((speed & XFER_MODE) == XFER_PIO) {
-		u8 pioa;
-		u8 piob;
-		u8 cmd;
+		ide_drive_t *pair = &drive->hwif->drives[drive->dn ^ 1];
+		u8 cmd, pioa;
 
-		pioa = speed - XFER_PIO_0;
-		piob = ide_get_best_pio_mode(&(drive->hwif->drives[!unit]),
-						255, 4);
-		cmd = pioa < piob ? pioa : piob;
+		cmd = pioa = speed - XFER_PIO_0;
+
+		if (pair->present) {
+			u8 piob = ide_get_best_pio_mode(pair, 255, 4);
+
+			if (piob < cmd)
+				cmd = piob;
+		}
 
 		/* Write the speed of the current drive */
 		reg = (cs5535_pio_cmd_timings[cmd] << 16) |
@@ -116,7 +120,7 @@ static void cs5535_set_speed(ide_drive_t *drive, u8 speed)
 
 		reg &= 0x80000000UL;  /* Preserve the PIO format bit */
 
-		if (speed >= XFER_UDMA_0 && speed <= XFER_UDMA_7)
+		if (speed >= XFER_UDMA_0 && speed <= XFER_UDMA_4)
 			reg |= cs5535_udma_timings[speed - XFER_UDMA_0];
 		else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
 			reg |= cs5535_mwdma_timings[speed - XFER_MW_DMA_0];
@@ -151,32 +155,22 @@ static int cs5535_set_drive(ide_drive_t *drive, u8 speed)
  *
  *	A callback from the upper layers for PIO-only tuning.
  */
-static void cs5535_tuneproc(ide_drive_t *drive, u8 xferspeed)
+static void cs5535_tuneproc(ide_drive_t *drive, u8 pio)
 {
-	u8 modes[] = {	XFER_PIO_0, XFER_PIO_1, XFER_PIO_2, XFER_PIO_3,
-			XFER_PIO_4 };
-
-	/* cs5535 max pio is pio 4, best_pio will check the blacklist.
-	i think we don't need to rate_filter the incoming xferspeed
-	since we know we're only going to choose pio */
-	xferspeed = ide_get_best_pio_mode(drive, xferspeed, 4);
-	ide_config_drive_speed(drive, modes[xferspeed]);
-	cs5535_set_speed(drive, xferspeed);
+	pio = ide_get_best_pio_mode(drive, pio, 4);
+	ide_config_drive_speed(drive, XFER_PIO_0 + pio);
+	cs5535_set_speed(drive, XFER_PIO_0 + pio);
 }
 
 static int cs5535_dma_check(ide_drive_t *drive)
 {
-	u8 speed;
-
 	drive->init_speed = 0;
 
 	if (ide_tune_dma(drive))
 		return 0;
 
-	if (ide_use_fast_pio(drive)) {
-		speed = ide_get_best_pio_mode(drive, 255, 4);
-		cs5535_set_drive(drive, speed);
-	}
+	if (ide_use_fast_pio(drive))
+		cs5535_tuneproc(drive, 255);
 
 	return -1;
 }
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index 95dbed7..70b3245 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -21,7 +21,7 @@
  *	it8213_dma_2_pio		-	return the PIO mode matching DMA
  *	@xfer_rate: transfer speed
  *
- *	Returns the nearest equivalent PIO timing for the PIO or DMA
+ *	Returns the nearest equivalent PIO timing for the DMA
  *	mode requested by the controller.
  */
 
@@ -35,34 +35,28 @@ static u8 it8213_dma_2_pio (u8 xfer_rate) {
 		case XFER_UDMA_1:
 		case XFER_UDMA_0:
 		case XFER_MW_DMA_2:
-		case XFER_PIO_4:
 			return 4;
 		case XFER_MW_DMA_1:
-		case XFER_PIO_3:
 			return 3;
 		case XFER_SW_DMA_2:
-		case XFER_PIO_2:
 			return 2;
 		case XFER_MW_DMA_0:
 		case XFER_SW_DMA_1:
 		case XFER_SW_DMA_0:
-		case XFER_PIO_1:
-		case XFER_PIO_0:
-		case XFER_PIO_SLOW:
 		default:
 			return 0;
 	}
 }
 
 /*
- *	it8213_tuneproc	-	tune a drive
+ *	it8213_tune_pio	-	tune a drive
  *	@drive: drive to tune
  *	@pio: desired PIO mode
  *
  *	Set the interface PIO mode.
  */
 
-static void it8213_tuneproc (ide_drive_t *drive, u8 pio)
+static void it8213_tune_pio(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -82,8 +76,6 @@ static void it8213_tuneproc (ide_drive_t *drive, u8 pio)
 					{ 2, 1 },
 					{ 2, 3 }, };
 
-	pio = ide_get_best_pio_mode(drive, pio, 4);
-
 	spin_lock_irqsave(&tune_lock, flags);
 	pci_read_config_word(dev, master_port, &master_data);
 
@@ -113,6 +105,13 @@ static void it8213_tuneproc (ide_drive_t *drive, u8 pio)
 	spin_unlock_irqrestore(&tune_lock, flags);
 }
 
+static void it8213_tuneproc(ide_drive_t *drive, u8 pio)
+{
+	pio = ide_get_best_pio_mode(drive, pio, 4);
+	it8213_tune_pio(drive, pio);
+	ide_config_drive_speed(drive, XFER_PIO_0 + pio);
+}
+
 /**
  *	it8213_tune_chipset	-	set controller timings
  *	@drive: Drive to set up
@@ -193,7 +192,12 @@ static int it8213_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		if (reg55 & w_flag)
 			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
 	}
-	it8213_tuneproc(drive, it8213_dma_2_pio(speed));
+
+	if (speed > XFER_PIO_4)
+		it8213_tune_pio(drive, it8213_dma_2_pio(speed));
+	else
+		it8213_tune_pio(drive, speed - XFER_PIO_0);
+
 	return ide_config_drive_speed(drive, speed);
 }
 
@@ -209,13 +213,10 @@ static int it8213_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 
 static int it8213_config_drive_for_dma (ide_drive_t *drive)
 {
-	u8 pio;
-
 	if (ide_tune_dma(drive))
 		return 0;
 
-	pio = ide_get_best_pio_mode(drive, 255, 4);
-	it8213_tune_chipset(drive, XFER_PIO_0 + pio);
+	it8213_tuneproc(drive, 255);
 
 	return -1;
 }
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index d7ce9dd..65a0ff3 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -83,23 +83,10 @@ static u8 __devinit ata66_jmicron(ide_hwif_t *hwif)
 	return ATA_CBL_PATA80;
 }
 
-static void jmicron_tuneproc (ide_drive_t *drive, byte mode_wanted)
+static void jmicron_tuneproc(ide_drive_t *drive, u8 pio)
 {
-	return;
-}
-
-/**
- *	config_jmicron_chipset_for_pio	-	set drive timings
- *	@drive: drive to tune
- *	@speed we want
- *
- */
-
-static void config_jmicron_chipset_for_pio (ide_drive_t *drive, byte set_speed)
-{
-	u8 speed = XFER_PIO_0 + ide_get_best_pio_mode(drive, 255, 5);
-	if (set_speed)
-		(void) ide_config_drive_speed(drive, speed);
+	pio = ide_get_best_pio_mode(drive, pio, 5);
+	ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
 /**
@@ -132,7 +119,7 @@ static int jmicron_config_drive_for_dma (ide_drive_t *drive)
 	if (ide_tune_dma(drive))
 		return 0;
 
-	config_jmicron_chipset_for_pio(drive, 1);
+	jmicron_tuneproc(drive, 255);
 
 	return -1;
 }
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 4f69cd0..5cfa937 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/piix.c	Version 0.50	Jun 10, 2007
+ *  linux/drivers/ide/pci/piix.c	Version 0.51	Jul 6, 2007
  *
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
@@ -109,7 +109,7 @@ static int no_piix_dma;
  *	piix_dma_2_pio		-	return the PIO mode matching DMA
  *	@xfer_rate: transfer speed
  *
- *	Returns the nearest equivalent PIO timing for the PIO or DMA
+ *	Returns the nearest equivalent PIO timing for the DMA
  *	mode requested by the controller.
  */
  
@@ -123,20 +123,14 @@ static u8 piix_dma_2_pio (u8 xfer_rate) {
 		case XFER_UDMA_1:
 		case XFER_UDMA_0:
 		case XFER_MW_DMA_2:
-		case XFER_PIO_4:
 			return 4;
 		case XFER_MW_DMA_1:
-		case XFER_PIO_3:
 			return 3;
 		case XFER_SW_DMA_2:
-		case XFER_PIO_2:
 			return 2;
 		case XFER_MW_DMA_0:
 		case XFER_SW_DMA_1:
 		case XFER_SW_DMA_0:
-		case XFER_PIO_1:
-		case XFER_PIO_0:
-		case XFER_PIO_SLOW:
 		default:
 			return 0;
 	}
@@ -269,6 +263,7 @@ static int piix_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		case XFER_PIO_4:
 		case XFER_PIO_3:
 		case XFER_PIO_2:
+		case XFER_PIO_1:
 		case XFER_PIO_0:	break;
 		default:		return -1;
 	}
@@ -299,7 +294,11 @@ static int piix_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
 	}
 
-	piix_tune_pio(drive, piix_dma_2_pio(speed));
+	if (speed > XFER_PIO_4)
+		piix_tune_pio(drive, piix_dma_2_pio(speed));
+	else
+		piix_tune_pio(drive, speed - XFER_PIO_0);
+
 	return ide_config_drive_speed(drive, speed);
 }
 
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index bf19ddf..eeb0a6d 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -190,7 +190,7 @@ scc_ide_outsl(unsigned long port, void *addr, u32 count)
 }
 
 /**
- *	scc_tuneproc	-	tune a drive PIO mode
+ *	scc_tune_pio	-	tune a drive PIO mode
  *	@drive: drive to tune
  *	@mode_wanted: the target operating mode
  *
@@ -198,7 +198,7 @@ scc_ide_outsl(unsigned long port, void *addr, u32 count)
  *	controller.
  */
 
-static void scc_tuneproc(ide_drive_t *drive, byte mode_wanted)
+static void scc_tune_pio(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
@@ -207,41 +207,25 @@ static void scc_tuneproc(ide_drive_t *drive, byte mode_wanted)
 	unsigned long piosht_port = ctl_base + 0x000;
 	unsigned long pioct_port = ctl_base + 0x004;
 	unsigned long reg;
-	unsigned char speed = XFER_PIO_0;
 	int offset;
 
-	mode_wanted = ide_get_best_pio_mode(drive, mode_wanted, 4);
-	switch (mode_wanted) {
-	case 4:
-		speed = XFER_PIO_4;
-		break;
-	case 3:
-		speed = XFER_PIO_3;
-		break;
-	case 2:
-		speed = XFER_PIO_2;
-		break;
-	case 1:
-		speed = XFER_PIO_1;
-		break;
-	case 0:
-	default:
-		speed = XFER_PIO_0;
-		break;
-	}
-
 	reg = in_be32((void __iomem *)cckctrl_port);
 	if (reg & CCKCTRL_ATACLKOEN) {
 		offset = 1; /* 133MHz */
 	} else {
 		offset = 0; /* 100MHz */
 	}
-	reg = JCHSTtbl[offset][mode_wanted] << 16 | JCHHTtbl[offset][mode_wanted];
+	reg = JCHSTtbl[offset][pio] << 16 | JCHHTtbl[offset][pio];
 	out_be32((void __iomem *)piosht_port, reg);
-	reg = JCHCTtbl[offset][mode_wanted];
+	reg = JCHCTtbl[offset][pio];
 	out_be32((void __iomem *)pioct_port, reg);
+}
 
-	ide_config_drive_speed(drive, speed);
+static void scc_tuneproc(ide_drive_t *drive, u8 pio)
+{
+	pio = ide_get_best_pio_mode(drive, pio, 4);
+	scc_tune_pio(drive, pio);
+	ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
 /**
@@ -280,26 +264,21 @@ static int scc_tune_chipset(ide_drive_t *drive, byte xferspeed)
 
 	switch (speed) {
 	case XFER_UDMA_6:
-		idx = 6;
-		break;
 	case XFER_UDMA_5:
-		idx = 5;
-		break;
 	case XFER_UDMA_4:
-		idx = 4;
-		break;
 	case XFER_UDMA_3:
-		idx = 3;
-		break;
 	case XFER_UDMA_2:
-		idx = 2;
-		break;
 	case XFER_UDMA_1:
-		idx = 1;
-		break;
 	case XFER_UDMA_0:
-		idx = 0;
+		idx = speed - XFER_UDMA_0;
 		break;
+	case XFER_PIO_4:
+	case XFER_PIO_3:
+	case XFER_PIO_2:
+	case XFER_PIO_1:
+	case XFER_PIO_0:
+		scc_tune_pio(drive, speed - XFER_PIO_0);
+		return ide_config_drive_speed(drive, speed);
 	default:
 		return 1;
 	}
@@ -329,7 +308,7 @@ static int scc_tune_chipset(ide_drive_t *drive, byte xferspeed)
  *	required.
  *      If the drive isn't suitable for DMA or we hit other problems
  *      then we will drop down to PIO and set up PIO appropriately.
- *      (return 1)
+ *      (return -1)
  */
 
 static int scc_config_drive_for_dma(ide_drive_t *drive)
@@ -338,7 +317,7 @@ static int scc_config_drive_for_dma(ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		scc_tuneproc(drive, 4);
+		scc_tuneproc(drive, 255);
 
 	return -1;
 }
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 63fbb79..26f2480 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -801,6 +801,7 @@ struct sis_laptop {
 static const struct sis_laptop sis_laptop[] = {
 	/* devid, subvendor, subdev */
 	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
+	{ 0x5513, 0x1734, 0x105f },	/* FSC Amilo A1630 */
 	/* end marker */
 	{ 0, }
 };
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index 8e655f2..628b066 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/slc90e66.c	Version 0.14	February 8, 2007
+ *  linux/drivers/ide/pci/slc90e66.c	Version 0.15	Jul 6, 2007
  *
  *  Copyright (C) 2000-2002 Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
@@ -29,20 +29,14 @@ static u8 slc90e66_dma_2_pio (u8 xfer_rate) {
 		case XFER_UDMA_1:
 		case XFER_UDMA_0:
 		case XFER_MW_DMA_2:
-		case XFER_PIO_4:
 			return 4;
 		case XFER_MW_DMA_1:
-		case XFER_PIO_3:
 			return 3;
 		case XFER_SW_DMA_2:
-		case XFER_PIO_2:
 			return 2;
 		case XFER_MW_DMA_0:
 		case XFER_SW_DMA_1:
 		case XFER_SW_DMA_0:
-		case XFER_PIO_1:
-		case XFER_PIO_0:
-		case XFER_PIO_SLOW:
 		default:
 			return 0;
 	}
@@ -136,6 +130,7 @@ static int slc90e66_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 		case XFER_PIO_4:
 		case XFER_PIO_3:
 		case XFER_PIO_2:
+		case XFER_PIO_1:
 		case XFER_PIO_0:        break;
 		default:		return -1;
 	}
@@ -156,7 +151,11 @@ static int slc90e66_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 			pci_write_config_word(dev, 0x4a, reg4a & ~a_speed);
 	}
 
-	slc90e66_tune_pio(drive, slc90e66_dma_2_pio(speed));
+	if (speed > XFER_PIO_4)
+		slc90e66_tune_pio(drive, slc90e66_dma_2_pio(speed));
+	else
+		slc90e66_tune_pio(drive, speed - XFER_PIO_0);
+
 	return ide_config_drive_speed(drive, speed);
 }
 
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index bb90df8..1cc01ac 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -328,17 +328,15 @@ static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_co
 	u8             *buf;
 
 	/* stuff a sense request in front of our current request */
-	pc = kmalloc (sizeof (idescsi_pc_t), GFP_ATOMIC);
-	rq = kmalloc (sizeof (struct request), GFP_ATOMIC);
-	buf = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_ATOMIC);
-	if (pc == NULL || rq == NULL || buf == NULL) {
+	pc = kzalloc(sizeof(idescsi_pc_t), GFP_ATOMIC);
+	rq = kmalloc(sizeof(struct request), GFP_ATOMIC);
+	buf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_ATOMIC);
+	if (!pc || !rq || !buf) {
 		kfree(buf);
 		kfree(rq);
 		kfree(pc);
 		return -ENOMEM;
 	}
-	memset (pc, 0, sizeof (idescsi_pc_t));
-	memset (buf, 0, SCSI_SENSE_BUFFERSIZE);
 	ide_init_drive_cmd(rq);
 	rq->special = (char *) pc;
 	pc->rq = rq;

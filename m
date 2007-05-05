Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXEEUIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXEEUIj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933318AbXEEUIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:08:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:60962 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbXEEUIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:08:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YLpGdM9P/c0pZNKbnYnGELjaR+TNsg1Tt+caPho5s6vo+WONt0qwuRe0VYtS4O6uL0d/HuFiKVrwXC/TTUm8erUbrVLNR5nMlxOW0SuYz16NunZ4/EIvn8/yyg1v/hc7AGagPcikuhBNMxVpp/xr8CQDs9VAD0HJeuay4Hf/auc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE updates
Date: Sat, 5 May 2007 22:15:20 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705052215.20359.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Updates/fixes for host drivers.


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/cris/ide-cris.c    |    9 +-
 drivers/ide/legacy/ide-cs.c    |    1 +
 drivers/ide/pci/aec62xx.c      |   22 +--
 drivers/ide/pci/alim15x3.c     |    7 +-
 drivers/ide/pci/cmd64x.c       |  537 +++++++++++++++++++++-------------------
 drivers/ide/pci/hpt366.c       |    7 +-
 drivers/ide/pci/it821x.c       |  126 +++++-----
 drivers/ide/pci/pdc202xx_new.c |    3 -
 drivers/ide/pci/siimage.c      |   12 +-
 drivers/ide/pci/sl82c105.c     |  247 ++++++++-----------
 include/linux/ide.h            |    1 -
 11 files changed, 459 insertions(+), 513 deletions(-)


Bartlomiej Zolnierkiewicz (5):
      alim15x3: PIO fallback fix
      pdc202xx_new: enable DMA for all ATAPI devices
      it821x: PIO mode setup fixes
      siimage: fix wrong ->swdma_mask
      ide-cris: fix ->speedproc and wrong ->swdma_mask

Fabrice Aeschbacher (1):
      ide-cs: recognize 2GB CompactFlash from Transcend

Sergei Shtylyov (9):
      sl82c105: rework PIO support (take 2)
      sl82c105: DMA support code cleanup (take 4)
      cmd64x: fix multiword and remove single-word DMA support
      cmd64x: interrupt status fixes (take 2)
      cmd64x: add/fix enablebits (take 2)
      cmd64x: procfs code fixes/cleanups (take 2)
      cmd64x: use interrupt status from MRDMODE register (take 2)
      aec62xx: fix PIO/DMA setup issues
      hpt366: don't check enablebits for HPT36x


diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 556455f..5e8efc8 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -730,7 +730,7 @@ static int speed_cris_ide(ide_drive_t *drive, u8 speed)
 
 	if (speed >= XFER_PIO_0 && speed <= XFER_PIO_4) {
 		tune_cris_ide(drive, speed - XFER_PIO_0);
-		return 0;
+		return ide_config_drive_speed(drive, speed);
 	}
 
 	switch(speed)
@@ -760,7 +760,8 @@ static int speed_cris_ide(ide_drive_t *drive, u8 speed)
 			hold = ATA_DMA2_HOLD;
 			break;
 		default:
-			return 0;
+			BUG();
+			break;
 	}
 
 	if (speed >= XFER_UDMA_0)
@@ -768,7 +769,7 @@ static int speed_cris_ide(ide_drive_t *drive, u8 speed)
 	else
 		cris_ide_set_speed(TYPE_DMA, 0, strobe, hold);
 
-	return 0;
+	return ide_config_drive_speed(drive, speed);
 }
 
 void __init
@@ -821,7 +822,6 @@ init_e100_ide (void)
 		hwif->udma_four = 0;
 		hwif->ultra_mask = cris_ultra_mask;
 		hwif->mwdma_mask = 0x07; /* Multiword DMA 0-2 */
-		hwif->swdma_mask = 0x07; /* Singleword DMA 0-2 */
 		hwif->autodma = 1;
 		hwif->drives[0].autodma = 1;
 		hwif->drives[1].autodma = 1;
@@ -1010,7 +1010,6 @@ static int cris_config_drive_for_dma (ide_drive_t *drive)
 		return 0;
 
 	speed_cris_ide(drive, speed);
-	ide_config_drive_speed(drive, speed);
 
 	return ide_dma_enable(drive);
 }
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index b08c37c..c6522a6 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -401,6 +401,7 @@ static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a, 0x3489e003),
 	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
 	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
 	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index 990eafe..73bdf64 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -1,7 +1,8 @@
 /*
- * linux/drivers/ide/pci/aec62xx.c		Version 0.11	March 27, 2002
+ * linux/drivers/ide/pci/aec62xx.c		Version 0.21	Apr 21, 2007
  *
  * Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
+ * Copyright (C) 2007		MontaVista Software, Inc. <source@mvista.com>
  *
  */
 
@@ -193,18 +194,8 @@ static int config_chipset_for_dma (ide_drive_t *drive)
 
 static void aec62xx_tune_drive (ide_drive_t *drive, u8 pio)
 {
-	u8 speed = 0;
-	u8 new_pio = XFER_PIO_0 + ide_get_best_pio_mode(drive, 255, 5, NULL);
-
-	switch(pio) {
-		case 5:		speed = new_pio; break;
-		case 4:		speed = XFER_PIO_4; break;
-		case 3:		speed = XFER_PIO_3; break;
-		case 2:		speed = XFER_PIO_2; break;
-		case 1:		speed = XFER_PIO_1; break;
-		default:	speed = XFER_PIO_0; break;
-	}
-	(void) aec62xx_tune_chipset(drive, speed);
+	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	(void) aec62xx_tune_chipset(drive, pio + XFER_PIO_0);
 }
 
 static int aec62xx_config_drive_xfer_rate (ide_drive_t *drive)
@@ -213,7 +204,7 @@ static int aec62xx_config_drive_xfer_rate (ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		aec62xx_tune_drive(drive, 5);
+		aec62xx_tune_drive(drive, 255);
 
 	return -1;
 }
@@ -288,11 +279,10 @@ static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 
 	hwif->ultra_mask = 0x7f;
 	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
 
 	hwif->ide_dma_check	= &aec62xx_config_drive_xfer_rate;
 	hwif->ide_dma_lostirq	= &aec62xx_irq_timeout;
-	hwif->ide_dma_timeout	= &aec62xx_irq_timeout;
+
 	if (!noautodma)
 		hwif->autodma = 1;
 	hwif->drives[0].autodma = hwif->autodma;
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 83e0aa6..946a127 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -534,7 +534,7 @@ static int ali15x3_config_drive_for_dma(ide_drive_t *drive)
 	struct hd_driveid *id	= drive->id;
 
 	if ((m5229_revision<=0x20) && (drive->media!=ide_disk))
-		goto no_dma_set;
+		goto ata_pio;
 
 	drive->init_speed = 0;
 
@@ -555,20 +555,19 @@ try_dma_modes:
 			    (id->dma_1word & hwif->swdma_mask)) {
 				/* Force if Capable regular DMA modes */
 				if (!config_chipset_for_dma(drive))
-					goto no_dma_set;
+					goto ata_pio;
 			}
 		} else if (__ide_dma_good_drive(drive) &&
 			   (id->eide_dma_time < 150)) {
 			/* Consult the list of known "good" drives */
 			if (!config_chipset_for_dma(drive))
-				goto no_dma_set;
+				goto ata_pio;
 		} else {
 			goto ata_pio;
 		}
 	} else {
 ata_pio:
 		hwif->tuneproc(drive, 255);
-no_dma_set:
 		return -1;
 	}
 
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 561197f..77f51ab 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -1,10 +1,7 @@
-/* $Id: cmd64x.c,v 1.21 2000/01/30 23:23:16
- *
- * linux/drivers/ide/pci/cmd64x.c		Version 1.42	Feb 8, 2007
+/*
+ * linux/drivers/ide/pci/cmd64x.c		Version 1.47	Mar 19, 2007
  *
  * cmd64x.c: Enable interrupts at initialization time on Ultra/PCI machines.
- *           Note, this driver is not used at all on other systems because
- *           there the "BIOS" has done all of the following already.
  *           Due to massive hardware bugs, UltraDMA is only supported
  *           on the 646U2 and not on the 646U.
  *
@@ -39,11 +36,12 @@
  * CMD64x specific registers definition.
  */
 #define CFR		0x50
-#define   CFR_INTR_CH0		0x02
+#define   CFR_INTR_CH0		0x04
 #define CNTRL		0x51
-#define	  CNTRL_DIS_RA0		0x40
-#define   CNTRL_DIS_RA1		0x80
-#define	  CNTRL_ENA_2ND		0x08
+#define   CNTRL_ENA_1ST 	0x04
+#define   CNTRL_ENA_2ND 	0x08
+#define   CNTRL_DIS_RA0 	0x40
+#define   CNTRL_DIS_RA1 	0x80
 
 #define	CMDTIM		0x52
 #define	ARTTIM0		0x53
@@ -90,86 +88,67 @@ static int n_cmd_devs;
 static char * print_cmd64x_get_info (char *buf, struct pci_dev *dev, int index)
 {
 	char *p = buf;
-
-	u8 reg53 = 0, reg54 = 0, reg55 = 0, reg56 = 0;	/* primary */
-	u8 reg57 = 0, reg58 = 0, reg5b;			/* secondary */
 	u8 reg72 = 0, reg73 = 0;			/* primary */
 	u8 reg7a = 0, reg7b = 0;			/* secondary */
-	u8 reg50 = 0, reg71 = 0;			/* extra */
+	u8 reg50 = 1, reg51 = 1, reg57 = 0, reg71 = 0;	/* extra */
+	u8 rev = 0;
 
 	p += sprintf(p, "\nController: %d\n", index);
-	p += sprintf(p, "CMD%x Chipset.\n", dev->device);
+	p += sprintf(p, "PCI-%x Chipset.\n", dev->device);
+
 	(void) pci_read_config_byte(dev, CFR,       &reg50);
-	(void) pci_read_config_byte(dev, ARTTIM0,   &reg53);
-	(void) pci_read_config_byte(dev, DRWTIM0,   &reg54);
-	(void) pci_read_config_byte(dev, ARTTIM1,   &reg55);
-	(void) pci_read_config_byte(dev, DRWTIM1,   &reg56);
-	(void) pci_read_config_byte(dev, ARTTIM2,   &reg57);
-	(void) pci_read_config_byte(dev, DRWTIM2,   &reg58);
-	(void) pci_read_config_byte(dev, DRWTIM3,   &reg5b);
+	(void) pci_read_config_byte(dev, CNTRL,     &reg51);
+	(void) pci_read_config_byte(dev, ARTTIM23,  &reg57);
 	(void) pci_read_config_byte(dev, MRDMODE,   &reg71);
 	(void) pci_read_config_byte(dev, BMIDESR0,  &reg72);
 	(void) pci_read_config_byte(dev, UDIDETCR0, &reg73);
 	(void) pci_read_config_byte(dev, BMIDESR1,  &reg7a);
 	(void) pci_read_config_byte(dev, UDIDETCR1, &reg7b);
 
-	p += sprintf(p, "--------------- Primary Channel "
-			"---------------- Secondary Channel "
-			"-------------\n");
-	p += sprintf(p, "                %sabled           "
-			"              %sabled\n",
-		(reg72&0x80)?"dis":" en",
-		(reg7a&0x80)?"dis":" en");
-	p += sprintf(p, "--------------- drive0 "
-		"--------- drive1 -------- drive0 "
-		"---------- drive1 ------\n");
-	p += sprintf(p, "DMA enabled:    %s              %s"
-			"             %s               %s\n",
-		(reg72&0x20)?"yes":"no ", (reg72&0x40)?"yes":"no ",
-		(reg7a&0x20)?"yes":"no ", (reg7a&0x40)?"yes":"no ");
-
-	p += sprintf(p, "DMA Mode:       %s(%s)          %s(%s)",
-		(reg72&0x20)?((reg73&0x01)?"UDMA":" DMA"):" PIO",
-		(reg72&0x20)?(
-			((reg73&0x30)==0x30)?(((reg73&0x35)==0x35)?"3":"0"):
-			((reg73&0x20)==0x20)?(((reg73&0x25)==0x25)?"3":"1"):
-			((reg73&0x10)==0x10)?(((reg73&0x15)==0x15)?"4":"2"):
-			((reg73&0x00)==0x00)?(((reg73&0x05)==0x05)?"5":"2"):
-			"X"):"?",
-		(reg72&0x40)?((reg73&0x02)?"UDMA":" DMA"):" PIO",
-		(reg72&0x40)?(
-			((reg73&0xC0)==0xC0)?(((reg73&0xC5)==0xC5)?"3":"0"):
-			((reg73&0x80)==0x80)?(((reg73&0x85)==0x85)?"3":"1"):
-			((reg73&0x40)==0x40)?(((reg73&0x4A)==0x4A)?"4":"2"):
-			((reg73&0x00)==0x00)?(((reg73&0x0A)==0x0A)?"5":"2"):
-			"X"):"?");
-	p += sprintf(p, "         %s(%s)           %s(%s)\n",
-		(reg7a&0x20)?((reg7b&0x01)?"UDMA":" DMA"):" PIO",
-		(reg7a&0x20)?(
-			((reg7b&0x30)==0x30)?(((reg7b&0x35)==0x35)?"3":"0"):
-			((reg7b&0x20)==0x20)?(((reg7b&0x25)==0x25)?"3":"1"):
-			((reg7b&0x10)==0x10)?(((reg7b&0x15)==0x15)?"4":"2"):
-			((reg7b&0x00)==0x00)?(((reg7b&0x05)==0x05)?"5":"2"):
-			"X"):"?",
-		(reg7a&0x40)?((reg7b&0x02)?"UDMA":" DMA"):" PIO",
-		(reg7a&0x40)?(
-			((reg7b&0xC0)==0xC0)?(((reg7b&0xC5)==0xC5)?"3":"0"):
-			((reg7b&0x80)==0x80)?(((reg7b&0x85)==0x85)?"3":"1"):
-			((reg7b&0x40)==0x40)?(((reg7b&0x4A)==0x4A)?"4":"2"):
-			((reg7b&0x00)==0x00)?(((reg7b&0x0A)==0x0A)?"5":"2"):
-			"X"):"?" );
-	p += sprintf(p, "PIO Mode:       %s                %s"
-			"               %s                 %s\n",
-			"?", "?", "?", "?");
-	p += sprintf(p, "                %s                     %s\n",
-		(reg50 & CFR_INTR_CH0) ? "interrupting" : "polling     ",
-		(reg57 & ARTTIM23_INTR_CH1) ? "interrupting" : "polling");
-	p += sprintf(p, "                %s                          %s\n",
-		(reg71 & MRDMODE_INTR_CH0) ? "pending" : "clear  ",
-		(reg71 & MRDMODE_INTR_CH1) ? "pending" : "clear");
-	p += sprintf(p, "                %s                          %s\n",
-		(reg71 & MRDMODE_BLK_CH0) ? "blocked" : "enabled",
-		(reg71 & MRDMODE_BLK_CH1) ? "blocked" : "enabled");
+	/* PCI0643/6 originally didn't have the primary channel enable bit */
+	(void) pci_read_config_byte(dev, PCI_REVISION_ID, &rev);
+	if ((dev->device == PCI_DEVICE_ID_CMD_643) ||
+	    (dev->device == PCI_DEVICE_ID_CMD_646 && rev < 3))
+		reg51 |= CNTRL_ENA_1ST;
+
+	p += sprintf(p, "---------------- Primary Channel "
+			"---------------- Secondary Channel ------------\n");
+	p += sprintf(p, "                 %s                         %s\n",
+		 (reg51 & CNTRL_ENA_1ST) ? "enabled " : "disabled",
+		 (reg51 & CNTRL_ENA_2ND) ? "enabled " : "disabled");
+	p += sprintf(p, "---------------- drive0 --------- drive1 "
+			"-------- drive0 --------- drive1 ------\n");
+	p += sprintf(p, "DMA enabled:     %s              %s"
+			"             %s              %s\n",
+		(reg72 & 0x20) ? "yes" : "no ", (reg72 & 0x40) ? "yes" : "no ",
+		(reg7a & 0x20) ? "yes" : "no ", (reg7a & 0x40) ? "yes" : "no ");
+	p += sprintf(p, "UltraDMA mode:   %s (%c)          %s (%c)",
+		( reg73 & 0x01) ? " on" : "off",
+		((reg73 & 0x30) == 0x30) ? ((reg73 & 0x04) ? '3' : '0') :
+		((reg73 & 0x30) == 0x20) ? ((reg73 & 0x04) ? '3' : '1') :
+		((reg73 & 0x30) == 0x10) ? ((reg73 & 0x04) ? '4' : '2') :
+		((reg73 & 0x30) == 0x00) ? ((reg73 & 0x04) ? '5' : '2') : '?',
+		( reg73 & 0x02) ? " on" : "off",
+		((reg73 & 0xC0) == 0xC0) ? ((reg73 & 0x08) ? '3' : '0') :
+		((reg73 & 0xC0) == 0x80) ? ((reg73 & 0x08) ? '3' : '1') :
+		((reg73 & 0xC0) == 0x40) ? ((reg73 & 0x08) ? '4' : '2') :
+		((reg73 & 0xC0) == 0x00) ? ((reg73 & 0x08) ? '5' : '2') : '?');
+	p += sprintf(p, "         %s (%c)          %s (%c)\n",
+		( reg7b & 0x01) ? " on" : "off",
+		((reg7b & 0x30) == 0x30) ? ((reg7b & 0x04) ? '3' : '0') :
+		((reg7b & 0x30) == 0x20) ? ((reg7b & 0x04) ? '3' : '1') :
+		((reg7b & 0x30) == 0x10) ? ((reg7b & 0x04) ? '4' : '2') :
+		((reg7b & 0x30) == 0x00) ? ((reg7b & 0x04) ? '5' : '2') : '?',
+		( reg7b & 0x02) ? " on" : "off",
+		((reg7b & 0xC0) == 0xC0) ? ((reg7b & 0x08) ? '3' : '0') :
+		((reg7b & 0xC0) == 0x80) ? ((reg7b & 0x08) ? '3' : '1') :
+		((reg7b & 0xC0) == 0x40) ? ((reg7b & 0x08) ? '4' : '2') :
+		((reg7b & 0xC0) == 0x00) ? ((reg7b & 0x08) ? '5' : '2') : '?');
+	p += sprintf(p, "Interrupt:       %s, %s                 %s, %s\n",
+		(reg71 & MRDMODE_BLK_CH0  ) ? "blocked" : "enabled",
+		(reg50 & CFR_INTR_CH0	  ) ? "pending" : "clear  ",
+		(reg71 & MRDMODE_BLK_CH1  ) ? "blocked" : "enabled",
+		(reg57 & ARTTIM23_INTR_CH1) ? "pending" : "clear  ");
 
 	return (char *)p;
 }
@@ -179,7 +158,6 @@ static int cmd64x_get_info (char *buffer, char **addr, off_t offset, int count)
 	char *p = buffer;
 	int i;
 
-	p += sprintf(p, "\n");
 	for (i = 0; i < n_cmd_devs; i++) {
 		struct pci_dev *dev	= cmd_devs[i];
 		p = print_cmd64x_get_info(p, dev, i);
@@ -195,116 +173,103 @@ static u8 quantize_timing(int timing, int quant)
 }
 
 /*
- * This routine writes the prepared setup/active/recovery counts
- * for a drive into the cmd646 chipset registers to active them.
+ * This routine calculates active/recovery counts and then writes them into
+ * the chipset registers.
  */
-static void program_drive_counts (ide_drive_t *drive, int setup_count, int active_count, int recovery_count)
+static void program_cycle_times (ide_drive_t *drive, int cycle_time, int active_time)
 {
-	unsigned long flags;
-	struct pci_dev *dev = HWIF(drive)->pci_dev;
-	ide_drive_t *drives = HWIF(drive)->drives;
-	u8 temp_b;
-	static const u8 setup_counts[] = {0x40, 0x40, 0x40, 0x80, 0, 0xc0};
-	static const u8 recovery_counts[] =
+	struct pci_dev *dev	= HWIF(drive)->pci_dev;
+	int clock_time		= 1000 / system_bus_clock();
+	u8  cycle_count, active_count, recovery_count, drwtim;
+	static const u8 recovery_values[] =
 		{15, 15, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0};
-	static const u8 arttim_regs[2][2] = {
-			{ ARTTIM0, ARTTIM1 },
-			{ ARTTIM23, ARTTIM23 }
-		};
-	static const u8 drwtim_regs[2][2] = {
-			{ DRWTIM0, DRWTIM1 },
-			{ DRWTIM2, DRWTIM3 }
-		};
-	int channel = (int) HWIF(drive)->channel;
-	int slave = (drives != drive);  /* Is this really the best way to determine this?? */
-
-	cmdprintk("program_drive_count parameters = s(%d),a(%d),r(%d),p(%d)\n",
-		setup_count, active_count, recovery_count, drive->present);
+	static const u8 drwtim_regs[4] = {DRWTIM0, DRWTIM1, DRWTIM2, DRWTIM3};
+
+	cmdprintk("program_cycle_times parameters: total=%d, active=%d\n",
+		  cycle_time, active_time);
+
+	cycle_count	= quantize_timing( cycle_time, clock_time);
+	active_count	= quantize_timing(active_time, clock_time);
+	recovery_count	= cycle_count - active_count;
+
 	/*
-	 * Set up address setup count registers.
-	 * Primary interface has individual count/timing registers for
-	 * each drive.  Secondary interface has one common set of registers,
-	 * for address setup so we merge these timings, using the slowest
-	 * value.
+	 * In case we've got too long recovery phase, try to lengthen
+	 * the active phase
 	 */
-	if (channel) {
-		drive->drive_data = setup_count;
-		setup_count = max(drives[0].drive_data,
-					drives[1].drive_data);
-		cmdprintk("Secondary interface, setup_count = %d\n",
-					setup_count);
+	if (recovery_count > 16) {
+		active_count += recovery_count - 16;
+		recovery_count = 16;
 	}
+	if (active_count > 16)		/* shouldn't actually happen... */
+	 	active_count = 16;
+
+	cmdprintk("Final counts: total=%d, active=%d, recovery=%d\n",
+		  cycle_count, active_count, recovery_count);
 
 	/*
 	 * Convert values to internal chipset representation
 	 */
-	setup_count = (setup_count > 5) ? 0xc0 : (int) setup_counts[setup_count];
-	active_count &= 0xf; /* Remember, max value is 16 */
-	recovery_count = (int) recovery_counts[recovery_count];
+	recovery_count = recovery_values[recovery_count];
+ 	active_count  &= 0x0f;
 
-	cmdprintk("Final values = %d,%d,%d\n",
-		setup_count, active_count, recovery_count);
-
-	/*
-	 * Now that everything is ready, program the new timings
-	 */
-	local_irq_save(flags);
-	/*
-	 * Program the address_setup clocks into ARTTIM reg,
-	 * and then the active/recovery counts into the DRWTIM reg
-	 */
-	(void) pci_read_config_byte(dev, arttim_regs[channel][slave], &temp_b);
-	(void) pci_write_config_byte(dev, arttim_regs[channel][slave],
-		((u8) setup_count) | (temp_b & 0x3f));
-	(void) pci_write_config_byte(dev, drwtim_regs[channel][slave],
-		(u8) ((active_count << 4) | recovery_count));
-	cmdprintk ("Write %x to %x\n",
-		((u8) setup_count) | (temp_b & 0x3f),
-		arttim_regs[channel][slave]);
-	cmdprintk ("Write %x to %x\n",
-		(u8) ((active_count << 4) | recovery_count),
-		drwtim_regs[channel][slave]);
-	local_irq_restore(flags);
+	/* Program the active/recovery counts into the DRWTIM register */
+	drwtim = (active_count << 4) | recovery_count;
+	(void) pci_write_config_byte(dev, drwtim_regs[drive->dn], drwtim);
+	cmdprintk("Write 0x%02x to reg 0x%x\n", drwtim, drwtim_regs[drive->dn]);
 }
 
 /*
- * This routine selects drive's best PIO mode, calculates setup/active/recovery
- * counts, and then writes them into the chipset registers.
+ * This routine selects drive's best PIO mode and writes into the chipset
+ * registers setup/active/recovery timings.
  */
 static u8 cmd64x_tune_pio (ide_drive_t *drive, u8 mode_wanted)
 {
-	int setup_time, active_time, cycle_time;
-	u8  cycle_count, setup_count, active_count, recovery_count;
-	u8  pio_mode;
-	int clock_time = 1000 / system_bus_clock();
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= hwif->pci_dev;
 	ide_pio_data_t pio;
-
+	u8 pio_mode, setup_count, arttim = 0;
+	static const u8 setup_values[] = {0x40, 0x40, 0x40, 0x80, 0, 0xc0};
+	static const u8 arttim_regs[4] = {ARTTIM0, ARTTIM1, ARTTIM23, ARTTIM23};
 	pio_mode = ide_get_best_pio_mode(drive, mode_wanted, 5, &pio);
-	cycle_time = pio.cycle_time;
 
-	setup_time  = ide_pio_timings[pio_mode].setup_time;
-	active_time = ide_pio_timings[pio_mode].active_time;
+	cmdprintk("%s: PIO mode wanted %d, selected %d (%d ns)%s\n",
+		  drive->name, mode_wanted, pio_mode, pio.cycle_time,
+		  pio.overridden ? " (overriding vendor mode)" : "");
 
-	setup_count  = quantize_timing( setup_time, clock_time);
-	cycle_count  = quantize_timing( cycle_time, clock_time);
-	active_count = quantize_timing(active_time, clock_time);
+	program_cycle_times(drive, pio.cycle_time,
+			    ide_pio_timings[pio_mode].active_time);
 
-	recovery_count = cycle_count - active_count;
-	/* program_drive_counts() takes care of zero recovery cycles */
-	if (recovery_count > 16) {
-		active_count += recovery_count - 16;
-		recovery_count = 16;
+	setup_count = quantize_timing(ide_pio_timings[pio_mode].setup_time,
+				      1000 / system_bus_clock());
+
+	/*
+	 * The primary channel has individual address setup timing registers
+	 * for each drive and the hardware selects the slowest timing itself.
+	 * The secondary channel has one common register and we have to select
+	 * the slowest address setup timing ourselves.
+	 */
+	if (hwif->channel) {
+		ide_drive_t *drives = hwif->drives;
+
+		drive->drive_data = setup_count;
+		setup_count = max(drives[0].drive_data, drives[1].drive_data);
 	}
-	if (active_count > 16)
-		active_count = 16; /* maximum allowed by cmd64x */
 
-	program_drive_counts (drive, setup_count, active_count, recovery_count);
+	if (setup_count > 5)		/* shouldn't actually happen... */
+		setup_count = 5;
+	cmdprintk("Final address setup count: %d\n", setup_count);
 
-	cmdprintk("%s: PIO mode wanted %d, selected %d (%dns)%s, "
-		"clocks=%d/%d/%d\n",
-		drive->name, mode_wanted, pio_mode, cycle_time,
-		pio.overridden ? " (overriding vendor mode)" : "",
-		setup_count, active_count, recovery_count);
+	/*
+	 * Program the address setup clocks into the ARTTIM registers.
+	 * Avoid clearing the secondary channel's interrupt bit.
+	 */
+	(void) pci_read_config_byte (dev, arttim_regs[drive->dn], &arttim);
+	if (hwif->channel)
+		arttim &= ~ARTTIM23_INTR_CH1;
+	arttim &= ~0xc0;
+	arttim |= setup_values[setup_count];
+	(void) pci_write_config_byte(dev, arttim_regs[drive->dn], arttim);
+	cmdprintk("Write 0x%02x to reg 0x%x\n", arttim, arttim_regs[drive->dn]);
 
 	return pio_mode;
 }
@@ -376,61 +341,64 @@ static u8 cmd64x_ratemask (ide_drive_t *drive)
 	return mode;
 }
 
-static int cmd64x_tune_chipset (ide_drive_t *drive, u8 xferspeed)
+static int cmd64x_tune_chipset (ide_drive_t *drive, u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
+	u8 unit			= drive->dn & 0x01;
+	u8 regU = 0, pciU	= hwif->channel ? UDIDETCR1 : UDIDETCR0;
 
-	u8 unit			= (drive->select.b.unit & 0x01);
-	u8 regU = 0, pciU	= (hwif->channel) ? UDIDETCR1 : UDIDETCR0;
-	u8 regD = 0, pciD	= (hwif->channel) ? BMIDESR1 : BMIDESR0;
-
-	u8 speed	= ide_rate_filter(cmd64x_ratemask(drive), xferspeed);
+	speed = ide_rate_filter(cmd64x_ratemask(drive), speed);
 
 	if (speed >= XFER_SW_DMA_0) {
-		(void) pci_read_config_byte(dev, pciD, &regD);
 		(void) pci_read_config_byte(dev, pciU, &regU);
-		regD &= ~(unit ? 0x40 : 0x20);
 		regU &= ~(unit ? 0xCA : 0x35);
-		(void) pci_write_config_byte(dev, pciD, regD);
-		(void) pci_write_config_byte(dev, pciU, regU);
-		(void) pci_read_config_byte(dev, pciD, &regD);
-		(void) pci_read_config_byte(dev, pciU, &regU);
 	}
 
 	switch(speed) {
-		case XFER_UDMA_5:	regU |= (unit ? 0x0A : 0x05); break;
-		case XFER_UDMA_4:	regU |= (unit ? 0x4A : 0x15); break;
-		case XFER_UDMA_3:	regU |= (unit ? 0x8A : 0x25); break;
-		case XFER_UDMA_2:	regU |= (unit ? 0x42 : 0x11); break;
-		case XFER_UDMA_1:	regU |= (unit ? 0x82 : 0x21); break;
-		case XFER_UDMA_0:	regU |= (unit ? 0xC2 : 0x31); break;
-		case XFER_MW_DMA_2:	regD |= (unit ? 0x40 : 0x10); break;
-		case XFER_MW_DMA_1:	regD |= (unit ? 0x80 : 0x20); break;
-		case XFER_MW_DMA_0:	regD |= (unit ? 0xC0 : 0x30); break;
-		case XFER_SW_DMA_2:	regD |= (unit ? 0x40 : 0x10); break;
-		case XFER_SW_DMA_1:	regD |= (unit ? 0x80 : 0x20); break;
-		case XFER_SW_DMA_0:	regD |= (unit ? 0xC0 : 0x30); break;
-		case XFER_PIO_5:
-		case XFER_PIO_4:
-		case XFER_PIO_3:
-		case XFER_PIO_2:
-		case XFER_PIO_1:
-		case XFER_PIO_0:
-			(void) cmd64x_tune_pio(drive, speed - XFER_PIO_0);
-			break;
-
-		default:
-			return 1;
+	case XFER_UDMA_5:
+		regU |= unit ? 0x0A : 0x05;
+		break;
+	case XFER_UDMA_4:
+		regU |= unit ? 0x4A : 0x15;
+		break;
+	case XFER_UDMA_3:
+		regU |= unit ? 0x8A : 0x25;
+		break;
+	case XFER_UDMA_2:
+		regU |= unit ? 0x42 : 0x11;
+		break;
+	case XFER_UDMA_1:
+		regU |= unit ? 0x82 : 0x21;
+		break;
+	case XFER_UDMA_0:
+		regU |= unit ? 0xC2 : 0x31;
+		break;
+	case XFER_MW_DMA_2:
+		program_cycle_times(drive, 120, 70);
+		break;
+	case XFER_MW_DMA_1:
+		program_cycle_times(drive, 150, 80);
+		break;
+	case XFER_MW_DMA_0:
+		program_cycle_times(drive, 480, 215);
+		break;
+	case XFER_PIO_5:
+	case XFER_PIO_4:
+	case XFER_PIO_3:
+	case XFER_PIO_2:
+	case XFER_PIO_1:
+	case XFER_PIO_0:
+		(void) cmd64x_tune_pio(drive, speed - XFER_PIO_0);
+		break;
+	default:
+		return 1;
 	}
 
-	if (speed >= XFER_SW_DMA_0) {
+	if (speed >= XFER_SW_DMA_0)
 		(void) pci_write_config_byte(dev, pciU, regU);
-		regD |= (unit ? 0x40 : 0x20);
-		(void) pci_write_config_byte(dev, pciD, regD);
-	}
 
-	return (ide_config_drive_speed(drive, speed));
+	return ide_config_drive_speed(drive, speed);
 }
 
 static int config_chipset_for_dma (ide_drive_t *drive)
@@ -457,67 +425,80 @@ static int cmd64x_config_drive_for_dma (ide_drive_t *drive)
 	return -1;
 }
 
-static int cmd64x_alt_dma_status (struct pci_dev *dev)
+static int cmd648_ide_dma_end (ide_drive_t *drive)
 {
-	switch(dev->device) {
-		case PCI_DEVICE_ID_CMD_648:
-		case PCI_DEVICE_ID_CMD_649:
-			return 1;
-		default:
-			break;
-	}
-	return 0;
+	ide_hwif_t *hwif	= HWIF(drive);
+	int err			= __ide_dma_end(drive);
+	u8  irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
+						  MRDMODE_INTR_CH0;
+	u8  mrdmode		= inb(hwif->dma_master + 0x01);
+
+	/* clear the interrupt bit */
+	outb(mrdmode | irq_mask, hwif->dma_master + 0x01);
+
+	return err;
 }
 
 static int cmd64x_ide_dma_end (ide_drive_t *drive)
 {
-	u8 dma_stat = 0, dma_cmd = 0;
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
+	int irq_reg		= hwif->channel ? ARTTIM23 : CFR;
+	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
+						  CFR_INTR_CH0;
+	u8  irq_stat		= 0;
+	int err			= __ide_dma_end(drive);
 
-	drive->waiting_for_dma = 0;
-	/* read DMA command state */
-	dma_cmd = inb(hwif->dma_command);
-	/* stop DMA */
-	outb(dma_cmd & ~1, hwif->dma_command);
-	/* get DMA status */
-	dma_stat = inb(hwif->dma_status);
-	/* clear the INTR & ERROR bits */
-	outb(dma_stat | 6, hwif->dma_status);
-	if (cmd64x_alt_dma_status(dev)) {
-		u8 dma_intr	= 0;
-		u8 dma_mask	= (hwif->channel) ? ARTTIM23_INTR_CH1 :
-						    CFR_INTR_CH0;
-		u8 dma_reg	= (hwif->channel) ? ARTTIM2 : CFR;
-		(void) pci_read_config_byte(dev, dma_reg, &dma_intr);
-		/* clear the INTR bit */
-		(void) pci_write_config_byte(dev, dma_reg, dma_intr|dma_mask);
-	}
-	/* purge DMA mappings */
-	ide_destroy_dmatable(drive);
-	/* verify good DMA status */
-	return (dma_stat & 7) != 4;
+	(void) pci_read_config_byte(dev, irq_reg, &irq_stat);
+	/* clear the interrupt bit */
+	(void) pci_write_config_byte(dev, irq_reg, irq_stat | irq_mask);
+
+	return err;
+}
+
+static int cmd648_ide_dma_test_irq (ide_drive_t *drive)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+	u8 irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
+						  MRDMODE_INTR_CH0;
+	u8 dma_stat		= inb(hwif->dma_status);
+	u8 mrdmode		= inb(hwif->dma_master + 0x01);
+
+#ifdef DEBUG
+	printk("%s: dma_stat: 0x%02x mrdmode: 0x%02x irq_mask: 0x%02x\n",
+	       drive->name, dma_stat, mrdmode, irq_mask);
+#endif
+	if (!(mrdmode & irq_mask))
+		return 0;
+
+	/* return 1 if INTR asserted */
+	if (dma_stat & 4)
+		return 1;
+
+	return 0;
 }
 
 static int cmd64x_ide_dma_test_irq (ide_drive_t *drive)
 {
-	ide_hwif_t *hwif		= HWIF(drive);
-	struct pci_dev *dev		= hwif->pci_dev;
-        u8 dma_alt_stat = 0, mask	= (hwif->channel) ? MRDMODE_INTR_CH1 :
-							    MRDMODE_INTR_CH0;
-	u8 dma_stat = inb(hwif->dma_status);
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= hwif->pci_dev;
+	int irq_reg		= hwif->channel ? ARTTIM23 : CFR;
+	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
+						  CFR_INTR_CH0;
+	u8  dma_stat		= inb(hwif->dma_status);
+	u8  irq_stat		= 0;
+
+	(void) pci_read_config_byte(dev, irq_reg, &irq_stat);
 
-	(void) pci_read_config_byte(dev, MRDMODE, &dma_alt_stat);
 #ifdef DEBUG
-	printk("%s: dma_stat: 0x%02x dma_alt_stat: "
-		"0x%02x mask: 0x%02x\n", drive->name,
-		dma_stat, dma_alt_stat, mask);
+	printk("%s: dma_stat: 0x%02x irq_stat: 0x%02x irq_mask: 0x%02x\n",
+	       drive->name, dma_stat, irq_stat, irq_mask);
 #endif
-	if (!(dma_alt_stat & mask))
+	if (!(irq_stat & irq_mask))
 		return 0;
 
 	/* return 1 if INTR asserted */
-	if ((dma_stat & 4) == 4)
+	if (dma_stat & 4)
 		return 1;
 
 	return 0;
@@ -665,7 +646,6 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 
 	hwif->ultra_mask = 0x3f;
 	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
 
 	if (dev->device == PCI_DEVICE_ID_CMD_643)
 		hwif->ultra_mask = 0x80;
@@ -678,17 +658,25 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 	if (!(hwif->udma_four))
 		hwif->udma_four = ata66_cmd64x(hwif);
 
-	if (dev->device == PCI_DEVICE_ID_CMD_646) {
+	switch(dev->device) {
+	case PCI_DEVICE_ID_CMD_648:
+	case PCI_DEVICE_ID_CMD_649:
+	alt_irq_bits:
+		hwif->ide_dma_end	= &cmd648_ide_dma_end;
+		hwif->ide_dma_test_irq	= &cmd648_ide_dma_test_irq;
+		break;
+	case PCI_DEVICE_ID_CMD_646:
 		hwif->chipset = ide_cmd646;
 		if (class_rev == 0x01) {
 			hwif->ide_dma_end = &cmd646_1_ide_dma_end;
-		} else {
-			hwif->ide_dma_end = &cmd64x_ide_dma_end;
-			hwif->ide_dma_test_irq = &cmd64x_ide_dma_test_irq;
-		}
-	} else {
-		hwif->ide_dma_end = &cmd64x_ide_dma_end;
-		hwif->ide_dma_test_irq = &cmd64x_ide_dma_test_irq;
+			break;
+		} else if (class_rev >= 0x03)
+			goto alt_irq_bits;
+		/* fall thru */
+	default:
+		hwif->ide_dma_end	= &cmd64x_ide_dma_end;
+		hwif->ide_dma_test_irq	= &cmd64x_ide_dma_test_irq;
+		break;
 	}
 
 
@@ -698,42 +686,75 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 	hwif->drives[1].autodma = hwif->autodma;
 }
 
+static int __devinit init_setup_cmd64x(struct pci_dev *dev, ide_pci_device_t *d)
+{
+	return ide_setup_pci_device(dev, d);
+}
+
+static int __devinit init_setup_cmd646(struct pci_dev *dev, ide_pci_device_t *d)
+{
+	u8 rev = 0;
+
+	/*
+	 * The original PCI0646 didn't have the primary channel enable bit,
+	 * it appeared starting with PCI0646U (i.e. revision ID 3).
+	 */
+	pci_read_config_byte(dev, PCI_REVISION_ID, &rev);
+	if (rev < 3)
+		d->enablebits[0].reg = 0;
+
+	return ide_setup_pci_device(dev, d);
+}
+
 static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "CMD643",
+		.init_setup	= init_setup_cmd64x,
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.channels	= 2,
 		.autodma	= AUTODMA,
+		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
 	},{	/* 1 */
 		.name		= "CMD646",
+		.init_setup	= init_setup_cmd646,
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.channels	= 2,
 		.autodma	= AUTODMA,
-		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x80,0x80}},
+		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
 	},{	/* 2 */
 		.name		= "CMD648",
+		.init_setup	= init_setup_cmd64x,
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.channels	= 2,
 		.autodma	= AUTODMA,
+		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
 	},{	/* 3 */
 		.name		= "CMD649",
+		.init_setup	= init_setup_cmd64x,
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.channels	= 2,
 		.autodma	= AUTODMA,
+		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
 	}
 };
 
+/*
+ * We may have to modify enablebits for PCI0646, so we'd better pass
+ * a local copy of the ide_pci_device_t structure down the call chain...
+ */
 static int __devinit cmd64x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &cmd64x_chipsets[id->driver_data]);
+	ide_pci_device_t d = cmd64x_chipsets[id->driver_data];
+
+	return d.init_setup(dev, &d);
 }
 
 static struct pci_device_id cmd64x_pci_tbl[] = {
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index ab6fa27..cf9d344 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.02	Apr 18, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.03	May 4, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -1527,7 +1527,12 @@ static int __devinit init_setup_hpt366(struct pci_dev *dev, ide_pci_device_t *d)
 	if (rev > 2)
 		goto init_single;
 
+	/*
+	 * HPT36x chips are single channel and
+	 * do not seem to have the channel enable bit...
+	 */
 	d->channels = 1;
+	d->enablebits[0].reg = 0;
 
 	if ((dev2 = pci_get_slot(dev->bus, dev->devfn + 1)) != NULL) {
 	  	u8  pin1 = 0, pin2 = 0;
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index a132767..4e12548 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -1,8 +1,9 @@
 
 /*
- * linux/drivers/ide/pci/it821x.c		Version 0.09	December 2004
+ * linux/drivers/ide/pci/it821x.c		Version 0.10	Mar 10 2007
  *
  * Copyright (C) 2004		Red Hat <alan@redhat.com>
+ * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
  *  Based in part on the ITE vendor provided SCSI driver.
@@ -104,6 +105,7 @@ static int it8212_noraid;
 /**
  *	it821x_program	-	program the PIO/MWDMA registers
  *	@drive: drive to tune
+ *	@timing: timing info
  *
  *	Program the PIO/MWDMA timing for this channel according to the
  *	current clock.
@@ -127,6 +129,7 @@ static void it821x_program(ide_drive_t *drive, u16 timing)
 /**
  *	it821x_program_udma	-	program the UDMA registers
  *	@drive: drive to tune
+ *	@timing: timing info
  *
  *	Program the UDMA timing for this drive according to the
  *	current clock.
@@ -153,10 +156,9 @@ static void it821x_program_udma(ide_drive_t *drive, u16 timing)
 	}
 }
 
-
 /**
  *	it821x_clock_strategy
- *	@hwif: hardware interface
+ *	@drive: drive to set up
  *
  *	Select between the 50 and 66Mhz base clocks to get the best
  *	results for this interface.
@@ -182,8 +184,11 @@ static void it821x_clock_strategy(ide_drive_t *drive)
 		altclock = itdev->want[0][1];
 	}
 
-	/* Master doesn't care does the slave ? */
-	if(clock == ATA_ANY)
+	/*
+	 * if both clocks can be used for the mode with the higher priority
+	 * use the clock needed by the mode with the lower priority
+	 */
+	if (clock == ATA_ANY)
 		clock = altclock;
 
 	/* Nobody cares - keep the same clock */
@@ -240,37 +245,56 @@ static u8 it821x_ratemask (ide_drive_t *drive)
 }
 
 /**
- *	it821x_tuneproc	-	tune a drive
+ *	it821x_tunepio	-	tune a drive
  *	@drive: drive to tune
- *	@mode_wanted: the target operating mode
- *
- *	Load the timing settings for this device mode into the
- *	controller. By the time we are called the mode has been
- *	modified as neccessary to handle the absence of seperate
- *	master/slave timers for MWDMA/PIO.
+ *	@pio: the desired PIO mode
  *
- *	This code is only used in pass through mode.
+ *	Try to tune the drive/host to the desired PIO mode taking into
+ *	the consideration the maximum PIO mode supported by the other
+ *	device on the cable.
  */
 
-static void it821x_tuneproc (ide_drive_t *drive, byte mode_wanted)
+static int it821x_tunepio(ide_drive_t *drive, u8 set_pio)
 {
 	ide_hwif_t *hwif	= drive->hwif;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
 	int unit = drive->select.b.unit;
+	ide_drive_t *pair = &hwif->drives[1 - unit];
 
 	/* Spec says 89 ref driver uses 88 */
 	static u16 pio[]	= { 0xAA88, 0xA382, 0xA181, 0x3332, 0x3121 };
 	static u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
 
-	if(itdev->smart)
-		return;
+	/*
+	 * Compute the best PIO mode we can for a given device. We must
+	 * pick a speed that does not cause problems with the other device
+	 * on the cable.
+	 */
+	if (pair) {
+		u8 pair_pio = ide_get_best_pio_mode(pair, 255, 4, NULL);
+		/* trim PIO to the slowest of the master/slave */
+		if (pair_pio < set_pio)
+			set_pio = pair_pio;
+	}
+
+	if (itdev->smart)
+		goto set_drive_speed;
 
 	/* We prefer 66Mhz clock for PIO 0-3, don't care for PIO4 */
-	itdev->want[unit][1] = pio_want[mode_wanted];
+	itdev->want[unit][1] = pio_want[set_pio];
 	itdev->want[unit][0] = 1;	/* PIO is lowest priority */
-	itdev->pio[unit] = pio[mode_wanted];
+	itdev->pio[unit] = pio[set_pio];
 	it821x_clock_strategy(drive);
 	it821x_program(drive, itdev->pio[unit]);
+
+set_drive_speed:
+	return ide_config_drive_speed(drive, XFER_PIO_0 + set_pio);
+}
+
+static void it821x_tuneproc(ide_drive_t *drive, u8 pio)
+{
+	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
+	(void)it821x_tunepio(drive, pio);
 }
 
 /**
@@ -354,40 +378,6 @@ static void it821x_tune_udma (ide_drive_t *drive, byte mode_wanted)
 }
 
 /**
- *	config_it821x_chipset_for_pio	-	set drive timings
- *	@drive: drive to tune
- *	@speed we want
- *
- *	Compute the best pio mode we can for a given device. We must
- *	pick a speed that does not cause problems with the other device
- *	on the cable.
- */
-
-static void config_it821x_chipset_for_pio (ide_drive_t *drive, byte set_speed)
-{
-	u8 unit = drive->select.b.unit;
-	ide_hwif_t *hwif = drive->hwif;
-	ide_drive_t *pair = &hwif->drives[1-unit];
-	u8 speed = 0, set_pio	= ide_get_best_pio_mode(drive, 255, 5, NULL);
-	u8 pair_pio;
-
-	/* We have to deal with this mess in pairs */
-	if(pair != NULL) {
-		pair_pio = ide_get_best_pio_mode(pair, 255, 5, NULL);
-		/* Trim PIO to the slowest of the master/slave */
-		if(pair_pio < set_pio)
-			set_pio = pair_pio;
-	}
-	it821x_tuneproc(drive, set_pio);
-	speed = XFER_PIO_0 + set_pio;
-	/* XXX - We trim to the lowest of the pair so the other drive
-	   will always be fine at this point until we do hotplug passthru */
-
-	if (set_speed)
-		(void) ide_config_drive_speed(drive, speed);
-}
-
-/**
  *	it821x_dma_read	-	DMA hook
  *	@drive: drive for DMA
  *
@@ -450,15 +440,17 @@ static int it821x_tune_chipset (ide_drive_t *drive, byte xferspeed)
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
 	u8 speed		= ide_rate_filter(it821x_ratemask(drive), xferspeed);
 
-	if(!itdev->smart) {
-		switch(speed) {
-			case XFER_PIO_4:
-			case XFER_PIO_3:
-			case XFER_PIO_2:
-			case XFER_PIO_1:
-			case XFER_PIO_0:
-				it821x_tuneproc(drive, (speed - XFER_PIO_0));
-				break;
+	switch (speed) {
+	case XFER_PIO_4:
+	case XFER_PIO_3:
+	case XFER_PIO_2:
+	case XFER_PIO_1:
+	case XFER_PIO_0:
+		return it821x_tunepio(drive, speed - XFER_PIO_0);
+	}
+
+	if (itdev->smart == 0) {
+		switch (speed) {
 			/* MWDMA tuning is really hard because our MWDMA and PIO
 			   timings are kept in the same place. We can switch in the
 			   host dma on/off callbacks */
@@ -498,14 +490,12 @@ static int config_chipset_for_dma (ide_drive_t *drive)
 {
 	u8 speed	= ide_dma_speed(drive, it821x_ratemask(drive));
 
-	if (speed) {
-		config_it821x_chipset_for_pio(drive, 0);
-		it821x_tune_chipset(drive, speed);
+	if (speed == 0)
+		return 0;
 
-		return ide_dma_enable(drive);
-	}
+	it821x_tune_chipset(drive, speed);
 
-	return 0;
+	return ide_dma_enable(drive);
 }
 
 /**
@@ -523,7 +513,7 @@ static int it821x_config_drive_for_dma (ide_drive_t *drive)
 	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
 		return 0;
 
-	config_it821x_chipset_for_pio(drive, 1);
+	it821x_tuneproc(drive, 255);
 
 	return -1;
 }
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index ace9892..2da5cbb 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -255,9 +255,6 @@ static int config_chipset_for_dma(ide_drive_t *drive)
 		printk(KERN_WARNING "%s reduced to Ultra33 mode.\n", drive->name);
 	}
 
-	if (drive->media != ide_disk && drive->media != ide_cdrom)
-		return 0;
-
 	if (id->capability & 4) {
 		/*
 		 * Set IORDY_EN & PREFETCH_EN (this seems to have
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 71eccdf..c0188de 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/siimage.c		Version 1.11	Jan 27, 2007
+ * linux/drivers/ide/pci/siimage.c		Version 1.12	Mar 10 2007
  *
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2003		Red Hat <alan@redhat.com>
@@ -287,11 +287,6 @@ static void config_siimage_chipset_for_pio (ide_drive_t *drive, byte set_speed)
 		(void) ide_config_drive_speed(drive, speed);
 }
 
-static void config_chipset_for_pio (ide_drive_t *drive, byte set_speed)
-{
-	config_siimage_chipset_for_pio(drive, set_speed);
-}
-
 /**
  *	siimage_tune_chipset	-	set controller timings
  *	@drive: Drive to set up
@@ -396,8 +391,6 @@ static int config_chipset_for_dma (ide_drive_t *drive)
 {
 	u8 speed	= ide_dma_speed(drive, siimage_ratemask(drive));
 
-	config_chipset_for_pio(drive, !speed);
-
 	if (!speed)
 		return 0;
 
@@ -423,7 +416,7 @@ static int siimage_config_drive_for_dma (ide_drive_t *drive)
 		return 0;
 
 	if (ide_use_fast_pio(drive))
-		config_chipset_for_pio(drive, 1);
+		config_siimage_chipset_for_pio(drive, 1);
 
 	return -1;
 }
@@ -1015,7 +1008,6 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 
 	hwif->ultra_mask = 0x7f;
 	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
 
 	if (!is_sata(hwif))
 		hwif->atapi_dma = 1;
diff --git a/drivers/ide/pci/sl82c105.c b/drivers/ide/pci/sl82c105.c
index 3a8a76f..fe3b4b9 100644
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -11,6 +11,8 @@
  * Merge in Russell's HW workarounds, fix various problems
  * with the timing registers setup.
  *  -- Benjamin Herrenschmidt (01/11/03) benh@kernel.crashing.org
+ *
+ * Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
  */
 
 #include <linux/types.h>
@@ -47,25 +49,19 @@
 #define CTRL_P0EN       (1 << 0)
 
 /*
- * Convert a PIO mode and cycle time to the required on/off
- * times for the interface.  This has protection against run-away
- * timings.
+ * Convert a PIO mode and cycle time to the required on/off times
+ * for the interface.  This has protection against runaway timings.
  */
-static unsigned int get_timing_sl82c105(ide_pio_data_t *p)
+static unsigned int get_pio_timings(ide_pio_data_t *p)
 {
-	unsigned int cmd_on;
-	unsigned int cmd_off;
+	unsigned int cmd_on, cmd_off;
 
-	cmd_on = (ide_pio_timings[p->pio_mode].active_time + 29) / 30;
+	cmd_on  = (ide_pio_timings[p->pio_mode].active_time + 29) / 30;
 	cmd_off = (p->cycle_time - 30 * cmd_on + 29) / 30;
 
-	if (cmd_on > 32)
-		cmd_on = 32;
 	if (cmd_on == 0)
 		cmd_on = 1;
 
-	if (cmd_off > 32)
-		cmd_off = 32;
 	if (cmd_off == 0)
 		cmd_off = 1;
 
@@ -73,100 +69,59 @@ static unsigned int get_timing_sl82c105(ide_pio_data_t *p)
 }
 
 /*
- * Configure the drive and chipset for PIO
+ * Configure the chipset for PIO mode.
  */
-static void config_for_pio(ide_drive_t *drive, int pio, int report, int chipset_only)
+static u8 sl82c105_tune_pio(ide_drive_t *drive, u8 pio)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *dev	= HWIF(drive)->pci_dev;
+	int reg			= 0x44 + drive->dn * 4;
 	ide_pio_data_t p;
-	u16 drv_ctrl = 0x909;
-	unsigned int xfer_mode, reg;
+	u16 drv_ctrl;
 
-	DBG(("config_for_pio(drive:%s, pio:%d, report:%d, chipset_only:%d)\n",
-		drive->name, pio, report, chipset_only));
-		
-	reg = (hwif->channel ? 0x4c : 0x44) + (drive->select.b.unit ? 4 : 0);
+	DBG(("sl82c105_tune_pio(drive:%s, pio:%u)\n", drive->name, pio));
 
 	pio = ide_get_best_pio_mode(drive, pio, 5, &p);
 
-	xfer_mode = XFER_PIO_0 + pio;
-
-	if (chipset_only || ide_config_drive_speed(drive, xfer_mode) == 0) {
-		drv_ctrl = get_timing_sl82c105(&p);
-		drive->pio_speed = xfer_mode;
-	} else
-		drive->pio_speed = XFER_PIO_0;
+	drive->drive_data = drv_ctrl = get_pio_timings(&p);
 
-	if (drive->using_dma == 0) {
+	if (!drive->using_dma) {
 		/*
 		 * If we are actually using MW DMA, then we can not
 		 * reprogram the interface drive control register.
 		 */
-		pci_write_config_word(dev, reg, drv_ctrl);
-		pci_read_config_word(dev, reg, &drv_ctrl);
-
-		if (report) {
-			printk("%s: selected %s (%dns) (%04X)\n", drive->name,
-			       ide_xfer_verbose(xfer_mode), p.cycle_time, drv_ctrl);
-		}
+		pci_write_config_word(dev, reg,  drv_ctrl);
+		pci_read_config_word (dev, reg, &drv_ctrl);
 	}
+
+	printk(KERN_DEBUG "%s: selected %s (%dns) (%04X)\n", drive->name,
+	       ide_xfer_verbose(pio + XFER_PIO_0), p.cycle_time, drv_ctrl);
+
+	return pio;
 }
 
 /*
- * Configure the drive and the chipset for DMA
+ * Configure the drive for DMA.
+ * We'll program the chipset only when DMA is actually turned on.
  */
-static int config_for_dma (ide_drive_t *drive)
+static int config_for_dma(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	struct pci_dev *dev = hwif->pci_dev;
-	unsigned int reg;
-
 	DBG(("config_for_dma(drive:%s)\n", drive->name));
 
-	reg = (hwif->channel ? 0x4c : 0x44) + (drive->select.b.unit ? 4 : 0);
-
 	if (ide_config_drive_speed(drive, XFER_MW_DMA_2) != 0)
-		return 1;
+		return 0;
 
-	pci_write_config_word(dev, reg, 0x0240);
-
-	return 0;
+	return ide_dma_enable(drive);
 }
 
 /*
- * Check to see if the drive and
- * chipset is capable of DMA mode
+ * Check to see if the drive and chipset are capable of DMA mode.
  */
-
-static int sl82c105_check_drive (ide_drive_t *drive)
+static int sl82c105_ide_dma_check(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-
-	DBG(("sl82c105_check_drive(drive:%s)\n", drive->name));
-
-	do {
-		struct hd_driveid *id = drive->id;
-
-		if (!drive->autodma)
-			break;
-
-		if (!id || !(id->capability & 1))
-			break;
+	DBG(("sl82c105_ide_dma_check(drive:%s)\n", drive->name));
 
-		/* Consult the list of known "bad" drives */
-		if (__ide_dma_bad_drive(drive))
-			break;
-
-		if (id->field_valid & 2) {
-			if ((id->dma_mword & hwif->mwdma_mask) ||
-			    (id->dma_1word & hwif->swdma_mask))
-				return 0;
-		}
-
-		if (__ide_dma_good_drive(drive) && id->eide_dma_time < 150)
-			return 0;
-	} while (0);
+	if (ide_use_dma(drive) && config_for_dma(drive))
+		return 0;
 
 	return -1;
 }
@@ -195,14 +150,14 @@ static inline void sl82c105_reset_host(struct pci_dev *dev)
  * This function is called when the IDE timer expires, the drive
  * indicates that it is READY, and we were waiting for DMA to complete.
  */
-static int sl82c105_ide_dma_lost_irq(ide_drive_t *drive)
+static int sl82c105_ide_dma_lostirq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	struct pci_dev *dev = hwif->pci_dev;
-	u32 val, mask = hwif->channel ? CTRL_IDE_IRQB : CTRL_IDE_IRQA;
-	unsigned long dma_base = hwif->dma_base;
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= hwif->pci_dev;
+	u32 val, mask		= hwif->channel ? CTRL_IDE_IRQB : CTRL_IDE_IRQA;
+	u8 dma_cmd;
 
-	printk("sl82c105: lost IRQ: resetting host\n");
+	printk("sl82c105: lost IRQ, resetting host\n");
 
 	/*
 	 * Check the raw interrupt from the drive.
@@ -215,15 +170,15 @@ static int sl82c105_ide_dma_lost_irq(ide_drive_t *drive)
 	 * Was DMA enabled?  If so, disable it - we're resetting the
 	 * host.  The IDE layer will be handling the drive for us.
 	 */
-	val = inb(dma_base);
-	if (val & 1) {
-		outb(val & ~1, dma_base);
+	dma_cmd = inb(hwif->dma_command);
+	if (dma_cmd & 1) {
+		outb(dma_cmd & ~1, hwif->dma_command);
 		printk("sl82c105: DMA was enabled\n");
 	}
 
 	sl82c105_reset_host(dev);
 
-	/* ide_dmaproc would return 1, so we do as well */
+	/* __ide_dma_lostirq would return 1, so we do as well */
 	return 1;
 }
 
@@ -235,10 +190,10 @@ static int sl82c105_ide_dma_lost_irq(ide_drive_t *drive)
  * The generic IDE core will have disabled the BMEN bit before this
  * function is called.
  */
-static void sl82c105_ide_dma_start(ide_drive_t *drive)
+static void sl82c105_dma_start(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	struct pci_dev *dev = hwif->pci_dev;
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= hwif->pci_dev;
 
 	sl82c105_reset_host(dev);
 	ide_dma_start(drive);
@@ -246,8 +201,8 @@ static void sl82c105_ide_dma_start(ide_drive_t *drive)
 
 static int sl82c105_ide_dma_timeout(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	struct pci_dev *dev = hwif->pci_dev;
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= hwif->pci_dev;
 
 	DBG(("sl82c105_ide_dma_timeout(drive:%s)\n", drive->name));
 
@@ -255,26 +210,32 @@ static int sl82c105_ide_dma_timeout(ide_drive_t *drive)
 	return __ide_dma_timeout(drive);
 }
 
-static int sl82c105_ide_dma_on (ide_drive_t *drive)
+static int sl82c105_ide_dma_on(ide_drive_t *drive)
 {
+	struct pci_dev *dev	= HWIF(drive)->pci_dev;
+	int rc, reg 		= 0x44 + drive->dn * 4;
+
 	DBG(("sl82c105_ide_dma_on(drive:%s)\n", drive->name));
 
-	if (config_for_dma(drive))
-		return 1;
-	printk(KERN_INFO "%s: DMA enabled\n", drive->name);
-	return __ide_dma_on(drive);
+	rc = __ide_dma_on(drive);
+	if (rc == 0) {
+		pci_write_config_word(dev, reg, 0x0200);
+
+		printk(KERN_INFO "%s: DMA enabled\n", drive->name);
+	}
+	return rc;
 }
 
 static void sl82c105_dma_off_quietly(ide_drive_t *drive)
 {
-	u8 speed = XFER_PIO_0;
+	struct pci_dev *dev	= HWIF(drive)->pci_dev;
+	int reg 		= 0x44 + drive->dn * 4;
 
 	DBG(("sl82c105_dma_off_quietly(drive:%s)\n", drive->name));
 
+	pci_write_config_word(dev, reg, drive->drive_data);
+
 	ide_dma_off_quietly(drive);
-	if (drive->pio_speed)
-		speed = drive->pio_speed - XFER_PIO_0;
-	config_for_pio(drive, speed, 0, 1);
 }
 
 /*
@@ -286,8 +247,8 @@ static void sl82c105_dma_off_quietly(ide_drive_t *drive)
  */
 static void sl82c105_selectproc(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-	struct pci_dev *dev = hwif->pci_dev;
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= hwif->pci_dev;
 	u32 val, old, mask;
 
 	//DBG(("sl82c105_selectproc(drive:%s)\n", drive->name));
@@ -323,18 +284,12 @@ static void sl82c105_resetproc(ide_drive_t *drive)
  * We only deal with PIO mode here - DMA mode 'using_dma' is not
  * initialised at the point that this function is called.
  */
-static void tune_sl82c105(ide_drive_t *drive, u8 pio)
+static void sl82c105_tune_drive(ide_drive_t *drive, u8 pio)
 {
-	DBG(("tune_sl82c105(drive:%s)\n", drive->name));
-
-	config_for_pio(drive, pio, 1, 0);
+	DBG(("sl82c105_tune_drive(drive:%s, pio:%u)\n", drive->name, pio));
 
-	/*
-	 * We support 32-bit I/O on this interface, and it
-	 * doesn't have problems with interrupts.
-	 */
-	drive->io_32bit = 1;
-	drive->unmask = 1;
+	pio = sl82c105_tune_pio(drive, pio);
+	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
 /*
@@ -393,7 +348,7 @@ static unsigned int __devinit init_chipset_sl82c105(struct pci_dev *dev, const c
 }
 
 /*
- * Initialise the chip
+ * Initialise IDE channel
  */
 static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 {
@@ -401,24 +356,22 @@ static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 
 	DBG(("init_hwif_sl82c105(hwif: ide%d)\n", hwif->index));
 
-	hwif->tuneproc = tune_sl82c105;
-	hwif->selectproc = sl82c105_selectproc;
-	hwif->resetproc = sl82c105_resetproc;
+	hwif->tuneproc		= &sl82c105_tune_drive;
+	hwif->selectproc	= &sl82c105_selectproc;
+	hwif->resetproc 	= &sl82c105_resetproc;
+
+	/*
+	 * We support 32-bit I/O on this interface, and
+	 * it doesn't have problems with interrupts.
+	 */
+	hwif->drives[0].io_32bit = hwif->drives[1].io_32bit = 1;
+	hwif->drives[0].unmask   = hwif->drives[1].unmask   = 1;
 
 	/*
-	 * Default to PIO 0 for fallback unless tuned otherwise.
 	 * We always autotune PIO,  this is done before DMA is checked,
 	 * so there's no risk of accidentally disabling DMA
 	 */
-	hwif->drives[0].pio_speed = XFER_PIO_0;
-	hwif->drives[0].autotune = 1;
-	hwif->drives[1].pio_speed = XFER_PIO_0;
-	hwif->drives[1].autotune = 1;
-
-	hwif->atapi_dma = 0;
-	hwif->mwdma_mask = 0;
-	hwif->swdma_mask = 0;
-	hwif->autodma = 0;
+	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
 
 	if (!hwif->dma_base)
 		return;
@@ -429,27 +382,27 @@ static void __devinit init_hwif_sl82c105(ide_hwif_t *hwif)
 		 * Never ever EVER under any circumstances enable
 		 * DMA when the bridge is this old.
 		 */
-		printk("    %s: Winbond 553 bridge revision %d, BM-DMA disabled\n",
-		       hwif->name, rev);
-	} else {
-		hwif->atapi_dma = 1;
-		hwif->mwdma_mask = 0x04;
-
-		hwif->ide_dma_check = &sl82c105_check_drive;
-		hwif->ide_dma_on = &sl82c105_ide_dma_on;
-		hwif->dma_off_quietly = &sl82c105_dma_off_quietly;
-		hwif->ide_dma_lostirq = &sl82c105_ide_dma_lost_irq;
-		hwif->dma_start = &sl82c105_ide_dma_start;
-		hwif->ide_dma_timeout = &sl82c105_ide_dma_timeout;
-
-		if (!noautodma)
-			hwif->autodma = 1;
-		hwif->drives[0].autodma = hwif->autodma;
-		hwif->drives[1].autodma = hwif->autodma;
-
-		if (hwif->mate)
-			hwif->serialized = hwif->mate->serialized = 1;
+		printk("    %s: Winbond W83C553 bridge revision %d, "
+		       "BM-DMA disabled\n", hwif->name, rev);
+		return;
 	}
+
+	hwif->atapi_dma  = 1;
+	hwif->mwdma_mask = 0x04;
+
+	hwif->ide_dma_check		= &sl82c105_ide_dma_check;
+	hwif->ide_dma_on		= &sl82c105_ide_dma_on;
+	hwif->dma_off_quietly		= &sl82c105_dma_off_quietly;
+	hwif->ide_dma_lostirq		= &sl82c105_ide_dma_lostirq;
+	hwif->dma_start			= &sl82c105_dma_start;
+	hwif->ide_dma_timeout		= &sl82c105_ide_dma_timeout;
+
+	if (!noautodma)
+		hwif->autodma = 1;
+	hwif->drives[0].autodma = hwif->drives[1].autodma = hwif->autodma;
+
+	if (hwif->mate)
+		hwif->serialized = hwif->mate->serialized = 1;
 }
 
 static ide_pci_device_t sl82c105_chipset __devinitdata = {
diff --git a/include/linux/ide.h b/include/linux/ide.h
index d3bbc71..418dfb5 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -613,7 +613,6 @@ typedef struct ide_drive_s {
 
         u8	quirk_list;	/* considered quirky, set for a specific host */
         u8	init_speed;	/* transfer rate set at boot */
-        u8	pio_speed;      /* unused by core, used by some drivers for fallback from DMA */
         u8	current_speed;	/* current transfer rate set */
 	u8	desired_speed;	/* desired transfer rate set */
         u8	dn;		/* now wide spread use */

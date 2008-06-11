Return-Path: <linux-kernel-owner+w=401wt.eu-S1763436AbYFKQSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763436AbYFKQSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761240AbYFKQSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:18:34 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:41001 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbYFKQSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:18:31 -0400
Subject: Patch for ide controler from kernel 2.4.16  for kernel 2.4.35.3
From: christopher <christophertaeufert@web.de>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-9GZSg901qeGmGJNd4enH"
Date: Wed, 11 Jun 2008 18:18:28 +0200
Message-Id: <1213201108.8316.9.camel@fuckup-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-Provags-ID: V01U2FsdGVkX1/+KZP8uiMkO3RxJ0aMqmEiNdADGyTcJAUZ5jAV
	LihpgAreDnZARBsMZzkNYtImgDnenjr2hDZhSzfmEOfSF4rFkN
	20XaHF0LLicgNbWp192Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9GZSg901qeGmGJNd4enH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello

at first please excuse my bad english but i gave my best

I have a problem with apply a patch for the cdm64x.c ide controler
driver in the kernel 2.4.35.3

i hav made a patch for these driver from the original kernel 2.4.16
source and the kernel source i got for my claxan nas110.
I'm runnign an alternate foirmware called OpenMCT on my nas. With the
original firmware i can use an sata ide adapter but with the alternate
firmware the adapter would not work.  so i made these patch but wehen i
try to apply the patch only 4 of 20 hunks succeeded an the other 16
faild. with the 4 succeeded hunks  the adapter and also the sata hdd are
recognized by the kernel during boot  but i think when 16 hunks faild
something must be wrong.  so i would ask if some body can help my to
made the patch compatibel to the 2.4.35.3 kernel. my patch is attached
to this mail.

the nas has got a 133mhz Tishiba 3927CF mipsel cpu and a cmd649 ide
controler.

i hope somebody can help me.
when someone would answer to thes mail please send a copy of the mail to
my mail address  christophertaeufert@web.de  because i have not
subscribe to the linux kernel mailing list.


thanks for reading i hope to become answers.
christopher t=C3=A4ufert

--=-9GZSg901qeGmGJNd4enH
Content-Disposition: attachment; filename=015-cmd64x.h.patch
Content-Type: text/x-patch; name=015-cmd64x.h.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- linux-2.4.16/drivers/ide/cmd64x.c	2001-12-28 22:06:01.000000000 +0100
+++ linux/drivers/ide/cmd64x.c	2005-03-31 11:19:27.000000000 +0200
@@ -86,6 +86,7 @@
 #include <linux/proc_fs.h>
 
 static int cmd64x_get_info(char *, char **, off_t, int);
+static int cmd680_get_info(char *, char **, off_t, int);
 extern int (*cmd64x_display_info)(char *, char **, off_t, int); /* ide-proc.c */
 extern char *ide_media_verbose(ide_drive_t *);
 static struct pci_dev *bmide_dev;
@@ -180,24 +181,21 @@
 	return p-buffer;	/* => must be less than 4k! */
 }
 
-#if 0
-static char * cmd64x_chipset_data (char *buf, struct pci_dev *dev)
-{
-	char *p = buf;
-	p += sprintf(p, "thingy stuff\n");
-	return (char *)p;
-}
-static int __init cmd64x_get_info (char *buffer, char **addr, off_t offset, int count)
+static int cmd680_get_info (char *buffer, char **addr, off_t offset, int count)
 {
 	char *p = buffer;
-	p = cmd64x_chipset_data(buffer, bmide_dev);
-	return p-buffer;	/* hoping it is less than 4K... */
+	p += sprintf(p, "\n                                CMD680 Chipset.\n");
+	p += sprintf(p, "--------------- Primary Channel ---------------- Secondary Channel -------------\n");
+	p += sprintf(p, "--------------- drive0 --------- drive1 -------- drive0 ---------- drive1 ------\n");
+	p += sprintf(p, "PIO Mode:       %s                %s               %s                 %s\n",
+		"?", "?", "?", "?");
+	return p-buffer;	/* => must be less than 4k! */
 }
-#endif
 
 #endif	/* defined(DISPLAY_CMD64X_TIMINGS) && defined(CONFIG_PROC_FS) */
 
 byte cmd64x_proc = 0;
+byte cmd680_proc = 0;
 
 /*
  * Registers and masks for easy access by drive index:
@@ -345,10 +343,58 @@
 		setup_count, active_count, recovery_count);
 }
 
-static void config_chipset_for_pio (ide_drive_t *drive, byte set_speed)
+static byte cmd680_taskfile_timing (ide_hwif_t *hwif)
+{
+	struct pci_dev *dev	= hwif->pci_dev;
+	byte addr_mask		= (hwif->channel) ? 0xB2 : 0xA2;
+	unsigned short		timing;
+
+	pci_read_config_word(dev, addr_mask, &timing);
+
+	switch (timing) {
+		case 0x10c1:	return 4;
+		case 0x10c3:	return 3;
+		case 0x1281:	return 2;
+		case 0x2283:	return 1;
+		case 0x328a:
+		default:	return 0;
+	}
+}
+
+static void cmd680_tuneproc (ide_drive_t *drive, byte mode_wanted)
 {
-	byte speed= 0x00;
-	byte set_pio= ide_get_best_pio_mode(drive, 4, 5, NULL);
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= hwif->pci_dev;
+	byte			drive_pci;
+	unsigned short		speedt;
+
+	switch (drive->dn) {
+		case 0: drive_pci = 0xA4; break;
+		case 1: drive_pci = 0xA6; break;
+		case 2: drive_pci = 0xB4; break;
+		case 3: drive_pci = 0xB6; break;
+		default: return;
+        }
+
+	pci_read_config_word(dev, drive_pci, &speedt);
+
+	/* cheat for now and use the docs */
+//	switch(cmd680_taskfile_timing(hwif)) {
+	switch(mode_wanted) {
+		case 4:		speedt = 0x10c1; break;
+		case 3:		speedt = 0x10C3; break;
+		case 2:		speedt = 0x1104; break;
+		case 1:		speedt = 0x2283; break;
+		case 0:
+		default:	speedt = 0x328A; break;
+	}
+	pci_write_config_word(dev, drive_pci, speedt);
+}
+
+static void config_cmd64x_chipset_for_pio (ide_drive_t *drive, byte set_speed)
+{
+	byte speed	= 0x00;
+	byte set_pio	= ide_get_best_pio_mode(drive, 4, 5, NULL);
 
 	cmd64x_tuneproc(drive, set_pio);
 	speed = XFER_PIO_0 + set_pio;
@@ -356,6 +402,41 @@
 		(void) ide_config_drive_speed(drive, speed);
 }
 
+static void config_cmd680_chipset_for_pio (ide_drive_t *drive, byte set_speed)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= hwif->pci_dev;
+	u8 unit			= (drive->select.b.unit & 0x01);
+	u8 addr_mask		= (hwif->channel) ? 0x84 : 0x80;
+	u8 speed		= 0x00;
+	u8 mode_pci		= 0x00;
+	u8 channel_timings	= cmd680_taskfile_timing(hwif);
+	u8 set_pio		= ide_get_best_pio_mode(drive, 4, 5, NULL);
+
+	pci_read_config_byte(dev, addr_mask, &mode_pci);
+	mode_pci &= ~((unit) ? 0x30 : 0x03);
+
+	/* WARNING PIO timing mess is going to happen b/w devices, argh */
+	if ((channel_timings != set_pio) && (set_pio > channel_timings))
+		set_pio = channel_timings;
+
+	cmd680_tuneproc(drive, set_pio);
+	speed = XFER_PIO_0 + set_pio;
+	if (set_speed) {
+		(void) ide_config_drive_speed(drive, speed);
+		drive->current_speed = speed;
+	}
+}
+
+static void config_chipset_for_pio (ide_drive_t *drive, byte set_speed)
+{
+        if (HWIF(drive)->pci_dev->device == PCI_DEVICE_ID_CMD_680) {
+		config_cmd680_chipset_for_pio(drive, set_speed);
+	} else {
+		config_cmd64x_chipset_for_pio(drive, set_speed);
+	}
+}
+
 static int cmd64x_tune_chipset (ide_drive_t *drive, byte speed)
 {
 #ifdef CONFIG_BLK_DEV_IDEDMA
@@ -363,7 +444,7 @@
 	struct pci_dev *dev	= hwif->pci_dev;
 	int err			= 0;
 
-	byte unit		= (drive->select.b.unit & 0x01);
+	u8 unit			= (drive->select.b.unit & 0x01);
 	u8 pciU			= (hwif->channel) ? UDIDETCR1 : UDIDETCR0;
 	u8 pciD			= (hwif->channel) ? BMIDESR1 : BMIDESR0;
 	u8 regU			= 0;
@@ -424,8 +505,123 @@
 	return err;
 }
 
+static int cmd680_tune_chipset (ide_drive_t *drive, byte speed)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct pci_dev *dev	= hwif->pci_dev;
+	u8 addr_mask		= (hwif->channel) ? 0x84 : 0x80;
+	u8 unit			= (drive->select.b.unit & 0x01);
+	u8 dma_pci		= 0;
+	u8 udma_pci		= 0;
+	u8 mode_pci		= 0;
+	u8 scsc			= 0;
+	u16 ultra		= 0;
+	u16 multi		= 0;
+	int err			= 0;
+
+        pci_read_config_byte(dev, addr_mask, &mode_pci);
+	pci_read_config_byte(dev, 0x8A, &scsc);
+
+        switch (drive->dn) {
+		case 0: dma_pci = 0xA8; udma_pci = 0xAC; break;
+		case 1: dma_pci = 0xAA; udma_pci = 0xAE; break;
+		case 2: dma_pci = 0xB8; udma_pci = 0xBC; break;
+		case 3: dma_pci = 0xBA; udma_pci = 0xBE; break;
+		default: return 1;
+	}
+
+	pci_read_config_byte(dev, addr_mask, &mode_pci);
+	mode_pci &= ~((unit) ? 0x30 : 0x03);
+	pci_read_config_word(dev, dma_pci, &multi);
+	pci_read_config_word(dev, udma_pci, &ultra);
+
+	if ((speed == XFER_UDMA_6) && (scsc & 0x30) == 0x00) {
+		pci_write_config_byte(dev, 0x8A, scsc|0x01);
+		pci_read_config_byte(dev, 0x8A, &scsc);
+	}
+
+	switch(speed) {
 #ifdef CONFIG_BLK_DEV_IDEDMA
-static int config_chipset_for_dma (ide_drive_t *drive, unsigned int rev, byte ultra_66)
+		case XFER_UDMA_6:
+			if ((scsc & 0x30) == 0x00)
+				goto speed_break;
+			multi = 0x10C1;
+			ultra &= ~0x3F;
+			ultra |= 0x01;
+			break;
+speed_break :
+			speed = XFER_UDMA_5;
+		case XFER_UDMA_5:
+			multi = 0x10C1;
+			ultra &= ~0x3F;
+			ultra |= (((scsc & 0x30) == 0x00) ? 0x01 : 0x02);
+			break;
+		case XFER_UDMA_4:
+			multi = 0x10C1;
+			ultra &= ~0x3F;
+			ultra |= (((scsc & 0x30) == 0x00) ? 0x02 : 0x03);
+			break;
+		case XFER_UDMA_3:
+			multi = 0x10C1;
+			ultra &= ~0x3F;
+			ultra |= (((scsc & 0x30) == 0x00) ? 0x04 : 0x05);
+			break;
+		case XFER_UDMA_2:
+			multi = 0x10C1;
+			ultra &= ~0x3F;
+			ultra |= (((scsc & 0x30) == 0x00) ? 0x05 : 0x07);
+			break;
+		case XFER_UDMA_1:
+			multi = 0x10C1;
+			ultra &= ~0x3F;
+			ultra |= (((scsc & 0x30) == 0x00) ? 0x07 : 0x0B);
+			break;
+		case XFER_UDMA_0:
+			multi = 0x10C1;
+			ultra &= ~0x3F;
+			ultra |= (((scsc & 0x30) == 0x00) ? 0x0C : 0x0F);
+			break;
+		case XFER_MW_DMA_2:
+			multi = 0x10C1;
+			break;
+		case XFER_MW_DMA_1:
+			multi = 0x10C2;
+			break;
+		case XFER_MW_DMA_0:
+			multi = 0x2208;
+			break;
+#endif /* CONFIG_BLK_DEV_IDEDMA */
+		case XFER_PIO_4:	cmd680_tuneproc(drive, 4); break;
+		case XFER_PIO_3:	cmd680_tuneproc(drive, 3); break;
+		case XFER_PIO_2:	cmd680_tuneproc(drive, 2); break;
+		case XFER_PIO_1:	cmd680_tuneproc(drive, 1); break;
+		case XFER_PIO_0:	cmd680_tuneproc(drive, 0); break;
+		default:
+			return 1;
+	}
+
+	
+	if (speed >= XFER_MW_DMA_0) 
+		config_cmd680_chipset_for_pio(drive, 0);
+
+	if (speed >= XFER_UDMA_0)
+		mode_pci |= ((unit) ? 0x30 : 0x03);
+	else if (speed >= XFER_MW_DMA_0)
+		mode_pci |= ((unit) ? 0x20 : 0x02);
+	else
+		mode_pci |= ((unit) ? 0x10 : 0x01);
+
+	pci_write_config_byte(dev, addr_mask, mode_pci);
+	pci_write_config_word(dev, dma_pci, multi);
+	pci_write_config_word(dev, udma_pci, ultra);
+
+	err = ide_config_drive_speed(drive, speed);
+	drive->current_speed = speed;
+	return err;
+}
+
+#ifdef CONFIG_BLK_DEV_IDEDMA
+static int config_cmd64x_chipset_for_dma (ide_drive_t *drive, unsigned int rev, byte ultra_66)
 {
 	struct hd_driveid *id	= drive->id;
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -493,6 +689,10 @@
 	if (!drive->init_speed)
 		drive->init_speed = speed;
 
+//test 
+//	set_pio = 0;
+//	speed = 0;
+//
 	config_chipset_for_pio(drive, set_pio);
 
 	if (set_pio)
@@ -510,6 +710,55 @@
 	return rval;
 }
 
+static int config_cmd680_chipset_for_dma (ide_drive_t *drive)
+{
+	struct hd_driveid *id	= drive->id;
+	byte udma_66		= eighty_ninty_three(drive);
+	byte speed		= 0x00;
+	byte set_pio		= 0x00;
+	int rval;
+
+	if ((id->dma_ultra & 0x0040) && (udma_66))	speed = XFER_UDMA_6;
+	else if ((id->dma_ultra & 0x0020) && (udma_66))	speed = XFER_UDMA_5;
+	else if ((id->dma_ultra & 0x0010) && (udma_66))	speed = XFER_UDMA_4;
+	else if ((id->dma_ultra & 0x0008) && (udma_66))	speed = XFER_UDMA_3;
+	else if (id->dma_ultra & 0x0004)		speed = XFER_UDMA_2;
+	else if (id->dma_ultra & 0x0002)		speed = XFER_UDMA_1;
+	else if (id->dma_ultra & 0x0001)		speed = XFER_UDMA_0;
+	else if (id->dma_mword & 0x0004)		speed = XFER_MW_DMA_2;
+	else if (id->dma_mword & 0x0002)		speed = XFER_MW_DMA_1;
+	else if (id->dma_mword & 0x0001)		speed = XFER_MW_DMA_0;
+	else {
+		set_pio = 1;
+	}
+
+	if (!drive->init_speed)
+		drive->init_speed = speed;
+
+	config_chipset_for_pio(drive, set_pio);
+
+	if (set_pio)
+		return ((int) ide_dma_off_quietly);
+
+	if (cmd680_tune_chipset(drive, speed))
+		return ((int) ide_dma_off);
+
+	rval = (int)(	((id->dma_ultra >> 14) & 3) ? ide_dma_on :
+			((id->dma_ultra >> 11) & 7) ? ide_dma_on :
+			((id->dma_ultra >> 8) & 7) ? ide_dma_on :
+			((id->dma_mword >> 8) & 7) ? ide_dma_on :
+			((id->dma_1word >> 8) & 7) ? ide_dma_on :
+						     ide_dma_off_quietly);
+	return rval;
+}
+
+static int config_chipset_for_dma (ide_drive_t *drive, unsigned int rev, byte ultra_66)
+{
+	if (HWIF(drive)->pci_dev->device == PCI_DEVICE_ID_CMD_680)
+		return (config_cmd680_chipset_for_dma(drive));
+	return (config_cmd64x_chipset_for_dma(drive, rev, ultra_66));
+}
+
 static int cmd64x_config_drive_for_dma (ide_drive_t *drive)
 {
 	struct hd_driveid *id	= drive->id;
@@ -519,12 +768,15 @@
 	byte can_ultra_33	= 0;
 	byte can_ultra_66	= 0;
 	byte can_ultra_100	= 0;
+	byte can_ultra_133	= 0;
 	ide_dma_action_t dma_func = ide_dma_on;
 
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
 	class_rev &= 0xff;	
 
 	switch(dev->device) {
+		case PCI_DEVICE_ID_CMD_680:
+			can_ultra_133 = 1;
 		case PCI_DEVICE_ID_CMD_649:
 			can_ultra_100 = 1;
 		case PCI_DEVICE_ID_CMD_648:
@@ -550,7 +802,7 @@
 		}
 		dma_func = ide_dma_off_quietly;
 		if ((id->field_valid & 4) && (can_ultra_33)) {
-			if (id->dma_ultra & 0x002F) {
+			if (id->dma_ultra & 0x007F) {
 				/* Force if Capable UltraDMA */
 				dma_func = config_chipset_for_dma(drive, class_rev, can_ultra_66);
 				if ((id->field_valid & 2) &&
@@ -586,6 +838,18 @@
 	return HWIF(drive)->dmaproc(dma_func, drive);
 }
 
+static int cmd680_dmaproc (ide_dma_action_t func, ide_drive_t *drive)
+{
+	switch (func) {
+		case ide_dma_check:
+			return cmd64x_config_drive_for_dma(drive);
+		default:
+			break;
+	}
+	/* Other cases are done by generic IDE-DMA code. */
+        return ide_dmaproc(func, drive);
+}
+
 static int cmd64x_dmaproc (ide_dma_action_t func, ide_drive_t *drive)
 {
 	byte dma_stat		= 0;
@@ -663,7 +927,78 @@
 }
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
-unsigned int __init pci_init_cmd64x (struct pci_dev *dev, const char *name)
+static int cmd680_busproc (ide_drive_t * drive, int state)
+{
+#if 0
+	ide_hwif_t *hwif	= HWIF(drive);
+	u8 addr_mask		= (hwif->channel) ? 0xB0 : 0xA0;
+	u32 stat_config		= 0;
+
+        pci_read_config_dword(hwif->pci_dev, addr_mask, &stat_config);
+
+	if (!hwif)
+		return -EINVAL;
+
+	switch (state) {
+		case BUSSTATE_ON:
+			hwif->drives[0].failures = 0;
+			hwif->drives[1].failures = 0;
+			break;
+		case BUSSTATE_OFF:
+			hwif->drives[0].failures = hwif->drives[0].max_failures + 1;
+			hwif->drives[1].failures = hwif->drives[1].max_failures + 1;
+			break;
+		case BUSSTATE_TRISTATE:
+			hwif->drives[0].failures = hwif->drives[0].max_failures + 1;
+			hwif->drives[1].failures = hwif->drives[1].max_failures + 1;
+			break;
+		default:
+			return 0;
+	}
+	hwif->bus_state = state;
+#endif
+	return 0;
+}
+
+void cmd680_reset (ide_drive_t *drive)
+{
+#if 0
+	ide_hwif_t *hwif	= HWIF(drive);
+	u8 addr_mask		= (hwif->channel) ? 0xB0 : 0xA0;
+	byte reset		= 0;
+
+	pci_read_config_byte(hwif->pci_dev, addr_mask, &reset);
+	pci_write_config_byte(hwif->pci_dev, addr_mask, reset|0x03);
+#endif
+}
+
+unsigned int cmd680_pci_init (struct pci_dev *dev, const char *name)
+{
+	u8 tmpbyte	= 0;	
+	pci_write_config_byte(dev, 0x80, 0x00);
+	pci_write_config_byte(dev, 0x84, 0x00);
+	pci_read_config_byte(dev, 0x8A, &tmpbyte);
+	pci_write_config_byte(dev, 0x8A, tmpbyte|0x01);
+	pci_write_config_word(dev, 0xA2, 0x328A);
+	pci_write_config_dword(dev, 0xA4, 0x328A);
+	pci_write_config_dword(dev, 0xA8, 0x4392);
+	pci_write_config_dword(dev, 0xAC, 0x4009);
+	pci_write_config_word(dev, 0xB2, 0x328A);
+	pci_write_config_dword(dev, 0xB4, 0x328A);
+	pci_write_config_dword(dev, 0xB8, 0x4392);
+	pci_write_config_dword(dev, 0xBC, 0x4009);
+
+#if defined(DISPLAY_CMD64X_TIMINGS) && defined(CONFIG_PROC_FS)
+	if (!cmd64x_proc) {
+		cmd64x_proc = 1;
+		bmide_dev = dev;
+		cmd64x_display_info = &cmd680_get_info;
+	}
+#endif /* DISPLAY_CMD64X_TIMINGS && CONFIG_PROC_FS */
+	return 0;
+}
+
+unsigned int cmd64x_pci_init (struct pci_dev *dev, const char *name)
 {
 	unsigned char mrdmode;
 	unsigned int class_rev;
@@ -707,9 +1042,9 @@
 
 	/* Set a good latency timer and cache line size value. */
 	(void) pci_write_config_byte(dev, PCI_LATENCY_TIMER, 64);
-#ifdef __sparc_v9__
+
+	/* Ethan: the cache line size fails to be updated. */
 	(void) pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, 0x10);
-#endif
 
 
 	/* Setup interrupts. */
@@ -723,7 +1058,12 @@
 	 *       back as set or not.  The PCI0646U2 specs clarify
 	 *       this point.
 	 */
+#if 1
 	(void) pci_write_config_byte(dev, MRDMODE, mrdmode | 0x02);
+#else
+	/* use MEMORY READ MULTIPLE */
+	(void) pci_write_config_byte(dev, MRDMODE, (mrdmode & 0xfc) | 0x01);
+#endif
 
 	/* Set reasonable active/recovery/address-setup values. */
 	(void) pci_write_config_byte(dev, ARTTIM0,  0x40);
@@ -740,6 +1080,7 @@
 #ifdef CONFIG_PPC
 	(void) pci_write_config_byte(dev, UDIDETCR0, 0xf0);
 #endif /* CONFIG_PPC */
+	pci_write_config_byte(dev, CMDTIM, 0x21);
 
 #if defined(DISPLAY_CMD64X_TIMINGS) && defined(CONFIG_PROC_FS)
 	if (!cmd64x_proc) {
@@ -748,11 +1089,43 @@
 		cmd64x_display_info = &cmd64x_get_info;
 	}
 #endif /* DISPLAY_CMD64X_TIMINGS && CONFIG_PROC_FS */
+//added by louis
+//	pci_write_config_byte(dev, 0x51, 0xe4);
+// only for debug use
+#if 0 
+	{
+	int i;
+        for (i = 0; i < 256; i++) {
+                u8      val;
+                if ( i % 16 == 0 )
+                        printk("\n%02x: ", i);
+                pci_read_config_byte(dev, i, &val);
+                printk("%02x ", val);
+        }
+        printk("\n");
+	}
+#endif
 
 	return 0;
 }
 
-unsigned int __init ata66_cmd64x (ide_hwif_t *hwif)
+unsigned int __init pci_init_cmd64x (struct pci_dev *dev, const char *name)
+{
+	if (dev->device == PCI_DEVICE_ID_CMD_680)
+		return cmd680_pci_init (dev, name);
+	return cmd64x_pci_init (dev, name);
+}
+
+unsigned int cmd680_ata66 (ide_hwif_t *hwif)
+{
+	byte ata66	= 0;
+	byte addr_mask	= (hwif->channel) ? 0xB0 : 0xA0;
+
+	pci_read_config_byte(hwif->pci_dev, addr_mask, &ata66);
+	return (ata66 & 0x01) ? 1 : 0;
+}
+
+unsigned int cmd64x_ata66 (ide_hwif_t *hwif)
 {
 	byte ata66 = 0;
 	byte mask = (hwif->channel) ? 0x02 : 0x01;
@@ -761,6 +1134,14 @@
 	return (ata66 & mask) ? 1 : 0;
 }
 
+unsigned int __init ata66_cmd64x (ide_hwif_t *hwif)
+{
+	struct pci_dev *dev	= hwif->pci_dev;
+	if (dev->device == PCI_DEVICE_ID_CMD_680)
+		return cmd680_ata66(hwif);
+	return cmd64x_ata66(hwif);
+}
+
 void __init ide_init_cmd64x (ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= hwif->pci_dev;
@@ -769,8 +1150,6 @@
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
 	class_rev &= 0xff;
 
-	hwif->tuneproc	= &cmd64x_tuneproc;
-	hwif->speedproc	= &cmd64x_tune_chipset;
 	hwif->drives[0].autotune = 1;
 	hwif->drives[1].autotune = 1;
 
@@ -779,10 +1158,19 @@
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	switch(dev->device) {
+		case PCI_DEVICE_ID_CMD_680:
+			hwif->busproc	= &cmd680_busproc;
+			hwif->dmaproc	= &cmd680_dmaproc;
+			hwif->resetproc = &cmd680_reset;
+			hwif->speedproc	= &cmd680_tune_chipset;
+			hwif->tuneproc	= &cmd680_tuneproc;
+			break;
 		case PCI_DEVICE_ID_CMD_649:
 		case PCI_DEVICE_ID_CMD_648:
 		case PCI_DEVICE_ID_CMD_643:
-			hwif->dmaproc = &cmd64x_dmaproc;
+			hwif->dmaproc	= &cmd64x_dmaproc;
+			hwif->tuneproc	= &cmd64x_tuneproc;
+			hwif->speedproc = &cmd64x_tune_chipset;
 			break;
 		case PCI_DEVICE_ID_CMD_646:
 			hwif->chipset = ide_cmd646;
@@ -791,6 +1179,8 @@
 			} else {
 				hwif->dmaproc = &cmd64x_dmaproc;
 			}
+			hwif->tuneproc	= &cmd64x_tuneproc;
+			hwif->speedproc	= &cmd64x_tune_chipset;
 			break;
 		default:
 			break;

--=-9GZSg901qeGmGJNd4enH--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1765073AbYBUUIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765073AbYBUUIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758253AbYBUUIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:08:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:9509 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbYBUUI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:08:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=G3NBbKDAevqcyjkhMT5nQYhOrnqO3/zvsmrWsxDtWI7jDG9YNHhsVBH0P2RnoQ8P6nW51G4dZl3U4UHpn3P3FKZw44wAvbhb10aaBYnffctfo1YEh2c6608IwlK+2x59lSxtewyfPbkUNH+FRpmypr/WHtCnorBp1kFu1le6SZU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove dead/obsolete ->busproc method
Date: Thu, 21 Feb 2008 21:21:03 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802212121.03847.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->busproc method is used by HDIO_SET_BUSSTATE ioctl but it has no chance
of working as intended (in 2.4.x days) because to issue an ioctl there
is a device node needed and:

- for BUSSTATE_TRISTATE+OFF it is too late (devices are already gone)

- for BUSSTATE_TRISTATE+ON it is too early (devices are not registered yet)

Just remove ->busproc method for now (it was only implemented by hpt366,
siimage and tc86c001 host drivers).

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
This patch goes before "ide: add warm-plug support for IDE devices" in
the IDE quilt tree.

 drivers/ide/ide.c          |    3 --
 drivers/ide/pci/hpt366.c   |   59 ---------------------------------------------
 drivers/ide/pci/sgiioc4.c  |    1 
 drivers/ide/pci/siimage.c  |   43 --------------------------------
 drivers/ide/pci/tc86c001.c |   36 ---------------------------
 include/linux/ide.h        |    2 -
 6 files changed, 144 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -418,7 +418,6 @@ static void ide_hwif_restore(ide_hwif_t 
 	hwif->resetproc			= tmp_hwif->resetproc;
 	hwif->maskproc			= tmp_hwif->maskproc;
 	hwif->quirkproc			= tmp_hwif->quirkproc;
-	hwif->busproc			= tmp_hwif->busproc;
 
 	hwif->ata_input_data		= tmp_hwif->ata_input_data;
 	hwif->ata_output_data		= tmp_hwif->ata_output_data;
@@ -1083,8 +1082,6 @@ int generic_ide_ioctl(ide_drive_t *drive
 		case HDIO_SET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
-			if (HWIF(drive)->busproc)
-				return HWIF(drive)->busproc(drive, (int)arg);
 			return -EOPNOTSUPP;
 		default:
 			return -EINVAL;
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -929,64 +929,6 @@ static void hpt3xxn_rw_disk(ide_drive_t 
 	hpt3xxn_set_clock(HWIF(drive), rq_data_dir(rq) ? 0x23 : 0x21);
 }
 
-/* 
- * Set/get power state for a drive.
- * NOTE: affects both drives on each channel.
- *
- * When we turn the power back on, we need to re-initialize things.
- */
-#define TRISTATE_BIT  0x8000
-
-static int hpt3xx_busproc(ide_drive_t *drive, int state)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u8  mcr_addr		= hwif->select_data + 2;
-	u8  resetmask		= hwif->channel ? 0x80 : 0x40;
-	u8  bsr2		= 0;
-	u16 mcr			= 0;
-
-	hwif->bus_state = state;
-
-	/* Grab the status. */
-	pci_read_config_word(dev, mcr_addr, &mcr);
-	pci_read_config_byte(dev, 0x59, &bsr2);
-
-	/*
-	 * Set the state. We don't set it if we don't need to do so.
-	 * Make sure that the drive knows that it has failed if it's off.
-	 */
-	switch (state) {
-	case BUSSTATE_ON:
-		if (!(bsr2 & resetmask))
-			return 0;
-		hwif->drives[0].failures = hwif->drives[1].failures = 0;
-
-		pci_write_config_byte(dev, 0x59, bsr2 & ~resetmask);
-		pci_write_config_word(dev, mcr_addr, mcr & ~TRISTATE_BIT);
-		return 0;
-	case BUSSTATE_OFF:
-		if ((bsr2 & resetmask) && !(mcr & TRISTATE_BIT))
-			return 0;
-		mcr &= ~TRISTATE_BIT;
-		break;
-	case BUSSTATE_TRISTATE:
-		if ((bsr2 & resetmask) &&  (mcr & TRISTATE_BIT))
-			return 0;
-		mcr |= TRISTATE_BIT;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	hwif->drives[0].failures = hwif->drives[0].max_failures + 1;
-	hwif->drives[1].failures = hwif->drives[1].max_failures + 1;
-
-	pci_write_config_word(dev, mcr_addr, mcr);
-	pci_write_config_byte(dev, 0x59, bsr2 | resetmask);
-	return 0;
-}
-
 /**
  *	hpt37x_calibrate_dpll	-	calibrate the DPLL
  *	@dev: PCI device
@@ -1334,7 +1276,6 @@ static void __devinit init_hwif_hpt366(i
 
 	hwif->quirkproc		= &hpt3xx_quirkproc;
 	hwif->maskproc		= &hpt3xx_maskproc;
-	hwif->busproc		= &hpt3xx_busproc;
 
 	hwif->udma_filter	= &hpt3xx_udma_filter;
 	hwif->mdma_filter	= &hpt3xx_mdma_filter;
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -562,7 +562,6 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 						clear interrupts */
 	hwif->maskproc = &sgiioc4_maskproc;	/* Mask on/off NIEN register */
 	hwif->quirkproc = NULL;
-	hwif->busproc = NULL;
 
 	hwif->INB = &sgiioc4_INB;
 
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -370,48 +370,6 @@ static int siimage_mmio_ide_dma_test_irq
 }
 
 /**
- *	sil_sata_busproc	-	bus isolation IOCTL
- *	@drive: drive to isolate/restore
- *	@state: bus state to set
- *
- *	Used by the SII3112 to handle bus isolation. As this is a 
- *	SATA controller the work required is quite limited, we 
- *	just have to clean up the statistics
- */
-
-static int sil_sata_busproc(ide_drive_t * drive, int state)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u32 stat_config		= 0;
-	unsigned long addr	= siimage_selreg(hwif, 0);
-
-	if (hwif->mmio)
-		stat_config = readl((void __iomem *)addr);
-	else
-		pci_read_config_dword(dev, addr, &stat_config);
-
-	switch (state) {
-		case BUSSTATE_ON:
-			hwif->drives[0].failures = 0;
-			hwif->drives[1].failures = 0;
-			break;
-		case BUSSTATE_OFF:
-			hwif->drives[0].failures = hwif->drives[0].max_failures + 1;
-			hwif->drives[1].failures = hwif->drives[1].max_failures + 1;
-			break;
-		case BUSSTATE_TRISTATE:
-			hwif->drives[0].failures = hwif->drives[0].max_failures + 1;
-			hwif->drives[1].failures = hwif->drives[1].max_failures + 1;
-			break;
-		default:
-			return -EINVAL;
-	}
-	hwif->bus_state = state;
-	return 0;
-}
-
-/**
  *	sil_sata_reset_poll	-	wait for SATA reset
  *	@drive: drive we are resetting
  *
@@ -818,7 +776,6 @@ static void __devinit init_hwif_siimage(
 	if (sata) {
 		static int first = 1;
 
-		hwif->busproc = &sil_sata_busproc;
 		hwif->reset_poll = &sil_sata_reset_poll;
 		hwif->pre_reset = &sil_sata_pre_reset;
 		hwif->udma_filter = &sil_sata_udma_filter;
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -126,40 +126,6 @@ static void tc86c001_dma_start(ide_drive
 	ide_dma_start(drive);
 }
 
-static int tc86c001_busproc(ide_drive_t *drive, int state)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	unsigned long sc_base	= hwif->config_data;
-	u16 scr1;
-
-	/* System Control 1 Register bit 11 (ATA Hard Reset) read */
-	scr1 = inw(sc_base + 0x00);
-
-	switch (state) {
-		case BUSSTATE_ON:
-			if (!(scr1 & 0x0800))
-				return 0;
-			scr1 &= ~0x0800;
-
-			hwif->drives[0].failures = hwif->drives[1].failures = 0;
-			break;
-		case BUSSTATE_OFF:
-			if (scr1 & 0x0800)
-				return 0;
-			scr1 |= 0x0800;
-
-			hwif->drives[0].failures = hwif->drives[0].max_failures + 1;
-			hwif->drives[1].failures = hwif->drives[1].max_failures + 1;
-			break;
-		default:
-			return -EINVAL;
-	}
-
-	/* System Control 1 Register bit 11 (ATA Hard Reset) write */
-	outw(scr1, sc_base + 0x00);
-	return 0;
-}
-
 static u8 __devinit tc86c001_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -194,8 +160,6 @@ static void __devinit init_hwif_tc86c001
 	hwif->set_pio_mode = &tc86c001_set_pio_mode;
 	hwif->set_dma_mode = &tc86c001_set_mode;
 
-	hwif->busproc	= &tc86c001_busproc;
-
 	hwif->cable_detect = tc86c001_cable_detect;
 
 	if (!hwif->dma_base)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -502,8 +502,6 @@ typedef struct hwif_s {
 	void	(*maskproc)(ide_drive_t *, int);
 	/* check host's drive quirk list */
 	void	(*quirkproc)(ide_drive_t *);
-	/* driver soft-power interface */
-	int	(*busproc)(ide_drive_t *, int);
 #endif
 	u8 (*mdma_filter)(ide_drive_t *);
 	u8 (*udma_filter)(ide_drive_t *);

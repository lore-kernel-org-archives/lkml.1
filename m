Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbXEXJdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbXEXJdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbXEXJdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:33:13 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:64223 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbXEXJdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:33:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=JIMBhjuqhFXi5nCPVPKwpzGunTn/cTwEtatE5y+Qrcy2KZy19hCm7Me6xjoHeVzdTpt1mMDWgIyY+OCrbR34ZiAXDkbeloDgogRq/KIWAJ8+CG1GFZBvGcaMsklHX9EZz/d2jOocCodRV4OuMxKp9D5WmYzUh/8ahkvBUnSG7CE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Thomas Kuther <gimpel@sonnenkinder.org>
Subject: Re: IT821x: no DMA since 2.6.21
Date: Thu, 24 May 2007 11:46:23 +0200
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20070515125308.3a9f6442@SiRiUS.home> <200705161146.19497.bzolnier@gmail.com> <20070518114722.3109a4a6@SiRiUS.home>
In-Reply-To: <20070518114722.3109a4a6@SiRiUS.home>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705241146.24079.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 18 May 2007, Thomas Kuther wrote:
> On Mi, 16.05.07 11:46 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> wrote:
> 
> > > Shall I test it without "noraid=1" too? 
> > 
> > Please do, the main goal of the patch was to fix "RAID mode"
> > ("noraid=1" should work fine also without the patch?).
> > 
> > Thanks,
> > Bart
> 
> Hi,
> 
> sorry for late response. Now the results in smart mode:
> ---------------------------------------------------
> IT8212: IDE controller at PCI slot 0000:00:09.0
> ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 18
> IT8212: chipset revision 17
> it821x: controller in smart mode.
> IT8212: 100% native mode on irq 18
>     ide2: BM-DMA at 0xdc00-0xdc07, BIOS settings: hde:pio, hdf:pio
>     ide3: BM-DMA at 0xdc08-0xdc0f, BIOS settings: hdg:pio, hdh:pio
> Probing IDE interface ide2...
> hde: SAMSUNG SP2514N, ATA DISK drive
> hdf: Maxtor 6Y120L0, ATA DISK drive
> hde: Performing identify fixups.
> hdf: Performing identify fixups.
> ide2 at 0xec00-0xec07,0xe802 on irq 18
> hde: max request size: 128KiB
> hde: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63
>  hde:hde: recal_intr: status=0x51 { DriveReady SeekComplete Error }
> hde: recal_intr: error=0x04 { DriveStatusError }
> ide: failed opcode was: unknown
>  hde1
> hdf: max request size: 128KiB
> hdf: 240121728 sectors (122942 MB) w/2048KiB Cache, CHS=65535/16/63
>  hdf:hdf: recal_intr: status=0x51 { DriveReady SeekComplete Error }
> hdf: recal_intr: error=0x04 { DriveStatusError }
> ide: failed opcode was: unknown
>  hdf1
> ------------------------------------------------------
> 
> # hdparm -d1 /dev/hde
> 
> /dev/hde:
>  setting using_dma to 1 (on)
>  HDIO_SET_DMA failed: Input/output error
>  using_dma     =  0 (off)
> 
> -------------------------------------------------------
> 
> Buffered reads: 3.06MB/s
> 
> Seems I shot too quick, DMA in smart mode still does not work.
> "noraid=1" also works without the patch, correct.

Improved patch - this time the issue should be fixed for good (I was
looking only at the RAID specific part of the fixups and I overlooked
the fact that the original code was clearing too much of id->field_valid),
there is now also an extra debugging printk to give us some more info.

Please give it a try.

[ recal_intr warning (which should be harmless) is not fixed by this
  patch because it is a different problem and requires some more work. ]

---
 drivers/ide/ide-probe.c  |   12 ++++++------
 drivers/ide/pci/it821x.c |   38 +++++++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 21 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -717,7 +717,7 @@ EXPORT_SYMBOL_GPL(ide_undecoded_slave);
  * This routine only knows how to look for drive units 0 and 1
  * on an interface, so any setting of MAX_DRIVES > 2 won't work here.
  */
-static void probe_hwif(ide_hwif_t *hwif)
+static void probe_hwif(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
 {
 	unsigned int unit;
 	unsigned long flags;
@@ -820,6 +820,9 @@ static void probe_hwif(ide_hwif_t *hwif)
 		return;
 	}
 
+	if (fixup)
+		fixup(hwif);
+
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t *drive = &hwif->drives[unit];
 
@@ -874,10 +877,7 @@ static int hwif_init(ide_hwif_t *hwif);
 
 int probe_hwif_init_with_fixup(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
 {
-	probe_hwif(hwif);
-
-	if (fixup)
-		fixup(hwif);
+	probe_hwif(hwif, fixup);
 
 	if (!hwif_init(hwif)) {
 		printk(KERN_INFO "%s: failed to initialize IDE interface\n",
@@ -1404,7 +1404,7 @@ int ideprobe_init (void)
 
 	for (index = 0; index < MAX_HWIFS; ++index)
 		if (probe[index])
-			probe_hwif(&ide_hwifs[index]);
+			probe_hwif(&ide_hwifs[index], NULL);
 	for (index = 0; index < MAX_HWIFS; ++index)
 		if (probe[index])
 			hwif_init(&ide_hwifs[index]);
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -262,7 +262,7 @@ static int it821x_tunepio(ide_drive_t *d
 	}
 
 	if (itdev->smart)
-		goto set_drive_speed;
+		return 0;
 
 	/* We prefer 66Mhz clock for PIO 0-3, don't care for PIO4 */
 	itdev->want[unit][1] = pio_want[set_pio];
@@ -271,7 +271,6 @@ static int it821x_tunepio(ide_drive_t *d
 	it821x_clock_strategy(drive);
 	it821x_program(drive, itdev->pio[unit]);
 
-set_drive_speed:
 	return ide_config_drive_speed(drive, XFER_PIO_0 + set_pio);
 }
 
@@ -455,12 +454,12 @@ static int it821x_tune_chipset (ide_driv
 			default:
 				return 1;
 		}
+
+		return ide_config_drive_speed(drive, speed);
 	}
-	/*
-	 *	In smart mode the clocking is done by the host controller
-	 * 	snooping the mode we picked. The rest of it is not our problem
-	 */
-	return ide_config_drive_speed(drive, speed);
+
+	/* don't touch anything in the smart mode */
+	return 0;
 }
 
 /**
@@ -543,6 +542,13 @@ static void __devinit it821x_fixups(ide_
 		id = drive->id;
 		idbits = (u16 *)drive->id;
 
+		/* debug */
+		printk(KERN_INFO "%s: field_valid=%04x capability=%02x "
+				 "dma_mword=%04x dma_status=%02x\n",
+				 drive->name,
+				 id->field_valid, id->capability,
+				 id->dma_mword, inb(hwif->dma_status));
+
 		/* Check for RAID v native */
 		if(strstr(id->model, "Integrated Technology Express")) {
 			/* In raid mode the ident block is slightly buggy
@@ -559,17 +565,10 @@ static void __devinit it821x_fixups(ide_
 				if(idbits[129] != 1)
 					printk("(%dK stripe)", idbits[146]);
 				printk(".\n");
-			/* Now the core code will have wrongly decided no DMA
-			   so we need to fix this */
-			hwif->dma_off_quietly(drive);
-#ifdef CONFIG_IDEDMA_ONLYDISK
-			if (drive->media == ide_disk)
-#endif
-				ide_set_dma(drive);
 		} else {
 			/* Non RAID volume. Fixups to stop the core code
 			   doing unsupported things */
-			id->field_valid &= 1;
+			id->field_valid &= 3;
 			id->queue_depth = 0;
 			id->command_set_1 = 0;
 			id->command_set_2 &= 0xC400;
@@ -584,6 +583,15 @@ static void __devinit it821x_fixups(ide_
 			printk(KERN_INFO "%s: Performing identify fixups.\n",
 				drive->name);
 		}
+
+		/*
+		 * Set MWDMA0 mode as enabled/support - just to tell
+		 * IDE core that DMA is supported (it821x hardware
+		 * takes care of DMA mode programming).
+		 */
+		id->capability |= 1;
+		id->dma_mword |= 0x0101;
+		drive->current_speed = XFER_MW_DMA_0;
 	}
 
 }


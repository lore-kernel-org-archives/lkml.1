Return-Path: <linux-kernel-owner+w=401wt.eu-S1762083AbXEPAr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083AbXEPAr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761713AbXEPAqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:46:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:35755 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760967AbXEPAqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:46:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uRzTQ5BsjQ4WGz9A5Lh5xaHa7eHA9Rc9lhYzl6Palg5dVvBrZORZllRQ6rrovcMGDmJRl1tOcp4ISBfgYDRI5Vk2craIzQo6V8+euBh2XIq4Ka+tfPssWZLE4tmbSypoqLbSu6YkzMigHBV6GQGLJD2xUDWnh9tAazGIhdhmzw4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: IT821x: no DMA since 2.6.21
Date: Wed, 16 May 2007 02:58:15 +0200
User-Agent: KMail/1.9.6
Cc: Thomas Kuther <gimpel@sonnenkinder.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20070515125308.3a9f6442@SiRiUS.home> <20070515123132.2e596d69@the-village.bc.nu>
In-Reply-To: <20070515123132.2e596d69@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705160258.15928.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 15 May 2007, Alan Cox wrote:
> On Tue, 15 May 2007 12:53:08 +0200
> Thomas Kuther <gimpel@sonnenkinder.org> wrote:
> 
> > Hi!
> > 
> > Since 2.6.21 I have a problem with the it821x driver on my ITE 8212
> > controller.
> > Now I saw some updates to it821x in 2.6.22-rc1 and gave that a try, but
> > the problem persists.
> 
> I've had multiple reports of this. I would recommend you use the libata
> driver. IT821x hasn't changed over the past few releases so its someting

commit 0e9b4e535fec7e2a189952670937adfbe2826b63
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sat May 5 22:03:50 2007 +0200

    it821x: PIO mode setup fixes

...

*cough, cough* ;)

> in the core IDE code that broke it [note it might not of course be that
> the problem is in the core code..].

The real problem seems to be that IT821x "virtual" ID misses info
about supported DMA modes (while it seems to contain enabled DMA
mode info).

This would be the logical explanation why the driver broke after:

commit 71ef51cc1756d1c56b57c70e7cc27a3559c81ee6
Author: Jens Axboe <axboe@suse.de>
Date:   Fri Jul 28 09:02:17 2006 +0200

    [PATCH] it821x: fix ide dma setup bug

    Only enable dma for a valid speed setting.

    Signed-off-by: Jens Axboe <axboe@suse.de>

commit 0a8348d08677ad77ee353f96eb8745c693a05a13
Author: Jens Axboe <axboe@suse.de>
Date:   Fri Jul 28 08:58:26 2006 +0200

    [PATCH] ide: if the id fields looks screwy, disable DMA

    It's the safer choice. Originally due to a bug in itx821x, but a
    generally sound thing to do.

    Signed-off-by: Jens Axboe <axboe@suse.de>


Bogus ide_dma_enable() usage in it821x.c + loosy check in ide_dma_verbose()
allowed the hardware to operate in DMA mode, when these bugs were fixed
DMA support broke...

> I have no plans at this point to debug the old IT821x driver due to time
> constraints, and if anyone wants to have a crack at debugging this and
> fixing it go for it.

It seems that somebody has already debugged this issue to
the aforementioned changes:

http://lkml.org/lkml/2007/1/14/110


Thomas, does the following patch against 2.6.22-rc1 fix the issue?

[ Patch is based on the above theory and Alan's work on pata_it821x.
  Sorry for no real description (TODO) but it's almost 3:00 am ... ]
---
 drivers/ide/ide-probe.c  |   12 ++++++------
 drivers/ide/pci/it821x.c |   36 +++++++++++++++++++++---------------
 2 files changed, 27 insertions(+), 21 deletions(-)

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
@@ -556,6 +555,7 @@ static void __devinit it821x_fixups(ide_
 		ide_drive_t *drive = &hwif->drives[i];
 		struct hd_driveid *id;
 		u16 *idbits;
+		u8 unit = drive->dn & 1;
 
 		if(!drive->present)
 			continue;
@@ -567,9 +567,22 @@ static void __devinit it821x_fixups(ide_
 			/* In raid mode the ident block is slightly buggy
 			   We need to set the bits so that the IDE layer knows
 			   LBA28. LBA48 and DMA ar valid */
-			id->capability |= 3;		/* LBA28, DMA */
+			id->capability |= 2;		/* LBA28 */
 			id->command_set_2 |= 0x0400;	/* LBA48 valid */
 			id->cfs_enable_2 |= 0x0400;	/* LBA48 on */
+			/*
+			 * If BIOS configured the device for DMA then set
+			 * MWDMA0 mode as enabled/support - just to tell
+			 * IDE core that DMA is supported (it821x hardware
+			 * takes care of DMA mode programming).
+			 */
+			if (inb(hwif->dma_status) & (1 << (5 + unit))) {
+				id->capability |= 1;
+				id->dma_mword |= 0x0101;
+				drive->current_speed = XFER_MW_DMA_0;
+			} else {
+				drive->current_speed = XFER_PIO_0;
+			}
 			/* Reporting logic */
 			printk(KERN_INFO "%s: IT8212 %sRAID %d volume",
 				drive->name,
@@ -578,13 +591,6 @@ static void __devinit it821x_fixups(ide_
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

Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbXFBVTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbXFBVTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 17:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757140AbXFBVTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 17:19:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:48058 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbXFBVTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 17:19:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=h1AgWtzQuBJPVwZx870l6SNxX2S8b+wTW/xvN5ngvQSSMUFPKNpNsIS4YqB1lPSVO1Q49uAVi/lKseIy6FO+b2Jj/Oi18AA1N/blb8caDiilWfKdOhwuNhWgE7sDIP01fVg+ycArH0IEXMzdeVx6DrL3DFJLlnNpqeG9rRkGhgI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] it821x: RAID mode fixes
Date: Sat, 2 Jun 2007 23:26:07 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Thomas Kuther <gimpel@sonnenkinder.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <axboe@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706022326.07605.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ The same patch as before but polished a bit, changes: don't force DMA
  capable bit, remove debugging, bump version and add patch description.

  I think that there is no need to re-test it (but it won't hurt either). ]

The DMA support for RAID mode broke after:

	commit 71ef51cc1756d1c56b57c70e7cc27a3559c81ee6
	Author: Jens Axboe <axboe@suse.de>
	Date:   Fri Jul 28 09:02:17 2006 +0200

	    [PATCH] it821x: fix ide dma setup bug

	    Only enable dma for a valid speed setting.

	    Signed-off-by: Jens Axboe <axboe@suse.de>

	commit 0a8348d08677ad77ee353f96eb8745c693a05a13
	Author: Jens Axboe <axboe@suse.de>
	Date:   Fri Jul 28 08:58:26 2006 +0200

	    [PATCH] ide: if the id fields looks screwy, disable DMA

	    It's the safer choice. Originally due to a bug in itx821x, but a
	    generally sound thing to do.

	    Signed-off-by: Jens Axboe <axboe@suse.de>

However it worked by pure luck before Jens' fixes: bogus ide_dma_enable()
usage in it821x driver combined with loosy check in ide_dma_verbose() allowed
the hardware to operate in DMA mode.  When these problems were fixed the DMA
support broke...

The source root for the regression turned out to be that the it821x.c code
was clearing too much of id->field_valid.  The IDE core code was using the
original value of id->field_valid to do the tuning but later DMA got disabled
in ide_dma_verbose() because of the incorrect id->field_valid fixup.  Fix it.

While at it:

* Do fixup() after probing the drives but before tuning them (which is also
  OK w.r.t. ide_undecoded_slave() fixup).  This change fixes device IDENTIFY
  data to be consistent before/after the tuning and allows us to remove extra
  re-tuning of drives from it821x_fixups().

* Fake MWDMA0 enabled/supported bits in IDENTIFY data if the device has
  DMA capable bit set (this is just to tell the IDE core that DMA is
  supported since it821x firmware takes care of DMA mode programming).

* Don't touch timing registers and don't program transfer modes on devices
  et all when in RAID mode - depend solely on firmware to do the tuning
  (as suggested by Alan Cox and done in libata pata_it821x driver).

Thanks for testing the patch goes out to Thomas Kuther.

Cc: Thomas Kuther <gimpel@sonnenkinder.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jens Axboe <axboe@suse.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c  |   12 ++++++------
 drivers/ide/pci/it821x.c |   34 ++++++++++++++++++----------------
 2 files changed, 24 insertions(+), 22 deletions(-)

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
@@ -1,6 +1,6 @@
 
 /*
- * linux/drivers/ide/pci/it821x.c		Version 0.10	Mar 10 2007
+ * linux/drivers/ide/pci/it821x.c		Version 0.15	Jun 2 2007
  *
  * Copyright (C) 2004		Red Hat <alan@redhat.com>
  * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
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
@@ -559,17 +558,10 @@ static void __devinit it821x_fixups(ide_
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
@@ -584,6 +576,16 @@ static void __devinit it821x_fixups(ide_
 			printk(KERN_INFO "%s: Performing identify fixups.\n",
 				drive->name);
 		}
+
+		/*
+		 * Set MWDMA0 mode as enabled/support - just to tell
+		 * IDE core that DMA is supported (it821x hardware
+		 * takes care of DMA mode programming).
+		 */
+		if (id->capability & 1) {
+			id->dma_mword |= 0x0101;
+			drive->current_speed = XFER_MW_DMA_0;
+		}
 	}
 
 }

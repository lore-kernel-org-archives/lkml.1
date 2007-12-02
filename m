Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbXLBSm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbXLBSm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXLBSmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:42:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:24442 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbXLBSmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:42:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=BMI+Bbtx4qSYHshtSJ3CvVzewNetn75mZKkSabWufp3ednzar9YOxVN5z8i9uPqNE1z2FiO89hmLGQaStfE1zrUuCEFYEorCsIzG3Ek37Vyo9CruAMeBh01ItryuHOxB/1DtysLsahZKsw7Hfhhr+dBN3Zz69yMRVb6wbdtWUbs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Peculiar out-of-sync boot log lines
Date: Sun, 2 Dec 2007 19:30:34 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Mark Lord <lkml@rtr.ca>, Nick Warne <nick@ukfsn.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20071129193728.2f1c237e@linuxamd.linicks.net> <200712012259.35152.bzolnier@gmail.com> <20071201151419.39a169f1.randy.dunlap@oracle.com>
In-Reply-To: <20071201151419.39a169f1.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712021930.34413.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 December 2007, Randy Dunlap wrote:
> On Sat, 1 Dec 2007 22:59:35 +0100 Bartlomiej Zolnierkiewicz wrote:
> 
> > Thanks for reporting/debugging it guys!
> > 
> > > Something in there needs to insert a '\n' before the "skipping word" message.
> > > Since it doesn't do that right now, the KERN_DEBUG string appears as "<7>"
> > 
> > This seems like a good occasion to fix ide_dma_verbose() for good so... :)
> > 
> > [ patch is against current Linus tree so might not apply to 2.6.23.9 ]
> > 
> > [PATCH] ide: DMA reporting and validity checking fixes
> > 
> > * ide_xfer_verbose() fixups:
> >   - beautify returned mode names
> >   - fix PIO5 reporting
> >   - make it return 'const char *'
> > 
> > * Change printk() level from KERN_DEBUG to KERN_INFO in ide_find_dma_mode().
> > 
> > * Add ide_id_dma_bug() helper based on ide_dma_verbose() to check for invalid
> >   DMA info in identify block.
> > 
> > * Use ide_id_dma_bug() in ide_tune_dma() and ide_driveid_update().
> > 
> >   As a result DMA won't be tuned or will be disabled after tuning if device
> >   reports inconsistent info about enabled DMA mode (ide_dma_verbose() does the
> >   same checks while the IDE device is probed by ide-{cd,disk} device driver).
> > 
> > * Since (id->capability & 1) && id->tDMA is a valid configuration handle
> >   it correctly in ide_id_dma_bug().
> > 
> > * Remove no longer needed ide_dma_verbose().
> > 
> > This patch should fix the following problem with out-of-sync IDE messages
> > reported by Nick Warned:
> > 
> >        hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache<7>hdd:
> >        skipping word 93 validity check
> >         , UDMA(66)
> > 
> > and later debugged by Mark Lord to be caused by:
> > 
> >         ide_dma_verbose()
> >                 printk( ... "2048kB Cache");
> >         eighty_ninty_three()
> >                 printk(KERN_DEBUG "%s: skipping word 93 validity check\n");
> >         ide_dma_verbose()
> >                 printk(", UDMA(66)"
> > 
> > Please note that as a result ide-{cd,disk} device drivers won't report the
> > DMA speed used but this is intended since now DMA mode being used is always
> > reported by IDE core code.
> > 
> > Cc: Nick Warne <nick@ukfsn.org>
> > Cc: Mark Lord <lkml@rtr.ca>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/ide-cd.c   |    7 ------
> >  drivers/ide/ide-disk.c |    5 ----
> >  drivers/ide/ide-dma.c  |   57 ++++++++++++-------------------------------------
> >  drivers/ide/ide-iops.c |    3 ++
> >  drivers/ide/ide-lib.c  |   55 ++++++++++++++++++++++++-----------------------
> >  include/linux/ide.h    |    6 ++---
> >  6 files changed, 51 insertions(+), 82 deletions(-)
> > 
> > Index: b/drivers/ide/ide-cd.c
> > ===================================================================
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -3049,12 +3049,7 @@ int ide_cdrom_probe_capabilities (ide_dr
> >          else 	
> >          	printk(" drive");
> >  
> > -	printk(", %dkB Cache", be16_to_cpu(cap.buffer_size));
> > -
> > -	if (drive->using_dma)
> > -		ide_dma_verbose(drive);
> > -
> > -	printk("\n");
> > +	printk(", %dkB Cache\n", be16_to_cpu(cap.buffer_size));
> 
> Use
> 	printk(KERN_CONT ...
> so that someone won't try to add another KERN_* facility level to it.
> (same for other continued printk calls in this patch)

good idea, fixed

[ I keep forgetting that there is KERN_CONT... ]

> >  
> >  	return nslots;
> >  }
> > Index: b/drivers/ide/ide-disk.c
> > ===================================================================
> > --- a/drivers/ide/ide-disk.c
> > +++ b/drivers/ide/ide-disk.c
> > @@ -961,11 +961,8 @@ static void idedisk_setup (ide_drive_t *
> >  	if (id->buf_size)
> >  		printk (" w/%dKiB Cache", id->buf_size/2);
> >  
> > -	printk(", CHS=%d/%d/%d", 
> > +	printk(", CHS=%d/%d/%d\n",
> 
> Ditto.

fixed

> >  	       drive->bios_cyl, drive->bios_head, drive->bios_sect);
> > -	if (drive->using_dma)
> > -		ide_dma_verbose(drive);
> > -	printk("\n");
> >  
> >  	/* write cache enabled? */
> >  	if ((id->csfo & 1) || (id->cfs_enable_1 & (1 << 5)))
> 
> > Index: b/include/linux/ide.h
> > ===================================================================
> > --- a/include/linux/ide.h
> > +++ b/include/linux/ide.h
> 
> > @@ -1333,8 +1334,7 @@ static inline void ide_set_hwifdata (ide
> >  	hwif->hwif_data = data;
> >  }
> >  
> > -/* ide-lib.c */
> > -extern char *ide_xfer_verbose(u8 xfer_rate);
> > +const char *ide_xfer_verbose(u8);
> >  extern void ide_toggle_bounce(ide_drive_t *drive, int on);
> >  extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);
> 
> Ideally function prototypes would include variable names, not just
> types, as a helpful hint to readers of them.

fixed

Thanks Randy!

[PATCH] ide: DMA reporting and validity checking fixes (take 2)

* ide_xfer_verbose() fixups:
  - beautify returned mode names
  - fix PIO5 reporting
  - make it return 'const char *'

* Change printk() level from KERN_DEBUG to KERN_INFO in ide_find_dma_mode().

* Add ide_id_dma_bug() helper based on ide_dma_verbose() to check for invalid
  DMA info in identify block.

* Use ide_id_dma_bug() in ide_tune_dma() and ide_driveid_update().

  As a result DMA won't be tuned or will be disabled after tuning if device
  reports inconsistent info about enabled DMA mode (ide_dma_verbose() does the
  same checks while the IDE device is probed by ide-{cd,disk} device driver).

* Since (id->capability & 1) && id->tDMA is a valid configuration handle
  it correctly in ide_id_dma_bug().

* Remove no longer needed ide_dma_verbose().

This patch should fix the following problem with out-of-sync IDE messages
reported by Nick Warne:

       hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache<7>hdd:
       skipping word 93 validity check
        , UDMA(66)

and later debugged by Mark Lord to be caused by:

        ide_dma_verbose()
                printk( ... "2048kB Cache");
        eighty_ninty_three()
                printk(KERN_DEBUG "%s: skipping word 93 validity check\n");
        ide_dma_verbose()
                printk(", UDMA(66)"

Please note that as a result ide-{cd,disk} device drivers won't report the
DMA speed used but this is intended since now DMA mode being used is always
reported by IDE core code.

v2:
* fixes suggested by Randy:
  - use KERN_CONT for printk()-s in ide-{cd,disk}.c
  - don't remove argument name from ide_xfer_verbose() declaration

Cc: Nick Warne <nick@ukfsn.org>
Cc: Mark Lord <lkml@rtr.ca>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c   |    7 ------
 drivers/ide/ide-disk.c |    7 +-----
 drivers/ide/ide-dma.c  |   57 ++++++++++++-------------------------------------
 drivers/ide/ide-iops.c |    3 ++
 drivers/ide/ide-lib.c  |   55 ++++++++++++++++++++++++-----------------------
 include/linux/ide.h    |    6 ++---
 6 files changed, 52 insertions(+), 83 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -3049,12 +3049,7 @@ int ide_cdrom_probe_capabilities (ide_dr
         else 	
         	printk(" drive");
 
-	printk(", %dkB Cache", be16_to_cpu(cap.buffer_size));
-
-	if (drive->using_dma)
-		ide_dma_verbose(drive);
-
-	printk("\n");
+	printk(KERN_CONT ", %dkB Cache\n", be16_to_cpu(cap.buffer_size));
 
 	return nslots;
 }
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -961,11 +961,8 @@ static void idedisk_setup (ide_drive_t *
 	if (id->buf_size)
 		printk (" w/%dKiB Cache", id->buf_size/2);
 
-	printk(", CHS=%d/%d/%d", 
-	       drive->bios_cyl, drive->bios_head, drive->bios_sect);
-	if (drive->using_dma)
-		ide_dma_verbose(drive);
-	printk("\n");
+	printk(KERN_CONT ", CHS=%d/%d/%d\n",
+			 drive->bios_cyl, drive->bios_head, drive->bios_sect);
 
 	/* write cache enabled? */
 	if ((id->csfo & 1) || (id->cfs_enable_1 & (1 << 5)))
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -753,7 +753,7 @@ u8 ide_find_dma_mode(ide_drive_t *drive,
 			mode = XFER_MW_DMA_1;
 	}
 
-	printk(KERN_DEBUG "%s: %s mode selected\n", drive->name,
+	printk(KERN_INFO "%s: %s mode selected\n", drive->name,
 			  mode ? ide_xfer_verbose(mode) : "no DMA");
 
 	return min(mode, req_mode);
@@ -772,6 +772,9 @@ static int ide_tune_dma(ide_drive_t *dri
 	if (__ide_dma_bad_drive(drive))
 		return 0;
 
+	if (ide_id_dma_bug(drive))
+		return 0;
+
 	if (drive->hwif->host_flags & IDE_HFLAG_TRUST_BIOS_FOR_DMA)
 		return config_drive_for_dma(drive);
 
@@ -806,58 +809,26 @@ static int ide_dma_check(ide_drive_t *dr
 	return vdma ? 0 : -1;
 }
 
-void ide_dma_verbose(ide_drive_t *drive)
+int ide_id_dma_bug(ide_drive_t *drive)
 {
-	struct hd_driveid *id	= drive->id;
-	ide_hwif_t *hwif	= HWIF(drive);
+	struct hd_driveid *id = drive->id;
 
 	if (id->field_valid & 4) {
 		if ((id->dma_ultra >> 8) && (id->dma_mword >> 8))
-			goto bug_dma_off;
-		if (id->dma_ultra & ((id->dma_ultra >> 8) & hwif->ultra_mask)) {
-			if (((id->dma_ultra >> 11) & 0x1F) &&
-			    eighty_ninty_three(drive)) {
-				if ((id->dma_ultra >> 15) & 1) {
-					printk(", UDMA(mode 7)");
-				} else if ((id->dma_ultra >> 14) & 1) {
-					printk(", UDMA(133)");
-				} else if ((id->dma_ultra >> 13) & 1) {
-					printk(", UDMA(100)");
-				} else if ((id->dma_ultra >> 12) & 1) {
-					printk(", UDMA(66)");
-				} else if ((id->dma_ultra >> 11) & 1) {
-					printk(", UDMA(44)");
-				} else
-					goto mode_two;
-			} else {
-		mode_two:
-				if ((id->dma_ultra >> 10) & 1) {
-					printk(", UDMA(33)");
-				} else if ((id->dma_ultra >> 9) & 1) {
-					printk(", UDMA(25)");
-				} else if ((id->dma_ultra >> 8) & 1) {
-					printk(", UDMA(16)");
-				}
-			}
-		} else {
-			printk(", (U)DMA");	/* Can be BIOS-enabled! */
-		}
+			goto err_out;
 	} else if (id->field_valid & 2) {
 		if ((id->dma_mword >> 8) && (id->dma_1word >> 8))
-			goto bug_dma_off;
-		printk(", DMA");
+			goto err_out;
 	} else if (id->field_valid & 1) {
-		goto bug_dma_off;
+		if (id->tDMA == 0)
+			goto err_out;
 	}
-	return;
-bug_dma_off:
-	printk(", BUG DMA OFF");
-	hwif->dma_off_quietly(drive);
-	return;
+	return 0;
+err_out:
+	printk(KERN_ERR "%s: bad DMA info in identify block\n", drive->name);
+	return 1;
 }
 
-EXPORT_SYMBOL(ide_dma_verbose);
-
 int ide_set_dma(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -748,6 +748,9 @@ int ide_driveid_update(ide_drive_t *driv
 		drive->id->dma_1word = id->dma_1word;
 		/* anything more ? */
 		kfree(id);
+
+		if (drive->using_dma && ide_id_dma_bug(drive))
+			ide_dma_off(drive);
 	}
 
 	return 1;
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -29,41 +29,44 @@
  *	Add common non I/O op stuff here. Make sure it has proper
  *	kernel-doc function headers or your patch will be rejected
  */
- 
+
+static const char *udma_str[] =
+	 { "UDMA/16", "UDMA/25",  "UDMA/33",  "UDMA/44",
+	   "UDMA/66", "UDMA/100", "UDMA/133", "UDMA7" };
+static const char *mwdma_str[] =
+	{ "MWDMA0", "MWDMA1", "MWDMA2" };
+static const char *swdma_str[] =
+	{ "SWDMA0", "SWDMA1", "SWDMA2" };
+static const char *pio_str[] =
+	{ "PIO0", "PIO1", "PIO2", "PIO3", "PIO4", "PIO5" };
 
 /**
  *	ide_xfer_verbose	-	return IDE mode names
- *	@xfer_rate: rate to name
+ *	@mode: transfer mode
  *
  *	Returns a constant string giving the name of the mode
  *	requested.
  */
 
-char *ide_xfer_verbose (u8 xfer_rate)
+const char *ide_xfer_verbose(u8 mode)
 {
-        switch(xfer_rate) {
-                case XFER_UDMA_7:	return("UDMA 7");
-                case XFER_UDMA_6:	return("UDMA 6");
-                case XFER_UDMA_5:	return("UDMA 5");
-                case XFER_UDMA_4:	return("UDMA 4");
-                case XFER_UDMA_3:	return("UDMA 3");
-                case XFER_UDMA_2:	return("UDMA 2");
-                case XFER_UDMA_1:	return("UDMA 1");
-                case XFER_UDMA_0:	return("UDMA 0");
-                case XFER_MW_DMA_2:	return("MW DMA 2");
-                case XFER_MW_DMA_1:	return("MW DMA 1");
-                case XFER_MW_DMA_0:	return("MW DMA 0");
-                case XFER_SW_DMA_2:	return("SW DMA 2");
-                case XFER_SW_DMA_1:	return("SW DMA 1");
-                case XFER_SW_DMA_0:	return("SW DMA 0");
-                case XFER_PIO_4:	return("PIO 4");
-                case XFER_PIO_3:	return("PIO 3");
-                case XFER_PIO_2:	return("PIO 2");
-                case XFER_PIO_1:	return("PIO 1");
-                case XFER_PIO_0:	return("PIO 0");
-                case XFER_PIO_SLOW:	return("PIO SLOW");
-                default:		return("XFER ERROR");
-        }
+	const char *s;
+	u8 i = mode & 0xf;
+
+	if (mode >= XFER_UDMA_0 && mode <= XFER_UDMA_7)
+		s = udma_str[i];
+	else if (mode >= XFER_MW_DMA_0 && mode <= XFER_MW_DMA_2)
+		s = mwdma_str[i];
+	else if (mode >= XFER_SW_DMA_0 && mode <= XFER_SW_DMA_2)
+		s = swdma_str[i];
+	else if (mode >= XFER_PIO_0 && mode <= XFER_PIO_5)
+		s = pio_str[i & 0x7];
+	else if (mode == XFER_PIO_SLOW)
+		s = "XFER SLOW";
+	else
+		s = "XFER ERROR";
+
+	return s;
 }
 
 EXPORT_SYMBOL(ide_xfer_verbose);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1255,6 +1255,7 @@ int ide_in_drive_list(struct hd_driveid 
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
 int __ide_dma_bad_drive(ide_drive_t *);
+int ide_id_dma_bug(ide_drive_t *);
 
 u8 ide_find_dma_mode(ide_drive_t *, u8);
 
@@ -1264,7 +1265,6 @@ static inline u8 ide_max_dma_mode(ide_dr
 }
 
 void ide_dma_off(ide_drive_t *);
-void ide_dma_verbose(ide_drive_t *);
 int ide_set_dma(ide_drive_t *);
 ide_startstop_t ide_dma_intr(ide_drive_t *);
 
@@ -1287,6 +1287,7 @@ extern void ide_dma_timeout(ide_drive_t 
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
 #else
+static inline int ide_id_dma_bug(ide_drive_t *drive) { return 0; }
 static inline u8 ide_find_dma_mode(ide_drive_t *drive, u8 speed) { return 0; }
 static inline u8 ide_max_dma_mode(ide_drive_t *drive) { return 0; }
 static inline void ide_dma_off(ide_drive_t *drive) { ; }
@@ -1333,8 +1334,7 @@ static inline void ide_set_hwifdata (ide
 	hwif->hwif_data = data;
 }
 
-/* ide-lib.c */
-extern char *ide_xfer_verbose(u8 xfer_rate);
+const char *ide_xfer_verbose(u8 mode);
 extern void ide_toggle_bounce(ide_drive_t *drive, int on);
 extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);
 


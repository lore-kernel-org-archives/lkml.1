Return-Path: <linux-kernel-owner+w=401wt.eu-S932243AbZHMT7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbZHMT7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbZHMT7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:51 -0400
Received: from kroah.org ([198.145.64.141]:41841 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222AbZHMT7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:31 2009
Message-Id: <20090813195131.225373807@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 45/74] ide: relax DMA info validity checking
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=ide-relax-dma-info-validity-checking.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 346c17a6cf60375323adfaa4b8a9d841049f890e upstream.

There are some broken devices that report multiple DMA xfer modes
enabled at once (ATA spec doesn't allow it) but otherwise work fine
with DMA so just delete ide_id_dma_bug().

[ As discovered by detective work by Frans and Bart, due to how
  handling of the ID block was handled before commit c419993
  ("ide-iops: only clear DMA words on setting DMA mode") this
  check was always seeing zeros in the fields or other similar
  garbage.  Therefore this check wasn't actually checking anything.
  Now that the tests actually check the real bits, all we see are
  devices that trigger the check yet work perfectly fine, therefore
  killing this useless check is the best thing to do. -DaveM ]

Reported-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-dma.c  |   21 ---------------------
 drivers/ide/ide-iops.c |    3 ---
 include/linux/ide.h    |    2 --
 3 files changed, 26 deletions(-)

--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -362,9 +362,6 @@ static int ide_tune_dma(ide_drive_t *dri
 	if (__ide_dma_bad_drive(drive))
 		return 0;
 
-	if (ide_id_dma_bug(drive))
-		return 0;
-
 	if (hwif->host_flags & IDE_HFLAG_TRUST_BIOS_FOR_DMA)
 		return config_drive_for_dma(drive);
 
@@ -395,24 +392,6 @@ static int ide_dma_check(ide_drive_t *dr
 	return -1;
 }
 
-int ide_id_dma_bug(ide_drive_t *drive)
-{
-	u16 *id = drive->id;
-
-	if (id[ATA_ID_FIELD_VALID] & 4) {
-		if ((id[ATA_ID_UDMA_MODES] >> 8) &&
-		    (id[ATA_ID_MWDMA_MODES] >> 8))
-			goto err_out;
-	} else if ((id[ATA_ID_MWDMA_MODES] >> 8) &&
-		   (id[ATA_ID_SWDMA_MODES] >> 8))
-		goto err_out;
-
-	return 0;
-err_out:
-	printk(KERN_ERR "%s: bad DMA info in identify block\n", drive->name);
-	return 1;
-}
-
 int ide_set_dma(ide_drive_t *drive)
 {
 	int rc;
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -306,9 +306,6 @@ int ide_driveid_update(ide_drive_t *driv
 
 	kfree(id);
 
-	if ((drive->dev_flags & IDE_DFLAG_USING_DMA) && ide_id_dma_bug(drive))
-		ide_dma_off(drive);
-
 	return 1;
 out_err:
 	SELECT_MASK(drive, 0);
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1384,7 +1384,6 @@ int ide_in_drive_list(u16 *, const struc
 #ifdef CONFIG_BLK_DEV_IDEDMA
 int ide_dma_good_drive(ide_drive_t *);
 int __ide_dma_bad_drive(ide_drive_t *);
-int ide_id_dma_bug(ide_drive_t *);
 
 u8 ide_find_dma_mode(ide_drive_t *, u8);
 
@@ -1425,7 +1424,6 @@ void ide_dma_lost_irq(ide_drive_t *);
 ide_startstop_t ide_dma_timeout_retry(ide_drive_t *, int);
 
 #else
-static inline int ide_id_dma_bug(ide_drive_t *drive) { return 0; }
 static inline u8 ide_find_dma_mode(ide_drive_t *drive, u8 speed) { return 0; }
 static inline u8 ide_max_dma_mode(ide_drive_t *drive) { return 0; }
 static inline void ide_dma_off_quietly(ide_drive_t *drive) { ; }



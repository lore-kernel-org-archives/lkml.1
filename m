Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYBSOdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYBSOdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbYBSOdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:33:00 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:22048 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbYBSOc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:32:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent:from;
        b=lSPUeo7JwoZe2hRTitfmWe94bKRTrvDsDqRkChHkTqj8qJjH+H5oVWKLys7BevaJOH2mTv5LdJPwhS0ysxHg6J5OwCeWe6bcwh/0mMSq0gR8pbj7dmVAmRJTYAfnszboBJefUTb36JmNduRFCZAUPCHbMkaO5eQvyynXAFID/7k=
Date: Tue, 19 Feb 2008 15:32:47 +0100
To: bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] ide-cd: remove the internal 64k buffer
Message-ID: <20080219143247.GA3980@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here's one more item from my TODO list. The removal is straight forward, after
testing it with all my cdrom drives they all seem even to rotate quieter due to
the automatic speed adjustment of the drive to the continuous data stream
bandwidth in contrast to the buffer-mode in which recurring buffer-fill speedups
caused the drive's read speeed to spike in order to keep the buffer filled up
constantly.

Still, i'd keep this a bit longer in -mm to see whether there are some
other issues with it and with all the different workloads.


commit a855bd5d94ddac678cf90b4b8f20dbd3ac8ea29a
Author: Borislav Petkov <petkovbb@gmail.com>
Date:   Tue Feb 19 14:25:09 2008 +0100

    ide-cd: remove the internal 64k buffer
    
    This removes the internal ide-cd buffer and falls back to read-ahead block layer
    capabilities. Thorough testing (cd burning, dvd read, raw read) gives with the
    bufferless mode marginally better performance in addition to simplified code.
    
    bufferless:
    
    dd: reading `/dev/hdc': Input/output error
    6238+0 records in
    6238+0 records out
    204406784 bytes (204 MB) copied, 259.891 s, 787 kB/s
    
    real    4m21.598s
    user    0m0.014s
    sys     0m0.744s
    
    with the old buffer (2.6.25-rc1):
    
    dd: reading `/dev/hdc': Input/output error
    6238+0 records in
    6238+0 records out
    204406784 bytes (204 MB) copied, 262.893 s, 778 kB/s
    
    real    4m22.938s
    user    0m0.009s
    sys     0m0.771s
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index b21da31..f1cb85c 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -89,7 +89,6 @@ static void cdrom_saw_media_change (ide_drive_t *drive)
 
 	cd->cd_flags |= IDE_CD_FLAG_MEDIA_CHANGED;
 	cd->cd_flags &= ~IDE_CD_FLAG_TOC_VALID;
-	cd->nsectors_buffered = 0;
 }
 
 static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
@@ -626,47 +625,6 @@ static void ide_cd_drain_data(ide_drive_t *drive, int nsects)
 }
 
 /*
- * Buffer up to SECTORS_TO_TRANSFER sectors from the drive in our sector
- * buffer.  Once the first sector is added, any subsequent sectors are
- * assumed to be continuous (until the buffer is cleared).  For the first
- * sector added, SECTOR is its sector number.  (SECTOR is then ignored until
- * the buffer is cleared.)
- */
-static void cdrom_buffer_sectors (ide_drive_t *drive, unsigned long sector,
-                                  int sectors_to_transfer)
-{
-	struct cdrom_info *info = drive->driver_data;
-
-	/* Number of sectors to read into the buffer. */
-	int sectors_to_buffer = min_t(int, sectors_to_transfer,
-				     (SECTOR_BUFFER_SIZE >> SECTOR_BITS) -
-				       info->nsectors_buffered);
-
-	char *dest;
-
-	/* If we couldn't get a buffer, don't try to buffer anything... */
-	if (info->buffer == NULL)
-		sectors_to_buffer = 0;
-
-	/* If this is the first sector in the buffer, remember its number. */
-	if (info->nsectors_buffered == 0)
-		info->sector_buffered = sector;
-
-	/* Read the data into the buffer. */
-	dest = info->buffer + info->nsectors_buffered * SECTOR_SIZE;
-	while (sectors_to_buffer > 0) {
-		HWIF(drive)->atapi_input_bytes(drive, dest, SECTOR_SIZE);
-		--sectors_to_buffer;
-		--sectors_to_transfer;
-		++info->nsectors_buffered;
-		dest += SECTOR_SIZE;
-	}
-
-	/* Throw away any remaining data. */
-	ide_cd_drain_data(drive, sectors_to_transfer);
-}
-
-/*
  * Check the contents of the interrupt reason register from the cdrom
  * and attempt to recover if there are problems.  Returns  0 if everything's
  * ok; nonzero if the request has been terminated.
@@ -731,65 +689,6 @@ static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 	return 1;
 }
 
-/*
- * Try to satisfy some of the current read request from our cached data.
- * Returns nonzero if the request has been completed, zero otherwise.
- */
-static int cdrom_read_from_buffer (ide_drive_t *drive)
-{
-	struct cdrom_info *info = drive->driver_data;
-	struct request *rq = HWGROUP(drive)->rq;
-	unsigned short sectors_per_frame;
-
-	sectors_per_frame = queue_hardsect_size(drive->queue) >> SECTOR_BITS;
-
-	/* Can't do anything if there's no buffer. */
-	if (info->buffer == NULL) return 0;
-
-	/* Loop while this request needs data and the next block is present
-	   in our cache. */
-	while (rq->nr_sectors > 0 &&
-	       rq->sector >= info->sector_buffered &&
-	       rq->sector < info->sector_buffered + info->nsectors_buffered) {
-		if (rq->current_nr_sectors == 0)
-			cdrom_end_request(drive, 1);
-
-		memcpy (rq->buffer,
-			info->buffer +
-			(rq->sector - info->sector_buffered) * SECTOR_SIZE,
-			SECTOR_SIZE);
-		rq->buffer += SECTOR_SIZE;
-		--rq->current_nr_sectors;
-		--rq->nr_sectors;
-		++rq->sector;
-	}
-
-	/* If we've satisfied the current request,
-	   terminate it successfully. */
-	if (rq->nr_sectors == 0) {
-		cdrom_end_request(drive, 1);
-		return -1;
-	}
-
-	/* Move on to the next buffer if needed. */
-	if (rq->current_nr_sectors == 0)
-		cdrom_end_request(drive, 1);
-
-	/* If this condition does not hold, then the kluge i use to
-	   represent the number of sectors to skip at the start of a transfer
-	   will fail.  I think that this will never happen, but let's be
-	   paranoid and check. */
-	if (rq->current_nr_sectors < bio_cur_sectors(rq->bio) &&
-	    (rq->sector & (sectors_per_frame - 1))) {
-		printk(KERN_ERR "%s: cdrom_read_from_buffer: buffer botch (%ld)\n",
-			drive->name, (long)rq->sector);
-		cdrom_end_request(drive, 0);
-		return -1;
-	}
-
-	return 0;
-}
-
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
 
 /*
@@ -1138,11 +1037,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		if (!ptr) {
 			if (blk_fs_request(rq) && !write)
 				/*
-				 * If the buffers are full, cache the rest
-				 * of the data in our internal buffer.
-				 */
-				cdrom_buffer_sectors(drive, rq->sector,
-						     thislen >> 9);
+				 * If the buffers are full, pipe the rest into
+				 * oblivion. */
+				ide_cd_drain_data(drive, thislen >> 9);
 			else {
 				printk(KERN_ERR "%s: confused, missing data\n",
 						drive->name);
@@ -1248,10 +1145,6 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 		 * weirdness which might be present in the request packet.
 		 */
 		restore_request(rq);
-
-		/* Satisfy whatever we can of this request from our cache. */
-		if (cdrom_read_from_buffer(drive))
-			return ide_stopped;
 	}
 
 	/*
@@ -1267,9 +1160,6 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 	} else
 		cd->dma = drive->using_dma;
 
-	/* Clear the local sector buffer. */
-	cd->nsectors_buffered = 0;
-
 	if (write)
 		cd->devinfo.media_written = 1;
 
@@ -2034,7 +1924,6 @@ static void ide_cd_release(struct kref *kref)
 	ide_drive_t *drive = info->drive;
 	struct gendisk *g = info->disk;
 
-	kfree(info->buffer);
 	kfree(info->toc);
 	if (devinfo->handle == drive && unregister_cdrom(devinfo))
 		printk(KERN_ERR "%s: %s failed to unregister device from the cdrom "
@@ -2095,11 +1984,7 @@ static int idecd_open(struct inode * inode, struct file * file)
 	if (!(info = ide_cd_get(disk)))
 		return -ENXIO;
 
-	if (!info->buffer)
-		info->buffer = kmalloc(SECTOR_BUFFER_SIZE, GFP_KERNEL|__GFP_REPEAT);
-
-	if (info->buffer)
-		rc = cdrom_open(&info->devinfo, inode, file);
+	rc = cdrom_open(&info->devinfo, inode, file);
 
 	if (rc < 0)
 		ide_cd_put(info);
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index 22e3751..a58801c 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -119,10 +119,6 @@ struct cdrom_info {
 
 	struct atapi_toc *toc;
 
-	unsigned long	sector_buffered;
-	unsigned long	nsectors_buffered;
-	unsigned char	*buffer;
-
 	/* The result of the last successful request sense command
 	   on this device. */
 	struct request_sense sense_data;
-- 
Regards/Gruß,
    Boris.

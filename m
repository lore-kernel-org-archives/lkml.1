Return-Path: <linux-kernel-owner+w=401wt.eu-S1765665AbYDQLFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765665AbYDQLFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756515AbYDQLE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:04:58 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:57537 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYDQLE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:04:57 -0400
Message-ID: <48072ED7.7030002@tiscali.nl>
Date: Thu, 17 Apr 2008 13:04:55 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: petkovbb@gmail.com
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] IDE: ide-cd: fix test unsigned var < 0
References: <48055F1A.9020706@tiscali.nl>	 <200804170040.07397.bzolnier@gmail.com> <4806C952.6030102@tiscali.nl> <9ea470500804170212md8ce430p42b3c1787ba95631@mail.gmail.com>
In-Reply-To: <9ea470500804170212md8ce430p42b3c1787ba95631@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris Petkov wrote:

> I'd rather keep the "unsigned long bio_sectors;" part and do something
> of the likes of:
> 
> bio_sectors = bio_sectors(failed_command->bio);
> 
> 
> (remove the "if (bio_sectors < 4)"-test)
> 
> ... and later...
> 
> sector &= ~(max(bio_sectors - 1, 3));
> 
> which is, IMO, more readable.
> 
> Roel, would you redo your patch please? Thanks.

While at it I also cleaned up some whitespace
---
Clean up cdrom_analyze_sense_data()

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index a60f5df..df9bf0d 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -133,65 +133,61 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 		default:
 			log = 1;
 			break;
 	}
 	return log;
 }
 
-static
-void cdrom_analyze_sense_data(ide_drive_t *drive,
+static void cdrom_analyze_sense_data(ide_drive_t *drive,
 			      struct request *failed_command,
 			      struct request_sense *sense)
 {
 	unsigned long sector;
 	unsigned long bio_sectors;
-	unsigned long valid;
 	struct cdrom_info *info = drive->driver_data;
 
 	if (!cdrom_log_sense(drive, failed_command, sense))
 		return;
 
 	/*
 	 * If a read toc is executed for a CD-R or CD-RW medium where
 	 * the first toc has not been recorded yet, it will fail with
 	 * 05/24/00 (which is a confusing error)
 	 */
 	if (failed_command && failed_command->cmd[0] == GPCMD_READ_TOC_PMA_ATIP)
 		if (sense->sense_key == 0x05 && sense->asc == 0x24)
 			return;
 
- 	if (sense->error_code == 0x70) {	/* Current Error */
- 		switch(sense->sense_key) {
+	if (sense->error_code == 0x70) {	/* Current Error */
+		switch (sense->sense_key) {
 		case MEDIUM_ERROR:
 		case VOLUME_OVERFLOW:
 		case ILLEGAL_REQUEST:
 			if (!sense->valid)
 				break;
 			if (failed_command == NULL ||
 					!blk_fs_request(failed_command))
 				break;
 			sector = (sense->information[0] << 24) |
 				 (sense->information[1] << 16) |
 				 (sense->information[2] <<  8) |
 				 (sense->information[3]);
 
-			bio_sectors = bio_sectors(failed_command->bio);
-			if (bio_sectors < 4)
-				bio_sectors = 4;
 			if (drive->queue->hardsect_size == 2048)
 				sector <<= 2;	/* Device sector size is 2K */
-			sector &= ~(bio_sectors -1);
-			valid = (sector - failed_command->sector) << 9;
+
+			bio_sectors = bio_sectors(failed_command->bio);
+			sector &= ~(max(bio_sectors - 1, 3));
 
 			if (sector < get_capacity(info->disk) &&
 				drive->probed_capacity - sector < 4 * 75) {
 				set_capacity(info->disk, sector);
 			}
- 		}
- 	}
+		}
+	}
 
 	ide_cd_log_error(drive->name, failed_command, sense);
 }
 
 /*
  * Initialize a ide-cd packet command request
  */

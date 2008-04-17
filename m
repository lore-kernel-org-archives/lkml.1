Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbYDQDwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbYDQDwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 23:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYDQDvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 23:51:50 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:54078 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbYDQDvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 23:51:48 -0400
Message-ID: <4806C952.6030102@tiscali.nl>
Date: Thu, 17 Apr 2008 05:51:46 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 3/6] IDE: ide-cd: fix test unsigned var < 0
References: <48055F1A.9020706@tiscali.nl> <200804170040.07397.bzolnier@gmail.com>
In-Reply-To: <200804170040.07397.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> On Wednesday 16 April 2008, Roel Kluin wrote:
>> Is this the right fix in this case?
> 
> Yes, but it seems that 'valid' is only written to
> so it may be as well removed completely.
> 
> Care to update the patch?
> 
> Thanks,
> Bart

how about this?

Roel

---
Clean up cdrom_analyze_sense_data()

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index a60f5df..a5f3beb 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -143,8 +143,6 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 			      struct request_sense *sense)
 {
 	unsigned long sector;
-	unsigned long bio_sectors;
-	unsigned long valid;
 	struct cdrom_info *info = drive->driver_data;
 
 	if (!cdrom_log_sense(drive, failed_command, sense))
@@ -174,13 +172,9 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 				 (sense->information[2] <<  8) |
 				 (sense->information[3]);
 
-			bio_sectors = bio_sectors(failed_command->bio);
-			if (bio_sectors < 4)
-				bio_sectors = 4;
 			if (drive->queue->hardsect_size == 2048)
 				sector <<= 2;	/* Device sector size is 2K */
-			sector &= ~(bio_sectors -1);
-			valid = (sector - failed_command->sector) << 9;
+			sector &= ~(max(bio_sectors(failed_command->bio) - 1, 3));
 
 			if (sector < get_capacity(info->disk) &&
 				drive->probed_capacity - sector < 4 * 75) {


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbYHOHeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbYHOHeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 03:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYHOHeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 03:34:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:47715 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYHOHeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 03:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=GCwL7LDev/GP9g2wd4nXGvOOb6enkk5SqJPuUIZ476wj1gaJiBH8u30eNwcOZlkqcr
         +en3ZzHQ4SEeTQWCXcGkg/yiBxR83ndlHqMTpyxSJjLypJu45JkmxvJO2ttyGwALM6g5
         PV+uhGCmlMWYCw3hEkAv+3IJ5elfUhMbkt64k=
Date: Fri, 15 Aug 2008 09:34:13 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 03/18] ide-cd: cdrom_decode_status: factor out block pc
	error handling code
Message-ID: <20080815073413.GA9906@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com> <1213252870-20474-4-git-send-email-petkovbb@gmail.com> <200806141929.21329.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806141929.21329.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 07:29:21PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 12 June 2008, Borislav Petkov wrote:
> > ... into cdrom_handle_failed_pc_req().
> 
> I actually think that we should try to unite pc/fs error handling as much
> as possible as it shouldn't really matter if i.e. READ command came through
> fs or pc request - the error handling w.r.t. hardware should be the same
> (at the moment it is not always the case - the most blatant example of this
> disrepancy is handling of NOT_READY sense key for WRITE commands).
> 
> When I was suggesting factoring out error handling I rather meant moving
> out _everything_ after OK_STAT() (sorry for the confusion).  On the second
> thought we may do it in even simpler way by moving:
> 
> ...
> 	/* check for errors */
> 	stat = ide_read_status(drive);
> 
> 	if (stat_ret)
> 		*stat_ret = stat;
> 
> 	if (OK_STAT(stat, good_stat, BAD_R_STAT))
> 		return 0;
> ...
> 
> to cdrom_decode_status() users and passing as an argument 'stat' instead
> of 'good_stat' and 'stat_ret'.
> 
> Therefore I skipped this patch (and also patch #4) for now.

Hi Bart,

here's a first attempt at that. These are only RFC of nature, please take a look
when there's time. They've been lightly tested but I'll do more later since this
path is not hit that often and a special test case will be required.

---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sun, 10 Aug 2008 18:54:03 +0200
Subject: [PATCH 1/2] ide-cd: move error handling outside of cdrom_decode_status()

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index f675cee..f2c12be 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -284,20 +284,11 @@ static void ide_dump_status_no_sense(ide_drive_t *drive, const char *msg, u8 st)
  * 0: if the request should be continued.
  * 1: if the request was ended.
  */
-static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
+static int cdrom_decode_status(ide_drive_t *drive, int stat)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->hwgroup->rq;
-	int stat, err, sense_key;
-
-	/* check for errors */
-	stat = hwif->tp_ops->read_status(hwif);
-
-	if (stat_ret)
-		*stat_ret = stat;
-
-	if (OK_STAT(stat, good_stat, BAD_R_STAT))
-		return 0;
+	int err, sense_key;
 
 	/* get the IDE error register */
 	err = ide_read_error(drive);
@@ -563,7 +554,7 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 					  ide_handler_t *handler)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	int cmd_len;
+	int cmd_len, stat;
 	struct cdrom_info *info = drive->driver_data;
 	ide_startstop_t startstop;
 
@@ -574,8 +565,11 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 		 */
 
 		/* check for errors */
-		if (cdrom_decode_status(drive, ATA_DRQ, NULL))
-			return ide_stopped;
+		stat = hwif->tp_ops->read_status(hwif);
+
+		if (!OK_STAT(stat, ATA_DRQ, BAD_R_STAT))
+			if (cdrom_decode_status(drive, stat))
+				return ide_stopped;
 
 		/* ok, next interrupt will be DMA interrupt */
 		if (info->dma)
@@ -739,8 +733,11 @@ static ide_startstop_t cdrom_seek_intr(ide_drive_t *drive)
 	int stat;
 	static int retry = 10;
 
-	if (cdrom_decode_status(drive, 0, &stat))
-		return ide_stopped;
+	stat = drive->hwif->tp_ops->read_status(drive->hwif);
+
+	if (!OK_STAT(stat, 0, BAD_R_STAT))
+		if (cdrom_decode_status(drive, stat))
+			return ide_stopped;
 
 	drive->atapi_flags |= IDE_AFLAG_SEEKING;
 
@@ -917,8 +914,11 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		}
 	}
 
-	if (cdrom_decode_status(drive, 0, &stat))
-		return ide_stopped;
+	stat = hwif->tp_ops->read_status(hwif);
+
+	if (!OK_STAT(stat, 0, BAD_R_STAT))
+		if (cdrom_decode_status(drive, stat))
+			return ide_stopped;
 
 	/* using dma, transfer is complete now */
 	if (dma) {
-- 
1.5.5.4


-- 
Regards/Gruss,
    Boris.

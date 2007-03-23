Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbXCWXrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbXCWXrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 19:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbXCWXrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 19:47:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:22740 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbXCWXre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 19:47:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nd1s3jkRmoTssP82WSnodY95SBTIu2I4xRVDT2nCYo7uwlZsvi+yfDDdQhTsJEs70vdtFUT+fZTsXgb0qGMJCeBNz0odxvB5GGxCVmZb3rGHH/EHMjobMhaqlVqry4Sk+7J4eU1LnnNazMJGZTEPfrp/XsQ9lyRcuDbKTpcuS1A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Suleiman Souhlal <ssouhlal@freebsd.org>
Subject: Re: [PATCH 3/3] Use correct IDE error recovery
Date: Sat, 24 Mar 2007 00:53:42 +0100
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>
References: <20070221012304.GC1777@freefall.freebsd.org> <200703072216.08295.bzolnier@gmail.com> <B2D4536E-D449-4D10-B745-30D25CAC40A4@freebsd.org>
In-Reply-To: <B2D4536E-D449-4D10-B745-30D25CAC40A4@freebsd.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703240053.42845.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 08 March 2007, Suleiman Souhlal wrote:
> 
> On Mar 7, 2007, at 1:16 PM, Bartlomiej Zolnierkiewicz wrote:

> > Please respin the patch so I could merge it.
> 
> Ok.

Since I think that it's worth to have it in 2.6.21-final and respin didn't
happen I did the required changes myself (it also turned out that I missed
few things during initial review), then applied the patch...

Please let my know whether you are fine with my changes, thanks.

[PATCH] ide: use correct IDE error recovery

From: Suleiman Souhlal <suleiman@google.com>

IDE error recovery is using IDLE IMMEDIATE if the drive is busy or has DRQ set.
This violates the ATA spec (can only send IDLE IMMEDIATE when drive is not
busy) and really hoses up some drives (modern drives will not be able to
recover using this error handling).  The correct thing to do is issue a SRST
followed by a SET FEATURES command.  This is what Western Digital recommends
for error recovery and what Western Digital says Windows does.  It also does
not violate the ATA spec as far as I can tell.

Bart:
* port the patch over the current tree
* undo the recalibration code removal
* send SET FEATURES command after checking for good drive status
* don't check whether the current request is of REQ_TYPE_ATA_{CMD,TASK}
  type because we need to send SET FEATURES before handling any requests
* some pre-ATA4 drives require INITIALIZE DEVICE PARAMETERS command before
  other commands (except IDENTIFY) so send SET FEATURES only if there are
  no pending drive->special requests
* update comments and patch description
* any bugs introduced by this patch are mine and not Suleiman's :-)

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---

 drivers/ide/ide-io.c   |   32 +++++++++++++++++++++-----------
 drivers/ide/ide-iops.c |    3 +++
 include/linux/ide.h    |    1 +
 3 files changed, 25 insertions(+), 11 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -519,21 +519,24 @@ static ide_startstop_t ide_ata_error(ide
 	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ && hwif->err_stops_fifo == 0)
 		try_to_flush_leftover_data(drive);
 
+	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq)) {
+		ide_kill_rq(drive, rq);
+		return ide_stopped;
+	}
+
 	if (hwif->INB(IDE_STATUS_REG) & (BUSY_STAT|DRQ_STAT))
-		/* force an abort */
-		hwif->OUTB(WIN_IDLEIMMEDIATE, IDE_COMMAND_REG);
+		rq->errors |= ERROR_RESET;
 
-	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq))
-		ide_kill_rq(drive, rq);
-	else {
-		if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
-			++rq->errors;
-			return ide_do_reset(drive);
-		}
-		if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)
-			drive->special.b.recalibrate = 1;
+	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
 		++rq->errors;
+		return ide_do_reset(drive);
 	}
+
+	if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)
+		drive->special.b.recalibrate = 1;
+
+	++rq->errors;
+
 	return ide_stopped;
 }
 
@@ -1025,6 +1028,13 @@ static ide_startstop_t start_request (id
 	if (!drive->special.all) {
 		ide_driver_t *drv;
 
+		/*
+		 * We reset the drive so we need to issue a SETFEATURES.
+		 * Do it _after_ do_special() restored device parameters.
+		 */
+		if (drive->current_speed == 0xff)
+			ide_config_drive_speed(drive, drive->desired_speed);
+
 		if (rq->cmd_type == REQ_TYPE_ATA_CMD ||
 		    rq->cmd_type == REQ_TYPE_ATA_TASK ||
 		    rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1094,6 +1094,9 @@ static void pre_reset(ide_drive_t *drive
 	if (HWIF(drive)->pre_reset != NULL)
 		HWIF(drive)->pre_reset(drive);
 
+	if (drive->current_speed != 0xff)
+		drive->desired_speed = drive->current_speed;
+	drive->current_speed = 0xff;
 }
 
 /*
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -615,6 +615,7 @@ typedef struct ide_drive_s {
         u8	init_speed;	/* transfer rate set at boot */
         u8	pio_speed;      /* unused by core, used by some drivers for fallback from DMA */
         u8	current_speed;	/* current transfer rate set */
+	u8	desired_speed;	/* desired transfer rate set */
         u8	dn;		/* now wide spread use */
         u8	wcache;		/* status of write cache */
 	u8	acoustic;	/* acoustic management */

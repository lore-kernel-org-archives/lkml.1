Return-Path: <linux-kernel-owner+w=401wt.eu-S1161371AbXDKXCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161371AbXDKXCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161362AbXDKXBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:01:42 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55708 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161337AbXDKWzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:55:08 -0400
Date: Wed, 11 Apr 2007 15:52:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Suleiman Souhlal <suleiman@google.com>,
       Alan Cox <alan@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 21/31] ide: use correct IDE error recovery
Message-ID: <20070411225229.GV24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="ide-use-correct-ide-error-recovery.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Suleiman Souhlal <suleiman@google.com>

ide: use correct IDE error recovery

IDE error recovery is using IDLE IMMEDIATE if the drive is busy or has DRQ set.
This violates the ATA spec (can only send IDLEÂ IMMEDIATE when drive is not
busy) and really hoses up some drives (modern drives will not be able to
recover using this error handling).  The correct thing to do is issue a SRST
followed by a SET FEATURES command.  This is what Western Digital recommends
for error recovery and what Western Digital says Windows does. Â ItÂ also does
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
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

---
 drivers/ide/ide-io.c   |   32 +++++++++++++++++++++-----------
 drivers/ide/ide-iops.c |    3 +++
 include/linux/ide.h    |    1 +
 3 files changed, 25 insertions(+), 11 deletions(-)

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
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1123,6 +1123,9 @@ static void pre_reset(ide_drive_t *drive
 	if (HWIF(drive)->pre_reset != NULL)
 		HWIF(drive)->pre_reset(drive);
 
+	if (drive->current_speed != 0xff)
+		drive->desired_speed = drive->current_speed;
+	drive->current_speed = 0xff;
 }
 
 /*
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -607,6 +607,7 @@ typedef struct ide_drive_s {
         u8	init_speed;	/* transfer rate set at boot */
         u8	pio_speed;      /* unused by core, used by some drivers for fallback from DMA */
         u8	current_speed;	/* current transfer rate set */
+	u8	desired_speed;	/* desired transfer rate set */
         u8	dn;		/* now wide spread use */
         u8	wcache;		/* status of write cache */
 	u8	acoustic;	/* acoustic management */

-- 

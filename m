Return-Path: <linux-kernel-owner+w=401wt.eu-S1161832AbXDYHsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161832AbXDYHsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 03:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161837AbXDYHsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 03:48:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161832AbXDYHsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 03:48:30 -0400
Date: Wed, 25 Apr 2007 00:48:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Heimbigner <icxcnika@mar.tar.cc>
Cc: linux-kernel@vger.kernel.org, Peter Osterlund <petero2@telia.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG: Null pointer dereference in fs/open.c
Message-Id: <20070425004816.bd0c240a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704240527030.25153@server.thyself>
References: <Pine.LNX.4.64.0704222310030.25153@server.thyself>
	<20070423010032.c89e8d32.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704231356480.25153@server.thyself>
	<Pine.LNX.4.64.0704231633210.25153@server.thyself>
	<Pine.LNX.4.64.0704240347470.25153@server.thyself>
	<20070423215810.5a24ed9a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704240507110.25153@server.thyself>
	<20070423221726.ccfa982c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704240527030.25153@server.thyself>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 05:44:42 +0000 (GMT) William Heimbigner <icxcnika@mar.tar.cc> wrote:

> On Mon, 23 Apr 2007, Andrew Morton wrote:
> > On Tue, 24 Apr 2007 05:10:04 +0000 (GMT) William Heimbigner <icxcnika@mar.tar.cc> wrote:
> >
> >>> --- a/drivers/block/pktcdvd.c~packet-fix-error-handling
> >>> +++ a/drivers/block/pktcdvd.c
> >>> @@ -777,7 +777,8 @@ static int pkt_generic_packet(struct pkt
> >>> 		rq->cmd_flags |= REQ_QUIET;
> >>>
> >>> 	blk_execute_rq(rq->q, pd->bdev->bd_disk, rq, 0);
> >>> -	ret = rq->errors;
> >>> +	if (rq->errors)
> >>> +		ret = -EIO;
> >>> out:
> >>> 	blk_put_request(rq);
> >>> 	return ret;
> >>> _
> >>
> >> This patch fixes (or conceals?) the oops.
> >>
> >
> > Fixes.  But does the packet driver actually work OK for you?  Writes
> > files and stuff like that?
> >
> Short answer, no.
> 
> Long answer:
> # pktsetup 0 /dev/hdc
> 
> ...
>
> # mkudffs /dev/pktcdvd/0
> [11539.953560] pktcdvd: pkt_get_last_written failed
> trying to change type of multiple extents
> 
> I get the same error with /dev/hdd as well (hdc and hdd are both dvd 
> burners, hdd has a cd-rw and hdc had a dvd-rw)
> 

OK.  I am able to use the pktcdvd driver OK in mainline with a piix/sata
drive.  It could be that something is going wrong at the IDE level for you.

Are you able to identify the most recent kernel which actually worked?

Here's the bugfix which we already worked out:

--- a/drivers/block/pktcdvd.c~packet-fix-error-handling
+++ a/drivers/block/pktcdvd.c
@@ -777,7 +777,8 @@ static int pkt_generic_packet(struct pkt
 		rq->cmd_flags |= REQ_QUIET;
 
 	blk_execute_rq(rq->q, pd->bdev->bd_disk, rq, 0);
-	ret = rq->errors;
+	if (rq->errors)
+		ret = -EIO;
 out:
 	blk_put_request(rq);
 	return ret;
_


And here's a debug patch which will hopefully tell us where we're detecting
an error.  Please apply both patches to 2.6.21-rc7 and retest?

Also, please send the full boot-time dmesg output.



 drivers/ide/ide-cd.c    |    6 +++++-
 drivers/ide/ide-io.c    |   24 +++++++++++++++++++-----
 drivers/scsi/scsi_lib.c |    2 ++
 include/linux/kernel.h  |    9 +++++++++
 4 files changed, 35 insertions(+), 6 deletions(-)

diff -puN drivers/ide/ide-cd.c~block-debug drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~block-debug
+++ a/drivers/ide/ide-cd.c
@@ -724,8 +724,10 @@ static int cdrom_decode_status(ide_drive
 		 * if we have an error, pass back CHECK_CONDITION as the
 		 * scsi status byte
 		 */
-		if (blk_pc_request(rq) && !rq->errors)
+		if (blk_pc_request(rq) && !rq->errors) {
 			rq->errors = SAM_STAT_CHECK_CONDITION;
+			MMMMM(rq->errors);
+		}
 
 		/* Check for tray open. */
 		if (sense_key == NOT_READY) {
@@ -791,6 +793,7 @@ static int cdrom_decode_status(ide_drive
 				if (!rq->errors)
 					info->write_timeout = jiffies + ATAPI_WAIT_WRITE_BUSY;
 				rq->errors = 1;
+				MMMMM(rq->errors);
 				if (time_after(jiffies, info->write_timeout))
 					do_end_request = 1;
 				else {
@@ -3127,6 +3130,7 @@ static int ide_cdrom_prep_pc(struct requ
 	 */
 	if (c[0] == MODE_SENSE || c[0] == MODE_SELECT) {
 		rq->errors = ILLEGAL_REQUEST;
+		MMMMM(rq->errors);
 		return BLKPREP_KILL;
 	}
 	
diff -puN drivers/ide/ide-io.c~block-debug drivers/ide/ide-io.c
--- a/drivers/ide/ide-io.c~block-debug
+++ a/drivers/ide/ide-io.c
@@ -66,8 +66,10 @@ static int __ide_end_request(ide_drive_t
 	if (blk_noretry_request(rq) && end_io_error(uptodate))
 		nr_sectors = rq->hard_nr_sectors;
 
-	if (!blk_fs_request(rq) && end_io_error(uptodate) && !rq->errors)
+	if (!blk_fs_request(rq) && end_io_error(uptodate) && !rq->errors) {
 		rq->errors = -EIO;
+		MMMMM(rq->errors);
+	}
 
 	/*
 	 * decide whether to reenable DMA -- 3 is a random magic for now,
@@ -265,8 +267,10 @@ int ide_end_dequeued_request(ide_drive_t
 	if (blk_noretry_request(rq) && end_io_error(uptodate))
 		nr_sectors = rq->hard_nr_sectors;
 
-	if (!blk_fs_request(rq) && end_io_error(uptodate) && !rq->errors)
+	if (!blk_fs_request(rq) && end_io_error(uptodate) && !rq->errors) {
 		rq->errors = -EIO;
+		MMMMM(rq->errors);
+	}
 
 	/*
 	 * decide whether to reenable DMA -- 3 is a random magic for now,
@@ -380,8 +384,10 @@ void ide_end_drive_cmd (ide_drive_t *dri
 
 	if (rq->cmd_type == REQ_TYPE_ATA_CMD) {
 		u8 *args = (u8 *) rq->buffer;
-		if (rq->errors == 0)
+		if (rq->errors == 0) {
 			rq->errors = !OK_STAT(stat,READY_STAT,BAD_STAT);
+			MMMMM(rq->errors);
+		}
 
 		if (args) {
 			args[0] = stat;
@@ -390,8 +396,10 @@ void ide_end_drive_cmd (ide_drive_t *dri
 		}
 	} else if (rq->cmd_type == REQ_TYPE_ATA_TASK) {
 		u8 *args = (u8 *) rq->buffer;
-		if (rq->errors == 0)
+		if (rq->errors == 0) {
 			rq->errors = !OK_STAT(stat,READY_STAT,BAD_STAT);
+			MMMMM(rq->errors);
+		}
 
 		if (args) {
 			args[0] = stat;
@@ -404,8 +412,10 @@ void ide_end_drive_cmd (ide_drive_t *dri
 		}
 	} else if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *args = (ide_task_t *) rq->special;
-		if (rq->errors == 0)
+		if (rq->errors == 0) {
 			rq->errors = !OK_STAT(stat,READY_STAT,BAD_STAT);
+			MMMMM(rq->errors);
+		}
 			
 		if (args) {
 			if (args->tf_in_flags.b.data) {
@@ -448,6 +458,7 @@ void ide_end_drive_cmd (ide_drive_t *dri
 	blkdev_dequeue_request(rq);
 	HWGROUP(drive)->rq = NULL;
 	rq->errors = err;
+	MMMMM(rq->errors);
 	end_that_request_last(rq, !rq->errors);
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
@@ -510,6 +521,7 @@ static ide_startstop_t ide_ata_error(ide
 		} else if (err & (BBD_ERR | ECC_ERR)) {
 			/* retries won't help these */
 			rq->errors = ERROR_MAX;
+			MMMMM(rq->errors);
 		} else if (err & TRK0_ERR) {
 			/* help it find track zero */
 			rq->errors |= ERROR_RECAL;
@@ -604,6 +616,7 @@ ide_startstop_t ide_error (ide_drive_t *
 	/* retry only "normal" I/O: */
 	if (!blk_fs_request(rq)) {
 		rq->errors = 1;
+		MMMMM(rq->errors);
 		ide_end_drive_cmd(drive, stat, err);
 		return ide_stopped;
 	}
@@ -655,6 +668,7 @@ ide_startstop_t ide_abort(ide_drive_t *d
 	/* retry only "normal" I/O: */
 	if (!blk_fs_request(rq)) {
 		rq->errors = 1;
+		MMMMM(rq->errors);
 		ide_end_drive_cmd(drive, BUSY_STAT, 0);
 		return ide_stopped;
 	}
diff -puN drivers/scsi/scsi_lib.c~block-debug drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~block-debug
+++ a/drivers/scsi/scsi_lib.c
@@ -835,6 +835,7 @@ void scsi_io_completion(struct scsi_cmnd
 
 	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
 		req->errors = result;
+		MMMMM(req->errors);
 		if (result) {
 			clear_errors = 0;
 			if (sense_valid && req->sense) {
@@ -1252,6 +1253,7 @@ static int scsi_prep_fn(struct request_q
 	switch (ret) {
 	case BLKPREP_KILL:
 		req->errors = DID_NO_CONNECT << 16;
+		MMMMM(req->errors);
 		break;
 	case BLKPREP_DEFER:
 		/*
diff -puN include/linux/kernel.h~block-debug include/linux/kernel.h
--- a/include/linux/kernel.h~block-debug
+++ a/include/linux/kernel.h
@@ -20,6 +20,15 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
+#define MMMMM(n)							\
+	do {								\
+		if (n) {						\
+			printk("%s:%d: setting error to %d\n",		\
+				__FILE__, __LINE__, (int)n);		\
+			dump_stack();					\
+		}							\
+	} while (0)
+
 #define INT_MAX		((int)(~0U>>1))
 #define INT_MIN		(-INT_MAX - 1)
 #define UINT_MAX	(~0U)
_


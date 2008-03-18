Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbYCSTgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbYCSTgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbYCST1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:27:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785AbYCST1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:27:33 -0400
Date: Tue, 18 Mar 2008 08:41:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anders Eriksson <aeriksson@fastmail.fm>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-Reply-To: <20080318133259.E71EE2DC044@tippex.mynet.homeunix.org>
Message-ID: <alpine.LFD.1.00.0803180751200.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <alpine.LFD.1.00.0803171548480.3020@woody.linux-foundation.org> <20080318001831.575D093C911@tippex.mynet.homeunix.org> <200803181403.37969.bzolnier@gmail.com>
 <20080318133259.E71EE2DC044@tippex.mynet.homeunix.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Mar 2008, Anders Eriksson wrote:
> 
> Mar 18 14:18:26 tippex do_rw_taskfile(task->data_phase=1, tf->command=236
> Mar 18 14:18:26 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
> Mar 18 14:18:26 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
> Mar 18 14:18:26 tippex task_in_intr: hda: stat=50

Uhhuh. That's READY_STAT | SRV_STAT. No error, no DRQ, no nothing.

And I think this also explains why your bisect found that old commit
4d977e43d8ae758434e603cf2455d955f71c77c4 to be problematic.

The thing is, that commit - and the taskfile code that it then all got 
replaced with - use this totally bogus check:

	OK_STAT(stat, DRQ_STAT, BAD_R_STAT)
		...

which basically says that the only OK situation is that no error bits are 
set, and DRQ _has_ to be set.

Before that, the code did the right thing in any _combination_ of bits: if 
DRQ wasn't set, it would just say "oh, ok, the command is done", but the 
taskfile code and the 4d977e43d commit code thinks that DRQ not being set 
is an error, and then it gets confused when the actual error bits aren't 
set!

I think that whole way of writing code is totally horribly bad! It's not 
only trying to tie together bits that are independent, but it actually 
gets a lot harder to understand too, because now you have *four* different 
cases ("no error, no drq", "error, no drq", "no error, drq", "error, drq") 
but you use one test to try to find the one you expect, and then the code 
easily messes up on all the other three cases!

I personally think the code should be written more like the suggested 
appended patch, which checks those error and drq bits _separately_, and 
doesn't try to mix them up, because they really are independent.

Anders, does this patch change any behaviour?

It basically does:

 - if the error bits are set, we just error out (and expect ide_error() to 
   flush the data fifo if necessary)

 - if the DRQ bit is *not* set, something unexpected happened, and we go 
   out of line to handle that.

 - otherwise we just do the data in phase and see if we're all done.

Then, in the unexpected case, we try to see what is actually going on, and 
that's where we do the same thing we always used to do (ie the thing that 
commit 4d977e43d messed up): if the drive tells us it's all done, we just 
end the command.

IOW, if we have no errors, no drq, and the drive says "ready and not 
busy", we just finish the command!

I think this is much more readable, and also less fragile, than using that 
OK_STAT() macro to mix up DRQ and errors in odd ways. Keep them separate 
events.

			Linus

---
 drivers/ide/ide-taskfile.c |   36 +++++++++++++++++++++++++++---------
 1 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 0518a2e..4c86a8d 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -423,6 +423,25 @@ void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 }
 
 /*
+ * We got an interrupt on a task_in case, but no errors and no DRQ.
+ *
+ * It might be a spurious irq (shared irq), but it might be a
+ * command that had no output.
+ */
+static ide_startstop_t task_in_unexpected(ide_drive_t *drive, struct request *rq, u8 stat)
+{
+	/* Command all done? */
+	if (OK_STAT(stat, READY_STAT, BUSY_STAT)) {
+		task_end_request(drive, rq, stat);
+		return ide_stopped;
+	}
+
+	/* Assume it was a spurious irq */
+	ide_set_handler(drive, &task_in_intr, WAIT_WORSTCASE, NULL);
+	return ide_started;
+}
+
+/*
  * Handler for command with PIO data-in phase (Read/Read Multiple).
  */
 static ide_startstop_t task_in_intr(ide_drive_t *drive)
@@ -431,18 +450,17 @@ static ide_startstop_t task_in_intr(ide_drive_t *drive)
 	struct request *rq = HWGROUP(drive)->rq;
 	u8 stat = ide_read_status(drive);
 
-	/* new way for dealing with premature shared PCI interrupts */
-	if (!OK_STAT(stat, DRQ_STAT, BAD_R_STAT)) {
-		if (stat & (ERR_STAT | DRQ_STAT))
-			return task_error(drive, rq, __FUNCTION__, stat);
-		/* No data yet, so wait for another IRQ. */
-		ide_set_handler(drive, &task_in_intr, WAIT_WORSTCASE, NULL);
-		return ide_started;
-	}
+	/* Error? */
+	if (stat & ERR_STAT)
+		return task_error(drive, rq, __FUNCTION__, stat);
+
+	/* No error, but didn't want any data either? Odd. */
+	if (!(stat & DRQ_STAT))
+		return task_in_unexpected(drive, rq, stat);
 
 	ide_pio_datablock(drive, rq, 0);
 
-	/* If it was the last datablock check status and finish transfer. */
+	/* Are we done? Check status and finish transfer. */
 	if (!hwif->nleft) {
 		stat = wait_drive_not_busy(drive);
 		if (!OK_STAT(stat, 0, BAD_STAT))

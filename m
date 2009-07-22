Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbZGVF5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbZGVF5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbZGVF5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:57:06 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:46570 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbZGVF5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=x0YONmMzB0g5MM/JVO9coPY/51Mtv3GX0ohUs0Jq+I5yaobe/vf04e6yxBpnXOln3e
         N6qULYRa2kVmq0BWGFkInSX4wS2/GV8mSgk1xepq+eQ55J2Exc59yFnw9XHWwMV3ZpMj
         e3dNv/6jJOXvTuYMWKfbuvbQp4b+jdugYdDR0=
Date: Wed, 22 Jul 2009 07:56:57 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ide-tape: fix handling of postponed rqs
Message-ID: <20090722055657.GA15465@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	David Miller <davem@davemloft.net>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1247910917-5237-1-git-send-email-petkovbb@gmail.com>
 <1247910917-5237-4-git-send-email-petkovbb@gmail.com>
 <20090721.204704.123531717.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090721.204704.123531717.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 08:47:04PM -0700, David Miller wrote:

> drivers/ide/ide-tape.c: In function ‘ide_tape_stall_queue’:
> drivers/ide/ide-tape.c:379: warning: unused variable ‘rq’

Sorry about that, rq is used only in the debug statement and I forgot to
do a non-debug build, my bad.

--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Wed, 22 Jul 2009 07:38:29 +0200
Subject: [PATCH 3/3] ide-tape: fix handling of postponed rqs

ide-tape used to hit

[   58.614854] ide-tape: ht0: BUG: Two DSC requests queued!

due to the fact that another rq was being issued while the driver was
waiting for DSC to get set for the device executing ATAPI commands which
set the DSC to 1 to indicate completion.

Here's a sample output of that case:

issue REZERO_UNIT

[  143.088505] ide-tape: ide_tape_issue_pc: retry #0, cmd: 0x01
[  143.095122] ide: Enter ide_pc_intr - interrupt handler
[  143.096118] ide: Packet command completed, 0 bytes transferred
[  143.106319] ide-tape: ide_tape_callback: cmd: 0x1, dsc: 1, err: 0
[  143.112601] ide-tape: idetape_postpone_request: cmd: 0x1, dsc_poll_freq: 2000

we stall the ide-tape queue here waiting for DSC

[  143.119936] ide-tape: ide_tape_read_position: enter
[  145.119019] ide-tape: idetape_do_request: sector: 4294967295, nr_sectors: 0

and issue the new READ_POSITION rq and hit the check.

[  145.126247] ide-tape: ht0: BUG: Two DSC requests queued!
[  145.131748] ide-tape: ide_tape_read_position: BOP - No
[  145.137059] ide-tape: ide_tape_read_position: EOP - No

Also, ->postponed_rq used to point to that postponed request. To make
things worse, in certain circumstances the rq it was pointing to got
replaced unterneath it by swiftly reusing the same rq from the mempool
of the block layer practically confusing stuff even more.

However, we don't need to keep a pointer to that rq but simply wait for
DSC to be set first before issuing the follow-up request in the drive's
queue. In order to do that, we make idetape_do_request() first check the
DSC and if not set, we stall the drive queue giving the other device on
that IDE channel a chance.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   33 +++++++++++----------------------
 1 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 08f09f5..96c93b0 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -155,7 +155,8 @@ typedef struct ide_tape_obj {
 	 * other device. Note that at most we will have only one DSC (usually
 	 * data transfer) request in the device request queue.
 	 */
-	struct request *postponed_rq;
+	bool postponed_rq;
+
 	/* The time in which we started polling for DSC */
 	unsigned long dsc_polling_start;
 	/* Timer used to poll for dsc */
@@ -372,15 +373,14 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
  * Postpone the current request so that ide.c will be able to service requests
  * from another device on the same port while we are polling for DSC.
  */
-static void idetape_postpone_request(ide_drive_t *drive)
+static void ide_tape_stall_queue(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	struct request *rq = drive->hwif->rq;
 
 	ide_debug_log(IDE_DBG_FUNC, "cmd: 0x%x, dsc_poll_freq: %lu",
-		      rq->cmd[0], tape->dsc_poll_freq);
+		      drive->hwif->rq->cmd[0], tape->dsc_poll_freq);
 
-	tape->postponed_rq = rq;
+	tape->postponed_rq = true;
 
 	ide_stall_queue(drive, tape->dsc_poll_freq);
 }
@@ -394,7 +394,7 @@ static void ide_tape_handle_dsc(ide_drive_t *drive)
 	tape->dsc_poll_freq = IDETAPE_DSC_MA_FAST;
 	tape->dsc_timeout = jiffies + IDETAPE_DSC_MA_TIMEOUT;
 	/* Allow ide.c to handle other requests */
-	idetape_postpone_request(drive);
+	ide_tape_stall_queue(drive);
 }
 
 /*
@@ -567,7 +567,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = NULL;
-	struct request *postponed_rq = tape->postponed_rq;
 	struct ide_cmd cmd;
 	u8 stat;
 
@@ -583,18 +582,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		goto out;
 	}
 
-	if (postponed_rq != NULL)
-		if (rq != postponed_rq) {
-			printk(KERN_ERR "ide-tape: ide-tape.c bug - "
-					"Two DSC requests were queued\n");
-			drive->failed_pc = NULL;
-			rq->errors = 0;
-			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
-			return ide_stopped;
-		}
-
-	tape->postponed_rq = NULL;
-
 	/*
 	 * If the tape is still busy, postpone our request and service
 	 * the other device meanwhile.
@@ -612,7 +599,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 
 	if (!(drive->atapi_flags & IDE_AFLAG_IGNORE_DSC) &&
 	    !(stat & ATA_DSC)) {
-		if (postponed_rq == NULL) {
+		if (!tape->postponed_rq) {
 			tape->dsc_polling_start = jiffies;
 			tape->dsc_poll_freq = tape->best_dsc_rw_freq;
 			tape->dsc_timeout = jiffies + IDETAPE_DSC_RW_TIMEOUT;
@@ -629,10 +616,12 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 					tape->dsc_polling_start +
 					IDETAPE_DSC_MA_THRESHOLD))
 			tape->dsc_poll_freq = IDETAPE_DSC_MA_SLOW;
-		idetape_postpone_request(drive);
+		ide_tape_stall_queue(drive);
 		return ide_stopped;
-	} else
+	} else {
 		drive->atapi_flags &= ~IDE_AFLAG_IGNORE_DSC;
+		tape->postponed_rq = false;
+	}
 
 	if (rq->cmd[13] & REQ_IDETAPE_READ) {
 		pc = &tape->queued_pc;
-- 
1.6.3.3


-- 
Regards/Gruss,
    Boris.

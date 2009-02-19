Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbZBSO7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbZBSO7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 09:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZBSO6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 09:58:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50941 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbZBSO6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 09:58:54 -0500
Date: Thu, 19 Feb 2009 15:58:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI][REGRESSION][BISECTED] Disk errors loop forever in 2.6.29
Message-ID: <20090219145844.GA22220@elte.hu>
References: <20090219135352.GA28717@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219135352.GA28717@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> Hi,
> 
> There appears to be a regression from 2.6.28 in how disk errors are
> handled in 2.6.29rc5 - rather than trying and eventually giving up, it
> appears to try (and report) forever. 
> 
> Here is the output where it aborts in 2.6.28:
> 
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> ata2.01: BMDMA stat 0x65
> ata2.01: cmd c8/00:00:f7:e2:9c/00:00:00:00:00/f1 tag 0 dma 131072 in
>          res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
> ata2: soft resetting link
> ata2.00: configured for UDMA/66
> ata2.01: configured for UDMA/66
> ata2: EH complete
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> ata2.01: BMDMA stat 0x65
> ata2.01: cmd c8/00:00:f7:e2:9c/00:00:00:00:00/f1 tag 0 dma 131072 in
>          res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
> ata2: soft resetting link
> ata2.00: configured for UDMA/66
> ata2.01: configured for UDMA/66
> ata2: EH complete
> sd 1:0:0:0: [sda] 7880544 512-byte hardware sectors: (4.03 GB/3.75 GiB)
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> ata2.01: BMDMA stat 0x65
> ata2.01: cmd c8/00:00:f7:e2:9c/00:00:00:00:00/f1 tag 0 dma 131072 in
>          res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
> ata2: soft resetting link
> ata2.00: configured for UDMA/66
> ata2.01: configured for UDMA/66
> ata2: EH complete
> sd 1:0:0:0: [sda] Write Protect is off
> sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
> ata2.01: limiting speed to UDMA/44:PIO4
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> ata2.01: BMDMA stat 0x65
> ata2.01: cmd c8/00:00:f7:e2:9c/00:00:00:00:00/f1 tag 0 dma 131072 in
>          res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
> ata2: soft resetting link
> ata2.00: configured for UDMA/66
> ata2.01: configured for UDMA/44
> ata2: EH complete
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> ata2.01: BMDMA stat 0x65
> ata2.01: cmd c8/00:00:f7:e2:9c/00:00:00:00:00/f1 tag 0 dma 131072 in
>          res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
> ata2: soft resetting link
> ata2.00: configured for UDMA/66
> ata2.01: configured for UDMA/44
> ata2: EH complete
> sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sda: detected capacity change from 0 to 4034838528
> ata2.01: limiting speed to UDMA/33:PIO4
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> ata2.01: BMDMA stat 0x65
> ata2.01: cmd c8/00:00:f7:e2:9c/00:00:00:00:00/f1 tag 0 dma 131072 in
>          res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
> ata2: soft resetting link
> ata2.00: configured for UDMA/66
> ata2.01: configured for UDMA/33
> sd 1:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
> sd 1:0:1:0: [sdb] Sense Key : 0xb [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
>         00 00 00 00 
> sd 1:0:1:0: [sdb] ASC=0x0 ASCQ=0x0
> end_request: I/O error, dev sdb, sector 27058935
> Buffer I/O error on device sdb2, logical block 444480
> Buffer I/O error on device sdb2, logical block 444481
> Buffer I/O error on device sdb2, logical block 444482
> Buffer I/O error on device sdb2, logical block 444483
> Buffer I/O error on device sdb2, logical block 444484
> Buffer I/O error on device sdb2, logical block 444485
> Buffer I/O error on device sdb2, logical block 444486
> Buffer I/O error on device sdb2, logical block 444487
> Buffer I/O error on device sdb2, logical block 444488
> Buffer I/O error on device sdb2, logical block 444489
> ata2: EH complete
> 
> It never gets to end_request on 2.6.29. I've bisected the problem down
> to the following:
> 
> [b60af5b0adf0da24c673598c8d3fb4d4189a15ce] [SCSI] simplify scsi_io_completion()
> 
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Mon Nov 3 15:56:47 2008 -0500
> 
>     [SCSI] simplify scsi_io_completion()

i had SCSI problems with that area of the code, and the patch 
below fixed it. Maybe it fixes your problem too.

	Ingo

----------------------->
>From 7e4cbd14b28546e6f758d01b0d7f3f4647fada52 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Tue, 17 Feb 2009 15:10:21 -0500
Subject: [PATCH] fix "scsi: aic7xxx hang since v2.6.28-rc1"

This patch (as1144c) removes scsi_end_request().  The routine had only
one caller, so it is moved inline and simplified.

In addition, if no forward progress has been made then the patch
decrements a request's retry counter before unpreparing and requeuing
it, to avoid infinite retry loops.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/scsi/scsi_lib.c |   94 ++++++++++-------------------------------------
 1 files changed, 20 insertions(+), 74 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 940dc32..d4c6ac3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -703,71 +703,6 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 
 static void __scsi_release_buffers(struct scsi_cmnd *, int);
 
-/*
- * Function:    scsi_end_request()
- *
- * Purpose:     Post-processing of completed commands (usually invoked at end
- *		of upper level post-processing and scsi_io_completion).
- *
- * Arguments:   cmd	 - command that is complete.
- *              error    - 0 if I/O indicates success, < 0 for I/O error.
- *              bytes    - number of bytes of completed I/O
- *		requeue  - indicates whether we should requeue leftovers.
- *
- * Lock status: Assumed that lock is not held upon entry.
- *
- * Returns:     cmd if requeue required, NULL otherwise.
- *
- * Notes:       This is called for block device requests in order to
- *              mark some number of sectors as complete.
- * 
- *		We are guaranteeing that the request queue will be goosed
- *		at some point during this call.
- * Notes:	If cmd was requeued, upon return it will be a stale pointer.
- */
-static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
-					  int bytes, int requeue)
-{
-	struct request_queue *q = cmd->device->request_queue;
-	struct request *req = cmd->request;
-
-	/*
-	 * If there are blocks left over at the end, set up the command
-	 * to queue the remainder of them.
-	 */
-	if (blk_end_request(req, error, bytes)) {
-		int leftover = (req->hard_nr_sectors << 9);
-
-		if (blk_pc_request(req))
-			leftover = req->data_len;
-
-		/* kill remainder if no retrys */
-		if (error && scsi_noretry_cmd(cmd))
-			blk_end_request(req, error, leftover);
-		else {
-			if (requeue) {
-				/*
-				 * Bleah.  Leftovers again.  Stick the
-				 * leftovers in the front of the
-				 * queue, and goose the queue again.
-				 */
-				scsi_release_buffers(cmd);
-				scsi_requeue_command(q, cmd);
-				cmd = NULL;
-			}
-			return cmd;
-		}
-	}
-
-	/*
-	 * This will goose the queue request function at the end, so we don't
-	 * need to worry about launching another command.
-	 */
-	__scsi_release_buffers(cmd, 0);
-	scsi_next_command(cmd);
-	return NULL;
-}
-
 static inline unsigned int scsi_sgtable_index(unsigned short nents)
 {
 	unsigned int index;
@@ -929,7 +864,6 @@ static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count;
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
@@ -980,18 +914,30 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
 				      "%d bytes done.\n",
 				      req->nr_sectors, good_bytes));
-
-	/* A number of bytes were successfully read.  If there
-	 * are leftovers and there is some kind of error
-	 * (result != 0), retry the rest.
-	 */
-	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
+	if (blk_end_request(req, error, good_bytes) == 0) {
+		/* This request is completely finished; start the next one */
+		scsi_next_command(cmd);
 		return;
-	this_count = blk_rq_bytes(req);
+	}
 
 	error = -EIO;
 
-	if (host_byte(result) == DID_RESET) {
+	/* The request isn't finished yet.  Figure out what to do next. */
+	if (result == 0) {
+		/* No error, so carry out the remainder of the request.
+		 * Failure to make forward progress counts against the
+		 * the number of retries.
+		 */
+		if (good_bytes > 0 || --req->retries >= 0)
+			action = ACTION_REPREP;
+		else {
+			action = ACTION_FAIL;
+			description = "Retries exhausted";
+		}
+	} else if (error && scsi_noretry_cmd(cmd)) {
+		/* Retrys are disallowed, so kill the remainder. */
+		action = ACTION_FAIL;
+	} else if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
 		 * reasons.  Just retry the command and see what
 		 * happens.

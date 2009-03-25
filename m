Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbZCYOTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbZCYOTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761988AbZCYOSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:18:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:57740 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758529AbZCYOSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:18:08 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 01/10] ide-atapi: allow ->pc_callback() to change rq->data_len
Date: Wed, 25 Mar 2009 23:17:44 +0900
Message-Id: <1237990673-8358-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237990673-8358-1-git-send-email-tj@kernel.org>
References: <1237990673-8358-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 14:17:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: allow residual count implementation in ->pc_callback()

rq->data_len has two duties - carrying the number of input bytes on
issue and carrying residual count back to the issuer on completion.
ide-atapi completion callback ->pc_callback() is the right place to do
this but currently ide-atapi depends on rq->data_len carrying the
original request size after calling ->pc_callback() to complete the pc
request.

This patch makes ide_pc_intr() cache length to complete before calling
->pc_callback() so that it can modify rq->data_len as necessary.

Note: As using rq->data_len for two purposes can make cases like this
      incorrect in subtle ways, future changes will introduce separate
      field for residual count.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/ide/ide-atapi.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index bc7dfcf..2b456c4 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -328,6 +328,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 	/* No more interrupts */
 	if ((stat & ATA_DRQ) == 0) {
+		unsigned int done;
 		int uptodate;
 
 		debug_log("Packet command completed, %d bytes transferred\n",
@@ -367,6 +368,15 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) && (stat & ATA_DSC) == 0)
 			dsc = 1;
 
+		/*
+		 * ->pc_callback() might change rq->data_len for
+		 * residual count, cache total length.
+		 */
+		if (drive->media == ide_tape)
+			done = ide_rq_bytes(rq);	/* FIXME */
+		else
+			done = blk_rq_bytes(rq);
+
 		/* Command finished - Call the callback function */
 		uptodate = drive->pc_callback(drive, dsc);
 
@@ -375,20 +385,13 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 		if (blk_special_request(rq)) {
 			rq->errors = 0;
-			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
+			ide_complete_rq(drive, 0, done);
 		} else {
-			unsigned int done;
-
 			if (blk_fs_request(rq) == 0 && uptodate <= 0) {
 				if (rq->errors == 0)
 					rq->errors = -EIO;
 			}
 
-			if (drive->media == ide_tape)
-				done = ide_rq_bytes(rq); /* FIXME */
-			else
-				done = blk_rq_bytes(rq);
-
 			ide_complete_rq(drive, uptodate ? 0 : -EIO, done);
 		}
 
-- 
1.6.0.2


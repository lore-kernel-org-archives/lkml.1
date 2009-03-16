Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZCPCar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZCPCar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbZCPC3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:29:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:44271 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbZCPC3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:29:13 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/17] ide: use blk_update_request() instead of blk_end_request_callback()
Date: Mon, 16 Mar 2009 11:28:46 +0900
Message-Id: <1237170540-19130-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237170540-19130-1-git-send-email-tj@kernel.org>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 02:29:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_end_request_callback() is being phased out in favor of
blk_update_request().  Switch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index ddfbea4..f825d50 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -748,16 +748,6 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 	return (flags & REQ_FAILED) ? -EIO : 0;
 }
 
-/*
- * Called from blk_end_request_callback() after the data of the request is
- * completed and before the request itself is completed. By returning value '1',
- * blk_end_request_callback() returns immediately without completing it.
- */
-static int cdrom_newpc_intr_dummy_cb(struct request *rq)
-{
-	return 1;
-}
-
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -932,12 +922,10 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			/*
 			 * The request can't be completed until DRQ is cleared.
 			 * So complete the data, but don't complete the request
-			 * using the dummy function for the callback feature
-			 * of blk_end_request_callback().
+			 * using blk_update_request().
 			 */
 			if (rq->bio)
-				blk_end_request_callback(rq, 0, blen,
-						 cdrom_newpc_intr_dummy_cb);
+				blk_update_request(rq, 0, blen);
 			else
 				rq->data += blen;
 		}
-- 
1.6.0.2


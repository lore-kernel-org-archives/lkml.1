Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbZELCPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbZELCPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 22:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbZELCPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 22:15:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:40468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270AbZELCPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 22:15:34 -0400
Message-ID: <4A08DBBA.1000208@kernel.org>
Date: Tue, 12 May 2009 11:15:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH block#for-2.6.31] scsi: fix resid_len mis-conversion in scsi_end_request()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 02:15:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c3a4d78c580de4edc9ef0f7c59812fb02ceb037f introduced
rq->data_len and converted residual count users to it.  While
converting, it mistakenly converted scsi_end_request() to finish
requests with residual count when it wants to do is fully complete the
request.  Fix it by using blk_end_request_all() instead.

This bug was spotted by Boaz Harrosh.

Signed-off-by: Tejun Heo <tj@kernel.org>
Spotted-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_lib.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a54bec9..e410d66 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -546,14 +546,9 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 	 * to queue the remainder of them.
 	 */
 	if (blk_end_request(req, error, bytes)) {
-		int leftover = blk_rq_bytes(req);
-
-		if (blk_pc_request(req))
-			leftover = req->resid_len;
-
 		/* kill remainder if no retrys */
 		if (error && scsi_noretry_cmd(cmd))
-			blk_end_request(req, error, leftover);
+			blk_end_request_all(req, error);
 		else {
 			if (requeue) {
 				/*


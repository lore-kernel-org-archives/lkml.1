Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbZEKI5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbZEKI5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbZEKI47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:56:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:37524 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbZEKI46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:56:58 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: jens.axboe@oracle.com
Cc: tj@kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com,
       fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] block: let blk_end_request_all handle bidi requests
Date: Mon, 11 May 2009 17:56:07 +0900
Message-Id: <1242032169-22422-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 11 May 2009 17:55:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_end_request_all() and __blk_end_request_all() should finish all
bytes including bidi, by definition. That's what all bidi users need ,
bidi requests must be complete as a whole (partial completion is
impossible).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/blkdev.h |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8919683..3b5c564 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -911,8 +911,12 @@ static inline bool blk_end_request(struct request *rq, int error,
 static inline void blk_end_request_all(struct request *rq, int error)
 {
 	bool pending;
+	unsigned int bidi_bytes = 0;
 
-	pending = blk_end_request(rq, error, blk_rq_bytes(rq));
+	if (unlikely(blk_bidi_rq(rq)))
+		bidi_bytes = blk_rq_bytes(rq->next_rq);
+
+	pending = blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
 	BUG_ON(pending);
 }
 
@@ -963,8 +967,12 @@ static inline bool __blk_end_request(struct request *rq, int error,
 static inline void __blk_end_request_all(struct request *rq, int error)
 {
 	bool pending;
+	unsigned int bidi_bytes = 0;
+
+	if (unlikely(blk_bidi_rq(rq)))
+		bidi_bytes = blk_rq_bytes(rq->next_rq);
 
-	pending = __blk_end_request(rq, error, blk_rq_bytes(rq));
+	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
 	BUG_ON(pending);
 }
 
-- 
1.6.0.6


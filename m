Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZCPCeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZCPCeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbZCPC30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:29:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:44324 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbZCPC3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:29:24 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>, Jeff Dike <jdike@linux.intel.com>
Subject: [PATCH 16/17] ubd: simplify block request completion
Date: Mon, 16 Mar 2009 11:28:59 +0900
Message-Id: <1237170540-19130-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237170540-19130-1-git-send-email-tj@kernel.org>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 02:29:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

ubd had its own block request partial completion mechanism, which is
unnecessary as block layer already does it.  Kill ubd_end_request()
and ubd_finish() and replace them with direct call to
blk_end_request().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/ubd_kern.c |   23 +----------------------
 1 files changed, 1 insertions(+), 22 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 0a86811..906ecdf 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -451,23 +451,6 @@ static void do_ubd_request(struct request_queue * q);
 
 /* Only changed by ubd_init, which is an initcall. */
 static int thread_fd = -1;
-
-static void ubd_end_request(struct request *req, int bytes, int error)
-{
-	blk_end_request(req, error, bytes);
-}
-
-/* Callable only from interrupt context - otherwise you need to do
- * spin_lock_irq()/spin_lock_irqsave() */
-static inline void ubd_finish(struct request *req, int bytes)
-{
-	if(bytes < 0){
-		ubd_end_request(req, 0, -EIO);
-		return;
-	}
-	ubd_end_request(req, bytes, 0);
-}
-
 static LIST_HEAD(restart);
 
 /* XXX - move this inside ubd_intr. */
@@ -475,7 +458,6 @@ static LIST_HEAD(restart);
 static void ubd_handler(void)
 {
 	struct io_thread_req *req;
-	struct request *rq;
 	struct ubd *ubd;
 	struct list_head *list, *next_ele;
 	unsigned long flags;
@@ -492,10 +474,7 @@ static void ubd_handler(void)
 			return;
 		}
 
-		rq = req->req;
-		rq->nr_sectors -= req->length >> 9;
-		if(rq->nr_sectors == 0)
-			ubd_finish(rq, rq->hard_nr_sectors << 9);
+		blk_end_request(req->req, 0, req->length);
 		kfree(req);
 	}
 	reactivate_fd(thread_fd, UBD_IRQ);
-- 
1.6.0.2


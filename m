Return-Path: <linux-kernel-owner+w=401wt.eu-S1759228AbZD1EJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228AbZD1EJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 00:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZD1EHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 00:07:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:38776 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZD1EHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 00:07:41 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, donari75@gmail.com,
       bzolnier@gmail.com, joerg@dorchain.net, geert@linux-m68k.org,
       davem@davemloft.net, jdike@linux.intel.com, benh@kernel.crashing.org,
       Laurent@lvivier.info
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/14] ubd: drop unnecessary rq->sector manipulation
Date: Tue, 28 Apr 2009 13:06:10 +0900
Message-Id: <1240891577-4813-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240891577-4813-1-git-send-email-tj@kernel.org>
References: <1240891577-4813-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Apr 2009 04:06:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ubd curiously updates rq->sector while issuing the request in multiple
pieces.  Don't do it and simply use local copy of sector.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/ubd_kern.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 36ca9fa..4330127 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1222,7 +1222,8 @@ static void do_ubd_request(struct request_queue *q)
 {
 	struct io_thread_req *io_req;
 	struct request *req;
-	int n, last_sectors;
+	sector_t sector;
+	int n;
 
 	while(1){
 		struct ubd *dev = q->queuedata;
@@ -1238,11 +1239,10 @@ static void do_ubd_request(struct request_queue *q)
 		}
 
 		req = dev->request;
-		last_sectors = 0;
+		sector = req->sector;
 		while(dev->start_sg < dev->end_sg){
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
-			req->sector += last_sectors;
 			io_req = kmalloc(sizeof(struct io_thread_req),
 					 GFP_ATOMIC);
 			if(io_req == NULL){
@@ -1251,10 +1251,10 @@ static void do_ubd_request(struct request_queue *q)
 				return;
 			}
 			prepare_request(req, io_req,
-					(unsigned long long) req->sector << 9,
+					(unsigned long long)sector << 9,
 					sg->offset, sg->length, sg_page(sg));
 
-			last_sectors = sg->length >> 9;
+			sector += sg->length >> 9;
 			n = os_write_file(thread_fd, &io_req,
 					  sizeof(struct io_thread_req *));
 			if(n != sizeof(struct io_thread_req *)){
-- 
1.6.0.2


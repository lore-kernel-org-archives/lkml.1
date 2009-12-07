Return-Path: <linux-kernel-owner+w=401wt.eu-S964972AbZLGSPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972AbZLGSPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964921AbZLGSPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:15:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964877AbZLGSPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:15:44 -0500
Date: Mon, 7 Dec 2009 13:15:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] cfq-iosched: Do not access cfqq after freeing it
Message-ID: <20091207181547.GG16900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a crash during boot reported by Jeff Moyer. Fix the issue of accessing
cfqq after freeing it.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Index: linux-2.6-block/block/cfq-iosched.c
===================================================================
--- linux-2.6-block.orig/block/cfq-iosched.c
+++ linux-2.6-block/block/cfq-iosched.c
@@ -2368,7 +2368,7 @@ static int cfq_dispatch_requests(struct 
 static void cfq_put_queue(struct cfq_queue *cfqq)
 {
 	struct cfq_data *cfqd = cfqq->cfqd;
-	struct cfq_group *cfqg;
+	struct cfq_group *cfqg, *orig_cfqg;
 
 	BUG_ON(atomic_read(&cfqq->ref) <= 0);
 
@@ -2379,6 +2379,7 @@ static void cfq_put_queue(struct cfq_que
 	BUG_ON(rb_first(&cfqq->sort_list));
 	BUG_ON(cfqq->allocated[READ] + cfqq->allocated[WRITE]);
 	cfqg = cfqq->cfqg;
+	orig_cfqg = cfqq->orig_cfqg;
 
 	if (unlikely(cfqd->active_queue == cfqq)) {
 		__cfq_slice_expired(cfqd, cfqq, 0);
@@ -2388,8 +2389,8 @@ static void cfq_put_queue(struct cfq_que
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 	kmem_cache_free(cfq_pool, cfqq);
 	cfq_put_cfqg(cfqg);
-	if (cfqq->orig_cfqg)
-		cfq_put_cfqg(cfqq->orig_cfqg);
+	if (orig_cfqg)
+		cfq_put_cfqg(orig_cfqg);
 }
 
 /*

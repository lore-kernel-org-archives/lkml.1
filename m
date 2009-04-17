Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbZDQGcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbZDQGcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbZDQGcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:32:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:19396 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbZDQGcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:32:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=FcyBO6Thhgh+CFAswN90WISBvtt3VPdDOJDwBHNVO9x4S/H3p8H7bVQzt1R7XJLeza
         vddRc1x/94O7wmJWRidtZuwb0VUb8M8hAZVHrtgEWHSHGCXI0jqF90yrAG0lZmICew1P
         1bM1/yE4UFdbL5LRlhr3uMXB9V+5LCaqGqC4g=
Date: Fri, 17 Apr 2009 15:32:17 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] loop: use BIO list management functions
Message-ID: <20090417063217.GA3515@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Cc:  Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/block/loop.c |   26 +++++++-------------------
 include/linux/bio.h  |    2 +-
 include/linux/loop.h |    3 +--
 3 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ddae808..9ca4bb0 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -511,11 +511,7 @@ out:
  */
 static void loop_add_bio(struct loop_device *lo, struct bio *bio)
 {
-	if (lo->lo_biotail) {
-		lo->lo_biotail->bi_next = bio;
-		lo->lo_biotail = bio;
-	} else
-		lo->lo_bio = lo->lo_biotail = bio;
+	bio_list_add(&lo->lo_bio_list, bio);
 }
 
 /*
@@ -523,16 +519,7 @@ static void loop_add_bio(struct loop_device *lo, struct bio *bio)
  */
 static struct bio *loop_get_bio(struct loop_device *lo)
 {
-	struct bio *bio;
-
-	if ((bio = lo->lo_bio)) {
-		if (bio == lo->lo_biotail)
-			lo->lo_biotail = NULL;
-		lo->lo_bio = bio->bi_next;
-		bio->bi_next = NULL;
-	}
-
-	return bio;
+	return bio_list_pop(&lo->lo_bio_list);
 }
 
 static int loop_make_request(struct request_queue *q, struct bio *old_bio)
@@ -609,12 +596,13 @@ static int loop_thread(void *data)
 
 	set_user_nice(current, -20);
 
-	while (!kthread_should_stop() || lo->lo_bio) {
+	while (!kthread_should_stop() || !bio_list_empty(&lo->lo_bio_list)) {
 
 		wait_event_interruptible(lo->lo_event,
-				lo->lo_bio || kthread_should_stop());
+				!bio_list_empty(&lo->lo_bio_list) ||
+				kthread_should_stop());
 
-		if (!lo->lo_bio)
+		if (bio_list_empty(&lo->lo_bio_list))
 			continue;
 		spin_lock_irq(&lo->lo_lock);
 		bio = loop_get_bio(lo);
@@ -841,7 +829,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
 
-	lo->lo_bio = lo->lo_biotail = NULL;
+	bio_list_init(&lo->lo_bio_list);
 
 	/*
 	 * set queue make_request_fn, and add limits based on lower level
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b89cf2d..631153b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -505,7 +505,7 @@ static inline int bio_has_data(struct bio *bio)
 }
 
 /*
- * BIO list managment for use by remapping drivers (e.g. DM or MD).
+ * BIO list management for use by remapping drivers (e.g. DM or MD) and loop.
  *
  * A bio_list anchors a singly-linked list of bios chained through the bi_next
  * member of the bio.  The bio_list also caches the last list member to allow
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 4072544..66c194e 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -56,8 +56,7 @@ struct loop_device {
 	gfp_t		old_gfp_mask;
 
 	spinlock_t		lo_lock;
-	struct bio 		*lo_bio;
-	struct bio		*lo_biotail;
+	struct bio_list		lo_bio_list;
 	int			lo_state;
 	struct mutex		lo_ctl_mutex;
 	struct task_struct	*lo_thread;

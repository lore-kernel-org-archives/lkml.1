Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0BVNn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 08:43:27 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:50717 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab0BVNnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 08:43:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fwHaPk1KTzGGrwSELLD1aYuSZn0TR9YUE1+2CKKtJqEpFwQwyfePItMhJ5ULIp0hku
         tMMvW08IqxLhNFgc/vl5KoOKsFbWrrlA2NdsnXn1LOi7NpXC3Jo95Wjn/Ua/cLD+7QXf
         PceVJA1yqSLokBxCgAClTed1V5HtjFDor0xP0=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jens Axboe <axboe@kernel.dk>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] blk-core: use BIO list management functions
Date: Mon, 22 Feb 2010 22:29:24 +0900
Message-Id: <1266845364-3242-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1266845364-3242-1-git-send-email-akinobu.mita@gmail.com>
References: <1266845364-3242-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the bio list management stuff is generic, convert
generic_make_request to use bio lists instead of its own private bio
list implementation.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc:  Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
---
 block/blk-core.c      |   31 ++++++++++++++-----------------
 include/linux/sched.h |    4 ++--
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 718897e..44b6d69 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1490,9 +1490,9 @@ end_io:
 /*
  * We only want one ->make_request_fn to be active at a time,
  * else stack usage with stacked devices could be a problem.
- * So use current->bio_{list,tail} to keep a list of requests
+ * So use current->bio_list to keep a list of requests
  * submited by a make_request_fn function.
- * current->bio_tail is also used as a flag to say if
+ * current->bio_list is also used as a flag to say if
  * generic_make_request is currently active in this task or not.
  * If it is NULL, then no make_request is active.  If it is non-NULL,
  * then a make_request is active, and new requests should be added
@@ -1500,11 +1500,11 @@ end_io:
  */
 void generic_make_request(struct bio *bio)
 {
-	if (current->bio_tail) {
+	struct bio_list bio_list_on_stack;
+
+	if (current->bio_list) {
 		/* make_request is active */
-		*(current->bio_tail) = bio;
-		bio->bi_next = NULL;
-		current->bio_tail = &bio->bi_next;
+		bio_list_add(current->bio_list, bio);
 		return;
 	}
 	/* following loop may be a bit non-obvious, and so deserves some
@@ -1512,30 +1512,27 @@ void generic_make_request(struct bio *bio)
 	 * Before entering the loop, bio->bi_next is NULL (as all callers
 	 * ensure that) so we have a list with a single bio.
 	 * We pretend that we have just taken it off a longer list, so
-	 * we assign bio_list to the next (which is NULL) and bio_tail
-	 * to &bio_list, thus initialising the bio_list of new bios to be
+	 * we assign bio_list to a pointer to the bio_list_on_stack,
+	 * thus initialising the bio_list of new bios to be
 	 * added.  __generic_make_request may indeed add some more bios
 	 * through a recursive call to generic_make_request.  If it
 	 * did, we find a non-NULL value in bio_list and re-enter the loop
 	 * from the top.  In this case we really did just take the bio
-	 * of the top of the list (no pretending) and so fixup bio_list and
-	 * bio_tail or bi_next, and call into __generic_make_request again.
+	 * of the top of the list (no pretending) and so remove it from
+	 * bio_list, and call into __generic_make_request again.
 	 *
 	 * The loop was structured like this to make only one call to
 	 * __generic_make_request (which is important as it is large and
 	 * inlined) and to keep the structure simple.
 	 */
 	BUG_ON(bio->bi_next);
+	bio_list_init(&bio_list_on_stack);
+	current->bio_list = &bio_list_on_stack;
 	do {
-		current->bio_list = bio->bi_next;
-		if (bio->bi_next == NULL)
-			current->bio_tail = &current->bio_list;
-		else
-			bio->bi_next = NULL;
 		__generic_make_request(bio);
-		bio = current->bio_list;
+		bio = bio_list_pop(current->bio_list);
 	} while (bio);
-	current->bio_tail = NULL; /* deactivate */
+	current->bio_list = NULL; /* deactivate */
 }
 EXPORT_SYMBOL(generic_make_request);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78efe7c..7eb8297 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -97,7 +97,7 @@ struct sched_param {
 struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
-struct bio;
+struct bio_list;
 struct fs_struct;
 struct bts_context;
 struct perf_event_context;
@@ -1466,7 +1466,7 @@ struct task_struct {
 	void *journal_info;
 
 /* stacked block device info */
-	struct bio *bio_list, **bio_tail;
+	struct bio_list *bio_list;
 
 /* VM state */
 	struct reclaim_state *reclaim_state;
-- 
1.6.0.6


Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0AHTKL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 8 Jan 2010 14:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845Ab0AHTKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:10:09 -0500
Received: from foot.mail.ru ([94.100.189.94]:54887 "EHLO foot.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab0AHTKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:10:07 -0500
X-Greylist: delayed 115979 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jan 2010 14:10:07 EST
From: Kirill Afonshin <kirill_nnov@mail.ru>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: =?koi8-r?Q?[PATCH]_removed_unused_as=5Fio=5Fcontext?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: [95.37.217.228]
Date: Fri, 08 Jan 2010 22:09:59 +0300
Reply-To: Kirill Afonshin <kirill_nnov@mail.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1NTKDf-0008NY-00.kirill_nnov-mail-ru@foot.mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, as_io_context isn't used anymore.
---
 block/blk-ioc.c           |    5 -----
 include/linux/iocontext.h |   27 ---------------------------
 2 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index cbdabb0..98e6bf6 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -39,8 +39,6 @@ int put_io_context(struct io_context *ioc)
 
 	if (atomic_long_dec_and_test(&ioc->refcount)) {
 		rcu_read_lock();
-		if (ioc->aic && ioc->aic->dtor)
-			ioc->aic->dtor(ioc->aic);
 		cfq_dtor(ioc);
 		rcu_read_unlock();
 
@@ -76,8 +74,6 @@ void exit_io_context(struct task_struct *task)
 	task_unlock(task);
 
 	if (atomic_dec_and_test(&ioc->nr_tasks)) {
-		if (ioc->aic && ioc->aic->exit)
-			ioc->aic->exit(ioc->aic);
 		cfq_exit(ioc);
 
 	}
@@ -97,7 +93,6 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 		ret->ioprio = 0;
 		ret->last_waited = jiffies; /* doesn't matter... */
 		ret->nr_batch_requests = 0; /* because this is 0 */
-		ret->aic = NULL;
 		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
 		INIT_HLIST_HEAD(&ret->cic_list);
 		ret->ioc_data = NULL;
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index a632359..78ef023 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -4,32 +4,6 @@
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
 
-/*
- * This is the per-process anticipatory I/O scheduler state.
- */
-struct as_io_context {
-	spinlock_t lock;
-
-	void (*dtor)(struct as_io_context *aic); /* destructor */
-	void (*exit)(struct as_io_context *aic); /* called on task exit */
-
-	unsigned long state;
-	atomic_t nr_queued; /* queued reads & sync writes */
-	atomic_t nr_dispatched; /* number of requests gone to the drivers */
-
-	/* IO History tracking */
-	/* Thinktime */
-	unsigned long last_end_request;
-	unsigned long ttime_total;
-	unsigned long ttime_samples;
-	unsigned long ttime_mean;
-	/* Layout pattern */
-	unsigned int seek_samples;
-	sector_t last_request_pos;
-	u64 seek_total;
-	sector_t seek_mean;
-};
-
 struct cfq_queue;
 struct cfq_io_context {
 	void *key;
@@ -78,7 +52,6 @@ struct io_context {
 	unsigned long last_waited; /* Time last woken after wait for request */
 	int nr_batch_requests;     /* Number of requests left in the batch */
 
-	struct as_io_context *aic;
 	struct radix_tree_root radix_root;
 	struct hlist_head cic_list;
 	void *ioc_data;
-- 
1.6.3.3

Best regards,
Kirill Afonshin

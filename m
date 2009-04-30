Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbZD3HbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbZD3HbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 03:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbZD3Ham
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 03:30:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbZD3Hak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 03:30:40 -0400
From: Nikanth Karthikesan <knikanth@novell.com>
Organization: Novell
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH v2] Handle improbable possibility of io_context->refcount overflow
Date: Thu, 30 Apr 2009 12:58:22 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200904291221.40361.knikanth@novell.com> <200904291533.07377.knikanth@novell.com> <20090429081558.acaa2a9a.akpm@linux-foundation.org>
In-Reply-To: <20090429081558.acaa2a9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301258.23182.knikanth@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently io_context has an atomic_t(32-bit) as refcount. In case of cfq, for
each device a task does I/O, a reference to the io_context would be taken. And
when there are multiple process sharing io_contexts(CLONE_IO) would also have
a reference to the same io_context. Theoretically the possible maximum number
of processes sharing the same io_context + the number of disks/cfq_data
referring to the same io_context can overflow the 32-bit counter on a very
high-end machine. Even though it is an improbable case, let us make it
difficult atleast on 64-bit architectures by changing the refcount to
atomic_long_t.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 012f065..d4ed600 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -35,9 +35,9 @@ int put_io_context(struct io_context *ioc)
 	if (ioc == NULL)
 		return 1;
 
-	BUG_ON(atomic_read(&ioc->refcount) == 0);
+	BUG_ON(atomic_long_read(&ioc->refcount) == 0);
 
-	if (atomic_dec_and_test(&ioc->refcount)) {
+	if (atomic_long_dec_and_test(&ioc->refcount)) {
 		rcu_read_lock();
 		if (ioc->aic && ioc->aic->dtor)
 			ioc->aic->dtor(ioc->aic);
@@ -90,7 +90,7 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 
 	ret = kmem_cache_alloc_node(iocontext_cachep, gfp_flags, node);
 	if (ret) {
-		atomic_set(&ret->refcount, 1);
+		atomic_long_set(&ret->refcount, 1);
 		atomic_set(&ret->nr_tasks, 1);
 		spin_lock_init(&ret->lock);
 		ret->ioprio_changed = 0;
@@ -151,7 +151,7 @@ struct io_context *get_io_context(gfp_t gfp_flags, int node)
 		ret = current_io_context(gfp_flags, node);
 		if (unlikely(!ret))
 			break;
-	} while (!atomic_inc_not_zero(&ret->refcount));
+	} while (!atomic_long_inc_not_zero(&ret->refcount));
 
 	return ret;
 }
@@ -163,8 +163,8 @@ void copy_io_context(struct io_context **pdst, struct io_context **psrc)
 	struct io_context *dst = *pdst;
 
 	if (src) {
-		BUG_ON(atomic_read(&src->refcount) == 0);
-		atomic_inc(&src->refcount);
+		BUG_ON(atomic_long_read(&src->refcount) == 0);
+		atomic_long_inc(&src->refcount);
 		put_io_context(dst);
 		*pdst = src;
 	}
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a55a9bd..6a79c5b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1282,7 +1282,7 @@ static void cfq_dispatch_request(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	if (!cfqd->active_cic) {
 		struct cfq_io_context *cic = RQ_CIC(rq);
 
-		atomic_inc(&cic->ioc->refcount);
+		atomic_long_inc(&cic->ioc->refcount);
 		cfqd->active_cic = cic;
 	}
 }
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 08b987b..dd05434 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -64,7 +64,7 @@ struct cfq_io_context {
  * and kmalloc'ed. These could be shared between processes.
  */
 struct io_context {
-	atomic_t refcount;
+	atomic_long_t refcount;
 	atomic_t nr_tasks;
 
 	/* all the fields below are protected by this lock */
@@ -91,8 +91,8 @@ static inline struct io_context *ioc_task_link(struct io_context *ioc)
 	 * if ref count is zero, don't allow sharing (ioc is going away, it's
 	 * a race).
 	 */
-	if (ioc && atomic_inc_not_zero(&ioc->refcount)) {
-		atomic_inc(&ioc->nr_tasks);
+	if (ioc && atomic_long_inc_not_zero(&ioc->refcount)) {
+		atomic_long_inc(&ioc->refcount);
 		return ioc;
 	}
 


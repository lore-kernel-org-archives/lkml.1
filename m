Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZD2KFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZD2KFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZD2KFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:05:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:55175 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbZD2KFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:05:30 -0400
From: Nikanth Karthikesan <knikanth@novell.com>
Organization: Novell
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH][RFC] Handle improbable possibility of io_context->refcount overflow
Date: Wed, 29 Apr 2009 15:33:06 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200904291221.40361.knikanth@novell.com> <20090429005930.3752dd6d.akpm@linux-foundation.org>
In-Reply-To: <20090429005930.3752dd6d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904291533.07377.knikanth@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009 13:29:30 Andrew Morton wrote:
> On Wed, 29 Apr 2009 12:21:39 +0530 Nikanth Karthikesan <knikanth@novell.com> wrote:
> > Hi Jens
> >
> > Currently io_context has an atomic_t(int) as refcount. In case of cfq,
> > for each device a task does I/O, a reference to the io_context would be
> > taken. And when there are multiple process sharing io_contexts(CLONE_IO)
> > would also have a reference to the same io_context. Theoretically the
> > possible maximum number of processes sharing the same io_context + the
> > number of disks/cfq_data referring to the same io_context can overflow
> > the 32-bit counter on a very high-end machine. Even though it is an
> > improbable case, let us make it difficult by changing the refcount to
> > atomic64_t(long).
>
> Sorry, atomic64_t isn't implemented on 32 bit architectures.
>
> Perhaps it should be, but I expect it'd be pretty slow.

Oh! Sorry, I didn't notice the #ifdef earlier. I guess thats why there is only
a single in-tree user for atomic64_t!

In this case, could we make it atomic64_t only on 64-bit architectures and
keep it as atomic_t on 32-bit machines? Something like the attached patch.

I wonder whether we should also add BUG_ON's whenever the refcount is about to
wrap? Or try to handle it gracefully. Another approach would be to impose an
artificial limit on the no of tasks that could share an io_context. Or resort
to lock protection. The problem is not very serious/common.

Thanks
Nikanth

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 012f065..5be4585 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -35,9 +35,9 @@ int put_io_context(struct io_context *ioc)
 	if (ioc == NULL)
 		return 1;
 
-	BUG_ON(atomic_read(&ioc->refcount) == 0);
+	BUG_ON(atomic_read_ioc_refcount(ioc) == 0);
 
-	if (atomic_dec_and_test(&ioc->refcount)) {
+	if (atomic_dec_and_test_ioc_refcount(ioc)) {
 		rcu_read_lock();
 		if (ioc->aic && ioc->aic->dtor)
 			ioc->aic->dtor(ioc->aic);
@@ -151,7 +151,7 @@ struct io_context *get_io_context(gfp_t gfp_flags, int node)
 		ret = current_io_context(gfp_flags, node);
 		if (unlikely(!ret))
 			break;
-	} while (!atomic_inc_not_zero(&ret->refcount));
+	} while (!atomic_inc_not_zero_ioc_refcount(ret));
 
 	return ret;
 }
@@ -163,8 +163,8 @@ void copy_io_context(struct io_context **pdst, struct io_context **psrc)
 	struct io_context *dst = *pdst;
 
 	if (src) {
-		BUG_ON(atomic_read(&src->refcount) == 0);
-		atomic_inc(&src->refcount);
+		BUG_ON(atomic_read_ioc_refcount(src) == 0);
+		atomic_inc_ioc_refcount(src);
 		put_io_context(dst);
 		*pdst = src;
 	}
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a55a9bd..42d5018 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1282,7 +1282,7 @@ static void cfq_dispatch_request(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	if (!cfqd->active_cic) {
 		struct cfq_io_context *cic = RQ_CIC(rq);
 
-		atomic_inc(&cic->ioc->refcount);
+		atomic_inc_ioc_refcount(cic->ioc);
 		cfqd->active_cic = cic;
 	}
 }
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 08b987b..bdc7156 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -64,7 +64,11 @@ struct cfq_io_context {
  * and kmalloc'ed. These could be shared between processes.
  */
 struct io_context {
+#ifdef CONFIG_64BIT
+	atomic64_t refcount;
+#else
 	atomic_t refcount;
+#endif
 	atomic_t nr_tasks;
 
 	/* all the fields below are protected by this lock */
@@ -85,14 +89,30 @@ struct io_context {
 	void *ioc_data;
 };
 
+#ifdef CONFIG_64BIT
+
+#define atomic_read_ioc_refcount(ioc)	atomic64_read(&ioc->refcount)
+#define atomic_inc_ioc_refcount(ioc)	atomic64_inc(&ioc->refcount)
+#define atomic_dec_and_test_ioc_refcount(ioc)	atomic64_dec_and_test(&ioc->refcount)
+#define atomic_inc_not_zero_ioc_refcount(ioc)	atomic64_inc_not_zero(&ioc->refcount)
+
+#else
+
+#define atomic_read_ioc_refcount(ioc)	atomic_read(&ioc->refcount)
+#define atomic_inc_ioc_refcount(ioc)	atomic_inc(&ioc->refcount)
+#define atomic_dec_and_test_ioc_refcount(ioc)	atomic_dec_and_test(&ioc->refcount)
+#define atomic_inc_not_zero_ioc_refcount(ioc)	atomic_inc_not_zero(&ioc->refcount)
+
+#endif
+
 static inline struct io_context *ioc_task_link(struct io_context *ioc)
 {
 	/*
 	 * if ref count is zero, don't allow sharing (ioc is going away, it's
 	 * a race).
 	 */
-	if (ioc && atomic_inc_not_zero(&ioc->refcount)) {
-		atomic_inc(&ioc->nr_tasks);
+	if (ioc && atomic_inc_not_zero_ioc_refcount(ioc)) {
+		atomic_inc_ioc_refcount(ioc);
 		return ioc;
 	}
 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbZD2GyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbZD2GyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZD2Gx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:53:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbZD2Gx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:53:58 -0400
From: Nikanth Karthikesan <knikanth@novell.com>
Organization: Novell
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH][RFC] Handle improbable possibility of io_context->refcount overflow
Date: Wed, 29 Apr 2009 12:21:39 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904291221.40361.knikanth@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens

Currently io_context has an atomic_t(int) as refcount. In case of cfq, for
each device a task does I/O, a reference to the io_context would be taken. And
when there are multiple process sharing io_contexts(CLONE_IO) would also have
a reference to the same io_context. Theoretically the possible maximum number
of processes sharing the same io_context + the number of disks/cfq_data
referring to the same io_context can overflow the 32-bit counter on a very
high-end machine. Even though it is an improbable case, let us make it
difficult by changing the refcount to atomic64_t(long).

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 012f065..4f5ff79 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -35,9 +35,9 @@ int put_io_context(struct io_context *ioc)
 	if (ioc == NULL)
 		return 1;
 
-	BUG_ON(atomic_read(&ioc->refcount) == 0);
+	BUG_ON(atomic64_read(&ioc->refcount) == 0);
 
-	if (atomic_dec_and_test(&ioc->refcount)) {
+	if (atomic64_dec_and_test(&ioc->refcount)) {
 		rcu_read_lock();
 		if (ioc->aic && ioc->aic->dtor)
 			ioc->aic->dtor(ioc->aic);
@@ -151,7 +151,7 @@ struct io_context *get_io_context(gfp_t gfp_flags, int node)
 		ret = current_io_context(gfp_flags, node);
 		if (unlikely(!ret))
 			break;
-	} while (!atomic_inc_not_zero(&ret->refcount));
+	} while (!atomic64_inc_not_zero(&ret->refcount));
 
 	return ret;
 }
@@ -163,8 +163,8 @@ void copy_io_context(struct io_context **pdst, struct io_context **psrc)
 	struct io_context *dst = *pdst;
 
 	if (src) {
-		BUG_ON(atomic_read(&src->refcount) == 0);
-		atomic_inc(&src->refcount);
+		BUG_ON(atomic64_read(&src->refcount) == 0);
+		atomic64_inc(&src->refcount);
 		put_io_context(dst);
 		*pdst = src;
 	}
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a55a9bd..f829bd2 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1282,7 +1282,7 @@ static void cfq_dispatch_request(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	if (!cfqd->active_cic) {
 		struct cfq_io_context *cic = RQ_CIC(rq);
 
-		atomic_inc(&cic->ioc->refcount);
+		atomic64_inc(&cic->ioc->refcount);
 		cfqd->active_cic = cic;
 	}
 }
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 08b987b..f1a57f4 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -64,7 +64,7 @@ struct cfq_io_context {
  * and kmalloc'ed. These could be shared between processes.
  */
 struct io_context {
-	atomic_t refcount;
+	atomic64_t refcount;
 	atomic_t nr_tasks;
 
 	/* all the fields below are protected by this lock */
@@ -91,7 +91,7 @@ static inline struct io_context *ioc_task_link(struct io_context *ioc)
 	 * if ref count is zero, don't allow sharing (ioc is going away, it's
 	 * a race).
 	 */
-	if (ioc && atomic_inc_not_zero(&ioc->refcount)) {
+	if (ioc && atomic64_inc_not_zero(&ioc->refcount)) {
 		atomic_inc(&ioc->nr_tasks);
 		return ioc;
 	}


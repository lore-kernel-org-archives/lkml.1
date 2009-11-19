Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbZKSRVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbZKSRVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZKSRVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:21:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232AbZKSRVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:21:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/28] FS-Cache: Permit cache retrieval ops to be interrupted
	in the initial wait phase
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:21:40 +0000
Message-ID: <20091119172140.1679.45635.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Permit the operations to retrieve data from the cache or to allocate space in
the cache for future writes to be interrupted whilst they're waiting for
permission for the operation to proceed.  Typically this wait occurs whilst the
cache object is being looked up on disk in the background.

If an interruption occurs, and the operation has not yet been given the
go-ahead to run, the operation is dequeued and cancelled, and control returns
to the read operation of the netfs routine with none of the requested pages
having been read or in any way marked as known by the cache.

This means that the initial wait is done interruptibly rather than
uninterruptibly.

In addition, extra stats values are made available to show the number of ops
cancelled and the number of cache space allocations interrupted.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/caching/fscache.txt |    2 +
 fs/fscache/internal.h                         |    3 +
 fs/fscache/operation.c                        |   82 ++++++++++++++++---------
 fs/fscache/page.c                             |   55 +++++++++++++++--
 fs/fscache/stats.c                            |   12 ++--
 5 files changed, 115 insertions(+), 39 deletions(-)

diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
index 472398f..21d20bf 100644
--- a/Documentation/filesystems/caching/fscache.txt
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -250,6 +250,7 @@ proc files.
 		ok=N	Number of successful alloc reqs
 		wt=N	Number of alloc reqs that waited on lookup completion
 		nbf=N	Number of alloc reqs rejected -ENOBUFS
+		int=N	Number of alloc reqs aborted -ERESTARTSYS
 		ops=N	Number of alloc reqs submitted
 		owt=N	Number of alloc reqs waited for CPU time
 	Retrvls	n=N	Number of retrieval (read) requests seen
@@ -271,6 +272,7 @@ proc files.
 	Ops	pend=N	Number of times async ops added to pending queues
 		run=N	Number of times async ops given CPU time
 		enq=N	Number of times async ops queued for processing
+		can=N	Number of async ops cancelled
 		dfr=N	Number of async ops queued for deferred release
 		rel=N	Number of async ops released
 		gc=N	Number of deferred-release async ops garbage collected
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index b85cc89..50324ad 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -112,6 +112,7 @@ extern int fscache_submit_exclusive_op(struct fscache_object *,
 				       struct fscache_operation *);
 extern int fscache_submit_op(struct fscache_object *,
 			     struct fscache_operation *);
+extern int fscache_cancel_op(struct fscache_operation *);
 extern void fscache_abort_object(struct fscache_object *);
 extern void fscache_start_operations(struct fscache_object *);
 extern void fscache_operation_gc(struct work_struct *);
@@ -140,6 +141,7 @@ extern atomic_t fscache_n_op_enqueue;
 extern atomic_t fscache_n_op_deferred_release;
 extern atomic_t fscache_n_op_release;
 extern atomic_t fscache_n_op_gc;
+extern atomic_t fscache_n_op_cancelled;
 
 extern atomic_t fscache_n_attr_changed;
 extern atomic_t fscache_n_attr_changed_ok;
@@ -151,6 +153,7 @@ extern atomic_t fscache_n_allocs;
 extern atomic_t fscache_n_allocs_ok;
 extern atomic_t fscache_n_allocs_wait;
 extern atomic_t fscache_n_allocs_nobufs;
+extern atomic_t fscache_n_allocs_intr;
 extern atomic_t fscache_n_alloc_ops;
 extern atomic_t fscache_n_alloc_op_waits;
 
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index 09e43b6..296492e 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -34,32 +34,31 @@ void fscache_enqueue_operation(struct fscache_operation *op)
 
 	fscache_set_op_state(op, "EnQ");
 
+	ASSERT(list_empty(&op->pend_link));
 	ASSERT(op->processor != NULL);
 	ASSERTCMP(op->object->state, >=, FSCACHE_OBJECT_AVAILABLE);
 	ASSERTCMP(atomic_read(&op->usage), >, 0);
 
-	if (list_empty(&op->pend_link)) {
-		switch (op->flags & FSCACHE_OP_TYPE) {
-		case FSCACHE_OP_FAST:
-			_debug("queue fast");
-			atomic_inc(&op->usage);
-			if (!schedule_work(&op->fast_work))
-				fscache_put_operation(op);
-			break;
-		case FSCACHE_OP_SLOW:
-			_debug("queue slow");
-			slow_work_enqueue(&op->slow_work);
-			break;
-		case FSCACHE_OP_MYTHREAD:
-			_debug("queue for caller's attention");
-			break;
-		default:
-			printk(KERN_ERR "FS-Cache: Unexpected op type %lx",
-			       op->flags);
-			BUG();
-			break;
-		}
-		fscache_stat(&fscache_n_op_enqueue);
+	fscache_stat(&fscache_n_op_enqueue);
+	switch (op->flags & FSCACHE_OP_TYPE) {
+	case FSCACHE_OP_FAST:
+		_debug("queue fast");
+		atomic_inc(&op->usage);
+		if (!schedule_work(&op->fast_work))
+			fscache_put_operation(op);
+		break;
+	case FSCACHE_OP_SLOW:
+		_debug("queue slow");
+		slow_work_enqueue(&op->slow_work);
+		break;
+	case FSCACHE_OP_MYTHREAD:
+		_debug("queue for caller's attention");
+		break;
+	default:
+		printk(KERN_ERR "FS-Cache: Unexpected op type %lx",
+		       op->flags);
+		BUG();
+		break;
 	}
 }
 EXPORT_SYMBOL(fscache_enqueue_operation);
@@ -97,6 +96,7 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 	spin_lock(&object->lock);
 	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
 	ASSERTCMP(object->n_ops, >=, object->n_exclusive);
+	ASSERT(list_empty(&op->pend_link));
 
 	ret = -ENOBUFS;
 	if (fscache_object_is_active(object)) {
@@ -202,6 +202,7 @@ int fscache_submit_op(struct fscache_object *object,
 	spin_lock(&object->lock);
 	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
 	ASSERTCMP(object->n_ops, >=, object->n_exclusive);
+	ASSERT(list_empty(&op->pend_link));
 
 	ostate = object->state;
 	smp_rmb();
@@ -273,12 +274,7 @@ void fscache_start_operations(struct fscache_object *object)
 			stop = true;
 		}
 		list_del_init(&op->pend_link);
-		object->n_in_progress++;
-
-		if (test_and_clear_bit(FSCACHE_OP_WAITING, &op->flags))
-			wake_up_bit(&op->flags, FSCACHE_OP_WAITING);
-		if (op->processor)
-			fscache_enqueue_operation(op);
+		fscache_run_op(object, op);
 
 		/* the pending queue was holding a ref on the object */
 		fscache_put_operation(op);
@@ -291,6 +287,36 @@ void fscache_start_operations(struct fscache_object *object)
 }
 
 /*
+ * cancel an operation that's pending on an object
+ */
+int fscache_cancel_op(struct fscache_operation *op)
+{
+	struct fscache_object *object = op->object;
+	int ret;
+
+	_enter("OBJ%x OP%x}", op->object->debug_id, op->debug_id);
+
+	spin_lock(&object->lock);
+
+	ret = -EBUSY;
+	if (!list_empty(&op->pend_link)) {
+		fscache_stat(&fscache_n_op_cancelled);
+		list_del_init(&op->pend_link);
+		object->n_ops--;
+		if (test_bit(FSCACHE_OP_EXCLUSIVE, &op->flags))
+			object->n_exclusive--;
+		if (test_and_clear_bit(FSCACHE_OP_WAITING, &op->flags))
+			wake_up_bit(&op->flags, FSCACHE_OP_WAITING);
+		fscache_put_operation(op);
+		ret = 0;
+	}
+
+	spin_unlock(&object->lock);
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
  * release an operation
  * - queues pending ops if this is the last in-progress op
  */
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 250dfd3..e6f2e61 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -295,8 +295,20 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 	if (test_bit(FSCACHE_OP_WAITING, &op->op.flags)) {
 		_debug(">>> WT");
 		fscache_stat(&fscache_n_retrieval_op_waits);
-		wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
-			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+		if (wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+				fscache_wait_bit_interruptible,
+				TASK_INTERRUPTIBLE) < 0) {
+			ret = fscache_cancel_op(&op->op);
+			if (ret == 0) {
+				ret = -ERESTARTSYS;
+				goto error;
+			}
+
+			/* it's been removed from the pending queue by another
+			 * party, so we should get to run shortly */
+			wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+				    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+		}
 		_debug("<<< GO");
 	}
 
@@ -313,6 +325,7 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 		fscache_stat_d(&fscache_n_cop_read_or_alloc_page);
 	}
 
+error:
 	if (ret == -ENOMEM)
 		fscache_stat(&fscache_n_retrievals_nomem);
 	else if (ret == -ERESTARTSYS)
@@ -412,8 +425,20 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 	if (test_bit(FSCACHE_OP_WAITING, &op->op.flags)) {
 		_debug(">>> WT");
 		fscache_stat(&fscache_n_retrieval_op_waits);
-		wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
-			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+		if (wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+				fscache_wait_bit_interruptible,
+				TASK_INTERRUPTIBLE) < 0) {
+			ret = fscache_cancel_op(&op->op);
+			if (ret == 0) {
+				ret = -ERESTARTSYS;
+				goto error;
+			}
+
+			/* it's been removed from the pending queue by another
+			 * party, so we should get to run shortly */
+			wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+				    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+		}
 		_debug("<<< GO");
 	}
 
@@ -430,6 +455,7 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 		fscache_stat_d(&fscache_n_cop_read_or_alloc_pages);
 	}
 
+error:
 	if (ret == -ENOMEM)
 		fscache_stat(&fscache_n_retrievals_nomem);
 	else if (ret == -ERESTARTSYS)
@@ -505,8 +531,20 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 	if (test_bit(FSCACHE_OP_WAITING, &op->op.flags)) {
 		_debug(">>> WT");
 		fscache_stat(&fscache_n_alloc_op_waits);
-		wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
-			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+		if (wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+				fscache_wait_bit_interruptible,
+				TASK_INTERRUPTIBLE) < 0) {
+			ret = fscache_cancel_op(&op->op);
+			if (ret == 0) {
+				ret = -ERESTARTSYS;
+				goto error;
+			}
+
+			/* it's been removed from the pending queue by another
+			 * party, so we should get to run shortly */
+			wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+				    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+		}
 		_debug("<<< GO");
 	}
 
@@ -515,7 +553,10 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 	ret = object->cache->ops->allocate_page(op, page, gfp);
 	fscache_stat_d(&fscache_n_cop_allocate_page);
 
-	if (ret < 0)
+error:
+	if (ret == -ERESTARTSYS)
+		fscache_stat(&fscache_n_allocs_intr);
+	else if (ret < 0)
 		fscache_stat(&fscache_n_allocs_nobufs);
 	else
 		fscache_stat(&fscache_n_allocs_ok);
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 20233fb..4c07439 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -25,6 +25,7 @@ atomic_t fscache_n_op_requeue;
 atomic_t fscache_n_op_deferred_release;
 atomic_t fscache_n_op_release;
 atomic_t fscache_n_op_gc;
+atomic_t fscache_n_op_cancelled;
 
 atomic_t fscache_n_attr_changed;
 atomic_t fscache_n_attr_changed_ok;
@@ -36,6 +37,7 @@ atomic_t fscache_n_allocs;
 atomic_t fscache_n_allocs_ok;
 atomic_t fscache_n_allocs_wait;
 atomic_t fscache_n_allocs_nobufs;
+atomic_t fscache_n_allocs_intr;
 atomic_t fscache_n_alloc_ops;
 atomic_t fscache_n_alloc_op_waits;
 
@@ -169,11 +171,12 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&fscache_n_attr_changed_nomem),
 		   atomic_read(&fscache_n_attr_changed_calls));
 
-	seq_printf(m, "Allocs : n=%u ok=%u wt=%u nbf=%u\n",
+	seq_printf(m, "Allocs : n=%u ok=%u wt=%u nbf=%u int=%u\n",
 		   atomic_read(&fscache_n_allocs),
 		   atomic_read(&fscache_n_allocs_ok),
 		   atomic_read(&fscache_n_allocs_wait),
-		   atomic_read(&fscache_n_allocs_nobufs));
+		   atomic_read(&fscache_n_allocs_nobufs),
+		   atomic_read(&fscache_n_allocs_intr));
 	seq_printf(m, "Allocs : ops=%u owt=%u\n",
 		   atomic_read(&fscache_n_alloc_ops),
 		   atomic_read(&fscache_n_alloc_op_waits));
@@ -201,10 +204,11 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&fscache_n_store_ops),
 		   atomic_read(&fscache_n_store_calls));
 
-	seq_printf(m, "Ops    : pend=%u run=%u enq=%u\n",
+	seq_printf(m, "Ops    : pend=%u run=%u enq=%u can=%u\n",
 		   atomic_read(&fscache_n_op_pend),
 		   atomic_read(&fscache_n_op_run),
-		   atomic_read(&fscache_n_op_enqueue));
+		   atomic_read(&fscache_n_op_enqueue),
+		   atomic_read(&fscache_n_op_cancelled));
 	seq_printf(m, "Ops    : dfr=%u rel=%u gc=%u\n",
 		   atomic_read(&fscache_n_op_deferred_release),
 		   atomic_read(&fscache_n_op_release),


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZKSRWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZKSRWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbZKSRWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:22:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbZKSRW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:22:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/28] FS-Cache: Start processing an object's operations on
	that object's death
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:22:21 +0000
Message-ID: <20091119172221.1679.57689.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start processing an object's operations when that object moves into the DYING
state as the object cannot be destroyed until all its outstanding operations
have completed.

Furthermore, make sure that read and allocation operations handle being woken
up on a dead object.  Such events are recorded in the Allocs.abt and
Retrvls.abt statistics as viewable through /proc/fs/fscache/stats.

The code for waiting for object activation for the read and allocation
operations is also extracted into its own function as it is much the same in
all cases, differing only in the stats incremented.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/caching/fscache.txt |    2 
 fs/fscache/internal.h                         |    5 +
 fs/fscache/object.c                           |    1 
 fs/fscache/page.c                             |  112 ++++++++++++-------------
 fs/fscache/stats.c                            |   12 ++-
 include/linux/fscache-cache.h                 |    4 +
 6 files changed, 75 insertions(+), 61 deletions(-)

diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
index 655569e..692ffef 100644
--- a/Documentation/filesystems/caching/fscache.txt
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -253,6 +253,7 @@ proc files.
 		int=N	Number of alloc reqs aborted -ERESTARTSYS
 		ops=N	Number of alloc reqs submitted
 		owt=N	Number of alloc reqs waited for CPU time
+		abt=N	Number of alloc reqs aborted due to object death
 	Retrvls	n=N	Number of retrieval (read) requests seen
 		ok=N	Number of successful retr reqs
 		wt=N	Number of retr reqs that waited on lookup completion
@@ -262,6 +263,7 @@ proc files.
 		oom=N	Number of retr reqs failed -ENOMEM
 		ops=N	Number of retr reqs submitted
 		owt=N	Number of retr reqs waited for CPU time
+		abt=N	Number of retr reqs aborted due to object death
 	Stores	n=N	Number of storage (write) requests seen
 		ok=N	Number of successful store reqs
 		agn=N	Number of store reqs on a page already pending storage
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 2bf463d..5b49a37 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -156,6 +156,7 @@ extern atomic_t fscache_n_allocs_ok;
 extern atomic_t fscache_n_allocs_wait;
 extern atomic_t fscache_n_allocs_nobufs;
 extern atomic_t fscache_n_allocs_intr;
+extern atomic_t fscache_n_allocs_object_dead;
 extern atomic_t fscache_n_alloc_ops;
 extern atomic_t fscache_n_alloc_op_waits;
 
@@ -166,6 +167,7 @@ extern atomic_t fscache_n_retrievals_nodata;
 extern atomic_t fscache_n_retrievals_nobufs;
 extern atomic_t fscache_n_retrievals_intr;
 extern atomic_t fscache_n_retrievals_nomem;
+extern atomic_t fscache_n_retrievals_object_dead;
 extern atomic_t fscache_n_retrieval_ops;
 extern atomic_t fscache_n_retrieval_op_waits;
 
@@ -249,9 +251,12 @@ static inline void fscache_stat_d(atomic_t *stat)
 	atomic_dec(stat);
 }
 
+#define __fscache_stat(stat) (stat)
+
 extern const struct file_operations fscache_stats_fops;
 #else
 
+#define __fscache_stat(stat) (NULL)
 #define fscache_stat(stat) do {} while (0)
 #endif
 
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index 74bc562..c85c9f5 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -201,6 +201,7 @@ static void fscache_object_state_machine(struct fscache_object *object)
 		}
 		spin_unlock(&object->lock);
 		fscache_enqueue_dependents(object);
+		fscache_start_operations(object);
 		goto terminal_transit;
 
 		/* handle an abort during initialisation */
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index fc76798..c598ea4 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -314,6 +314,43 @@ static int fscache_wait_for_deferred_lookup(struct fscache_cookie *cookie)
 }
 
 /*
+ * wait for an object to become active (or dead)
+ */
+static int fscache_wait_for_retrieval_activation(struct fscache_object *object,
+						 struct fscache_retrieval *op,
+						 atomic_t *stat_op_waits,
+						 atomic_t *stat_object_dead)
+{
+	int ret;
+
+	if (!test_bit(FSCACHE_OP_WAITING, &op->op.flags))
+		goto check_if_dead;
+
+	_debug(">>> WT");
+	fscache_stat(stat_op_waits);
+	if (wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+			fscache_wait_bit_interruptible,
+			TASK_INTERRUPTIBLE) < 0) {
+		ret = fscache_cancel_op(&op->op);
+		if (ret == 0)
+			return -ERESTARTSYS;
+
+		/* it's been removed from the pending queue by another party,
+		 * so we should get to run shortly */
+		wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+	}
+	_debug("<<< GO");
+
+check_if_dead:
+	if (unlikely(fscache_object_is_dead(object))) {
+		fscache_stat(stat_object_dead);
+		return -ENOBUFS;
+	}
+	return 0;
+}
+
+/*
  * read a page from the cache or allocate a block in which to store it
  * - we return:
  *   -ENOMEM	- out of memory, nothing done
@@ -376,25 +413,12 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 
 	/* we wait for the operation to become active, and then process it
 	 * *here*, in this thread, and not in the thread pool */
-	if (test_bit(FSCACHE_OP_WAITING, &op->op.flags)) {
-		_debug(">>> WT");
-		fscache_stat(&fscache_n_retrieval_op_waits);
-		if (wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
-				fscache_wait_bit_interruptible,
-				TASK_INTERRUPTIBLE) < 0) {
-			ret = fscache_cancel_op(&op->op);
-			if (ret == 0) {
-				ret = -ERESTARTSYS;
-				goto error;
-			}
-
-			/* it's been removed from the pending queue by another
-			 * party, so we should get to run shortly */
-			wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
-				    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
-		}
-		_debug("<<< GO");
-	}
+	ret = fscache_wait_for_retrieval_activation(
+		object, op,
+		__fscache_stat(&fscache_n_retrieval_op_waits),
+		__fscache_stat(&fscache_n_retrievals_object_dead));
+	if (ret < 0)
+		goto error;
 
 	/* ask the cache to honour the operation */
 	if (test_bit(FSCACHE_COOKIE_NO_DATA_YET, &object->cookie->flags)) {
@@ -506,25 +530,12 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 
 	/* we wait for the operation to become active, and then process it
 	 * *here*, in this thread, and not in the thread pool */
-	if (test_bit(FSCACHE_OP_WAITING, &op->op.flags)) {
-		_debug(">>> WT");
-		fscache_stat(&fscache_n_retrieval_op_waits);
-		if (wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
-				fscache_wait_bit_interruptible,
-				TASK_INTERRUPTIBLE) < 0) {
-			ret = fscache_cancel_op(&op->op);
-			if (ret == 0) {
-				ret = -ERESTARTSYS;
-				goto error;
-			}
-
-			/* it's been removed from the pending queue by another
-			 * party, so we should get to run shortly */
-			wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
-				    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
-		}
-		_debug("<<< GO");
-	}
+	ret = fscache_wait_for_retrieval_activation(
+		object, op,
+		__fscache_stat(&fscache_n_retrieval_op_waits),
+		__fscache_stat(&fscache_n_retrievals_object_dead));
+	if (ret < 0)
+		goto error;
 
 	/* ask the cache to honour the operation */
 	if (test_bit(FSCACHE_COOKIE_NO_DATA_YET, &object->cookie->flags)) {
@@ -612,25 +623,12 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 
 	fscache_stat(&fscache_n_alloc_ops);
 
-	if (test_bit(FSCACHE_OP_WAITING, &op->op.flags)) {
-		_debug(">>> WT");
-		fscache_stat(&fscache_n_alloc_op_waits);
-		if (wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
-				fscache_wait_bit_interruptible,
-				TASK_INTERRUPTIBLE) < 0) {
-			ret = fscache_cancel_op(&op->op);
-			if (ret == 0) {
-				ret = -ERESTARTSYS;
-				goto error;
-			}
-
-			/* it's been removed from the pending queue by another
-			 * party, so we should get to run shortly */
-			wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
-				    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
-		}
-		_debug("<<< GO");
-	}
+	ret = fscache_wait_for_retrieval_activation(
+		object, op,
+		__fscache_stat(&fscache_n_alloc_op_waits),
+		__fscache_stat(&fscache_n_allocs_object_dead));
+	if (ret < 0)
+		goto error;
 
 	/* ask the cache to honour the operation */
 	fscache_stat(&fscache_n_cop_allocate_page);
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 9e15289..05f77ca 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -39,6 +39,7 @@ atomic_t fscache_n_allocs_ok;
 atomic_t fscache_n_allocs_wait;
 atomic_t fscache_n_allocs_nobufs;
 atomic_t fscache_n_allocs_intr;
+atomic_t fscache_n_allocs_object_dead;
 atomic_t fscache_n_alloc_ops;
 atomic_t fscache_n_alloc_op_waits;
 
@@ -49,6 +50,7 @@ atomic_t fscache_n_retrievals_nodata;
 atomic_t fscache_n_retrievals_nobufs;
 atomic_t fscache_n_retrievals_intr;
 atomic_t fscache_n_retrievals_nomem;
+atomic_t fscache_n_retrievals_object_dead;
 atomic_t fscache_n_retrieval_ops;
 atomic_t fscache_n_retrieval_op_waits;
 
@@ -188,9 +190,10 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&fscache_n_allocs_wait),
 		   atomic_read(&fscache_n_allocs_nobufs),
 		   atomic_read(&fscache_n_allocs_intr));
-	seq_printf(m, "Allocs : ops=%u owt=%u\n",
+	seq_printf(m, "Allocs : ops=%u owt=%u abt=%u\n",
 		   atomic_read(&fscache_n_alloc_ops),
-		   atomic_read(&fscache_n_alloc_op_waits));
+		   atomic_read(&fscache_n_alloc_op_waits),
+		   atomic_read(&fscache_n_allocs_object_dead));
 
 	seq_printf(m, "Retrvls: n=%u ok=%u wt=%u nod=%u nbf=%u"
 		   " int=%u oom=%u\n",
@@ -201,9 +204,10 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&fscache_n_retrievals_nobufs),
 		   atomic_read(&fscache_n_retrievals_intr),
 		   atomic_read(&fscache_n_retrievals_nomem));
-	seq_printf(m, "Retrvls: ops=%u owt=%u\n",
+	seq_printf(m, "Retrvls: ops=%u owt=%u abt=%u\n",
 		   atomic_read(&fscache_n_retrieval_ops),
-		   atomic_read(&fscache_n_retrieval_op_waits));
+		   atomic_read(&fscache_n_retrieval_op_waits),
+		   atomic_read(&fscache_n_retrievals_object_dead));
 
 	seq_printf(m, "Stores : n=%u ok=%u agn=%u nbf=%u oom=%u\n",
 		   atomic_read(&fscache_n_stores),
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 4750d5f..907bb56 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -404,6 +404,10 @@ extern const char *fscache_object_states[];
 	 (obj)->state >= FSCACHE_OBJECT_AVAILABLE &&	      \
 	 (obj)->state < FSCACHE_OBJECT_DYING)
 
+#define fscache_object_is_dead(obj)				\
+	(test_bit(FSCACHE_IOERROR, &(obj)->cache->flags) &&	\
+	 (obj)->state >= FSCACHE_OBJECT_DYING)
+
 extern const struct slow_work_ops fscache_object_slow_work_ops;
 
 /**


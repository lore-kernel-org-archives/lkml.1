Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZKSRZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZKSRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZKSRZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:25:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbZKSRVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:21:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/28] FS-Cache: Annotate slow-work runqueue proc lines for
	FS-Cache work items
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:21:15 +0000
Message-ID: <20091119172115.1679.11301.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate slow-work runqueue proc lines for FS-Cache work items.  Objects
include the object ID and the state.  Operations include the object ID, the
operation ID and the operation type and state.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/object.c           |   41 ++++++++++++++++++++++++++++++++++++++++-
 fs/fscache/operation.c        |   29 +++++++++++++++++++++++++++++
 fs/fscache/page.c             |   27 ++++++++++++++++++++++-----
 include/linux/fscache-cache.h |   12 ++++++++++++
 4 files changed, 103 insertions(+), 6 deletions(-)

diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index d236eb1..615b63d 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -14,9 +14,10 @@
 
 #define FSCACHE_DEBUG_LEVEL COOKIE
 #include <linux/module.h>
+#include <linux/seq_file.h>
 #include "internal.h"
 
-const char *fscache_object_states[] = {
+const char *fscache_object_states[FSCACHE_OBJECT__NSTATES] = {
 	[FSCACHE_OBJECT_INIT]		= "OBJECT_INIT",
 	[FSCACHE_OBJECT_LOOKING_UP]	= "OBJECT_LOOKING_UP",
 	[FSCACHE_OBJECT_CREATING]	= "OBJECT_CREATING",
@@ -33,9 +34,28 @@ const char *fscache_object_states[] = {
 };
 EXPORT_SYMBOL(fscache_object_states);
 
+static const char fscache_object_states_short[FSCACHE_OBJECT__NSTATES][5] = {
+	[FSCACHE_OBJECT_INIT]		= "INIT",
+	[FSCACHE_OBJECT_LOOKING_UP]	= "LOOK",
+	[FSCACHE_OBJECT_CREATING]	= "CRTN",
+	[FSCACHE_OBJECT_AVAILABLE]	= "AVBL",
+	[FSCACHE_OBJECT_ACTIVE]		= "ACTV",
+	[FSCACHE_OBJECT_UPDATING]	= "UPDT",
+	[FSCACHE_OBJECT_DYING]		= "DYNG",
+	[FSCACHE_OBJECT_LC_DYING]	= "LCDY",
+	[FSCACHE_OBJECT_ABORT_INIT]	= "ABTI",
+	[FSCACHE_OBJECT_RELEASING]	= "RELS",
+	[FSCACHE_OBJECT_RECYCLING]	= "RCYC",
+	[FSCACHE_OBJECT_WITHDRAWING]	= "WTHD",
+	[FSCACHE_OBJECT_DEAD]		= "DEAD",
+};
+
 static void fscache_object_slow_work_put_ref(struct slow_work *);
 static int  fscache_object_slow_work_get_ref(struct slow_work *);
 static void fscache_object_slow_work_execute(struct slow_work *);
+#ifdef CONFIG_SLOW_WORK_PROC
+static void fscache_object_slow_work_desc(struct slow_work *, struct seq_file *);
+#endif
 static void fscache_initialise_object(struct fscache_object *);
 static void fscache_lookup_object(struct fscache_object *);
 static void fscache_object_available(struct fscache_object *);
@@ -49,6 +69,9 @@ const struct slow_work_ops fscache_object_slow_work_ops = {
 	.get_ref	= fscache_object_slow_work_get_ref,
 	.put_ref	= fscache_object_slow_work_put_ref,
 	.execute	= fscache_object_slow_work_execute,
+#ifdef CONFIG_SLOW_WORK_PROC
+	.desc		= fscache_object_slow_work_desc,
+#endif
 };
 EXPORT_SYMBOL(fscache_object_slow_work_ops);
 
@@ -327,6 +350,22 @@ static void fscache_object_slow_work_execute(struct slow_work *work)
 }
 
 /*
+ * describe an object for slow-work debugging
+ */
+#ifdef CONFIG_SLOW_WORK_PROC
+static void fscache_object_slow_work_desc(struct slow_work *work,
+					  struct seq_file *m)
+{
+	struct fscache_object *object =
+		container_of(work, struct fscache_object, work);
+
+	seq_printf(m, "FSC: OBJ%x: %s",
+		   object->debug_id,
+		   fscache_object_states_short[object->state]);
+}
+#endif
+
+/*
  * initialise an object
  * - check the specified object's parent to see if we can make use of it
  *   immediately to do a creation
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index f1a2857..91bbe6f 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -13,6 +13,7 @@
 
 #define FSCACHE_DEBUG_LEVEL OPERATION
 #include <linux/module.h>
+#include <linux/seq_file.h>
 #include "internal.h"
 
 atomic_t fscache_op_debug_id;
@@ -31,6 +32,8 @@ void fscache_enqueue_operation(struct fscache_operation *op)
 	_enter("{OBJ%x OP%x,%u}",
 	       op->object->debug_id, op->debug_id, atomic_read(&op->usage));
 
+	fscache_set_op_state(op, "EnQ");
+
 	ASSERT(op->processor != NULL);
 	ASSERTCMP(op->object->state, >=, FSCACHE_OBJECT_AVAILABLE);
 	ASSERTCMP(atomic_read(&op->usage), >, 0);
@@ -67,6 +70,8 @@ EXPORT_SYMBOL(fscache_enqueue_operation);
 static void fscache_run_op(struct fscache_object *object,
 			   struct fscache_operation *op)
 {
+	fscache_set_op_state(op, "Run");
+
 	object->n_in_progress++;
 	if (test_and_clear_bit(FSCACHE_OP_WAITING, &op->flags))
 		wake_up_bit(&op->flags, FSCACHE_OP_WAITING);
@@ -87,6 +92,8 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 
 	_enter("{OBJ%x OP%x},", object->debug_id, op->debug_id);
 
+	fscache_set_op_state(op, "SubmitX");
+
 	spin_lock(&object->lock);
 	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
 	ASSERTCMP(object->n_ops, >=, object->n_exclusive);
@@ -190,6 +197,8 @@ int fscache_submit_op(struct fscache_object *object,
 
 	ASSERTCMP(atomic_read(&op->usage), >, 0);
 
+	fscache_set_op_state(op, "Submit");
+
 	spin_lock(&object->lock);
 	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
 	ASSERTCMP(object->n_ops, >=, object->n_exclusive);
@@ -298,6 +307,8 @@ void fscache_put_operation(struct fscache_operation *op)
 	if (!atomic_dec_and_test(&op->usage))
 		return;
 
+	fscache_set_op_state(op, "Put");
+
 	_debug("PUT OP");
 	if (test_and_set_bit(FSCACHE_OP_DEAD, &op->flags))
 		BUG();
@@ -452,9 +463,27 @@ static void fscache_op_execute(struct slow_work *work)
 	_leave("");
 }
 
+/*
+ * describe an operation for slow-work debugging
+ */
+#ifdef CONFIG_SLOW_WORK_PROC
+static void fscache_op_desc(struct slow_work *work, struct seq_file *m)
+{
+	struct fscache_operation *op =
+		container_of(work, struct fscache_operation, slow_work);
+
+	seq_printf(m, "FSC: OBJ%x OP%x: %s/%s fl=%lx",
+		   op->object->debug_id, op->debug_id,
+		   op->name, op->state, op->flags);
+}
+#endif
+
 const struct slow_work_ops fscache_op_slow_work_ops = {
 	.owner		= THIS_MODULE,
 	.get_ref	= fscache_op_get_ref,
 	.put_ref	= fscache_op_put_ref,
 	.execute	= fscache_op_execute,
+#ifdef CONFIG_SLOW_WORK_PROC
+	.desc		= fscache_op_desc,
+#endif
 };
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 2568e0e..e8bbc39 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -63,14 +63,19 @@ static void fscache_end_page_write(struct fscache_cookie *cookie, struct page *p
 static void fscache_attr_changed_op(struct fscache_operation *op)
 {
 	struct fscache_object *object = op->object;
+	int ret;
 
 	_enter("{OBJ%x OP%x}", object->debug_id, op->debug_id);
 
 	fscache_stat(&fscache_n_attr_changed_calls);
 
-	if (fscache_object_is_active(object) &&
-	    object->cache->ops->attr_changed(object) < 0)
-		fscache_abort_object(object);
+	if (fscache_object_is_active(object)) {
+		fscache_set_op_state(op, "CallFS");
+		ret = object->cache->ops->attr_changed(object);
+		fscache_set_op_state(op, "Done");
+		if (ret < 0)
+			fscache_abort_object(object);
+	}
 
 	_leave("");
 }
@@ -99,6 +104,7 @@ int __fscache_attr_changed(struct fscache_cookie *cookie)
 	fscache_operation_init(op, NULL);
 	fscache_operation_init_slow(op, fscache_attr_changed_op);
 	op->flags = FSCACHE_OP_SLOW | (1 << FSCACHE_OP_EXCLUSIVE);
+	fscache_set_op_name(op, "Attr");
 
 	spin_lock(&cookie->lock);
 
@@ -184,6 +190,7 @@ static struct fscache_retrieval *fscache_alloc_retrieval(
 	op->start_time	= jiffies;
 	INIT_WORK(&op->op.fast_work, fscache_retrieval_work);
 	INIT_LIST_HEAD(&op->to_do);
+	fscache_set_op_name(&op->op, "Retr");
 	return op;
 }
 
@@ -257,6 +264,7 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 		_leave(" = -ENOMEM");
 		return -ENOMEM;
 	}
+	fscache_set_op_name(&op->op, "RetrRA1");
 
 	spin_lock(&cookie->lock);
 
@@ -369,6 +377,7 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 	op = fscache_alloc_retrieval(mapping, end_io_func, context);
 	if (!op)
 		return -ENOMEM;
+	fscache_set_op_name(&op->op, "RetrRAN");
 
 	spin_lock(&cookie->lock);
 
@@ -461,6 +470,7 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 	op = fscache_alloc_retrieval(page->mapping, NULL, NULL);
 	if (!op)
 		return -ENOMEM;
+	fscache_set_op_name(&op->op, "RetrAL1");
 
 	spin_lock(&cookie->lock);
 
@@ -529,6 +539,8 @@ static void fscache_write_op(struct fscache_operation *_op)
 
 	_enter("{OP%x,%d}", op->op.debug_id, atomic_read(&op->op.usage));
 
+	fscache_set_op_state(&op->op, "GetPage");
+
 	spin_lock(&cookie->lock);
 	spin_lock(&object->lock);
 
@@ -559,13 +571,17 @@ static void fscache_write_op(struct fscache_operation *_op)
 	spin_unlock(&cookie->lock);
 
 	if (page) {
+		fscache_set_op_state(&op->op, "Store");
 		ret = object->cache->ops->write_page(op, page);
+		fscache_set_op_state(&op->op, "EndWrite");
 		fscache_end_page_write(cookie, page);
 		page_cache_release(page);
-		if (ret < 0)
+		if (ret < 0) {
+			fscache_set_op_state(&op->op, "Abort");
 			fscache_abort_object(object);
-		else
+		} else {
 			fscache_enqueue_operation(&op->op);
+		}
 	}
 
 	_leave("");
@@ -634,6 +650,7 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	fscache_operation_init(&op->op, fscache_release_write_op);
 	fscache_operation_init_slow(&op->op, fscache_write_op);
 	op->op.flags = FSCACHE_OP_SLOW | (1 << FSCACHE_OP_WAITING);
+	fscache_set_op_name(&op->op, "Write1");
 
 	ret = radix_tree_preload(gfp & ~__GFP_HIGHMEM);
 	if (ret < 0)
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 84d3532..7a9847c 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -102,6 +102,16 @@ struct fscache_operation {
 
 	/* operation releaser */
 	fscache_operation_release_t release;
+
+#ifdef CONFIG_SLOW_WORK_PROC
+	const char *name;		/* operation name */
+	const char *state;		/* operation state */
+#define fscache_set_op_name(OP, N)	do { (OP)->name  = (N); } while(0)
+#define fscache_set_op_state(OP, S)	do { (OP)->state = (S); } while(0)
+#else
+#define fscache_set_op_name(OP, N)	do { } while(0)
+#define fscache_set_op_state(OP, S)	do { } while(0)
+#endif
 };
 
 extern atomic_t fscache_op_debug_id;
@@ -125,6 +135,7 @@ static inline void fscache_operation_init(struct fscache_operation *op,
 	op->debug_id = atomic_inc_return(&fscache_op_debug_id);
 	op->release = release;
 	INIT_LIST_HEAD(&op->pend_link);
+	fscache_set_op_state(op, "Init");
 }
 
 /**
@@ -337,6 +348,7 @@ struct fscache_object {
 		FSCACHE_OBJECT_RECYCLING,	/* retiring object */
 		FSCACHE_OBJECT_WITHDRAWING,	/* withdrawing object */
 		FSCACHE_OBJECT_DEAD,		/* object is now dead */
+		FSCACHE_OBJECT__NSTATES
 	} state;
 
 	int			debug_id;	/* debugging ID */


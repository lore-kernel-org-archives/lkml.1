Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbZGXQMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbZGXQMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZGXQM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:12:28 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51182 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbZGXQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:12:25 -0400
Subject: [PATCH 4/8] kmemleak: Save the stack trace for early allocations
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 24 Jul 2009 17:12:24 +0100
Message-ID: <20090724161224.5752.30441.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
References: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-9-gd8846
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2009 16:12:24.0564 (UTC) FILETIME=[87FE3340:01CA0C79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before slab is initialised, kmemleak save the allocations in an early
log buffer. They are later recorded as normal memory allocations. This
patch adds the stack trace saving to the early log buffer, otherwise the
information shown for such objects only refers to the kmemleak_init()
function.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 8eab0a7..7dcb898 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -229,6 +229,8 @@ struct early_log {
 	int min_count;			/* minimum reference count */
 	unsigned long offset;		/* scan area offset */
 	size_t length;			/* scan area length */
+	unsigned long trace[MAX_TRACE];	/* stack trace */
+	unsigned int trace_len;		/* stack trace length */
 };
 
 /* early logging buffer and current position */
@@ -437,21 +439,36 @@ static struct kmemleak_object *find_and_get_object(unsigned long ptr, int alias)
 }
 
 /*
+ * Save stack trace to the given array of MAX_TRACE size.
+ */
+static int __save_stack_trace(unsigned long *trace)
+{
+	struct stack_trace stack_trace;
+
+	stack_trace.max_entries = MAX_TRACE;
+	stack_trace.nr_entries = 0;
+	stack_trace.entries = trace;
+	stack_trace.skip = 2;
+	save_stack_trace(&stack_trace);
+
+	return stack_trace.nr_entries;
+}
+
+/*
  * Create the metadata (struct kmemleak_object) corresponding to an allocated
  * memory block and add it to the object_list and object_tree_root.
  */
-static void create_object(unsigned long ptr, size_t size, int min_count,
-			  gfp_t gfp)
+static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
+					     int min_count, gfp_t gfp)
 {
 	unsigned long flags;
 	struct kmemleak_object *object;
 	struct prio_tree_node *node;
-	struct stack_trace trace;
 
 	object = kmem_cache_alloc(object_cache, gfp & GFP_KMEMLEAK_MASK);
 	if (!object) {
 		kmemleak_stop("Cannot allocate a kmemleak_object structure\n");
-		return;
+		return NULL;
 	}
 
 	INIT_LIST_HEAD(&object->object_list);
@@ -485,12 +502,7 @@ static void create_object(unsigned long ptr, size_t size, int min_count,
 	}
 
 	/* kernel backtrace */
-	trace.max_entries = MAX_TRACE;
-	trace.nr_entries = 0;
-	trace.entries = object->trace;
-	trace.skip = 1;
-	save_stack_trace(&trace);
-	object->trace_len = trace.nr_entries;
+	object->trace_len = __save_stack_trace(object->trace);
 
 	INIT_PRIO_TREE_NODE(&object->tree_node);
 	object->tree_node.start = ptr;
@@ -521,6 +533,7 @@ static void create_object(unsigned long ptr, size_t size, int min_count,
 	list_add_tail_rcu(&object->object_list, &object_list);
 out:
 	write_unlock_irqrestore(&kmemleak_lock, flags);
+	return object;
 }
 
 /*
@@ -742,11 +755,39 @@ static void __init log_early(int op_type, const void *ptr, size_t size,
 	log->min_count = min_count;
 	log->offset = offset;
 	log->length = length;
+	if (op_type == KMEMLEAK_ALLOC)
+		log->trace_len = __save_stack_trace(log->trace);
 	crt_early_log++;
 	local_irq_restore(flags);
 }
 
 /*
+ * Log an early allocated block and populate the stack trace.
+ */
+static void early_alloc(struct early_log *log)
+{
+	struct kmemleak_object *object;
+	unsigned long flags;
+	int i;
+
+	if (!atomic_read(&kmemleak_enabled) || !log->ptr || IS_ERR(log->ptr))
+		return;
+
+	/*
+	 * RCU locking needed to ensure object is not freed via put_object().
+	 */
+	rcu_read_lock();
+	object = create_object((unsigned long)log->ptr, log->size,
+			       log->min_count, GFP_KERNEL);
+	spin_lock_irqsave(&object->lock, flags);
+	for (i = 0; i < log->trace_len; i++)
+		object->trace[i] = log->trace[i];
+	object->trace_len = log->trace_len;
+	spin_unlock_irqrestore(&object->lock, flags);
+	rcu_read_unlock();
+}
+
+/*
  * Memory allocation function callback. This function is called from the
  * kernel allocators when a new block is allocated (kmem_cache_alloc, kmalloc,
  * vmalloc etc.).
@@ -1507,8 +1548,7 @@ void __init kmemleak_init(void)
 
 		switch (log->op_type) {
 		case KMEMLEAK_ALLOC:
-			kmemleak_alloc(log->ptr, log->size, log->min_count,
-				       GFP_KERNEL);
+			early_alloc(log);
 			break;
 		case KMEMLEAK_FREE:
 			kmemleak_free(log->ptr);


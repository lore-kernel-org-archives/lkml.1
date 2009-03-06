Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZCFP5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZCFP5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbZCFP4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:56:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:35754 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303AbZCFP4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:56:05 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, npiggin@suse.de,
       akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] percpu: finer grained locking to break deadlock and allow atomic free
Date: Sat,  7 Mar 2009 00:54:43 +0900
Message-Id: <1236354883-25063-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236354883-25063-1-git-send-email-tj@kernel.org>
References: <1236354883-25063-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 15:54:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix deadlock and allow atomic free

Percpu allocation always uses GFP_KERNEL and whole alloc/free paths
were protected by single mutex.  All percpu allocations have been from
GFP_KERNEL-safe context and the original allocator had this assumption
too.  However, by protecting both alloc and free paths with the same
mutex, the new allocator creates free -> alloc -> GFP_KERNEL
dependency which the original allocator didn't have.  This can lead to
deadlock if free is called from FS or IO paths.  Also, in general,
allocators are expected to allow free to be called from atomic
context.

This patch implements finer grained locking to break the deadlock and
allow atomic free.  For details, please read the "Synchronization
rules" comment.

While at it, also add CONTEXT: to function comments to describe which
context they expect to be called from and what they do to it.

This problem was reported by Thomas Gleixner and Peter Zijlstra.

  http://thread.gmane.org/gmane.linux.kernel/802384

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Peter Zijlstra <peterz@infradead.org>
---
 mm/percpu.c |  160 +++++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 123 insertions(+), 37 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 4c8a419..d2cda3d 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -62,6 +62,7 @@
 #include <linux/pfn.h>
 #include <linux/rbtree.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
 
@@ -101,20 +102,28 @@ static struct pcpu_chunk *pcpu_reserved_chunk;
 static int pcpu_reserved_chunk_limit;
 
 /*
- * One mutex to rule them all.
- *
- * The following mutex is grabbed in the outermost public alloc/free
- * interface functions and released only when the operation is
- * complete.  As such, every function in this file other than the
- * outermost functions are called under pcpu_mutex.
- *
- * It can easily be switched to use spinlock such that only the area
- * allocation and page population commit are protected with it doing
- * actual [de]allocation without holding any lock.  However, given
- * what this allocator does, I think it's better to let them run
- * sequentially.
+ * Synchronization rules.
+ *
+ * There are two locks - pcpu_alloc_mutex and pcpu_lock.  The former
+ * protects allocation/reclaim paths, chunks and chunk->page arrays.
+ * The latter is a spinlock and protects the index data structures -
+ * chunk slots, rbtree, chunks and area maps in chunks.
+ *
+ * During allocation, pcpu_alloc_mutex is kept locked all the time and
+ * pcpu_lock is grabbed and released as necessary.  All actual memory
+ * allocations are done using GFP_KERNEL with pcpu_lock released.
+ *
+ * Free path accesses and alters only the index data structures, so it
+ * can be safely called from atomic context.  When memory needs to be
+ * returned to the system, free path schedules reclaim_work which
+ * grabs both pcpu_alloc_mutex and pcpu_lock, unlinks chunks to be
+ * reclaimed, release both locks and frees the chunks.  Note that it's
+ * necessary to grab both locks to remove a chunk from circulation as
+ * allocation path might be referencing the chunk with only
+ * pcpu_alloc_mutex locked.
  */
-static DEFINE_MUTEX(pcpu_mutex);
+static DEFINE_MUTEX(pcpu_alloc_mutex);	/* protects whole alloc and reclaim */
+static DEFINE_SPINLOCK(pcpu_lock);	/* protects index data structures */
 
 static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
 static struct rb_root pcpu_addr_root = RB_ROOT;	/* chunks by address */
@@ -176,6 +185,9 @@ static bool pcpu_chunk_page_occupied(struct pcpu_chunk *chunk,
  * kzalloc() is used; otherwise, vmalloc() is used.  The returned
  * memory is always zeroed.
  *
+ * CONTEXT:
+ * Does GFP_KERNEL allocation.
+ *
  * RETURNS:
  * Pointer to the allocated area on success, NULL on failure.
  */
@@ -215,6 +227,9 @@ static void pcpu_mem_free(void *ptr, size_t size)
  * New slot according to the changed state is determined and @chunk is
  * moved to the slot.  Note that the reserved chunk is never put on
  * chunk slots.
+ *
+ * CONTEXT:
+ * pcpu_lock.
  */
 static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
 {
@@ -260,6 +275,9 @@ static struct rb_node **pcpu_chunk_rb_search(void *addr,
  * searchs for the chunk with the highest start address which isn't
  * beyond @addr.
  *
+ * CONTEXT:
+ * pcpu_lock.
+ *
  * RETURNS:
  * The address of the found chunk.
  */
@@ -300,6 +318,9 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
  * @new: chunk to insert
  *
  * Insert @new into address rb tree.
+ *
+ * CONTEXT:
+ * pcpu_lock.
  */
 static void pcpu_chunk_addr_insert(struct pcpu_chunk *new)
 {
@@ -319,6 +340,10 @@ static void pcpu_chunk_addr_insert(struct pcpu_chunk *new)
  * A single allocation can split an area into three areas, so this
  * function makes sure that @chunk->map has at least two extra slots.
  *
+ * CONTEXT:
+ * pcpu_alloc_mutex, pcpu_lock.  pcpu_lock is released and reacquired
+ * if area map is extended.
+ *
  * RETURNS:
  * 0 if noop, 1 if successfully extended, -errno on failure.
  */
@@ -332,13 +357,25 @@ static int pcpu_extend_area_map(struct pcpu_chunk *chunk)
 	if (chunk->map_alloc >= chunk->map_used + 2)
 		return 0;
 
+	spin_unlock(&pcpu_lock);
+
 	new_alloc = PCPU_DFL_MAP_ALLOC;
 	while (new_alloc < chunk->map_used + 2)
 		new_alloc *= 2;
 
 	new = pcpu_mem_alloc(new_alloc * sizeof(new[0]));
-	if (!new)
+	if (!new) {
+		spin_lock(&pcpu_lock);
 		return -ENOMEM;
+	}
+
+	/*
+	 * Acquire pcpu_lock and switch to new area map.  Only free
+	 * could have happened inbetween, so map_used couldn't have
+	 * grown.
+	 */
+	spin_lock(&pcpu_lock);
+	BUG_ON(new_alloc < chunk->map_used + 2);
 
 	size = chunk->map_alloc * sizeof(chunk->map[0]);
 	memcpy(new, chunk->map, size);
@@ -371,6 +408,9 @@ static int pcpu_extend_area_map(struct pcpu_chunk *chunk)
  * is inserted after the target block.
  *
  * @chunk->map must have enough free slots to accomodate the split.
+ *
+ * CONTEXT:
+ * pcpu_lock.
  */
 static void pcpu_split_block(struct pcpu_chunk *chunk, int i,
 			     int head, int tail)
@@ -406,6 +446,9 @@ static void pcpu_split_block(struct pcpu_chunk *chunk, int i,
  *
  * @chunk->map must have at least two free slots.
  *
+ * CONTEXT:
+ * pcpu_lock.
+ *
  * RETURNS:
  * Allocated offset in @chunk on success, -1 if no matching area is
  * found.
@@ -495,6 +538,9 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
  * Free area starting from @freeme to @chunk.  Note that this function
  * only modifies the allocation map.  It doesn't depopulate or unmap
  * the area.
+ *
+ * CONTEXT:
+ * pcpu_lock.
  */
 static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme)
 {
@@ -580,6 +626,9 @@ static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
  * For each cpu, depopulate and unmap pages [@page_start,@page_end)
  * from @chunk.  If @flush is true, vcache is flushed before unmapping
  * and tlb after.
+ *
+ * CONTEXT:
+ * pcpu_alloc_mutex.
  */
 static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size,
 				  bool flush)
@@ -658,6 +707,9 @@ static int pcpu_map(struct pcpu_chunk *chunk, int page_start, int page_end)
  *
  * For each cpu, populate and map pages [@page_start,@page_end) into
  * @chunk.  The area is cleared on return.
+ *
+ * CONTEXT:
+ * pcpu_alloc_mutex, does GFP_KERNEL allocation.
  */
 static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 {
@@ -748,15 +800,16 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
  * @align: alignment of area (max PAGE_SIZE)
  * @reserved: allocate from the reserved chunk if available
  *
- * Allocate percpu area of @size bytes aligned at @align.  Might
- * sleep.  Might trigger writeouts.
+ * Allocate percpu area of @size bytes aligned at @align.
+ *
+ * CONTEXT:
+ * Does GFP_KERNEL allocation.
  *
  * RETURNS:
  * Percpu pointer to the allocated area on success, NULL on failure.
  */
 static void *pcpu_alloc(size_t size, size_t align, bool reserved)
 {
-	void *ptr = NULL;
 	struct pcpu_chunk *chunk;
 	int slot, off;
 
@@ -766,27 +819,37 @@ static void *pcpu_alloc(size_t size, size_t align, bool reserved)
 		return NULL;
 	}
 
-	mutex_lock(&pcpu_mutex);
+	mutex_lock(&pcpu_alloc_mutex);
+	spin_lock(&pcpu_lock);
 
 	/* serve reserved allocations from the reserved chunk if available */
 	if (reserved && pcpu_reserved_chunk) {
 		chunk = pcpu_reserved_chunk;
 		if (size > chunk->contig_hint ||
 		    pcpu_extend_area_map(chunk) < 0)
-			goto out_unlock;
+			goto fail_unlock;
 		off = pcpu_alloc_area(chunk, size, align);
 		if (off >= 0)
 			goto area_found;
-		goto out_unlock;
+		goto fail_unlock;
 	}
 
+restart:
 	/* search through normal chunks */
 	for (slot = pcpu_size_to_slot(size); slot < pcpu_nr_slots; slot++) {
 		list_for_each_entry(chunk, &pcpu_slot[slot], list) {
 			if (size > chunk->contig_hint)
 				continue;
-			if (pcpu_extend_area_map(chunk) < 0)
-				goto out_unlock;
+
+			switch (pcpu_extend_area_map(chunk)) {
+			case 0:
+				break;
+			case 1:
+				goto restart;	/* pcpu_lock dropped, restart */
+			default:
+				goto fail_unlock;
+			}
+
 			off = pcpu_alloc_area(chunk, size, align);
 			if (off >= 0)
 				goto area_found;
@@ -794,27 +857,36 @@ static void *pcpu_alloc(size_t size, size_t align, bool reserved)
 	}
 
 	/* hmmm... no space left, create a new chunk */
+	spin_unlock(&pcpu_lock);
+
 	chunk = alloc_pcpu_chunk();
 	if (!chunk)
-		goto out_unlock;
+		goto fail_unlock_mutex;
+
+	spin_lock(&pcpu_lock);
 	pcpu_chunk_relocate(chunk, -1);
 	pcpu_chunk_addr_insert(chunk);
-
-	off = pcpu_alloc_area(chunk, size, align);
-	if (off < 0)
-		goto out_unlock;
+	goto restart;
 
 area_found:
+	spin_unlock(&pcpu_lock);
+
 	/* populate, map and clear the area */
 	if (pcpu_populate_chunk(chunk, off, size)) {
+		spin_lock(&pcpu_lock);
 		pcpu_free_area(chunk, off);
-		goto out_unlock;
+		goto fail_unlock;
 	}
 
-	ptr = __addr_to_pcpu_ptr(chunk->vm->addr + off);
-out_unlock:
-	mutex_unlock(&pcpu_mutex);
-	return ptr;
+	mutex_unlock(&pcpu_alloc_mutex);
+
+	return __addr_to_pcpu_ptr(chunk->vm->addr + off);
+
+fail_unlock:
+	spin_unlock(&pcpu_lock);
+fail_unlock_mutex:
+	mutex_unlock(&pcpu_alloc_mutex);
+	return NULL;
 }
 
 /**
@@ -825,6 +897,9 @@ out_unlock:
  * Allocate percpu area of @size bytes aligned at @align.  Might
  * sleep.  Might trigger writeouts.
  *
+ * CONTEXT:
+ * Does GFP_KERNEL allocation.
+ *
  * RETURNS:
  * Percpu pointer to the allocated area on success, NULL on failure.
  */
@@ -843,6 +918,9 @@ EXPORT_SYMBOL_GPL(__alloc_percpu);
  * percpu area if arch has set it up; otherwise, allocation is served
  * from the same dynamic area.  Might sleep.  Might trigger writeouts.
  *
+ * CONTEXT:
+ * Does GFP_KERNEL allocation.
+ *
  * RETURNS:
  * Percpu pointer to the allocated area on success, NULL on failure.
  */
@@ -856,6 +934,9 @@ void *__alloc_reserved_percpu(size_t size, size_t align)
  * @work: unused
  *
  * Reclaim all fully free chunks except for the first one.
+ *
+ * CONTEXT:
+ * workqueue context.
  */
 static void pcpu_reclaim(struct work_struct *work)
 {
@@ -863,7 +944,8 @@ static void pcpu_reclaim(struct work_struct *work)
 	struct list_head *head = &pcpu_slot[pcpu_nr_slots - 1];
 	struct pcpu_chunk *chunk, *next;
 
-	mutex_lock(&pcpu_mutex);
+	mutex_lock(&pcpu_alloc_mutex);
+	spin_lock(&pcpu_lock);
 
 	list_for_each_entry_safe(chunk, next, head, list) {
 		WARN_ON(chunk->immutable);
@@ -876,7 +958,8 @@ static void pcpu_reclaim(struct work_struct *work)
 		list_move(&chunk->list, &todo);
 	}
 
-	mutex_unlock(&pcpu_mutex);
+	spin_unlock(&pcpu_lock);
+	mutex_unlock(&pcpu_alloc_mutex);
 
 	list_for_each_entry_safe(chunk, next, &todo, list) {
 		pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size, false);
@@ -888,7 +971,10 @@ static void pcpu_reclaim(struct work_struct *work)
  * free_percpu - free percpu area
  * @ptr: pointer to area to free
  *
- * Free percpu area @ptr.  Might sleep.
+ * Free percpu area @ptr.
+ *
+ * CONTEXT:
+ * Can be called from atomic context.
  */
 void free_percpu(void *ptr)
 {
@@ -899,7 +985,7 @@ void free_percpu(void *ptr)
 	if (!ptr)
 		return;
 
-	mutex_lock(&pcpu_mutex);
+	spin_lock(&pcpu_lock);
 
 	chunk = pcpu_chunk_addr_search(addr);
 	off = addr - chunk->vm->addr;
@@ -917,7 +1003,7 @@ void free_percpu(void *ptr)
 			}
 	}
 
-	mutex_unlock(&pcpu_mutex);
+	spin_unlock(&pcpu_lock);
 }
 EXPORT_SYMBOL_GPL(free_percpu);
 
-- 
1.6.0.2


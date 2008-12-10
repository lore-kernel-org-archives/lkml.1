Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbYLJSav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbYLJSav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbYLJS2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:28:02 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33241 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754791AbYLJS14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:27:56 -0500
Subject: [PATCH 01/15] kmemleak: Add the base support
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 10 Dec 2008 18:26:59 +0000
Message-ID: <20081210182659.30323.43898.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2008 18:26:59.0748 (UTC) FILETIME=[E3D1FE40:01C95AF4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the base support for the kernel memory leak
detector. It traces the memory allocation/freeing in a way similar to
the Boehm's conservative garbage collector, the difference being that
the unreferenced objects are not freed but only shown in
/sys/kernel/debug/memleak. Enabling this feature introduces an
overhead to memory allocations.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/memleak.h |   93 +++
 init/main.c             |    4 
 mm/memleak.c            | 1263 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1359 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/memleak.h
 create mode 100644 mm/memleak.c

diff --git a/include/linux/memleak.h b/include/linux/memleak.h
new file mode 100644
index 0000000..340b9fc
--- /dev/null
+++ b/include/linux/memleak.h
@@ -0,0 +1,93 @@
+/*
+ * include/linux/memleak.h
+ *
+ * Copyright (C) 2008 ARM Limited
+ * Written by Catalin Marinas <catalin.marinas@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#ifndef __MEMLEAK_H
+#define __MEMLEAK_H
+
+#ifdef CONFIG_DEBUG_MEMLEAK
+
+extern void memleak_init(void);
+extern void memleak_alloc(const void *ptr, size_t size, int min_count,
+			  gfp_t gfp);
+extern void memleak_free(const void *ptr);
+extern void memleak_padding(const void *ptr, unsigned long offset, size_t size);
+extern void memleak_not_leak(const void *ptr);
+extern void memleak_ignore(const void *ptr);
+extern void memleak_scan_area(const void *ptr, unsigned long offset,
+			      size_t length, gfp_t gfp);
+
+static inline void memleak_alloc_recursive(const void *ptr, size_t size,
+					   int min_count, unsigned long flags,
+					   gfp_t gfp)
+{
+	if (!(flags & SLAB_NOLEAKTRACE))
+		memleak_alloc(ptr, size, min_count, gfp);
+}
+
+static inline void memleak_free_recursive(const void *ptr, unsigned long flags)
+{
+	if (!(flags & SLAB_NOLEAKTRACE))
+		memleak_free(ptr);
+}
+
+static inline void memleak_erase(void **ptr)
+{
+	*ptr = NULL;
+}
+
+#else
+
+#define DECLARE_MEMLEAK_OFFSET(name, type, member)
+
+static inline void memleak_init(void)
+{
+}
+static inline void memleak_alloc(const void *ptr, size_t size, int min_count,
+				 gfp_t gfp)
+{
+}
+static inline void memleak_alloc_recursive(const void *ptr, size_t size,
+					   int min_count, unsigned long flags,
+					   gfp_t gfp)
+{
+}
+static inline void memleak_free(const void *ptr)
+{
+}
+static inline void memleak_free_recursive(const void *ptr, unsigned long flags)
+{
+}
+static inline void memleak_not_leak(const void *ptr)
+{
+}
+static inline void memleak_ignore(const void *ptr)
+{
+}
+static inline void memleak_scan_area(const void *ptr, unsigned long offset,
+				     size_t length, gfp_t gfp)
+{
+}
+static inline void memleak_erase(void **ptr)
+{
+}
+
+#endif	/* CONFIG_DEBUG_MEMLEAK */
+
+#endif	/* __MEMLEAK_H */
diff --git a/init/main.c b/init/main.c
index 7e117a2..81cbbb7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -56,6 +56,7 @@
 #include <linux/debug_locks.h>
 #include <linux/debugobjects.h>
 #include <linux/lockdep.h>
+#include <linux/memleak.h>
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
@@ -653,6 +654,8 @@ asmlinkage void __init start_kernel(void)
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
 	kmem_cache_init();
+	prio_tree_init();
+	memleak_init();
 	debug_objects_mem_init();
 	idr_init_cache();
 	setup_per_cpu_pageset();
@@ -662,7 +665,6 @@ asmlinkage void __init start_kernel(void)
 	calibrate_delay();
 	pidmap_init();
 	pgtable_cache_init();
-	prio_tree_init();
 	anon_vma_init();
 #ifdef CONFIG_X86
 	if (efi_enabled)
diff --git a/mm/memleak.c b/mm/memleak.c
new file mode 100644
index 0000000..bd84ee0
--- /dev/null
+++ b/mm/memleak.c
@@ -0,0 +1,1263 @@
+/*
+ * mm/memleak.c
+ *
+ * Copyright (C) 2008 ARM Limited
+ * Written by Catalin Marinas <catalin.marinas@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ *
+ * For more information on the algorithm and kmemleak usage, please see
+ * Documentation/kmemleak.txt.
+ *
+ * Notes on locking
+ * ----------------
+ *
+ * The following locks are used by kmemleak:
+ *
+ * - memleak_lock (rw_lock): protects the object_list modifications and
+ *   accesses to the object_tree_root. The object_list is the main
+ *   list holding the metadata (struct memleak_object) for the allocated
+ *   memory blocks. The object_tree_root is a priority search tree used to
+ *   look-up metadata based on a pointer to the corresponding memory block.
+ *   The memleak_object structures are added to the object_list and
+ *   object_tree_root in the create_object() function called from the
+ *   memleak_alloc() callback and removed in delete_object() called from the
+ *   memleak_free() callback
+ * - memleak_object.lock (spinlock): protects a memleak_object. Accesses to
+ *   the metadata (e.g. count) are protected by this lock. Note that some
+ *   members of this structure may be protected by other means (atomic or
+ *   memleak_lock). This lock is also held when scanning the corresponding
+ *   memory block to avoid the kernel freeing it via the memleak_free()
+ *   callback. This is less heavyweight than holding a global lock like
+ *   memleak_lock during scanning
+ *
+ * The memleak_object structures have a use_count incremented or decremented
+ * using the get_object()/put_object() functions. When the use_count becomes
+ * 0, this count can no longer be incremented and put_object() schedules the
+ * memleak_object freeing via an RCU callback. All calls to the get_object()
+ * function must be protected by rcu_read_lock() to avoid accessing a freed
+ * structure.
+ *
+ * The only mutex used is scan_mutex. This ensures that only one thread may
+ * scan the memory for unreferenced objects at a time. The gray_list contains
+ * the objects which are already referenced or marked as false positives and
+ * need to be scanned. This list is only modified during a scanning episode
+ * when the scan_mutex is held. At the end of a scan, the gray_list is always
+ * empty. Note that the memleak_object.use_count is incremented when an object
+ * is added to the gray_list and therefore cannot be freed.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/sched.h>
+#include <linux/jiffies.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/kthread.h>
+#include <linux/prio_tree.h>
+#include <linux/gfp.h>
+#include <linux/kallsyms.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/cpumask.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+#include <linux/stacktrace.h>
+#include <linux/cache.h>
+#include <linux/percpu.h>
+#include <linux/hardirq.h>
+#include <linux/mmzone.h>
+#include <linux/slab.h>
+#include <linux/thread_info.h>
+
+#include <asm/sections.h>
+#include <asm/processor.h>
+#include <asm/atomic.h>
+
+#include <linux/memleak.h>
+
+/*
+ * Kmemleak configuration and common defines.
+ */
+#define MAX_TRACE		16	/* stack trace length */
+#define REPORTS_NR		100	/* maximum number of reported leaks */
+#define MSECS_MIN_AGE		5000	/* minimum object age for reporting */
+#define MSECS_SCAN_YIELD	10	/* CPU yielding period */
+#define SECS_FIRST_SCAN		60	/* delay before the first scan */
+#define SECS_SCAN_PERIOD	600	/* auto scanning period */
+#undef SCAN_TASK_STACKS			/* scan the task kernel stacks */
+#undef REPORT_ORPHAN_FREEING		/* notify when freeing orphan objects */
+
+#define BYTES_PER_POINTER	sizeof(void *)
+
+/* scanning area inside a memory block */
+struct memleak_scan_area {
+	struct hlist_node node;
+	unsigned long offset;
+	size_t length;
+};
+
+/*
+ * Structure holding the metadata for each allocated memory block.
+ * Modifications to such objects should be made while holding the
+ * object->lock. Insertions or deletions from object_list, gray_list or
+ * tree_node are already protected by the corresponding locks or mutex (see
+ * the notes on locking above). These objects are reference-counted
+ * (use_count) and freed using the RCU mechanism.
+ */
+struct memleak_object {
+	spinlock_t lock;
+	unsigned long flags;		/* object status flags */
+	struct list_head object_list;
+	struct list_head gray_list;
+	struct prio_tree_node tree_node;
+	struct rcu_head rcu;		/* object_list lockless traversal */
+	/* object usage count; object freed when use_count == 0 */
+	atomic_t use_count;
+	unsigned long pointer;
+	size_t size;
+	/* minimum number of a pointers found before it is considered leak */
+	int min_count;
+	/* the total number of pointers found pointing to this object */
+	int count;
+	/* memory ranges to be scanned inside an object (empty for all) */
+	struct hlist_head area_list;
+	unsigned long trace[MAX_TRACE];
+	unsigned int trace_len;
+	unsigned long jiffies;		/* creation timestamp */
+	pid_t pid;			/* pid of the current task */
+	char comm[TASK_COMM_LEN];	/* executable name */
+};
+
+/* flag representing the memory block allocation status */
+#define OBJECT_ALLOCATED	(1 << 0)
+/* flag set after the first reporting of an unreference object */
+#define OBJECT_REPORTED		(1 << 1)
+
+/* the list of all allocated objects */
+static LIST_HEAD(object_list);
+/* the list of gray-colored objects (see color_gray comment below) */
+static LIST_HEAD(gray_list);
+/* prio search tree for object boundaries */
+static struct prio_tree_root object_tree_root;
+/* rw_lock protecting the access to object_list and prio_tree_root */
+static DEFINE_RWLOCK(memleak_lock);
+
+/* allocation caches for kmemleak internal data */
+static struct kmem_cache *object_cache;
+static struct kmem_cache *scan_area_cache;
+
+/* set if tracing memory operations is enabled */
+static atomic_t memleak_enabled = ATOMIC_INIT(0);
+/* set in the late_initcall if there were no errors */
+static atomic_t memleak_initialized = ATOMIC_INIT(0);
+/* enables or disables early logging of the memory operations */
+static atomic_t memleak_early_log = ATOMIC_INIT(1);
+/* set if a fata kmemleak error has occurred */
+static atomic_t memleak_error = ATOMIC_INIT(0);
+
+/* minimum and maximum address that may be valid pointers */
+static unsigned long min_addr = ULONG_MAX;
+static unsigned long max_addr;
+
+/* used for yielding the CPU to other tasks during scanning */
+static unsigned long next_scan_yield;
+static struct task_struct *scan_thread;
+static unsigned long jiffies_scan_yield;
+static unsigned long jiffies_min_age;
+static DEFINE_MUTEX(scan_mutex);
+
+/* number of leaks reported (for limitation purposes) */
+static int reported_leaks;
+
+/*
+ * Early object allocation/freeing logging. Kmemleak is initialized after the
+ * kernel allocator. However, both the kernel allocator and kmemleak may
+ * allocate memory blocks which need to be tracked. Kmemleak defines an
+ * arbitrary buffer to hold the allocation/freeing information before it is
+ * fully initialized.
+ */
+
+/* kmemleak operation type for early logging */
+enum {
+	MEMLEAK_ALLOC,
+	MEMLEAK_FREE,
+	MEMLEAK_NOT_LEAK,
+	MEMLEAK_IGNORE,
+	MEMLEAK_SCAN_AREA,
+};
+
+/*
+ * Structure holding the information passed to kmemleak callbacks during the
+ * early logging.
+ */
+struct early_log {
+	int op_type;			/* kmemleak operation type */
+	const void *ptr;		/* allocated/freed memory block */
+	size_t size;			/* memory block size */
+	int min_count;			/* minimum reference count */
+	unsigned long offset;		/* scan area offset */
+	size_t length;			/* scan area length */
+};
+
+/* early logging buffer and current position */
+static struct early_log __initdata early_log[200];
+static int __initdata crt_early_log;
+
+static void memleak_disable(void);
+
+/*
+ * Macro invoked when a serious kmemleak condition occured and cannot be
+ * recovered from. Kmemleak will be disabled and further allocation/freeing
+ * tracing no longer available.
+ */
+#define memleak_panic(x...) {	\
+	pr_warning(x);		\
+	memleak_disable();	\
+}
+
+/*
+ * Object colors, encoded with count and min_count:
+ * - white - orphan object, not enough references to it (count < min_count)
+ * - gray  - not orphan, marked as false positive (min_count == 0) or
+ *		sufficient references to it (count >= min_count)
+ * - black - ignore, it doesn't contain references (e.g. text section)
+ *		(min_count == -1). No function defined for this color.
+ * Newly created objects don't have any color assigned (object->count == -1)
+ * before the next memory scan when they become white.
+ */
+static int color_white(const struct memleak_object *object)
+{
+	return object->count != -1 && object->count < object->min_count;
+}
+
+static int color_gray(const struct memleak_object *object)
+{
+	return object->min_count != -1 && object->count >= object->min_count;
+}
+
+/*
+ * Objects are considered unreferenced only if their color is white, they have
+ * not be deleted and have a minimum age to avoid false positives caused by
+ * pointers temporarily stored in CPU registers.
+ */
+static int unreferenced_object(struct memleak_object *object)
+{
+	if (color_white(object) &&
+	    (object->flags & OBJECT_ALLOCATED) &&
+	    time_is_before_eq_jiffies(object->jiffies + jiffies_min_age))
+		return 1;
+	else
+		return 0;
+}
+
+/*
+ * Printing of the unreferenced objects information, either to the seq file
+ * or to the kernel log. The print_unreferenced() function must be called with
+ * the object->lock held.
+ */
+#define print_helper(seq, x...)			\
+do {						\
+	if (seq)				\
+		seq_printf(seq, x);		\
+	else					\
+		pr_info(x);			\
+} while (0)
+
+static void print_unreferenced(struct seq_file *seq,
+			       struct memleak_object *object)
+{
+	char namebuf[KSYM_NAME_LEN + 1] = "";
+	char *modname;
+	unsigned long symsize;
+	int i;
+
+	print_helper(seq, "unreferenced object 0x%08lx (size %zu):\n",
+		     object->pointer, object->size);
+	print_helper(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
+		     object->comm, object->pid, object->jiffies);
+	print_helper(seq, "  backtrace:\n");
+
+	for (i = 0; i < object->trace_len; i++) {
+		unsigned long trace = object->trace[i];
+		unsigned long offset = 0;
+
+		kallsyms_lookup(trace, &symsize, &offset, &modname, namebuf);
+		print_helper(seq, "    [<%08lx>] %s\n", trace, namebuf);
+	}
+}
+
+/*
+ * Print the memleak_object information. This function is used mainly for
+ * debugging special cases when kmemleak operations. It must be called with
+ * the object->lock held.
+ */
+static void dump_object_info(struct memleak_object *object)
+{
+	struct stack_trace trace;
+
+	trace.nr_entries = object->trace_len;
+	trace.entries = object->trace;
+
+	pr_notice("kmemleak: Object 0x%08lx (size %zu):\n",
+		  object->tree_node.start, object->size);
+	pr_notice("  comm \"%s\", pid %d, jiffies %lu\n",
+		  object->comm, object->pid, object->jiffies);
+	pr_notice("  min_count = %d\n", object->min_count);
+	pr_notice("  count = %d\n", object->count);
+	pr_notice("  backtrace:\n");
+	print_stack_trace(&trace, 4);
+}
+
+/*
+ * Look-up a memory block metadata (memleak_object) in the priority search
+ * tree based on a pointer value. If alias is 0, only values pointing to the
+ * beginning of the memory block are allowed. The memleak_lock must be held
+ * when calling this function.
+ */
+static struct memleak_object *lookup_object(unsigned long ptr, int alias)
+{
+	struct prio_tree_node *node;
+	struct prio_tree_iter iter;
+	struct memleak_object *object;
+
+	prio_tree_iter_init(&iter, &object_tree_root, ptr, ptr);
+	node = prio_tree_next(&iter);
+	if (node) {
+		object = prio_tree_entry(node, struct memleak_object,
+					 tree_node);
+		if (!alias && object->pointer != ptr) {
+			pr_warning("kmemleak: Found object by alias");
+			object = NULL;
+		}
+	} else
+		object = NULL;
+
+	return object;
+}
+
+/*
+ * Increment the object use_count. Return 1 if successful or 0 otherwise. Note
+ * that once an object's use_count reached 0, the RCU freeing was already
+ * registered and the object should no longer be used. This function must be
+ * called under the protection of rcu_read_lock().
+ */
+static int get_object(struct memleak_object *object)
+{
+	return atomic_inc_not_zero(&object->use_count);
+}
+
+/*
+ * RCU callback to free a memleak_object.
+ */
+static void free_object_rcu(struct rcu_head *rcu)
+{
+	struct hlist_node *elem, *tmp;
+	struct memleak_scan_area *area;
+	struct memleak_object *object =
+		container_of(rcu, struct memleak_object, rcu);
+
+	/*
+	 * Once use_count is 0 (guaranteed by put_object), there is no other
+	 * code accessing this object, hence no need for locking.
+	 */
+	hlist_for_each_entry_safe(area, elem, tmp, &object->area_list, node) {
+		hlist_del(elem);
+		kmem_cache_free(scan_area_cache, area);
+	}
+	kmem_cache_free(object_cache, object);
+}
+
+/*
+ * Decrement the object use_count. Once the count is 0, free the object using
+ * an RCU callback. Since put_object() may be called via the memleak_free() ->
+ * delete_object() path, the delayed RCU freeing ensures that there is no
+ * recursive call to the kernel allocator. Lock-less RCU object_list traversal
+ * is also possible.
+ */
+static void put_object(struct memleak_object *object)
+{
+	if (!atomic_dec_and_test(&object->use_count))
+		return;
+
+	/* should only get here after delete_object was called */
+	BUG_ON(object->flags & OBJECT_ALLOCATED);
+
+	call_rcu(&object->rcu, free_object_rcu);
+}
+
+/*
+ * Look up an object in the prio search tree and increase its use_count.
+ */
+static struct memleak_object *find_and_get_object(unsigned long ptr, int alias)
+{
+	unsigned long flags;
+	struct memleak_object *object = NULL;
+
+	rcu_read_lock();
+	read_lock_irqsave(&memleak_lock, flags);
+	if (ptr >= min_addr && ptr < max_addr)
+		object = lookup_object(ptr, alias);
+	read_unlock_irqrestore(&memleak_lock, flags);
+
+	/* check whether the object is still available */
+	if (object && !get_object(object))
+		object = NULL;
+	rcu_read_unlock();
+
+	return object;
+}
+
+/*
+ * Create the metadata (struct memleak_object) corresponding to an allocated
+ * memory block and add it to the object_list and object_tree_root.
+ */
+static void create_object(unsigned long ptr, size_t size, int min_count,
+			  gfp_t gfp)
+{
+	unsigned long flags;
+	struct memleak_object *object;
+	struct prio_tree_node *node;
+	struct stack_trace trace;
+
+	object = kmem_cache_alloc(object_cache, gfp);
+	if (!object)
+		memleak_panic("kmemleak: Cannot allocate a memleak_object "
+			      "structure\n");
+
+	INIT_LIST_HEAD(&object->object_list);
+	INIT_LIST_HEAD(&object->gray_list);
+	INIT_HLIST_HEAD(&object->area_list);
+	spin_lock_init(&object->lock);
+	atomic_set(&object->use_count, 1);
+	object->flags = OBJECT_ALLOCATED;
+	object->pointer = ptr;
+	object->size = size;
+	object->min_count = min_count;
+	object->count = -1;			/* no color initially */
+	object->jiffies = jiffies;
+
+	/* task information */
+	if (in_irq()) {
+		object->pid = 0;
+		strncpy(object->comm, "hardirq", TASK_COMM_LEN);
+	} else if (in_softirq()) {
+		object->pid = 0;
+		strncpy(object->comm, "softirq", TASK_COMM_LEN);
+	} else {
+		object->pid = current->pid;
+		get_task_comm(object->comm, current);
+	}
+
+	/* kernel backtrace */
+	trace.max_entries = MAX_TRACE;
+	trace.nr_entries = 0;
+	trace.entries = object->trace;
+	trace.skip = 1;
+	save_stack_trace(&trace);
+	object->trace_len = trace.nr_entries;
+
+	INIT_PRIO_TREE_NODE(&object->tree_node);
+	object->tree_node.start = ptr;
+	object->tree_node.last = ptr + size - 1;
+
+	write_lock_irqsave(&memleak_lock, flags);
+	min_addr = min(min_addr, ptr);
+	max_addr = max(max_addr, ptr + size);
+	node = prio_tree_insert(&object_tree_root, &object->tree_node);
+	/*
+	 * The code calling the kernel does not yet have the pointer to the
+	 * memory block to be able to free it.  However, we still hold the
+	 * memleak_lock here in case parts of the kernel started freeing
+	 * random memory blocks.
+	 */
+	if (node != &object->tree_node) {
+		unsigned long flags;
+
+		pr_warning("kmemleak: Existing pointer\n");
+		dump_stack();
+
+		object = lookup_object(ptr, 1);
+		spin_lock_irqsave(&object->lock, flags);
+		dump_object_info(object);
+		spin_unlock_irqrestore(&object->lock, flags);
+
+		memleak_panic("kmemleak: Cannot insert 0x%lx into the object "
+			      "search tree\n", ptr);
+	}
+	list_add_tail_rcu(&object->object_list, &object_list);
+	write_unlock_irqrestore(&memleak_lock, flags);
+}
+
+/*
+ * Remove the metadata (struct memleak_object) for a memory block from the
+ * object_list and object_tree_root and decrement its use_count.
+ */
+static void delete_object(unsigned long ptr)
+{
+	unsigned long flags;
+	struct memleak_object *object;
+
+	write_lock_irqsave(&memleak_lock, flags);
+	object = lookup_object(ptr, 0);
+	if (!object) {
+		pr_warning("kmemleak: Freeing unknown object at 0x%08lx\n",
+			   ptr);
+		dump_stack();
+		write_unlock_irqrestore(&memleak_lock, flags);
+		return;
+	}
+	prio_tree_remove(&object_tree_root, &object->tree_node);
+	list_del_rcu(&object->object_list);
+	write_unlock_irqrestore(&memleak_lock, flags);
+
+	BUG_ON(!(object->flags & OBJECT_ALLOCATED));
+	BUG_ON(atomic_read(&object->use_count) < 1);
+
+	/*
+	 * Locking here also ensures that the corresponding memory block
+	 * cannot be freed when it is being scanned.
+	 */
+	spin_lock_irqsave(&object->lock, flags);
+	object->flags &= ~OBJECT_ALLOCATED;
+#ifdef REPORT_ORPHAN_FREEING
+	if (color_white(object)) {
+		pr_warning("kmemleak: Freeing orphan object 0x%08lx\n", ptr);
+		dump_stack();
+		dump_object_info(object);
+	}
+#endif
+	spin_unlock_irqrestore(&object->lock, flags);
+	put_object(object);
+}
+
+/*
+ * Make a object permanently as gray-colored so that it can no longer be
+ * reported as a leak. This is used in general to mark a false positive.
+ */
+static void make_gray_object(unsigned long ptr)
+{
+	unsigned long flags;
+	struct memleak_object *object;
+
+	object = find_and_get_object(ptr, 0);
+	if (!object) {
+		dump_stack();
+		memleak_panic("kmemleak: Graying unknown object at 0x%08lx\n",
+			      ptr);
+	}
+
+	spin_lock_irqsave(&object->lock, flags);
+	object->min_count = 0;
+	spin_unlock_irqrestore(&object->lock, flags);
+	put_object(object);
+}
+
+/*
+ * Mark the object as black-colored so that it is ignored from scans and
+ * reporting.
+ */
+static void make_black_object(unsigned long ptr)
+{
+	unsigned long flags;
+	struct memleak_object *object;
+
+	object = find_and_get_object(ptr, 0);
+	if (!object) {
+		dump_stack();
+		memleak_panic("kmemleak: Blacking unknown object at 0x%08lx\n",
+			      ptr);
+	}
+
+	spin_lock_irqsave(&object->lock, flags);
+	object->min_count = -1;
+	spin_unlock_irqrestore(&object->lock, flags);
+	put_object(object);
+}
+
+/*
+ * Add a scanning area to the object. If at least one such area is added,
+ * kmemleak will only scan these ranges rather than the whole memory block.
+ */
+static void add_scan_area(unsigned long ptr, unsigned long offset,
+			  size_t length, gfp_t gfp)
+{
+	unsigned long flags;
+	struct memleak_object *object;
+	struct memleak_scan_area *area;
+
+	object = find_and_get_object(ptr, 0);
+	if (!object) {
+		dump_stack();
+		memleak_panic("kmemleak: Adding scan area to unknown "
+			      "object at 0x%08lx\n", ptr);
+	}
+
+	area = kmem_cache_alloc(scan_area_cache, gfp);
+	if (!area)
+		memleak_panic("kmemleak: Cannot allocate a scan area\n");
+
+	spin_lock_irqsave(&object->lock, flags);
+	if (offset + length > object->size) {
+		dump_stack();
+		dump_object_info(object);
+		memleak_panic("kmemleak: Scan area larger than object "
+			      "0x%08lx\n", ptr);
+	}
+
+	INIT_HLIST_NODE(&area->node);
+	area->offset = offset;
+	area->length = length;
+
+	hlist_add_head(&area->node, &object->area_list);
+	spin_unlock_irqrestore(&object->lock, flags);
+	put_object(object);
+}
+
+/*
+ * Log an early memleak_* call to the early_log buffer. These calls will be
+ * processed later once kmemleak is fully initialized.
+ */
+static void __init log_early(int op_type, const void *ptr, size_t size,
+			     int min_count,
+			     unsigned long offset, size_t length)
+{
+	unsigned long flags;
+	struct early_log *log;
+
+	if (crt_early_log >= ARRAY_SIZE(early_log))
+		memleak_panic("kmemleak: Early log buffer exceeded\n");
+
+	/*
+	 * There is no need for locking since the kernel is still in UP mode
+	 * at this stage. Disabling the IRQs is enough.
+	 */
+	local_irq_save(flags);
+	log = &early_log[crt_early_log];
+	log->op_type = op_type;
+	log->ptr = ptr;
+	log->size = size;
+	log->min_count = min_count;
+	log->offset = offset;
+	log->length = length;
+	crt_early_log++;
+	local_irq_restore(flags);
+}
+
+/*
+ * Memory allocation function callback. This function is called from the
+ * kernel allocators when a new block is allocated (kmem_cache_alloc, kmalloc,
+ * vmalloc etc.).
+ */
+void memleak_alloc(const void *ptr, size_t size, int min_count, gfp_t gfp)
+{
+	pr_debug("%s(0x%p, %zu, %d)\n", __func__, ptr, size, min_count);
+
+	if (atomic_read(&memleak_enabled) && ptr)
+		create_object((unsigned long)ptr, size, min_count, gfp);
+	else if (atomic_read(&memleak_early_log))
+		log_early(MEMLEAK_ALLOC, ptr, size, min_count, 0, 0);
+}
+EXPORT_SYMBOL_GPL(memleak_alloc);
+
+/*
+ * Memory freeing function callback. This function is called from the kernel
+ * allocators when a block is freed (kmem_cache_free, kfree, vfree etc.).
+ */
+void memleak_free(const void *ptr)
+{
+	pr_debug("%s(0x%p)\n", __func__, ptr);
+
+	if (atomic_read(&memleak_enabled) && ptr)
+		delete_object((unsigned long)ptr);
+	else if (atomic_read(&memleak_early_log))
+		log_early(MEMLEAK_FREE, ptr, 0, 0, 0, 0);
+}
+EXPORT_SYMBOL_GPL(memleak_free);
+
+/*
+ * Mark an already allocated memory block as a false positive. This will cause
+ * the block to no longer be reported as leak and always be scanned.
+ */
+void memleak_not_leak(const void *ptr)
+{
+	pr_debug("%s(0x%p)\n", __func__, ptr);
+
+	if (atomic_read(&memleak_enabled) && ptr)
+		make_gray_object((unsigned long)ptr);
+	else if (atomic_read(&memleak_early_log))
+		log_early(MEMLEAK_NOT_LEAK, ptr, 0, 0, 0, 0);
+}
+EXPORT_SYMBOL(memleak_not_leak);
+
+/*
+ * Ignore a memory block. This is usually done when it is known that the
+ * corresponding block is not a leak and does not contain any references to
+ * other allocated memory blocks.
+ */
+void memleak_ignore(const void *ptr)
+{
+	pr_debug("%s(0x%p)\n", __func__, ptr);
+
+	if (atomic_read(&memleak_enabled) && ptr)
+		make_black_object((unsigned long)ptr);
+	else if (atomic_read(&memleak_early_log))
+		log_early(MEMLEAK_IGNORE, ptr, 0, 0, 0, 0);
+}
+EXPORT_SYMBOL(memleak_ignore);
+
+/*
+ * Limit the range to be scanned in an allocated memory block.
+ */
+void memleak_scan_area(const void *ptr, unsigned long offset, size_t length,
+		       gfp_t gfp)
+{
+	pr_debug("%s(0x%p)\n", __func__, ptr);
+
+	if (atomic_read(&memleak_enabled) && ptr)
+		add_scan_area((unsigned long)ptr, offset, length, gfp);
+	else if (atomic_read(&memleak_early_log))
+		log_early(MEMLEAK_SCAN_AREA, ptr, 0, 0, offset, length);
+}
+EXPORT_SYMBOL(memleak_scan_area);
+
+/*
+ * Yield the CPU so that other tasks get a chance to run.  The yielding is
+ * rate-limited to avoid excessive number of calls to the schedule() function
+ * during memory scanning.
+ */
+static void scan_yield(void)
+{
+	might_sleep();
+
+	if (time_is_before_eq_jiffies(next_scan_yield)) {
+		schedule();
+		next_scan_yield = jiffies + jiffies_scan_yield;
+	}
+}
+
+/*
+ * Memory scanning is a long process and it needs to be interruptable. This
+ * function checks whether such interrupt condition occured.
+ */
+static int scan_should_stop(void)
+{
+	if (!atomic_read(&memleak_enabled))
+		return 1;
+	/*
+	 * This function may be called from either process or kthread context,
+	 * hence the need to check for both stop conditions.
+	 */
+	if ((current->mm && signal_pending(current)) ||
+	    (!current->mm && kthread_should_stop()))
+		return 1;
+	return 0;
+}
+
+/*
+ * Scan a memory block (exclusive range) for valid pointers and add those
+ * found to the gray list.
+ */
+static void scan_block(void *_start, void *_end, struct memleak_object *scanned)
+{
+	unsigned long *ptr;
+	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
+	unsigned long *end = _end - (BYTES_PER_POINTER - 1);
+
+	for (ptr = start; ptr < end; ptr++) {
+		unsigned long flags;
+		unsigned long pointer = *ptr;
+		struct memleak_object *object;
+
+		if (scan_should_stop())
+			break;
+
+		/*
+		 * When scanning a memory block with a corresponding
+		 * memleak_object, the CPU yielding is handled in the calling
+		 * code since it holds the object->lock to avoid the block
+		 * freeing.
+		 */
+		if (!scanned)
+			scan_yield();
+
+		object = find_and_get_object(pointer, 1);
+		if (!object)
+			continue;
+		if (object == scanned) {
+			/* self referenced, ignore */
+			put_object(object);
+			continue;
+		}
+
+		/*
+		 * Avoid the lockdep recursive warning on object->lock being
+		 * previously acquired in scan_object(). These locks are
+		 * enclosed by scan_mutex.
+		 */
+		spin_lock_irqsave_nested(&object->lock, flags,
+					 SINGLE_DEPTH_NESTING);
+		if (!color_white(object)) {
+			/* non-orphan, ignored or new */
+			spin_unlock_irqrestore(&object->lock, flags);
+			put_object(object);
+			continue;
+		}
+
+		/*
+		 * Increase the object's reference count (number of pointers
+		 * to the memory block). If this count reaches the required
+		 * minimum, the object's color will become gray and it will be
+		 * added to the gray_list.
+		 */
+		object->count++;
+		if (color_gray(object))
+			list_add_tail(&object->gray_list, &gray_list);
+		else
+			put_object(object);
+		spin_unlock_irqrestore(&object->lock, flags);
+	}
+}
+
+/*
+ * Scan a memory block corresponding to a memleak_object. A condition is
+ * that object->use_count >= 1.
+ */
+static void scan_object(struct memleak_object *object)
+{
+	struct memleak_scan_area *area;
+	struct hlist_node *elem;
+	unsigned long flags;
+
+	/*
+	 * Once the object->lock is aquired, the corresponding memory block
+	 * cannot be freed (the same lock is aquired in delete_object).
+	 */
+	spin_lock_irqsave(&object->lock, flags);
+	if (!(object->flags & OBJECT_ALLOCATED))
+		/* already freed object */
+		goto out;
+	if (hlist_empty(&object->area_list))
+		scan_block((void *)object->pointer,
+			   (void *)(object->pointer + object->size), object);
+	else
+		hlist_for_each_entry(area, elem, &object->area_list, node)
+			scan_block((void *)(object->pointer + area->offset),
+				   (void *)(object->pointer + area->offset
+					    + area->length), object);
+ out:
+	spin_unlock_irqrestore(&object->lock, flags);
+}
+
+/*
+ * Scan data sections and all the referenced memory blocks allocated via the
+ * kernel's standard allocators. This function must be called with the
+ * scan_mutex held.
+ */
+static void memleak_scan(void)
+{
+	unsigned long flags;
+	struct memleak_object *object, *tmp;
+#ifdef CONFIG_SMP
+	int i;
+#endif
+#ifdef SCAN_TASK_STACKS
+	struct task_struct *task;
+#endif
+
+	/* prepare the memleak_object's */
+	rcu_read_lock();
+	list_for_each_entry_rcu(object, &object_list, object_list) {
+		spin_lock_irqsave(&object->lock, flags);
+#ifdef DEBUG
+		/*
+		 * With a few exceptions there should be a maximum of
+		 * 1 reference to any object at this point.
+		 */
+		if (atomic_read(&object->use_count) > 1) {
+			pr_debug("kmemleak: object->use_count = %d\n",
+				 atomic_read(&object->use_count));
+			dump_object_info(object);
+		}
+#endif
+		/* reset the reference count (whiten the object) */
+		object->count = 0;
+		if (color_gray(object) && get_object(object))
+			list_add_tail(&object->gray_list, &gray_list);
+
+		spin_unlock_irqrestore(&object->lock, flags);
+	}
+	rcu_read_unlock();
+
+	/* data/bss scanning */
+	scan_block(_sdata, _edata, NULL);
+	scan_block(__bss_start, __bss_stop, NULL);
+
+#ifdef CONFIG_SMP
+	/* per-cpu sections scanning */
+	for_each_possible_cpu(i)
+		scan_block(__per_cpu_start + per_cpu_offset(i),
+			   __per_cpu_end + per_cpu_offset(i), NULL);
+#endif
+
+#ifdef SCAN_TASK_STACKS
+	/*
+	 * Scanning the task stacks may introduce false negatives and it is
+	 * not enabled by default.
+	 */
+	read_lock(&tasklist_lock);
+	for_each_process(task)
+		scan_block(task_stack_page(task),
+			   task_stack_page(task) + THREAD_SIZE, NULL);
+	read_unlock(&tasklist_lock);
+#endif
+
+	/*
+	 * Scan the objects already referenced from the sections scanned
+	 * above. More objects will be referenced and, if there are no memory
+	 * leaks, all the objects will be scanned. The list traversal is safe
+	 * for both tail additions and removals from inside the loop. The
+	 * memleak objects cannot be freed from outside the loop because their
+	 * use_count was increased.
+	 */
+	object = list_entry(gray_list.next, typeof(*object), gray_list);
+	while (&object->gray_list != &gray_list) {
+		scan_yield();
+
+		/* may add new objects to the list */
+		if (!scan_should_stop())
+			scan_object(object);
+
+		tmp = list_entry(object->gray_list.next, typeof(*object),
+				 gray_list);
+
+		/* remove the object from the list and release it */
+		list_del(&object->gray_list);
+		put_object(object);
+
+		object = tmp;
+	}
+	BUG_ON(!list_empty(&gray_list));
+}
+
+/*
+ * Iterate over the object_list and return the first valid object at or after
+ * the required position with its use_count incremented. The function triggers
+ * a memory scanning when the pos argument points to the first position.
+ */
+static void *memleak_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct memleak_object *object;
+	loff_t n = *pos;
+
+	if (!atomic_read(&memleak_enabled)) {
+		seq_printf(seq, "Kernel memory leak detector disabled\n");
+		return ERR_PTR(-EBUSY);
+	}
+	if (!n) {
+		memleak_scan();
+		reported_leaks = 0;
+	}
+	if (reported_leaks >= REPORTS_NR)
+		return NULL;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(object, &object_list, object_list) {
+		if (n-- > 0)
+			continue;
+		if (get_object(object))
+			goto out;
+	}
+	object = NULL;
+ out:
+	rcu_read_unlock();
+	return object;
+}
+
+/*
+ * Return the next object in the object_list. The function decrements the
+ * use_count of the previous object and increases that of the next one.
+ */
+static void *memleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct memleak_object *prev_obj = v;
+	struct memleak_object *next_obj = NULL;
+	struct list_head *n = &prev_obj->object_list;
+
+	++(*pos);
+	if (reported_leaks >= REPORTS_NR)
+		goto out;
+
+	rcu_read_lock();
+	list_for_each_continue_rcu(n, &object_list) {
+		next_obj = list_entry(n, struct memleak_object, object_list);
+		if (get_object(next_obj))
+			break;
+	}
+	rcu_read_unlock();
+ out:
+	put_object(prev_obj);
+	return next_obj;
+}
+
+/*
+ * Decrement the use_count of the last object required, if any.
+ */
+static void memleak_seq_stop(struct seq_file *seq, void *v)
+{
+	if (v)
+		put_object(v);
+}
+
+/*
+ * Print the information for an unreferenced object to the seq file.
+ */
+static int memleak_seq_show(struct seq_file *seq, void *v)
+{
+	struct memleak_object *object = v;
+	unsigned long flags;
+
+	spin_lock_irqsave(&object->lock, flags);
+	if (!unreferenced_object(object))
+		goto out;
+	print_unreferenced(seq, object);
+	reported_leaks++;
+out:
+	spin_unlock_irqrestore(&object->lock, flags);
+	return 0;
+}
+
+static const struct seq_operations memleak_seq_ops = {
+	.start = memleak_seq_start,
+	.next  = memleak_seq_next,
+	.stop  = memleak_seq_stop,
+	.show  = memleak_seq_show,
+};
+
+static int memleak_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = mutex_lock_interruptible(&scan_mutex);
+	if (ret < 0)
+		return ret;
+	ret = seq_open(file, &memleak_seq_ops);
+	if (ret < 0)
+		mutex_unlock(&scan_mutex);
+	return ret;
+}
+
+static int memleak_seq_release(struct inode *inode, struct file *file)
+{
+	int ret = seq_release(inode, file);
+	mutex_unlock(&scan_mutex);
+	return ret;
+}
+
+static const struct file_operations memleak_fops = {
+	.owner	 = THIS_MODULE,
+	.open    = memleak_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = memleak_seq_release,
+};
+
+/*
+ * Thread function performing automatic memory scanning. Unreferenced objects
+ * at the end of a memory scan are reported but only the first time.
+ */
+static int memleak_scan_thread(void *arg)
+{
+	/*
+	 * Wait before the first scan to allow the system to fully initialize.
+	 */
+	ssleep(SECS_FIRST_SCAN);
+
+	while (!kthread_should_stop()) {
+		struct memleak_object *object;
+		int ret;
+
+		ret = mutex_lock_interruptible(&scan_mutex);
+		if (ret < 0)
+			continue;
+
+		memleak_scan();
+		reported_leaks = 0;
+
+		rcu_read_lock();
+		list_for_each_entry_rcu(object, &object_list, object_list) {
+			unsigned long flags;
+
+			if (reported_leaks >= REPORTS_NR)
+				break;
+			spin_lock_irqsave(&object->lock, flags);
+			if (!(object->flags & OBJECT_REPORTED) &&
+			    unreferenced_object(object)) {
+				print_unreferenced(NULL, object);
+				object->flags |= OBJECT_REPORTED;
+				reported_leaks++;
+			}
+			spin_unlock_irqrestore(&object->lock, flags);
+		}
+		rcu_read_unlock();
+
+		mutex_unlock(&scan_mutex);
+		/* sleep before the next scan */
+		ssleep(SECS_SCAN_PERIOD);
+	}
+
+	return 0;
+}
+
+/*
+ * Perform the freeing of the kmemleak internal objects after waiting for any
+ * current memory scan to complete.
+ */
+static int memleak_cleanup_thread(void *arg)
+{
+	struct memleak_object *object;
+
+	mutex_lock(&scan_mutex);
+	rcu_read_lock();
+	list_for_each_entry_rcu(object, &object_list, object_list)
+		delete_object(object->pointer);
+	rcu_read_unlock();
+	mutex_unlock(&scan_mutex);
+
+	return 0;
+}
+
+/*
+ * Start the clean-up thread.
+ */
+static void memleak_cleanup(void)
+{
+	struct task_struct *cleanup_thread;
+
+	cleanup_thread = kthread_run(memleak_cleanup_thread, NULL,
+				     "kmemleak-cleanup");
+	if (IS_ERR(cleanup_thread))
+		pr_warning("kmemleak: Failed to create the clean-up thread\n");
+}
+
+/*
+ * Disable kmemleak. No memory allocation/freeing will be traced once this
+ * function is called. Disabling kmemleak is an irreversible operation.
+ */
+static void memleak_disable(void)
+{
+	if (atomic_cmpxchg(&memleak_error, 0, 1))
+		return;
+
+	/* stop any memory operation tracing */
+	atomic_set(&memleak_early_log, 0);
+	atomic_set(&memleak_enabled, 0);
+
+	/* check whether it is too early for a kernel thread */
+	if (atomic_read(&memleak_initialized))
+		memleak_cleanup();
+
+	pr_info("Kernel memory leak detector disabled\n");
+}
+
+/*
+ * Kmemleak initialization.
+ */
+void __init memleak_init(void)
+{
+	int i;
+	unsigned long flags;
+
+	jiffies_scan_yield = msecs_to_jiffies(MSECS_SCAN_YIELD);
+	jiffies_min_age = msecs_to_jiffies(MSECS_MIN_AGE);
+
+	object_cache = KMEM_CACHE(memleak_object, SLAB_NOLEAKTRACE);
+	scan_area_cache = KMEM_CACHE(memleak_scan_area, SLAB_NOLEAKTRACE);
+	INIT_PRIO_TREE_ROOT(&object_tree_root);
+
+	/* the kernel is still in UP mode, so disabling the IRQs is enough */
+	local_irq_save(flags);
+	if (!atomic_read(&memleak_error)) {
+		atomic_set(&memleak_enabled, 1);
+		atomic_set(&memleak_early_log, 0);
+	}
+	local_irq_restore(flags);
+
+	/*
+	 * This is the point where tracking allocations is safe. Automatic
+	 * scanning is started during the late initcall. Add the early logged
+	 * callbacks to the kmemleak infrastructure.
+	 */
+	for (i = 0; i < crt_early_log; i++) {
+		struct early_log *log = &early_log[i];
+
+		switch (log->op_type) {
+		case MEMLEAK_ALLOC:
+			memleak_alloc(log->ptr, log->size, log->min_count,
+				      GFP_ATOMIC);
+			break;
+		case MEMLEAK_FREE:
+			memleak_free(log->ptr);
+			break;
+		case MEMLEAK_NOT_LEAK:
+			memleak_not_leak(log->ptr);
+			break;
+		case MEMLEAK_IGNORE:
+			memleak_ignore(log->ptr);
+			break;
+		case MEMLEAK_SCAN_AREA:
+			memleak_scan_area(log->ptr, log->offset, log->length,
+					  GFP_ATOMIC);
+			break;
+		default:
+			BUG();
+		}
+	}
+}
+
+/*
+ * Late initialization function.
+ */
+static int __init memleak_late_init(void)
+{
+	struct dentry *dentry;
+
+	atomic_set(&memleak_initialized, 1);
+
+	if (atomic_read(&memleak_error)) {
+		/*
+		 * Some error occured and kmemleak was disabled. There is a
+		 * small chance that memleak_disable() was called immediately
+		 * after setting memleak_initialized and we may end up with
+		 * two clean-up threads but serialized by scan_mutex.
+		 */
+		memleak_cleanup();
+		return -EBUSY;
+	}
+
+	dentry = debugfs_create_file("memleak", S_IRUGO, NULL, NULL,
+				     &memleak_fops);
+	if (!dentry)
+		return -ENOMEM;
+
+	scan_thread = kthread_run(memleak_scan_thread, NULL, "kmemleak");
+	if (IS_ERR(scan_thread))
+		pr_warning("kmemleak: Failed to create the scan thread\n");
+
+	pr_info("Kernel memory leak detector initialized\n");
+
+	return 0;
+}
+late_initcall(memleak_late_init);


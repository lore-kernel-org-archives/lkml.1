Return-Path: <linux-kernel-owner+w=401wt.eu-S1751655AbYK2Knp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbYK2Knp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYK2Knb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:43:31 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41338 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747AbYK2Kn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:43:27 -0500
Subject: [PATCH 01/15] kmemleak: Add the base support
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Date: Sat, 29 Nov 2008 10:43:12 +0000
Message-ID: <20081129104312.16726.36218.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.288.gdd3f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2008 10:43:12.0440 (UTC) FILETIME=[46E88380:01C9520F]
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
---
 include/linux/memleak.h |   87 ++++
 init/main.c             |    4 
 mm/memleak.c            | 1019 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1109 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/memleak.h
 create mode 100644 mm/memleak.c

diff --git a/include/linux/memleak.h b/include/linux/memleak.h
new file mode 100644
index 0000000..2756a05
--- /dev/null
+++ b/include/linux/memleak.h
@@ -0,0 +1,87 @@
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
+extern void memleak_alloc(const void *ptr, size_t size, int ref_count);
+extern void memleak_free(const void *ptr);
+extern void memleak_padding(const void *ptr, unsigned long offset, size_t size);
+extern void memleak_not_leak(const void *ptr);
+extern void memleak_ignore(const void *ptr);
+extern void memleak_scan_area(const void *ptr, unsigned long offset, size_t length);
+
+static inline void memleak_alloc_recursive(const void *ptr, size_t size,
+					   int ref_count, unsigned long flags)
+{
+	if (!(flags & SLAB_NOLEAKTRACE))
+		memleak_alloc(ptr, size, ref_count);
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
+static inline void memleak_alloc(const void *ptr, size_t size, int ref_count)
+{
+}
+static inline void memleak_alloc_recursive(const void *ptr, size_t size,
+					   int ref_count, unsigned long flags)
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
+static inline void memleak_scan_area(const void *ptr, unsigned long offset, size_t length)
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
index 0000000..1b09ca2
--- /dev/null
+++ b/mm/memleak.c
@@ -0,0 +1,1019 @@
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
+
+#include <asm/sections.h>
+#include <asm/processor.h>
+#include <asm/thread_info.h>
+#include <asm/atomic.h>
+
+#include <linux/memleak.h>
+
+/*
+ * Kmemleak configuration and common defines.
+ */
+#define MAX_TRACE		16	/* stack trace length */
+#define REPORTS_NR		100	/* maximum number of reported leaks */
+#define MSECS_MIN_AGE		1000	/* minimum object age for leak reporting */ 
+#undef SCAN_TASK_STACKS			/* scan the task kernel stacks */
+#undef REPORT_ORPHAN_FREEING		/* notify when freeing orphan objects */
+
+#define BYTES_PER_WORD		sizeof(void *)
+#define MSECS_SCAN_YIELD	10
+#define SECS_FIRST_SCAN		60
+#define SECS_SCAN_PERIOD	600
+
+/* scanning area inside a memory block */
+struct memleak_scan_area {
+	struct hlist_node node;
+	unsigned long offset;
+	size_t length;
+};
+
+/* the main allocation tracking object */
+struct memleak_object {
+	spinlock_t lock;
+	unsigned long flags;
+	struct list_head object_list;
+	struct list_head gray_list;
+	struct prio_tree_node tree_node;
+	struct rcu_head rcu;		/* used for object_list lockless traversal */
+	atomic_t use_count;		/* internal usage count */
+	unsigned long pointer;
+	size_t size;
+	int ref_count;			/* the minimum encounters of the pointer */
+	int count;			/* the ecounters of the pointer */
+	struct hlist_head area_list;	/* areas to be scanned (or empty for all) */
+	unsigned long trace[MAX_TRACE];
+	unsigned int trace_len;
+	unsigned long jiffies;		/* creation timestamp */
+	pid_t pid;			/* pid of the current task */
+	char comm[TASK_COMM_LEN];	/* executable name */
+};
+
+/* The list of all allocated objects */
+static LIST_HEAD(object_list);
+static DEFINE_SPINLOCK(object_list_lock);
+/* The list of the gray objects */
+static LIST_HEAD(gray_list);
+/* prio search tree for object boundaries */
+static struct prio_tree_root object_tree_root;
+static DEFINE_RWLOCK(object_tree_lock);
+
+/* allocation caches */
+static struct kmem_cache *object_cache;
+static struct kmem_cache *scan_area_cache;
+
+static atomic_t memleak_enabled = ATOMIC_INIT(0);
+
+/* minimum and maximum address that may be valid pointers */
+static unsigned long min_addr = ~0;
+static unsigned long max_addr;
+
+/* used for yielding the CPU to other tasks during scanning */
+static unsigned long next_scan_yield;
+static struct task_struct *scan_thread;
+static DEFINE_MUTEX(scan_mutex);
+static int reported_leaks;
+static int scan_should_stop;
+
+static unsigned long jiffies_scan_yield;
+static unsigned long jiffies_min_age;
+
+/*
+ * Early object allocation (before kmemleak is fully initialised).
+ */
+#define EARLY_LOG_NR		200
+
+enum {
+	MEMLEAK_ALLOC,
+	MEMLEAK_FREE,
+	MEMLEAK_NOT_LEAK,
+	MEMLEAK_IGNORE,
+	MEMLEAK_SCAN_AREA,
+};
+
+struct early_log {
+	int op_type;			/* kmemleak operation type */
+	const void *ptr;
+	size_t size;
+	int ref_count;
+	unsigned long offset;
+	size_t length;
+};
+
+static struct early_log __initdata early_log[EARLY_LOG_NR];
+static int __initdata crt_early_log;
+
+/* object flags */
+#define OBJECT_ALLOCATED	(1 << 0)
+#define OBJECT_REPORTED		(1 << 1)
+
+/*
+ * Object colors, encoded with count and ref_count:
+ *   - white - orphan object, i.e. not enough references to it (ref_count >= 1)
+ *   - gray  - referred at least once and therefore non-orphan (ref_count == 0)
+ *   - black - ignore; it doesn't contain references (text section) (ref_count == -1).
+ * Newly created objects don't have any color (object->count == -1) before
+ * the next memory scan when they become white.
+ */
+static inline int color_white(const struct memleak_object *object)
+{
+	return object->count != -1 && object->count < object->ref_count;
+}
+
+static inline int color_gray(const struct memleak_object *object)
+{
+	return object->ref_count != -1 && object->count >= object->ref_count;
+}
+
+static inline int color_black(const struct memleak_object *object)
+{
+	return object->ref_count == -1;
+}
+
+static inline int unreferenced_object(struct memleak_object *object)
+{
+	if (color_white(object) &&
+	    (object->flags & OBJECT_ALLOCATED) &&
+	    time_is_before_eq_jiffies(object->jiffies + jiffies_min_age))
+		return 1;
+	else
+		return 0;
+}
+
+#define print_seq(seq, x...)			\
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
+	unsigned long offset = 0;
+	int i;
+
+	print_seq(seq, "unreferenced object 0x%08lx (size %zu):\n",
+		  object->pointer, object->size);
+	print_seq(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
+		  object->comm, object->pid, object->jiffies);
+	print_seq(seq, "  backtrace:\n");
+
+	for (i = 0; i < object->trace_len; i++) {
+		unsigned long trace = object->trace[i];
+
+		kallsyms_lookup(trace, &symsize, &offset, &modname, namebuf);
+		print_seq(seq, "    [<%08lx>] %s\n", trace, namebuf);
+	}
+}
+
+static void dump_object_info(struct memleak_object *object)
+{
+	struct stack_trace trace;
+
+	trace.nr_entries = object->trace_len;
+	trace.entries = object->trace;
+
+	pr_notice("kmemleak: object 0x%08lx (size %zu):\n",
+		  object->tree_node.start, object->size);
+	pr_notice("  comm \"%s\", pid %d, jiffies %lu\n",
+		  object->comm, object->pid, object->jiffies);
+	pr_notice("  ref_count = %d\n", object->ref_count);
+	pr_notice("  count = %d\n", object->count);
+	pr_notice("  backtrace:\n");
+	print_stack_trace(&trace, 4);
+}
+
+static struct memleak_object *lookup_object(unsigned long ptr, int alias)
+{
+	struct prio_tree_node *node;
+	struct prio_tree_iter iter;
+	struct memleak_object *object;
+
+	prio_tree_iter_init(&iter, &object_tree_root, ptr, ptr);
+	node = prio_tree_next(&iter);
+	if (node) {
+		object = prio_tree_entry(node, struct memleak_object, tree_node);
+		if (!alias && object->pointer != ptr) {
+			pr_warning("kmemleak: found object by alias");
+			object = NULL;
+		}
+	} else
+		object = NULL;
+
+	return object;
+}
+
+/*
+ * Return 1 if successful or 0 otherwise.
+ */
+static inline int get_object(struct memleak_object *object)
+{
+	return atomic_inc_not_zero(&object->use_count);
+}
+
+static void free_object_rcu(struct rcu_head *rcu)
+{
+	struct hlist_node *elem, *tmp;
+	struct memleak_scan_area *area;
+	struct memleak_object *object =
+		container_of(rcu, struct memleak_object, rcu);
+
+	/* once use_count is 0, there is no code accessing the object */
+	hlist_for_each_entry_safe(area, elem, tmp, &object->area_list, node) {
+		hlist_del(elem);
+		kmem_cache_free(scan_area_cache, area);
+	}
+	kmem_cache_free(object_cache, object);
+}
+
+static void put_object(struct memleak_object *object)
+{
+	unsigned long flags;
+
+	if (!atomic_dec_and_test(&object->use_count))
+		return;
+
+	/* should only get here after delete_object was called */
+	BUG_ON(object->flags & OBJECT_ALLOCATED);
+
+	spin_lock_irqsave(&object_list_lock, flags);
+	/* the last reference to this object */
+	list_del_rcu(&object->object_list);
+	call_rcu(&object->rcu, free_object_rcu);
+	spin_unlock_irqrestore(&object_list_lock, flags);
+}
+
+static struct memleak_object *find_and_get_object(unsigned long ptr, int alias)
+{
+	unsigned long flags;
+	struct memleak_object *object;
+
+	read_lock_irqsave(&object_tree_lock, flags);
+	object = lookup_object(ptr, alias);
+	if (object)
+		get_object(object);
+	read_unlock_irqrestore(&object_tree_lock, flags);
+
+	return object;
+}
+
+/*
+ * Insert a pointer into the pointer hash table.
+ */
+static inline void create_object(unsigned long ptr, size_t size, int ref_count)
+{
+	unsigned long flags;
+	struct memleak_object *object;
+	struct prio_tree_node *node;
+	struct stack_trace trace;
+
+	object = kmem_cache_alloc(object_cache, GFP_ATOMIC);
+	if (!object)
+		panic("kmemleak: cannot allocate a memleak_object structure\n");
+
+	INIT_LIST_HEAD(&object->object_list);
+	INIT_LIST_HEAD(&object->gray_list);
+	INIT_HLIST_HEAD(&object->area_list);
+	spin_lock_init(&object->lock);
+	atomic_set(&object->use_count, 1);
+	object->flags = OBJECT_ALLOCATED;
+	object->pointer = ptr;
+	object->size = size;
+	object->ref_count = ref_count;
+	object->count = -1;				/* black color initially */
+	object->jiffies = jiffies;
+	if (in_irq()) {
+		object->pid = 0;
+		strncpy(object->comm, "hardirq", TASK_COMM_LEN);
+	} else if (in_softirq()) {
+		object->pid = 0;
+		strncpy(object->comm, "softirq", TASK_COMM_LEN);
+	} else {
+		object->pid = current->pid;
+		strncpy(object->comm, current->comm, TASK_COMM_LEN);
+	}
+
+	trace.max_entries = MAX_TRACE;
+	trace.nr_entries = 0;
+	trace.entries = object->trace;
+	trace.skip = 1;
+	save_stack_trace(&trace);
+
+	object->trace_len = trace.nr_entries;
+
+	INIT_PRIO_TREE_NODE(&object->tree_node);
+	object->tree_node.start = ptr;
+	object->tree_node.last = ptr + size - 1;
+
+	if (ptr < min_addr)
+		min_addr = ptr;
+	if (ptr + size > max_addr)
+		max_addr = ptr + size;
+	/*
+	 * Update the boundaries before inserting the object in the
+	 * prio search tree.
+	 */
+	smp_mb();
+
+	write_lock_irqsave(&object_tree_lock, flags);
+	node = prio_tree_insert(&object_tree_root, &object->tree_node);
+	if (node != &object->tree_node) {
+		unsigned long flags;
+
+		pr_warning("kmemleak: existing pointer\n");
+		dump_stack();
+
+		object = lookup_object(ptr, 1);
+		spin_lock_irqsave(&object->lock, flags);
+		dump_object_info(object);
+		spin_unlock_irqrestore(&object->lock, flags);
+
+		panic("kmemleak: cannot insert 0x%lx into the object search tree\n",
+		      ptr);
+	}
+	write_unlock_irqrestore(&object_tree_lock, flags);
+
+	spin_lock_irqsave(&object_list_lock, flags);
+	list_add_tail_rcu(&object->object_list, &object_list);
+	spin_unlock_irqrestore(&object_list_lock, flags);
+}
+
+/*
+ * Remove a pointer from the pointer hash table.
+ */
+static inline void delete_object(unsigned long ptr)
+{
+	unsigned long flags;
+	struct memleak_object *object;
+
+	write_lock_irqsave(&object_tree_lock, flags);
+	object = lookup_object(ptr, 0);
+	if (!object) {
+		pr_warning("kmemleak: freeing unknown object at 0x%08lx\n", ptr);
+		dump_stack();
+		write_unlock_irqrestore(&object_tree_lock, flags);
+		return;
+	}
+	prio_tree_remove(&object_tree_root, &object->tree_node);
+	write_unlock_irqrestore(&object_tree_lock, flags);
+
+	BUG_ON(!(object->flags & OBJECT_ALLOCATED));
+
+	spin_lock_irqsave(&object->lock, flags);
+	object->flags &= ~OBJECT_ALLOCATED;
+#ifdef REPORT_ORPHAN_FREEING
+	if (color_white(object)) {
+		pr_warning("kmemleak: freeing orphan object 0x%08lx\n", ptr);
+		dump_stack();
+		dump_object_info(object);
+	}
+#endif
+	object->pointer = 0;
+	spin_unlock_irqrestore(&object->lock, flags);
+
+	put_object(object);
+}
+
+/*
+ * Make a object permanently gray (false positive).
+ */
+static inline void make_gray_object(unsigned long ptr)
+{
+	unsigned long flags;
+	struct memleak_object *object;
+
+	object = find_and_get_object(ptr, 0);
+	if (!object) {
+		dump_stack();
+		panic("kmemleak: graying unknown object at 0x%08lx\n", ptr);
+	}
+
+	spin_lock_irqsave(&object->lock, flags);
+	object->ref_count = 0;
+	spin_unlock_irqrestore(&object->lock, flags);
+	put_object(object);
+}
+
+/*
+ * Mark the object as black.
+ */
+static inline void make_black_object(unsigned long ptr)
+{
+	unsigned long flags;
+	struct memleak_object *object;
+
+	object = find_and_get_object(ptr, 0);
+	if (!object) {
+		dump_stack();
+		panic("kmemleak: blacking unknown object at 0x%08lx\n", ptr);
+	}
+
+	spin_lock_irqsave(&object->lock, flags);
+	object->ref_count = -1;
+	spin_unlock_irqrestore(&object->lock, flags);
+	put_object(object);
+}
+
+/*
+ * Add a scanning area to the object.
+ */
+static inline void add_scan_area(unsigned long ptr, unsigned long offset, size_t length)
+{
+	unsigned long flags;
+	struct memleak_object *object;
+	struct memleak_scan_area *area;
+
+	object = find_and_get_object(ptr, 0);
+	if (!object) {
+		dump_stack();
+		panic("kmemleak: adding scan area to unknown object at 0x%08lx\n", ptr);
+	}
+
+	area = kmem_cache_alloc(scan_area_cache, GFP_ATOMIC);
+	if (!area)
+		panic("kmemleak: cannot allocate a scan area\n");
+
+	spin_lock_irqsave(&object->lock, flags);
+	if (offset + length > object->size) {
+		dump_stack();
+		dump_object_info(object);
+		panic("kmemleak: scan area larger than object 0x%08lx\n", ptr);
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
+ * Log the early memleak_* calls.
+ */
+static void __init memleak_early_log(int op_type, const void *ptr, size_t size,
+				     int ref_count,
+				     unsigned long offset, size_t length)
+{
+	unsigned long flags;
+	struct early_log *log;
+
+	if (crt_early_log >= EARLY_LOG_NR)
+		panic("kmemleak: early log buffer exceeded\n");
+
+	local_irq_save(flags);
+	log = &early_log[crt_early_log];
+	log->op_type = op_type;
+	log->ptr = ptr;
+	log->size = size;
+	log->ref_count = ref_count;
+	log->offset = offset;
+	log->length = length;
+	crt_early_log++;
+	local_irq_restore(flags);
+}
+
+/*
+ * Allocation function hook.
+ */
+void memleak_alloc(const void *ptr, size_t size, int ref_count)
+{
+	pr_debug("%s(0x%p, %zu, %d)\n", __FUNCTION__, ptr, size, ref_count);
+
+	if (!atomic_read(&memleak_enabled)) {
+		memleak_early_log(MEMLEAK_ALLOC, ptr, size, ref_count, 0, 0);
+		return;
+	}
+	if (!ptr)
+		return;
+
+	create_object((unsigned long)ptr, size, ref_count);
+}
+EXPORT_SYMBOL_GPL(memleak_alloc);
+
+/*
+ * Freeing function hook.
+ */
+void memleak_free(const void *ptr)
+{
+	pr_debug("%s(0x%p)\n", __FUNCTION__, ptr);
+
+	if (!atomic_read(&memleak_enabled)) {
+		memleak_early_log(MEMLEAK_FREE, ptr, 0, 0, 0, 0);
+		return;
+	}
+	if (!ptr)
+		return;
+
+	delete_object((unsigned long)ptr);
+}
+EXPORT_SYMBOL_GPL(memleak_free);
+
+/*
+ * Mark a object as a false positive.
+ */
+void memleak_not_leak(const void *ptr)
+{
+	pr_debug("%s(0x%p)\n", __FUNCTION__, ptr);
+
+	if (!atomic_read(&memleak_enabled)) {
+		memleak_early_log(MEMLEAK_NOT_LEAK, ptr, 0, 0, 0, 0);
+		return;
+	}
+	if (!ptr)
+		return;
+
+	make_gray_object((unsigned long)ptr);
+}
+EXPORT_SYMBOL(memleak_not_leak);
+
+/*
+ * Ignore this memory object.
+ */
+void memleak_ignore(const void *ptr)
+{
+	pr_debug("%s(0x%p)\n", __FUNCTION__, ptr);
+
+	if (!atomic_read(&memleak_enabled)) {
+		memleak_early_log(MEMLEAK_IGNORE, ptr, 0, 0, 0, 0);
+		return;
+	}
+	if (!ptr)
+		return;
+
+	make_black_object((unsigned long)ptr);
+}
+EXPORT_SYMBOL(memleak_ignore);
+
+/*
+ * Add a scanning area to an object.
+ */
+void memleak_scan_area(const void *ptr, unsigned long offset, size_t length)
+{
+	pr_debug("%s(0x%p)\n", __FUNCTION__, ptr);
+
+	if (!atomic_read(&memleak_enabled)) {
+		memleak_early_log(MEMLEAK_SCAN_AREA, ptr, 0, 0, offset, length);
+		return;
+	}
+	if (!ptr)
+		return;
+
+	add_scan_area((unsigned long)ptr, offset, length);
+}
+EXPORT_SYMBOL(memleak_scan_area);
+
+static inline void scan_yield(void)
+{
+	BUG_ON(in_atomic());
+
+	if (time_is_before_eq_jiffies(next_scan_yield)) {
+		schedule();
+		next_scan_yield = jiffies + jiffies_scan_yield;
+	}
+	if (signal_pending(current))
+		scan_should_stop = 1;
+}
+
+/*
+ * Scan a block of memory (exclusive range) for pointers and move
+ * those found to the gray list.
+ */
+static void scan_block(void *_start, void *_end, struct memleak_object *scanned)
+{
+	unsigned long *ptr;
+	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_WORD);
+	unsigned long *end = _end - (BYTES_PER_WORD - 1);
+
+	for (ptr = start; ptr < end; ptr++) {
+		unsigned long flags;
+		unsigned long pointer = *ptr;
+		struct memleak_object *object;
+
+		if (scan_should_stop)
+			break;
+
+		/* If scanned, the CPU is yielded in the calling code */
+		if (!scanned)
+			scan_yield();
+
+		/*
+		 * The boundaries check doesn't need to be precise
+		 * (hence no locking) since orphan objects need to
+		 * pass a scanning threshold before being reported.
+		 */
+		if (pointer < min_addr || pointer >= max_addr)
+			continue;
+
+		object = find_and_get_object(pointer, 1);
+		if (!object)
+			continue;
+		if (object == scanned) {
+			/* self referenced */
+			put_object(object);
+			continue;
+		}
+
+		/*
+		 * Avoid the lockdep recursive warning on object->lock
+		 * being previously acquired in scan_object(). These
+		 * locks are enclosed by scan_mutex.
+		 */
+		spin_lock_irqsave_nested(&object->lock, flags, SINGLE_DEPTH_NESTING);
+		if (!color_white(object)) {
+			/* non-orphan, ignored or new */
+			spin_unlock_irqrestore(&object->lock, flags);
+			put_object(object);
+			continue;
+		}
+
+		object->count++;
+		if (color_gray(object))
+			/* the object became gray, add it to the list */
+			list_add_tail(&object->gray_list, &gray_list);
+		else
+			put_object(object);
+		spin_unlock_irqrestore(&object->lock, flags);
+	}
+}
+
+/*
+ * Scan a memory block represented by a memleak_object.
+ */
+static inline void scan_object(struct memleak_object *object)
+{
+	struct memleak_scan_area *area;
+	struct hlist_node *elem;
+	unsigned long flags;
+
+	spin_lock_irqsave(&object->lock, flags);
+
+	/* freed object */
+	if (!(object->flags & OBJECT_ALLOCATED))
+		goto out;
+
+	if (hlist_empty(&object->area_list))
+		scan_block((void *)object->pointer,
+			   (void *)(object->pointer + object->size), object);
+	else
+		hlist_for_each_entry(area, elem, &object->area_list, node)
+			scan_block((void *)(object->pointer + area->offset),
+				   (void *)(object->pointer + area->offset
+					    + area->length), object);
+
+ out:
+	spin_unlock_irqrestore(&object->lock, flags);
+}
+
+/*
+ * Scan the memory and print the orphan objects.
+ */
+static void memleak_scan(void)
+{
+	unsigned long flags;
+	struct memleak_object *object, *tmp;
+	int i;
+#ifdef SCAN_TASK_STACKS
+	struct task_struct *task;
+#endif
+
+	scan_should_stop = 0;
+
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
+	/* per-cpu scanning */
+	for_each_possible_cpu(i)
+		scan_block(__per_cpu_start + per_cpu_offset(i),
+			   __per_cpu_end + per_cpu_offset(i), NULL);
+#endif
+
+	/* mem_map scanning */
+	for_each_online_node(i) {
+		struct page *page, *end;
+
+		page = NODE_MEM_MAP(i);
+		end  = page + NODE_DATA(i)->node_spanned_pages;
+
+		scan_block(page, end, NULL);
+	}
+
+#ifdef SCAN_TASK_STACKS
+	read_lock(&tasklist_lock);
+	for_each_process(task)
+		scan_block(task_stack_page(task),
+			   task_stack_page(task) + THREAD_SIZE, NULL);
+	read_unlock(&tasklist_lock);
+#endif
+
+	/*
+	 * Scan the objects already referenced. More objects will be
+	 * referenced and, if there are no memory leaks, all the
+	 * objects will be scanned. The list traversal is safe for
+	 * both tail additions and removals from inside the loop. The
+	 * memleak objects cannot be freed from outside the loop
+	 * because their use_count was increased.
+	 */
+	object = list_entry(gray_list.next, typeof(*object), gray_list);
+	while (&object->gray_list != &gray_list) {
+		scan_yield();
+
+		/* may add new objects to the list */
+		if (!scan_should_stop)
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
+static void *memleak_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct memleak_object *object;
+	loff_t n = *pos;
+
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
+
+		if (get_object(object))
+			goto out;
+	}
+	object = NULL;
+ out:
+	rcu_read_unlock();
+	return object;
+}
+
+static void *memleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct list_head *n;
+	struct memleak_object *next = NULL;
+	unsigned long flags;
+
+	++(*pos);
+	if (reported_leaks >= REPORTS_NR)
+		goto out;
+
+	spin_lock_irqsave(&object_list_lock, flags);
+	n = ((struct memleak_object *)v)->object_list.next;
+	if (n != &object_list) {
+		next = list_entry(n, struct memleak_object, object_list);
+		get_object(next);
+	}
+	spin_unlock_irqrestore(&object_list_lock, flags);
+
+ out:
+	put_object(v);
+	return next;
+}
+
+static void memleak_seq_stop(struct seq_file *seq, void *v)
+{
+	if (v)
+		put_object(v);
+}
+
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
+static struct seq_operations memleak_seq_ops = {
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
+static struct file_operations memleak_fops = {
+	.owner	 = THIS_MODULE,
+	.open    = memleak_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = memleak_seq_release,
+};
+
+static int memleak_scan_thread(void *arg)
+{
+	/* sleep before the first scan */
+	ssleep(SECS_FIRST_SCAN);
+
+	while (!kthread_should_stop()) {
+		struct memleak_object *object;
+
+		mutex_lock(&scan_mutex);
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
+		ssleep(SECS_SCAN_PERIOD);
+	}
+
+	return 0;
+}
+
+/*
+ * Kmemleak initialization.
+ */
+void __init memleak_init(void)
+{
+	int i;
+
+	jiffies_scan_yield = msecs_to_jiffies(MSECS_SCAN_YIELD);
+	jiffies_min_age = msecs_to_jiffies(MSECS_MIN_AGE);
+	object_cache = kmem_cache_create("kmemleak_object",
+					 sizeof(struct memleak_object),
+					 0, SLAB_NOLEAKTRACE, NULL);
+	scan_area_cache = kmem_cache_create("kmemleak_scan_area",
+					    sizeof(struct memleak_scan_area),
+					    0, SLAB_NOLEAKTRACE, NULL);
+	INIT_PRIO_TREE_ROOT(&object_tree_root);
+
+	/*
+	 * This is the point where tracking allocations is safe.
+	 * Scanning is only available later.
+	 */
+	atomic_set(&memleak_enabled, 1);
+
+	/* execute the early logged operations */
+	for (i = 0; i < crt_early_log; i++) {
+		struct early_log *log = &early_log[i];
+
+		switch (log->op_type) {
+		case MEMLEAK_ALLOC:
+			memleak_alloc(log->ptr, log->size, log->ref_count);
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
+			memleak_scan_area(log->ptr, log->offset, log->length);
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
+	dentry = debugfs_create_file("memleak", S_IRUGO, NULL, NULL,
+				     &memleak_fops);
+	if (!dentry)
+		return -ENOMEM;
+
+	scan_thread = kthread_run(memleak_scan_thread, NULL, "kmemleak");
+	if (IS_ERR(scan_thread))
+		pr_warning("kmemleak: Failed to initialise the scan thread\n");
+
+	pr_info("Kernel memory leak detector initialized\n");
+
+	return 0;
+}
+late_initcall(memleak_late_init);


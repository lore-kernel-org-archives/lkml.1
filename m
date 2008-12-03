Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbYLCSMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbYLCSMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYLCSML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:12:11 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51237 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYLCSMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:12:07 -0500
Date: Wed, 3 Dec 2008 10:12:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28-rc5 01/11] kmemleak: Add the base support
Message-ID: <20081203181202.GA10031@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com> <20081120113033.16607.19928.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120113033.16607.19928.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 11:30:34AM +0000, Catalin Marinas wrote:
> This patch adds the base support for the kernel memory leak
> detector. It traces the memory allocation/freeing in a way similar to
> the Boehm's conservative garbage collector, the difference being that
> the unreferenced objects are not freed but only shown in
> /sys/kernel/debug/memleak. Enabling this feature introduces an
> overhead to memory allocations.

Hello, Catalin,

I have some concerns about your locking/RCU design, please see
interspersed questions and comments.

							Thanx, Paul

> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  include/linux/memleak.h |   60 +++
>  init/main.c             |    4 
>  mm/memleak.c            | 1012 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1075 insertions(+), 1 deletions(-)
>  create mode 100644 include/linux/memleak.h
>  create mode 100644 mm/memleak.c
> 
> diff --git a/include/linux/memleak.h b/include/linux/memleak.h
> new file mode 100644
> index 0000000..29b3ecb
> --- /dev/null
> +++ b/include/linux/memleak.h
> @@ -0,0 +1,60 @@
> +/*
> + * include/linux/memleak.h
> + *
> + * Copyright (C) 2008 ARM Limited
> + * Written by Catalin Marinas <catalin.marinas@arm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +
> +#ifndef __MEMLEAK_H
> +#define __MEMLEAK_H
> +
> +#ifdef CONFIG_DEBUG_MEMLEAK
> +
> +extern void memleak_init(void);
> +extern void memleak_alloc(const void *ptr, size_t size, int ref_count);
> +extern void memleak_free(const void *ptr);
> +extern void memleak_padding(const void *ptr, unsigned long offset, size_t size);
> +extern void memleak_not_leak(const void *ptr);
> +extern void memleak_ignore(const void *ptr);
> +extern void memleak_scan_area(const void *ptr, unsigned long offset, size_t length);
> +
> +static inline void memleak_erase(void **ptr)
> +{
> +	*ptr = NULL;
> +}
> +
> +#else
> +
> +#define DECLARE_MEMLEAK_OFFSET(name, type, member)
> +
> +static inline void memleak_init(void)
> +{ }
> +static inline void memleak_alloc(const void *ptr, size_t size, int ref_count)
> +{ }
> +static inline void memleak_free(const void *ptr)
> +{ }
> +static inline void memleak_not_leak(const void *ptr)
> +{ }
> +static inline void memleak_ignore(const void *ptr)
> +{ }
> +static inline void memleak_scan_area(const void *ptr, unsigned long offset, size_t length)
> +{ }
> +static inline void memleak_erase(void **ptr)
> +{ }
> +
> +#endif	/* CONFIG_DEBUG_MEMLEAK */
> +
> +#endif	/* __MEMLEAK_H */
> diff --git a/init/main.c b/init/main.c
> index 7e117a2..e7f4d8c 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -63,6 +63,7 @@
>  #include <linux/signal.h>
>  #include <linux/idr.h>
>  #include <linux/ftrace.h>
> +#include <linux/memleak.h>
> 
>  #include <asm/io.h>
>  #include <asm/bugs.h>
> @@ -652,6 +653,8 @@ asmlinkage void __init start_kernel(void)
>  	mem_init();
>  	enable_debug_pagealloc();
>  	cpu_hotplug_init();
> +	prio_tree_init();
> +	memleak_init();
>  	kmem_cache_init();
>  	debug_objects_mem_init();
>  	idr_init_cache();
> @@ -662,7 +665,6 @@ asmlinkage void __init start_kernel(void)
>  	calibrate_delay();
>  	pidmap_init();
>  	pgtable_cache_init();
> -	prio_tree_init();
>  	anon_vma_init();
>  #ifdef CONFIG_X86
>  	if (efi_enabled)
> diff --git a/mm/memleak.c b/mm/memleak.c
> new file mode 100644
> index 0000000..8fb5260
> --- /dev/null
> +++ b/mm/memleak.c
> @@ -0,0 +1,1012 @@
> +/*
> + * mm/memleak.c
> + *
> + * Copyright (C) 2008 ARM Limited
> + * Written by Catalin Marinas <catalin.marinas@arm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/sched.h>
> +#include <linux/jiffies.h>
> +#include <linux/module.h>
> +#include <linux/prio_tree.h>
> +#include <linux/gfp.h>
> +#include <linux/kallsyms.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/cpumask.h>
> +#include <linux/spinlock.h>
> +#include <linux/rcupdate.h>
> +#include <linux/stacktrace.h>
> +#include <linux/cache.h>
> +#include <linux/percpu.h>
> +#include <linux/lockdep.h>
> +
> +#include <asm/sections.h>
> +#include <asm/processor.h>
> +#include <asm/thread_info.h>
> +#include <asm/atomic.h>
> +
> +#include <linux/memleak.h>
> +
> +/*
> + * kmemleak configuration and common defines
> + */
> +#define MAX_TRACE		16	/* stack trace length */
> +#define REPORT_THLD		1	/* unreferenced reporting threshold */
> +#define REPORTS_NR		100	/* maximum number of reported leaks */
> +#undef SCAN_TASK_STACKS			/* scan the task kernel stacks */
> +#undef REPORT_ORPHAN_FREEING		/* notify when freeing orphan objects */
> +#undef FAST_CACHE_STATS			/* fast_cache statistics */
> +
> +#define BYTES_PER_WORD		sizeof(void *)
> +#define MSECS_SCAN_YIELD	100
> +
> +/*
> + * Simple lock-free memory allocator using pages. Objects are
> + * allocated on a CPU but can be freed on a different one
> + */
> +struct fast_cache {
> +	struct list_head free_list[NR_CPUS];
> +	size_t obj_size;
> +	int objs_per_page;
> +#ifdef FAST_CACHE_STATS
> +	int pages_nr[NR_CPUS];
> +	int free_nr[NR_CPUS];
> +#endif
> +};
> +
> +/*
> + * Cache page information
> + */
> +struct fast_cache_page {
> +	int free_nr[NR_CPUS];
> +	char data[0] ____cacheline_aligned_in_smp;
> +};
> +
> +#define entry_to_page(entry) \
> +	((struct fast_cache_page *)((unsigned long)(entry) & ~(PAGE_SIZE - 1)))
> +
> +#ifdef CONFIG_SMP
> +#define cache_line_align(x)	L1_CACHE_ALIGN(x)
> +#else
> +#define cache_line_align(x)	(x)
> +#endif
> +
> +#ifdef FAST_CACHE_STATS
> +#define fast_cache_inc_pages(cache, cpu)	((cache)->pages_nr[cpu]++)
> +#define fast_cache_dec_pages(cache, cpu)	((cache)->pages_nr[cpu]--)
> +#define fast_cache_inc_free(cache, cpu)		((cache)->free_nr[cpu]++)
> +#define fast_cache_dec_free(cache, cpu)		((cache)->free_nr[cpu]--)
> +static void fast_cache_dump_stats(struct fast_cache *cache, const char *name)
> +{
> +	unsigned int cpu = get_cpu();
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	pr_info("kmemleak: %s statistics\n", name);
> +	pr_info("  obj_size: %d\n", cache->obj_size);
> +	pr_info("  objs_per_page: %d\n", cache->objs_per_page);
> +	for_each_online_cpu(cpu) {
> +		pr_info("  CPU: %d\n", cpu);
> +		pr_info("    pages_nr: %d\n", cache->pages_nr[cpu]);
> +		pr_info("    free_nr: %d\n", cache->free_nr[cpu]);
> +	}
> +	local_irq_restore(flags);
> +	put_cpu();
> +}
> +#else
> +#define fast_cache_inc_pages(cache, cpu)
> +#define fast_cache_dec_pages(cache, cpu)
> +#define fast_cache_inc_free(cache, cpu)
> +#define fast_cache_dec_free(cache, cpu)
> +static inline void fast_cache_dump_stats(struct fast_cache *cache, const char *name)
> +{ }
> +#endif
> +
> +/*
> + * Initialize the cache. This function must be called before any
> + * tracked memory allocations take place
> + */
> +static void fast_cache_init(struct fast_cache *cache, size_t size)
> +{
> +	unsigned int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		INIT_LIST_HEAD(&cache->free_list[cpu]);
> +#ifdef FAST_CACHE_STATS
> +		cache->pages_nr[cpu] = 0;
> +		cache->free_nr[cpu] = 0;
> +#endif
> +	}
> +	cache->obj_size = cache_line_align(sizeof(struct list_head) + size);
> +	cache->objs_per_page = (PAGE_SIZE - sizeof(struct fast_cache_page)) /
> +		cache->obj_size;
> +}
> +
> +/*
> + * Expand the free list for the current CPU. Called with interrupts
> + * and preemption disabled
> + */
> +static inline void __fast_cache_grow(struct fast_cache *cache, unsigned int cpu)
> +{
> +	struct fast_cache_page *page;
> +	void *pos, *last;
> +	unsigned int c;
> +
> +	page = (struct fast_cache_page *)__get_free_page(GFP_ATOMIC);
> +	if (!page)
> +		panic("kmemleak: cannot allocate page for fast_cache\n");
> +	fast_cache_inc_pages(cache, cpu);
> +
> +	for_each_possible_cpu(c)
> +		page->free_nr[c] = 0;
> +	page->free_nr[cpu] = cache->objs_per_page;
> +
> +	last = (void *)page + PAGE_SIZE - cache->obj_size;
> +	for (pos = page->data; pos <= last; pos += cache->obj_size) {
> +		struct list_head *entry = pos;
> +		list_add_tail(entry, &cache->free_list[cpu]);
> +		fast_cache_inc_free(cache, cpu);
> +	}
> +}
> +
> +/*
> + * Shrink the free list for the current CPU and free the specified
> + * page. Called with interrupts and preemption disabled
> + */
> +static inline void __fast_cache_shrink(struct fast_cache *cache, unsigned int cpu,
> +				       struct fast_cache_page *page)
> +{
> +	void *pos;
> +	void *last = (void *)page + PAGE_SIZE - cache->obj_size;
> +
> +	for (pos = page->data; pos <= last; pos += cache->obj_size) {
> +		struct list_head *entry = pos;
> +		/* entry present only in cache->free_list[cpu] */
> +		list_del(entry);
> +		fast_cache_dec_free(cache, cpu);
> +	}
> +
> +	free_page((unsigned long)page);
> +	fast_cache_dec_pages(cache, cpu);
> +}
> +
> +/*
> + * Object allocation
> + */
> +static void *fast_cache_alloc(struct fast_cache *cache)
> +{
> +	unsigned int cpu = get_cpu();
> +	unsigned long flags;
> +	struct list_head *entry;
> +	struct fast_cache_page *page;
> +
> +	local_irq_save(flags);
> +
> +	if (list_empty(&cache->free_list[cpu]))
> +		__fast_cache_grow(cache, cpu);
> +
> +	entry = cache->free_list[cpu].next;
> +	page = entry_to_page(entry);
> +	list_del(entry);
> +	page->free_nr[cpu]--;
> +	BUG_ON(page->free_nr[cpu] < 0);
> +	fast_cache_dec_free(cache, cpu);
> +
> +	local_irq_restore(flags);
> +	put_cpu_no_resched();
> +
> +	return (void *)(entry + 1);
> +}
> +
> +/*
> + * Object freeing
> + */
> +static void fast_cache_free(struct fast_cache *cache, void *obj)
> +{
> +	unsigned int cpu = get_cpu();
> +	unsigned long flags;
> +	struct list_head *entry = (struct list_head *)obj - 1;
> +	struct fast_cache_page *page = entry_to_page(entry);
> +
> +	local_irq_save(flags);
> +
> +	list_add(entry, &cache->free_list[cpu]);
> +	page->free_nr[cpu]++;
> +	BUG_ON(page->free_nr[cpu] > cache->objs_per_page);
> +	fast_cache_inc_free(cache, cpu);
> +
> +	if (page->free_nr[cpu] == cache->objs_per_page)
> +		__fast_cache_shrink(cache, cpu, page);
> +
> +	local_irq_restore(flags);
> +	put_cpu_no_resched();
> +}
> +
> +/* scanning area inside a memory block */
> +struct memleak_scan_area {
> +	struct hlist_node node;
> +	unsigned long offset;
> +	size_t length;
> +};
> +
> +/* the main allocation tracking object */
> +struct memleak_object {
> +	spinlock_t lock;
> +	unsigned long flags;
> +	struct list_head object_list;
> +	struct list_head gray_list;
> +	struct prio_tree_node tree_node;
> +	struct rcu_head rcu;		/* used for object_list lockless traversal */
> +	atomic_t use_count;		/* internal usage count */
> +	unsigned long pointer;
> +	size_t size;
> +	int ref_count;			/* the minimum encounters of the pointer */
> +	int count;			/* the ecounters of the pointer */
> +	int report_thld;		/* the unreferenced reporting threshold */
> +	struct hlist_head area_list;	/* areas to be scanned (or empty for all) */
> +	unsigned long trace[MAX_TRACE];
> +	unsigned int trace_len;
> +	unsigned long jiffies;		/* creation timestamp */
> +	pid_t pid;			/* pid of the current task */
> +	char comm[TASK_COMM_LEN];	/* executable name */
> +};
> +
> +/* The list of all allocated objects */
> +static LIST_HEAD(object_list);
> +static DEFINE_SPINLOCK(object_list_lock);
> +/* The list of the gray objects */
> +static LIST_HEAD(gray_list);
> +/* prio search tree for object boundaries */
> +static struct prio_tree_root object_tree_root;
> +static DEFINE_RWLOCK(object_tree_lock);
> +
> +/* allocation pools */
> +static struct fast_cache object_cache;
> +static struct fast_cache scan_area_cache;
> +
> +static atomic_t memleak_enabled = ATOMIC_INIT(0);
> +static int reported_leaks;
> +
> +/* minimum and maximum address that may be valid pointers */
> +static unsigned long min_addr = ~0;
> +static unsigned long max_addr;
> +
> +/* used for yielding the CPU to other tasks during scanning */
> +static unsigned long next_scan_yield;
> +
> +/* object flags */
> +#define OBJECT_ALLOCATED	0x1
> +
> +/*
> + * Object colors, encoded with count and ref_count:
> + *   - white - orphan object, i.e. not enough references to it (ref_count >= 1)
> + *   - gray  - referred at least once and therefore non-orphan (ref_count == 0)
> + *   - black - ignore; it doesn't contain references (text section) (ref_count == -1)
> + */
> +static inline int color_white(const struct memleak_object *object)
> +{
> +	return object->count != -1 && object->count < object->ref_count;
> +}
> +
> +static inline int color_gray(const struct memleak_object *object)
> +{
> +	return object->ref_count != -1 && object->count >= object->ref_count;
> +}
> +
> +static inline int color_black(const struct memleak_object *object)
> +{
> +	return object->ref_count == -1;
> +}
> +
> +static void dump_object_info(struct memleak_object *object)
> +{
> +	struct stack_trace trace;
> +
> +	trace.nr_entries = object->trace_len;
> +	trace.entries = object->trace;
> +
> +	pr_notice("kmemleak: object 0x%08lx (size %u):\n",
> +		  object->tree_node.start, object->size);
> +	pr_notice("  comm \"%s\", pid %d, jiffies %lu\n",
> +		  object->comm, object->pid, object->jiffies);
> +	pr_notice("  ref_count = %d\n", object->ref_count);
> +	pr_notice("  count = %d\n", object->count);
> +	pr_notice("  backtrace:\n");
> +	print_stack_trace(&trace, 4);
> +}
> +
> +static struct memleak_object *lookup_object(unsigned long ptr, int alias)
> +{
> +	struct prio_tree_node *node;
> +	struct prio_tree_iter iter;
> +	struct memleak_object *object;
> +
> +	prio_tree_iter_init(&iter, &object_tree_root, ptr, ptr);
> +	node = prio_tree_next(&iter);
> +	if (node) {
> +		object = prio_tree_entry(node, struct memleak_object, tree_node);
> +		if (!alias && object->pointer != ptr) {
> +			pr_warning("kmemleak: found object by alias");
> +			object = NULL;
> +		}
> +	} else
> +		object = NULL;
> +
> +	return object;
> +}
> +
> +/*
> + * return 1 if successful or 0 otherwise
> + */
> +static inline int get_object(struct memleak_object *object)
> +{
> +	return atomic_inc_not_zero(&object->use_count);
> +}
> +
> +static void free_object_rcu(struct rcu_head *rcu)
> +{
> +	struct hlist_node *elem, *tmp;
> +	struct memleak_scan_area *area;
> +	struct memleak_object *object =
> +		container_of(rcu, struct memleak_object, rcu);
> +
> +	/* once use_count is 0, there is no code accessing the object */

OK, so we won't pass free_object_rcu() to call_rcu() until use_count
is equal to zero.  And once use_count is zero, it is never incremented.
So the point of the RCU grace period is to ensure that all tasks
who didn't quite call get_object() soon enough get done failing
before we free up the object, correct?

Which means that get_object() needs to be under rcu_read_lock()...

> +	hlist_for_each_entry_safe(area, elem, tmp, &object->area_list, node) {
> +		hlist_del(elem);
> +		fast_cache_free(&scan_area_cache, area);
> +	}
> +	fast_cache_free(&object_cache, object);
> +}
> +
> +static void put_object(struct memleak_object *object)
> +{
> +	unsigned long flags;
> +
> +	if (!atomic_dec_and_test(&object->use_count))
> +		return;
> +
> +	/* should only get here after delete_object was called */
> +	BUG_ON(object->flags & OBJECT_ALLOCATED);
> +
> +	spin_lock_irqsave(&object_list_lock, flags);

We also need to write-hold the object_tree_lock, not?

> +	/* the last reference to this object */
> +	list_del_rcu(&object->object_list);
> +	call_rcu(&object->rcu, free_object_rcu);
> +	spin_unlock_irqrestore(&object_list_lock, flags);
> +}
> +
> +static struct memleak_object *find_and_get_object(unsigned long ptr, int alias)
> +{
> +	unsigned long flags;
> +	struct memleak_object *object;
> +
> +	read_lock_irqsave(&object_tree_lock, flags);

Use of read_lock_irqsave() will work, but only if -all- deletions are
protected by write-acquiring object_tree_lock.

Or unless there is an enclosing rcu_read_lock() around all calls to
find_and_get_object().

> +	object = lookup_object(ptr, alias);
> +	if (object)
> +		get_object(object);
> +	read_unlock_irqrestore(&object_tree_lock, flags);
> +
> +	return object;
> +}
> +
> +/*
> + * Insert a pointer into the pointer hash table
> + */
> +static inline void create_object(unsigned long ptr, size_t size, int ref_count)
> +{
> +	unsigned long flags;
> +	struct memleak_object *object;
> +	struct prio_tree_node *node;
> +	struct stack_trace trace;
> +
> +	object = fast_cache_alloc(&object_cache);
> +	if (!object)
> +		panic("kmemleak: cannot allocate a memleak_object structure\n");
> +
> +	INIT_LIST_HEAD(&object->object_list);
> +	INIT_LIST_HEAD(&object->gray_list);
> +	INIT_HLIST_HEAD(&object->area_list);
> +	spin_lock_init(&object->lock);
> +	atomic_set(&object->use_count, 1);
> +	object->flags = OBJECT_ALLOCATED;
> +	object->pointer = ptr;
> +	object->size = size;
> +	object->ref_count = ref_count;
> +	object->count = -1;				/* black color initially */
> +	object->report_thld = REPORT_THLD;
> +	object->jiffies = jiffies;
> +	if (in_irq()) {
> +		object->pid = 0;
> +		strncpy(object->comm, "hardirq", TASK_COMM_LEN);
> +	} else if (in_softirq()) {
> +		object->pid = 0;
> +		strncpy(object->comm, "softirq", TASK_COMM_LEN);
> +	} else {
> +		object->pid = current->pid;
> +		strncpy(object->comm, current->comm, TASK_COMM_LEN);
> +	}
> +
> +	trace.max_entries = MAX_TRACE;
> +	trace.nr_entries = 0;
> +	trace.entries = object->trace;
> +	trace.skip = 1;
> +	save_stack_trace(&trace);
> +
> +	object->trace_len = trace.nr_entries;
> +
> +	INIT_PRIO_TREE_NODE(&object->tree_node);
> +	object->tree_node.start = ptr;
> +	object->tree_node.last = ptr + size - 1;
> +
> +	if (ptr < min_addr)
> +		min_addr = ptr;
> +	if (ptr + size > max_addr)
> +		max_addr = ptr + size;
> +	/* update the boundaries before inserting the object in the
> +	 * prio search tree */
> +	smp_mb();
> +
> +	write_lock_irqsave(&object_tree_lock, flags);
> +	node = prio_tree_insert(&object_tree_root, &object->tree_node);
> +	if (node != &object->tree_node) {
> +		unsigned long flags;
> +
> +		pr_warning("kmemleak: existing pointer\n");
> +		dump_stack();
> +
> +		object = lookup_object(ptr, 1);
> +		spin_lock_irqsave(&object->lock, flags);
> +		dump_object_info(object);
> +		spin_unlock_irqrestore(&object->lock, flags);
> +
> +		panic("kmemleak: cannot insert 0x%lx into the object search tree\n",
> +		      ptr);
> +	}
> +	write_unlock_irqrestore(&object_tree_lock, flags);

In theory, you are OK here, but only because the below is adding
an element (not removing it).  But this code is looking pretty dodgy.

What exactly does object_tree_lock protect?  What exactly does
object_list protect?

> +
> +	spin_lock_irqsave(&object_list_lock, flags);
> +	list_add_tail_rcu(&object->object_list, &object_list);
> +	spin_unlock_irqrestore(&object_list_lock, flags);
> +}
> +
> +/*
> + * Remove a pointer from the pointer hash table
> + */
> +static inline void delete_object(unsigned long ptr)
> +{
> +	unsigned long flags;
> +	struct memleak_object *object;
> +
> +	write_lock_irqsave(&object_tree_lock, flags);
> +	object = lookup_object(ptr, 0);
> +	if (!object) {
> +		pr_warning("kmemleak: freeing unknown object at 0x%08lx\n", ptr);
> +		dump_stack();
> +		write_unlock_irqrestore(&object_tree_lock, flags);
> +		return;
> +	}
> +	prio_tree_remove(&object_tree_root, &object->tree_node);
> +	write_unlock_irqrestore(&object_tree_lock, flags);
> +
> +	BUG_ON(!(object->flags & OBJECT_ALLOCATED));
> +
> +	spin_lock_irqsave(&object->lock, flags);
> +	object->flags &= ~OBJECT_ALLOCATED;
> +#ifdef REPORT_ORPHAN_FREEING
> +	if (color_white(object)) {
> +		pr_warning("kmemleak: freeing orphan object 0x%08lx\n", ptr);
> +		dump_stack();
> +		dump_object_info(object);
> +	}
> +#endif
> +	object->pointer = 0;
> +	spin_unlock_irqrestore(&object->lock, flags);
> +
> +	put_object(object);
> +}
> +
> +/*
> + * Make a object permanently gray (false positive)
> + */
> +static inline void make_gray_object(unsigned long ptr)
> +{
> +	unsigned long flags;
> +	struct memleak_object *object;
> +
> +	object = find_and_get_object(ptr, 0);
> +	if (!object) {
> +		dump_stack();
> +		panic("kmemleak: graying unknown object at 0x%08lx\n", ptr);
> +	}
> +
> +	spin_lock_irqsave(&object->lock, flags);
> +	object->ref_count = 0;
> +	spin_unlock_irqrestore(&object->lock, flags);
> +	put_object(object);
> +}
> +
> +/*
> + * Mark the object as black
> + */
> +static inline void make_black_object(unsigned long ptr)
> +{
> +	unsigned long flags;
> +	struct memleak_object *object;
> +
> +	object = find_and_get_object(ptr, 0);
> +	if (!object) {
> +		dump_stack();
> +		panic("kmemleak: blacking unknown object at 0x%08lx\n", ptr);
> +	}
> +
> +	spin_lock_irqsave(&object->lock, flags);
> +	object->ref_count = -1;
> +	spin_unlock_irqrestore(&object->lock, flags);
> +	put_object(object);
> +}
> +
> +/*
> + * Add a scanning area to the object
> + */
> +static inline void add_scan_area(unsigned long ptr, unsigned long offset, size_t length)
> +{
> +	unsigned long flags;
> +	struct memleak_object *object;
> +	struct memleak_scan_area *area;
> +
> +	object = find_and_get_object(ptr, 0);
> +	if (!object) {
> +		dump_stack();
> +		panic("kmemleak: adding scan area to unknown object at 0x%08lx\n", ptr);
> +	}
> +
> +	spin_lock_irqsave(&object->lock, flags);
> +	if (offset + length > object->size) {
> +		dump_stack();
> +		dump_object_info(object);
> +		panic("kmemleak: scan area larger than object 0x%08lx\n", ptr);
> +	}
> +
> +	area = fast_cache_alloc(&scan_area_cache);
> +	if (!area)
> +		panic("kmemleak: cannot allocate a scan area\n");
> +
> +	INIT_HLIST_NODE(&area->node);
> +	area->offset = offset;
> +	area->length = length;
> +
> +	hlist_add_head(&area->node, &object->area_list);
> +	spin_unlock_irqrestore(&object->lock, flags);
> +	put_object(object);
> +}
> +
> +/*
> + * Allocation function hook
> + */
> +void memleak_alloc(const void *ptr, size_t size, int ref_count)
> +{
> +	pr_debug("%s(0x%p, %u, %d)\n", __FUNCTION__, ptr, size, ref_count);
> +
> +	if (!atomic_read(&memleak_enabled))
> +		return;
> +	if (!ptr)
> +		return;
> +
> +	create_object((unsigned long)ptr, size, ref_count);
> +}
> +EXPORT_SYMBOL_GPL(memleak_alloc);
> +
> +/*
> + * Freeing function hook
> + */
> +void memleak_free(const void *ptr)
> +{
> +	pr_debug("%s(0x%p)\n", __FUNCTION__, ptr);
> +
> +	if (!atomic_read(&memleak_enabled))
> +		return;
> +	if (!ptr)
> +		return;
> +
> +	delete_object((unsigned long)ptr);
> +}
> +EXPORT_SYMBOL_GPL(memleak_free);
> +
> +/*
> + * Mark a object as a false positive
> + */
> +void memleak_not_leak(const void *ptr)
> +{
> +	pr_debug("%s(0x%p)\n", __FUNCTION__, ptr);
> +
> +	if (!atomic_read(&memleak_enabled))
> +		return;
> +	if (!ptr)
> +		return;
> +
> +	make_gray_object((unsigned long)ptr);
> +}
> +EXPORT_SYMBOL(memleak_not_leak);
> +
> +/*
> + * Ignore this memory object
> + */
> +void memleak_ignore(const void *ptr)
> +{
> +	pr_debug("%s(0x%p)\n", __FUNCTION__, ptr);
> +
> +	if (!atomic_read(&memleak_enabled))
> +		return;
> +	if (!ptr)
> +		return;
> +
> +	make_black_object((unsigned long)ptr);
> +}
> +EXPORT_SYMBOL(memleak_ignore);
> +
> +/*
> + * Add a scanning area to an object
> + */
> +void memleak_scan_area(const void *ptr, unsigned long offset, size_t length)
> +{
> +	pr_debug("%s(0x%p)\n", __FUNCTION__, ptr);
> +
> +	if (!atomic_read(&memleak_enabled))
> +		return;
> +	if (!ptr)
> +		return;
> +
> +	add_scan_area((unsigned long)ptr, offset, length);
> +}
> +EXPORT_SYMBOL(memleak_scan_area);
> +
> +static inline void scan_yield(void)
> +{
> +	BUG_ON(in_atomic());
> +
> +	if (time_is_before_eq_jiffies(next_scan_yield)) {
> +		schedule();
> +		next_scan_yield = jiffies + msecs_to_jiffies(MSECS_SCAN_YIELD);
> +	}
> +}
> +
> +/*
> + * Scan a block of memory (exclusive range) for pointers and move
> + * those found to the gray list
> + */
> +static void scan_block(void *_start, void *_end, struct memleak_object *scanned)
> +{
> +	unsigned long *ptr;
> +	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_WORD);
> +	unsigned long *end = _end - (BYTES_PER_WORD - 1);
> +
> +	for (ptr = start; ptr < end; ptr++) {
> +		unsigned long flags;
> +		unsigned long pointer = *ptr;
> +		struct memleak_object *object;
> +
> +		if (!scanned)
> +			scan_yield();
> +
> +		/* the boundaries check doesn't need to be precise
> +		 * (hence no locking) since orphan objects need to
> +		 * pass a scanning threshold before being reported */
> +		if (pointer < min_addr || pointer >= max_addr)
> +			continue;
> +
> +		object = find_and_get_object(pointer, 1);
> +		if (!object)
> +			continue;
> +		if (object == scanned) {
> +			/* self referenced */
> +			put_object(object);
> +			continue;
> +		}
> +
> +		/* avoid the lockdep recursive warning on object->lock
> +		 * being previously acquired in scan_object(). These
> +		 * locks are enclosed by a mutex aquired in seq_open */
> +		spin_lock_irqsave_nested(&object->lock, flags, SINGLE_DEPTH_NESTING);
> +		if (!color_white(object)) {
> +			/* non-orphan or ignored */
> +			spin_unlock_irqrestore(&object->lock, flags);
> +			put_object(object);
> +			continue;
> +		}
> +
> +		object->count++;
> +		if (color_gray(object)) {
> +			/* the object became gray, add it to the list */
> +			object->report_thld++;
> +			list_add_tail(&object->gray_list, &gray_list);
> +		} else
> +			put_object(object);
> +		spin_unlock_irqrestore(&object->lock, flags);
> +	}
> +}
> +
> +/*
> + * Scan a memory block represented by a memleak_object
> + */
> +static inline void scan_object(struct memleak_object *object)
> +{
> +	struct memleak_scan_area *area;
> +	struct hlist_node *elem;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&object->lock, flags);
> +
> +	/* freed object */
> +	if (!(object->flags & OBJECT_ALLOCATED))
> +		goto out;
> +
> +	if (hlist_empty(&object->area_list))
> +		scan_block((void *)object->pointer,
> +			   (void *)(object->pointer + object->size), object);
> +	else
> +		hlist_for_each_entry(area, elem, &object->area_list, node)
> +			scan_block((void *)(object->pointer + area->offset),
> +				   (void *)(object->pointer + area->offset
> +					    + area->length), object);
> +
> + out:
> +	spin_unlock_irqrestore(&object->lock, flags);
> +}
> +
> +/*
> + * Scan the memory and print the orphan objects
> + */
> +static void memleak_scan(void)
> +{
> +	unsigned long flags;
> +	struct memleak_object *object, *tmp;
> +	int i;
> +#ifdef SCAN_TASK_STACKS
> +	struct task_struct *task;
> +#endif
> +
> +	fast_cache_dump_stats(&object_cache, "object_cache");
> +	fast_cache_dump_stats(&scan_area_cache, "scan_area_cache");
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(object, &object_list, object_list) {
> +		spin_lock_irqsave(&object->lock, flags);
> +
> +#ifdef DEBUG
> +		/* with a few exceptions there should be a maximum of
> +		 * 1 reference to any object at this point */
> +		if (atomic_read(&object->use_count) > 1) {
> +			pr_debug("kmemleak: object->use_count = %d\n",
> +				 atomic_read(&object->use_count));
> +			dump_object_info(object);
> +		}
> +#endif
> +
> +		/* reset the reference count (whiten the object) */
> +		object->count = 0;
> +		if (color_gray(object) && get_object(object))
> +			list_add_tail(&object->gray_list, &gray_list);

What prevents other tasks from concurrently adding other objects to
gray_list?  Preventing such concurrent adds is absolutely required,
otherwise gray_list will be corrupted.

> +		else
> +			object->report_thld--;
> +
> +		spin_unlock_irqrestore(&object->lock, flags);
> +	}
> +	rcu_read_unlock();
> +
> +	/* data/bss scanning */
> +	scan_block(_sdata, _edata, NULL);
> +	scan_block(__bss_start, __bss_stop, NULL);
> +
> +#ifdef CONFIG_SMP
> +	/* per-cpu scanning */
> +	for_each_possible_cpu(i)
> +		scan_block(__per_cpu_start + per_cpu_offset(i),
> +			   __per_cpu_end + per_cpu_offset(i), NULL);
> +#endif
> +
> +	/* mem_map scanning */
> +	for_each_online_node(i) {
> +		struct page *page, *end;
> +
> +		page = NODE_MEM_MAP(i);
> +		end  = page + NODE_DATA(i)->node_spanned_pages;
> +
> +		scan_block(page, end, NULL);
> +	}
> +
> +#ifdef SCAN_TASK_STACKS
> +	read_lock(&tasklist_lock);
> +	for_each_process(task)
> +		scan_block(task_stack_page(task),
> +			   task_stack_page(task) + THREAD_SIZE, NULL);
> +	read_unlock(&tasklist_lock);
> +#endif
> +
> +	/* scan the objects already referenced. More objects will be
> +	 * referenced and, if there are no memory leaks, all the
> +	 * objects will be scanned. The list traversal is safe for
> +	 * both tail additions and removals from inside the loop. The
> +	 * memleak objects cannot be freed from outside the loop
> +	 * because their use_count was increased */
> +	object = list_entry(gray_list.next, typeof(*object), gray_list);
> +	while (&object->gray_list != &gray_list) {
> +		scan_yield();
> +
> +		/* may add new objects to the list */
> +		scan_object(object);
> +
> +		tmp = list_entry(object->gray_list.next, typeof(*object),
> +				 gray_list);
> +
> +		/* remove the object from the list and release it */
> +		list_del(&object->gray_list);
> +		put_object(object);
> +
> +		object = tmp;
> +	}
> +	BUG_ON(!list_empty(&gray_list));
> +}
> +
> +static void *memleak_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct memleak_object *object;
> +	loff_t n = *pos;
> +
> +	if (!n) {
> +		memleak_scan();
> +		reported_leaks = 0;
> +	}
> +	if (reported_leaks >= REPORTS_NR)
> +		return NULL;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(object, &object_list, object_list) {
> +		if (n-- > 0)
> +			continue;
> +
> +		if (get_object(object))
> +			goto out;
> +	}
> +	object = NULL;
> + out:
> +	rcu_read_unlock();
> +	return object;
> +}
> +
> +static void *memleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct list_head *n;
> +	struct memleak_object *next = NULL;
> +	unsigned long flags;
> +
> +	++(*pos);
> +	if (reported_leaks >= REPORTS_NR)
> +		goto out;
> +
> +	spin_lock_irqsave(&object_list_lock, flags);

Using a spinlock instead of rcu_read_lock() is OK, but only if all
updates are also protected by this same spinlock.  Which means that,
given that find_and_get_object read-acquires object_tree_lock, deletions
must be projected both by object_list_lock and by write-acquiring
object_tree_lock.  Or all calls to memleak_seq_next need to be covered
by rcu_read_lock().

> +	n = ((struct memleak_object *)v)->object_list.next;
> +	if (n != &object_list) {
> +		next = list_entry(n, struct memleak_object, object_list);
> +		get_object(next);
> +	}
> +	spin_unlock_irqrestore(&object_list_lock, flags);
> +
> + out:
> +	put_object(v);
> +	return next;
> +}
> +
> +static void memleak_seq_stop(struct seq_file *seq, void *v)
> +{
> +	if (v)
> +		put_object(v);
> +}
> +
> +static int memleak_seq_show(struct seq_file *seq, void *v)
> +{
> +	struct memleak_object *object = v;
> +	unsigned long flags;
> +	char namebuf[KSYM_NAME_LEN + 1] = "";
> +	char *modname;
> +	unsigned long symsize;
> +	unsigned long offset = 0;
> +	int i;
> +
> +	spin_lock_irqsave(&object->lock, flags);
> +
> +	if (!color_white(object))
> +		goto out;
> +	/* freed in the meantime (false positive) or just allocated */
> +	if (!(object->flags & OBJECT_ALLOCATED))
> +		goto out;
> +	if (object->report_thld >= 0)
> +		goto out;
> +
> +	reported_leaks++;
> +	seq_printf(seq, "unreferenced object 0x%08lx (size %u):\n",
> +		   object->pointer, object->size);
> +	seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
> +		   object->comm, object->pid, object->jiffies);
> +	seq_printf(seq, "  backtrace:\n");
> +
> +	for (i = 0; i < object->trace_len; i++) {
> +		unsigned long trace = object->trace[i];
> +
> +		kallsyms_lookup(trace, &symsize, &offset, &modname, namebuf);
> +		seq_printf(seq, "    [<%08lx>] %s\n", trace, namebuf);
> +	}
> +
> + out:
> +	spin_unlock_irqrestore(&object->lock, flags);
> +	return 0;
> +}
> +
> +static struct seq_operations memleak_seq_ops = {
> +	.start = memleak_seq_start,
> +	.next  = memleak_seq_next,
> +	.stop  = memleak_seq_stop,
> +	.show  = memleak_seq_show,
> +};
> +
> +static int memleak_seq_open(struct inode *inode, struct file *file)
> +{
> +	return seq_open(file, &memleak_seq_ops);
> +}
> +
> +static struct file_operations memleak_fops = {
> +	.owner	 = THIS_MODULE,
> +	.open    = memleak_seq_open,
> +	.read    = seq_read,
> +	.llseek  = seq_lseek,
> +	.release = seq_release,
> +};
> +
> +/*
> + * Kmemleak initialization
> + */
> +void __init memleak_init(void)
> +{
> +	fast_cache_init(&object_cache, sizeof(struct memleak_object));
> +	fast_cache_init(&scan_area_cache, sizeof(struct memleak_scan_area));
> +
> +	INIT_PRIO_TREE_ROOT(&object_tree_root);
> +
> +	/* this is the point where tracking allocations is safe.
> +	 * Scanning is only available later */
> +	atomic_set(&memleak_enabled, 1);
> +}
> +
> +/*
> + * Late initialization function
> + */
> +int __init memleak_late_init(void)
> +{
> +	struct dentry *dentry;
> +
> +	dentry = debugfs_create_file("memleak", S_IRUGO, NULL, NULL,
> +				     &memleak_fops);
> +	if (!dentry)
> +		return -ENOMEM;
> +
> +	pr_info("Kernel memory leak detector initialized\n");
> +
> +	return 0;
> +}
> +late_initcall(memleak_late_init);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

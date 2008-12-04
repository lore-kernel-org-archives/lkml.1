Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbYLDSvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbYLDSvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 13:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbYLDSvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 13:51:11 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:58014 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754629AbYLDSvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 13:51:09 -0500
Subject: Re: [PATCH 01/15] kmemleak: Add the base support
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20081202132828.5c84b815.akpm@linux-foundation.org>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
	 <20081129104312.16726.36218.stgit@pc1117.cambridge.arm.com>
	 <20081202132828.5c84b815.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 04 Dec 2008 18:50:46 +0000
Message-Id: <1228416646.19553.117.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Dec 2008 18:50:47.0430 (UTC) FILETIME=[384E7A60:01C95641]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for your comments. There are some clarifications below (I'm OK
with the rest of your comments).

On Tue, 2008-12-02 at 13:28 -0800, Andrew Morton wrote:
> On Sat, 29 Nov 2008 10:43:12 +0000
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > @@ -653,6 +654,8 @@ asmlinkage void __init start_kernel(void)
> >  	enable_debug_pagealloc();
> >  	cpu_hotplug_init();
> >  	kmem_cache_init();
> > +	prio_tree_init();
> > +	memleak_init();
> >  	debug_objects_mem_init();
> >  	idr_init_cache();
> >  	setup_per_cpu_pageset();
> > @@ -662,7 +665,6 @@ asmlinkage void __init start_kernel(void)
> >  	calibrate_delay();
> >  	pidmap_init();
> >  	pgtable_cache_init();
> > -	prio_tree_init();
> 
> Yeah.
> 
> prio_tree_init() could be done at compile-time, even.

I can't figure out how to do it in a readable way and dependent on
BITS_PER_LONG.

> > +#define MSECS_SCAN_YIELD	10
> > +#define SECS_FIRST_SCAN		60
> > +#define SECS_SCAN_PERIOD	600
> > +
> > +/* scanning area inside a memory block */
> > +struct memleak_scan_area {
> > +	struct hlist_node node;
> > +	unsigned long offset;
> > +	size_t length;
> > +};
> > +
> > +/* the main allocation tracking object */
> > +struct memleak_object {
> > +	spinlock_t lock;
> > +	unsigned long flags;
> > +	struct list_head object_list;
> > +	struct list_head gray_list;
> > +	struct prio_tree_node tree_node;
> > +	struct rcu_head rcu;		/* used for object_list lockless traversal */
> > +	atomic_t use_count;		/* internal usage count */
> > +	unsigned long pointer;
> > +	size_t size;
> > +	int ref_count;			/* the minimum encounters of the pointer */
> > +	int count;			/* the ecounters of the pointer */
> 
> Was that supposed to read "encounters"?
> 
> The reader of the above documentation will be wondering what an
> "encounter" is.
> 
> `count', `refcount' and `use_count' is getting confusing...

OK, I changed the comments and remove the encounters (which might be a
wrong interpretation of this word).

> > +	struct hlist_head area_list;	/* areas to be scanned (or empty for all) */
> > +	unsigned long trace[MAX_TRACE];
> > +	unsigned int trace_len;
> > +	unsigned long jiffies;		/* creation timestamp */
> > +	pid_t pid;			/* pid of the current task */
> 
> Two tasks in different pid namespaces can have the same pid.  What
> effect will that have upon kmemleak?

It won't have any effect. The pid is just an additional information
displayed when reporting an unreferenced object.

> > +	char comm[TASK_COMM_LEN];	/* executable name */
> > +};
> > +
> > +/* The list of all allocated objects */
> > +static LIST_HEAD(object_list);
> > +static DEFINE_SPINLOCK(object_list_lock);
> > +/* The list of the gray objects */
> > +static LIST_HEAD(gray_list);
> 
> It would be nice to briefly define the term "gray" before using it.

Yes, it needs a better comment (the terminology is known in the garbage
collectors world).

> > +/* prio search tree for object boundaries */
> > +static struct prio_tree_root object_tree_root;
> > +static DEFINE_RWLOCK(object_tree_lock);
> > +
> > +/* allocation caches */
> > +static struct kmem_cache *object_cache;
> > +static struct kmem_cache *scan_area_cache;
> > +
> > +static atomic_t memleak_enabled = ATOMIC_INIT(0);
> > +
> > +/* minimum and maximum address that may be valid pointers */
> > +static unsigned long min_addr = ~0;
> 
> <writes a test program>
> 
> OK, I think you got lucky here.
> 
> "0" is a signed 32-bit integer, having the all-zeroes pattern.
> 
> "~0" is a signed 32-bit integer, having the all-ones bit pattern.
> 
> When that gets assigned to an unsigned long it gets sign-extended
> first, so you indeed ended up with the 64-bit all-ones pattern.
> 
> All very tricky!  I like to use plain old "-1" for the all-ones pattern
> and let the compiler do the work.  It always works.

It might be even better to use ULONG_MAX here.

> > +static unsigned long max_addr;
> > +
> > +/* used for yielding the CPU to other tasks during scanning */
> > +static unsigned long next_scan_yield;
> > +static struct task_struct *scan_thread;
> > +static DEFINE_MUTEX(scan_mutex);
> > +static int reported_leaks;
> > +static int scan_should_stop;
> > +
> > +static unsigned long jiffies_scan_yield;
> > +static unsigned long jiffies_min_age;
> > +
> > +/*
> > + * Early object allocation (before kmemleak is fully initialised).
> > + */
> > +#define EARLY_LOG_NR		200
> > +
> > +enum {
> > +	MEMLEAK_ALLOC,
> > +	MEMLEAK_FREE,
> > +	MEMLEAK_NOT_LEAK,
> > +	MEMLEAK_IGNORE,
> > +	MEMLEAK_SCAN_AREA,
> > +};
> 
> It looks to me like the above states are pretty important to
> understanding the code.  Perhaps they each should be documented?

I agree, the early logging part needs commenting. The above states are
just the callbacks which cannot be handled because memleak_init() wasn't
called yet. Once kmemleak is initialised, it goes through the array and
calls the corresponding memleak_alloc/memleak_free/... functions.

> > +struct early_log {
> > +	int op_type;			/* kmemleak operation type */
> > +	const void *ptr;
> > +	size_t size;
> > +	int ref_count;
> > +	unsigned long offset;
> > +	size_t length;
> > +};
> 
> Undocumented?  What's it for, and what do the fields do?

I'll add comments. The members are just arguments passed to the kmemleak
callbacks that need to be stored before kmemleak is fully initialised.
Maybe some other name like early_buffer would be more meaningful.

> > +{
> > +	unsigned long flags;
> > +	struct memleak_object *object;
> > +	struct prio_tree_node *node;
> > +	struct stack_trace trace;
> > +
> > +	object = kmem_cache_alloc(object_cache, GFP_ATOMIC);
> > +	if (!object)
> > +		panic("kmemleak: cannot allocate a memleak_object structure\n");
> 
> That's a big problem, isn't it?  GFP_ATOMIC allocations are quite
> unreliable, and we just nuked the machine?

That's still on the to-do list. The first step I did, as suggested by
others (I think Pekka), was to use the same flags as those used by the
code triggering the callback. This way we don't need to always have
GFP_ATOMIC.

The next step is to change most of the panic/BUG stuff in the code to
something more friendly like disabling kmemleak rather than locking the
machine.

> > +	/*
> > +	 * Update the boundaries before inserting the object in the
> > +	 * prio search tree.
> > +	 */
> > +	smp_mb();
> 
> hm.  Is that needed?  I hope not, assuming that readers are taking
> read_lock(object_tree_lock).

The reader of the min_addr/max_addr variables isn't taking the
object_tree_lock at that point. It does a simple boundary check and, if
this check succeeds, it look-up the object_tree (with
read_lock(object_tree_lock)). My thinking here was that the boundaries
update might not become visible before the the object_tree update. And
adding locking around these boundaries looks too heavyweight, especially
when we have to check a huge amount of values during scanning.

Now, I don't think it really matters whether the boundaries are visible
or not because we could see the boundaries udpated and do the
read_lock(object_tree_lock) before he thread updating the boundaries
gets the chance to do write_lock(object_tree_lock).

There may be another hypothetical situation in which the boundaries will
never become visible to other CPUs unless a memory barrier is used. But
the write_unlock following the min_addr/max_addr update already has such
barriers.

So, I think this barrier can be safely removed.

> > +{
> > +	unsigned long flags;
> > +	struct memleak_object *object;
> > +
> > +	write_lock_irqsave(&object_tree_lock, flags);
> > +	object = lookup_object(ptr, 0);
> > +	if (!object) {
> > +		pr_warning("kmemleak: freeing unknown object at 0x%08lx\n", ptr);
> > +		dump_stack();
> > +		write_unlock_irqrestore(&object_tree_lock, flags);
> > +		return;
> > +	}
> > +	prio_tree_remove(&object_tree_root, &object->tree_node);
> > +	write_unlock_irqrestore(&object_tree_lock, flags);
> > +
> > +	BUG_ON(!(object->flags & OBJECT_ALLOCATED));
> > +
> > +	spin_lock_irqsave(&object->lock, flags);
> > +	object->flags &= ~OBJECT_ALLOCATED;
> > +#ifdef REPORT_ORPHAN_FREEING
> > +	if (color_white(object)) {
> > +		pr_warning("kmemleak: freeing orphan object 0x%08lx\n", ptr);
> > +		dump_stack();
> > +		dump_object_info(object);
> > +	}
> > +#endif
> > +	object->pointer = 0;
> > +	spin_unlock_irqrestore(&object->lock, flags);
> > +
> > +	put_object(object);
> 
> Seems strange to take the object's internal lock if we're about to
> delete it - nobody else should be using it anyway?

Not really, we may call the delete_object() function during a scanning
episode when the object->use_count could be higher and put_object()
wouldn't actually free it unless use_count becomes 0.

> > +{
> > +	unsigned long flags;
> > +	struct memleak_object *object;
> > +	struct memleak_scan_area *area;
> > +
> > +	object = find_and_get_object(ptr, 0);
> > +	if (!object) {
> > +		dump_stack();
> > +		panic("kmemleak: adding scan area to unknown object at 0x%08lx\n", ptr);
> > +	}
> > +
> > +	area = kmem_cache_alloc(scan_area_cache, GFP_ATOMIC);
> > +	if (!area)
> > +		panic("kmemleak: cannot allocate a scan area\n");
> 
> ow, ow, ow.

Yes, I'll sort them out.

> > +/*
> > + * Mark a object as a false positive.
> > + */
> > +void memleak_not_leak(const void *ptr)
> > +{
> > +	pr_debug("%s(0x%p)\n", __FUNCTION__, ptr);
> > +
> > +	if (!atomic_read(&memleak_enabled)) {
> > +		memleak_early_log(MEMLEAK_NOT_LEAK, ptr, 0, 0, 0, 0);
> > +		return;
> > +	}
> > +	if (!ptr)
> > +		return;
> > +
> > +	make_gray_object((unsigned long)ptr);
> > +}
> > +EXPORT_SYMBOL(memleak_not_leak);
> 
> It would be appropriate to have some discussion somewhere describing
> what a false positive is, and how it can come about, and how kmemleak
> handles them.
> 
> Perhaps that's in the documentation somewhere.

There is Documentation/kmemleak.txt and it says something about false
positives/negatives but it can be improved.

> > + */
> > +void memleak_scan_area(const void *ptr, unsigned long offset, size_t length)
> > +{
> > +	pr_debug("%s(0x%p)\n", __FUNCTION__, ptr);
> > +
> > +	if (!atomic_read(&memleak_enabled)) {
> > +		memleak_early_log(MEMLEAK_SCAN_AREA, ptr, 0, 0, offset, length);
> > +		return;
> > +	}
> > +	if (!ptr)
> > +		return;
> > +
> > +	add_scan_area((unsigned long)ptr, offset, length);
> > +}
> > +EXPORT_SYMBOL(memleak_scan_area);
> > +
> > +static inline void scan_yield(void)
> > +{
> > +	BUG_ON(in_atomic());
> 
> Please don't use in_atomic().  It's a low-level internal thing, the
> results of which vary according to kernel configuration.  checkpatch
> does/will/should warn about this.

It didn't.

> Using might_sleep() would be appropriate here.

OK.

> > +	if (time_is_before_eq_jiffies(next_scan_yield)) {
> > +		schedule();
> > +		next_scan_yield = jiffies + jiffies_scan_yield;
> > +	}
> 
> Why is the yielding rate-limited?  The code needs a comment explaining
> this, because the reader cannot tell.

I'll add a comment. It is rate-limited to avoid calling schedule() after
every pointer checked. It would be really time consuming.

> > +	if (signal_pending(current))
> > +		scan_should_stop = 1;
> 
> That looks odd.  per-task signal state will change kernel-wide state?
> 
> You can tell that I don't understand how all this code actually works. 
> It would be nice if I _could_ tell that, from the code and its comments.
> 
> <looks around a bit>
> 
> Ah, this is run from a kernel thread?  Why is kthread_should_stop()
> insufficient?

The memleak_scan() function (and the subsequently called scan_block) can
be invoked from either a kernel thread or from a user process when
reading the /sys/kernel/debug/memleak file. The signal_pending() is
intended for the latter case. Scanning takes considerable amount of time
(minutes) and the user might decide to stop this, hence the
scan_should_stop = 1 and the scan_block() function will avoid any
subsequent pointer look-ups.

The kthread_should_stop() is called only outside the memleak_scan()
function. For the kthread, there is currently no way to stop it in the
middle of a scan.

An alternative would be to differentiate the scan_yield() checks
(process or kthread) with an additional argument that gets passed via
memleak_scan(). Or, is there a way to tell whether it's in a kernel
thread or user process context? Checking current->mm?

> > +	/* mem_map scanning */
> > +	for_each_online_node(i) {
> > +		struct page *page, *end;
> > +
> > +		page = NODE_MEM_MAP(i);
> > +		end  = page + NODE_DATA(i)->node_spanned_pages;
> > +
> > +		scan_block(page, end, NULL);
> > +	}
> 
> hmm, do we really need to go this low into the mm data structures?
> 
> What assumptions are being made about the contiguity of a node's memory
> here?
> 
> Perhaps this code should be using pfns and pfn_valid(), dunno.

I'll have to review this but there are several objects referred via the
"struct page" in the mem_map. So it only scans these structures
otherwise there would be plenty of false positives.

> > +static void *memleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> > +{
> > +	struct list_head *n;
> > +	struct memleak_object *next = NULL;
> > +	unsigned long flags;
> > +
> > +	++(*pos);
> > +	if (reported_leaks >= REPORTS_NR)
> > +		goto out;
> > +
> > +	spin_lock_irqsave(&object_list_lock, flags);
> > +	n = ((struct memleak_object *)v)->object_list.next;
> 
> Now what's going on here.  Can this be cleaned up?  container_of(),
> list_entry(), etc?

I'll look at it. I mainly did what I saw in other parts of the kernel.

> > +static int memleak_scan_thread(void *arg)
> > +{
> > +	/* sleep before the first scan */
> 
> The reader wonders why...

Because Ingo asked for it :-). It's mainly for his automatic testing.
I'll add a meaningful comment.

Thanks again for your comments. I'll post another set of patches once I
sort these comments out.

-- 
Catalin


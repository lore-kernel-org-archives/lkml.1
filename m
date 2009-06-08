Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbZFHNi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbZFHNi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbZFHNil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:38:41 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:45711 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbZFHNij convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:38:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wUj7urkn2JV4+774N7+ORJmYW40kciqd8OjBG0xtGyBfA23G+Ju6/aIM1eGCP42QYg
         Iw85O1uHQhT3emRqoM1t/A/3tR/nb/DZoaZXE8WRbRnSDz1R0EG7J1PkGVVNsMxGtia3
         82/XHBUHvkURo1+gHYoFmcjZQOLspjHEZbf0E=
MIME-Version: 1.0
In-Reply-To: <1244463727.13761.8700.camel@twins>
References: <1243781365-26814-1-git-send-email-tom.leiming@gmail.com>
	 <1244463727.13761.8700.camel@twins>
Date: Mon, 8 Jun 2009 21:38:33 +0800
Message-ID: <d82e647a0906080638m913d963heac0bbc0260dc1df@mail.gmail.com>
Subject: Re: [PATCH 0/8] kernel:lockdep:replace DFS with BFS
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/8 Peter Zijlstra <a.p.zijlstra@chello.nl>:
>
> OK, so I applied the patches and the cleanup below.

Thank you for your review and feedback.

>
> mostly little style nits and moving the circular queue into lockdep.c
> (nobody else uses it, so why share it?).

Yes, I agree.

>
> One thing though, macros with return statements?! that's seriously bad
> style, don't do that.

Yes, I'll fix it.

>
> One thing that worries me a little is that we loose DaveM's
> lockdep_dependency_visit() optimization. My brain seems unwilling to
> co-operate on determining if BFS would make that redundant, so a little
> word on that would be appreciated.
>
> Then I booted it and all hell broke loose, so either I wrecked something
> or you did :-), would you terribly mind poking at that a little?

Oh, let me work out what's wrong with this, maybe I need a little time.

>
> Over all I like that patches, but they need a little more work. Could
> you send delta patches from now on?

Yes, I'd like to do it.

>
> ---
>
> [    0.000999] =================================
> [    0.000999] [ BUG: bad contention detected! ]
> [    0.000999] ---------------------------------
> [    0.000999] swapper/0 is trying to contend lock (old_style_seqlock_init) at:
> [    0.000999] [<ffffffff8133a795>] _spin_lock+0x6d/0x75
> [    0.000999] but there are no locks held!
> [    0.000999]
> [    0.000999] other info that might help us debug this:
> [    0.000999] 1 lock held by swapper/0:
> [    0.000999]  #0:  (xtime_lock){-.....}, at: [<ffffffff8106a360>] tick_periodic+0x1d/0x74
> [    0.000999]
> [    0.000999] stack backtrace:
> [    0.000999] Pid: 0, comm: swapper Not tainted 2.6.30-rc8-tip #1049
> [    0.000999] Call Trace:
> [    0.000999]  <IRQ>  [<ffffffff81071bd8>] print_lock_contention_bug+0x100/0x110
> [    0.000999]  [<ffffffff81071ce0>] lock_acquired+0xf8/0x2b4
> [    0.000999]  [<ffffffff81010221>] ? update_vsyscall+0x2d/0xd0
> [    0.000999]  [<ffffffff8133a795>] _spin_lock+0x6d/0x75
> [    0.000999]  [<ffffffff81010221>] ? update_vsyscall+0x2d/0xd0
> [    0.000999]  [<ffffffff81010221>] update_vsyscall+0x2d/0xd0
> [    0.000999]  [<ffffffff81067469>] update_wall_time+0x4c1/0x4cc
> [    0.000999]  [<ffffffff8105274b>] do_timer+0x15/0x1c
> [    0.000999]  [<ffffffff8106a37e>] tick_periodic+0x3b/0x74
> [    0.000999]  [<ffffffff8106a3db>] tick_handle_periodic+0x24/0x71
> [    0.000999]  [<ffffffff8100ea23>] timer_interrupt+0x1f/0x26
> [    0.000999]  [<ffffffff8109348b>] handle_IRQ_event+0x8e/0x19c
> [    0.000999]  [<ffffffff8109501e>] handle_level_irq+0x9d/0xf3
> [    0.000999]  [<ffffffff8100e24b>] handle_irq+0x24/0x2c
> [    0.000999]  [<ffffffff8133f55b>] do_IRQ+0x63/0xc2
> [    0.000999]  [<ffffffff8100c713>] ret_from_intr+0x0/0xf
> [    0.000999]  <EOI>  [<ffffffff8133a538>] ? _spin_unlock_irqrestore+0x47/0x6d
> [    0.000999]  [<ffffffff81093eea>] ? __setup_irq+0x1ea/0x277
> [    0.000999]  [<ffffffff81094120>] ? setup_irq+0x25/0x2a
> [    0.000999]  [<ffffffff8158e63e>] ? hpet_time_init+0x20/0x22
> [    0.000999]  [<ffffffff8158bbcc>] ? start_kernel+0x2ee/0x37a
> [    0.000999]  [<ffffffff8158b29a>] ? x86_64_start_reservations+0xaa/0xae
> [    0.000999]  [<ffffffff8158b37f>] ? x86_64_start_kernel+0xe1/0xe8
>
> And ended in a stuck boot at:
>
> [   65.411804] rmmod         R  running task        0   616      1 0x00000008
> [   65.411804]  ffff8800023c41a0 ffffea0003336ba8 ffff88007e3a3c08 ffffffff8106f71a
> [   65.411804]  ffff88007e3a3c48 0000000000000202 ffff88007f821600 0000000000001823
> [   65.411804]  ffff88007e109d20 ffff88007f8b5c80 0000000000000000 ffff88007e3a3d18
> [   65.411804] Call Trace:
> [   65.411804]  [<ffffffff8106f71a>] ? trace_hardirqs_on+0xd/0xf
> [   65.411804]  [<ffffffff8113f1b6>] ? release_sysfs_dirent+0x91/0xb1
> [   65.411804]  [<ffffffff81071af6>] ? print_lock_contention_bug+0x1e/0x110
> [   65.411804]  [<ffffffff81071af6>] ? print_lock_contention_bug+0x1e/0x110
> [   65.411804]  [<ffffffff8113eff3>] ? sysfs_addrm_start+0x7d/0xaa
> [   65.411804]  [<ffffffff81071af6>] ? print_lock_contention_bug+0x1e/0x110
> [   65.411804]  [<ffffffff810113ff>] ? alternatives_smp_module_del+0x37/0xd0
> [   65.411804]  [<ffffffff810e61ee>] ? free_percpu+0x38/0xf8
> [   65.411804]  [<ffffffff8106f71a>] ? trace_hardirqs_on+0xd/0xf
> [   65.411804]  [<ffffffff8133a542>] ? _spin_unlock_irqrestore+0x51/0x6d
> [   65.411804]  [<ffffffff810e62a5>] ? free_percpu+0xef/0xf8
> [   65.411804]  [<ffffffff8107ade5>] ? free_module+0x104/0x118
> [   65.411804]  [<ffffffff8107b0a8>] ? sys_delete_module+0x20c/0x22e
> [   65.411804]  [<ffffffff81339f88>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   65.411804]  [<ffffffff8100bcdb>] ? system_call_fastpath+0x16/0x1b
>
> ( I can send you my .config if you cannot reproduce, but I don't think
> its anything special )
>
> ---
>
> Subject: lockdep: clean up after BFS patches
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Jun 08 13:32:31 CEST 2009
>
>
> LKML-Reference: <new-submission>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/lockdep.h    |    7 -
>  kernel/lockdep.c           |  232 +++++++++++++++++++++++++++------------------
>  kernel/lockdep_internals.h |   97 ------------------
>  3 files changed, 147 insertions(+), 189 deletions(-)
> ===================================================================
> ===================================================================
> --- linux-2.6.orig/include/linux/lockdep.h
> +++ linux-2.6/include/linux/lockdep.h
> @@ -58,7 +58,6 @@ struct lock_class {
>
>        struct lockdep_subclass_key     *key;
>        unsigned int                    subclass;
> -       unsigned int                    dep_gen_id;
>
>        /*
>         * IRQ/softirq usage tracking bits:
> @@ -150,9 +149,9 @@ struct lock_list {
>        struct stack_trace              trace;
>        int                             distance;
>
> -       /*The parent field is used to implement breadth-first search,and
> -        *the bit 0 is reused to indicate if the lock has been accessed
> -        *in BFS.
> +       /*
> +        * The parent field is used to implement breadth-first search, and the
> +        * bit 0 is reused to indicate if the lock has been accessed in BFS.
>         */
>        struct lock_list                *parent;
>  };
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep.c
> +++ linux-2.6/kernel/lockdep.c
> @@ -43,6 +43,7 @@
>  #include <linux/ftrace.h>
>  #include <linux/stringify.h>
>  #include <linux/bitops.h>
> +
>  #include <asm/sections.h>
>
>  #include "lockdep_internals.h"
> @@ -118,7 +119,7 @@ static inline int debug_locks_off_graph_
>  static int lockdep_initialized;
>
>  unsigned long nr_list_entries;
> -struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
> +static struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
>
>  /*
>  * All data structures here are protected by the global debug_lock.
> @@ -390,19 +391,6 @@ unsigned int nr_process_chains;
>  unsigned int max_lockdep_depth;
>  unsigned int max_recursion_depth;
>
> -static unsigned int lockdep_dependency_gen_id;
> -
> -static bool lockdep_dependency_visit(struct lock_class *source,
> -                                    unsigned int depth)
> -{
> -       if (!depth)
> -               lockdep_dependency_gen_id++;
> -       if (source->dep_gen_id == lockdep_dependency_gen_id)
> -               return true;
> -       source->dep_gen_id = lockdep_dependency_gen_id;
> -       return false;
> -}
> -
>  #ifdef CONFIG_DEBUG_LOCKDEP
>  /*
>  * We cannot printk in early bootup code. Not even early_printk()
> @@ -575,64 +563,6 @@ static void print_lock_class_header(stru
>        print_ip_sym((unsigned long)class->key);
>  }
>
> -/*
> - * printk the shortest lock dependencies from @start to @end in reverse order:
> - */
> -static void __used
> -print_shortest_lock_dependencies(struct lock_list *leaf,
> -                               struct lock_list *root)
> -{
> -       struct lock_list *entry = leaf;
> -       int depth;
> -
> -       /*compute depth from generated tree by BFS*/
> -       depth = get_lock_depth(leaf);
> -
> -       do {
> -               print_lock_class_header(entry->class, depth);
> -               printk("%*s ... acquired at:\n", depth, "");
> -               print_stack_trace(&entry->trace, 2);
> -               printk("\n");
> -
> -               if (depth == 0 && (entry != root)) {
> -                       printk("lockdep:%s bad BFS generated tree\n", __func__);
> -                       break;
> -               }
> -
> -               entry = get_lock_parent(entry);
> -               depth--;
> -       } while (entry && (depth >= 0));
> -
> -       return;
> -}
> -/*
> - * printk all lock dependencies starting at <entry>:
> - */
> -static void __used
> -print_lock_dependencies(struct lock_class *class, int depth)
> -{
> -       struct lock_list *entry;
> -
> -       if (lockdep_dependency_visit(class, depth))
> -               return;
> -
> -       if (DEBUG_LOCKS_WARN_ON(depth >= 20))
> -               return;
> -
> -       print_lock_class_header(class, depth);
> -
> -       list_for_each_entry(entry, &class->locks_after, entry) {
> -               if (DEBUG_LOCKS_WARN_ON(!entry->class))
> -                       return;
> -
> -               print_lock_dependencies(entry->class, depth + 1);
> -
> -               printk("%*s ... acquired at:\n",depth,"");
> -               print_stack_trace(&entry->trace, 2);
> -               printk("\n");
> -       }
> -}
> -
>  static void print_kernel_version(void)
>  {
>        printk("%s %.*s\n", init_utsname()->release,
> @@ -927,14 +857,106 @@ static int add_lock_to_list(struct lock_
>        return 1;
>  }
>
> -unsigned long bfs_accessed[BITS_TO_LONGS(MAX_LOCKDEP_ENTRIES)];
> -static struct circular_queue  lock_cq;
> +/*For good efficiency of modular, we use power of 2*/
> +#define MAX_CIRCULAR_QUEUE_SIZE                4096UL
> +#define CQ_MASK                                (MAX_CIRCULAR_QUEUE_SIZE-1)
> +
> +/* The circular_queue and helpers is used to implement the
> + * breadth-first search(BFS)algorithem, by which we can build
> + * the shortest path from the next lock to be acquired to the
> + * previous held lock if there is a circular between them.
> + * */
> +struct circular_queue {
> +       unsigned long element[MAX_CIRCULAR_QUEUE_SIZE];
> +       unsigned int  front, rear;
> +};
> +
> +static struct circular_queue lock_cq;
> +static unsigned long bfs_accessed[BITS_TO_LONGS(MAX_LOCKDEP_ENTRIES)];
> +
>  unsigned int max_bfs_queue_depth;
> +
> +static inline void __cq_init(struct circular_queue *cq)
> +{
> +       cq->front = cq->rear = 0;
> +       bitmap_zero(bfs_accessed, MAX_LOCKDEP_ENTRIES);
> +}
> +
> +static inline int __cq_empty(struct circular_queue *cq)
> +{
> +       return (cq->front == cq->rear);
> +}
> +
> +static inline int __cq_full(struct circular_queue *cq)
> +{
> +       return ((cq->rear + 1) & CQ_MASK) == cq->front;
> +}
> +
> +static inline int __cq_enqueue(struct circular_queue *cq, unsigned long elem)
> +{
> +       if (__cq_full(cq))
> +               return -1;
> +
> +       cq->element[cq->rear] = elem;
> +       cq->rear = (cq->rear + 1) & CQ_MASK;
> +       return 0;
> +}
> +
> +static inline int __cq_dequeue(struct circular_queue *cq, unsigned long *elem)
> +{
> +       if (__cq_empty(cq))
> +               return -1;
> +
> +       *elem = cq->element[cq->front];
> +       cq->front = (cq->front + 1) & CQ_MASK;
> +       return 0;
> +}
> +
> +static inline unsigned int  __cq_get_elem_count(struct circular_queue *cq)
> +{
> +       return (cq->rear - cq->front) & CQ_MASK;
> +}
> +
> +static inline void mark_lock_accessed(struct lock_list *lock,
> +                                       struct lock_list *parent)
> +{
> +       unsigned long nr;
> +       nr = lock - list_entries;
> +       WARN_ON(nr >= nr_list_entries);
> +       lock->parent = parent;
> +       set_bit(nr, bfs_accessed);
> +}
> +
> +static inline unsigned long lock_accessed(struct lock_list *lock)
> +{
> +       unsigned long nr;
> +       nr = lock - list_entries;
> +       WARN_ON(nr >= nr_list_entries);
> +       return test_bit(nr, bfs_accessed);
> +}
> +
> +static inline struct lock_list *get_lock_parent(struct lock_list *child)
> +{
> +       return child->parent;
> +}
> +
> +static inline int get_lock_depth(struct lock_list *child)
> +{
> +       int depth = 0;
> +       struct lock_list *parent;
> +
> +       while ((parent = get_lock_parent(child))) {
> +               child = parent;
> +               depth++;
> +       }
> +       return depth;
> +}
> +
>  static int __bfs(struct lock_list *source_entry,
> -                       void *data,
> -                       int (*match)(struct lock_list *entry, void *data),
> -                       struct lock_list **target_entry,
> -                       int forward)
> +                void *data,
> +                int (*match)(struct lock_list *entry, void *data),
> +                struct lock_list **target_entry,
> +                int forward)
>  {
>        struct lock_list *entry;
>        struct list_head *head;
> @@ -1202,14 +1224,6 @@ check_noncircular(struct lock_list *root
>  * without creating any illegal irq-safe -> irq-unsafe lock dependency.
>  */
>
> -
> -#define   BFS_PROCESS_RET(ret) do { \
> -                                       if (ret < 0) \
> -                                               return print_bfs_bug(ret); \
> -                                       if (ret == 1) \
> -                                               return 1; \
> -                               } while (0)
> -
>  static inline int usage_match(struct lock_list *entry, void *bit)
>  {
>        return entry->class->usage_mask & (1 << (enum lock_usage_bit)bit);
> @@ -1236,6 +1250,8 @@ find_usage_forwards(struct lock_list *ro
>        debug_atomic_inc(&nr_find_usage_forwards_checks);
>
>        result = __bfs_forwards(root, (void *)bit, usage_match, target_entry);
> +       if (result < 0)
> +               return print_bfs_bug(result);
>
>        return result;
>  }
> @@ -1259,10 +1275,42 @@ find_usage_backwards(struct lock_list *r
>        debug_atomic_inc(&nr_find_usage_backwards_checks);
>
>        result = __bfs_backwards(root, (void *)bit, usage_match, target_entry);
> +       if (result < 0)
> +               return print_bfs_bug(result);
>
>        return result;
>  }
>
> +/*
> + * printk the shortest lock dependencies from @start to @end in reverse order:
> + */
> +static void __used
> +print_shortest_lock_dependencies(struct lock_list *leaf,
> +                               struct lock_list *root)
> +{
> +       struct lock_list *entry = leaf;
> +       int depth;
> +
> +       /*compute depth from generated tree by BFS*/
> +       depth = get_lock_depth(leaf);
> +
> +       do {
> +               print_lock_class_header(entry->class, depth);
> +               printk("%*s ... acquired at:\n", depth, "");
> +               print_stack_trace(&entry->trace, 2);
> +               printk("\n");
> +
> +               if (depth == 0 && (entry != root)) {
> +                       printk("lockdep:%s bad BFS generated tree\n", __func__);
> +                       break;
> +               }
> +
> +               entry = get_lock_parent(entry);
> +               depth--;
> +       } while (entry && (depth >= 0));
> +
> +       return;
> +}
>
>  static int
>  print_bad_irq_dependency(struct task_struct *curr,
> @@ -1349,12 +1397,14 @@ check_usage(struct task_struct *curr, st
>
>        this.class = hlock_class(prev);
>        ret = find_usage_backwards(&this, bit_backwards, &target_entry);
> -       BFS_PROCESS_RET(ret);
> +       if (!ret || ret == 1)
> +               return ret;
>
>        that.parent = NULL;
>        that.class = hlock_class(next);
>        ret = find_usage_forwards(&that, bit_forwards, &target_entry1);
> -       BFS_PROCESS_RET(ret);
> +       if (!ret || ret == 1)
> +               return ret;
>
>        return print_bad_irq_dependency(curr, &this, &that,
>                        target_entry, target_entry1,
> @@ -2038,7 +2088,8 @@ check_usage_forwards(struct task_struct
>        root.parent = NULL;
>        root.class = hlock_class(this);
>        ret = find_usage_forwards(&root, bit, &target_entry);
> -       BFS_PROCESS_RET(ret);
> +       if (!ret || ret == 1)
> +               return ret;
>
>        return print_irq_inversion_bug(curr, &root, target_entry,
>                                        this, 1, irqclass);
> @@ -2059,7 +2110,8 @@ check_usage_backwards(struct task_struct
>        root.parent = NULL;
>        root.class = hlock_class(this);
>        ret = find_usage_backwards(&root, bit, &target_entry);
> -       BFS_PROCESS_RET(ret);
> +       if (!ret || ret == 1)
> +               return ret;
>
>        return print_irq_inversion_bug(curr, &root, target_entry,
>                                        this, 1, irqclass);
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep_internals.h
> +++ linux-2.6/kernel/lockdep_internals.h
> @@ -91,6 +91,8 @@ extern unsigned int nr_process_chains;
>  extern unsigned int max_lockdep_depth;
>  extern unsigned int max_recursion_depth;
>
> +extern unsigned int max_bfs_queue_depth;
> +
>  #ifdef CONFIG_PROVE_LOCKING
>  extern unsigned long lockdep_count_forward_deps(struct lock_class *);
>  extern unsigned long lockdep_count_backward_deps(struct lock_class *);
> @@ -136,98 +138,3 @@ extern atomic_t nr_find_usage_backwards_
>  # define debug_atomic_dec(ptr)         do { } while (0)
>  # define debug_atomic_read(ptr)                0
>  #endif
> -
> -
> -extern unsigned int max_bfs_queue_depth;
> -extern unsigned long nr_list_entries;
> -extern struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
> -extern unsigned long bfs_accessed[];
> -
> -/*For good efficiency of modular, we use power of 2*/
> -#define  MAX_CIRCULAR_QUE_SIZE     4096UL
> -
> -/* The circular_queue and helpers is used to implement the
> - * breadth-first search(BFS)algorithem, by which we can build
> - * the shortest path from the next lock to be acquired to the
> - * previous held lock if there is a circular between them.
> - * */
> -struct circular_queue{
> -       unsigned long element[MAX_CIRCULAR_QUE_SIZE];
> -       unsigned int  front, rear;
> -};
> -
> -static inline void __cq_init(struct circular_queue *cq)
> -{
> -       cq->front = cq->rear = 0;
> -       bitmap_zero(bfs_accessed, MAX_LOCKDEP_ENTRIES);
> -}
> -
> -static inline int __cq_empty(struct circular_queue *cq)
> -{
> -       return (cq->front == cq->rear);
> -}
> -
> -static inline int __cq_full(struct circular_queue *cq)
> -{
> -       return ((cq->rear + 1)&(MAX_CIRCULAR_QUE_SIZE-1))  == cq->front;
> -}
> -
> -static inline int __cq_enqueue(struct circular_queue *cq, unsigned long elem)
> -{
> -       if (__cq_full(cq))
> -               return -1;
> -
> -       cq->element[cq->rear] = elem;
> -       cq->rear = (cq->rear + 1)&(MAX_CIRCULAR_QUE_SIZE-1);
> -       return 0;
> -}
> -
> -static inline int __cq_dequeue(struct circular_queue *cq, unsigned long *elem)
> -{
> -       if (__cq_empty(cq))
> -               return -1;
> -
> -       *elem = cq->element[cq->front];
> -       cq->front = (cq->front + 1)&(MAX_CIRCULAR_QUE_SIZE-1);
> -       return 0;
> -}
> -
> -static inline unsigned int  __cq_get_elem_count(struct circular_queue *cq)
> -{
> -       return (cq->rear - cq->front)&(MAX_CIRCULAR_QUE_SIZE-1);
> -}
> -
> -static inline void mark_lock_accessed(struct lock_list *lock,
> -                                       struct lock_list *parent)
> -{
> -       unsigned long nr;
> -       nr = lock - list_entries;
> -       WARN_ON(nr >= nr_list_entries);
> -       lock->parent = parent;
> -       set_bit(nr, bfs_accessed);
> -}
> -
> -static inline unsigned long lock_accessed(struct lock_list *lock)
> -{
> -       unsigned long nr;
> -       nr = lock - list_entries;
> -       WARN_ON(nr >= nr_list_entries);
> -       return test_bit(nr, bfs_accessed);
> -}
> -
> -static inline struct lock_list *get_lock_parent(struct lock_list *child)
> -{
> -       return child->parent;
> -}
> -
> -static inline int get_lock_depth(struct lock_list *child)
> -{
> -       int depth = 0;
> -       struct lock_list *parent;
> -
> -       while ((parent = get_lock_parent(child))) {
> -               child = parent;
> -               depth++;
> -       }
> -       return depth;
> -}
>
>
>



-- 
Lei Ming

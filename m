Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbZFSMjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbZFSMjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 08:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbZFSMjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 08:39:40 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:27355 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbZFSMjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 08:39:39 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:perfcounters/core] perf_counter: Simplify and fix task
 migration counting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <19003.33663.47733.451895@cargo.ozlabs.ibm.com>
References: <new-submission>
	 <tip-e5289d4a181fb6c0b7a7607649af2ffdc491335c@git.kernel.org>
	 <1245412779.19816.5.camel@twins>
	 <19003.33663.47733.451895@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 14:39:44 +0200
Message-Id: <1245415184.19816.15.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 22:24 +1000, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > static struct perf_counter_context *perf_pin_task_context(struct task_struct *task)
> > {
> > 	struct perf_counter_context *ctx;
> > 	unsigned long flags;
> > 
> > 	ctx = perf_lock_task_context(task, &flags);
> > 	if (ctx) {
> > 		++ctx->pin_count;
> > 		get_ctx(ctx);
> > 		spin_unlock_irqrestore(&ctx->lock, flags);
> > 	}
> > 	return ctx;
> > }
> > 
> > Is buggy because perf_lock_task_context() can return a dead context.
> > 
> > the RCU read lock in perf_lock_task_context() only guarantees the memory
> > won't get freed, it doesn't guarantee the object is valid (in our case
> > refcount > 0).
> > 
> > Therefore we can return a locked object that can get freed the moment we
> > release the rcu read lock.
> > 
> > perf_pin_task_context() then increases the refcount and does an unlock
> > on freed memory.
> > 
> > That increased refcount will cause a double free, in case it started out
> > with 0.
> 
> Wow, good catch!  Thanks for finding that.

The clue that got me started was this scribble:

[  123.800172] =============================================================================
[  123.808725] BUG kmalloc-512: Poison overwritten
[  123.813422] -----------------------------------------------------------------------------
[  123.813424]
[  123.823390] INFO: 0xffff8801bd546480-0xffff8801bd546588. First byte 0x6c instead of 0x6b
[  123.831777] INFO: Allocated in perf_counter_init_task+0x8d/0x262 age=351 cpu=1 pid=12276
[  123.840047] INFO: Freed in free_ctx+0x10/0x12 age=256 cpu=1 pid=12669
[  123.846702] INFO: Slab 0xffffea0009914f60 objects=28 used=14 fp=0xffff8801bd546480 flags=0x2000000000040c3
[  123.856710] INFO: Object 0xffff8801bd546480 @offset=9344 fp=0xffff8801bd546fe8
[  123.856712]
[  123.865782] Bytes b4 0xffff8801bd546470:  31 3b fd ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a 1;<FD><FF>....ZZZZZZZZ
[  123.876163]   Object 0xffff8801bd546480:  6c 6c 6b 6b 6b 6b 6b 6b ff ff ff ff 6b 6b 6b 6b llkkkkkk<FF><FF><FF><FF>kkkk
[  123.886447]   Object 0xffff8801bd546490:  ff ff ff ff ff ff ff ff 6b 6b 6b 6b 6b 6b 6b 6b <FF><FF><FF><FF><FF><FF><FF><FF>kkkkkkkk
[  123.896810]   Object 0xffff8801bd5464a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  123.907162]   Object 0xffff8801bd5464b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  123.917421]   Object 0xffff8801bd5464c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  123.927837]   Object 0xffff8801bd5464d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  123.938147]   Object 0xffff8801bd5464e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  123.948398]   Object 0xffff8801bd5464f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk

And from pahole (thanks acme!) we find that the only relevant perf
object in that bucket is:

struct perf_counter_context {
        spinlock_t                 lock;                 /*     0    64 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        struct mutex               mutex;                /*    64   152 */
        /* --- cacheline 3 boundary (192 bytes) was 24 bytes ago --- */
        struct list_head           counter_list;         /*   216    16 */
        struct list_head           event_list;           /*   232    16 */
        int                        nr_counters;          /*   248     4 */
        int                        nr_active;            /*   252     4 */
        /* --- cacheline 4 boundary (256 bytes) --- */
        int                        is_active;            /*   256     4 */
        atomic_t                   refcount;             /*   260     4 */
        struct task_struct *       task;                 /*   264     8 */
        u64                        time;                 /*   272     8 */
        u64                        timestamp;            /*   280     8 */
        struct perf_counter_context * parent_ctx;        /*   288     8 */
        u64                        parent_gen;           /*   296     8 */
        u64                        generation;           /*   304     8 */
        int                        pin_count;            /*   312     4 */

        /* XXX 4 bytes hole, try to pack */

        /* --- cacheline 5 boundary (320 bytes) --- */
        struct rcu_head            rcu_head;             /*   320    16 */

        /* size: 336, cachelines: 6 */
        /* sum members: 332, holes: 1, sum holes: 4 */
        /* last cacheline: 16 bytes */
}; 

typedef struct {
        raw_spinlock_t             raw_lock;             /*     0     4 */
        unsigned int               magic;                /*     4     4 */
        unsigned int               owner_cpu;            /*     8     4 */

        /* XXX 4 bytes hole, try to pack */

        void *                     owner;                /*    16     8 */
        struct lockdep_map         dep_map;              /*    24    40 */
        /* --- cacheline 1 boundary (64 bytes) --- */

        /* size: 64, cachelines: 1 */
        /* sum members: 60, holes: 1, sum holes: 4 */
} spinlock_t;   /* definitions: 1 */


Which learns us that we had lock/unlock (6b->6c) + owner and owner_cpu
scribble as through:

static inline void debug_spin_unlock(spinlock_t *lock)
{
	SPIN_BUG_ON(lock->magic != SPINLOCK_MAGIC, lock, "bad magic");
	SPIN_BUG_ON(!spin_is_locked(lock), lock, "already unlocked");
	SPIN_BUG_ON(lock->owner != current, lock, "wrong owner");
	SPIN_BUG_ON(lock->owner_cpu != raw_smp_processor_id(),
							lock, "wrong CPU");
	lock->owner = SPINLOCK_OWNER_INIT;
	lock->owner_cpu = -1;
}

The SPIN_BUG_ON() failed to trigger in this particular case because
earlier corruption took out lockdep.




Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbXKLTPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbXKLTPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbXKLTPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:15:35 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:40164 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbXKLTPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:15:33 -0500
Date: Mon, 12 Nov 2007 11:15:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       tony@bakeyournoodle.com, paulus@samba.org, dino@in.ibm.com,
       tytso@us.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com, antonb@us.ibm.com
Subject: Re: [PATCH, RFC] improved hacks to allow -rt to run kernbench on POWER
Message-ID: <20071112191526.GC11113@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071109181028.GA26800@linux.vnet.ibm.com> <1194641524.21340.14.camel@pasglop> <20071109220717.GJ8826@linux.vnet.ibm.com> <1194753541.21340.26.camel@pasglop> <Pine.LNX.4.58.0711110943510.12853@gandalf.stny.rr.com> <1194814125.6510.14.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194814125.6510.14.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 07:48:45AM +1100, Benjamin Herrenschmidt wrote:
> 
> On Sun, 2007-11-11 at 09:45 -0500, Steven Rostedt wrote:
> > > Well, I suppose the patch could go in, maybe with some ifdef's
> > around
> > > the bits in _switch_to, there's little point in doing that on non-rt
> > > kernels.
> > 
> > As Nick Piggin already stated, and I'll even state it for the RT
> > kernel,
> > we do not allow preemption in switch_to. So it is safe to remove those
> > "preempt_disable" bits from the patch
> 
> Sure, I know that, I'm not talking about that, I'm talking about the
> added code that flush pending batches & save the batch state, since on
> non-rt kernel, this is not useful (the batch is only ever active within
> a spinlocked section, which cannot be preempted on non-rt).

And here is an updated patch.  There has to be a better way than the
#ifdef, but I need the two local variables, and breaking the intervening
code out into a separate function didn't quite seem right either.

Thoughts?

This one does only one oops during boot-up, which I will start looking
at:

BUG: sleeping function called from invalid context ifconfig(994) at kernel/rtmutex.c:637
in_atomic():1 [00000002], irqs_disabled():1
Call Trace:
[c0000000ff49f030] [c000000000010028] .show_stack+0x6c/0x1a0 (unreliable)
[c0000000ff49f0d0] [c00000000004f8b4] .__might_sleep+0x11c/0x138
[c0000000ff49f150] [c00000000039c920] .__rt_spin_lock+0x38/0xa0
[c0000000ff49f1d0] [c0000000000cf8e8] .kmem_cache_alloc+0x68/0x184
[c0000000ff49f270] [c0000000001f7534] .radix_tree_node_alloc+0x3c/0x104
[c0000000ff49f300] [c0000000001f8418] .radix_tree_insert+0x19c/0x324
[c0000000ff49f3c0] [c00000000000b758] .irq_radix_revmap+0x140/0x178
[c0000000ff49f470] [c000000000044aec] .xics_startup+0x30/0x54
[c0000000ff49f500] [c0000000000997f4] .setup_irq+0x254/0x320
[c0000000ff49f5b0] [c000000000099984] .request_irq+0xc4/0x114
[c0000000ff49f660] [d00000000079b194] .e1000_open+0xdc/0x1b8 [e1000]
[c0000000ff49f6f0] [c00000000030a840] .dev_open+0x94/0x110
[c0000000ff49f790] [c00000000030a69c] .dev_change_flags+0x110/0x220
[c0000000ff49f830] [c00000000036a0a8] .devinet_ioctl+0x2cc/0x764
[c0000000ff49f930] [c00000000036a6a8] .inet_ioctl+0xe8/0x138
[c0000000ff49f9b0] [c0000000002f9acc] .sock_ioctl+0x2c8/0x314
[c0000000ff49fa50] [c0000000000e6dec] .do_ioctl+0x5c/0xf0
[c0000000ff49faf0] [c0000000000e731c] .vfs_ioctl+0x49c/0x4d4
[c0000000ff49fba0] [c0000000000e73ec] .sys_ioctl+0x98/0xe0
[c0000000ff49fc50] [c000000000117944] .dev_ifsioc+0x1e0/0x46c
[c0000000ff49fd40] [c00000000011e1d4] .compat_sys_ioctl+0x40c/0x4a0
[c0000000ff49fe30] [c00000000000852c] syscall_exit+0x0/0x40

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 arch/powerpc/kernel/process.c        |   22 ++++++++++++++++++++++
 arch/powerpc/kernel/prom.c           |    2 +-
 arch/powerpc/mm/tlb_64.c             |    5 ++++-
 arch/powerpc/platforms/pseries/eeh.c |    2 +-
 drivers/of/base.c                    |    2 +-
 include/asm-powerpc/tlb.h            |    5 ++++-
 include/asm-powerpc/tlbflush.h       |   15 ++++++++++-----
 7 files changed, 43 insertions(+), 10 deletions(-)

diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/kernel/process.c linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/process.c
--- linux-2.6.23.1-rt4/arch/powerpc/kernel/process.c	2007-10-12 09:43:44.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/process.c	2007-11-12 09:18:55.000000000 -0800
@@ -245,6 +245,10 @@ struct task_struct *__switch_to(struct t
 	struct thread_struct *new_thread, *old_thread;
 	unsigned long flags;
 	struct task_struct *last;
+#ifdef CONFIG_PREEMPT_RT
+	struct ppc64_tlb_batch *batch;
+	int hadbatch;
+#endif /* #ifdef CONFIG_PREEMPT_RT */
 
 #ifdef CONFIG_SMP
 	/* avoid complexity of lazy save/restore of fpu
@@ -325,6 +329,17 @@ struct task_struct *__switch_to(struct t
 	}
 #endif
 
+#ifdef CONFIG_PREEMPT_RT
+	batch = &__get_cpu_var(ppc64_tlb_batch);
+	if (batch->active) {
+		hadbatch = 1;
+		if (batch->index) {
+			__flush_tlb_pending(batch);
+		}
+		batch->active = 0;
+	}
+#endif /* #ifdef CONFIG_PREEMPT_RT */
+
 	local_irq_save(flags);
 
 	account_system_vtime(current);
@@ -335,6 +350,13 @@ struct task_struct *__switch_to(struct t
 
 	local_irq_restore(flags);
 
+#ifdef CONFIG_PREEMPT_RT
+	if (hadbatch) {
+		batch = &__get_cpu_var(ppc64_tlb_batch);
+		batch->active = 1;
+	}
+#endif /* #ifdef CONFIG_PREEMPT_RT */
+
 	return last;
 }
 
diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/kernel/prom.c linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/prom.c
--- linux-2.6.23.1-rt4/arch/powerpc/kernel/prom.c	2007-10-12 09:43:44.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/prom.c	2007-10-28 13:37:23.000000000 -0700
@@ -80,7 +80,7 @@ struct boot_param_header *initial_boot_p
 
 extern struct device_node *allnodes;	/* temporary while merging */
 
-extern rwlock_t devtree_lock;	/* temporary while merging */
+extern raw_rwlock_t devtree_lock;	/* temporary while merging */
 
 /* export that to outside world */
 struct device_node *of_chosen;
diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/mm/tlb_64.c linux-2.6.23.1-rt4-fix/arch/powerpc/mm/tlb_64.c
--- linux-2.6.23.1-rt4/arch/powerpc/mm/tlb_64.c	2007-10-27 22:20:57.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/arch/powerpc/mm/tlb_64.c	2007-11-08 16:49:04.000000000 -0800
@@ -133,7 +133,7 @@ void pgtable_free_tlb(struct mmu_gather 
 void hpte_need_flush(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, unsigned long pte, int huge)
 {
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);
 	unsigned long vsid, vaddr;
 	unsigned int psize;
 	real_pte_t rpte;
@@ -180,6 +180,7 @@ void hpte_need_flush(struct mm_struct *m
 	 */
 	if (!batch->active) {
 		flush_hash_page(vaddr, rpte, psize, 0);
+		put_cpu_var(ppc64_tlb_batch);
 		return;
 	}
 
@@ -212,12 +213,14 @@ void hpte_need_flush(struct mm_struct *m
 	 */
 	if (machine_is(celleb)) {
 		__flush_tlb_pending(batch);
+		put_cpu_var(ppc64_tlb_batch);
 		return;
 	}
 #endif /* CONFIG_PREEMPT_RT */
 
 	if (i >= PPC64_TLB_BATCH_NR)
 		__flush_tlb_pending(batch);
+	put_cpu_var(ppc64_tlb_batch);
 }
 
 /*
diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/platforms/pseries/eeh.c linux-2.6.23.1-rt4-fix/arch/powerpc/platforms/pseries/eeh.c
--- linux-2.6.23.1-rt4/arch/powerpc/platforms/pseries/eeh.c	2007-10-12 09:43:44.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/arch/powerpc/platforms/pseries/eeh.c	2007-10-28 15:43:54.000000000 -0700
@@ -97,7 +97,7 @@ int eeh_subsystem_enabled;
 EXPORT_SYMBOL(eeh_subsystem_enabled);
 
 /* Lock to avoid races due to multiple reports of an error */
-static DEFINE_SPINLOCK(confirm_error_lock);
+static DEFINE_RAW_SPINLOCK(confirm_error_lock);
 
 /* Buffer for reporting slot-error-detail rtas calls. Its here
  * in BSS, and not dynamically alloced, so that it ends up in
diff -urpNa -X dontdiff linux-2.6.23.1-rt4/drivers/of/base.c linux-2.6.23.1-rt4-fix/drivers/of/base.c
--- linux-2.6.23.1-rt4/drivers/of/base.c	2007-10-12 09:43:44.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/drivers/of/base.c	2007-10-28 13:38:36.000000000 -0700
@@ -25,7 +25,7 @@ struct device_node *allnodes;
 /* use when traversing tree through the allnext, child, sibling,
  * or parent members of struct device_node.
  */
-DEFINE_RWLOCK(devtree_lock);
+DEFINE_RAW_RWLOCK(devtree_lock);
 
 int of_n_addr_cells(struct device_node *np)
 {
diff -urpNa -X dontdiff linux-2.6.23.1-rt4/include/asm-powerpc/tlbflush.h linux-2.6.23.1-rt4-fix/include/asm-powerpc/tlbflush.h
--- linux-2.6.23.1-rt4/include/asm-powerpc/tlbflush.h	2007-10-12 09:43:44.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/include/asm-powerpc/tlbflush.h	2007-11-08 17:11:18.000000000 -0800
@@ -109,18 +109,23 @@ extern void hpte_need_flush(struct mm_st
 
 static inline void arch_enter_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);
 
 	batch->active = 1;
+	put_cpu_var(ppc64_tlb_batch);
 }
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch = &__get_cpu_var(ppc64_tlb_batch);
+	struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);
 
-	if (batch->index)
-		__flush_tlb_pending(batch);
-	batch->active = 0;
+	if (batch->active) {
+		if (batch->index) {
+			__flush_tlb_pending(batch);
+		}
+		batch->active = 0;
+	}
+	put_cpu_var(ppc64_tlb_batch);
 }
 
 #define arch_flush_lazy_mmu_mode()      do {} while (0)
diff -urpNa -X dontdiff linux-2.6.23.1-rt4/include/asm-powerpc/tlb.h linux-2.6.23.1-rt4-fix/include/asm-powerpc/tlb.h
--- linux-2.6.23.1-rt4/include/asm-powerpc/tlb.h	2007-10-12 09:43:44.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/include/asm-powerpc/tlb.h	2007-10-28 11:36:05.000000000 -0700
@@ -44,8 +44,11 @@ static inline void tlb_flush(struct mmu_
 	 * pages are going to be freed and we really don't want to have a CPU
 	 * access a freed page because it has a stale TLB
 	 */
-	if (tlbbatch->index)
+	if (tlbbatch->index) {
+		preempt_disable();
 		__flush_tlb_pending(tlbbatch);
+		preempt_enable();
+	}
 
 	pte_free_finish();
 }

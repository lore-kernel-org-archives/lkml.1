Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbXKIWHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbXKIWHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 17:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbXKIWHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 17:07:32 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:35367 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbXKIWHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 17:07:30 -0500
Date: Fri, 9 Nov 2007 14:07:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, tony@bakeyournoodle.com, paulus@samba.org,
       dino@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       antonb@us.ibm.com, rostedt@goodmis.org
Subject: Re: [PATCH, RFC] improved hacks to allow -rt to run kernbench on POWER
Message-ID: <20071109220717.GJ8826@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071109181028.GA26800@linux.vnet.ibm.com> <1194641524.21340.14.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194641524.21340.14.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 07:52:04AM +1100, Benjamin Herrenschmidt wrote:
> > diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/kernel/process.c linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/process.c
> > --- linux-2.6.23.1-rt4/arch/powerpc/kernel/process.c	2007-10-12 09:43:44.000000000 -0700
> > +++ linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/process.c	2007-11-08 20:33:59.000000000 -0800
> > @@ -245,6 +245,8 @@ struct task_struct *__switch_to(struct t
> >  	struct thread_struct *new_thread, *old_thread;
> >  	unsigned long flags;
> >  	struct task_struct *last;
> > +	struct ppc64_tlb_batch *batch;
> > +	int hadbatch;
> >  
> >  #ifdef CONFIG_SMP
> >  	/* avoid complexity of lazy save/restore of fpu
> > @@ -325,6 +327,16 @@ struct task_struct *__switch_to(struct t
> >  	}
> >  #endif
> >  
> > +	batch = &get_cpu_var(ppc64_tlb_batch);
> > +	if (batch->active) {
> > +		hadbatch = 1;
> > +		if (batch->index) {
> > +			__flush_tlb_pending(batch);
> > +		}
> > +		batch->active = 0;
> > +	}
> > +	put_cpu_var(ppc64_tlb_batch);
> > +
> >  	local_irq_save(flags);
> >  
> >  	account_system_vtime(current);
> > @@ -335,6 +347,12 @@ struct task_struct *__switch_to(struct t
> >  
> >  	local_irq_restore(flags);
> >  
> > +	if (hadbatch) {
> > +		batch = &get_cpu_var(ppc64_tlb_batch);
> > +		batch->active = 1;
> > +		put_cpu_var(ppc64_tlb_batch);
> > +	}
> > +
> >  	return last;
> >  }
> 
> I doubt we can schedule within __switch_to() (can somebody confirm
> this ?), in which case, you can just use __get_cpu_var() and avoid
> the put, thus saving a handful of cycles in the code above.

Thank you for looking this over!

I tried this, and it seemed to work.

> >  /* export that to outside world */
> >  struct device_node *of_chosen;
> > diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/mm/fault.c linux-2.6.23.1-rt4-fix/arch/powerpc/mm/fault.c
> > --- linux-2.6.23.1-rt4/arch/powerpc/mm/fault.c	2007-10-27 22:20:57.000000000 -0700
> > +++ linux-2.6.23.1-rt4-fix/arch/powerpc/mm/fault.c	2007-10-28 13:49:07.000000000 -0700
> > @@ -301,6 +301,7 @@ good_area:
> >  		if (get_pteptr(mm, address, &ptep, &pmdp)) {
> >  			spinlock_t *ptl = pte_lockptr(mm, pmdp);
> >  			spin_lock(ptl);
> > +			preempt_disable();
> >  			if (pte_present(*ptep)) {
> >  				struct page *page = pte_page(*ptep);
> >  
> > @@ -310,10 +311,12 @@ good_area:
> >  				}
> >  				pte_update(ptep, 0, _PAGE_HWEXEC);
> >  				_tlbie(address);
> > +				preempt_enable();
> >  				pte_unmap_unlock(ptep, ptl);
> >  				up_read(&mm->mmap_sem);
> >  				return 0;
> >  			}
> > +			preempt_enable();
> >  			pte_unmap_unlock(ptep, ptl);
> >  		}
> >  #endif
> 
> 
> The patch above will have to be rebased following a fix I did that makes
> _tlbie() takes a context ID argument. I don't actually think
> preempt_disable/enable is necessary here. I don't think it matters if we
> preempt here, but I suppose better safe than sorry.... (this is 44x
> code).

Removed this as well, also seemed to work.  Please note, however, that
this is just running kernbench.  But this did seem to get rid of some
of the warnings as well.  ;-)  Now only have the xics_startup() warning.

> Overall, looks fine !

I bet that there are more gotchas lurking in there somewhere, but in
the meantime here is the updated patch.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 arch/powerpc/kernel/process.c        |   16 ++++++++++++++++
 arch/powerpc/kernel/prom.c           |    2 +-
 arch/powerpc/mm/tlb_64.c             |    5 ++++-
 arch/powerpc/platforms/pseries/eeh.c |    2 +-
 drivers/of/base.c                    |    2 +-
 include/asm-powerpc/tlb.h            |    5 ++++-
 include/asm-powerpc/tlbflush.h       |   15 ++++++++++-----
 7 files changed, 37 insertions(+), 10 deletions(-)

diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/kernel/process.c linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/process.c
--- linux-2.6.23.1-rt4/arch/powerpc/kernel/process.c	2007-10-12 09:43:44.000000000 -0700
+++ linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/process.c	2007-11-09 13:24:46.000000000 -0800
@@ -245,6 +245,8 @@ struct task_struct *__switch_to(struct t
 	struct thread_struct *new_thread, *old_thread;
 	unsigned long flags;
 	struct task_struct *last;
+	struct ppc64_tlb_batch *batch;
+	int hadbatch;
 
 #ifdef CONFIG_SMP
 	/* avoid complexity of lazy save/restore of fpu
@@ -325,6 +327,15 @@ struct task_struct *__switch_to(struct t
 	}
 #endif
 
+	batch = &__get_cpu_var(ppc64_tlb_batch);
+	if (batch->active) {
+		hadbatch = 1;
+		if (batch->index) {
+			__flush_tlb_pending(batch);
+		}
+		batch->active = 0;
+	}
+
 	local_irq_save(flags);
 
 	account_system_vtime(current);
@@ -335,6 +346,11 @@ struct task_struct *__switch_to(struct t
 
 	local_irq_restore(flags);
 
+	if (hadbatch) {
+		batch = &__get_cpu_var(ppc64_tlb_batch);
+		batch->active = 1;
+	}
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

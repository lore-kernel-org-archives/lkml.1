Return-Path: <linux-kernel-owner+w=401wt.eu-S1762859AbYEVN7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859AbYEVN7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 09:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbYEVN6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 09:58:53 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:58099 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbYEVN6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 09:58:51 -0400
From: Srinivasa D S <srinivasa@in.ibm.com>
Organization: IBM
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] To improve kretprobe scalability
Date: Thu, 22 May 2008 13:56:39 +0530
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, mhiramat@redhat.com,
       jkenisto@us.ibm.com, srikar@linux.vnet.ibm.com
References: <200805210632.17655.srinivasa@in.ibm.com> <20080521163235.0fcb39ed.akpm@linux-foundation.org>
In-Reply-To: <20080521163235.0fcb39ed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221356.40098.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2008 05:02:35 am Andrew Morton wrote:
> On Wed, 21 May 2008 06:32:17 +0530
>
> Srinivasa D S <srinivasa@in.ibm.com> wrote:
> > Currently list of kretprobe instances are stored in kretprobe object (as
> > used_instances,free_instances) and in kretprobe hash table. 
>
> Are you sure that all the code which was previously globally serialised
> is safe to run concurrently?

Yes, Iam sure.  I have tested this patch on all architecture. I have written 
the systemtap script which probes all systemcalls and its return values. This 
works fine on patched kernel.

>
> > Time duration for  kernel compilation ("make -j 8") on a 8-way ppc64
> > system with return probes set on all systemcalls looks like this.
> >
> > Patched-kernel                            Un-Patched kernel
> > ============================================================
> > real    10m49.694s                       real    13m21.276s
> > user    35m6.117s                        user    40m30.454s
> > sys     2m55.480s                        sys     3m23.221s
> > ===========================================================
>
> That's a large speedup.
>
> Do you have available the figures for the same workload when no probes
> are set at all?

As I was concerned with the performance of kretprobes, I don't have figures on 
the workload when probes are set. But, currently I have implemented your 
cacheline aligned approach and captured this data. Please see below(in the 
patch).

>
> > --- linux-2.6.26-rc2-mm1.orig/kernel/kprobes.c
> > +++ linux-2.6.26-rc2-mm1/kernel/kprobes.c
> >
> >  DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
> > -DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
> >  static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
> > +static spinlock_t kretprobe_table_locks[KPROBE_TABLE_SIZE];
>
> An array of 64 spinlocks.  These will all be crammed into two or four
> cachelines.  If there is really any concurrency in here, the contention
> will be large.
>
> I suggest that you experiment with one-lock-per-cacheline here and see
> whether it is worth doing that permanently.
>
> Something along the lines of
>
> static struct {
> 	spinlock_t lock __cacheline_aligned;
> } kretprobe_locks[KPROBE_TABLE_SIZE];
>
> static spinlock_t *kretprobe_lock_ptr(...)
> {
> 	return kretprobe_locks + hash(...);
> }
>
>

Thanks for the suggestion. I have implemented this approach and by looking at 
the statistics(attached in the patch), there is slight improvement in 
kretprobe performance.


> Also, none of this new code is needed on uniprocessor builds.  Did we
> just add some bloat?
>

No Andrew, We just replaced old kretprobe_lock code with the new one. Since 
kretprobe_lock was also used in arch dependent code, we have modified arch 
dependent kprobes.c file. 
But code added to kernel.[ch] is very less, 51 lines of code gets added to 
kprobes.c(with the new patch, attached below) and this has caused speedup in 
performance.

> > +void put_kretprobe_hash_lock(struct task_struct *tsk, unsigned long
> > *flags) {
> > -	return &kretprobe_inst_table[hash_ptr(tsk, KPROBE_HASH_BITS)];
> > +	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
> > +	spinlock_t *hlist_lock;
> > +
> > +	hlist_lock = &kretprobe_table_locks[hash];
> > +	spin_unlock_irqrestore(hlist_lock, *flags);
> >  }
>
> I think these functions are misnamed.  Generally functions whose names
> are of the form get_foo() and put_foo() are used for acquiring and
> releasing reference counts.  These functions don't do that.
>
> kretprobe_hash_lock() and kretprobe_hash_unlock() would be better?

Sounds good to me, Done.

>
> >  /*
> > @@ -401,17 +417,21 @@ void __kprobes kprobe_flush_task(struct
> >  	struct kretprobe_instance *ri;
> >  	struct hlist_head *head, empty_rp;
> >  	struct hlist_node *node, *tmp;
> >  	}
> > -	spin_unlock_irqrestore(&kretprobe_lock, flags);
> > -
> > +	spin_unlock_irqrestore(&kretprobe_table_locks[hash], flags);
>
> and of put_kretprobe_hash_lock().  Perhaps a separate function which
> just obtains the spinlock_t* is needed.

Added to the code.
>
> > +	INIT_HLIST_HEAD(&empty_rp);
> >  	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
> >  		hlist_del(&ri->hlist);

Resending the patch, Again


Currently list of kretprobe instances are stored in kretprobe object (as
used_instances,free_instances) and in kretprobe hash table. We have one 
global kretprobe lock to serialise the access to these lists. This causes 
only one kretprobe handler to execute at a time. Hence affects system 
performance, particularly on SMP systems and when return probe is set on
lot of functions (like on all systemcalls).

Solution proposed here gives fine-grain locks that performs better on SMP
system compared to present kretprobe implementation.

Solution:
   1) Instead of having one global lock to protect kretprobe instances  
present 
in kretprobe object and kretprobe hash table. We will have two locks, one lock
for protecting kretprobe hash table and another lock for kretporbe object.
	
  2) We hold lock present in kretprobe object while we modify kretprobe 
instance in
kretprobe object and we hold per-hash-list lock while modifying kretprobe 
instances 
present in that hash list. To prevent deadlock, we never grab a per-hash-list
lock while holding a kretprobe lock.

  3) We can remove used_instances from struct kretprobe, as we can track used
instances of kretprobe instances using kretprobe hash table.

Time duration for  kernel compilation ("make -j 8") on a 8-way ppc64 system
with return probes set on all systemcalls looks like this.

cacheline              non-cacheline             Un-patched kernel 
aligned patch 	       aligned patch                            
===============================================================================
real    9m46.784s       9m54.412s                  10m2.450s   
user    40m5.715s       40m7.142s                  40m4.273s 
sys     2m57.754s       2m58.583s                  3m17.430s                            
===========================================================

Time duration for kernel compilation ("make -j 8) on the same system, when 
kernel is not probed.
=========================
real    9m26.389s
user    40m8.775s
sys     2m7.283s
=========================

Please let me know your comments on the patch attached here.

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>



---
 arch/arm/kernel/kprobes.c     |    6 -
 arch/ia64/kernel/kprobes.c    |    6 -
 arch/powerpc/kernel/kprobes.c |    6 -
 arch/s390/kernel/kprobes.c    |    6 -
 arch/sparc64/kernel/kprobes.c |   11 +--
 arch/x86/kernel/kprobes.c     |    6 -
 include/linux/kprobes.h       |    7 +-
 kernel/kprobes.c              |  127 
+++++++++++++++++++++++++++++-------------
 8 files changed, 108 insertions(+), 67 deletions(-)

Index: linux-2.6.26-rc2-mm1/arch/ia64/kernel/kprobes.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/arch/ia64/kernel/kprobes.c
+++ linux-2.6.26-rc2-mm1/arch/ia64/kernel/kprobes.c
@@ -429,8 +429,7 @@ int __kprobes trampoline_probe_handler(s
 		((struct fnptr *)kretprobe_trampoline)->ip;
 
 	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
+	kretprobe_hash_lock(current, &head, &flags);
 
 	/*
 	 * It is possible to have multiple instances associated with a given
@@ -485,7 +484,7 @@ int __kprobes trampoline_probe_handler(s
 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 
 	reset_current_kprobe();
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	kretprobe_hash_unlock(current, &flags);
 	preempt_enable_no_resched();
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
@@ -500,7 +499,6 @@ int __kprobes trampoline_probe_handler(s
 	return 1;
 }
 
-/* Called with kretprobe_lock held */
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
Index: linux-2.6.26-rc2-mm1/arch/powerpc/kernel/kprobes.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/arch/powerpc/kernel/kprobes.c
+++ linux-2.6.26-rc2-mm1/arch/powerpc/kernel/kprobes.c
@@ -127,7 +127,6 @@ static void __kprobes set_current_kprobe
 	kcb->kprobe_saved_msr = regs->msr;
 }
 
-/* Called with kretprobe_lock held */
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
@@ -294,8 +293,7 @@ static int __kprobes trampoline_probe_ha
 	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
 
 	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
+	kretprobe_hash_lock(current, &head, &flags);
 
 	/*
 	 * It is possible to have multiple instances associated with a given
@@ -334,7 +332,7 @@ static int __kprobes trampoline_probe_ha
 	regs->nip = orig_ret_address;
 
 	reset_current_kprobe();
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	kretprobe_hash_unlock(current, &flags);
 	preempt_enable_no_resched();
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
Index: linux-2.6.26-rc2-mm1/arch/s390/kernel/kprobes.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/arch/s390/kernel/kprobes.c
+++ linux-2.6.26-rc2-mm1/arch/s390/kernel/kprobes.c
@@ -272,7 +272,6 @@ static void __kprobes set_current_kprobe
 	__ctl_store(kcb->kprobe_saved_ctl, 9, 11);
 }
 
-/* Called with kretprobe_lock held */
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 					struct pt_regs *regs)
 {
@@ -379,8 +378,7 @@ static int __kprobes trampoline_probe_ha
 	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
 
 	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
+	kretprobe_hash_lock(current, &head, &flags);
 
 	/*
 	 * It is possible to have multiple instances associated with a given
@@ -419,7 +417,7 @@ static int __kprobes trampoline_probe_ha
 	regs->psw.addr = orig_ret_address | PSW_ADDR_AMODE;
 
 	reset_current_kprobe();
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	kretprobe_hash_unlock(current, &flags);
 	preempt_enable_no_resched();
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
Index: linux-2.6.26-rc2-mm1/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/arch/x86/kernel/kprobes.c
+++ linux-2.6.26-rc2-mm1/arch/x86/kernel/kprobes.c
@@ -431,7 +431,6 @@ static void __kprobes prepare_singlestep
 		regs->ip = (unsigned long)p->ainsn.insn;
 }
 
-/* Called with kretprobe_lock held */
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
@@ -682,8 +681,7 @@ static __used __kprobes void *trampoline
 	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
 
 	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
+	kretprobe_hash_lock(current, &head, &flags);
 	/* fixup registers */
 #ifdef CONFIG_X86_64
 	regs->cs = __KERNEL_CS;
@@ -732,7 +730,7 @@ static __used __kprobes void *trampoline
 
 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	kretprobe_hash_unlock(current, &flags);
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
Index: linux-2.6.26-rc2-mm1/include/linux/kprobes.h
===================================================================
--- linux-2.6.26-rc2-mm1.orig/include/linux/kprobes.h
+++ linux-2.6.26-rc2-mm1/include/linux/kprobes.h
@@ -157,11 +157,10 @@ struct kretprobe {
 	int nmissed;
 	size_t data_size;
 	struct hlist_head free_instances;
-	struct hlist_head used_instances;
+	spinlock_t lock;
 };
 
 struct kretprobe_instance {
-	struct hlist_node uflist; /* either on free list or used list */
 	struct hlist_node hlist;
 	struct kretprobe *rp;
 	kprobe_opcode_t *ret_addr;
@@ -201,7 +200,6 @@ static inline int init_test_probes(void)
 }
 #endif /* CONFIG_KPROBES_SANITY_TEST */
 
-extern spinlock_t kretprobe_lock;
 extern struct mutex kprobe_mutex;
 extern int arch_prepare_kprobe(struct kprobe *p);
 extern void arch_arm_kprobe(struct kprobe *p);
@@ -214,6 +212,9 @@ extern void kprobes_inc_nmissed_count(st
 
 /* Get the kprobe at this addr (if any) - called with preemption disabled */
 struct kprobe *get_kprobe(void *addr);
+void kretprobe_hash_lock(struct task_struct *tsk,
+			 struct hlist_head **head, unsigned long *flags);
+void kretprobe_hash_unlock(struct task_struct *tsk, unsigned long *flags);
 struct hlist_head * kretprobe_inst_table_head(struct task_struct *tsk);
 
 /* kprobe_running() will just return the current_kprobe on this CPU */
Index: linux-2.6.26-rc2-mm1/kernel/kprobes.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/kernel/kprobes.c
+++ linux-2.6.26-rc2-mm1/kernel/kprobes.c
@@ -62,6 +62,7 @@
 	addr = ((kprobe_opcode_t *)(kallsyms_lookup_name(name)))
 #endif
 
+static int kprobes_initialized;
 static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 
@@ -69,8 +70,15 @@ static struct hlist_head kretprobe_inst_
 static bool kprobe_enabled;
 
 DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
-DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
+static struct {
+	spinlock_t lock ____cacheline_aligned;
+} kretprobe_table_locks[KPROBE_TABLE_SIZE];
+
+static spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
+{
+	return &(kretprobe_table_locks[hash].lock);
+}
 
 /*
  * Normally, functions that we'd want to prohibit kprobes in, are marked
@@ -368,26 +376,53 @@ void __kprobes kprobes_inc_nmissed_count
 	return;
 }
 
-/* Called with kretprobe_lock held */
 void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
 				struct hlist_head *head)
 {
+	struct kretprobe *rp = ri->rp;
+
 	/* remove rp inst off the rprobe_inst_table */
 	hlist_del(&ri->hlist);
-	if (ri->rp) {
-		/* remove rp inst off the used list */
-		hlist_del(&ri->uflist);
-		/* put rp inst back onto the free list */
-		INIT_HLIST_NODE(&ri->uflist);
-		hlist_add_head(&ri->uflist, &ri->rp->free_instances);
+	INIT_HLIST_NODE(&ri->hlist);
+	if (likely(rp)) {
+		spin_lock(&rp->lock);
+		hlist_add_head(&ri->hlist, &rp->free_instances);
+		spin_unlock(&rp->lock);
 	} else
 		/* Unregistering */
 		hlist_add_head(&ri->hlist, head);
 }
 
-struct hlist_head __kprobes *kretprobe_inst_table_head(struct task_struct 
*tsk)
+void kretprobe_hash_lock(struct task_struct *tsk,
+			 struct hlist_head **head, unsigned long *flags)
+{
+	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
+	spinlock_t *hlist_lock;
+
+	*head = &kretprobe_inst_table[hash];
+	hlist_lock = kretprobe_table_lock_ptr(hash);
+	spin_lock_irqsave(hlist_lock, *flags);
+}
+
+void kretprobe_table_lock(unsigned long hash, unsigned long *flags)
 {
-	return &kretprobe_inst_table[hash_ptr(tsk, KPROBE_HASH_BITS)];
+	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
+	spin_lock_irqsave(hlist_lock, *flags);
+}
+
+void kretprobe_hash_unlock(struct task_struct *tsk, unsigned long *flags)
+{
+	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
+	spinlock_t *hlist_lock;
+
+	hlist_lock = kretprobe_table_lock_ptr(hash);
+	spin_unlock_irqrestore(hlist_lock, *flags);
+}
+
+void kretprobe_table_unlock(unsigned long hash, unsigned long *flags)
+{
+	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
+	spin_unlock_irqrestore(hlist_lock, *flags);
 }
 
 /*
@@ -401,17 +436,21 @@ void __kprobes kprobe_flush_task(struct 
 	struct kretprobe_instance *ri;
 	struct hlist_head *head, empty_rp;
 	struct hlist_node *node, *tmp;
-	unsigned long flags = 0;
+	unsigned long hash, flags = 0;
 
-	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(tk);
+	if (unlikely(!kprobes_initialized))
+		/* Early boot.  kretprobe_table_locks not yet initialized. */
+		return;
+
+	hash = hash_ptr(tk, KPROBE_HASH_BITS);
+	head = &kretprobe_inst_table[hash];
+	kretprobe_table_lock(hash, &flags);
 	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
 		if (ri->task == tk)
 			recycle_rp_inst(ri, &empty_rp);
 	}
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-
+	kretprobe_table_unlock(hash, &flags);
+	INIT_HLIST_HEAD(&empty_rp);
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
@@ -423,24 +462,29 @@ static inline void free_rp_inst(struct k
 	struct kretprobe_instance *ri;
 	struct hlist_node *pos, *next;
 
-	hlist_for_each_entry_safe(ri, pos, next, &rp->free_instances, uflist) {
-		hlist_del(&ri->uflist);
+	hlist_for_each_entry_safe(ri, pos, next, &rp->free_instances, hlist) {
+		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
 }
 
 static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
 {
-	unsigned long flags;
+	unsigned long flags, hash;
 	struct kretprobe_instance *ri;
 	struct hlist_node *pos, *next;
+	struct hlist_head *head;
+
 	/* No race here */
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	hlist_for_each_entry_safe(ri, pos, next, &rp->used_instances, uflist) {
-		ri->rp = NULL;
-		hlist_del(&ri->uflist);
+	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
+		kretprobe_table_lock(hash, &flags);
+		head = &kretprobe_inst_table[hash];
+		hlist_for_each_entry_safe(ri, pos, next, head, hlist) {
+			if (ri->rp == rp)
+				ri->rp = NULL;
+		}
+		kretprobe_table_unlock(hash, &flags);
 	}
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
 	free_rp_inst(rp);
 }
 
@@ -829,32 +873,37 @@ static int __kprobes pre_handler_kretpro
 					   struct pt_regs *regs)
 {
 	struct kretprobe *rp = container_of(p, struct kretprobe, kp);
-	unsigned long flags = 0;
+	unsigned long hash, flags = 0;
+	struct kretprobe_instance *ri;
 
 	/*TODO: consider to only swap the RA after the last pre_handler fired */
-	spin_lock_irqsave(&kretprobe_lock, flags);
+	hash = hash_ptr(current, KPROBE_HASH_BITS);
+	spin_lock_irqsave(&rp->lock, flags);
 	if (!hlist_empty(&rp->free_instances)) {
-		struct kretprobe_instance *ri;
-
 		ri = hlist_entry(rp->free_instances.first,
-				 struct kretprobe_instance, uflist);
+				struct kretprobe_instance, hlist);
+		hlist_del(&ri->hlist);
+		spin_unlock_irqrestore(&rp->lock, flags);
+
 		ri->rp = rp;
 		ri->task = current;
 
 		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
-			spin_unlock_irqrestore(&kretprobe_lock, flags);
+			spin_unlock_irqrestore(&rp->lock, flags);
 			return 0;
 		}
 
 		arch_prepare_kretprobe(ri, regs);
 
 		/* XXX(hch): why is there no hlist_move_head? */
-		hlist_del(&ri->uflist);
-		hlist_add_head(&ri->uflist, &ri->rp->used_instances);
-		hlist_add_head(&ri->hlist, kretprobe_inst_table_head(ri->task));
-	} else
+		INIT_HLIST_NODE(&ri->hlist);
+		kretprobe_table_lock(hash, &flags);
+		hlist_add_head(&ri->hlist, &kretprobe_inst_table[hash]);
+		kretprobe_table_unlock(hash, &flags);
+	} else {
 		rp->nmissed++;
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+		spin_unlock_irqrestore(&rp->lock, flags);
+	}
 	return 0;
 }
 
@@ -890,7 +939,7 @@ static int __kprobes __register_kretprob
 		rp->maxactive = NR_CPUS;
 #endif
 	}
-	INIT_HLIST_HEAD(&rp->used_instances);
+	spin_lock_init(&rp->lock);
 	INIT_HLIST_HEAD(&rp->free_instances);
 	for (i = 0; i < rp->maxactive; i++) {
 		inst = kmalloc(sizeof(struct kretprobe_instance) +
@@ -899,8 +948,8 @@ static int __kprobes __register_kretprob
 			free_rp_inst(rp);
 			return -ENOMEM;
 		}
-		INIT_HLIST_NODE(&inst->uflist);
-		hlist_add_head(&inst->uflist, &rp->free_instances);
+		INIT_HLIST_NODE(&inst->hlist);
+		hlist_add_head(&inst->hlist, &rp->free_instances);
 	}
 
 	rp->nmissed = 0;
@@ -1006,6 +1055,7 @@ static int __init init_kprobes(void)
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		INIT_HLIST_HEAD(&kprobe_table[i]);
 		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
+		spin_lock_init(&(kretprobe_table_locks[i].lock));
 	}
 
 	/*
@@ -1047,6 +1097,7 @@ static int __init init_kprobes(void)
 	err = arch_init_kprobes();
 	if (!err)
 		err = register_die_notifier(&kprobe_exceptions_nb);
+	kprobes_initialized = (err == 0);
 
 	if (!err)
 		init_test_probes();
Index: linux-2.6.26-rc2-mm1/arch/sparc64/kernel/kprobes.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/arch/sparc64/kernel/kprobes.c
+++ linux-2.6.26-rc2-mm1/arch/sparc64/kernel/kprobes.c
@@ -478,9 +478,9 @@ int __kprobes longjmp_break_handler(stru
 	return 0;
 }
 
-/* Called with kretprobe_lock held.  The value stored in the return
- * address register is actually 2 instructions before where the
- * callee will return to.  Sequences usually look something like this
+/* The value stored in the return address register is actually 2
+ * instructions before where the callee will return to.
+ * Sequences usually look something like this
  *
  *		call	some_function	<--- return register points here
  *		 nop			<--- call delay slot
@@ -512,8 +512,7 @@ int __kprobes trampoline_probe_handler(s
 	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
 
 	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
+	kretprobe_hash_lock(current, &head, &flags);
 
 	/*
 	 * It is possible to have multiple instances associated with a given
@@ -553,7 +552,7 @@ int __kprobes trampoline_probe_handler(s
 	regs->tnpc = orig_ret_address + 4;
 
 	reset_current_kprobe();
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	kretprobe_hash_unlock(current, &flags);
 	preempt_enable_no_resched();
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
Index: linux-2.6.26-rc2-mm1/arch/arm/kernel/kprobes.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/arch/arm/kernel/kprobes.c
+++ linux-2.6.26-rc2-mm1/arch/arm/kernel/kprobes.c
@@ -296,8 +296,7 @@ static __used __kprobes void *trampoline
 	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
 
 	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
+	kretprobe_hash_lock(current, &head, &flags);
 
 	/*
 	 * It is possible to have multiple instances associated with a given
@@ -337,7 +336,7 @@ static __used __kprobes void *trampoline
 	}
 
 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	kretprobe_hash_unlock(current, &flags);
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
@@ -347,7 +346,6 @@ static __used __kprobes void *trampoline
 	return (void *)orig_ret_address;
 }
 
-/* Called with kretprobe_lock held. */
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {


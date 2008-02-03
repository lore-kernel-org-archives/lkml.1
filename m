Return-Path: <linux-kernel-owner+w=401wt.eu-S936553AbYBCJxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936553AbYBCJxO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 04:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760940AbYBCJw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 04:52:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:59208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506AbYBCJw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 04:52:57 -0500
Date: Sun, 3 Feb 2008 10:52:52 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       ak@suse.de, jens.axboe@oracle.com, James.Bottomley@SteelEye.com,
       andrea@suse.de, clameter@sgi.com, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com, willy@linux.intel.com,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20080203095252.GA11043@wotan.suse.de>
References: <20070728012128.GB10033@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070728012128.GB10033@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 06:21:28PM -0700, Suresh B wrote:
> 
> Second experiment which we did was migrating the IO submission to the
> IO completion cpu. Instead of submitting the IO on the same cpu where the
> request arrived, in this experiment  the IO submission gets migrated to the
> cpu that is processing IO completions(interrupt). This will minimize the
> access to remote cachelines (that happens in timers, slab, scsi layers). The
> IO submission request is forwarded to the kblockd thread on the cpu receiving
> the interrupts. As part of this, we also made kblockd thread on each cpu as the
> highest priority thread, so that IO gets submitted as soon as possible on the
> interrupt cpu with out any delay. On x86_64 SMP platform with 16 cores, this
> resulted in 2% performance improvement and 3.3% improvement on two node ia64
> platform.
> 
> Quick and dirty prototype patch(not meant for inclusion) for this io migration
> experiment is appended to this e-mail.
> 
> Observation #1 mentioned above is also applicable to this experiment. CPU's
> processing interrupts will now have to cater IO submission/processing
> load aswell.
> 
> Observation #2: This introduces some migration overhead during IO submission.
> With the current prototype, every incoming IO request results in an IPI and
> context switch(to kblockd thread) on the interrupt processing cpu.
> This issue needs to be addressed and main challenge to address is
> the efficient mechanism of doing this IO migration(how much batching to do and
> when to send the migrate request?), so that we don't delay the IO much and at
> the same point, don't cause much overhead during migration.

Hi guys,

Just had another way we might do this. Migrate the completions out to
the submitting CPUs rather than migrate submission into the completing
CPU.

I've got a basic patch that passes some stress testing. It seems fairly
simple to do at the block layer, and the bulk of the patch involves
introducing a scalable smp_call_function for it.

Now it could be optimised more by looking at batching up IPIs or
optimising the call function path or even mirating the completion event
at a different level...

However, this is a first cut. It actually seems like it might be taking
slightly more CPU to process block IO (~0.2%)... however, this is on my
dual core system that shares an llc, which means that there are very few
cache benefits to the migration, but non-zero overhead. So on multisocket
systems hopefully it might get to positive territory.

---

Index: linux-2.6/arch/x86/kernel/smp_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smp_64.c
+++ linux-2.6/arch/x86/kernel/smp_64.c
@@ -321,6 +321,99 @@ void unlock_ipi_call_lock(void)
 	spin_unlock_irq(&call_lock);
 }
 
+struct call_single_data {
+	struct list_head list;
+	void (*func) (void *info);
+	void *info;
+	int wait;
+};
+
+struct call_single_queue {
+	spinlock_t lock;
+	struct list_head list;
+};
+static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
+
+int __cpuinit init_smp_call(void)
+{
+	int i;
+
+	for_each_cpu_mask(i, cpu_possible_map) {
+		spin_lock_init(&per_cpu(call_single_queue, i).lock);
+		INIT_LIST_HEAD(&per_cpu(call_single_queue, i).list);
+	}
+	return 0;
+}
+core_initcall(init_smp_call);
+
+/*
+ * this function sends a 'generic call function' IPI to all other CPU
+ * of the system defined in the mask.
+ */
+int smp_call_function_fast(int cpu, void (*func)(void *), void *info,
+				    int wait)
+{
+	struct call_single_data *data;
+	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
+	cpumask_t mask = cpumask_of_cpu(cpu);
+	int ipi;
+
+	data = kmalloc(sizeof(struct call_single_data), GFP_ATOMIC);
+	data->func = func;
+	data->info = info;
+	data->wait = wait;
+
+	spin_lock_irq(&dst->lock);
+	ipi = list_empty(&dst->list);
+	list_add_tail(&data->list, &dst->list);
+	spin_unlock_irq(&dst->lock);
+
+	if (ipi)
+		send_IPI_mask(mask, CALL_FUNCTION_SINGLE_VECTOR);
+
+	if (wait) {
+		/* Wait for response */
+		while (data->wait)
+			cpu_relax();
+		kfree(data);
+	}
+
+	return 0;
+}
+
+asmlinkage void smp_call_function_fast_interrupt(void)
+{
+	struct call_single_queue *q;
+	unsigned long flags;
+	LIST_HEAD(list);
+
+	ack_APIC_irq();
+
+	q = &__get_cpu_var(call_single_queue);
+	spin_lock_irqsave(&q->lock, flags);
+	list_replace_init(&q->list, &list);
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	exit_idle();
+	irq_enter();
+	while (!list_empty(&list)) {
+		struct call_single_data *data;
+
+		data = list_entry(list.next, struct call_single_data, list);
+		list_del(&data->list);
+
+		data->func(data->info);
+		if (data->wait) {
+			smp_mb();
+			data->wait = 0;
+		} else {
+			kfree(data);
+		}
+	}
+	add_pda(irq_call_count, 1);
+	irq_exit();
+}
+
 /*
  * this function sends a 'generic call function' IPI to all other CPU
  * of the system defined in the mask.
Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c
+++ linux-2.6/block/blk-core.c
@@ -1604,6 +1604,13 @@ static int __end_that_request_first(stru
 	return 1;
 }
 
+static void blk_done_softirq_other(void *data)
+{
+	struct request *rq = data;
+
+	blk_complete_request(rq);
+}
+
 /*
  * splice the completion data to a local structure and hand off to
  * process_completion_queue() to complete the requests
@@ -1622,7 +1629,15 @@ static void blk_done_softirq(struct soft
 
 		rq = list_entry(local_list.next, struct request, donelist);
 		list_del_init(&rq->donelist);
-		rq->q->softirq_done_fn(rq);
+		if (rq->submission_cpu != smp_processor_id()) {
+			/*
+			 * Could batch up IPIs here, but we should measure how
+			 * often blk_done_softirq gets a large batch...
+			 */
+			smp_call_function_fast(rq->submission_cpu,
+						blk_done_softirq_other, rq, 0);
+		} else
+			rq->q->softirq_done_fn(rq);
 	}
 }
 
Index: linux-2.6/include/asm-x86/hw_irq_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/hw_irq_64.h
+++ linux-2.6/include/asm-x86/hw_irq_64.h
@@ -68,8 +68,7 @@
 #define ERROR_APIC_VECTOR	0xfe
 #define RESCHEDULE_VECTOR	0xfd
 #define CALL_FUNCTION_VECTOR	0xfc
-/* fb free - please don't readd KDB here because it's useless
-   (hint - think what a NMI bit does to a vector) */
+#define CALL_FUNCTION_SINGLE_VECTOR	0xfb
 #define THERMAL_APIC_VECTOR	0xfa
 #define THRESHOLD_APIC_VECTOR   0xf9
 /* f8 free */
@@ -102,6 +101,7 @@ void spurious_interrupt(void);
 void error_interrupt(void);
 void reschedule_interrupt(void);
 void call_function_interrupt(void);
+void call_function_fast_interrupt(void);
 void irq_move_cleanup_interrupt(void);
 void invalidate_interrupt0(void);
 void invalidate_interrupt1(void);
Index: linux-2.6/include/linux/smp.h
===================================================================
--- linux-2.6.orig/include/linux/smp.h
+++ linux-2.6/include/linux/smp.h
@@ -53,6 +53,7 @@ extern void smp_cpus_done(unsigned int m
  * Call a function on all other processors
  */
 int smp_call_function(void(*func)(void *info), void *info, int retry, int wait);
+int smp_call_function_fast(int cpuid, void(*func)(void *info), void *info, int wait);
 
 int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 				int retry, int wait);
@@ -92,6 +93,11 @@ static inline int up_smp_call_function(v
 }
 #define smp_call_function(func, info, retry, wait) \
 			(up_smp_call_function(func, info))
+static inline int smp_call_function_fast(int cpuid, void(*func)(void *info), void *info, int wait)
+{
+	return 0;
+}
+
 #define on_each_cpu(func,info,retry,wait)	\
 	({					\
 		local_irq_disable();		\
Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c
+++ linux-2.6/block/elevator.c
@@ -648,6 +648,8 @@ void elv_insert(struct request_queue *q,
 void __elv_add_request(struct request_queue *q, struct request *rq, int where,
 		       int plug)
 {
+	rq->submission_cpu = smp_processor_id();
+
 	if (q->ordcolor)
 		rq->cmd_flags |= REQ_ORDERED_COLOR;
 
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h
+++ linux-2.6/include/linux/blkdev.h
@@ -208,6 +208,8 @@ struct request {
 
 	int ref_count;
 
+	int submission_cpu;
+
 	/*
 	 * when request is used as a packet command carrier
 	 */
Index: linux-2.6/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/entry_64.S
+++ linux-2.6/arch/x86/kernel/entry_64.S
@@ -696,6 +696,9 @@ END(invalidate_interrupt\num)
 ENTRY(call_function_interrupt)
 	apicinterrupt CALL_FUNCTION_VECTOR,smp_call_function_interrupt
 END(call_function_interrupt)
+ENTRY(call_function_fast_interrupt)
+	apicinterrupt CALL_FUNCTION_SINGLE_VECTOR,smp_call_function_fast_interrupt
+END(call_function_fast_interrupt)
 ENTRY(irq_move_cleanup_interrupt)
 	apicinterrupt IRQ_MOVE_CLEANUP_VECTOR,smp_irq_move_cleanup_interrupt
 END(irq_move_cleanup_interrupt)
Index: linux-2.6/arch/x86/kernel/i8259_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8259_64.c
+++ linux-2.6/arch/x86/kernel/i8259_64.c
@@ -493,6 +493,7 @@ void __init native_init_IRQ(void)
 
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR, call_function_fast_interrupt);
 
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
Index: linux-2.6/include/asm-x86/mach-default/entry_arch.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-default/entry_arch.h
+++ linux-2.6/include/asm-x86/mach-default/entry_arch.h
@@ -13,6 +13,7 @@
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
 BUILD_INTERRUPT(invalidate_interrupt,INVALIDATE_TLB_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
+BUILD_INTERRUPT(call_function_fast_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
 #endif
 
 /*

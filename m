Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbZF0Fbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbZF0Fbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 01:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZF0Fbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 01:31:38 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:39463 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbZF0Fbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 01:31:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19013.44646.549261.100582@cargo.ozlabs.ibm.com>
Date: Sat, 27 Jun 2009 15:30:14 +1000
From: Paul Mackerras <paulus@samba.org>
To: benh@kernel.crashing.org
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 1/2] powerpc: Allow perf_counters to access user memory at interrupt time
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a mechanism to allow the perf_counters code to access
user memory in a PMU interrupt routine on a 64-bit kernel.  Such an
access can cause a SLB miss interrupt and/or a MMU hash table miss
interrupt.

An SLB miss interrupt on a user address will update the slb_cache and
slb_cache_ptr fields in the paca.  This is OK except in the case where
a PMU interrupt occurs in switch_slb, which also accesses those fields.
To prevent this, we hard-disable interrupts in switch_slb.  Interrupts
are already soft-disabled in switch-slb, and will get hard-enabled
when they get soft-enabled later.

If a MMU hashtable miss interrupt occurs, normally we would call
hash_page to look up the Linux PTE for the address and create a HPTE.
However, hash_page is fairly complex and takes some locks, so to
avoid the possibility of deadlock, we add a flag to the paca to
indicate to the MMU hashtable miss handler that it should not call
hash_page but instead treat it like a bad access that will get
reported up through the exception table mechanism.  The PMU interrupt
code should then set this flag (get_paca()->in_pmu_nmi) and use
__get_user_inatomic to read user memory.  If there is no HPTE for
the address, __get_user_inatomic will return -EFAULT.

On a 32-bit processor, there is no SLB.  The 32-bit hash_page appears
to be safe to call in an interrupt handler since we don't do soft
disabling of interrupts on 32-bit, and the only lock that hash_page
takes is the mmu_hash_lock, which is always taken with interrupts
hard-disabled.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/include/asm/paca.h      |    3 ++-
 arch/powerpc/kernel/asm-offsets.c    |    2 ++
 arch/powerpc/kernel/exceptions-64s.S |   21 +++++++++++++++++++++
 arch/powerpc/mm/slb.c                |   10 +++++++++-
 4 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index c8a3cbf..17b29b1 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -105,7 +105,8 @@ struct paca_struct {
 	u8 soft_enabled;		/* irq soft-enable flag */
 	u8 hard_enabled;		/* set if irqs are enabled in MSR */
 	u8 io_sync;			/* writel() needs spin_unlock sync */
-	u8 perf_counter_pending;	/* PM interrupt while soft-disabled */
+	u8 perf_counter_pending;	/* perf_counter stuff needs wakeup */
+	u8 in_pmu_nmi;			/* PM interrupt while soft-disabled */
 
 	/* Stuff for accurate time accounting */
 	u64 user_time;			/* accumulated usermode TB ticks */
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 561b646..5347780 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -130,6 +130,7 @@ int main(void)
 	DEFINE(PACASOFTIRQEN, offsetof(struct paca_struct, soft_enabled));
 	DEFINE(PACAHARDIRQEN, offsetof(struct paca_struct, hard_enabled));
 	DEFINE(PACAPERFPEND, offsetof(struct paca_struct, perf_counter_pending));
+	DEFINE(PACAPERFNMI, offsetof(struct paca_struct, in_pmu_nmi));
 	DEFINE(PACACONTEXTID, offsetof(struct paca_struct, context.id));
 #ifdef CONFIG_PPC_MM_SLICES
 	DEFINE(PACALOWSLICESPSIZE, offsetof(struct paca_struct,
@@ -398,6 +399,7 @@ int main(void)
 	DEFINE(VCPU_TIMING_LAST_ENTER_TBL, offsetof(struct kvm_vcpu,
 					arch.timing_last_enter.tv32.tbl));
 #endif
+	DEFINE(SIGSEGV, SIGSEGV);
 
 	return 0;
 }
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index eb89811..02d96b0 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -722,6 +722,12 @@ _STATIC(do_hash_page)
 	std	r3,_DAR(r1)
 	std	r4,_DSISR(r1)
 
+#ifdef CONFIG_PERF_COUNTERS
+	lbz	r0,PACAPERFNMI(r13)
+	cmpwi	r0,0
+	bne	77f			/* if we don't want to hash_page now */
+#endif /* CONFIG_PERF_COUNTERS */
+
 	andis.	r0,r4,0xa450		/* weird error? */
 	bne-	handle_page_fault	/* if not, try to insert a HPTE */
 BEGIN_FTR_SECTION
@@ -833,6 +839,21 @@ handle_page_fault:
 	bl	.low_hash_fault
 	b	.ret_from_except
 
+#ifdef CONFIG_PERF_COUNTERS
+/*
+ * We come here as a result of a DSI when accessing memory (possibly
+ * user memory) inside a PMU interrupt that occurred while interrupts
+ * were soft-disabled, so we just want to invoke the exception handler
+ * for the access, or panic if there isn't a handler.
+ */
+77:	bl	.save_nvgprs
+	mr	r4,r3
+	addi	r3,r1,STACK_FRAME_OVERHEAD
+	li	r5,SIGSEGV
+	bl	.bad_page_fault
+	b	.ret_from_except
+#endif
+
 	/* here we have a segment miss */
 do_ste_alloc:
 	bl	.ste_allocate		/* try to insert stab entry */
diff --git a/arch/powerpc/mm/slb.c b/arch/powerpc/mm/slb.c
index 3b52c80..ebfb8df 100644
--- a/arch/powerpc/mm/slb.c
+++ b/arch/powerpc/mm/slb.c
@@ -187,12 +187,20 @@ static inline int esids_match(unsigned long addr1, unsigned long addr2)
 /* Flush all user entries from the segment table of the current processor. */
 void switch_slb(struct task_struct *tsk, struct mm_struct *mm)
 {
-	unsigned long offset = get_paca()->slb_cache_ptr;
+	unsigned long offset;
 	unsigned long slbie_data = 0;
 	unsigned long pc = KSTK_EIP(tsk);
 	unsigned long stack = KSTK_ESP(tsk);
 	unsigned long unmapped_base;
 
+	/*
+	 * We need interrupts hard-disabled here, not just soft-disabled,
+	 * so that a PMU interrupt can't occur, which might try to access
+	 * user memory (to get a stack trace) and possible cause an SLB miss
+	 * which would update the slb_cache/slb_cache_ptr fields in the PACA.
+	 */
+	hard_irq_disable();
+	offset = get_paca()->slb_cache_ptr;
 	if (!cpu_has_feature(CPU_FTR_NO_SLBIE_B) &&
 	    offset <= SLB_CACHE_ENTRIES) {
 		int i;
-- 
1.6.0.4


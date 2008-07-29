Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbYG2IHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbYG2IHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbYG2IFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:05:43 -0400
Received: from gw.goop.org ([64.81.55.164]:59710 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbYG2IFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:05:41 -0400
Message-ID: <488ECF51.2060704@goop.org>
Date: Tue, 29 Jul 2008 01:05:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] x86: bring tlb_32.c and _64.c into alignment
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring arch/x86/kernel/tlb_32.c and _64.c closer into alignment, so
that unification is more straightforward.  After this patch, the
remaining differences come down to UV support and the distinction
between percpu and pda variables.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/tlb_32.c |   39 +++++++++++++++++++--------------------
 arch/x86/kernel/tlb_64.c |   12 +++++++-----
 2 files changed, 26 insertions(+), 25 deletions(-)

===================================================================
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -1,7 +1,7 @@
-#include <linux/cpu.h>
+#include <linux/smp.h>
 #include <linux/interrupt.h>
-#include <linux/smp.h>
 #include <linux/percpu.h>
+#include <linux/module.h>
 
 #include <asm/tlbflush.h>
 
@@ -46,25 +46,25 @@
  * 1) switch_mm() either 1a) or 1b)
  * 1a) thread switch to a different mm
  * 1a1) cpu_clear(cpu, old_mm->cpu_vm_mask);
- * 	Stop ipi delivery for the old mm. This is not synchronized with
- * 	the other cpus, but smp_invalidate_interrupt ignore flush ipis
- * 	for the wrong mm, and in the worst case we perform a superfluous
- * 	tlb flush.
+ *	Stop ipi delivery for the old mm. This is not synchronized with
+ *	the other cpus, but tlb_invalidate() ignores flush ipis
+ *	for the wrong mm, and in the worst case we perform a superfluous
+ *	tlb flush.
  * 1a2) set cpu_tlbstate to TLBSTATE_OK
  * 	Now the smp_invalidate_interrupt won't call leave_mm if cpu0
  *	was in lazy tlb mode.
  * 1a3) update cpu_tlbstate[].active_mm
- * 	Now cpu0 accepts tlb flushes for the new mm.
+ *	Now cpu0 accepts tlb flushes for the new mm.
  * 1a4) cpu_set(cpu, new_mm->cpu_vm_mask);
- * 	Now the other cpus will send tlb flush ipis.
+ *	Now the other cpus will send tlb flush ipis.
  * 1a4) change cr3.
  * 1b) thread switch without mm change
  *	cpu_tlbstate[].active_mm is correct, cpu0 already handles
  *	flush ipis.
  * 1b1) set cpu_tlbstate to TLBSTATE_OK
  * 1b2) test_and_set the cpu bit in cpu_vm_mask.
- * 	Atomically set the bit [other cpus will start sending flush ipis],
- * 	and test the bit.
+ *	Atomically set the bit [other cpus will start sending flush ipis],
+ *	and test the bit.
  * 1b3) if the bit was 0: leave_mm was called, flush the tlb.
  * 2) switch %%esp, ie current
  *
@@ -83,26 +83,27 @@
  *
  * 1) Flush the tlb entries if the cpu uses the mm that's being flushed.
  * 2) Leave the mm if we are in the lazy tlb mode.
+ *
+ * Interrupts are disabled.
  */
 
 static void tlb_invalidate(void *arg)
 {
-	struct tlb_flush *flush = arg;
-	unsigned long cpu;
+	struct tlb_flush *f = arg;
+	int cpu;
 
-	cpu = get_cpu();
+	cpu = smp_processor_id();
 
-	if (flush->mm == per_cpu(cpu_tlbstate, cpu).active_mm) {
+	if (f->mm == per_cpu(cpu_tlbstate, cpu).active_mm) {
 		if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK) {
-			if (flush->va == TLB_FLUSH_ALL)
+			if (f->va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
-				__flush_tlb_one(flush->va);
+				__flush_tlb_one(f->va);
 		} else
 			leave_mm(cpu);
 	}
 
-	put_cpu_no_resched();
 	__get_cpu_var(irq_stat).irq_tlb_count++;
 }
 
@@ -164,7 +165,7 @@
 	if (current->active_mm == mm) {
 		if (current->mm)
 			__flush_tlb_one(va);
-		 else
+		else
 			leave_mm(smp_processor_id());
 	}
 
@@ -173,7 +174,6 @@
 
 	preempt_enable();
 }
-EXPORT_SYMBOL(flush_tlb_page);
 
 static void do_flush_tlb_all(void *info)
 {
@@ -188,4 +188,3 @@
 {
 	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
-
===================================================================
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -1,10 +1,8 @@
-#include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/kernel_stat.h>
+#include <linux/interrupt.h>
 #include <linux/module.h>
 
 #include <asm/tlbflush.h>
-#include <asm/mmu_context.h>
 
 /* For UV tlb flush */
 #include <asm/uv/uv_hub.h>
@@ -29,6 +27,9 @@
 /*
  * We cannot call mmdrop() because we are in interrupt context,
  * instead update mm->cpu_vm_mask.
+ *
+ * We need to reload %cr3 since the page tables may be going
+ * away from under us..
  */
 void leave_mm(int cpu)
 {
@@ -47,7 +48,7 @@
  * 1a) thread switch to a different mm
  * 1a1) cpu_clear(cpu, old_mm->cpu_vm_mask);
  *	Stop ipi delivery for the old mm. This is not synchronized with
- *	the other cpus, but smp_invalidate_interrupt ignore flush ipis
+ *	the other cpus, but tlb_invalidate() ignores flush ipis
  *	for the wrong mm, and in the worst case we perform a superfluous
  *	tlb flush.
  * 1a2) set cpu mmu_state to TLBSTATE_OK
@@ -103,6 +104,7 @@
 		} else
 			leave_mm(cpu);
 	}
+
 	add_pda(irq_tlb_count, 1);
 }
 
@@ -111,7 +113,7 @@
 {
 	struct tlb_flush flush = {
 		.mm = mm,
-		.va = va,
+		.va = va
 	};
 
 	if (is_uv_system() && uv_flush_tlb_others(cpumaskp, mm, va))



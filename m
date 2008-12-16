Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYLPLqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYLPLqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbYLPLqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:46:39 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:39937 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbYLPLqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:46:38 -0500
Message-Id: <4947A342.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 16 Dec 2008 11:46:58 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: improve lazy TLB handling code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the faster x86_{read,write}_percpu() accessors here.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/mmu_context_32.h |   13 ++++++-------
 arch/x86/kernel/tlb_32.c              |   11 +++++------
 2 files changed, 11 insertions(+), 13 deletions(-)

--- linux-2.6.28-rc8/arch/x86/include/asm/mmu_context_32.h	2008-12-11 14:36:51.000000000 +0100
+++ 2.6.28-rc8-i386-lazy-tlb/arch/x86/include/asm/mmu_context_32.h	2008-11-17 14:11:45.000000000 +0100
@@ -4,9 +4,8 @@
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 #ifdef CONFIG_SMP
-	unsigned cpu = smp_processor_id();
-	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK)
-		per_cpu(cpu_tlbstate, cpu).state = TLBSTATE_LAZY;
+	if (x86_read_percpu(cpu_tlbstate.state) == TLBSTATE_OK)
+		x86_write_percpu(cpu_tlbstate.state, TLBSTATE_LAZY);
 #endif
 }
 
@@ -20,8 +19,8 @@ static inline void switch_mm(struct mm_s
 		/* stop flush ipis for the previous mm */
 		cpu_clear(cpu, prev->cpu_vm_mask);
 #ifdef CONFIG_SMP
-		per_cpu(cpu_tlbstate, cpu).state = TLBSTATE_OK;
-		per_cpu(cpu_tlbstate, cpu).active_mm = next;
+		x86_write_percpu(cpu_tlbstate.state, TLBSTATE_OK);
+		x86_write_percpu(cpu_tlbstate.active_mm, next);
 #endif
 		cpu_set(cpu, next->cpu_vm_mask);
 
@@ -36,8 +35,8 @@ static inline void switch_mm(struct mm_s
 	}
 #ifdef CONFIG_SMP
 	else {
-		per_cpu(cpu_tlbstate, cpu).state = TLBSTATE_OK;
-		BUG_ON(per_cpu(cpu_tlbstate, cpu).active_mm != next);
+		x86_write_percpu(cpu_tlbstate.state, TLBSTATE_OK);
+		BUG_ON(x86_read_percpu(cpu_tlbstate.active_mm) != next);
 
 		if (!cpu_test_and_set(cpu, next->cpu_vm_mask)) {
 			/* We were in lazy tlb mode and leave_mm disabled
--- linux-2.6.28-rc8/arch/x86/kernel/tlb_32.c	2008-12-11 14:36:52.000000000 +0100
+++ 2.6.28-rc8-i386-lazy-tlb/arch/x86/kernel/tlb_32.c	2008-11-17 14:19:32.000000000 +0100
@@ -34,9 +34,8 @@ static DEFINE_SPINLOCK(tlbstate_lock);
  */
 void leave_mm(int cpu)
 {
-	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK)
-		BUG();
-	cpu_clear(cpu, per_cpu(cpu_tlbstate, cpu).active_mm->cpu_vm_mask);
+	BUG_ON(x86_read_percpu(cpu_tlbstate.state) == TLBSTATE_OK);
+	cpu_clear(cpu, x86_read_percpu(cpu_tlbstate.active_mm)->cpu_vm_mask);
 	load_cr3(swapper_pg_dir);
 }
 EXPORT_SYMBOL_GPL(leave_mm);
@@ -104,8 +103,8 @@ void smp_invalidate_interrupt(struct pt_
 		 * BUG();
 		 */
 
-	if (flush_mm == per_cpu(cpu_tlbstate, cpu).active_mm) {
-		if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK) {
+	if (flush_mm == x86_read_percpu(cpu_tlbstate.active_mm)) {
+		if (x86_read_percpu(cpu_tlbstate.state) == TLBSTATE_OK) {
 			if (flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
@@ -238,7 +237,7 @@ static void do_flush_tlb_all(void *info)
 	unsigned long cpu = smp_processor_id();
 
 	__flush_tlb_all();
-	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_LAZY)
+	if (x86_read_percpu(cpu_tlbstate.state) == TLBSTATE_LAZY)
 		leave_mm(cpu);
 }
 




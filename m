Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbYLPC2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbYLPC2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYLPCYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:24 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40564 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752028AbYLPCYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:14 -0500
Message-Id: <20081216022411.873756000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:24 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, jeremy@xensource.com
Subject: [PATCH 15/16] x86: xen: use smp_call_function_many()
Content-Disposition: inline; filename=0019-x86-xen-use-smp_call_function_many.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use new API, remove cpumask from stack.

Change smp_call_function_mask() callers to smp_call_function_many().

This removes a cpumask from the stack, and falls back should allocating
the cpumask var fail (only possible with CONFIG_CPUMASKS_OFFSTACK).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: jeremy@xensource.com
---
 arch/x86/xen/mmu.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 636ef4c..e59e53b 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1079,7 +1079,7 @@ static void drop_other_mm_ref(void *info)
 
 static void xen_drop_mm_ref(struct mm_struct *mm)
 {
-	cpumask_t mask;
+	cpumask_var_t mask;
 	unsigned cpu;
 
 	if (current->active_mm == mm) {
@@ -1091,7 +1091,16 @@ static void xen_drop_mm_ref(struct mm_struct *mm)
 	}
 
 	/* Get the "official" set of cpus referring to our pagetable. */
-	mask = mm->cpu_vm_mask;
+	if (!alloc_cpumask_var(&mask, GFP_ATOMIC)) {
+		for_each_online_cpu(cpu) {
+			if (!cpumask_test_cpu(cpu, &mm->cpu_vm_mask)
+			    && per_cpu(xen_current_cr3, cpu) != __pa(mm->pgd))
+				continue;
+			smp_call_function_single(cpu, drop_other_mm_ref, mm, 1);
+		}
+		return;
+	}
+	cpumask_copy(mask, &mm->cpu_vm_mask);
 
 	/* It's possible that a vcpu may have a stale reference to our
 	   cr3, because its in lazy mode, and it hasn't yet flushed
@@ -1100,11 +1109,12 @@ static void xen_drop_mm_ref(struct mm_struct *mm)
 	   if needed. */
 	for_each_online_cpu(cpu) {
 		if (per_cpu(xen_current_cr3, cpu) == __pa(mm->pgd))
-			cpu_set(cpu, mask);
+			cpumask_set_cpu(cpu, mask);
 	}
 
-	if (!cpus_empty(mask))
-		smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
+	if (!cpumask_empty(mask))
+		smp_call_function_many(mask, drop_other_mm_ref, mm, 1);
+	free_cpumask_var(mask);
 }
 #else
 static void xen_drop_mm_ref(struct mm_struct *mm)
-- 
1.6.0

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZCFFZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZCFFZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 00:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZCFFX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 00:23:59 -0500
Received: from ozlabs.org ([203.10.76.45]:35489 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZCFFX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 00:23:57 -0500
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 05 Mar 2009 17:27:23 +1030
Subject: [PATCH 4/10] use smp_call_function_single() in arch/x86/kernel/cpu/mcheck/mce_amd_64.c
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20090306052352.E2B23DDF48@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Attempting to rid us of the problematic work_on_cpu().  Just use
smp_call_function_single() here.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |   40 +++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/mce_amd_64.c~arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu arch/x86/kernel/cpu/mcheck/mce_amd_64.c
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c~arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu
+++ a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -90,7 +90,8 @@ struct thresh_restart {
 };
 
 /* must be called with correct cpu affinity */
-static long threshold_restart_bank(void *_tr)
+/* Called via smp_call_function_single() */
+static void threshold_restart_bank(void *_tr)
 {
 	struct thresh_restart *tr = _tr;
 	u32 mci_misc_hi, mci_misc_lo;
@@ -117,7 +118,6 @@ static long threshold_restart_bank(void 
 
 	mci_misc_hi |= MASK_COUNT_EN_HI;
 	wrmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
-	return 0;
 }
 
 /* cpu init entry point, called from mce.c with preempt off */
@@ -283,7 +283,7 @@ static ssize_t store_interrupt_enable(st
 	tr.b = b;
 	tr.reset = 0;
 	tr.old_limit = 0;
-	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
+	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
 
 	return end - buf;
 }
@@ -305,23 +305,32 @@ static ssize_t store_threshold_limit(str
 	tr.b = b;
 	tr.reset = 0;
 
-	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
+	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
 
 	return end - buf;
 }
 
-static long local_error_count(void *_b)
+struct threshold_block_cross_cpu {
+	struct threshold_block *tb;
+	long retval;
+};
+
+static void local_error_count_handler(void *_tbcc)
 {
-	struct threshold_block *b = _b;
+	struct threshold_block_cross_cpu *tbcc = _tbcc;
+	struct threshold_block *b = tbcc->tb;
 	u32 low, high;
 
 	rdmsr(b->address, low, high);
-	return (high & 0xFFF) - (THRESHOLD_MAX - b->threshold_limit);
+	tbcc->retval = (high & 0xFFF) - (THRESHOLD_MAX - b->threshold_limit);
 }
 
 static ssize_t show_error_count(struct threshold_block *b, char *buf)
 {
-	return sprintf(buf, "%lx\n", work_on_cpu(b->cpu, local_error_count, b));
+	struct threshold_block_cross_cpu tbcc = { .tb = b, };
+
+	smp_call_function_single(b->cpu, local_error_count_handler, &tbcc, 1);
+	return sprintf(buf, "%lx\n", tbcc.retval);
 }
 
 static ssize_t store_error_count(struct threshold_block *b,
@@ -329,7 +338,7 @@ static ssize_t store_error_count(struct 
 {
 	struct thresh_restart tr = { .b = b, .reset = 1, .old_limit = 0 };
 
-	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
+	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
 	return 1;
 }
 
@@ -398,7 +407,7 @@ static __cpuinit int allocate_threshold_
 	if ((bank >= NR_BANKS) || (block >= NR_BLOCKS))
 		return 0;
 
-	if (rdmsr_safe(address, &low, &high))
+	if (rdmsr_safe_on_cpu(cpu, address, &low, &high))
 		return 0;
 
 	if (!(high & MASK_VALID_HI)) {
@@ -462,12 +471,11 @@ out_free:
 	return err;
 }
 
-static __cpuinit long local_allocate_threshold_blocks(void *_bank)
+static __cpuinit long
+local_allocate_threshold_blocks(int cpu, unsigned int bank)
 {
-	unsigned int *bank = _bank;
-
-	return allocate_threshold_blocks(smp_processor_id(), *bank, 0,
-					 MSR_IA32_MC0_MISC + *bank * 4);
+	return allocate_threshold_blocks(cpu, bank, 0,
+					 MSR_IA32_MC0_MISC + bank * 4);
 }
 
 /* symlinks sibling shared banks to first core.  first core owns dir/files. */
@@ -525,7 +533,7 @@ static __cpuinit int threshold_create_ba
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
-	err = work_on_cpu(cpu, local_allocate_threshold_blocks, &bank);
+	err = local_allocate_threshold_blocks(cpu, bank);
 	if (err)
 		goto out_free;
 
_


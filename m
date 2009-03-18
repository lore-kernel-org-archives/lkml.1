Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbZCRGxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbZCRGxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 02:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbZCRGxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 02:53:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:47432 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbZCRGxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 02:53:34 -0400
Date: Wed, 18 Mar 2009 06:52:16 GMT
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090318042217.EF3F1DDF39@ozlabs.org>
References: <20090318042217.EF3F1DDF39@ozlabs.org>
Subject: [tip:x86/mce2] x86: use smp_call_function_single() in arch/x86/kernel/cpu/mcheck/mce_amd_64.c
Message-ID: <tip-a6b6a14e0c60561f2902b078bd28d0e61defad70@git.kernel.org>
Git-Commit-ID: a6b6a14e0c60561f2902b078bd28d0e61defad70
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 06:52:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6b6a14e0c60561f2902b078bd28d0e61defad70
Gitweb:     http://git.kernel.org/tip/a6b6a14e0c60561f2902b078bd28d0e61defad70
Author:     Andrew Morton <akpm@linux-foundation.org>
AuthorDate: Wed, 18 Mar 2009 10:40:25 +1030
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 07:03:12 +0100

x86: use smp_call_function_single() in arch/x86/kernel/cpu/mcheck/mce_amd_64.c

Attempting to rid us of the problematic work_on_cpu().  Just use
smp_call_function_single() here.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <20090318042217.EF3F1DDF39@ozlabs.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |   40 ++++++++++++++++++------------
 1 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index c5a32f9..7d01be8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -92,7 +92,8 @@ struct thresh_restart {
 };
 
 /* must be called with correct cpu affinity */
-static long threshold_restart_bank(void *_tr)
+/* Called via smp_call_function_single() */
+static void threshold_restart_bank(void *_tr)
 {
 	struct thresh_restart *tr = _tr;
 	u32 mci_misc_hi, mci_misc_lo;
@@ -119,7 +120,6 @@ static long threshold_restart_bank(void *_tr)
 
 	mci_misc_hi |= MASK_COUNT_EN_HI;
 	wrmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
-	return 0;
 }
 
 /* cpu init entry point, called from mce.c with preempt off */
@@ -279,7 +279,7 @@ static ssize_t store_interrupt_enable(struct threshold_block *b,
 	tr.b = b;
 	tr.reset = 0;
 	tr.old_limit = 0;
-	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
+	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
 
 	return end - buf;
 }
@@ -301,23 +301,32 @@ static ssize_t store_threshold_limit(struct threshold_block *b,
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
@@ -325,7 +334,7 @@ static ssize_t store_error_count(struct threshold_block *b,
 {
 	struct thresh_restart tr = { .b = b, .reset = 1, .old_limit = 0 };
 
-	work_on_cpu(b->cpu, threshold_restart_bank, &tr);
+	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
 	return 1;
 }
 
@@ -394,7 +403,7 @@ static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
 	if ((bank >= NR_BANKS) || (block >= NR_BLOCKS))
 		return 0;
 
-	if (rdmsr_safe(address, &low, &high))
+	if (rdmsr_safe_on_cpu(cpu, address, &low, &high))
 		return 0;
 
 	if (!(high & MASK_VALID_HI)) {
@@ -458,12 +467,11 @@ out_free:
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
@@ -526,7 +534,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
-	err = work_on_cpu(cpu, local_allocate_threshold_blocks, &bank);
+	err = local_allocate_threshold_blocks(cpu, bank);
 	if (err)
 		goto out_free;
 

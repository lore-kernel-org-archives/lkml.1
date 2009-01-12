Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbZALVgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbZALVgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbZALVfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:35:48 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64973 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454AbZALVfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:35:47 -0500
Date: Mon, 12 Jan 2009 22:35:42 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: mingo@elte.hu
Cc: andi@firstfloor.org, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090112213539.GA10720@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On x86_64 flush tlb data is stored in per_cpu variables. This is
unnecessary because only the first NUM_INVALIDATE_TLB_VECTORS entries
are accessed.
This patch aims at making the code less confusing (there's nothing
really "per_cpu") by using a plain array. It also would save some memory
on most distros out there (Ubuntu x86_64 has NR_CPUS=64 by default).

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>

diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index f8be6f1..c177a1f 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -33,7 +33,7 @@
  *	To avoid global state use 8 different call vectors.
  *	Each CPU uses a specific vector to trigger flushes on other
  *	CPUs. Depending on the received vector the target CPUs look into
- *	the right per cpu variable for the flush data.
+ *	the right array slot for the flush data.
  *
  *	With more than 8 CPUs they are hashed to the 8 available
  *	vectors. The limited global vector space forces us to this right now.
@@ -54,7 +54,7 @@ union smp_flush_state {
 /* State is put into the per CPU data section, but padded
    to a full cache line because other CPUs can access it and we don't
    want false sharing in the per cpu data segment. */
-static DEFINE_PER_CPU(union smp_flush_state, flush_state);
+static union smp_flush_state flush_state[NUM_INVALIDATE_TLB_VECTORS];
 
 /*
  * We cannot call mmdrop() because we are in interrupt context,
@@ -129,7 +129,7 @@ asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
 	 * Use that to determine where the sender put the data.
 	 */
 	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
-	f = &per_cpu(flush_state, sender);
+	f = &flush_state[sender];
 
 	if (!cpu_isset(cpu, f->flush_cpumask))
 		goto out;
@@ -169,7 +169,7 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 
 	/* Caller has disabled preemption */
 	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
-	f = &per_cpu(flush_state, sender);
+	f = &flush_state[sender];
 
 	/*
 	 * Could avoid this lock when
@@ -205,8 +205,8 @@ static int __cpuinit init_smp_flush(void)
 {
 	int i;
 
-	for_each_possible_cpu(i)
-		spin_lock_init(&per_cpu(flush_state, i).tlbstate_lock);
+	for (i = 0; i < ARRAY_SIZE(flush_state); i++)
+		spin_lock_init(&flush_state[i].tlbstate_lock);
 
 	return 0;
 }

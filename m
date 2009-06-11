Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbZFKTW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbZFKTW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbZFKTUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:20:51 -0400
Received: from claw.goop.org ([74.207.240.146]:44181 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682AbZFKTUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:20:46 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Alok Kataria <akataria@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/5] x86-32: make sure clts is batched during context switch
Date: Thu, 11 Jun 2009 12:20:38 -0700
Message-Id: <1244748040-27185-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1244748040-27185-1-git-send-email-jeremy@goop.org>
References: <1244748040-27185-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If we're preloading the fpu state during context switch, make sure the clts
happens while we're batching the cpu context update, then do the actual
__math_state_restore once the updates are flushed.

This allows more efficient context switches when running paravirtualized,
as all the hypercalls can be folded together into one.

[ Impact: optimise paravirtual FPU context switch ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Alok Kataria <akataria@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/process_32.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 00a8fe4..57ea7a7 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -361,14 +361,21 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 				 *next = &next_p->thread;
 	int cpu = smp_processor_id();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
+	bool preload_fpu;
 
 	/* never put a printk in __switch_to... printk() calls wake_up*() indirectly */
 
-	__unlazy_fpu(prev_p);
+	/*
+	 * If the task has used fpu the last 5 timeslices, just do a full
+	 * restore of the math state immediately to avoid the trap; the
+	 * chances of needing FPU soon are obviously high now
+	 */
+	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5;
 
+	__unlazy_fpu(prev_p);
 
 	/* we're going to use this soon, after a few expensive things */
-	if (next_p->fpu_counter > 5)
+	if (preload_fpu)
 		prefetch(next->xstate);
 
 	/*
@@ -409,6 +416,11 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
 		__switch_to_xtra(prev_p, next_p, tss);
 
+	/* If we're going to preload the fpu context, make sure clts
+	   is run while we're batching the cpu state updates. */
+	if (preload_fpu)
+		clts();
+
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
 	 * This must be done before restoring TLS segments so
@@ -418,15 +430,8 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	arch_end_context_switch(next_p);
 
-	/* If the task has used fpu the last 5 timeslices, just do a full
-	 * restore of the math state immediately to avoid the trap; the
-	 * chances of needing FPU soon are obviously high now
-	 *
-	 * tsk_used_math() checks prevent calling math_state_restore(),
-	 * which can sleep in the case of !tsk_used_math()
-	 */
-	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
-		math_state_restore();
+	if (preload_fpu)
+		__math_state_restore();
 
 	/*
 	 * Restore %gs if needed (which is common)
-- 
1.6.2.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760481AbZFKTWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481AbZFKTWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbZFKTUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:20:50 -0400
Received: from claw.goop.org ([74.207.240.146]:44171 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbZFKTUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:20:46 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Alok Kataria <akataria@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 5/5] x86-64: move clts into batch cpu state updates when preloading fpu
Date: Thu, 11 Jun 2009 12:20:40 -0700
Message-Id: <1244748040-27185-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1244748040-27185-1-git-send-email-jeremy@goop.org>
References: <1244748040-27185-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

When a task is likely to be using the fpu, we preload its state during
the context switch, rather than waiting for it to run an fpu instruction.
Make sure the clts() happens while we're doing batched fpu state updates
to optimise paravirtualized context switches.

[ Impact: optimise paravirtual FPU context switch ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Alok Kataria <akataria@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/process_64.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6ed1c57..79463ab 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -399,9 +399,17 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	int cpu = smp_processor_id();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
 	unsigned fsindex, gsindex;
+	bool preload_fpu;
+
+	/*
+	 * If the task has used fpu the last 5 timeslices, just do a full
+	 * restore of the math state immediately to avoid the trap; the
+	 * chances of needing FPU soon are obviously high now
+	 */
+	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5;
 
 	/* we're going to use this soon, after a few expensive things */
-	if (next_p->fpu_counter > 5)
+	if (preload_fpu)
 		prefetch(next->xstate);
 
 	/*
@@ -435,6 +443,10 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/* Must be after DS reload */
 	unlazy_fpu(prev_p);
 
+	/* Make sure cpu is ready for new context */
+	if (preload_fpu)
+		clts();
+
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
 	 * This must be done before restoring TLS segments so
@@ -493,15 +505,12 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		     task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV))
 		__switch_to_xtra(prev_p, next_p, tss);
 
-	/* If the task has used fpu the last 5 timeslices, just do a full
-	 * restore of the math state immediately to avoid the trap; the
-	 * chances of needing FPU soon are obviously high now
-	 *
-	 * tsk_used_math() checks prevent calling math_state_restore(),
-	 * which can sleep in the case of !tsk_used_math()
+	/*
+	 * Preload the FPU context, now that we've determined that the
+	 * task is likely to be using it. 
 	 */
-	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
-		math_state_restore();
+	if (preload_fpu)
+		__math_state_restore();
 	/*
 	 * There's a problem with moving the arch_install_thread_hw_breakpoint()
 	 * call before current is updated.  Suppose a kernel breakpoint is
-- 
1.6.2.2


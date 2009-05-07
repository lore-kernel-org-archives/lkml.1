Return-Path: <linux-kernel-owner+w=401wt.eu-S1761807AbZEHAe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761807AbZEHAe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759805AbZEHAK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:59 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52703
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754928AbZEHAJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:57 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 5/5] x86-64: move clts into batch cpu state updates when preloading fpu
Date: Thu,  7 May 2009 13:32:53 -0700
Message-Id: <1241728373-3537-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241728373-3537-1-git-send-email-jeremy@goop.org>
References: <1241728373-3537-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

When a task is likely to be using the fpu, we preload its state during
the context switch, rather than waiting for it to run an fpu instruction.
Make sure the clts() happens while we're doing batched fpu state updates
to optimise paravirtualized context switches.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/process_64.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 534859b..45c5eb8 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -389,9 +389,17 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
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
@@ -425,6 +433,10 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/* Must be after DS reload */
 	unlazy_fpu(prev_p);
 
+	/* Make sure cpu is ready for new context */
+	if (preload_fpu)
+		clts();
+
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
 	 * This must be done before restoring TLS segments so
@@ -483,15 +495,13 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
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
+
 	return prev_p;
 }
 
-- 
1.6.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbYGPXEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbYGPXEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758193AbYGPXDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:03:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757600AbYGPXDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:03:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 1/4] x86 ptrace: block-step fix
In-Reply-To: Roland McGrath's message of  Wednesday, 16 July 2008 16:02:17 -0700 <20080716230217.3C25715410D@magilla.localdomain>
References: <20080716230217.3C25715410D@magilla.localdomain>
X-Shopping-List: (1) Anomalous expectorants
   (2) Simultaneous scorpions
   (3) Prenatal Sand
   (4) Deviant hamster-lip companions
   (5) Incautious accordions
Message-Id: <20080716230316.9A24015410D@magilla.localdomain>
Date: Wed, 16 Jul 2008 16:03:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The enable_single_step() logic bails out early if TF is already set.
That skips some of the bookkeeping that keeps things straight.
This makes PTRACE_SINGLEBLOCK break the behavior of a user task
that was already setting TF itself in user mode.

Fix the bookkeeping to notice the old TF setting as it should.

Test case at: http://sources.redhat.com/cgi-bin/cvsweb.cgi/~checkout~/tests/ptrace-tests/tests/step-jump-cont-strict.c?cvsroot=systemtap

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/step.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 92c20fe..0d2cb36 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -105,6 +105,7 @@ static int is_setting_trap_flag(struct task_struct *child, struct pt_regs *regs)
 static int enable_single_step(struct task_struct *child)
 {
 	struct pt_regs *regs = task_pt_regs(child);
+	unsigned long oflags;
 
 	/*
 	 * Always set TIF_SINGLESTEP - this guarantees that
@@ -113,11 +114,7 @@ static int enable_single_step(struct task_struct *child)
 	 */
 	set_tsk_thread_flag(child, TIF_SINGLESTEP);
 
-	/*
-	 * If TF was already set, don't do anything else
-	 */
-	if (regs->flags & X86_EFLAGS_TF)
-		return 0;
+	oflags = regs->flags;
 
 	/* Set TF on the kernel stack.. */
 	regs->flags |= X86_EFLAGS_TF;
@@ -126,9 +123,22 @@ static int enable_single_step(struct task_struct *child)
 	 * ..but if TF is changed by the instruction we will trace,
 	 * don't mark it as being "us" that set it, so that we
 	 * won't clear it by hand later.
+	 *
+	 * Note that if we don't actually execute the popf because
+	 * of a signal arriving right now or suchlike, we will lose
+	 * track of the fact that it really was "us" that set it.
 	 */
-	if (is_setting_trap_flag(child, regs))
+	if (is_setting_trap_flag(child, regs)) {
+		clear_tsk_thread_flag(child, TIF_FORCED_TF);
 		return 0;
+	}
+
+	/*
+	 * If TF was already set, check whether it was us who set it.
+	 * If not, we should never attempt a block step.
+	 */
+	if (oflags & X86_EFLAGS_TF)
+		return test_tsk_thread_flag(child, TIF_FORCED_TF);
 
 	set_tsk_thread_flag(child, TIF_FORCED_TF);
 

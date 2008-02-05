Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbYBEABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbYBEABU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbYBEABF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:01:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988AbYBEAA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:00:56 -0500
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86 ptrace: disallow null cs/ss
X-Fcc: ~/Mail/linus
X-Windows: power tools for power losers.
Message-Id: <20080205000053.997342701A8@magilla.localdomain>
Date: Mon,  4 Feb 2008 16:00:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In my revamp of the x86 ptrace code for setting register values,
I accidentally omitted a check that was there in the old code.
Allowing %cs to be 0 causes a bad crash in recovery from iret failure.
This patch fixes that regression against 2.6.24, and adds a comment
that should help prevent this subtlety from being overlooked again.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 96286df..702c33e 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -103,9 +103,26 @@ static int set_segment_reg(struct task_struct *task,
 	if (invalid_selector(value))
 		return -EIO;
 
-	if (offset != offsetof(struct user_regs_struct, gs))
+	/*
+	 * For %cs and %ss we cannot permit a null selector.
+	 * We can permit a bogus selector as long as it has USER_RPL.
+	 * Null selectors are fine for other segment registers, but
+	 * we will never get back to user mode with invalid %cs or %ss
+	 * and will take the trap in iret instead.  Much code relies
+	 * on user_mode() to distinguish a user trap frame (which can
+	 * safely use invalid selectors) from a kernel trap frame.
+	 */
+	switch (offset) {
+	case offsetof(struct user_regs_struct, cs):
+	case offsetof(struct user_regs_struct, ss):
+		if (unlikely(value == 0))
+			return -EIO;
+
+	default:
 		*pt_regs_access(task_pt_regs(task), offset) = value;
-	else {
+		break;
+
+	case offsetof(struct user_regs_struct, gs):
 		task->thread.gs = value;
 		if (task == current)
 			/*
@@ -227,12 +244,16 @@ static int set_segment_reg(struct task_struct *task,
 		 * Can't actually change these in 64-bit mode.
 		 */
 	case offsetof(struct user_regs_struct,cs):
+		if (unlikely(value == 0))
+			return -EIO;
 #ifdef CONFIG_IA32_EMULATION
 		if (test_tsk_thread_flag(task, TIF_IA32))
 			task_pt_regs(task)->cs = value;
 #endif
 		break;
 	case offsetof(struct user_regs_struct,ss):
+		if (unlikely(value == 0))
+			return -EIO;
 #ifdef CONFIG_IA32_EMULATION
 		if (test_tsk_thread_flag(task, TIF_IA32))
 			task_pt_regs(task)->ss = value;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763537AbYCGW5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763537AbYCGW5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 17:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYCGW44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 17:56:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760995AbYCGW4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 17:56:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64 ptrace orig_ax on ia32 task
In-Reply-To: Roland McGrath's message of  Thursday, 28 February 2008 19:57:07 -0800 <20080229035707.EAE862700FD@magilla.localdomain>
X-Fcc: ~/Mail/linus
References: <20080229035707.EAE862700FD@magilla.localdomain>
Emacs: more than just a Lisp interpreter, a text editor as well!
Message-Id: <20080307225602.6491B26F990@magilla.localdomain>
Date: Fri,  7 Mar 2008 14:56:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This makes 64-bit ptrace calls setting the 64-bit orig_ax field
for a 32-bit task sign-extend the low 32 bits up to 64.  This
matches what a 64-bit debugger expects when tracing a 32-bit task.

This follows on my "x86_64 ia32 syscall restart fix".
This didn't matter until that was fixed.

The debugger ignores or zeros the high half of every register slot it
sets (including the orig_rax pseudo-register) uniformly.  It expects
that the setting of the low 32 bits always has the same meaning as a
32-bit debugger setting those same 32 bits with native 32-bit
facilities.

This never arose before because the syscall restart check never
matched any -ERESTART* values due to lack of sign extension.  Before
that fix, even 32-bit ptrace setting orig_eax to -1 failed to trigger
the restart check anyway.  So this was never noticed as a regression
of 64-bit debuggers vs 32-bit debuggers on the same 64-bit kernel.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index f8eed1b..92b44e1 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -322,6 +322,20 @@ static int putreg(struct task_struct *child,
 	case offsetof(struct user_regs_struct, flags):
 		return set_flags(child, value);
 
+#ifdef CONFIG_IA32_EMULATION
+	case offsetof(struct user_regs_struct, orig_ax):
+		/*
+		 * For a 32-bit task, setting only the low 32 bits and
+		 * leaving the high bits untouched (all 0) has the same
+		 * effect as setting those bits via 32-bit ptrace would.
+		 * This means sign-extending an orig_eax of -1, which
+		 * here is an orig_rax of (u32)-1.
+		 */
+		if (test_tsk_thread_flag(child, TIF_IA32))
+			value = (long) (s32) value;
+		break;
+#endif
+
 #ifdef CONFIG_X86_64
 	case offsetof(struct user_regs_struct,fs_base):
 		if (value >= TASK_SIZE_OF(child))

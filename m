Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbXKYWCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbXKYWCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758102AbXKYWBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:01:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758097AbXKYWBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:01:43 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 10/27] ptrace: generic resume
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Windows: flawed beyond belief.
Message-Id: <20071125220109.10BC726F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:01:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This makes ptrace_request handle all the ptrace requests that wake
up the traced task.  These do low-level ptrace implementation magic
that is not arch-specific and should be kept out of arch code.  The
implementations on each arch usually do the same thing.  The new
generic code makes use of the arch_has_single_step macro and generic
entry points to handle PTRACE_SINGLESTEP.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/ptrace.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 7c76f2f..309796a 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -366,6 +366,50 @@ static int ptrace_setsiginfo(struct task_struct *child, siginfo_t __user * data)
 	return error;
 }
 
+
+#ifdef PTRACE_SINGLESTEP
+#define is_singlestep(request)		((request) == PTRACE_SINGLESTEP)
+#else
+#define is_singlestep(request)		0
+#endif
+
+#ifdef PTRACE_SYSEMU
+#define is_sysemu_singlestep(request)	((request) == PTRACE_SYSEMU_SINGLESTEP)
+#else
+#define is_sysemu_singlestep(request)	0
+#endif
+
+static int ptrace_resume(struct task_struct *child, long request, long data)
+{
+	if (!valid_signal(data))
+		return -EIO;
+
+	if (request == PTRACE_SYSCALL)
+		set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+	else
+		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+
+#ifdef TIF_SYSCALL_EMU
+	if (request == PTRACE_SYSEMU || request == PTRACE_SYSEMU_SINGLESTEP)
+		set_tsk_thread_flag(child, TIF_SYSCALL_EMU);
+	else
+		clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
+#endif
+
+	if (is_singlestep(request) || is_sysemu_singlestep(request)) {
+		if (unlikely(!arch_has_single_step()))
+			return -EIO;
+		user_enable_single_step(child);
+	}
+	else
+		user_disable_single_step(child);
+
+	child->exit_code = data;
+	wake_up_process(child);
+
+	return 0;
+}
+
 int ptrace_request(struct task_struct *child, long request,
 		   long addr, long data)
 {
@@ -390,6 +434,23 @@ int ptrace_request(struct task_struct *child, long request,
 	case PTRACE_DETACH:	 /* detach a process that was attached. */
 		ret = ptrace_detach(child, data);
 		break;
+
+#ifdef PTRACE_SINGLESTEP
+	case PTRACE_SINGLESTEP:
+#endif
+#ifdef PTRACE_SYSEMU
+	case PTRACE_SYSEMU:
+	case PTRACE_SYSEMU_SINGLESTEP:
+#endif
+	case PTRACE_SYSCALL:
+	case PTRACE_CONT:
+		return ptrace_resume(child, request, data);
+
+	case PTRACE_KILL:
+		if (child->exit_state)	/* already dead */
+			return 0;
+		return ptrace_resume(child, request, SIGKILL);
+
 	default:
 		break;
 	}

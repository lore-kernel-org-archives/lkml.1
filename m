Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbXIEKGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbXIEKGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 06:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbXIEKGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 06:06:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018AbXIEKGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 06:06:35 -0400
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jan.kratochvil@redhat.com
Subject: [PATCH] Fix spurious syscall tracing after PTRACE_DETACH + PTRACE_ATTACH
X-Fcc: ~/Mail/linus
X-Windows: the joke that kills.
Message-Id: <20070905100556.703BE4D04D3@magilla.localdomain>
Date: Wed,  5 Sep 2007 03:05:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a test case in https://bugzilla.redhat.com/show_bug.cgi?id=276861
to demonstrate this bug.


Thanks,
Roland

---

When PTRACE_SYSCALL was used and then PTRACE_DETACH is used, the
TIF_SYSCALL_TRACE flag is left set on the formerly-traced task.
This means that when a new tracer comes along and does
PTRACE_ATTACH, it's possible he gets a syscall tracing stop even
though he's never used PTRACE_SYSCALL.  This happens if the task was
in the middle of a system call when the second PTRACE_ATTACH was
done.  The symptom is an unexpected SIGTRAP when the tracer thinks
that only SIGSTOP should have been provoked by his ptrace calls so far.

A few machines already fixed this in ptrace_disable (i386, ia64, m68k).
But all other machines do not, and still have this bug.  On x86_64, this
constitutes a regression in IA32 compatibility support.

Since all machines now use TIF_SYSCALL_TRACE for this, I put the
clearing of TIF_SYSCALL_TRACE in the generic ptrace_detach code rather
than adding it to every other machine's ptrace_disable.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/i386/kernel/ptrace.c |    1 -
 arch/ia64/kernel/ptrace.c |    1 -
 arch/m68k/kernel/ptrace.c |    1 -
 kernel/ptrace.c           |    1 +
 4 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/i386/kernel/ptrace.c b/arch/i386/kernel/ptrace.c
index 0c8f00e..7c1b925 100644
--- a/arch/i386/kernel/ptrace.c
+++ b/arch/i386/kernel/ptrace.c
@@ -274,7 +274,6 @@ static void clear_singlestep(struct task_struct *child)
 void ptrace_disable(struct task_struct *child)
 { 
 	clear_singlestep(child);
-	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 }
 
diff --git a/arch/ia64/kernel/ptrace.c b/arch/ia64/kernel/ptrace.c
index 122444a..2e96f17 100644
--- a/arch/ia64/kernel/ptrace.c
+++ b/arch/ia64/kernel/ptrace.c
@@ -1577,7 +1577,6 @@ sys_ptrace (long request, pid_t pid, unsigned long addr, unsigned long data)
 
 	      case PTRACE_DETACH:
 		/* detach a process that was attached. */
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 		ret = ptrace_detach(child, data);
 		goto out_tsk;
 
diff --git a/arch/m68k/kernel/ptrace.c b/arch/m68k/kernel/ptrace.c
index 2cf0690..e792d3c 100644
--- a/arch/m68k/kernel/ptrace.c
+++ b/arch/m68k/kernel/ptrace.c
@@ -116,7 +116,6 @@ static inline void singlestep_disable(struct task_struct *child)
 void ptrace_disable(struct task_struct *child)
 {
 	singlestep_disable(child);
-	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 }
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 82a558b..3eca7a5 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -233,6 +233,7 @@ int ptrace_detach(struct task_struct *child, unsigned int data)
 
 	/* Architecture-specific hardware disable .. */
 	ptrace_disable(child);
+	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 
 	write_lock_irq(&tasklist_lock);
 	/* protect against de_thread()->release_task() */

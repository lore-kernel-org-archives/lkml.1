Return-Path: <linux-kernel-owner+w=401wt.eu-S1751151AbZIWEDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbZIWEDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 00:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbZIWEDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 00:03:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZIWEDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 00:03:20 -0400
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] x86: ptrace: sysret path should reach syscall_trace_leave
X-Fcc: ~/Mail/linus
Emacs: ballast for RAM.
Message-Id: <20090923040211.7733314093@magilla.sf.frob.com>
Date: Tue, 22 Sep 2009 21:02:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7fa07729e439a6184bd824746d06a49cca553f15:
  Linus Torvalds (1):
        Merge branch 'perf-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git x86/ptrace-syscall-exit

Roland McGrath (1):
      x86: ptrace: sysret path should reach syscall_trace_leave

 arch/x86/kernel/entry_64.S |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)
---
[PATCH] x86: ptrace: sysret path should reach syscall_trace_leave

If TIF_SYSCALL_TRACE or TIF_SINGLESTEP is set while inside a syscall,
the path back to user mode should get to syscall_trace_leave.

This does happen in most circumstances.  The exception to this is on
the 64-bit syscall fastpath, when no such flag was set on syscall
entry and nothing else has punted it off the fastpath for exit.  That
one exit fastpath fails to check for _TIF_WORK_SYSCALL_EXIT flags.
This makes the behavior inconsistent with what 32-bit tasks see and
what the native 32-bit kernel always does, and what 64-bit tasks see
in all cases where the iret path is taken anyhow.

Perhaps the only example that is affected is a ptrace stop inside
do_fork (for PTRACE_O_TRACE{CLONE,FORK,VFORK,VFORKDONE}).  Other
syscalls with internal ptrace stop points (execve) already take the
iret exit path for unrelated reasons.

Test cases for both PTRACE_SYSCALL and PTRACE_SINGLESTEP variants are at:
http://sources.redhat.com/cgi-bin/cvsweb.cgi/~checkout~/tests/ptrace-tests/tests/syscall-from-clone.c?cvsroot=systemtap
http://sources.redhat.com/cgi-bin/cvsweb.cgi/~checkout~/tests/ptrace-tests/tests/step-from-clone.c?cvsroot=systemtap

There was no special benefit to the sysret path's special path to call
do_notify_resume, because it always takes the iret exit path at the end.
So this change just makes the sysret exit path join the iret exit path
for all the signals and ptrace cases.  The fastpath still applies to
the plain syscall-audit and resched cases.

Signed-off-by: Roland McGrath <roland@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/entry_64.S |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 681c3fd..b5c061f 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -536,20 +536,13 @@ sysret_signal:
 	bt $TIF_SYSCALL_AUDIT,%edx
 	jc sysret_audit
 #endif
-	/* edx:	work flags (arg3) */
-	leaq -ARGOFFSET(%rsp),%rdi # &pt_regs -> arg1
-	xorl %esi,%esi # oldset -> arg2
-	SAVE_REST
-	FIXUP_TOP_OF_STACK %r11
-	call do_notify_resume
-	RESTORE_TOP_OF_STACK %r11
-	RESTORE_REST
-	movl $_TIF_WORK_MASK,%edi
-	/* Use IRET because user could have changed frame. This
-	   works because ptregscall_common has called FIXUP_TOP_OF_STACK. */
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	TRACE_IRQS_OFF
-	jmp int_with_check
+	/*
+	 * We have a signal, or exit tracing or single-step.
+	 * These all wind up with the iret return path anyway,
+	 * so just join that path right now.
+	 */
+	FIXUP_TOP_OF_STACK %r11, -ARGOFFSET
+	jmp int_check_syscall_exit_work
 
 badsys:
 	movq $-ENOSYS,RAX-ARGOFFSET(%rsp)
@@ -654,6 +647,7 @@ int_careful:
 int_very_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
+int_check_syscall_exit_work:
 	SAVE_REST
 	/* Check for syscall exit trace */
 	testl $_TIF_WORK_SYSCALL_EXIT,%edx

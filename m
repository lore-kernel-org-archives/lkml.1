Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZIWAu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZIWAu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbZIWAu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:50:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZIWAu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:50:26 -0400
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: jan.kratochvil@redhat.com, Oleg Nesterov <oleg@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] x86: ptrace: sign-extend eax with orig_eax>=0
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090923004651.2D99513F37@magilla.sf.frob.com>
Date: Tue, 22 Sep 2009 17:46:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32-bit ptrace syscall on a 64-bit kernel (32-bit debugger on
32-bit task) behaves differently than a native 32-bit kernel.  When
setting a register state of orig_eax>=0 and eax=-ERESTART* when the
debugged task is NOT on its way out of a 32-bit syscall, the task will
fail to do the syscall restart logic that it should do.

Test case available at http://sources.redhat.com/cgi-bin/cvsweb.cgi/~checkout~/tests/ptrace-tests/tests/erestartsys-trap.c?cvsroot=systemtap

This happens because the 32-bit ptrace syscall sets eax=0xffffffff
when it sets orig_eax>=0.  The resuming task will not sign-extend this
for the -ERESTART* check because TS_COMPAT is not set.  (So the task
thinks it is restarting after a 64-bit syscall, not a 32-bit one.)

The fix is to have 32-bit ptrace calls sign-extend eax when orig_eax>=0.
The long comment in the change explains the scenarios and caveats fully.

Reported-by: Jan.Kratochvil@redhat.com
Signed-off-by: Roland McGrath <roland@redhat.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/ptrace.c |   55 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 8d7d5c9..ecb7a49 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1120,7 +1120,6 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 value)
 	R32(edi, di);
 	R32(esi, si);
 	R32(ebp, bp);
-	R32(eax, ax);
 	R32(eip, ip);
 	R32(esp, sp);
 
@@ -1130,6 +1129,60 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 value)
 		 * causes (long)orig_ax < 0 tests to fire correctly.
 		 */
 		regs->orig_ax = (long) (s32) value;
+
+		/*
+		 * Whenever setting orig_eax to indicate a system call in
+		 * progress, make sure an eax value set by the debugger gets
+		 * sign-extended so that any ax == -ERESTART* tests fire
+		 * correctly.
+		 *
+		 * When those tests (in handle_signal) are done directly
+		 * after an actual 32-bit syscall, then TS_COMPAT is set and
+		 * so syscall_get_error() does sign-extension.  However, the
+		 * debugger sometimes saves that state and then restores it
+		 * later with the intent of picking up the old thread state
+		 * that can be about to do syscall restart.
+		 *
+		 * When it's a 32-bit debugger, that truncates ax to 32 bits.
+		 * If the debugger restores thread state and resumes after a
+		 * ptrace stop when the child was not doing a new syscall, it
+		 * will not have TS_COMPAT set to make syscall_get_error()
+		 * notice and do the sign-extension.
+		 *
+		 * We can't have syscall_get_error() always sign-extend,
+		 * since that's wrong for 64-bit syscalls.  We want it to
+		 * check TS_COMPAT rather than TIF_IA32 to avoid a false
+		 * positive in the oddball case of a 32-bit task doing a
+		 * syscall from a 64-bit code segment.  In the "restored
+		 * thread state" case, it has no way to know whether the
+		 * restored state refers to a 32-bit or 64-bit syscall.
+		 *
+		 * So we can't win 'em all.  We assume that if you are using
+		 * a 32-bit debugger, you don't really care about arcane
+		 * interference with a child trying to use 64-bit syscalls.
+		 * (Just use a 64-bit debugger on it instead!)  What we do
+		 * here makes a 32-bit debugger fiddling a 32-bit task
+		 * consistent with what happens on a native 32-bit kernel.
+		 *
+		 * NOTE!  Since we have no similar logic in putreg(), we
+		 * just expect a 64-bit debugger to save/restore the full
+		 * 64 bits.  If a 64-bit debugger were to treat a 32-bit
+		 * task differently and save/restore only 32 bits per
+		 * register, it would have to grok orig_eax >= 0 and know
+		 * to sign-extend its saved eax when setting it as 64 bits.
+		 */
+		if (regs->orig_ax >= 0)
+			regs->ax = (long) (s32) regs->ax;
+		break;
+
+	case offsetof(struct user32, regs.eax):
+		/*
+		 * As above, for either order of setting both ax and orig_ax.
+		 */
+		if (regs->orig_ax >= 0)
+			regs->ax = (long) (s32) value;
+		else
+			regs->ax = value;
 		break;
 
 	case offsetof(struct user32, regs.eflags):

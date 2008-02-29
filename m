Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYB2D62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYB2D62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 22:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYB2D6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 22:58:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbYB2D6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 22:58:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64 ia32 syscall restart fix
X-Zippy-Says: Hey, wait a minute!!  I want a divorce!!..  you're not Clint Eastwood!!
Message-Id: <20080229035707.EAE862700FD@magilla.localdomain>
Date: Thu, 28 Feb 2008 19:57:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The code to restart syscalls after signals depends on checking for a
negative orig_ax, and for particular negative -ERESTART* values in ax.
These fields are 64 bits and for a 32-bit task they get zero-extended.
The syscall restart behavior is lost, a regression from a native 32-bit
kernel and from 64-bit tasks' behavior.  This patch fixes the problem by
doing sign-extension where it matters.  For orig_ax, the only time the
value should be -1 but winds up as 0x0ffffffff is via a 32-bit ptrace
call.  So the patch changes ptrace to sign-extend the 32-bit orig_eax
value when it's stored; it doesn't change the checks on orig_ax, though
it uses the new current_syscall() inline to better document the subtle
importance of the used of signedness there.  The ax value is stored a
lot of ways and it seems hard to get them all sign-extended at their
origins.  So for that, we use the current_syscall_ret() to sign-extend
it only for 32-bit tasks at the time of the -ERESTART* comparisons.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c    |    9 ++++++++-
 arch/x86/kernel/signal_64.c |   38 +++++++++++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index d862e39..3975351 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1035,10 +1035,17 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 value)
 	R32(esi, si);
 	R32(ebp, bp);
 	R32(eax, ax);
-	R32(orig_eax, orig_ax);
 	R32(eip, ip);
 	R32(esp, sp);
 
+	case offsetof(struct user32, regs.orig_eax):
+		/*
+		 * Sign-extend the value so that orig_eax = -1
+		 * causes (long)orig_ax < 0 tests to fire correctly.
+		 */
+		regs->orig_ax = (long) (s32) value;
+		break;
+
 	case offsetof(struct user32, regs.eflags):
 		return set_flags(child, value);
 
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 7347bb1..ce317ee 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -311,6 +311,35 @@ give_sigsegv:
 }
 
 /*
+ * Return -1L or the syscall number that @regs is executing.
+ */
+static long current_syscall(struct pt_regs *regs)
+{
+	/*
+	 * We always sign-extend a -1 value being set here,
+	 * so this is always either -1L or a syscall number.
+	 */
+	return regs->orig_ax;
+}
+
+/*
+ * Return a value that is -EFOO if the system call in @regs->orig_ax
+ * returned an error.  This only works for @regs from @current.
+ */
+static long current_syscall_ret(struct pt_regs *regs)
+{
+#ifdef CONFIG_IA32_EMULATION
+	if (test_thread_flag(TIF_IA32))
+		/*
+		 * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
+		 * and will match correctly in comparisons.
+		 */
+		return (int) regs->ax;
+#endif
+	return regs->ax;
+}
+
+/*
  * OK, we're invoking a handler
  */	
 
@@ -327,9 +356,9 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 #endif
 
 	/* Are we from a system call? */
-	if ((long)regs->orig_ax >= 0) {
+	if (current_syscall(regs) >= 0) {
 		/* If so, check system call restarting.. */
-		switch (regs->ax) {
+		switch (current_syscall_ret(regs)) {
 		        case -ERESTART_RESTARTBLOCK:
 			case -ERESTARTNOHAND:
 				regs->ax = -EINTR;
@@ -426,10 +455,9 @@ static void do_signal(struct pt_regs *regs)
 	}
 
 	/* Did we come from a system call? */
-	if ((long)regs->orig_ax >= 0) {
+	if (current_syscall(regs) >= 0) {
 		/* Restart the system call - no handlers present */
-		long res = regs->ax;
-		switch (res) {
+		switch (current_syscall_ret(regs)) {
 		case -ERESTARTNOHAND:
 		case -ERESTARTSYS:
 		case -ERESTARTNOINTR:

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbYG0GxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbYG0GxG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYG0Gwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:52:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbYG0Gwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:52:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Fcc: ~/Mail/linus
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] powerpc: tracehook: TIF_NOTIFY_RESUME
In-Reply-To: Roland McGrath's message of  Saturday, 26 July 2008 23:48:59 -0700 <20080727064859.69692154280@magilla.localdomain>
References: <20080727064859.69692154280@magilla.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080727065252.0F1B1154280@magilla.localdomain>
Date: Sat, 26 Jul 2008 23:52:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds TIF_NOTIFY_RESUME support for powerpc.  When set,
we call tracehook_notify_resume() on the way to user mode.
This overloads do_signal() to do the work, but changes its
arguments to it has the TIF_* bits handy in a register and
drops the useless first argument that was always zero.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/entry_32.S    |    4 ++--
 arch/powerpc/kernel/entry_64.S    |    3 +--
 arch/powerpc/kernel/signal.c      |   13 ++++++++++++-
 include/asm-powerpc/signal.h      |    3 +--
 include/asm-powerpc/thread_info.h |    5 ++++-
 5 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 0efc1e6..3e7445e 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -1060,8 +1060,8 @@ do_user_signal:			/* r10 contains MSR_KERNEL here */
 	SAVE_NVGPRS(r1)
 	rlwinm	r3,r3,0,0,30
 	stw	r3,_TRAP(r1)
-2:	li	r3,0
-	addi	r4,r1,STACK_FRAME_OVERHEAD
+2:	addi	r3,r1,STACK_FRAME_OVERHEAD
+	mr	r4,r9
 	bl	do_signal
 	REST_NVGPRS(r1)
 	b	recheck
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 79c089e..2d802e9 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -643,8 +643,7 @@ user_work:
 	b	.ret_from_except_lite
 
 1:	bl	.save_nvgprs
-	li	r3,0
-	addi	r4,r1,STACK_FRAME_OVERHEAD
+	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	.do_signal
 	b	.ret_from_except
 
diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index 11a5c45..060d2a8 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -112,7 +112,7 @@ static void check_syscall_restart(struct pt_regs *regs, struct k_sigaction *ka,
 	}
 }
 
-int do_signal(sigset_t *oldset, struct pt_regs *regs)
+static int do_signal_pending(sigset_t *oldset, struct pt_regs *regs)
 {
 	siginfo_t info;
 	int signr;
@@ -188,6 +188,17 @@ int do_signal(sigset_t *oldset, struct pt_regs *regs)
 	return ret;
 }
 
+void do_signal(struct pt_regs *regs, unsigned long thread_info_flags)
+{
+	if (thread_info_flags & _TIF_SIGPENDING)
+		do_signal_pending(NULL, regs);
+
+	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(regs);
+	}
+}
+
 long sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		unsigned long r5, unsigned long r6, unsigned long r7,
 		unsigned long r8, struct pt_regs *regs)
diff --git a/include/asm-powerpc/signal.h b/include/asm-powerpc/signal.h
index a8c7bab..a7360cd 100644
--- a/include/asm-powerpc/signal.h
+++ b/include/asm-powerpc/signal.h
@@ -122,8 +122,7 @@ typedef struct sigaltstack {
 
 #ifdef __KERNEL__
 struct pt_regs;
-extern int do_signal(sigset_t *oldset, struct pt_regs *regs);
-extern int do_signal32(sigset_t *oldset, struct pt_regs *regs);
+extern void do_signal(struct pt_regs *regs, unsigned long thread_info_flags);
 #define ptrace_signal_deliver(regs, cookie) do { } while (0)
 #endif /* __KERNEL__ */
 
diff --git a/include/asm-powerpc/thread_info.h b/include/asm-powerpc/thread_info.h
index a9db562..9665a26 100644
--- a/include/asm-powerpc/thread_info.h
+++ b/include/asm-powerpc/thread_info.h
@@ -108,6 +108,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SECCOMP		10	/* secure computing */
 #define TIF_RESTOREALL		11	/* Restore all regs (implies NOERROR) */
 #define TIF_NOERROR		12	/* Force successful syscall return */
+#define TIF_NOTIFY_RESUME	13	/* callback before returning to user */
 #define TIF_FREEZE		14	/* Freezing for suspend */
 #define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
 #define TIF_ABI_PENDING		16	/* 32/64 bit switch needed */
@@ -125,12 +126,14 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_RESTOREALL		(1<<TIF_RESTOREALL)
 #define _TIF_NOERROR		(1<<TIF_NOERROR)
+#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
 
-#define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED)
+#define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
+				 _TIF_NOTIFY_RESUME)
 #define _TIF_PERSYSCALL_MASK	(_TIF_RESTOREALL|_TIF_NOERROR)
 
 /* Bits in local_flags */

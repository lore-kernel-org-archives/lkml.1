Return-Path: <linux-kernel-owner+w=401wt.eu-S1760246AbYDCVJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246AbYDCVJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:09:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbYDCVIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:08:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113AbYDCVIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:08:50 -0400
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] powerpc TLF_RESTORE_SIGMASK
X-Fcc: ~/Mail/linus
X-Zippy-Says: Remember, if you try to ESCAPE, many APARTMENT HOPPING ALCOHOLICS
    will SIMONIZE your HALLWAYS!!  This is your LAST WARNING!!
Message-Id: <20080403210842.6C88C26F98D@magilla.localdomain>
Date: Thu,  3 Apr 2008 14:08:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This requires the earlier HAVE_SET_RESTORE_SIGMASK patch series.
This does the same for powerpc that I posted the x86 change for.

---
Replace TIF_RESTORE_SIGMASK with TLF_RESTORE_SIGMASK and define
our own set_restore_sigmask() function.  This saves the costly
SMP-safe set_bit operation, which we do not need for the sigmask
flag since TIF_SIGPENDING always has to be set too.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/entry_32.S    |    4 ++--
 arch/powerpc/kernel/signal.c      |   12 ++++++------
 arch/powerpc/kernel/signal_32.c   |    2 +-
 include/asm-powerpc/thread_info.h |   17 +++++++++++++----
 4 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 69a91bd..646daf4 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -661,7 +661,7 @@ user_exc_return:		/* r10 contains MSR_KERNEL here */
 	/* Check current_thread_info()->flags */
 	rlwinm	r9,r1,0,0,(31-THREAD_SHIFT)
 	lwz	r9,TI_FLAGS(r9)
-	andi.	r0,r9,(_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK|_TIF_NEED_RESCHED)
+	andi.	r0,r9,(_TIF_SIGPENDING|_TIF_NEED_RESCHED)
 	bne	do_work
 
 restore_user:
@@ -912,7 +912,7 @@ recheck:
 	lwz	r9,TI_FLAGS(r9)
 	andi.	r0,r9,_TIF_NEED_RESCHED
 	bne-	do_resched
-	andi.	r0,r9,_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK
+	andi.	r0,r9,_TIF_SIGPENDING
 	beq	restore_user
 do_user_signal:			/* r10 contains MSR_KERNEL here */
 	ori	r10,r10,MSR_EE
diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index a65a44f..ad55488 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -120,7 +120,7 @@ int do_signal(sigset_t *oldset, struct pt_regs *regs)
 	int ret;
 	int is32 = is_32bit_task();
 
-	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+	if (current_thread_info()->local_flags & _TLF_RESTORE_SIGMASK)
 		oldset = &current->saved_sigmask;
 	else if (!oldset)
 		oldset = &current->blocked;
@@ -131,9 +131,10 @@ int do_signal(sigset_t *oldset, struct pt_regs *regs)
 	check_syscall_restart(regs, &ka, signr > 0);
 
 	if (signr <= 0) {
+		struct thread_info *ti = current_thread_info();
 		/* No signal to deliver -- put the saved sigmask back */
-		if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
-			clear_thread_flag(TIF_RESTORE_SIGMASK);
+		if (ti->local_flags & _TLF_RESTORE_SIGMASK) {
+			ti->local_flags &= ~_TLF_RESTORE_SIGMASK;
 			sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 		}
 		return 0;               /* no signals delivered */
@@ -169,10 +170,9 @@ int do_signal(sigset_t *oldset, struct pt_regs *regs)
 
 		/*
 		 * A signal was successfully delivered; the saved sigmask is in
-		 * its frame, and we can clear the TIF_RESTORE_SIGMASK flag.
+		 * its frame, and we can clear the TLF_RESTORE_SIGMASK flag.
 		 */
-		if (test_thread_flag(TIF_RESTORE_SIGMASK))
-			clear_thread_flag(TIF_RESTORE_SIGMASK);
+		current_thread_info()->local_flags &= ~_TLF_RESTORE_SIGMASK;
 	}
 
 	return ret;
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index ad69434..4ae16d1 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -243,7 +243,7 @@ long sys_sigsuspend(old_sigset_t mask)
 
  	current->state = TASK_INTERRUPTIBLE;
  	schedule();
- 	set_thread_flag(TIF_RESTORE_SIGMASK);
+	set_restore_sigmask();
  	return -ERESTARTNOHAND;
 }
 
diff --git a/include/asm-powerpc/thread_info.h b/include/asm-powerpc/thread_info.h
index 40d5f98..3b9271b 100644
--- a/include/asm-powerpc/thread_info.h
+++ b/include/asm-powerpc/thread_info.h
@@ -120,7 +120,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SECCOMP		10	/* secure computing */
 #define TIF_RESTOREALL		11	/* Restore all regs (implies NOERROR) */
 #define TIF_NOERROR		12	/* Force successful syscall return */
-#define TIF_RESTORE_SIGMASK	13	/* Restore signal mask in do_signal */
 #define TIF_FREEZE		14	/* Freezing for suspend */
 #define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
 #define TIF_ABI_PENDING		16	/* 32/64 bit switch needed */
@@ -138,21 +137,31 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_RESTOREALL		(1<<TIF_RESTOREALL)
 #define _TIF_NOERROR		(1<<TIF_NOERROR)
-#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
 
-#define _TIF_USER_WORK_MASK	( _TIF_SIGPENDING | \
-				 _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK)
+#define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED)
 #define _TIF_PERSYSCALL_MASK	(_TIF_RESTOREALL|_TIF_NOERROR)
 
 /* Bits in local_flags */
 /* Don't move TLF_NAPPING without adjusting the code in entry_32.S */
 #define TLF_NAPPING		0	/* idle thread enabled NAP mode */
+#define TLF_RESTORE_SIGMASK	1	/* Restore signal mask in do_signal */
 
 #define _TLF_NAPPING		(1 << TLF_NAPPING)
+#define _TLF_RESTORE_SIGMASK	(1 << TLF_RESTORE_SIGMASK)
+
+#ifndef __ASSEMBLY__
+#define HAVE_SET_RESTORE_SIGMASK	1
+static inline void set_restore_sigmask(void)
+{
+	struct thread_info *ti = current_thread_info();
+	ti->local_flags |= TLF_RESTORE_SIGMASK;
+	set_bit(TIF_SIGPENDING, &ti->flags);
+}
+#endif	/* !__ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
 

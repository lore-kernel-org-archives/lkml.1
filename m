Return-Path: <linux-kernel-owner+w=401wt.eu-S932607AbYD1Hb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbYD1Hb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765518AbYD1HbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:31:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763654AbYD1HbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:31:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] powerpc TLF_RESTORE_SIGMASK
In-Reply-To: Paul Mackerras's message of  Thursday, 24 April 2008 16:31:31 +1000 <18448.10563.385481.904182@cargo.ozlabs.ibm.com>
References: <20080403210842.6C88C26F98D@magilla.localdomain>
	<18446.50037.964682.539009@cargo.ozlabs.ibm.com>
	<20080423063753.C2088270381@magilla.localdomain>
	<18448.10563.385481.904182@cargo.ozlabs.ibm.com>
X-Zippy-Says: After THIS, let's go to PHILADELPHIA and have TRIPLETS!!
Message-Id: <20080428073037.B649B26F8F0@magilla.localdomain>
Date: Mon, 28 Apr 2008 00:30:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks.  That can't go in until some generic changes have gone in
> first, right?  So are you going to push the lot in one go via Andrew,
> or should I wait until the generic part is upstream and then push the
> powerpc bit?

>From what I can see, the related patches are in -mm now, but the powerpc
patch is not.  Linus already said he approved of the patches, so I hope
they can be merged in real soon.  That will simplify the juggling for arch
patches.  That said, there is really no hurry for this change for powerpc;
it's a small optimization.

> Oh, and could you please also fix the occurrence of
> TIF_RESTORE_SIGMASK in arch/ppc/kernel/entry.S when this stuff goes
> in?

Oh, I didn't realize that file was in use (or existed).
Third time's the charm (or is this the fifth time?).


Thanks,
Roland

---
[PATCH] powerpc TLF_RESTORE_SIGMASK

Replace TIF_RESTORE_SIGMASK with TLF_RESTORE_SIGMASK and define
our own set_restore_sigmask() function.  This saves the costly
SMP-safe set_bit operation, which we do not need for the sigmask
flag since TIF_SIGPENDING always has to be set too.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/entry_32.S    |    4 ++--
 arch/powerpc/kernel/signal.c      |   12 ++++++------
 arch/powerpc/kernel/signal_32.c   |    2 +-
 arch/ppc/kernel/entry.S           |    4 ++--
 include/asm-powerpc/thread_info.h |   17 +++++++++++++----
 5 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 84c8686..7e2ecf0 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -667,7 +667,7 @@ user_exc_return:		/* r10 contains MSR_KERNEL here */
 	/* Check current_thread_info()->flags */
 	rlwinm	r9,r1,0,0,(31-THREAD_SHIFT)
 	lwz	r9,TI_FLAGS(r9)
-	andi.	r0,r9,(_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK|_TIF_NEED_RESCHED)
+	andi.	r0,r9,_TIF_USER_WORK_MASK
 	bne	do_work
 
 restore_user:
@@ -924,7 +924,7 @@ recheck:
 	lwz	r9,TI_FLAGS(r9)
 	andi.	r0,r9,_TIF_NEED_RESCHED
 	bne-	do_resched
-	andi.	r0,r9,_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK
+	andi.	r0,r9,_TIF_USER_WORK_MASK
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
 
diff --git a/arch/ppc/kernel/entry.S b/arch/ppc/kernel/entry.S
index 5f3a5d0..fcd830a 100644
--- a/arch/ppc/kernel/entry.S
+++ b/arch/ppc/kernel/entry.S
@@ -647,7 +647,7 @@ user_exc_return:		/* r10 contains MSR_KERNEL here */
 	/* Check current_thread_info()->flags */
 	rlwinm	r9,r1,0,0,18
 	lwz	r9,TI_FLAGS(r9)
-	andi.	r0,r9,(_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK|_TIF_NEED_RESCHED)
+	andi.	r0,r9,_TIF_USER_WORK_MASK
 	bne	do_work
 
 restore_user:
@@ -898,7 +898,7 @@ recheck:
 	lwz	r9,TI_FLAGS(r9)
 	andi.	r0,r9,_TIF_NEED_RESCHED
 	bne-	do_resched
-	andi.	r0,r9,_TIF_SIGPENDING
+	andi.	r0,r9,_TIF_USER_WORK_MASK
 	beq	restore_user
 do_user_signal:			/* r10 contains MSR_KERNEL here */
 	ori	r10,r10,MSR_EE
diff --git a/include/asm-powerpc/thread_info.h b/include/asm-powerpc/thread_info.h
index d030f5c..e079e81 100644
--- a/include/asm-powerpc/thread_info.h
+++ b/include/asm-powerpc/thread_info.h
@@ -116,7 +116,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SECCOMP		10	/* secure computing */
 #define TIF_RESTOREALL		11	/* Restore all regs (implies NOERROR) */
 #define TIF_NOERROR		12	/* Force successful syscall return */
-#define TIF_RESTORE_SIGMASK	13	/* Restore signal mask in do_signal */
 #define TIF_FREEZE		14	/* Freezing for suspend */
 #define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
 #define TIF_ABI_PENDING		16	/* 32/64 bit switch needed */
@@ -134,21 +133,31 @@ static inline struct thread_info *current_thread_info(void)
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
+	ti->local_flags |= _TLF_RESTORE_SIGMASK;
+	set_bit(TIF_SIGPENDING, &ti->flags);
+}
+#endif	/* !__ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
 

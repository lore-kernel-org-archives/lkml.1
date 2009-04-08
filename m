Return-Path: <linux-kernel-owner+w=401wt.eu-S933516AbZDHMD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbZDHMD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933251AbZDHLzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:55:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:37371 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967AbZDHLzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:55:12 -0400
Date: Wed, 8 Apr 2009 11:54:32 GMT
From: Jiri Slaby <jirislaby@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jirislaby@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1239190320-23952-1-git-send-email-jirislaby@gmail.com>
References: <1239190320-23952-1-git-send-email-jirislaby@gmail.com>
Subject: [tip:x86/fpu] x86_32: introduce restore_fpu_checking()
Message-ID: <tip-fcb2ac5bdfa3a7a04fb9749b916f64400f4c35a8@git.kernel.org>
Git-Commit-ID: fcb2ac5bdfa3a7a04fb9749b916f64400f4c35a8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 11:54:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fcb2ac5bdfa3a7a04fb9749b916f64400f4c35a8
Gitweb:     http://git.kernel.org/tip/fcb2ac5bdfa3a7a04fb9749b916f64400f4c35a8
Author:     Jiri Slaby <jirislaby@gmail.com>
AuthorDate: Wed, 8 Apr 2009 13:31:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 13:46:00 +0200

x86_32: introduce restore_fpu_checking()

Impact: cleanup, prepare FPU code unificaton

Like on x86_64, return an error from restore_fpu and kill the task
if it fails.

Also rename restore_fpu to restore_fpu_checking which allows ifdefs
to be removed in math_state_restore().

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
LKML-Reference: <1239190320-23952-1-git-send-email-jirislaby@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/i387.h |    9 ++++-----
 arch/x86/kernel/traps.c     |    5 +----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 71c9e51..09a2d6d 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -185,12 +185,10 @@ static inline void tolerant_fwait(void)
 	asm volatile("fnclex ; fwait");
 }
 
-static inline void restore_fpu(struct task_struct *tsk)
+static inline int restore_fpu_checking(struct task_struct *tsk)
 {
-	if (task_thread_info(tsk)->status & TS_XSAVE) {
-		xrstor_checking(&tsk->thread.xstate->xsave);
-		return;
-	}
+	if (task_thread_info(tsk)->status & TS_XSAVE)
+		return xrstor_checking(&tsk->thread.xstate->xsave);
 	/*
 	 * The "nop" is needed to make the instructions the same
 	 * length.
@@ -200,6 +198,7 @@ static inline void restore_fpu(struct task_struct *tsk)
 		"fxrstor %1",
 		X86_FEATURE_FXSR,
 		"m" (tsk->thread.xstate->fxsave));
+	return 0;
 }
 
 /* We need a safe address that is cheap to find and that is already
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a1d2883..d696145 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -839,9 +839,6 @@ asmlinkage void math_state_restore(void)
 	}
 
 	clts();				/* Allow maths ops (or we recurse) */
-#ifdef CONFIG_X86_32
-	restore_fpu(tsk);
-#else
 	/*
 	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
 	 */
@@ -850,7 +847,7 @@ asmlinkage void math_state_restore(void)
 		force_sig(SIGSEGV, tsk);
 		return;
 	}
-#endif
+
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
 }

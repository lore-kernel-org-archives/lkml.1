Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbYIJAWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbYIJAWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 20:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYIJAWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 20:22:13 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:34826 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYIJAWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 20:22:12 -0400
Message-ID: <48C71334.7050801@ct.jp.nec.com>
Date: Tue, 09 Sep 2008 17:22:12 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86_64: signal: make handle_signal() similar
References: <48C7126A.5010304@ct.jp.nec.com>
In-Reply-To: <48C7126A.5010304@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Make handle_signal() same as 32bit.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_64.c |   61 ++++++++++++++++++++++---------------------
 1 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 321da93..43e6862 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -338,39 +338,40 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 
 	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
-	if (ret == 0) {
-		/*
-		 * This has nothing to do with segment registers,
-		 * despite the name.  This magic affects uaccess.h
-		 * macros' behavior.  Reset it to the normal setting.
-		 */
-		set_fs(USER_DS);
+	if (ret)
+		return ret;
 
-		/*
-		 * Clear the direction flag as per the ABI for function entry.
-		 */
-		regs->flags &= ~X86_EFLAGS_DF;
+	/*
+	 * This has nothing to do with segment registers,
+	 * despite the name.  This magic affects uaccess.h
+	 * macros' behavior.  Reset it to the normal setting.
+	 */
+	set_fs(USER_DS);
 
-		/*
-		 * Clear TF when entering the signal handler, but
-		 * notify any tracer that was single-stepping it.
-		 * The tracer may want to single-step inside the
-		 * handler too.
-		 */
-		regs->flags &= ~X86_EFLAGS_TF;
+	/*
+	 * Clear the direction flag as per the ABI for function entry.
+	 */
+	regs->flags &= ~X86_EFLAGS_DF;
 
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+	/*
+	 * Clear TF when entering the signal handler, but
+	 * notify any tracer that was single-stepping it.
+	 * The tracer may want to single-step inside the
+	 * handler too.
+	 */
+	regs->flags &= ~X86_EFLAGS_TF;
 
-		tracehook_signal_handler(sig, info, ka, regs,
-					 test_thread_flag(TIF_SINGLESTEP));
-	}
+	spin_lock_irq(&current->sighand->siglock);
+	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
+	if (!(ka->sa.sa_flags & SA_NODEFER))
+		sigaddset(&current->blocked, sig);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
 
-	return ret;
+	tracehook_signal_handler(sig, info, ka, regs,
+				 test_thread_flag(TIF_SINGLESTEP));
+
+	return 0;
 }
 
 #define NR_restart_syscall	\
-- 
1.5.6


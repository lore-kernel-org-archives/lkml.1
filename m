Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYIEX2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYIEX2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 19:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYIEX2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 19:28:09 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:51291 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYIEX2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 19:28:08 -0400
Message-ID: <48C1C086.2090807@ct.jp.nec.com>
Date: Fri, 05 Sep 2008 16:28:06 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] x86: signal: split out frame setups
References: <48C1BF41.8040404@ct.jp.nec.com>
In-Reply-To: <48C1BF41.8040404@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Make setup_rt_frame() and split out frame setups from handle_signal().
This is for cosmetic unification of handle_signal().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   29 ++++++++++++++++++++---------
 arch/x86/kernel/signal_64.c |   30 ++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index bd9b650..48982f7 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -338,8 +338,8 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 }
 
 static int
-setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
-	    struct pt_regs *regs)
+__setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
+	      struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
 	void __user *restorer;
@@ -416,8 +416,8 @@ give_sigsegv:
 	return -EFAULT;
 }
 
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set, struct pt_regs *regs)
+static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			    sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	void __user *restorer;
@@ -502,6 +502,21 @@ give_sigsegv:
  * OK, we're invoking a handler:
  */
 static int
+setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+	       sigset_t *set, struct pt_regs *regs)
+{
+	int ret;
+
+	/* Set up the stack frame */
+	if (ka->sa.sa_flags & SA_SIGINFO)
+		ret = __setup_rt_frame(sig, ka, info, set, regs);
+	else
+		ret = __setup_frame(sig, ka, set, regs);
+
+	return ret;
+}
+
+static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
@@ -537,11 +552,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
 		regs->flags &= ~X86_EFLAGS_TF;
 
-	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = setup_rt_frame(sig, ka, info, oldset, regs);
-	else
-		ret = setup_frame(sig, ka, oldset, regs);
+	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
 	if (ret)
 		return ret;
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 19e2b91..8fbdd23 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -195,8 +195,8 @@ get_stack(struct k_sigaction *ka, struct pt_regs *regs, unsigned long size)
 	return (void __user *)round_down(sp - size, 64);
 }
 
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs *regs)
+static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			    sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	void __user *fp = NULL;
@@ -280,6 +280,24 @@ give_sigsegv:
 /*
  * OK, we're invoking a handler
  */
+static int
+setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+	       sigset_t *set, struct pt_regs *regs)
+{
+	int ret;
+
+#ifdef CONFIG_IA32_EMULATION
+	if (test_thread_flag(TIF_IA32)) {
+		if (ka->sa.sa_flags & SA_SIGINFO)
+			ret = ia32_setup_rt_frame(sig, ka, info, set, regs);
+		else
+			ret = ia32_setup_frame(sig, ka, set, regs);
+	} else
+#endif
+	ret = __setup_rt_frame(sig, ka, info, set, regs);
+
+	return ret;
+}
 
 static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
@@ -317,14 +335,6 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
 		regs->flags &= ~X86_EFLAGS_TF;
 
-#ifdef CONFIG_IA32_EMULATION
-	if (test_thread_flag(TIF_IA32)) {
-		if (ka->sa.sa_flags & SA_SIGINFO)
-			ret = ia32_setup_rt_frame(sig, ka, info, oldset, regs);
-		else
-			ret = ia32_setup_frame(sig, ka, oldset, regs);
-	} else
-#endif
 	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
 	if (ret == 0) {
-- 
1.5.6


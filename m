Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYIYCNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYIYCNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYIYCNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:13:13 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:28434 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYIYCNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:13:12 -0400
Message-ID: <48DAF3B7.9030000@ct.jp.nec.com>
Date: Wed, 24 Sep 2008 19:13:11 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86: signal: introduce helper macro is_ia32
References: <48DAF315.7070700@ct.jp.nec.com>
In-Reply-To: <48DAF315.7070700@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Introduce new macro is_ia32 for unification of setup_rt_frame().
No affect in binary, compiler will optimize.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   13 +++++++++----
 arch/x86/kernel/signal_64.c |   13 +++++++++----
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index b1bc90f..cf62f70 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -491,6 +491,8 @@ static int signr_convert(int sig)
 	return sig;
 }
 
+#define is_ia32	1
+
 static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	       sigset_t *set, struct pt_regs *regs)
@@ -499,10 +501,13 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	int ret;
 
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = __setup_rt_frame(usig, ka, info, set, regs);
-	else
-		ret = __setup_frame(usig, ka, set, regs);
+	if (is_ia32) {
+		if (ka->sa.sa_flags & SA_SIGINFO)
+			ret = __setup_rt_frame(usig, ka, info, set, regs);
+		else
+			ret = __setup_frame(usig, ka, set, regs);
+	} else
+		ret = __setup_rt_frame(sig, ka, info, set, regs);
 
 	if (ret) {
 		force_sigsegv(sig, current);
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index c5d8002..53f86d9 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -286,6 +286,12 @@ static int signr_convert(int sig)
 	return sig;
 }
 
+#ifdef CONFIG_IA32_EMULATION
+#define is_ia32	test_thread_flag(TIF_IA32)
+#else
+#define is_ia32	0
+#endif
+
 static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	       sigset_t *set, struct pt_regs *regs)
@@ -293,15 +299,14 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	int usig = signr_convert(sig);
 	int ret;
 
-#ifdef CONFIG_IA32_EMULATION
-	if (test_thread_flag(TIF_IA32)) {
+	/* Set up the stack frame */
+	if (is_ia32) {
 		if (ka->sa.sa_flags & SA_SIGINFO)
 			ret = ia32_setup_rt_frame(usig, ka, info, set, regs);
 		else
 			ret = ia32_setup_frame(usig, ka, set, regs);
 	} else
-#endif
-	ret = __setup_rt_frame(sig, ka, info, set, regs);
+		ret = __setup_rt_frame(sig, ka, info, set, regs);
 
 	if (ret) {
 		force_sigsegv(sig, current);
-- 
1.5.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYIMADK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYIMADK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbYIMACz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:02:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:6161 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290AbYIMACy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:02:54 -0400
Message-ID: <48CB032D.3040608@ct.jp.nec.com>
Date: Fri, 12 Sep 2008 17:02:53 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: signal: remove unneeded err handling
References: <48CB02C5.4060805@ct.jp.nec.com>
In-Reply-To: <48CB02C5.4060805@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

This patch eliminates unused or unneeded variable handling.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |   11 ++++-------
 arch/x86/kernel/signal_32.c |   11 ++++-------
 arch/x86/kernel/signal_64.c |    5 ++---
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 5f42cfc..e47bed2 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -446,18 +446,15 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	err |= __put_user(sig, &frame->sig);
-	if (err)
+	if (__put_user(sig, &frame->sig))
 		return -EFAULT;
 
-	err |= ia32_setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]);
-	if (err)
+	if (ia32_setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]))
 		return -EFAULT;
 
 	if (_COMPAT_NSIG_WORDS > 1) {
-		err |= __copy_to_user(frame->extramask, &set->sig[1],
-				      sizeof(frame->extramask));
-		if (err)
+		if (__copy_to_user(frame->extramask, &set->sig[1],
+				   sizeof(frame->extramask)))
 			return -EFAULT;
 	}
 
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 1c22e00..d433861 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -351,18 +351,15 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	err = __put_user(sig, &frame->sig);
-	if (err)
+	if (__put_user(sig, &frame->sig))
 		return -EFAULT;
 
-	err = setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]);
-	if (err)
+	if (setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]))
 		return -EFAULT;
 
 	if (_NSIG_WORDS > 1) {
-		err = __copy_to_user(&frame->extramask, &set->sig[1],
-				      sizeof(frame->extramask));
-		if (err)
+		if (__copy_to_user(&frame->extramask, &set->sig[1],
+				   sizeof(frame->extramask)))
 			return -EFAULT;
 	}
 
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 3b79e17..a21c851 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -210,7 +210,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
 
 		if (save_i387_xstate(fp) < 0)
-			err |= -1;
+			return -EFAULT;
 	} else
 		frame = get_stack(ka, regs, sizeof(struct rt_sigframe)) - 8;
 
@@ -218,8 +218,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		return -EFAULT;
 
 	if (ka->sa.sa_flags & SA_SIGINFO) {
-		err |= copy_siginfo_to_user(&frame->info, info);
-		if (err)
+		if (copy_siginfo_to_user(&frame->info, info))
 			return -EFAULT;
 	}
 
-- 
1.5.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZB0S3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZB0S3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZB0S2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:28:52 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:64493 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbZB0S2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:28:51 -0500
Message-ID: <49A830E0.5030806@ct.jp.nec.com>
Date: Fri, 27 Feb 2009 10:28:48 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86: signal: intrroduce get_sigframe() and replace get_sigstack()
References: <49A83078.3020207@ct.jp.nec.com>
In-Reply-To: <49A83078.3020207@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Introduce get_sigframe() like 32-bit to replace get_sigstack().
Move the i387 stuff into get_sigframe().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index d6883b7..5ed4533 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -392,10 +392,13 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
  * Determine which stack to use..
  */
 static void __user *
-get_stack(struct k_sigaction *ka, unsigned long sp, unsigned long size)
+get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
+	     void __user **fpstate)
 {
-	/* Default to using normal stack - redzone*/
-	sp -= 128;
+	unsigned long sp;
+
+	/* Default to using normal stack - redzone */
+	sp = regs->sp - 128;
 
 	/* This is the X/Open sanctioned signal stack switching.  */
 	if (ka->sa.sa_flags & SA_ONSTACK) {
@@ -403,7 +406,18 @@ get_stack(struct k_sigaction *ka, unsigned long sp, unsigned long size)
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
-	return (void __user *)round_down(sp - size, 64);
+	if (used_math()) {
+		sp -= sig_xstate_size;
+		*fpstate = (void __user *)round_down(sp, 64);
+		if (save_i387_xstate(*fpstate) < 0)
+			return (void __user *) -1L;
+
+		sp -= frame_size;
+		return (void __user *)round_down(sp, 16) - 8;
+	}
+
+	sp -= frame_size;
+	return (void __user *)round_down(sp, 64) - 8;
 }
 
 static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
@@ -414,15 +428,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	int err = 0;
 	struct task_struct *me = current;
 
-	if (used_math()) {
-		fp = get_stack(ka, regs->sp, sig_xstate_size);
-		frame = (void __user *)round_down(
-			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
-
-		if (save_i387_xstate(fp) < 0)
-			return -EFAULT;
-	} else
-		frame = get_stack(ka, regs->sp, sizeof(struct rt_sigframe)) - 8;
+	frame = get_sigframe(ka, regs, sizeof(struct rt_sigframe), &fp);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
-- 
1.6.1.2


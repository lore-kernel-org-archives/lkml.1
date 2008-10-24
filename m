Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYJXAPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYJXAPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 20:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYJXAPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 20:15:30 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:27703 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbYJXAP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 20:15:29 -0400
Message-ID: <490113A0.4080009@ct.jp.nec.com>
Date: Thu, 23 Oct 2008 17:15:28 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: signal_64.c: get_stack() doesn't need entire regs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

get_stack() uses sp only, entire regs is not needed.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_64.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 9c469da..3d0deb3 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -199,12 +199,10 @@ setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
  */
 
 static void __user *
-get_stack(struct k_sigaction *ka, struct pt_regs *regs, unsigned long size)
+get_stack(struct k_sigaction *ka, unsigned long sp, unsigned long size)
 {
-	unsigned long sp;
-
 	/* Default to using normal stack - redzone*/
-	sp = regs->sp - 128;
+	sp -= 128;
 
 	/* This is the X/Open sanctioned signal stack switching.  */
 	if (ka->sa.sa_flags & SA_ONSTACK) {
@@ -224,14 +222,14 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	struct task_struct *me = current;
 
 	if (used_math()) {
-		fp = get_stack(ka, regs, sig_xstate_size);
+		fp = get_stack(ka, regs->sp, sig_xstate_size);
 		frame = (void __user *)round_down(
 			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
 
 		if (save_i387_xstate(fp) < 0)
 			return -EFAULT;
 	} else
-		frame = get_stack(ka, regs, sizeof(struct rt_sigframe)) - 8;
+		frame = get_stack(ka, regs->sp, sizeof(struct rt_sigframe)) - 8;
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
-- 
1.5.6


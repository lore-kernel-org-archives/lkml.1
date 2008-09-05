Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYIEX2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYIEX2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 19:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYIEX2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 19:28:39 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:51448 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYIEX2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 19:28:39 -0400
Message-ID: <48C1C0A6.2000600@ct.jp.nec.com>
Date: Fri, 05 Sep 2008 16:28:38 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86_32: signal: move signal number conversion to upper
 layer
References: <48C1BF41.8040404@ct.jp.nec.com>
In-Reply-To: <48C1BF41.8040404@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Bring signal number conversion in __setup_frame() and __setup_rt_frame()
up into the common part setup_frame().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   31 ++++++++++++-------------------
 1 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 48982f7..b668efc 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -344,7 +344,6 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	struct sigframe __user *frame;
 	void __user *restorer;
 	int err = 0;
-	int usig;
 	void __user *fpstate = NULL;
 
 	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
@@ -352,13 +351,7 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
 
-	usig = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
-
-	err = __put_user(usig, &frame->sig);
+	err = __put_user(sig, &frame->sig);
 	if (err)
 		goto give_sigsegv;
 
@@ -422,7 +415,6 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	struct rt_sigframe __user *frame;
 	void __user *restorer;
 	int err = 0;
-	int usig;
 	void __user *fpstate = NULL;
 
 	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
@@ -430,13 +422,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
 
-	usig = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
-
-	err |= __put_user(usig, &frame->sig);
+	err |= __put_user(sig, &frame->sig);
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
 	err |= copy_siginfo_to_user(&frame->info, info);
@@ -482,7 +468,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	/* Set up registers for signal handler */
 	regs->sp = (unsigned long)frame;
 	regs->ip = (unsigned long)ka->sa.sa_handler;
-	regs->ax = (unsigned long)usig;
+	regs->ax = (unsigned long)sig;
 	regs->dx = (unsigned long)&frame->info;
 	regs->cx = (unsigned long)&frame->uc;
 
@@ -506,12 +492,19 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	       sigset_t *set, struct pt_regs *regs)
 {
 	int ret;
+	int usig;
+
+	usig = current_thread_info()->exec_domain
+		&& current_thread_info()->exec_domain->signal_invmap
+		&& sig < 32
+		? current_thread_info()->exec_domain->signal_invmap[sig]
+		: sig;
 
 	/* Set up the stack frame */
 	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = __setup_rt_frame(sig, ka, info, set, regs);
+		ret = __setup_rt_frame(usig, ka, info, set, regs);
 	else
-		ret = __setup_frame(sig, ka, set, regs);
+		ret = __setup_frame(usig, ka, set, regs);
 
 	return ret;
 }
-- 
1.5.6


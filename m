Return-Path: <linux-kernel-owner+w=401wt.eu-S933654AbYBVMrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654AbYBVMrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYBVMrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:47:35 -0500
Received: from sacred.ru ([62.205.161.221]:45205 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbYBVMre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:47:34 -0500
Message-ID: <47BEC459.6090207@openvz.org>
Date: Fri, 22 Feb 2008 15:47:21 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 1/3] Consolidate checks for whether or not to ignore a signal
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 22 Feb 2008 15:47:11 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both sig_ignored() and do_sigactoin() check for signr to be explicitly 
or implicitly ignored. Introduce a helper for them.

This patch is aimed to help handling signals by pid namespace's
init, and was derived from one of Oleg's patches
https://lists.linux-foundation.org/pipermail/containers/2007-December/009308.html
so, if he doesn't mind, he should be considered as an author.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 kernel/signal.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 56ebcc3..c32f990 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -39,11 +39,19 @@
 
 static struct kmem_cache *sigqueue_cachep;
 
+static int __sig_ignored(struct task_struct *t, int sig)
+{
+	void __user *handler;
+
+	/* Is it explicitly or implicitly ignored? */
+
+	handler = t->sighand->action[sig - 1].sa.sa_handler;
+	return handler == SIG_IGN ||
+		(handler == SIG_DFL && sig_kernel_ignore(sig));
+}
 
 static int sig_ignored(struct task_struct *t, int sig)
 {
-	void __user * handler;
-
 	/*
 	 * Tracers always want to know about signals..
 	 */
@@ -58,10 +66,7 @@ static int sig_ignored(struct task_struct *t, int sig)
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	/* Is it explicitly or implicitly ignored? */
-	handler = t->sighand->action[sig-1].sa.sa_handler;
-	return   handler == SIG_IGN ||
-		(handler == SIG_DFL && sig_kernel_ignore(sig));
+	return __sig_ignored(t, sig);
 }
 
 /*
@@ -2307,13 +2312,14 @@ sys_rt_sigqueueinfo(int pid, int sig, siginfo_t __user *uinfo)
 
 int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 {
+	struct task_struct *t = current;
 	struct k_sigaction *k;
 	sigset_t mask;
 
 	if (!valid_signal(sig) || sig < 1 || (act && sig_kernel_only(sig)))
 		return -EINVAL;
 
-	k = &current->sighand->action[sig-1];
+	k = &t->sighand->action[sig-1];
 
 	spin_lock_irq(&current->sighand->siglock);
 	if (oact)
@@ -2334,9 +2340,7 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 		 *   (for example, SIGCHLD), shall cause the pending signal to
 		 *   be discarded, whether or not it is blocked"
 		 */
-		if (act->sa.sa_handler == SIG_IGN ||
-		   (act->sa.sa_handler == SIG_DFL && sig_kernel_ignore(sig))) {
-			struct task_struct *t = current;
+		if (__sig_ignored(t, sig)) {
 			sigemptyset(&mask);
 			sigaddset(&mask, sig);
 			rm_from_queue_full(&mask, &t->signal->shared_pending);
-- 
1.5.3.4



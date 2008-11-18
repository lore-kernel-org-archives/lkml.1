Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYKRQ7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYKRQ7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbYKRQ6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:58:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46018 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbYKRQ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:58:49 -0500
Date: Tue, 18 Nov 2008 18:59:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] simplify sig_ignored() pathes
Message-ID: <20081118175905.GA17142@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code which checks for ignored signals is a bit overcomplicated
because tracehook_consider_ignored_signal() wants the "handler" arg.
Can't we kill it? It is not used even with utrace, and even if it will
be used later it is OK to read ->sighand again in the slow path.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- K-IS/include/linux/tracehook.h~2_SIG_IGNORED	2008-11-10 19:21:17.000000000 +0100
+++ K-IS/include/linux/tracehook.h	2008-11-17 22:01:28.000000000 +0100
@@ -388,17 +388,14 @@ static inline void tracehook_signal_hand
  * tracehook_consider_ignored_signal - suppress short-circuit of ignored signal
  * @task:		task receiving the signal
  * @sig:		signal number being sent
- * @handler:		%SIG_IGN or %SIG_DFL
  *
  * Return zero iff tracing doesn't care to examine this ignored signal,
  * so it can short-circuit normal delivery and never even get queued.
- * Either @handler is %SIG_DFL and @sig's default is ignore, or it's %SIG_IGN.
  *
  * Called with @task->sighand->siglock held.
  */
 static inline int tracehook_consider_ignored_signal(struct task_struct *task,
-						    int sig,
-						    void __user *handler)
+						    int sig)
 {
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
--- K-IS/kernel/signal.c~2_SIG_IGNORED	2008-11-17 19:54:09.000000000 +0100
+++ K-IS/kernel/signal.c	2008-11-17 22:01:28.000000000 +0100
@@ -41,44 +41,33 @@
 
 static struct kmem_cache *sigqueue_cachep;
 
-static void __user *sig_handler(struct task_struct *t, int sig)
+static int sig_task_ignored(struct task_struct *t, int sig)
 {
 	void __user *h = t->sighand->action[sig - 1].sa.sa_handler;
 
-	/* drop SIGKILL early to not confuse wait_xxx_killable/etc */
-	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) && h == SIG_DFL)
-		h = SIG_IGN;
-
-	return h;
-}
-
-static int sig_handler_ignored(void __user *handler, int sig)
-{
-	/* Is it explicitly or implicitly ignored? */
-	return handler == SIG_IGN ||
-		(handler == SIG_DFL && sig_kernel_ignore(sig));
+	if (h == SIG_DFL) {
+		/* init drops SIGKILL early to not confuse xxx_killable/etc */
+		return sig_kernel_ignore(sig) ||
+			unlikely(t->signal->flags & SIGNAL_UNKILLABLE);
+	}
+	return h == SIG_IGN;
 }
 
 static int sig_ignored(struct task_struct *t, int sig)
 {
-	void __user *handler;
-
 	/*
 	 * Blocked signals are never ignored, since the
 	 * signal handler may change by the time it is
 	 * unblocked.
 	 */
-	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
-		return 0;
-
-	handler = sig_handler(t, sig);
-	if (!sig_handler_ignored(handler, sig))
+	if (sigismember(&t->blocked, sig) ||
+	    sigismember(&t->real_blocked, sig) ||
+	    !sig_task_ignored(t, sig))
 		return 0;
-
 	/*
 	 * Tracers may want to know about even ignored signals.
 	 */
-	return !tracehook_consider_ignored_signal(t, sig, handler);
+	return !tracehook_consider_ignored_signal(t, sig);
 }
 
 /*
@@ -2338,7 +2327,7 @@ int do_sigaction(int sig, struct k_sigac
 		 *   (for example, SIGCHLD), shall cause the pending signal to
 		 *   be discarded, whether or not it is blocked"
 		 */
-		if (sig_handler_ignored(sig_handler(t, sig), sig)) {
+		if (sig_task_ignored(t, sig)) {
 			sigemptyset(&mask);
 			sigaddset(&mask, sig);
 			rm_from_queue_full(&mask, &t->signal->shared_pending);


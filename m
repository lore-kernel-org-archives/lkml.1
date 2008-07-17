Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbYGQHb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbYGQHb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbYGQHaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:30:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629AbYGQHaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:30:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 11/23] tracehook: tracehook_consider_ignored_signal
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
Emacs: a learning curve that you can use as a plumb line.
Message-Id: <20080717073011.DC1B01541A5@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:30:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defines tracehook_consider_ignored_signal() has a fine-grained
hook for deciding to prevent the normal short-circuit of sending an
ignored signal, as ptrace does.  There is no change, only cleanup.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   19 +++++++++++++++++++
 kernel/signal.c           |   27 ++++++++++++++++-----------
 2 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 2d1426f..8cffd34 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -312,4 +312,23 @@ static inline void tracehook_signal_handler(int sig, siginfo_t *info,
 		ptrace_notify(SIGTRAP);
 }
 
+/**
+ * tracehook_consider_ignored_signal - suppress short-circuit of ignored signal
+ * @task:		task receiving the signal
+ * @sig:		signal number being sent
+ * @handler:		%SIG_IGN or %SIG_DFL
+ *
+ * Return zero iff tracing doesn't care to examine this ignored signal,
+ * so it can short-circuit normal delivery and never even get queued.
+ * Either @handler is %SIG_DFL and @sig's default is ignore, or it's %SIG_IGN.
+ *
+ * Called with @task->sighand->siglock held.
+ */
+static inline int tracehook_consider_ignored_signal(struct task_struct *task,
+						    int sig,
+						    void __user *handler)
+{
+	return (task_ptrace(task) & PT_PTRACED) != 0;
+}
+
 #endif	/* <linux/tracehook.h> */
diff --git a/kernel/signal.c b/kernel/signal.c
index 02d3a11..f68fb01 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -22,6 +22,7 @@
 #include <linux/ptrace.h>
 #include <linux/signal.h>
 #include <linux/signalfd.h>
+#include <linux/tracehook.h>
 #include <linux/capability.h>
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
@@ -39,24 +40,21 @@
 
 static struct kmem_cache *sigqueue_cachep;
 
-static int __sig_ignored(struct task_struct *t, int sig)
+static void __user *sig_handler(struct task_struct *t, int sig)
 {
-	void __user *handler;
+	return t->sighand->action[sig - 1].sa.sa_handler;
+}
 
+static int sig_handler_ignored(void __user *handler, int sig)
+{
 	/* Is it explicitly or implicitly ignored? */
-
-	handler = t->sighand->action[sig - 1].sa.sa_handler;
 	return handler == SIG_IGN ||
 		(handler == SIG_DFL && sig_kernel_ignore(sig));
 }
 
 static int sig_ignored(struct task_struct *t, int sig)
 {
-	/*
-	 * Tracers always want to know about signals..
-	 */
-	if (t->ptrace & PT_PTRACED)
-		return 0;
+	void __user *handler;
 
 	/*
 	 * Blocked signals are never ignored, since the
@@ -66,7 +64,14 @@ static int sig_ignored(struct task_struct *t, int sig)
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	return __sig_ignored(t, sig);
+	handler = sig_handler(t, sig);
+	if (!sig_handler_ignored(handler, sig))
+		return 0;
+
+	/*
+	 * Tracers may want to know about even ignored signals.
+	 */
+	return !tracehook_consider_ignored_signal(t, sig, handler);
 }
 
 /*
@@ -2324,7 +2329,7 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 		 *   (for example, SIGCHLD), shall cause the pending signal to
 		 *   be discarded, whether or not it is blocked"
 		 */
-		if (__sig_ignored(t, sig)) {
+		if (sig_handler_ignored(sig_handler(t, sig), sig)) {
 			sigemptyset(&mask);
 			sigaddset(&mask, sig);
 			rm_from_queue_full(&mask, &t->signal->shared_pending);

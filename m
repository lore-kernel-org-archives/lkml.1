Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbYGQHc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbYGQHc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759324AbYGQHaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:30:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758628AbYGQHa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:30:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 12/23] tracehook: tracehook_consider_fatal_signal
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Shopping-List: (1) Ferocious cow carnations
   (2) Impractical officious snowbulbs
   (3) Topical expectorants
   (4) Laborious prosthetic rice hydrants
Message-Id: <20080717073023.4DB3A1541A5@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:30:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defines tracehook_consider_fatal_signal() has a fine-grained
hook for deciding to skip the special cases for a fatal signal,
as ptrace does.  There is no change, only cleanup.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   21 +++++++++++++++++++++
 kernel/signal.c           |    9 +++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 8cffd34..8b4c15e 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -331,4 +331,25 @@ static inline int tracehook_consider_ignored_signal(struct task_struct *task,
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
 
+/**
+ * tracehook_consider_fatal_signal - suppress special handling of fatal signal
+ * @task:		task receiving the signal
+ * @sig:		signal number being sent
+ * @handler:		%SIG_DFL or %SIG_IGN
+ *
+ * Return nonzero to prevent special handling of this termination signal.
+ * Normally @handler is %SIG_DFL.  It can be %SIG_IGN if @sig is ignored,
+ * in which case force_sig() is about to reset it to %SIG_DFL.
+ * When this returns zero, this signal might cause a quick termination
+ * that does not give the debugger a chance to intercept the signal.
+ *
+ * Called with or without @task->sighand->siglock held.
+ */
+static inline int tracehook_consider_fatal_signal(struct task_struct *task,
+						  int sig,
+						  void __user *handler)
+{
+	return (task_ptrace(task) & PT_PTRACED) != 0;
+}
+
 #endif	/* <linux/tracehook.h> */
diff --git a/kernel/signal.c b/kernel/signal.c
index f68fb01..860afb8 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -300,12 +300,12 @@ flush_signal_handlers(struct task_struct *t, int force_default)
 
 int unhandled_signal(struct task_struct *tsk, int sig)
 {
+	void __user *handler = tsk->sighand->action[sig-1].sa.sa_handler;
 	if (is_global_init(tsk))
 		return 1;
-	if (tsk->ptrace & PT_PTRACED)
+	if (handler != SIG_IGN && handler != SIG_DFL)
 		return 0;
-	return (tsk->sighand->action[sig-1].sa.sa_handler == SIG_IGN) ||
-		(tsk->sighand->action[sig-1].sa.sa_handler == SIG_DFL);
+	return !tracehook_consider_fatal_signal(tsk, sig, handler);
 }
 
 
@@ -770,7 +770,8 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 	if (sig_fatal(p, sig) &&
 	    !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT)) &&
 	    !sigismember(&t->real_blocked, sig) &&
-	    (sig == SIGKILL || !(t->ptrace & PT_PTRACED))) {
+	    (sig == SIGKILL ||
+	     !tracehook_consider_fatal_signal(t, sig, SIG_DFL))) {
 		/*
 		 * This signal will be fatal to the whole group.
 		 */

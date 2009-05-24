Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZEXUs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZEXUs0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 16:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZEXUsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 16:48:19 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:50010 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZEXUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 16:48:19 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 1/1] signal: make group kill signal fatal
Date: Sun, 24 May 2009 22:47:34 +0200
Message-Id: <1243198054-13816-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__fatal_signal_pending() returns now true only for a non-group sent
sigkill, i. e. for example tgkill, send_sig...

Use sigkill_pending() in __fatal_signal_pending() which adds a test also
for shared_pending queue.

Also grab siglock in __fatal_signal_pending().

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>
---
 kernel/signal.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index e964ad9..a12897a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -116,6 +116,16 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 	return ready !=	0;
 }
 
+/*
+ * Return nonzero if there is a SIGKILL that should be waking us up.
+ * Called with the siglock held.
+ */
+static int sigkill_pending(struct task_struct *tsk)
+{
+	return	sigismember(&tsk->pending.signal, SIGKILL) ||
+		sigismember(&tsk->signal->shared_pending.signal, SIGKILL);
+}
+
 #define PENDING(p,b) has_pending_signals(&(p)->signal, (b))
 
 static int recalc_sigpending_tsk(struct task_struct *t)
@@ -1033,7 +1043,13 @@ void zap_other_threads(struct task_struct *p)
 
 int __fatal_signal_pending(struct task_struct *tsk)
 {
-	return sigismember(&tsk->pending.signal, SIGKILL);
+	int ret;
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	ret = sigkill_pending(tsk);
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	return ret;
 }
 EXPORT_SYMBOL(__fatal_signal_pending);
 
@@ -1549,16 +1565,6 @@ static inline int may_ptrace_stop(void)
 }
 
 /*
- * Return nonzero if there is a SIGKILL that should be waking us up.
- * Called with the siglock held.
- */
-static int sigkill_pending(struct task_struct *tsk)
-{
-	return	sigismember(&tsk->pending.signal, SIGKILL) ||
-		sigismember(&tsk->signal->shared_pending.signal, SIGKILL);
-}
-
-/*
  * This must be called with current->sighand->siglock held.
  *
  * This should be the path for all ptrace stops.
-- 
1.6.3


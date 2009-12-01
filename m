Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZLARis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZLARis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZLARir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:38:47 -0500
Received: from www.tglx.de ([62.245.132.106]:50678 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbZLARiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:38:46 -0500
Date: Tue, 1 Dec 2009 18:37:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] audit: Call tty_audit_push_task() outside preempt disabled
 region
In-Reply-To: <alpine.LFD.2.00.0911301443110.2872@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912011608070.24119@localhost.localdomain>
References: <20091123145409.GA29627@wotan.suse.de>  <alpine.LFD.2.00.0911280927180.2561@localhost>  <20091130100041.GA29610@infradead.org>  <alpine.LFD.2.00.0911300722370.2872@localhost.localdomain>  <20091130174638.GA9782@elte.hu> 
 <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain> <1259616429.26472.499.camel@laptop> <alpine.LFD.2.00.0911302300550.24119@localhost.localdomain> <alpine.LFD.2.00.0911301409560.2872@localhost.localdomain> <alpine.LFD.2.00.0911302328350.24119@localhost.localdomain>
 <alpine.LFD.2.00.0911301443110.2872@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While auditing all tasklist_lock read_lock sites I stumbled over the
following call chain:

audit_prepare_user_tty()
  read_lock(&tasklist_lock);
  tty_audit_push_task();
     mutex_lock(&buf->mutex);

     --> buf->mutex is locked with preemption disabled.

Solve this by acquiring a reference to the task struct under
rcu_read_lock and call tty_audit_push_task outside of the preempt
disabled region.

Move all code which needs to be protected by sighand lock into
tty_audit_push_task() and use lock/unlock_sighand as we do not hold
tasklist_lock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/char/tty_audit.c |   29 +++++++++++++++++++++--------
 include/linux/tty.h      |    8 ++++----
 kernel/audit.c           |   25 +++++++++----------------
 3 files changed, 34 insertions(+), 28 deletions(-)

Index: linux-2.6-tip/drivers/char/tty_audit.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/tty_audit.c
+++ linux-2.6-tip/drivers/char/tty_audit.c
@@ -188,25 +188,38 @@ void tty_audit_tiocsti(struct tty_struct
 }
 
 /**
- *	tty_audit_push_task	-	Flush task's pending audit data
+ * tty_audit_push_task	-	Flush task's pending audit data
+ * @tsk:		task pointer
+ * @loginuid:		sender login uid
+ * @sessionid:		sender session id
+ *
+ * Called with a ref on @tsk held. Try to lock sighand and get a
+ * reference to the tty audit buffer if available.
+ * Flush the buffer or return an appropriate error code.
  */
-void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid, u32 sessionid)
+int tty_audit_push_task(struct task_struct *tsk, uid_t loginuid, u32 sessionid)
 {
-	struct tty_audit_buf *buf;
+	struct tty_audit_buf *buf = NULL;
+	unsigned long flags;
 
-	spin_lock_irq(&tsk->sighand->siglock);
-	buf = tsk->signal->tty_audit_buf;
-	if (buf)
+	if (!lock_task_sighand(tsk, &flags))
+		return -ESRCH;
+
+	if (tsk->signal->audit_tty && tsk->signal->tty_audit_buf) {
+		buf = tsk->signal->tty_audit_buf;
 		atomic_inc(&buf->count);
-	spin_unlock_irq(&tsk->sighand->siglock);
+	}
+	unlock_task_sighand(tsk, &flags);
+
 	if (!buf)
-		return;
+		return -EPERM;
 
 	mutex_lock(&buf->mutex);
 	tty_audit_buf_push(tsk, loginuid, sessionid, buf);
 	mutex_unlock(&buf->mutex);
 
 	tty_audit_buf_put(buf);
+	return 0;
 }
 
 /**
Index: linux-2.6-tip/include/linux/tty.h
===================================================================
--- linux-2.6-tip.orig/include/linux/tty.h
+++ linux-2.6-tip/include/linux/tty.h
@@ -494,8 +494,8 @@ extern void tty_audit_exit(void);
 extern void tty_audit_fork(struct signal_struct *sig);
 extern void tty_audit_tiocsti(struct tty_struct *tty, char ch);
 extern void tty_audit_push(struct tty_struct *tty);
-extern void tty_audit_push_task(struct task_struct *tsk,
-					uid_t loginuid, u32 sessionid);
+extern int tty_audit_push_task(struct task_struct *tsk,
+			       uid_t loginuid, u32 sessionid);
 #else
 static inline void tty_audit_add_data(struct tty_struct *tty,
 				      unsigned char *data, size_t size)
@@ -513,8 +513,8 @@ static inline void tty_audit_fork(struct
 static inline void tty_audit_push(struct tty_struct *tty)
 {
 }
-static inline void tty_audit_push_task(struct task_struct *tsk,
-					uid_t loginuid, u32 sessionid)
+static inline int tty_audit_push_task(struct task_struct *tsk,
+				      uid_t loginuid, u32 sessionid)
 {
 }
 #endif
Index: linux-2.6-tip/kernel/audit.c
===================================================================
--- linux-2.6-tip.orig/kernel/audit.c
+++ linux-2.6-tip/kernel/audit.c
@@ -467,23 +467,16 @@ static int audit_prepare_user_tty(pid_t 
 	struct task_struct *tsk;
 	int err;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	tsk = find_task_by_vpid(pid);
-	err = -ESRCH;
-	if (!tsk)
-		goto out;
-	err = 0;
-
-	spin_lock_irq(&tsk->sighand->siglock);
-	if (!tsk->signal->audit_tty)
-		err = -EPERM;
-	spin_unlock_irq(&tsk->sighand->siglock);
-	if (err)
-		goto out;
-
-	tty_audit_push_task(tsk, loginuid, sessionid);
-out:
-	read_unlock(&tasklist_lock);
+	if (!tsk) {
+		rcu_read_unlock();
+		return -ESRCH;
+	}
+	get_task_struct(tsk);
+	rcu_read_unlock();
+	err = tty_audit_push_task(tsk, loginuid, sessionid);
+	put_task_struct(tsk);
 	return err;
 }
 

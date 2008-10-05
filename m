Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYJEQUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYJEQUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757065AbYJEQPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:15:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49620 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757017AbYJEQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:15:37 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 43/76] tty: Redo current tty locking
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:15:37 +0100
Message-ID: <20081005161532.1997.19318.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it is sometimes locked by the tty mutex and sometimes by the
sighand lock. The latter is in fact correct and now we can hand back referenced
objects we can fix this up without problems around sleeping functions.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c    |   18 ++++--------------
 fs/dquot.c               |    2 --
 include/linux/tty.h      |    1 +
 security/selinux/hooks.c |    2 --
 4 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index b5f57d0..f40298e 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -739,13 +739,11 @@ void tty_vhangup_self(void)
 {
 	struct tty_struct *tty;
 
-	mutex_lock(&tty_mutex);
 	tty = get_current_tty();
 	if (tty) {
 		tty_vhangup(tty);
 		tty_kref_put(tty);
 	}
-	mutex_unlock(&tty_mutex);
 }
 
 /**
@@ -801,11 +799,9 @@ void disassociate_ctty(int on_exit)
 	struct pid *tty_pgrp = NULL;
 
 
-	mutex_lock(&tty_mutex);
 	tty = get_current_tty();
 	if (tty) {
 		tty_pgrp = get_pid(tty->pgrp);
-		mutex_unlock(&tty_mutex);
 		lock_kernel();
 		if (on_exit && tty->driver->type != TTY_DRIVER_TYPE_PTY)
 			tty_vhangup(tty);
@@ -822,7 +818,6 @@ void disassociate_ctty(int on_exit)
 			kill_pgrp(old_pgrp, SIGCONT, on_exit);
 			put_pid(old_pgrp);
 		}
-		mutex_unlock(&tty_mutex);
 		return;
 	}
 	if (tty_pgrp) {
@@ -837,7 +832,6 @@ void disassociate_ctty(int on_exit)
 	current->signal->tty_old_pgrp = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
 
-	mutex_lock(&tty_mutex);
 	tty = get_current_tty();
 	if (tty) {
 		unsigned long flags;
@@ -854,7 +848,6 @@ void disassociate_ctty(int on_exit)
 		       " = NULL", tty);
 #endif
 	}
-	mutex_unlock(&tty_mutex);
 
 	/* Now clear signal->tty under the lock */
 	read_lock(&tasklist_lock);
@@ -3180,14 +3173,11 @@ static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 struct tty_struct *get_current_tty(void)
 {
 	struct tty_struct *tty;
-	WARN_ON_ONCE(!mutex_is_locked(&tty_mutex));
+	unsigned long flags;
+
+	spin_lock_irqsave(&current->sighand->siglock, flags);
 	tty = tty_kref_get(current->signal->tty);
-	/*
-	 * session->tty can be changed/cleared from under us, make sure we
-	 * issue the load. The obtained pointer, when not NULL, is valid as
-	 * long as we hold tty_mutex.
-	 */
-	barrier();
+	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 	return tty;
 }
 EXPORT_SYMBOL_GPL(get_current_tty);
diff --git a/fs/dquot.c b/fs/dquot.c
index 7417a6c..ad7e590 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -895,9 +895,7 @@ static void print_warning(struct dquot *dquot, const int warntype)
 	    warntype == QUOTA_NL_BSOFTBELOW || !need_print_warning(dquot))
 		return;
 
-	mutex_lock(&tty_mutex);
 	tty = get_current_tty();
-	mutex_unlock(&tty_mutex);
 	if (!tty)
 		return;
 	tty_write_message(tty, dquot->dq_sb->s_id);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index c30ed8d..e00393a 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -361,6 +361,7 @@ extern int is_ignored(int sig);
 extern int tty_signal(int sig, struct tty_struct *tty);
 extern void tty_hangup(struct tty_struct *tty);
 extern void tty_vhangup(struct tty_struct *tty);
+extern void tty_vhangup_self(void);
 extern void tty_unhangup(struct file *filp);
 extern int tty_hung_up_p(struct file *filp);
 extern void do_SAK(struct tty_struct *tty);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index c856db8..215cddd 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2120,9 +2120,7 @@ static inline void flush_unauthorized_files(struct files_struct *files)
 	long j = -1;
 	int drop_tty = 0;
 
-	mutex_lock(&tty_mutex);
 	tty = get_current_tty();
-	mutex_unlock(&tty_mutex);
 	if (tty) {
 		file_list_lock();
 		file = list_entry(tty->tty_files.next, typeof(*file), f_u.fu_list);


Return-Path: <linux-kernel-owner+w=401wt.eu-S1763233AbYJMJvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763233AbYJMJvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761883AbYJMJkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:40:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48691 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761857AbYJMJkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:40:51 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 49/80] tty: Redo current tty locking
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:40:43 +0100
Message-ID: <20081013094035.21645.340.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Currently it is sometimes locked by the tty mutex and sometimes by the
sighand lock. The latter is in fact correct and now we can hand back referenced
objects we can fix this up without problems around sleeping functions.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c      |   18 ++++--------------
 drivers/s390/char/fs3270.c |    1 +
 fs/dquot.c                 |    2 --
 security/selinux/hooks.c   |    2 --
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
diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index 3ef5425..84fbc90 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -431,6 +431,7 @@ fs3270_open(struct inode *inode, struct file *filp)
 		tty = get_current_tty();
 		if (!tty || tty->driver->major != IBM_TTY3270_MAJOR) {
 			tty_kref_put(tty);
+			mutex_unlock(&tty_mutex);
 			rc = -ENODEV;
 			goto out;
 		}
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
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 089d61a..4888139 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2121,9 +2121,7 @@ static inline void flush_unauthorized_files(struct files_struct *files)
 	long j = -1;
 	int drop_tty = 0;
 
-	mutex_lock(&tty_mutex);
 	tty = get_current_tty();
-	mutex_unlock(&tty_mutex);
 	if (tty) {
 		file_list_lock();
 		file = list_entry(tty->tty_files.next, typeof(*file), f_u.fu_list);


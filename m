Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbYJEQRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbYJEQRc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbYJEQKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:10:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48484 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757116AbYJEQKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:10:42 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 36/76] tty: Make get_current_tty use a kref
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:10:42 +0100
Message-ID: <20081005161021.1997.38953.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now return a kref covered tty reference. That ensures the tty structure
doesn't go away when you have a return from get_current_tty. This is not
enough to protect you from most of the resources being freed behind your
back - yet.

[Updated to include fixes for SELinux problems found by Andrew Morton and
 an s390 leak found while debugging the former]

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c      |   10 ++++++----
 drivers/s390/char/fs3270.c |    3 ++-
 fs/dquot.c                 |    6 +++---
 security/selinux/hooks.c   |    3 ++-
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 9a76db3..4c0e4ed 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -786,12 +786,12 @@ void disassociate_ctty(int on_exit)
 	tty = get_current_tty();
 	if (tty) {
 		tty_pgrp = get_pid(tty->pgrp);
-		lock_kernel();
 		mutex_unlock(&tty_mutex);
-		/* XXX: here we race, there is nothing protecting tty */
+		lock_kernel();
 		if (on_exit && tty->driver->type != TTY_DRIVER_TYPE_PTY)
 			tty_vhangup(tty);
 		unlock_kernel();
+		tty_kref_put(tty);
 	} else if (on_exit) {
 		struct pid *old_pgrp;
 		spin_lock_irq(&current->sighand->siglock);
@@ -819,7 +819,6 @@ void disassociate_ctty(int on_exit)
 	spin_unlock_irq(&current->sighand->siglock);
 
 	mutex_lock(&tty_mutex);
-	/* It is possible that do_tty_hangup has free'd this tty */
 	tty = get_current_tty();
 	if (tty) {
 		unsigned long flags;
@@ -829,6 +828,7 @@ void disassociate_ctty(int on_exit)
 		tty->session = NULL;
 		tty->pgrp = NULL;
 		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+		tty_kref_put(tty);
 	} else {
 #ifdef TTY_DEBUG_HANGUP
 		printk(KERN_DEBUG "error attempted to write to tty [0x%p]"
@@ -1806,6 +1806,8 @@ retry_open:
 		index = tty->index;
 		filp->f_flags |= O_NONBLOCK; /* Don't let /dev/tty block */
 		/* noctty = 1; */
+		/* FIXME: Should we take a driver reference ? */
+		tty_kref_put(tty);
 		goto got_driver;
 	}
 #ifdef CONFIG_VT
@@ -3135,7 +3137,7 @@ struct tty_struct *get_current_tty(void)
 {
 	struct tty_struct *tty;
 	WARN_ON_ONCE(!mutex_is_locked(&tty_mutex));
-	tty = current->signal->tty;
+	tty = tty_kref_get(current->signal->tty);
 	/*
 	 * session->tty can be changed/cleared from under us, make sure we
 	 * issue the load. The obtained pointer, when not NULL, is valid as
diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index d18e6d2..3ef5425 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -430,11 +430,12 @@ fs3270_open(struct inode *inode, struct file *filp)
 		mutex_lock(&tty_mutex);
 		tty = get_current_tty();
 		if (!tty || tty->driver->major != IBM_TTY3270_MAJOR) {
-			mutex_unlock(&tty_mutex);
+			tty_kref_put(tty);
 			rc = -ENODEV;
 			goto out;
 		}
 		minor = tty->index + RAW3270_FIRSTMINOR;
+		tty_kref_put(tty);
 		mutex_unlock(&tty_mutex);
 	}
 	/* Check if some other program is already using fullscreen mode. */
diff --git a/fs/dquot.c b/fs/dquot.c
index 8ec4d6c..7417a6c 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -897,8 +897,9 @@ static void print_warning(struct dquot *dquot, const int warntype)
 
 	mutex_lock(&tty_mutex);
 	tty = get_current_tty();
+	mutex_unlock(&tty_mutex);
 	if (!tty)
-		goto out_lock;
+		return;
 	tty_write_message(tty, dquot->dq_sb->s_id);
 	if (warntype == QUOTA_NL_ISOFTWARN || warntype == QUOTA_NL_BSOFTWARN)
 		tty_write_message(tty, ": warning, ");
@@ -926,8 +927,7 @@ static void print_warning(struct dquot *dquot, const int warntype)
 			break;
 	}
 	tty_write_message(tty, msg);
-out_lock:
-	mutex_unlock(&tty_mutex);
+	tty_kref_put(tty);
 }
 #endif
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 03fc6a8..c856db8 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2122,6 +2122,7 @@ static inline void flush_unauthorized_files(struct files_struct *files)
 
 	mutex_lock(&tty_mutex);
 	tty = get_current_tty();
+	mutex_unlock(&tty_mutex);
 	if (tty) {
 		file_list_lock();
 		file = list_entry(tty->tty_files.next, typeof(*file), f_u.fu_list);
@@ -2138,8 +2139,8 @@ static inline void flush_unauthorized_files(struct files_struct *files)
 			}
 		}
 		file_list_unlock();
+		tty_kref_put(tty);
 	}
-	mutex_unlock(&tty_mutex);
 	/* Reset controlling tty. */
 	if (drop_tty)
 		no_tty();


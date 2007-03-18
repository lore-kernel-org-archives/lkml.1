Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbXCRTJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbXCRTJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933051AbXCRTJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:09:49 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47384 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057AbXCRTJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:09:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Catalin Marinas" <catalin.marinas@gmail.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 3/4] tty: Introduce no_tty and use it in selinux
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	<m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703090844i6459372auba8e408ccce0c1f0@mail.gmail.com>
	<m1lki64a3i.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703120807t796e6c62k2422a93f6161db3a@mail.gmail.com>
	<m1veh5q6s7.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703140259p773b0eb8p9c142d33934e64ff@mail.gmail.com>
	<m1wt1jq45w.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703141008o4d6cb243r7bc328d79cccfa2e@mail.gmail.com>
	<m1slc4luf5.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703161544h2961670dh8f5e499fd2dc0ce5@mail.gmail.com>
	<m1vegyjspz.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6rmjsev.fsf_-_@ebiederm.dsl.xmission.com>
	<m1mz2ajs6g.fsf_-_@ebiederm.dsl.xmission.com>
	<m1fy82jrwz.fsf_-_@ebiederm.dsl.xmission.com>
Date: Sun, 18 Mar 2007 13:08:34 -0600
In-Reply-To: <m1fy82jrwz.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Sun, 18 Mar 2007 13:03:08 -0600")
Message-ID: <m1bqiqjrnx.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While researching the tty layer pid leaks I found a weird case in
selinux when we drop a controlling tty because of inadequate
permissions we don't do the normal hangup processing.  Which is a
problem if it happens the session  leader has exec'd something that
can no longer access the tty.

We already have code in the kernel to handle this case in the form of
the TIOCNOTTY ioctl.  So this patch factors out a helper function that
is the essence of that ioctl and calls it from the selinux code.

This removes the inconsistency in handling dropping of a controlling
tty and who knows it might even make some part of user space happy
because it received a SIGHUP it was expecting.

In addition since this removes the last user of proc_set_tty outside
of tty_io.c proc_set_tty is made static and removed from tty.h

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/char/tty_io.c    |   19 +++++++++++++++----
 include/linux/tty.h      |    2 +-
 security/selinux/hooks.c |    7 +++----
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 01fcfaf..0843fcb 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -156,6 +156,7 @@ int tty_ioctl(struct inode * inode, struct file * file,
 static int tty_fasync(int fd, struct file * filp, int on);
 static void release_tty(struct tty_struct *tty, int idx);
 static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
+static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 
 /**
  *	alloc_tty_struct	-	allocate a tty object
@@ -1560,6 +1561,18 @@ void disassociate_ctty(int on_exit)
 	unlock_kernel();
 }
 
+/**
+ *
+ *	no_tty	- Ensure the current process does not have a controlling tty
+ */
+void no_tty(void)
+{
+	struct task_struct *tsk = current;
+	if (tsk->signal->leader)
+		disassociate_ctty(0);
+	proc_clear_tty(tsk);
+}
+
 
 /**
  *	stop_tty	-	propogate flow control
@@ -3282,9 +3295,7 @@ int tty_ioctl(struct inode * inode, struct file * file,
 		case TIOCNOTTY:
 			if (current->signal->tty != tty)
 				return -ENOTTY;
-			if (current->signal->leader)
-				disassociate_ctty(0);
-			proc_clear_tty(current);
+			no_tty();
 			return 0;
 		case TIOCSCTTY:
 			return tiocsctty(tty, arg);
@@ -3847,7 +3858,7 @@ static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 	tsk->signal->tty_old_pgrp = NULL;
 }
 
-void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
 	spin_lock_irq(&tsk->sighand->siglock);
 	__proc_set_tty(tsk, tty);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index dee72b9..bb45760 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -313,6 +313,7 @@ extern int tty_hung_up_p(struct file * filp);
 extern void do_SAK(struct tty_struct *tty);
 extern void __do_SAK(struct tty_struct *tty);
 extern void disassociate_ctty(int priv);
+extern void no_tty(void);
 extern void tty_flip_buffer_push(struct tty_struct *tty);
 extern speed_t tty_get_baud_rate(struct tty_struct *tty);
 extern speed_t tty_termios_baud_rate(struct ktermios *termios);
@@ -333,7 +334,6 @@ extern int tty_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 
 extern dev_t tty_devnum(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
-extern void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 extern struct tty_struct *get_current_tty(void);
 
 extern struct mutex tty_mutex;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 19a385e..90da0e2 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1758,12 +1758,11 @@ static inline void flush_unauthorized_files(struct files_struct * files)
 			}
 		}
 		file_list_unlock();
-
-		/* Reset controlling tty. */
-		if (drop_tty)
-			proc_set_tty(current, NULL);
 	}
 	mutex_unlock(&tty_mutex);
+	/* Reset controlling tty. */
+	if (drop_tty)
+		no_tty();
 
 	/* Revalidate access to inherited open files. */
 
-- 
1.5.0.g53756


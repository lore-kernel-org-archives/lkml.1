Return-Path: <linux-kernel-owner+w=401wt.eu-S932878AbXCRTEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbXCRTEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932991AbXCRTEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:04:05 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36904 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878AbXCRTEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:04:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Catalin Marinas" <catalin.marinas@gmail.com>
Subject: [PATCH 2/4] tty: Simplify calling of put_pid.
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
Date: Sun, 18 Mar 2007 13:03:08 -0600
In-Reply-To: <m1mz2ajs6g.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Sun, 18 Mar 2007 12:57:27 -0600")
Message-ID: <m1fy82jrwz.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch should contain no functional changes.

At somepoint I got confused and thought put_pid could not
be called while a spin lock was held.  While it may be nice
to avoid that to reduce lock hold times put_pid can be safely
called while we hold a spin lock.

This patch removes all of the complications from the code
introduced by my misunderstanding, making the code a little
more readable.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/char/tty_io.c |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 583730f..01fcfaf 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -155,8 +155,7 @@ int tty_ioctl(struct inode * inode, struct file * file,
 	      unsigned int cmd, unsigned long arg);
 static int tty_fasync(int fd, struct file * filp, int on);
 static void release_tty(struct tty_struct *tty, int idx);
-static struct pid *__proc_set_tty(struct task_struct *tsk,
-				struct tty_struct *tty);
+static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 
 /**
  *	alloc_tty_struct	-	allocate a tty object
@@ -1534,10 +1533,9 @@ void disassociate_ctty(int on_exit)
 	}
 
 	spin_lock_irq(&current->sighand->siglock);
-	tty_pgrp = current->signal->tty_old_pgrp;
+	put_pid(current->signal->tty_old_pgrp);
 	current->signal->tty_old_pgrp = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
-	put_pid(tty_pgrp);
 
 	mutex_lock(&tty_mutex);
 	/* It is possible that do_tty_hangup has free'd this tty */
@@ -2508,7 +2506,6 @@ static int tty_open(struct inode * inode, struct file * filp)
 	int index;
 	dev_t device = inode->i_rdev;
 	unsigned short saved_flags = filp->f_flags;
-	struct pid *old_pgrp;
 
 	nonseekable_open(inode, filp);
 	
@@ -2602,17 +2599,15 @@ got_driver:
 		goto retry_open;
 	}
 
-	old_pgrp = NULL;
 	mutex_lock(&tty_mutex);
 	spin_lock_irq(&current->sighand->siglock);
 	if (!noctty &&
 	    current->signal->leader &&
 	    !current->signal->tty &&
 	    tty->session == NULL)
-		old_pgrp = __proc_set_tty(current, tty);
+		__proc_set_tty(current, tty);
 	spin_unlock_irq(&current->sighand->siglock);
 	mutex_unlock(&tty_mutex);
-	put_pid(old_pgrp);
 	return 0;
 }
 
@@ -3838,9 +3833,8 @@ void proc_clear_tty(struct task_struct *p)
 	spin_unlock_irq(&p->sighand->siglock);
 }
 
-static struct pid *__proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
-	struct pid *old_pgrp;
 	if (tty) {
 		/* We should not have a session or pgrp to here but.... */
 		put_pid(tty->session);
@@ -3848,21 +3842,16 @@ static struct pid *__proc_set_tty(struct task_struct *tsk, struct tty_struct *tt
 		tty->session = get_pid(task_session(tsk));
 		tty->pgrp = get_pid(task_pgrp(tsk));
 	}
-	old_pgrp = tsk->signal->tty_old_pgrp;
+	put_pid(tsk->signal->tty_old_pgrp);
 	tsk->signal->tty = tty;
 	tsk->signal->tty_old_pgrp = NULL;
-	return old_pgrp;
 }
 
 void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
-	struct pid *old_pgrp;
-
 	spin_lock_irq(&tsk->sighand->siglock);
-	old_pgrp = __proc_set_tty(tsk, tty);
+	__proc_set_tty(tsk, tty);
 	spin_unlock_irq(&tsk->sighand->siglock);
-
-	put_pid(old_pgrp);
 }
 
 struct tty_struct *get_current_tty(void)
-- 
1.5.0.g53756


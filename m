Return-Path: <linux-kernel-owner+w=401wt.eu-S965980AbXCPWCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965980AbXCPWCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 18:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965984AbXCPWCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 18:02:03 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51650 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965980AbXCPWCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 18:02:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Catalin Marinas" <catalin.marinas@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Possible "struct pid" leak from tty_io.c
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	<m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703090844i6459372auba8e408ccce0c1f0@mail.gmail.com>
	<m1lki64a3i.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703120807t796e6c62k2422a93f6161db3a@mail.gmail.com>
	<m1veh5q6s7.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703140259p773b0eb8p9c142d33934e64ff@mail.gmail.com>
	<m1wt1jq45w.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703141008o4d6cb243r7bc328d79cccfa2e@mail.gmail.com>
Date: Fri, 16 Mar 2007 16:01:34 -0600
In-Reply-To: <b0943d9e0703141008o4d6cb243r7bc328d79cccfa2e@mail.gmail.com>
	(Catalin Marinas's message of "Wed, 14 Mar 2007 17:08:34 +0000")
Message-ID: <m1slc4luf5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Catalin Marinas" <catalin.marinas@gmail.com> writes:

> On 14/03/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> How does this look?
>
> It seems to fix the leak. I looked at the logs and proc_set_tty calls
> put_pid twice for pid 245 (the unresolved leak) and get_pid for pid
> 296, which is later passed to put_pid via do_tty_hangup.

Ok.  Any chance you could help me track down which application is
ultimately calling proc_set_tty (I think it has pid 296 in your case).

>From what I can tell reading the source it is calling
TIOCSCTTY with the arg field set to 1.  Which is a linux extension
to force other people off of the tty.

My skimming of the implementation says to me that we are forcing
other processes of the tty in the wrong way.  I think we should call
tty_vhangup (so those processes kicked off get normal terminal hangup
behavior) and not simply session_clear_tty.  However if I am correct the
implementation has been broken for over a decade so I am reluctant to
just change it without tracking down the users.  

The patch below is what I am looking at for a comprehensive fix.  I
think it fixes the second set of leaks in a better manner by simply
fixing callers to do the sane thing.

Eric


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index e453268..5140f15 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1376,6 +1376,8 @@ static void do_tty_hangup(struct work_struct *work)
 	read_unlock(&tasklist_lock);
 
 	tty->flags = 0;
+	put_pid(tty->session);
+	put_pid(tty->pgrp);
 	tty->session = NULL;
 	tty->pgrp = NULL;
 	tty->ctrl_status = 0;
@@ -2972,9 +2974,7 @@ static int tiocsctty(struct tty_struct *tty, int arg)
 			/*
 			 * Steal it away
 			 */
-			read_lock(&tasklist_lock);
-			session_clear_tty(tty->session);
-			read_unlock(&tasklist_lock);
+			tty_vhangup(tty);
 		} else {
 			ret = -EPERM;
 			goto unlock;
@@ -3850,7 +3850,7 @@ static struct pid *__proc_set_tty(struct task_struct *tsk, struct tty_struct *tt
 	return old_pgrp;
 }
 
-void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
 	struct pid *old_pgrp;
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index dee72b9..5f7a5fb 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -333,7 +333,6 @@ extern int tty_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 
 extern dev_t tty_devnum(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
-extern void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 extern struct tty_struct *get_current_tty(void);
 
 extern struct mutex tty_mutex;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 19a385e..84b489a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1759,12 +1759,16 @@ static inline void flush_unauthorized_files(struct files_struct * files)
 		}
 		file_list_unlock();
 
-		/* Reset controlling tty. */
-		if (drop_tty)
-			proc_set_tty(current, NULL);
 	}
 	mutex_unlock(&tty_mutex);
 
+	/* Reset controlling tty. */
+	if (drop_tty) {
+		if (current->signal->leader)
+			disassociate_ctty(0);
+		proc_clear_tty(current);
+	}
+
 	/* Revalidate access to inherited open files. */
 
 	AVC_AUDIT_DATA_INIT(&ad,FS);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYBYRmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYBYRmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbYBYRmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:42:42 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:42170 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256AbYBYRmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:42:40 -0500
Date: Mon, 25 Feb 2008 20:42:28 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       David Quigley <dpquigl@tycho.nsa.gov>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Eric Paris <eparis@redhat.com>, Harald Welte <laforge@gnumonks.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] kill_pid_info_as_uid: don't use security_task_kill()
Message-ID: <20080225174228.GA22084@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kill_pid_info_as_uid() is solely used by drivers/usb/core/. The original
"[PATCH] Fix signal sending in usbdevio on async URB completion" commit
46113830a18847cff8da73005e57bc49c2f95a56 was right, but nowadays we use
struct pid and this solves most of the addressed problems.

It would be nice to use kill_pid_info() instead, but we can't because USB
uses .si_code = SI_ASYNCIO which fools SI_FROMUSER() and thus security checks.

I think we should omit the permission checks completely, the task which does
ioctl(USBDEVFS_SUBMITURB) explicitly asks to send the signal to it, we should
not deny the signal even if the task changes its credentials in any way.

For now, we can remove security_task_kill(). It is bogus, the signal has come
from kernel.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/sched.h    |    2 +-
 kernel/signal.c          |    5 +----
 drivers/usb/core/usb.h   |    1 -
 drivers/usb/core/devio.c |    7 ++-----
 drivers/usb/core/inode.c |    3 ++-
 5 files changed, 6 insertions(+), 12 deletions(-)

--- 25/include/linux/sched.h~2_KPIAU_NO_LSM	2008-02-15 16:59:17.000000000 +0300
+++ 25/include/linux/sched.h	2008-02-25 19:13:05.000000000 +0300
@@ -1690,7 +1690,7 @@ extern int force_sigsegv(int, struct tas
 extern int force_sig_info(int, struct siginfo *, struct task_struct *);
 extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
 extern int kill_pid_info(int sig, struct siginfo *info, struct pid *pid);
-extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *, uid_t, uid_t, u32);
+extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *, uid_t, uid_t);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
--- 25/kernel/signal.c~2_KPIAU_NO_LSM	2008-02-25 18:15:38.000000000 +0300
+++ 25/kernel/signal.c	2008-02-25 19:13:56.000000000 +0300
@@ -1078,7 +1078,7 @@ kill_proc_info(int sig, struct siginfo *
 
 /* like kill_pid_info(), but doesn't use uid/euid of "current" */
 int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
-		      uid_t uid, uid_t euid, u32 secid)
+		      uid_t uid, uid_t euid)
 {
 	int ret = -EINVAL;
 	struct task_struct *p;
@@ -1098,9 +1098,6 @@ int kill_pid_info_as_uid(int sig, struct
 		ret = -EPERM;
 		goto out_unlock;
 	}
-	ret = security_task_kill(p, info, sig, secid);
-	if (ret)
-		goto out_unlock;
 	if (sig && p->sighand) {
 		unsigned long flags;
 		spin_lock_irqsave(&p->sighand->siglock, flags);
--- 25/drivers/usb/core/usb.h~2_KPIAU_NO_LSM	2008-02-15 16:59:10.000000000 +0300
+++ 25/drivers/usb/core/usb.h	2008-02-25 19:16:37.000000000 +0300
@@ -155,7 +155,6 @@ struct dev_state {
 	uid_t disc_uid, disc_euid;
 	void __user *disccontext;
 	unsigned long ifclaimed;
-	u32 secid;
 };
 
 /* internal notify stuff */
--- 25/drivers/usb/core/devio.c~2_KPIAU_NO_LSM	2008-02-15 16:59:09.000000000 +0300
+++ 25/drivers/usb/core/devio.c	2008-02-25 19:19:55.000000000 +0300
@@ -72,7 +72,6 @@ struct async {
 	void __user *userurb;
 	struct urb *urb;
 	int status;
-	u32 secid;
 };
 
 static int usbfs_snoop;
@@ -321,8 +320,8 @@ static void async_completed(struct urb *
 		sinfo.si_errno = as->status;
 		sinfo.si_code = SI_ASYNCIO;
 		sinfo.si_addr = as->userurb;
-		kill_pid_info_as_uid(as->signr, &sinfo, as->pid, as->uid,
-				      as->euid, as->secid);
+		kill_pid_info_as_uid(as->signr, &sinfo, as->pid,
+					as->uid, as->euid);
 	}
 	snoop(&urb->dev->dev, "urb complete\n");
 	snoop_urb(urb, as->userurb);
@@ -603,7 +602,6 @@ static int usbdev_open(struct inode *ino
 	ps->disc_euid = current->euid;
 	ps->disccontext = NULL;
 	ps->ifclaimed = 0;
-	security_task_getsecid(current, &ps->secid);
 	smp_wmb();
 	list_add_tail(&ps->list, &dev->filelist);
 	file->private_data = ps;
@@ -1132,7 +1130,6 @@ static int proc_do_submiturb(struct dev_
 	as->pid = get_pid(task_pid(current));
 	as->uid = current->uid;
 	as->euid = current->euid;
-	security_task_getsecid(current, &as->secid);
 	if (!is_in) {
 		if (copy_from_user(as->urb->transfer_buffer, uurb->buffer,
 				as->urb->transfer_buffer_length)) {
--- 25/drivers/usb/core/inode.c~2_KPIAU_NO_LSM	2008-02-15 16:59:09.000000000 +0300
+++ 25/drivers/usb/core/inode.c	2008-02-25 19:21:09.000000000 +0300
@@ -728,7 +728,8 @@ static void usbfs_remove_device(struct u
 			sinfo.si_errno = EPIPE;
 			sinfo.si_code = SI_ASYNCIO;
 			sinfo.si_addr = ds->disccontext;
-			kill_pid_info_as_uid(ds->discsignr, &sinfo, ds->disc_pid, ds->disc_uid, ds->disc_euid, ds->secid);
+			kill_pid_info_as_uid(ds->discsignr, &sinfo, ds->disc_pid,
+						ds->disc_uid, ds->disc_euid);
 		}
 	}
 }


Return-Path: <linux-kernel-owner+w=401wt.eu-S1946184AbXBCAh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946184AbXBCAh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946186AbXBCAh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:37:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946184AbXBCAh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:37:57 -0500
Message-Id: <200702030036.l130aQnm020949@pasta.boston.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] tgid fixes for filp->f_owner.pid assignments
Date: Fri, 02 Feb 2007 19:36:26 -0500
From: Ernie Petrides <petrides@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't the f_owner.pid of the "file" structure hold the process id
("tgid" field of task_struct) as opposed to the thread id ("pid" field
of task_struct)?

If agreed, the patch below fixes the obvious places.  It seems to be
used for determining how to post SIGIO signals.  With current code,
in a multi-threaded process, I think only the thread arming the SIGIO
gets the signal, whereas it seems that the whole thread group should
be signaled.

This has only been compile-tested.

Cheers.  -ernie



Signed-off-by: Ernie Petrides <petrides@redhat.com>

--- linux-2.6.19/drivers/char/tty_io.c.orig
+++ linux-2.6.19/drivers/char/tty_io.c
@@ -2697,7 +2697,7 @@ static int tty_fasync(int fd, struct fil
 	if (on) {
 		if (!waitqueue_active(&tty->read_wait))
 			tty->minimum_to_wake = 1;
-		retval = f_setown(filp, (-tty->pgrp) ? : current->pid, 0);
+		retval = f_setown(filp, (-tty->pgrp) ? : current->tgid, 0);
 		if (retval)
 			return retval;
 	} else {
--- linux-2.6.19/drivers/net/tun.c.orig
+++ linux-2.6.19/drivers/net/tun.c
@@ -697,7 +697,7 @@ static int tun_chr_fasync(int fd, struct
 		return ret;
 
 	if (on) {
-		ret = __f_setown(file, task_pid(current), PIDTYPE_PID, 0);
+		ret = __f_setown(file, task_tgid(current), PIDTYPE_PID, 0);
 		if (ret)
 			return ret;
 		tun->flags |= TUN_FASYNC;
--- linux-2.6.19/fs/locks.c.orig
+++ linux-2.6.19/fs/locks.c
@@ -1514,7 +1514,7 @@ int fcntl_setlease(unsigned int fd, stru
 		goto out_unlock;
 	}
 
-	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
+	error = __f_setown(filp, task_tgid(current), PIDTYPE_PID, 0);
 out_unlock:
 	unlock_kernel();
 	return error;
--- linux-2.6.19/fs/dnotify.c.orig
+++ linux-2.6.19/fs/dnotify.c
@@ -92,7 +92,7 @@ int fcntl_dirnotify(int fd, struct file 
 		prev = &odn->dn_next;
 	}
 
-	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
+	error = __f_setown(filp, task_tgid(current), PIDTYPE_PID, 0);
 	if (error)
 		goto out_free;
 
--- linux-2.6.19/kernel/futex.c.orig
+++ linux-2.6.19/kernel/futex.c
@@ -1534,7 +1534,7 @@ static int futex_fd(u32 __user *uaddr, i
 	filp->f_mapping = filp->f_dentry->d_inode->i_mapping;
 
 	if (signal) {
-		err = __f_setown(filp, task_pid(current), PIDTYPE_PID, 1);
+		err = __f_setown(filp, task_tgid(current), PIDTYPE_PID, 1);
 		if (err < 0) {
 			goto error;
 		}

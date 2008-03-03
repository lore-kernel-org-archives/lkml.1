Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbYCCQds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbYCCQds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbYCCQdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:33:39 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42493 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751251AbYCCQdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:33:38 -0500
Date: Mon, 3 Mar 2008 16:22:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty_io: Fix remaining pid struct locking
Message-ID: <20080303162201.750aaeea@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the last couple of pid struct locking failures I know about.
Goes on top of the other -mm patches for pid struct locking in the tty
layer

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/tty_io.c linux-2.6.25-rc2-mm1/drivers/char/tty_io.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/tty_io.c	2008-02-19 11:03:26.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/tty_io.c	2008-02-25 09:29:22.000000000 +0000
@@ -3098,6 +3260,27 @@
 }
 
 /**
+ *	tty_get_pgrp	-	return a ref counted pgrp pid
+ *	@tty: tty to read
+ *
+ *	Returns a refcounted instance of the pid struct for the process
+ *	group controlling the tty.
+ */
+
+struct pid *tty_get_pgrp(struct tty_struct *tty)
+{
+	unsigned long flags;
+	struct pid *pgrp;
+	
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	pgrp = get_pid(tty->pgrp);
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	
+	return pgrp;
+}
+EXPORT_SYMBOL_GPL(tty_get_pgrp);
+
+/**
  *	tiocgpgrp		-	get process group
  *	@tty: tty passed by user
  *	@real_tty: tty side of the tty pased by the user if a pty else the tty
@@ -3111,13 +3294,18 @@
 
 static int tiocgpgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t __user *p)
 {
+	struct pid *pid;
+	int ret;
 	/*
 	 * (tty == real_tty) is a cheap way of
 	 * testing if the tty is NOT a master pty.
 	 */
 	if (tty == real_tty && current->signal->tty != real_tty)
 		return -ENOTTY;
-	return put_user(pid_vnr(real_tty->pgrp), p);
+	pid = tty_get_pgrp(real_tty);
+	ret =  put_user(pid_vnr(pid), p);
+	put_pid(pid);
+	return ret;
 }
 
 /**
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/fs/proc/array.c linux-2.6.25-rc2-mm1/fs/proc/array.c
--- linux.vanilla-2.6.25-rc2-mm1/fs/proc/array.c	2008-02-19 11:03:02.000000000 +0000
+++ linux-2.6.25-rc2-mm1/fs/proc/array.c	2008-02-25 09:28:29.000000000 +0000
@@ -408,6 +408,7 @@
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
+	struct pid *pgrp;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -430,7 +431,9 @@
 		struct signal_struct *sig = task->signal;
 
 		if (sig->tty) {
-			tty_pgrp = pid_nr_ns(sig->tty->pgrp, ns);
+			pgrp = tty_get_pgrp(sig->tty);
+			tty_pgrp = pid_nr_ns(pgrp, ns);
+			put_pid(pgrp);
 			tty_nr = new_encode_dev(tty_devnum(sig->tty));
 		}
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/include/linux/tty.h linux-2.6.25-rc2-mm1/include/linux/tty.h
--- linux.vanilla-2.6.25-rc2-mm1/include/linux/tty.h	2008-02-19 11:03:27.000000000 +0000
+++ linux-2.6.25-rc2-mm1/include/linux/tty.h	2008-02-25 09:27:37.000000000 +0000
@@ -295,6 +315,7 @@
 extern void tty_write_message(struct tty_struct *tty, char *msg);
 
 extern int is_current_pgrp_orphaned(void);
+extern struct pid *tty_get_pgrp(struct tty_struct *tty);
 extern int is_ignored(int sig);
 extern int tty_signal(int sig, struct tty_struct *tty);
 extern void tty_hangup(struct tty_struct * tty);

Return-Path: <linux-kernel-owner+w=401wt.eu-S933761AbYBTVG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbYBTVG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbYBTVGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:06:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47613 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753164AbYBTVGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:06:42 -0500
Date: Wed, 20 Feb 2008 20:57:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] redo locking of tty->pgrp
Message-ID: <20080220205737.1bdec9d6@core>
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

Historically tty->pgrp and friends were pid_t and the code "knew" they
were safe. The change to pid structs opened up a few races and the
removal of the BKL in places made them quite hittable. We put tty->pgrp
under the ctrl_lock for the tty.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/tty_io.c linux-2.6.25-rc2-mm1/drivers/char/tty_io.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/tty_io.c	2008-02-19 11:03:26.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/tty_io.c	2008-02-20 12:31:54.000000000 +0000
@@ -1162,26 +1162,37 @@
  *	not in the foreground, send a SIGTTOU.  If the signal is blocked or
  *	ignored, go ahead and perform the operation.  (POSIX 7.2)
  *
- *	Locking: none - FIXME: review this
+ *	Locking: ctrl_lock - FIXME: review this
  */
 
 int tty_check_change(struct tty_struct *tty)
 {
+	unsigned long flags;
+	int ret = 0;
+
 	if (current->signal->tty != tty)
 		return 0;
+
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+
 	if (!tty->pgrp) {
 		printk(KERN_WARNING "tty_check_change: tty->pgrp == NULL!\n");
-		return 0;
+		goto out;
 	}
 	if (task_pgrp(current) == tty->pgrp)
-		return 0;
+		goto out;
 	if (is_ignored(SIGTTOU))
-		return 0;
-	if (is_current_pgrp_orphaned())
-		return -EIO;
+		goto out;
+	if (is_current_pgrp_orphaned()) {
+		ret = -EIO;
+		goto out;
+	}
 	kill_pgrp(task_pgrp(current), SIGTTOU, 1);
 	set_thread_flag(TIF_SIGPENDING);
-	return -ERESTARTSYS;
+	ret = -ERESTARTSYS;
+out:
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	return ret;
 }
 
 EXPORT_SYMBOL(tty_check_change);
@@ -1361,6 +1372,7 @@
 	struct task_struct *p;
 	struct tty_ldisc *ld;
 	int    closecount = 0, n;
+	unsigned long flags;
 
 	if (!tty)
 		return;
@@ -1437,19 +1449,24 @@
 			__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
 			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
 			put_pid(p->signal->tty_old_pgrp);  /* A noop */
+			spin_lock_irqsave(&tty->ctrl_lock, flags);
 			if (tty->pgrp)
 				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
+			spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 			spin_unlock_irq(&p->sighand->siglock);
 		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
 	}
 	read_unlock(&tasklist_lock);
 
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
 	tty->flags = 0;
 	put_pid(tty->session);
 	put_pid(tty->pgrp);
 	tty->session = NULL;
 	tty->pgrp = NULL;
 	tty->ctrl_status = 0;
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+
 	/*
 	 * If one of the devices matches a console pointer, we
 	 * cannot just call hangup() because that will cause
@@ -1624,10 +1641,13 @@
 	/* It is possible that do_tty_hangup has free'd this tty */
 	tty = get_current_tty();
 	if (tty) {
+		unsigned long flags;
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		put_pid(tty->session);
 		put_pid(tty->pgrp);
 		tty->session = NULL;
 		tty->pgrp = NULL;
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	} else {
 #ifdef TTY_DEBUG_HANGUP
 		printk(KERN_DEBUG "error attempted to write to tty [0x%p]"
@@ -1743,10 +1763,8 @@
  *	for hung up devices before calling the line discipline method.
  *
  *	Locking:
- *		Locks the line discipline internally while needed
- *		For historical reasons the line discipline read method is
- *	invoked under the BKL. This will go away in time so do not rely on it
- *	in new code. Multiple read calls may be outstanding in parallel.
+ *		Locks the line discipline internally while needed. Multiple
+ *	read calls may be outstanding in parallel.
  */
 
 static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
@@ -2846,6 +2992,7 @@
 static int tty_fasync(int fd, struct file *filp, int on)
 {
 	struct tty_struct *tty;
+	unsigned long flags;
 	int retval;
 
 	tty = (struct tty_struct *)filp->private_data;
@@ -2861,6 +3008,7 @@
 		struct pid *pid;
 		if (!waitqueue_active(&tty->read_wait))
 			tty->minimum_to_wake = 1;
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		if (tty->pgrp) {
 			pid = tty->pgrp;
 			type = PIDTYPE_PGID;
@@ -2868,6 +3016,7 @@
 			pid = task_pid(current);
 			type = PIDTYPE_PID;
 		}
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		retval = __f_setown(filp, pid, type, 0);
 		if (retval)
 			return retval;
@@ -2953,6 +3102,8 @@
 	struct winsize __user *arg)
 {
 	struct winsize tmp_ws;
+	struct pid *pgrp, *rpgrp;
+	unsigned long flags;
 
 	if (copy_from_user(&tmp_ws, arg, sizeof(*arg)))
 		return -EFAULT;
@@ -2970,10 +3121,21 @@
 		}
 	}
 #endif
-	if (tty->pgrp)
-		kill_pgrp(tty->pgrp, SIGWINCH, 1);
-	if ((real_tty->pgrp != tty->pgrp) && real_tty->pgrp)
-		kill_pgrp(real_tty->pgrp, SIGWINCH, 1);
+	/* Get the PID values and reference them so we can
+	   avoid holding the tty ctrl lock while sending signals */
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	pgrp = get_pid(tty->pgrp);
+	rpgrp = get_pid(real_tty->pgrp);
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+
+	if (pgrp)
+		kill_pgrp(pgrp, SIGWINCH, 1);
+	if (rpgrp != pgrp && rpgrp)
+		kill_pgrp(rpgrp, SIGWINCH, 1);
+
+	put_pid(pgrp);
+	put_pid(rpgrp);
+
 	tty->winsize = tmp_ws;
 	real_tty->winsize = tmp_ws;
 done:
@@ -3129,7 +3291,7 @@
  *	Set the process group of the tty to the session passed. Only
  *	permitted where the tty session is our session.
  *
- *	Locking: RCU
+ *	Locking: RCU, ctrl lock
  */
 
 static int tiocspgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t __user *p)
@@ -3137,6 +3299,7 @@
 	struct pid *pgrp;
 	pid_t pgrp_nr;
 	int retval = tty_check_change(real_tty);
+	unsigned long flags;
 
 	if (retval == -EIO)
 		return -ENOTTY;
@@ -3159,8 +3322,10 @@
 	if (session_of_pgrp(pgrp) != task_session(current))
 		goto out_unlock;
 	retval = 0;
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
 	put_pid(real_tty->pgrp);
 	real_tty->pgrp = get_pid(pgrp);
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 out_unlock:
 	rcu_read_unlock();
 	return retval;
@@ -4030,14 +4187,19 @@
 }
 EXPORT_SYMBOL(proc_clear_tty);
 
+/* Called under the sighand lock */
+
 static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
 	if (tty) {
-		/* We should not have a session or pgrp to here but.... */
+		unsigned long flags;
+		/* We should not have a session or pgrp to put here but.... */
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		put_pid(tty->session);
 		put_pid(tty->pgrp);
-		tty->session = get_pid(task_session(tsk));
 		tty->pgrp = get_pid(task_pgrp(tsk));
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+		tty->session = get_pid(task_session(tsk));
 	}
 	put_pid(tsk->signal->tty_old_pgrp);
 	tsk->signal->tty = tty;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/vt.c linux-2.6.25-rc2-mm1/drivers/char/vt.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/vt.c	2008-02-19 11:03:26.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/vt.c	2008-02-20 16:46:03.000000000 +0000
@@ -907,15 +907,21 @@
 
 	if (vc->vc_tty) {
 		struct winsize ws, *cws = &vc->vc_tty->winsize;
+		unsigned long flags;
 
 		memset(&ws, 0, sizeof(ws));
 		ws.ws_row = vc->vc_rows;
 		ws.ws_col = vc->vc_cols;
 		ws.ws_ypixel = vc->vc_scan_lines;
+
+		mutex_lock(&vc->vc_tty->termios_mutex);
+		spin_lock_irqsave(&vc->vc_tty->ctrl_lock, flags);
 		if ((ws.ws_row != cws->ws_row || ws.ws_col != cws->ws_col) &&
 		    vc->vc_tty->pgrp)
 			kill_pgrp(vc->vc_tty->pgrp, SIGWINCH, 1);
+		spin_unlock_irqrestore(&vc->vc_tty->ctrl_lock, flags);
 		*cws = ws;
+		mutex_unlock(&vc->vc_tty->termios_mutex);
 	}
 
 	if (CON_IS_VISIBLE(vc))
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/include/linux/tty.h linux-2.6.25-rc2-mm1/include/linux/tty.h
--- linux.vanilla-2.6.25-rc2-mm1/include/linux/tty.h	2008-02-19 11:03:27.000000000 +0000
+++ linux-2.6.25-rc2-mm1/include/linux/tty.h	2008-02-20 11:54:51.000000000 +0000
@@ -184,21 +201,22 @@
 	struct tty_ldisc ldisc;
 	struct mutex termios_mutex;
 	spinlock_t ctrl_lock;
+	/* Termios values are protected by the termios mutex */
 	struct ktermios *termios, *termios_locked;
 	char name[64];
-	struct pid *pgrp;
+	struct pid *pgrp;		/* Protected by ctrl lock */
 	struct pid *session;
 	unsigned long flags;
 	int count;
-	struct winsize winsize;
+	struct winsize winsize;		/* termios mutex */
 	unsigned char stopped:1, hw_stopped:1, flow_stopped:1, packet:1;
 	unsigned char low_latency:1, warned:1;
-	unsigned char ctrl_status;
+	unsigned char ctrl_status;	/* ctrl_lock */
 	unsigned int receive_room;	/* Bytes free for queue */
 
 	struct tty_struct *link;
 	struct fasync_struct *fasync;
-	struct tty_bufhead buf;
+	struct tty_bufhead buf;		/* Locked internally */
 	int alt_speed;		/* For magic substitution of 38400 bps */
 	wait_queue_head_t write_wait;
 	wait_queue_head_t read_wait;
@@ -212,6 +230,7 @@
 	/*
 	 * The following is data for the N_TTY line discipline.  For
 	 * historical reasons, this is included in the tty structure.
+	 * Mostly locked by the BKL.
 	 */
 	unsigned int column;
 	unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;

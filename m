Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbYBHPsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYBHPsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 10:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbYBHPsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 10:48:36 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58672 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751311AbYBHPse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 10:48:34 -0500
Date: Fri, 8 Feb 2008 15:42:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: BKL pushdown
Message-ID: <20080208154208.0efd6885@core>
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

- Push the BKL down into the line disciplines
- Switch the tty layer to unlocked_ioctl
- Introduce a new ctrl_lock spin lock for the control bits
- Eliminate much of the lock_kernel use in n_tty
- Prepare to (but don't yet) call the drivers with the lock dropped
  on the paths that historically held the lock

BKL now primarily protects open/close/ldisc change in the tty layer

I'm sure this will break something so it wants to stew in -mm for a
little while.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-mm1/drivers/char/n_hdlc.c linux-2.6.24-mm1/drivers/char/n_hdlc.c
--- linux.vanilla-2.6.24-mm1/drivers/char/n_hdlc.c	2008-02-06 14:13:24.000000000 +0000
+++ linux-2.6.24-mm1/drivers/char/n_hdlc.c	2008-02-06 14:33:00.000000000 +0000
@@ -578,26 +578,36 @@
 		return -EFAULT;
 	}
 
+	lock_kernel();
+	
 	for (;;) {
-		if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
+		if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
+			unlock_kernel();
 			return -EIO;
+		}
 
 		n_hdlc = tty2n_hdlc (tty);
 		if (!n_hdlc || n_hdlc->magic != HDLC_MAGIC ||
-			 tty != n_hdlc->tty)
+			 tty != n_hdlc->tty) {
+			unlock_kernel();
 			return 0;
+		}
 
 		rbuf = n_hdlc_buf_get(&n_hdlc->rx_buf_list);
 		if (rbuf)
 			break;
 			
 		/* no data */
-		if (file->f_flags & O_NONBLOCK)
+		if (file->f_flags & O_NONBLOCK) {
+			unlock_kernel();
 			return -EAGAIN;
+		}
 			
 		interruptible_sleep_on (&tty->read_wait);
-		if (signal_pending(current))
+		if (signal_pending(current)) {
+			unlock_kernel();
 			return -EINTR;
+		}
 	}
 		
 	if (rbuf->count > nr)
@@ -618,7 +628,7 @@
 		kfree(rbuf);
 	else	
 		n_hdlc_buf_put(&n_hdlc->rx_free_buf_list,rbuf);
-	
+	unlock_kernel();
 	return ret;
 	
 }	/* end of n_hdlc_tty_read() */
@@ -661,6 +671,8 @@
 		count = maxframe;
 	}
 	
+	lock_kernel();
+	
 	add_wait_queue(&tty->write_wait, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
 	
@@ -695,7 +707,7 @@
 		n_hdlc_buf_put(&n_hdlc->tx_buf_list,tbuf);
 		n_hdlc_send_frames(n_hdlc,tty);
 	}
-
+	unlock_kernel();
 	return error;
 	
 }	/* end of n_hdlc_tty_write() */
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-mm1/drivers/char/n_r3964.c linux-2.6.24-mm1/drivers/char/n_r3964.c
--- linux.vanilla-2.6.24-mm1/drivers/char/n_r3964.c	2008-02-06 14:13:23.000000000 +0000
+++ linux-2.6.24-mm1/drivers/char/n_r3964.c	2008-02-06 14:33:00.000000000 +0000
@@ -1074,6 +1074,8 @@
 	int count;
 
 	TRACE_L("read()");
+	
+	lock_kernel();
 
 	pClient = findClient(pInfo, task_pid(current));
 	if (pClient) {
@@ -1081,6 +1083,7 @@
 		if (pMsg == NULL) {
 			/* no messages available. */
 			if (file->f_flags & O_NONBLOCK) {
+				unlock_kernel();
 				return -EAGAIN;
 			}
 			/* block until there is a message: */
@@ -1090,8 +1093,10 @@
 
 		/* If we still haven't got a message, we must have been signalled */
 
-		if (!pMsg)
+		if (!pMsg) {
+			unlock_kernel();
 			return -EINTR;
+		}
 
 		/* deliver msg to client process: */
 		theMsg.msg_id = pMsg->msg_id;
@@ -1102,12 +1107,15 @@
 		kfree(pMsg);
 		TRACE_M("r3964_read - msg kfree %p", pMsg);
 
-		if (copy_to_user(buf, &theMsg, count))
+		if (copy_to_user(buf, &theMsg, count)) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 
 		TRACE_PS("read - return %d", count);
 		return count;
 	}
+	unlock_kernel();
 	return -EPERM;
 }
 
@@ -1156,6 +1164,8 @@
 	pHeader->locks = 0;
 	pHeader->owner = NULL;
 
+	lock_kernel();
+	
 	pClient = findClient(pInfo, task_pid(current));
 	if (pClient) {
 		pHeader->owner = pClient;
@@ -1172,6 +1182,8 @@
  */
 	add_tx_queue(pInfo, pHeader);
 	trigger_transmit(pInfo);
+	
+	unlock_kernel();
 
 	return 0;
 }
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-mm1/drivers/char/n_tty.c linux-2.6.24-mm1/drivers/char/n_tty.c
--- linux.vanilla-2.6.24-mm1/drivers/char/n_tty.c	2008-02-06 14:14:39.000000000 +0000
+++ linux-2.6.24-mm1/drivers/char/n_tty.c	2008-02-06 14:33:00.000000000 +0000
@@ -183,22 +183,24 @@
  *	at hangup) or when the N_TTY line discipline internally has to
  *	clean the pending queue (for example some signals).
  *
- *	FIXME: tty->ctrl_status is not spinlocked and relies on
- *	lock_kernel() still.
+ *	Locking: ctrl_lock
  */
 
 static void n_tty_flush_buffer(struct tty_struct *tty)
 {
+	unsigned long flags;
 	/* clear everything and unthrottle the driver */
 	reset_buffer_flags(tty);
 
 	if (!tty->link)
 		return;
 
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
 	if (tty->link->packet) {
 		tty->ctrl_status |= TIOCPKT_FLUSHREAD;
 		wake_up_interruptible(&tty->link->read_wait);
 	}
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 }
 
 /**
@@ -264,7 +266,7 @@
  *	relevant in the world today. If you ever need them, add them here.
  *
  *	Called from both the receive and transmit sides and can be called
- *	re-entrantly. Relies on lock_kernel() still.
+ *	re-entrantly. Relies on lock_kernel() for tty->column state.
  */
 
 static int opost(unsigned char c, struct tty_struct *tty)
@@ -275,6 +277,7 @@
 	if (!space)
 		return -1;
 
+	lock_kernel();
 	if (O_OPOST(tty)) {
 		switch (c) {
 		case '\n':
@@ -323,6 +326,7 @@
 		}
 	}
 	tty->driver->put_char(tty, c);
+	unlock_kernel();
 	return 0;
 }
 
@@ -337,7 +341,8 @@
  *	the simple cases normally found and helps to generate blocks of
  *	symbols for the console driver and thus improve performance.
  *
- *	Called from write_chan under the tty layer write lock.
+ *	Called from write_chan under the tty layer write lock. Relies
+ *	on lock_kernel for the tty->column state.
  */
 
 static ssize_t opost_block(struct tty_struct *tty,
@@ -353,6 +358,7 @@
 	if (nr > space)
 		nr = space;
 
+	lock_kernel();
 	for (i = 0, cp = buf; i < nr; i++, cp++) {
 		switch (*cp) {
 		case '\n':
@@ -387,6 +393,7 @@
 	if (tty->driver->flush_chars)
 		tty->driver->flush_chars(tty);
 	i = tty->driver->write(tty, buf, i);
+	unlock_kernel();
 	return i;
 }
 
@@ -1194,6 +1201,11 @@
  *	Perform job control management checks on this file/tty descriptor
  *	and if appropriate send any needed signals and return a negative
  *	error code if action should be taken.
+ *
+ *	FIXME:
+ *	Locking: None - redirected write test is safe, testing
+ *	current->signal should possibly lock current->sighand
+ *	pgrp locking ?
  */
 
 static int job_control(struct tty_struct *tty, struct file *file)
@@ -1246,6 +1258,7 @@
 	ssize_t size;
 	long timeout;
 	unsigned long flags;
+	int packet;
 
 do_it_again:
 
@@ -1289,16 +1302,19 @@
 		if (mutex_lock_interruptible(&tty->atomic_read_lock))
 			return -ERESTARTSYS;
 	}
-
+	packet = tty->packet;
+	
 	add_wait_queue(&tty->read_wait, &wait);
 	while (nr) {
 		/* First test for status change. */
-		if (tty->packet && tty->link->ctrl_status) {
+		if (packet && tty->link->ctrl_status) {
 			unsigned char cs;
 			if (b != buf)
 				break;
+			spin_lock_irqsave(&tty->link->ctrl_lock, flags);
 			cs = tty->link->ctrl_status;
 			tty->link->ctrl_status = 0;
+			spin_unlock_irqrestore(&tty->link->ctrl_lock, flags);
 			if (tty_put_user(tty, cs, b++)) {
 				retval = -EFAULT;
 				b--;
@@ -1333,6 +1349,7 @@
 				retval = -ERESTARTSYS;
 				break;
 			}
+			/* FIXME: does n_tty_set_room need locking ? */
 			n_tty_set_room(tty);
 			timeout = schedule_timeout(timeout);
 			continue;
@@ -1340,7 +1357,7 @@
 		__set_current_state(TASK_RUNNING);
 
 		/* Deal with packet mode. */
-		if (tty->packet && b == buf) {
+		if (packet && b == buf) {
 			if (tty_put_user(tty, TIOCPKT_DATA, b++)) {
 				retval = -EFAULT;
 				b--;
@@ -1388,6 +1405,8 @@
 				break;
 		} else {
 			int uncopied;
+			/* The copy function takes the read lock and handles
+			   locking internally for this case */
 			uncopied = copy_from_read_buf(tty, &b, &nr);
 			uncopied += copy_from_read_buf(tty, &b, &nr);
 			if (uncopied) {
@@ -1429,7 +1448,6 @@
 		 goto do_it_again;
 
 	n_tty_set_room(tty);
-
 	return retval;
 }
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-mm1/drivers/char/pty.c linux-2.6.24-mm1/drivers/char/pty.c
--- linux.vanilla-2.6.24-mm1/drivers/char/pty.c	2008-02-06 14:13:22.000000000 +0000
+++ linux-2.6.24-mm1/drivers/char/pty.c	2008-02-06 14:33:29.000000000 +0000
@@ -181,6 +181,7 @@
 static void pty_flush_buffer(struct tty_struct *tty)
 {
 	struct tty_struct *to = tty->link;
+	unsigned long flags;
 	
 	if (!to)
 		return;
@@ -189,8 +190,10 @@
 		to->ldisc.flush_buffer(to);
 	
 	if (to->packet) {
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		tty->ctrl_status |= TIOCPKT_FLUSHWRITE;
 		wake_up_interruptible(&to->read_wait);
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	}
 }
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-mm1/drivers/char/tty_io.c linux-2.6.24-mm1/drivers/char/tty_io.c
--- linux.vanilla-2.6.24-mm1/drivers/char/tty_io.c	2008-02-06 14:14:39.000000000 +0000
+++ linux-2.6.24-mm1/drivers/char/tty_io.c	2008-02-06 14:33:29.000000000 +0000
@@ -152,8 +152,7 @@
 static unsigned int tty_poll(struct file *, poll_table *);
 static int tty_open(struct inode *, struct file *);
 static int tty_release(struct inode *, struct file *);
-int tty_ioctl(struct inode *inode, struct file *file,
-	      unsigned int cmd, unsigned long arg);
+long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
 static long tty_compat_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg);
@@ -1163,7 +1163,7 @@
  *	not in the foreground, send a SIGTTOU.  If the signal is blocked or
  *	ignored, go ahead and perform the operation.  (POSIX 7.2)
  *
- *	Locking: none
+ *	Locking: none - FIXME: review this
  */
 
 int tty_check_change(struct tty_struct *tty)
@@ -1205,7 +1205,7 @@
 	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
 }
 
-static int hung_up_tty_ioctl(struct inode *inode, struct file *file,
+static long hung_up_tty_ioctl(struct inode *inode, struct file *file,
 			     unsigned int cmd, unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
@@ -1222,7 +1222,7 @@
 	.read		= tty_read,
 	.write		= tty_write,
 	.poll		= tty_poll,
-	.ioctl		= tty_ioctl,
+	.unlocked_ioctl	= tty_ioctl,
 	.compat_ioctl	= tty_compat_ioctl,
 	.open		= tty_open,
 	.release	= tty_release,
@@ -1235,7 +1235,7 @@
 	.read		= tty_read,
 	.write		= tty_write,
 	.poll		= tty_poll,
-	.ioctl		= tty_ioctl,
+	.unlocked_ioctl	= tty_ioctl,
 	.compat_ioctl	= tty_compat_ioctl,
 	.open		= ptmx_open,
 	.release	= tty_release,
@@ -1248,7 +1248,7 @@
 	.read		= tty_read,
 	.write		= redirected_tty_write,
 	.poll		= tty_poll,
-	.ioctl		= tty_ioctl,
+	.unlocked_ioctl	= tty_ioctl,
 	.compat_ioctl	= tty_compat_ioctl,
 	.open		= tty_open,
 	.release	= tty_release,
@@ -1584,16 +1584,17 @@
 	struct tty_struct *tty;
 	struct pid *tty_pgrp = NULL;
 
-	lock_kernel();
 
 	mutex_lock(&tty_mutex);
 	tty = get_current_tty();
 	if (tty) {
 		tty_pgrp = get_pid(tty->pgrp);
 		mutex_unlock(&tty_mutex);
+		lock_kernel();
 		/* XXX: here we race, there is nothing protecting tty */
 		if (on_exit && tty->driver->type != TTY_DRIVER_TYPE_PTY)
 			tty_vhangup(tty);
+		unlock_kernel();
 	} else if (on_exit) {
 		struct pid *old_pgrp;
 		spin_lock_irq(&current->sighand->siglock);
@@ -1606,7 +1607,6 @@
 			put_pid(old_pgrp);
 		}
 		mutex_unlock(&tty_mutex);
-		unlock_kernel();
 		return;
 	}
 	if (tty_pgrp) {
@@ -1641,7 +1641,6 @@
 	read_lock(&tasklist_lock);
 	session_clear_tty(task_session(current));
 	read_unlock(&tasklist_lock);
-	unlock_kernel();
 }
 
 /**
@@ -1651,8 +1650,10 @@
 void no_tty(void)
 {
 	struct task_struct *tsk = current;
+	lock_kernel();
 	if (tsk->signal->leader)
 		disassociate_ctty(0);
+	unlock_kernel();
 	proc_clear_tty(tsk);
 }
 
@@ -1672,19 +1673,24 @@
  *	but not always.
  *
  *	Locking:
- *		Broken. Relies on BKL which is unsafe here.
+ *		Uses the tty control lock internally
  */
 
 void stop_tty(struct tty_struct *tty)
 {
-	if (tty->stopped)
+	unsigned long flags;
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	if (tty->stopped) {
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		return;
+	}
 	tty->stopped = 1;
 	if (tty->link && tty->link->packet) {
 		tty->ctrl_status &= ~TIOCPKT_START;
 		tty->ctrl_status |= TIOCPKT_STOP;
 		wake_up_interruptible(&tty->link->read_wait);
 	}
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	if (tty->driver->stop)
 		(tty->driver->stop)(tty);
 }
@@ -1701,19 +1707,24 @@
  *	driver start method is invoked and the line discipline woken.
  *
  *	Locking:
- *		Broken. Relies on BKL which is unsafe here.
+ *		ctrl_lock
  */
 
 void start_tty(struct tty_struct *tty)
 {
-	if (!tty->stopped || tty->flow_stopped)
+	unsigned long flags;
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	if (!tty->stopped || tty->flow_stopped) {
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		return;
+	}
 	tty->stopped = 0;
 	if (tty->link && tty->link->packet) {
 		tty->ctrl_status &= ~TIOCPKT_STOP;
 		tty->ctrl_status |= TIOCPKT_START;
 		wake_up_interruptible(&tty->link->read_wait);
 	}
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	if (tty->driver->start)
 		(tty->driver->start)(tty);
 	/* If we have a running line discipline it may need kicking */
@@ -1757,13 +1768,11 @@
 	/* We want to wait for the line discipline to sort out in this
 	   situation */
 	ld = tty_ldisc_ref_wait(tty);
-	lock_kernel();
 	if (ld->read)
 		i = (ld->read)(tty, file, buf, count);
 	else
 		i = -EIO;
 	tty_ldisc_deref(ld);
-	unlock_kernel();
 	if (i > 0)
 		inode->i_atime = current_fs_time(inode->i_sb);
 	return i;
@@ -1851,9 +1860,7 @@
 		ret = -EFAULT;
 		if (copy_from_user(tty->write_buf, buf, size))
 			break;
-		lock_kernel();
 		ret = write(tty, file, tty->write_buf, size);
-		unlock_kernel();
 		if (ret <= 0)
 			break;
 		written += ret;
@@ -3028,10 +3165,13 @@
 	if (get_user(nonblock, p))
 		return -EFAULT;
 
+	/* file->f_flags is still BKL protected in the fs layer - vomit */
+	lock_kernel();
 	if (nonblock)
 		file->f_flags |= O_NONBLOCK;
 	else
 		file->f_flags &= ~O_NONBLOCK;
+	unlock_kernel();
 	return 0;
 }
 
@@ -3120,7 +3260,7 @@
  *	Set the process group of the tty to the session passed. Only
  *	permitted where the tty session is our session.
  *
- *	Locking: None
+ *	Locking: RCU
  */
 
 static int tiocspgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t __user *p)
@@ -3195,10 +3335,14 @@
 static int tiocsetd(struct tty_struct *tty, int __user *p)
 {
 	int ldisc;
+	int ret;
 
 	if (get_user(ldisc, p))
 		return -EFAULT;
-	return tty_set_ldisc(tty, ldisc);
+		
+	lock_kernel();
+	ret = tty_set_ldisc(tty, ldisc);
+	unlock_kernel();
 }
 
 /**
@@ -3216,16 +3360,21 @@
 
 static int send_break(struct tty_struct *tty, unsigned int duration)
 {
+	int retval = -EINTR;
+	
+	lock_kernel();
 	if (tty_write_lock(tty, 0) < 0)
-		return -EINTR;
+		goto out;
 	tty->driver->break_ctl(tty, -1);
 	if (!signal_pending(current))
 		msleep_interruptible(duration);
 	tty->driver->break_ctl(tty, 0);
 	tty_write_unlock(tty);
-	if (signal_pending(current))
-		return -EINTR;
-	return 0;
+	if (!signal_pending(current))
+		retval = 0;
+out:
+	unlock_kernel();
+	return retval;
 }
 
 /**
@@ -3245,7 +3394,9 @@
 	int retval = -EINVAL;
 
 	if (tty->driver->tiocmget) {
+		lock_kernel();
 		retval = tty->driver->tiocmget(tty, file);
+		unlock_kernel();
 
 		if (retval >= 0)
 			retval = put_user(retval, p);
@@ -3295,7 +3446,9 @@
 		set &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
 		clear &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
 
+		lock_kernel();
 		retval = tty->driver->tiocmset(tty, file, set, clear);
+		unlock_kernel();
 	}
 	return retval;
 }
@@ -3303,20 +3456,18 @@
 /*
  * Split this up, as gcc can choke on it otherwise..
  */
-int tty_ioctl(struct inode *inode, struct file *file,
-	      unsigned int cmd, unsigned long arg)
+long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct tty_struct *tty, *real_tty;
 	void __user *p = (void __user *)arg;
 	int retval;
 	struct tty_ldisc *ld;
+	struct inode *inode = file->f_dentry->d_inode;
 
 	tty = (struct tty_struct *)file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
 		return -EINVAL;
 
-	/* CHECKME: is this safe as one end closes ? */
-
 	real_tty = tty;
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_MASTER)
@@ -3325,13 +3476,19 @@
 	/*
 	 * Break handling by driver
 	 */
+	 
+	retval = -EINVAL;
+	
 	if (!tty->driver->break_ctl) {
 		switch (cmd) {
 		case TIOCSBRK:
 		case TIOCCBRK:
-			if (tty->driver->ioctl)
-				return tty->driver->ioctl(tty, file, cmd, arg);
-			return -EINVAL;
+			if (tty->driver->ioctl) {
+				lock_kernel();
+				retval = tty->driver->ioctl(tty, file, cmd, arg);
+				unlock_kernel();
+			}
+			return retval;
 
 		/* These two ioctl's always return success; even if */
 		/* the driver doesn't support them. */
@@ -3339,7 +3496,9 @@
 		case TCSBRKP:
 			if (!tty->driver->ioctl)
 				return 0;
+			lock_kernel();
 			retval = tty->driver->ioctl(tty, file, cmd, arg);
+			unlock_kernel();
 			if (retval == -ENOIOCTLCMD)
 				retval = 0;
 			return retval;
@@ -3359,7 +3518,9 @@
 		if (retval)
 			return retval;
 		if (cmd != TIOCCBRK) {
+			lock_kernel();
 			tty_wait_until_sent(tty, 0);
+			unlock_kernel();
 			if (signal_pending(current))
 				return -EINTR;
 		}
@@ -3409,11 +3570,15 @@
 	 * Break handling
 	 */
 	case TIOCSBRK:	/* Turn break on, unconditionally */
+		lock_kernel();
 		tty->driver->break_ctl(tty, -1);
+		unlock_kernel();
 		return 0;
 
 	case TIOCCBRK:	/* Turn break off, unconditionally */
+		lock_kernel();
 		tty->driver->break_ctl(tty, 0);
+		unlock_kernel();
 		return 0;
 	case TCSBRK:   /* SVID version: non-zero arg --> no break */
 		/* non-zero arg means wait for all output data
@@ -3443,14 +3608,18 @@
 		break;
 	}
 	if (tty->driver->ioctl) {
+		lock_kernel();
 		retval = (tty->driver->ioctl)(tty, file, cmd, arg);
+		unlock_kernel();
 		if (retval != -ENOIOCTLCMD)
 			return retval;
 	}
 	ld = tty_ldisc_ref_wait(tty);
 	retval = -EINVAL;
 	if (ld->ioctl) {
+		lock_kernel();
 		retval = ld->ioctl(tty, file, cmd, arg);
+		unlock_kernel();
 		if (retval == -ENOIOCTLCMD)
 			retval = -EINVAL;
 	}
@@ -3728,6 +3897,7 @@
 	mutex_init(&tty->atomic_read_lock);
 	mutex_init(&tty->atomic_write_lock);
 	spin_lock_init(&tty->read_lock);
+	spin_lock_init(&tty->ctrl_lock);
 	INIT_LIST_HEAD(&tty->tty_files);
 	INIT_WORK(&tty->SAK_work, do_SAK_work);
 }
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-mm1/drivers/char/tty_ioctl.c linux-2.6.24-mm1/drivers/char/tty_ioctl.c
--- linux.vanilla-2.6.24-mm1/drivers/char/tty_ioctl.c	2008-02-06 14:14:39.000000000 +0000
+++ linux-2.6.24-mm1/drivers/char/tty_ioctl.c	2008-02-06 14:33:34.000000000 +0000
@@ -395,6 +395,7 @@
 	int canon_change;
 	struct ktermios old_termios = *tty->termios;
 	struct tty_ldisc *ld;
+	unsigned long flags;
 
 	/*
 	 *	Perform the actual termios internal changes under lock.
@@ -429,11 +430,13 @@
 				STOP_CHAR(tty) == '\023' &&
 				START_CHAR(tty) == '\021');
 		if (old_flow != new_flow) {
+			spin_lock_irqsave(&tty->ctrl_lock, flags);
 			tty->ctrl_status &= ~(TIOCPKT_DOSTOP | TIOCPKT_NOSTOP);
 			if (new_flow)
 				tty->ctrl_status |= TIOCPKT_DOSTOP;
 			else
 				tty->ctrl_status |= TIOCPKT_NOSTOP;
+			spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 			wake_up_interruptible(&tty->link->read_wait);
 		}
 	}
@@ -905,6 +908,7 @@
 		       unsigned int cmd, unsigned long arg)
 {
 	struct tty_struct *real_tty;
+	unsigned long flags;
 	int retval;
 
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
@@ -963,6 +967,7 @@
 			return -ENOTTY;
 		if (get_user(pktmode, (int __user *) arg))
 			return -EFAULT;
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		if (pktmode) {
 			if (!tty->packet) {
 				tty->packet = 1;
@@ -970,6 +975,7 @@
 			}
 		} else
 			tty->packet = 0;
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		return 0;
 	}
 	default:
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-mm1/drivers/char/vt.c linux-2.6.24-mm1/drivers/char/vt.c
--- linux.vanilla-2.6.24-mm1/drivers/char/vt.c	2008-02-06 14:14:39.000000000 +0000
+++ linux-2.6.24-mm1/drivers/char/vt.c	2008-02-06 14:33:40.000000000 +0000
@@ -2531,6 +2531,9 @@
 	if (get_user(type, p))
 		return -EFAULT;
 	ret = 0;
+	
+	lock_kernel();
+	
 	switch (type)
 	{
 		case TIOCL_SETSEL:
@@ -2605,6 +2608,7 @@
 			ret = -EINVAL;
 			break;
 	}
+	unlock_kernel();
 	return ret;
 }
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-mm1/include/linux/tty.h linux-2.6.24-mm1/include/linux/tty.h
--- linux.vanilla-2.6.24-mm1/include/linux/tty.h	2008-02-06 14:14:42.000000000 +0000
+++ linux-2.6.24-mm1/include/linux/tty.h	2008-02-06 14:37:29.000000000 +0000
@@ -183,6 +200,7 @@
 	int index;
 	struct tty_ldisc ldisc;
 	struct mutex termios_mutex;
+	spinlock_t ctrl_lock;
 	struct ktermios *termios, *termios_locked;
 	char name[64];
 	struct pid *pgrp;
@@ -323,8 +342,7 @@
 extern void tty_wakeup(struct tty_struct *tty);
 extern void tty_ldisc_flush(struct tty_struct *tty);
 
-extern int tty_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg);
+extern long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 extern int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 extern int tty_perform_flush(struct tty_struct *tty, unsigned long arg);

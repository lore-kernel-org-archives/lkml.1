Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbZKROmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbZKROmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbZKROmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:42:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36884 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757509AbZKROmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:42:06 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [RFC PATCH 1/5] tty: push the BKL down into the handlers a bit
To: linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:25:43 +0000
Message-ID: <20091118142404.3806.19238.stgit@localhost.localdomain>
In-Reply-To: <20091118142313.3806.47368.stgit@localhost.localdomain>
References: <20091118142313.3806.47368.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start trying to untangle the remaining BKL mess

Signed-off-by: Alan "I must be out of my tree" Cox <alan@linux.intel.com>
---

 drivers/char/pty.c       |    2 -
 drivers/char/tty_io.c    |  140 ++++++++++++++++++++++++++--------------------
 drivers/char/tty_ldisc.c |   13 ++++
 include/linux/tty.h      |    2 -
 4 files changed, 94 insertions(+), 63 deletions(-)


diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index d516e9c..169cdcc 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -659,7 +659,7 @@ static int __ptmx_open(struct inode *inode, struct file *filp)
 	if (!retval)
 		return 0;
 out1:
-	tty_release_dev(filp);
+	tty_release(inode, filp);
 	return retval;
 out:
 	devpts_kill_index(inode, index);
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 59499ee..05e94a2 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -142,7 +142,6 @@ ssize_t redirected_tty_write(struct file *, const char __user *,
 							size_t, loff_t *);
 static unsigned int tty_poll(struct file *, poll_table *);
 static int tty_open(struct inode *, struct file *);
-static int tty_release(struct inode *, struct file *);
 long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
 static long tty_compat_ioctl(struct file *file, unsigned int cmd,
@@ -1017,14 +1016,16 @@ out:
 
 void tty_write_message(struct tty_struct *tty, char *msg)
 {
-	lock_kernel();
 	if (tty) {
 		mutex_lock(&tty->atomic_write_lock);
-		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags))
+		lock_kernel();
+		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags)) {
+			unlock_kernel();
 			tty->ops->write(tty, msg, strlen(msg));
+		} else
+			unlock_kernel();
 		tty_write_unlock(tty);
 	}
-	unlock_kernel();
 	return;
 }
 
@@ -1202,14 +1203,21 @@ static int tty_driver_install_tty(struct tty_driver *driver,
 						struct tty_struct *tty)
 {
 	int idx = tty->index;
+	int ret;
 
-	if (driver->ops->install)
-		return driver->ops->install(driver, tty);
+	if (driver->ops->install) {
+		lock_kernel();
+		ret = driver->ops->install(driver, tty);
+		unlock_kernel();
+		return ret;
+	}
 
 	if (tty_init_termios(tty) == 0) {
+		lock_kernel();
 		tty_driver_kref_get(driver);
 		tty->count++;
 		driver->ttys[idx] = tty;
+		unlock_kernel();
 		return 0;
 	}
 	return -ENOMEM;
@@ -1302,10 +1310,14 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 	struct tty_struct *tty;
 	int retval;
 
+	lock_kernel();
 	/* Check if pty master is being opened multiple times */
 	if (driver->subtype == PTY_TYPE_MASTER &&
-		(driver->flags & TTY_DRIVER_DEVPTS_MEM) && !first_ok)
+		(driver->flags & TTY_DRIVER_DEVPTS_MEM) && !first_ok) {
+		unlock_kernel();
 		return ERR_PTR(-EIO);
+	}
+	unlock_kernel();
 
 	/*
 	 * First time open is complex, especially for PTY devices.
@@ -1335,8 +1347,9 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 	 * If we fail here just call release_tty to clean up.  No need
 	 * to decrement the use counts, as release_tty doesn't care.
 	 */
-
+	lock_kernel();
 	retval = tty_ldisc_setup(tty, tty->link);
+	unlock_kernel();
 	if (retval)
 		goto release_mem_out;
 	return tty;
@@ -1350,7 +1363,9 @@ release_mem_out:
 	if (printk_ratelimit())
 		printk(KERN_INFO "tty_init_dev: ldisc open failed, "
 				 "clearing slot %d\n", idx);
+	lock_kernel();
 	release_tty(tty, idx);
+	unlock_kernel();
 	return ERR_PTR(retval);
 }
 
@@ -1464,7 +1479,17 @@ static void release_tty(struct tty_struct *tty, int idx)
 	tty_kref_put(tty);
 }
 
-/*
+/**
+ *	tty_release		-	vfs callback for close
+ *	@inode: inode of tty
+ *	@filp: file pointer for handle to tty
+ *
+ *	Called the last time each file handle is closed that references
+ *	this tty. There may however be several such references.
+ *
+ *	Locking:
+ *		Takes bkl. See tty_release_dev
+ *
  * Even releasing the tty structures is a tricky business.. We have
  * to be very careful that the structures are all released at the
  * same time, as interrupts might otherwise get the wrong pointers.
@@ -1472,20 +1497,20 @@ static void release_tty(struct tty_struct *tty, int idx)
  * WSH 09/09/97: rewritten to avoid some nasty race conditions that could
  * lead to double frees or releasing memory still in use.
  */
-void tty_release_dev(struct file *filp)
+
+int tty_release(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty, *o_tty;
 	int	pty_master, tty_closing, o_tty_closing, do_sleep;
 	int	devpts;
 	int	idx;
 	char	buf[64];
-	struct 	inode *inode;
 
-	inode = filp->f_path.dentry->d_inode;
 	tty = (struct tty_struct *)filp->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_release_dev"))
-		return;
+		return 0;
 
+	lock_kernel();
 	check_tty_count(tty, "tty_release_dev");
 
 	tty_fasync(-1, filp, 0);
@@ -1500,19 +1525,22 @@ void tty_release_dev(struct file *filp)
 	if (idx < 0 || idx >= tty->driver->num) {
 		printk(KERN_DEBUG "tty_release_dev: bad idx when trying to "
 				  "free (%s)\n", tty->name);
-		return;
+		unlock_kernel();
+		return 0;
 	}
 	if (!devpts) {
 		if (tty != tty->driver->ttys[idx]) {
+			unlock_kernel();
 			printk(KERN_DEBUG "tty_release_dev: driver.table[%d] not tty "
 			       "for (%s)\n", idx, tty->name);
-			return;
+			return 0;
 		}
 		if (tty->termios != tty->driver->termios[idx]) {
+			unlock_kernel();
 			printk(KERN_DEBUG "tty_release_dev: driver.termios[%d] not termios "
 			       "for (%s)\n",
 			       idx, tty->name);
-			return;
+			return 0;
 		}
 	}
 #endif
@@ -1526,26 +1554,29 @@ void tty_release_dev(struct file *filp)
 	if (tty->driver->other &&
 	     !(tty->driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
 		if (o_tty != tty->driver->other->ttys[idx]) {
+			unlock_kernel();
 			printk(KERN_DEBUG "tty_release_dev: other->table[%d] "
 					  "not o_tty for (%s)\n",
 			       idx, tty->name);
-			return;
+			return 0 ;
 		}
 		if (o_tty->termios != tty->driver->other->termios[idx]) {
+			unlock_kernel();
 			printk(KERN_DEBUG "tty_release_dev: other->termios[%d] "
 					  "not o_termios for (%s)\n",
 			       idx, tty->name);
-			return;
+			return 0;
 		}
 		if (o_tty->link != tty) {
 			printk(KERN_DEBUG "tty_release_dev: bad pty pointers\n");
-			return;
+			return 0;
 		}
 	}
 #endif
 	if (tty->ops->close)
 		tty->ops->close(tty, filp);
 
+	unlock_kernel();
 	/*
 	 * Sanity check: if tty->count is going to zero, there shouldn't be
 	 * any waiters on tty->read_wait or tty->write_wait.  We test the
@@ -1568,6 +1599,7 @@ void tty_release_dev(struct file *filp)
 		   opens on /dev/tty */
 
 		mutex_lock(&tty_mutex);
+		lock_kernel();
 		tty_closing = tty->count <= 1;
 		o_tty_closing = o_tty &&
 			(o_tty->count <= (pty_master ? 1 : 0));
@@ -1598,6 +1630,7 @@ void tty_release_dev(struct file *filp)
 
 		printk(KERN_WARNING "tty_release_dev: %s: read/write wait queue "
 				    "active!\n", tty_name(tty, buf));
+		unlock_kernel();
 		mutex_unlock(&tty_mutex);
 		schedule();
 	}
@@ -1661,8 +1694,10 @@ void tty_release_dev(struct file *filp)
 	mutex_unlock(&tty_mutex);
 
 	/* check whether both sides are closing ... */
-	if (!tty_closing || (o_tty && !o_tty_closing))
-		return;
+	if (!tty_closing || (o_tty && !o_tty_closing)) {
+		unlock_kernel();
+		return 0;
+	}
 
 #ifdef TTY_DEBUG_HANGUP
 	printk(KERN_DEBUG "freeing tty structure...");
@@ -1680,10 +1715,12 @@ void tty_release_dev(struct file *filp)
 	/* Make this pty number available for reallocation */
 	if (devpts)
 		devpts_kill_index(inode, idx);
+	unlock_kernel();
+	return 0;
 }
 
 /**
- *	__tty_open		-	open a tty device
+ *	tty_open		-	open a tty device
  *	@inode: inode of device file
  *	@filp: file pointer to tty
  *
@@ -1703,7 +1740,7 @@ void tty_release_dev(struct file *filp)
  *		 ->siglock protects ->signal/->sighand
  */
 
-static int __tty_open(struct inode *inode, struct file *filp)
+static int tty_open(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty = NULL;
 	int noctty, retval;
@@ -1720,10 +1757,12 @@ retry_open:
 	retval = 0;
 
 	mutex_lock(&tty_mutex);
+	lock_kernel();
 
 	if (device == MKDEV(TTYAUX_MAJOR, 0)) {
 		tty = get_current_tty();
 		if (!tty) {
+			unlock_kernel();
 			mutex_unlock(&tty_mutex);
 			return -ENXIO;
 		}
@@ -1755,12 +1794,14 @@ retry_open:
 				goto got_driver;
 			}
 		}
+		unlock_kernel();
 		mutex_unlock(&tty_mutex);
 		return -ENODEV;
 	}
 
 	driver = get_tty_driver(device, &index);
 	if (!driver) {
+		unlock_kernel();
 		mutex_unlock(&tty_mutex);
 		return -ENODEV;
 	}
@@ -1770,6 +1811,7 @@ got_driver:
 		tty = tty_driver_lookup_tty(driver, inode, index);
 
 		if (IS_ERR(tty)) {
+			unlock_kernel();
 			mutex_unlock(&tty_mutex);
 			return PTR_ERR(tty);
 		}
@@ -1784,8 +1826,10 @@ got_driver:
 
 	mutex_unlock(&tty_mutex);
 	tty_driver_kref_put(driver);
-	if (IS_ERR(tty))
+	if (IS_ERR(tty)) {
+		unlock_kernel();
 		return PTR_ERR(tty);
+	}
 
 	filp->private_data = tty;
 	file_move(filp, &tty->tty_files);
@@ -1813,11 +1857,15 @@ got_driver:
 		printk(KERN_DEBUG "error %d in opening %s...", retval,
 		       tty->name);
 #endif
-		tty_release_dev(filp);
-		if (retval != -ERESTARTSYS)
+		tty_release(inode, filp);
+		if (retval != -ERESTARTSYS) {
+			unlock_kernel();
 			return retval;
-		if (signal_pending(current))
+		}
+		if (signal_pending(current)) {
+			unlock_kernel();
 			return retval;
+		}
 		schedule();
 		/*
 		 * Need to reset f_op in case a hangup happened.
@@ -1826,8 +1874,11 @@ got_driver:
 			filp->f_op = &tty_fops;
 		goto retry_open;
 	}
+	unlock_kernel();
+
 
 	mutex_lock(&tty_mutex);
+	lock_kernel();
 	spin_lock_irq(&current->sighand->siglock);
 	if (!noctty &&
 	    current->signal->leader &&
@@ -1835,44 +1886,13 @@ got_driver:
 	    tty->session == NULL)
 		__proc_set_tty(current, tty);
 	spin_unlock_irq(&current->sighand->siglock);
+	unlock_kernel();
 	mutex_unlock(&tty_mutex);
 	return 0;
 }
 
-/* BKL pushdown: scary code avoidance wrapper */
-static int tty_open(struct inode *inode, struct file *filp)
-{
-	int ret;
-
-	lock_kernel();
-	ret = __tty_open(inode, filp);
-	unlock_kernel();
-	return ret;
-}
 
 
-
-
-/**
- *	tty_release		-	vfs callback for close
- *	@inode: inode of tty
- *	@filp: file pointer for handle to tty
- *
- *	Called the last time each file handle is closed that references
- *	this tty. There may however be several such references.
- *
- *	Locking:
- *		Takes bkl. See tty_release_dev
- */
-
-static int tty_release(struct inode *inode, struct file *filp)
-{
-	lock_kernel();
-	tty_release_dev(filp);
-	unlock_kernel();
-	return 0;
-}
-
 /**
  *	tty_poll	-	check tty status
  *	@filp: file being polled
@@ -2317,9 +2337,7 @@ static int tiocsetd(struct tty_struct *tty, int __user *p)
 	if (get_user(ldisc, p))
 		return -EFAULT;
 
-	lock_kernel();
 	ret = tty_set_ldisc(tty, ldisc);
-	unlock_kernel();
 
 	return ret;
 }
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index feb5507..d914e77 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -34,6 +34,8 @@
 #include <linux/vt_kern.h>
 #include <linux/selection.h>
 
+#include <linux/smp_lock.h>	/* For the moment */
+
 #include <linux/kmod.h>
 #include <linux/nsproxy.h>
 
@@ -545,6 +547,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	if (IS_ERR(new_ldisc))
 		return PTR_ERR(new_ldisc);
 
+	lock_kernel();
 	/*
 	 *	We need to look at the tty locking here for pty/tty pairs
 	 *	when both sides try to change in parallel.
@@ -558,6 +561,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	 */
 
 	if (tty->ldisc->ops->num == ldisc) {
+		unlock_kernel();
 		tty_ldisc_put(new_ldisc);
 		return 0;
 	}
@@ -569,6 +573,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_wait_until_sent(tty, 0);
 
+	unlock_kernel();
 	mutex_lock(&tty->ldisc_mutex);
 
 	/*
@@ -582,6 +587,9 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 			test_bit(TTY_LDISC_CHANGING, &tty->flags) == 0);
 		mutex_lock(&tty->ldisc_mutex);
 	}
+
+	lock_kernel();
+
 	set_bit(TTY_LDISC_CHANGING, &tty->flags);
 
 	/*
@@ -592,6 +600,8 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	tty->receive_room = 0;
 
 	o_ldisc = tty->ldisc;
+
+	unlock_kernel();
 	/*
 	 *	Make sure we don't change while someone holds a
 	 *	reference to the line discipline. The TTY_LDISC bit
@@ -617,12 +627,14 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	flush_scheduled_work();
 
 	mutex_lock(&tty->ldisc_mutex);
+	lock_kernel();
 	if (test_bit(TTY_HUPPED, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
 		clear_bit(TTY_LDISC_CHANGING, &tty->flags);
 		mutex_unlock(&tty->ldisc_mutex);
 		tty_ldisc_put(new_ldisc);
+		unlock_kernel();
 		return -EIO;
 	}
 
@@ -664,6 +676,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	if (o_work)
 		schedule_delayed_work(&o_tty->buf.work, 1);
 	mutex_unlock(&tty->ldisc_mutex);
+	unlock_kernel();
 	return retval;
 }
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index e6da667..405a903 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -449,7 +449,7 @@ extern void initialize_tty_struct(struct tty_struct *tty,
 		struct tty_driver *driver, int idx);
 extern struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 								int first_ok);
-extern void tty_release_dev(struct file *filp);
+extern int tty_release(struct inode *inode, struct file *filp);
 extern int tty_init_termios(struct tty_struct *tty);
 
 extern struct tty_struct *tty_pair_get_tty(struct tty_struct *tty);


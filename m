Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbZLLKSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbZLLKSC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:18:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZLLKSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:18:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45045 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbZLLKR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:17:58 -0500
Date: Sat, 12 Dec 2009 11:15:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091212101551.GA16049@elte.hu>
References: <20091211232805.GA10652@kroah.com>
 <20091212084611.GA28266@elte.hu>
 <20091212013927.58d386d1.akpm@linux-foundation.org>
 <20091212100656.GA25286@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091212100656.GA25286@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Have a trace.  I'm actually wondering if perhaps there's a missing 
> > unlock_kernel() somewhere else, and the tty code is just the victim of 
> > that.
> 
> Unlikely i'd say. I have 1000+ successful overnight tests on the latest 
> tree Linus pushed out:
> 
>  3ef884b: Merge branch 'drm-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/d
> 
> So that's a guaranteed 'good' kernel.
> 
> The moment i merged 053fe57 into -tip the lockups started, so that's a 
> guaranteed 'bad' kernel. There's only the TTY changes between those two 
> points that look remotely related.
> 
> It's spurious though so quite hard to bisect. I tried one bisection 
> today already and it got on the wrong track. I'll do a brute-force 
> revert of the commits i quoted, lets see what happens.

i'm testing the series of 5 reverts below. It's looking good so far. You 
might want to try them - how quickly can you reproduce the hangs?

	Ingo

--------------->
>From 95b532d4e2f9a82c1dedf7ea4a6c2702402237e6 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 12 Dec 2009 11:08:04 +0100
Subject: [PATCH] Revert "tty: push the BKL down into the handlers a bit"

This reverts commit eeb89d918c2fa2b809e464136bbafdaec2aacb30.

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 385c44b..d86c0bc 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -659,7 +659,7 @@ static int __ptmx_open(struct inode *inode, struct file *filp)
 	if (!retval)
 		return 0;
 out1:
-	tty_release(inode, filp);
+	tty_release_dev(filp);
 	return retval;
 out:
 	devpts_kill_index(inode, index);
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 1e24130..59499ee 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -142,6 +142,7 @@ ssize_t redirected_tty_write(struct file *, const char __user *,
 							size_t, loff_t *);
 static unsigned int tty_poll(struct file *, poll_table *);
 static int tty_open(struct inode *, struct file *);
+static int tty_release(struct inode *, struct file *);
 long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
 static long tty_compat_ioctl(struct file *file, unsigned int cmd,
@@ -1016,16 +1017,14 @@ out:
 
 void tty_write_message(struct tty_struct *tty, char *msg)
 {
+	lock_kernel();
 	if (tty) {
 		mutex_lock(&tty->atomic_write_lock);
-		lock_kernel();
-		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags)) {
-			unlock_kernel();
+		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags))
 			tty->ops->write(tty, msg, strlen(msg));
-		} else
-			unlock_kernel();
 		tty_write_unlock(tty);
 	}
+	unlock_kernel();
 	return;
 }
 
@@ -1203,21 +1202,14 @@ static int tty_driver_install_tty(struct tty_driver *driver,
 						struct tty_struct *tty)
 {
 	int idx = tty->index;
-	int ret;
 
-	if (driver->ops->install) {
-		lock_kernel();
-		ret = driver->ops->install(driver, tty);
-		unlock_kernel();
-		return ret;
-	}
+	if (driver->ops->install)
+		return driver->ops->install(driver, tty);
 
 	if (tty_init_termios(tty) == 0) {
-		lock_kernel();
 		tty_driver_kref_get(driver);
 		tty->count++;
 		driver->ttys[idx] = tty;
-		unlock_kernel();
 		return 0;
 	}
 	return -ENOMEM;
@@ -1310,14 +1302,10 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 	struct tty_struct *tty;
 	int retval;
 
-	lock_kernel();
 	/* Check if pty master is being opened multiple times */
 	if (driver->subtype == PTY_TYPE_MASTER &&
-		(driver->flags & TTY_DRIVER_DEVPTS_MEM) && !first_ok) {
-		unlock_kernel();
+		(driver->flags & TTY_DRIVER_DEVPTS_MEM) && !first_ok)
 		return ERR_PTR(-EIO);
-	}
-	unlock_kernel();
 
 	/*
 	 * First time open is complex, especially for PTY devices.
@@ -1347,9 +1335,8 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 	 * If we fail here just call release_tty to clean up.  No need
 	 * to decrement the use counts, as release_tty doesn't care.
 	 */
-	lock_kernel();
+
 	retval = tty_ldisc_setup(tty, tty->link);
-	unlock_kernel();
 	if (retval)
 		goto release_mem_out;
 	return tty;
@@ -1363,9 +1350,7 @@ release_mem_out:
 	if (printk_ratelimit())
 		printk(KERN_INFO "tty_init_dev: ldisc open failed, "
 				 "clearing slot %d\n", idx);
-	lock_kernel();
 	release_tty(tty, idx);
-	unlock_kernel();
 	return ERR_PTR(retval);
 }
 
@@ -1479,17 +1464,7 @@ static void release_tty(struct tty_struct *tty, int idx)
 	tty_kref_put(tty);
 }
 
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
- *
+/*
  * Even releasing the tty structures is a tricky business.. We have
  * to be very careful that the structures are all released at the
  * same time, as interrupts might otherwise get the wrong pointers.
@@ -1497,20 +1472,20 @@ static void release_tty(struct tty_struct *tty, int idx)
  * WSH 09/09/97: rewritten to avoid some nasty race conditions that could
  * lead to double frees or releasing memory still in use.
  */
-
-int tty_release(struct inode *inode, struct file *filp)
+void tty_release_dev(struct file *filp)
 {
 	struct tty_struct *tty, *o_tty;
 	int	pty_master, tty_closing, o_tty_closing, do_sleep;
 	int	devpts;
 	int	idx;
 	char	buf[64];
+	struct 	inode *inode;
 
+	inode = filp->f_path.dentry->d_inode;
 	tty = (struct tty_struct *)filp->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_release_dev"))
-		return 0;
+		return;
 
-	lock_kernel();
 	check_tty_count(tty, "tty_release_dev");
 
 	tty_fasync(-1, filp, 0);
@@ -1525,22 +1500,19 @@ int tty_release(struct inode *inode, struct file *filp)
 	if (idx < 0 || idx >= tty->driver->num) {
 		printk(KERN_DEBUG "tty_release_dev: bad idx when trying to "
 				  "free (%s)\n", tty->name);
-		unlock_kernel();
-		return 0;
+		return;
 	}
 	if (!devpts) {
 		if (tty != tty->driver->ttys[idx]) {
-			unlock_kernel();
 			printk(KERN_DEBUG "tty_release_dev: driver.table[%d] not tty "
 			       "for (%s)\n", idx, tty->name);
-			return 0;
+			return;
 		}
 		if (tty->termios != tty->driver->termios[idx]) {
-			unlock_kernel();
 			printk(KERN_DEBUG "tty_release_dev: driver.termios[%d] not termios "
 			       "for (%s)\n",
 			       idx, tty->name);
-			return 0;
+			return;
 		}
 	}
 #endif
@@ -1554,30 +1526,26 @@ int tty_release(struct inode *inode, struct file *filp)
 	if (tty->driver->other &&
 	     !(tty->driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
 		if (o_tty != tty->driver->other->ttys[idx]) {
-			unlock_kernel();
 			printk(KERN_DEBUG "tty_release_dev: other->table[%d] "
 					  "not o_tty for (%s)\n",
 			       idx, tty->name);
-			return 0 ;
+			return;
 		}
 		if (o_tty->termios != tty->driver->other->termios[idx]) {
-			unlock_kernel();
 			printk(KERN_DEBUG "tty_release_dev: other->termios[%d] "
 					  "not o_termios for (%s)\n",
 			       idx, tty->name);
-			return 0;
+			return;
 		}
 		if (o_tty->link != tty) {
-			unlock_kernel();
 			printk(KERN_DEBUG "tty_release_dev: bad pty pointers\n");
-			return 0;
+			return;
 		}
 	}
 #endif
 	if (tty->ops->close)
 		tty->ops->close(tty, filp);
 
-	unlock_kernel();
 	/*
 	 * Sanity check: if tty->count is going to zero, there shouldn't be
 	 * any waiters on tty->read_wait or tty->write_wait.  We test the
@@ -1600,7 +1568,6 @@ int tty_release(struct inode *inode, struct file *filp)
 		   opens on /dev/tty */
 
 		mutex_lock(&tty_mutex);
-		lock_kernel();
 		tty_closing = tty->count <= 1;
 		o_tty_closing = o_tty &&
 			(o_tty->count <= (pty_master ? 1 : 0));
@@ -1631,7 +1598,6 @@ int tty_release(struct inode *inode, struct file *filp)
 
 		printk(KERN_WARNING "tty_release_dev: %s: read/write wait queue "
 				    "active!\n", tty_name(tty, buf));
-		unlock_kernel();
 		mutex_unlock(&tty_mutex);
 		schedule();
 	}
@@ -1695,10 +1661,8 @@ int tty_release(struct inode *inode, struct file *filp)
 	mutex_unlock(&tty_mutex);
 
 	/* check whether both sides are closing ... */
-	if (!tty_closing || (o_tty && !o_tty_closing)) {
-		unlock_kernel();
-		return 0;
-	}
+	if (!tty_closing || (o_tty && !o_tty_closing))
+		return;
 
 #ifdef TTY_DEBUG_HANGUP
 	printk(KERN_DEBUG "freeing tty structure...");
@@ -1716,12 +1680,10 @@ int tty_release(struct inode *inode, struct file *filp)
 	/* Make this pty number available for reallocation */
 	if (devpts)
 		devpts_kill_index(inode, idx);
-	unlock_kernel();
-	return 0;
 }
 
 /**
- *	tty_open		-	open a tty device
+ *	__tty_open		-	open a tty device
  *	@inode: inode of device file
  *	@filp: file pointer to tty
  *
@@ -1741,7 +1703,7 @@ int tty_release(struct inode *inode, struct file *filp)
  *		 ->siglock protects ->signal/->sighand
  */
 
-static int tty_open(struct inode *inode, struct file *filp)
+static int __tty_open(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty = NULL;
 	int noctty, retval;
@@ -1758,12 +1720,10 @@ retry_open:
 	retval = 0;
 
 	mutex_lock(&tty_mutex);
-	lock_kernel();
 
 	if (device == MKDEV(TTYAUX_MAJOR, 0)) {
 		tty = get_current_tty();
 		if (!tty) {
-			unlock_kernel();
 			mutex_unlock(&tty_mutex);
 			return -ENXIO;
 		}
@@ -1795,14 +1755,12 @@ retry_open:
 				goto got_driver;
 			}
 		}
-		unlock_kernel();
 		mutex_unlock(&tty_mutex);
 		return -ENODEV;
 	}
 
 	driver = get_tty_driver(device, &index);
 	if (!driver) {
-		unlock_kernel();
 		mutex_unlock(&tty_mutex);
 		return -ENODEV;
 	}
@@ -1812,7 +1770,6 @@ got_driver:
 		tty = tty_driver_lookup_tty(driver, inode, index);
 
 		if (IS_ERR(tty)) {
-			unlock_kernel();
 			mutex_unlock(&tty_mutex);
 			return PTR_ERR(tty);
 		}
@@ -1827,10 +1784,8 @@ got_driver:
 
 	mutex_unlock(&tty_mutex);
 	tty_driver_kref_put(driver);
-	if (IS_ERR(tty)) {
-		unlock_kernel();
+	if (IS_ERR(tty))
 		return PTR_ERR(tty);
-	}
 
 	filp->private_data = tty;
 	file_move(filp, &tty->tty_files);
@@ -1858,15 +1813,11 @@ got_driver:
 		printk(KERN_DEBUG "error %d in opening %s...", retval,
 		       tty->name);
 #endif
-		tty_release(inode, filp);
-		if (retval != -ERESTARTSYS) {
-			unlock_kernel();
+		tty_release_dev(filp);
+		if (retval != -ERESTARTSYS)
 			return retval;
-		}
-		if (signal_pending(current)) {
-			unlock_kernel();
+		if (signal_pending(current))
 			return retval;
-		}
 		schedule();
 		/*
 		 * Need to reset f_op in case a hangup happened.
@@ -1875,11 +1826,8 @@ got_driver:
 			filp->f_op = &tty_fops;
 		goto retry_open;
 	}
-	unlock_kernel();
-
 
 	mutex_lock(&tty_mutex);
-	lock_kernel();
 	spin_lock_irq(&current->sighand->siglock);
 	if (!noctty &&
 	    current->signal->leader &&
@@ -1887,13 +1835,44 @@ got_driver:
 	    tty->session == NULL)
 		__proc_set_tty(current, tty);
 	spin_unlock_irq(&current->sighand->siglock);
-	unlock_kernel();
 	mutex_unlock(&tty_mutex);
 	return 0;
 }
 
+/* BKL pushdown: scary code avoidance wrapper */
+static int tty_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+
+	lock_kernel();
+	ret = __tty_open(inode, filp);
+	unlock_kernel();
+	return ret;
+}
 
 
+
+
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
+ */
+
+static int tty_release(struct inode *inode, struct file *filp)
+{
+	lock_kernel();
+	tty_release_dev(filp);
+	unlock_kernel();
+	return 0;
+}
+
 /**
  *	tty_poll	-	check tty status
  *	@filp: file being polled
@@ -2338,7 +2317,9 @@ static int tiocsetd(struct tty_struct *tty, int __user *p)
 	if (get_user(ldisc, p))
 		return -EFAULT;
 
+	lock_kernel();
 	ret = tty_set_ldisc(tty, ldisc);
+	unlock_kernel();
 
 	return ret;
 }
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index d914e77..feb5507 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -34,8 +34,6 @@
 #include <linux/vt_kern.h>
 #include <linux/selection.h>
 
-#include <linux/smp_lock.h>	/* For the moment */
-
 #include <linux/kmod.h>
 #include <linux/nsproxy.h>
 
@@ -547,7 +545,6 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	if (IS_ERR(new_ldisc))
 		return PTR_ERR(new_ldisc);
 
-	lock_kernel();
 	/*
 	 *	We need to look at the tty locking here for pty/tty pairs
 	 *	when both sides try to change in parallel.
@@ -561,7 +558,6 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	 */
 
 	if (tty->ldisc->ops->num == ldisc) {
-		unlock_kernel();
 		tty_ldisc_put(new_ldisc);
 		return 0;
 	}
@@ -573,7 +569,6 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_wait_until_sent(tty, 0);
 
-	unlock_kernel();
 	mutex_lock(&tty->ldisc_mutex);
 
 	/*
@@ -587,9 +582,6 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 			test_bit(TTY_LDISC_CHANGING, &tty->flags) == 0);
 		mutex_lock(&tty->ldisc_mutex);
 	}
-
-	lock_kernel();
-
 	set_bit(TTY_LDISC_CHANGING, &tty->flags);
 
 	/*
@@ -600,8 +592,6 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	tty->receive_room = 0;
 
 	o_ldisc = tty->ldisc;
-
-	unlock_kernel();
 	/*
 	 *	Make sure we don't change while someone holds a
 	 *	reference to the line discipline. The TTY_LDISC bit
@@ -627,14 +617,12 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	flush_scheduled_work();
 
 	mutex_lock(&tty->ldisc_mutex);
-	lock_kernel();
 	if (test_bit(TTY_HUPPED, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
 		clear_bit(TTY_LDISC_CHANGING, &tty->flags);
 		mutex_unlock(&tty->ldisc_mutex);
 		tty_ldisc_put(new_ldisc);
-		unlock_kernel();
 		return -EIO;
 	}
 
@@ -676,7 +664,6 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	if (o_work)
 		schedule_delayed_work(&o_tty->buf.work, 1);
 	mutex_unlock(&tty->ldisc_mutex);
-	unlock_kernel();
 	return retval;
 }
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 405a903..e6da667 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -449,7 +449,7 @@ extern void initialize_tty_struct(struct tty_struct *tty,
 		struct tty_driver *driver, int idx);
 extern struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 								int first_ok);
-extern int tty_release(struct inode *inode, struct file *filp);
+extern void tty_release_dev(struct file *filp);
 extern int tty_init_termios(struct tty_struct *tty);
 
 extern struct tty_struct *tty_pair_get_tty(struct tty_struct *tty);

>From bd9a619494c123470a081e5e30602c307de2bba3 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 12 Dec 2009 11:07:55 +0100
Subject: [PATCH] Revert "tty: Push the lock down further into the ldisc code"

This reverts commit f18f9498e90327b9b0e245e191029e6e1996d203.

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index c408c81..1e24130 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1347,7 +1347,9 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 	 * If we fail here just call release_tty to clean up.  No need
 	 * to decrement the use counts, as release_tty doesn't care.
 	 */
+	lock_kernel();
 	retval = tty_ldisc_setup(tty, tty->link);
+	unlock_kernel();
 	if (retval)
 		goto release_mem_out;
 	return tty;
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 3f653f7..d914e77 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -445,14 +445,8 @@ static void tty_set_termios_ldisc(struct tty_struct *tty, int num)
 static int tty_ldisc_open(struct tty_struct *tty, struct tty_ldisc *ld)
 {
 	WARN_ON(test_and_set_bit(TTY_LDISC_OPEN, &tty->flags));
-	if (ld->ops->open) {
-		int ret;
-                /* BKL here locks verus a hangup event */
-		lock_kernel();
-		ret = ld->ops->open(tty);
-		unlock_kernel();
-		return ret;
-	}
+	if (ld->ops->open)
+		return ld->ops->open(tty);
 	return 0;
 }
 
@@ -572,7 +566,6 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		return 0;
 	}
 
-	unlock_kernel();
 	/*
 	 *	Problem: What do we do if this blocks ?
 	 *	We could deadlock here
@@ -580,6 +573,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_wait_until_sent(tty, 0);
 
+	unlock_kernel();
 	mutex_lock(&tty->ldisc_mutex);
 
 	/*

>From 8e991a5112643a63820a1088860f0c7c869d6f25 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 12 Dec 2009 11:07:46 +0100
Subject: [PATCH] Revert "tty: Push the bkl down a bit in the hangup code"

This reverts commit 38c70b27f9502c31c1d0c29676275f7362cdb0d9.

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index cc941a3..c408c81 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -505,6 +505,8 @@ static void do_tty_hangup(struct work_struct *work)
 	if (!tty)
 		return;
 
+	/* inuse_filps is protected by the single kernel lock */
+	lock_kernel();
 
 	spin_lock(&redirect_lock);
 	if (redirect && redirect->private_data == tty) {
@@ -513,8 +515,6 @@ static void do_tty_hangup(struct work_struct *work)
 	}
 	spin_unlock(&redirect_lock);
 
-	/* inuse_filps is protected by the single kernel lock */
-	lock_kernel();
 	check_tty_count(tty, "do_tty_hangup");
 	file_list_lock();
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */

>From 9d6d77b3c56e6c169e50b6bb9033e4a2e7d4ec71 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 12 Dec 2009 11:07:38 +0100
Subject: [PATCH] Revert "tty: Move the leader test in disassociate"

This reverts commit 5ec93d1154fd1e269162398f8e70efc7e004485d.

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index a19fef2..cc941a3 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -707,8 +707,6 @@ void disassociate_ctty(int on_exit)
 	struct tty_struct *tty;
 	struct pid *tty_pgrp = NULL;
 
-	if (!current->signal->leader)
-		return;
 
 	tty = get_current_tty();
 	if (tty) {
@@ -774,7 +772,8 @@ void no_tty(void)
 {
 	struct task_struct *tsk = current;
 	lock_kernel();
-	disassociate_ctty(0);
+	if (tsk->signal->leader)
+		disassociate_ctty(0);
 	unlock_kernel();
 	proc_clear_tty(tsk);
 }
diff --git a/kernel/exit.c b/kernel/exit.c
index 6f50ef5..1143012 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -971,7 +971,7 @@ NORET_TYPE void do_exit(long code)
 	exit_thread();
 	cgroup_exit(tsk, 1);
 
-	if (group_dead)
+	if (group_dead && tsk->signal->leader)
 		disassociate_ctty(1);
 
 	module_put(task_thread_info(tsk)->exec_domain->module);

>From 153d2afe47cc994d35adc7e61be13bf840fd0b47 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 12 Dec 2009 11:07:28 +0100
Subject: [PATCH] Revert "tty: split the lock up a bit further"

This reverts commit 36ba782e9674cdc29ec7003757df0b375e99fa96.

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 684f0e0..a19fef2 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -516,8 +516,6 @@ static void do_tty_hangup(struct work_struct *work)
 	/* inuse_filps is protected by the single kernel lock */
 	lock_kernel();
 	check_tty_count(tty, "do_tty_hangup");
-	unlock_kernel();
-
 	file_list_lock();
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
 	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
@@ -531,7 +529,6 @@ static void do_tty_hangup(struct work_struct *work)
 	}
 	file_list_unlock();
 
-	lock_kernel();
 	tty_ldisc_hangup(tty);
 
 	read_lock(&tasklist_lock);


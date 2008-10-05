Return-Path: <linux-kernel-owner+w=401wt.eu-S1758949AbYJEQWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbYJEQWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757761AbYJEQS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:18:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57932 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757620AbYJEQSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:18:24 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 48/76] tty: Remove more special casing and out of place code
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:18:23 +0100
Message-ID: <20081005161816.1997.25272.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carry on pushing code out of tty_io when it belongs to other drivers. I'm
not 100% happy with some of this and it will be worth revisiting some of the
exports later when the restructuring work is done.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/pty.c       |   78 +++++++++++++++++++++
 drivers/char/tty_io.c    |  169 ++++++++++------------------------------------
 drivers/char/tty_ioctl.c |   66 ++++++++++++++++--
 drivers/char/vt.c        |   30 ++++----
 include/linux/tty.h      |    6 ++
 include/linux/vt_kern.h  |    2 -
 6 files changed, 195 insertions(+), 156 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index ec09c1c..328e8ac 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/sysctl.h>
+#include <linux/device.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -332,6 +333,8 @@ int pty_limit = NR_UNIX98_PTY_DEFAULT;
 static int pty_limit_min = 0;
 static int pty_limit_max = NR_UNIX98_PTY_MAX;
 
+static struct cdev ptmx_cdev;
+
 static struct ctl_table pty_table[] = {
 	{
 		.ctl_name	= PTY_MAX,
@@ -408,6 +411,70 @@ static const struct tty_operations ptm_unix98_ops = {
 	.shutdown = pty_shutdown
 };
 
+
+/**
+ *	ptmx_open		-	open a unix 98 pty master
+ *	@inode: inode of device file
+ *	@filp: file pointer to tty
+ *
+ *	Allocate a unix98 pty master device from the ptmx driver.
+ *
+ *	Locking: tty_mutex protects the init_dev work. tty->count should
+ * 		protect the rest.
+ *		allocated_ptys_lock handles the list of free pty numbers
+ */
+
+static int __ptmx_open(struct inode *inode, struct file *filp)
+{
+	struct tty_struct *tty;
+	int retval;
+	int index;
+
+	nonseekable_open(inode, filp);
+
+	/* find a device that is not in use. */
+	index = devpts_new_index();
+	if (index < 0)
+		return index;
+
+	mutex_lock(&tty_mutex);
+	retval = tty_init_dev(ptm_driver, index, &tty, 1);
+	mutex_unlock(&tty_mutex);
+
+	if (retval)
+		goto out;
+
+	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
+	filp->private_data = tty;
+	file_move(filp, &tty->tty_files);
+
+	retval = devpts_pty_new(tty->link);
+	if (retval)
+		goto out1;
+
+	retval = ptm_driver->ops->open(tty, filp);
+	if (!retval)
+		return 0;
+out1:
+	tty_release_dev(filp);
+	return retval;
+out:
+	devpts_kill_index(index);
+	return retval;
+}
+
+static int ptmx_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+
+	lock_kernel();
+	ret = __ptmx_open(inode, filp);
+	unlock_kernel();
+	return ret;
+}
+
+static struct file_operations ptmx_fops;
+
 static void __init unix98_pty_init(void)
 {
 	ptm_driver = alloc_tty_driver(NR_UNIX98_PTY_MAX);
@@ -459,7 +526,18 @@ static void __init unix98_pty_init(void)
 
 	pty_table[1].data = &ptm_driver->refcount;
 	register_sysctl_table(pty_root_table);
+
+	/* Now create the /dev/ptmx special device */
+	tty_default_fops(&ptmx_fops);
+	ptmx_fops.open = ptmx_open;
+
+	cdev_init(&ptmx_cdev, &ptmx_fops);
+	if (cdev_add(&ptmx_cdev, MKDEV(TTYAUX_MAJOR, 2), 1) ||
+	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 2), 1, "/dev/ptmx") < 0)
+		panic("Couldn't register /dev/ptmx driver\n");
+	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 2), NULL, "ptmx");
 }
+
 #else
 static inline void unix98_pty_init(void) { }
 #endif
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index f91704d..fdcc43c 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -49,7 +49,7 @@
  * implement CONFIG_VT and generalize console device interface.
  *	-- Marko Kohtala <Marko.Kohtala@hut.fi>, March 97
  *
- * Rewrote init_dev and release_dev to eliminate races.
+ * Rewrote tty_init_dev and tty_release_dev to eliminate races.
  *	-- Bill Hawes <whawes@star.net>, June 97
  *
  * Added devfs support.
@@ -136,11 +136,6 @@ LIST_HEAD(tty_drivers);			/* linked list of tty drivers */
 DEFINE_MUTEX(tty_mutex);
 EXPORT_SYMBOL(tty_mutex);
 
-#ifdef CONFIG_UNIX98_PTYS
-extern struct tty_driver *ptm_driver;	/* Unix98 pty masters; for /dev/ptmx */
-static int ptmx_open(struct inode *, struct file *);
-#endif
-
 static void initialize_tty_struct(struct tty_struct *tty);
 
 static ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
@@ -425,20 +420,6 @@ static const struct file_operations tty_fops = {
 	.fasync		= tty_fasync,
 };
 
-#ifdef CONFIG_UNIX98_PTYS
-static const struct file_operations ptmx_fops = {
-	.llseek		= no_llseek,
-	.read		= tty_read,
-	.write		= tty_write,
-	.poll		= tty_poll,
-	.unlocked_ioctl	= tty_ioctl,
-	.compat_ioctl	= tty_compat_ioctl,
-	.open		= ptmx_open,
-	.release	= tty_release,
-	.fasync		= tty_fasync,
-};
-#endif
-
 static const struct file_operations console_fops = {
 	.llseek		= no_llseek,
 	.read		= tty_read,
@@ -1224,7 +1205,7 @@ static void tty_line_name(struct tty_driver *driver, int index, char *p)
 }
 
 /**
- *	init_dev		-	initialise a tty device
+ *	tty_init_dev		-	initialise a tty device
  *	@driver: tty driver we are opening a device on
  *	@idx: device index
  *	@ret_tty: returned tty structure
@@ -1248,7 +1229,7 @@ static void tty_line_name(struct tty_driver *driver, int index, char *p)
  * relaxed for the (most common) case of reopening a tty.
  */
 
-static int init_dev(struct tty_driver *driver, int idx,
+int tty_init_dev(struct tty_driver *driver, int idx,
 	struct tty_struct **ret_tty, int first_ok)
 {
 	struct tty_struct *tty, *o_tty;
@@ -1269,8 +1250,8 @@ static int init_dev(struct tty_driver *driver, int idx,
 			goto end_init;
 		}
 		/*
-		 * It's safe from now on because init_dev() is called with
-		 * tty_mutex held and release_dev() won't change tty->count
+		 * It's safe from now on because tty_init_dev() is called with
+		 * tty_mutex held and tty_release_dev() won't change tty->count
 		 * or tty->flags without having to grab tty_mutex
 		 */
 		if (tty && driver->subtype == PTY_TYPE_MASTER)
@@ -1449,7 +1430,7 @@ fast_track:
 
 	/* FIXME */
 	if (!test_bit(TTY_LDISC, &tty->flags))
-		printk(KERN_ERR "init_dev but no ldisc\n");
+		printk(KERN_ERR "tty_init_dev but no ldisc\n");
 success:
 	*ret_tty = tty;
 
@@ -1476,7 +1457,7 @@ fail_no_mem:
 	/* call the tty release_tty routine to clean out this slot */
 release_mem_out:
 	if (printk_ratelimit())
-		printk(KERN_INFO "init_dev: ldisc open failed, "
+		printk(KERN_INFO "tty_init_dev: ldisc open failed, "
 				 "clearing slot %d\n", idx);
 	release_tty(tty, idx);
 	goto end_init;
@@ -1587,7 +1568,7 @@ static void release_tty(struct tty_struct *tty, int idx)
  * WSH 09/09/97: rewritten to avoid some nasty race conditions that could
  * lead to double frees or releasing memory still in use.
  */
-static void release_dev(struct file *filp)
+void tty_release_dev(struct file *filp)
 {
 	struct tty_struct *tty, *o_tty;
 	int	pty_master, tty_closing, o_tty_closing, do_sleep;
@@ -1597,10 +1578,10 @@ static void release_dev(struct file *filp)
 
 	tty = (struct tty_struct *)filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode,
-							"release_dev"))
+							"tty_release_dev"))
 		return;
 
-	check_tty_count(tty, "release_dev");
+	check_tty_count(tty, "tty_release_dev");
 
 	tty_fasync(-1, filp, 0);
 
@@ -1612,24 +1593,24 @@ static void release_dev(struct file *filp)
 
 #ifdef TTY_PARANOIA_CHECK
 	if (idx < 0 || idx >= tty->driver->num) {
-		printk(KERN_DEBUG "release_dev: bad idx when trying to "
+		printk(KERN_DEBUG "tty_release_dev: bad idx when trying to "
 				  "free (%s)\n", tty->name);
 		return;
 	}
 	if (!(tty->driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
 		if (tty != tty->driver->ttys[idx]) {
-			printk(KERN_DEBUG "release_dev: driver.table[%d] not tty "
+			printk(KERN_DEBUG "tty_release_dev: driver.table[%d] not tty "
 			       "for (%s)\n", idx, tty->name);
 			return;
 		}
 		if (tty->termios != tty->driver->termios[idx]) {
-			printk(KERN_DEBUG "release_dev: driver.termios[%d] not termios "
+			printk(KERN_DEBUG "tty_release_dev: driver.termios[%d] not termios "
 			       "for (%s)\n",
 			       idx, tty->name);
 			return;
 		}
 		if (tty->termios_locked != tty->driver->termios_locked[idx]) {
-			printk(KERN_DEBUG "release_dev: driver.termios_locked[%d] not "
+			printk(KERN_DEBUG "tty_release_dev: driver.termios_locked[%d] not "
 			       "termios_locked for (%s)\n",
 			       idx, tty->name);
 			return;
@@ -1638,7 +1619,7 @@ static void release_dev(struct file *filp)
 #endif
 
 #ifdef TTY_DEBUG_HANGUP
-	printk(KERN_DEBUG "release_dev of %s (tty count=%d)...",
+	printk(KERN_DEBUG "tty_release_dev of %s (tty count=%d)...",
 	       tty_name(tty, buf), tty->count);
 #endif
 
@@ -1646,26 +1627,26 @@ static void release_dev(struct file *filp)
 	if (tty->driver->other &&
 	     !(tty->driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
 		if (o_tty != tty->driver->other->ttys[idx]) {
-			printk(KERN_DEBUG "release_dev: other->table[%d] "
+			printk(KERN_DEBUG "tty_release_dev: other->table[%d] "
 					  "not o_tty for (%s)\n",
 			       idx, tty->name);
 			return;
 		}
 		if (o_tty->termios != tty->driver->other->termios[idx]) {
-			printk(KERN_DEBUG "release_dev: other->termios[%d] "
+			printk(KERN_DEBUG "tty_release_dev: other->termios[%d] "
 					  "not o_termios for (%s)\n",
 			       idx, tty->name);
 			return;
 		}
 		if (o_tty->termios_locked !=
 		      tty->driver->other->termios_locked[idx]) {
-			printk(KERN_DEBUG "release_dev: other->termios_locked["
+			printk(KERN_DEBUG "tty_release_dev: other->termios_locked["
 					  "%d] not o_termios_locked for (%s)\n",
 			       idx, tty->name);
 			return;
 		}
 		if (o_tty->link != tty) {
-			printk(KERN_DEBUG "release_dev: bad pty pointers\n");
+			printk(KERN_DEBUG "tty_release_dev: bad pty pointers\n");
 			return;
 		}
 	}
@@ -1723,7 +1704,7 @@ static void release_dev(struct file *filp)
 		if (!do_sleep)
 			break;
 
-		printk(KERN_WARNING "release_dev: %s: read/write wait queue "
+		printk(KERN_WARNING "tty_release_dev: %s: read/write wait queue "
 				    "active!\n", tty_name(tty, buf));
 		mutex_unlock(&tty_mutex);
 		schedule();
@@ -1736,14 +1717,14 @@ static void release_dev(struct file *filp)
 	 */
 	if (pty_master) {
 		if (--o_tty->count < 0) {
-			printk(KERN_WARNING "release_dev: bad pty slave count "
+			printk(KERN_WARNING "tty_release_dev: bad pty slave count "
 					    "(%d) for %s\n",
 			       o_tty->count, tty_name(o_tty, buf));
 			o_tty->count = 0;
 		}
 	}
 	if (--tty->count < 0) {
-		printk(KERN_WARNING "release_dev: bad tty->count (%d) for %s\n",
+		printk(KERN_WARNING "tty_release_dev: bad tty->count (%d) for %s\n",
 		       tty->count, tty_name(tty, buf));
 		tty->count = 0;
 	}
@@ -1825,7 +1806,7 @@ static void release_dev(struct file *filp)
  *	The termios state of a pty is reset on first open so that
  *	settings don't persist across reuse.
  *
- *	Locking: tty_mutex protects tty, get_tty_driver and init_dev work.
+ *	Locking: tty_mutex protects tty, get_tty_driver and tty_init_dev work.
  *		 tty->count should protect the rest.
  *		 ->siglock protects ->signal/->sighand
  */
@@ -1889,7 +1870,7 @@ retry_open:
 		return -ENODEV;
 	}
 got_driver:
-	retval = init_dev(driver, index, &tty, 0);
+	retval = tty_init_dev(driver, index, &tty, 0);
 	mutex_unlock(&tty_mutex);
 	if (retval)
 		return retval;
@@ -1920,7 +1901,7 @@ got_driver:
 		printk(KERN_DEBUG "error %d in opening %s...", retval,
 		       tty->name);
 #endif
-		release_dev(filp);
+		tty_release_dev(filp);
 		if (retval != -ERESTARTSYS)
 			return retval;
 		if (signal_pending(current))
@@ -1959,69 +1940,6 @@ static int tty_open(struct inode *inode, struct file *filp)
 
 
 
-#ifdef CONFIG_UNIX98_PTYS
-/**
- *	ptmx_open		-	open a unix 98 pty master
- *	@inode: inode of device file
- *	@filp: file pointer to tty
- *
- *	Allocate a unix98 pty master device from the ptmx driver.
- *
- *	Locking: tty_mutex protects theinit_dev work. tty->count should
- * 		protect the rest.
- *		allocated_ptys_lock handles the list of free pty numbers
- */
-
-static int __ptmx_open(struct inode *inode, struct file *filp)
-{
-	struct tty_struct *tty;
-	int retval;
-	int index;
-
-	nonseekable_open(inode, filp);
-
-	/* find a device that is not in use. */
-	index = devpts_new_index();
-	if (index < 0)
-		return index;
-
-	mutex_lock(&tty_mutex);
-	retval = init_dev(ptm_driver, index, &tty, 1);
-	mutex_unlock(&tty_mutex);
-
-	if (retval)
-		goto out;
-
-	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
-	filp->private_data = tty;
-	file_move(filp, &tty->tty_files);
-
-	retval = devpts_pty_new(tty->link);
-	if (retval)
-		goto out1;
-
-	check_tty_count(tty, "ptmx_open");
-	retval = ptm_driver->ops->open(tty, filp);
-	if (!retval)
-		return 0;
-out1:
-	release_dev(filp);
-	return retval;
-out:
-	devpts_kill_index(index);
-	return retval;
-}
-
-static int ptmx_open(struct inode *inode, struct file *filp)
-{
-	int ret;
-
-	lock_kernel();
-	ret = __ptmx_open(inode, filp);
-	unlock_kernel();
-	return ret;
-}
-#endif
 
 /**
  *	tty_release		-	vfs callback for close
@@ -2032,13 +1950,13 @@ static int ptmx_open(struct inode *inode, struct file *filp)
  *	this tty. There may however be several such references.
  *
  *	Locking:
- *		Takes bkl. See release_dev
+ *		Takes bkl. See tty_release_dev
  */
 
 static int tty_release(struct inode *inode, struct file *filp)
 {
 	lock_kernel();
-	release_dev(filp);
+	tty_release_dev(filp);
 	unlock_kernel();
 	return 0;
 }
@@ -2932,7 +2850,7 @@ int tty_put_char(struct tty_struct *tty, unsigned char ch)
 
 EXPORT_SYMBOL_GPL(tty_put_char);
 
-static struct class *tty_class;
+struct class *tty_class;
 
 /**
  *	tty_register_device - register a tty device
@@ -3197,6 +3115,11 @@ struct tty_struct *get_current_tty(void)
 }
 EXPORT_SYMBOL_GPL(get_current_tty);
 
+void tty_default_fops(struct file_operations *fops)
+{
+	*fops = tty_fops;
+}
+
 /*
  * Initialize the console device. This is called *early*, so
  * we can't necessarily depend on lots of kernel help here.
@@ -3234,12 +3157,6 @@ postcore_initcall(tty_class_init);
 /* 3/2004 jmc: why do these devices exist? */
 
 static struct cdev tty_cdev, console_cdev;
-#ifdef CONFIG_UNIX98_PTYS
-static struct cdev ptmx_cdev;
-#endif
-#ifdef CONFIG_VT
-static struct cdev vc0_cdev;
-#endif
 
 /*
  * Ok, now we can initialize the rest of the tty devices and can count
@@ -3251,32 +3168,18 @@ static int __init tty_init(void)
 	if (cdev_add(&tty_cdev, MKDEV(TTYAUX_MAJOR, 0), 1) ||
 	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 0), 1, "/dev/tty") < 0)
 		panic("Couldn't register /dev/tty driver\n");
-	device_create_drvdata(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 0), NULL,
+	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 0), NULL,
 			      "tty");
 
 	cdev_init(&console_cdev, &console_fops);
 	if (cdev_add(&console_cdev, MKDEV(TTYAUX_MAJOR, 1), 1) ||
 	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 1), 1, "/dev/console") < 0)
 		panic("Couldn't register /dev/console driver\n");
-	device_create_drvdata(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 1), NULL,
+	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 1), NULL,
 			      "console");
 
-#ifdef CONFIG_UNIX98_PTYS
-	cdev_init(&ptmx_cdev, &ptmx_fops);
-	if (cdev_add(&ptmx_cdev, MKDEV(TTYAUX_MAJOR, 2), 1) ||
-	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 2), 1, "/dev/ptmx") < 0)
-		panic("Couldn't register /dev/ptmx driver\n");
-	device_create_drvdata(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 2), NULL, "ptmx");
-#endif
-
 #ifdef CONFIG_VT
-	cdev_init(&vc0_cdev, &console_fops);
-	if (cdev_add(&vc0_cdev, MKDEV(TTY_MAJOR, 0), 1) ||
-	    register_chrdev_region(MKDEV(TTY_MAJOR, 0), 1, "/dev/vc/0") < 0)
-		panic("Couldn't register /dev/tty0 driver\n");
-	device_create_drvdata(tty_class, NULL, MKDEV(TTY_MAJOR, 0), NULL, "tty0");
-
-	vty_init();
+	vty_init(&console_fops);
 #endif
 	return 0;
 }
diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 3067085..14cc19c 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -40,6 +40,15 @@
 #define TERMIOS_OLD	8
 
 
+/**
+ *	tty_chars_in_buffer	-	characters pending
+ *	@tty: terminal
+ *
+ *	Return the number of bytes of data in the device private
+ *	output queue. If no private method is supplied there is assumed
+ *	to be no queue on the device.
+ */
+
 int tty_chars_in_buffer(struct tty_struct *tty)
 {
 	if (tty->ops->chars_in_buffer)
@@ -47,26 +56,49 @@ int tty_chars_in_buffer(struct tty_struct *tty)
 	else
 		return 0;
 }
-
 EXPORT_SYMBOL(tty_chars_in_buffer);
 
+/**
+ *	tty_write_room		-	write queue space
+ *	@tty: terminal
+ *
+ *	Return the number of bytes that can be queued to this device
+ *	at the present time. The result should be treated as a guarantee
+ *	and the driver cannot offer a value it later shrinks by more than
+ *	the number of bytes written. If no method is provided 2K is always
+ *	returned and data may be lost as there will be no flow control.
+ */
+ 
 int tty_write_room(struct tty_struct *tty)
 {
 	if (tty->ops->write_room)
 		return tty->ops->write_room(tty);
 	return 2048;
 }
-
 EXPORT_SYMBOL(tty_write_room);
 
+/**
+ *	tty_driver_flush_buffer	-	discard internal buffer
+ *	@tty: terminal
+ *
+ *	Discard the internal output buffer for this device. If no method
+ *	is provided then either the buffer cannot be hardware flushed or
+ *	there is no buffer driver side.
+ */
 void tty_driver_flush_buffer(struct tty_struct *tty)
 {
 	if (tty->ops->flush_buffer)
 		tty->ops->flush_buffer(tty);
 }
-
 EXPORT_SYMBOL(tty_driver_flush_buffer);
 
+/**
+ *	tty_throttle		-	flow control
+ *	@tty: terminal
+ *
+ *	Indicate that a tty should stop transmitting data down the stack.
+ */
+
 void tty_throttle(struct tty_struct *tty)
 {
 	/* check TTY_THROTTLED first so it indicates our state */
@@ -76,6 +108,13 @@ void tty_throttle(struct tty_struct *tty)
 }
 EXPORT_SYMBOL(tty_throttle);
 
+/**
+ *	tty_unthrottle		-	flow control
+ *	@tty: terminal
+ *
+ *	Indicate that a tty may continue transmitting data down the stack.
+ */
+
 void tty_unthrottle(struct tty_struct *tty)
 {
 	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
@@ -112,6 +151,11 @@ void tty_wait_until_sent(struct tty_struct *tty, long timeout)
 }
 EXPORT_SYMBOL(tty_wait_until_sent);
 
+
+/*
+ *		Termios Helper Methods
+ */
+
 static void unset_locked_termios(struct ktermios *termios,
 				 struct ktermios *old,
 				 struct ktermios *locked)
@@ -346,6 +390,16 @@ void tty_termios_encode_baud_rate(struct ktermios *termios,
 }
 EXPORT_SYMBOL_GPL(tty_termios_encode_baud_rate);
 
+/**
+ *	tty_encode_baud_rate		-	set baud rate of the tty
+ *	@ibaud: input baud rate
+ *	@obad: output baud rate
+ *
+ *	Update the current termios data for the tty with the new speed
+ *	settings. The caller must hold the termios_mutex for the tty in
+ *	question.
+ */
+
 void tty_encode_baud_rate(struct tty_struct *tty, speed_t ibaud, speed_t obaud)
 {
 	tty_termios_encode_baud_rate(tty->termios, ibaud, obaud);
@@ -430,7 +484,7 @@ EXPORT_SYMBOL(tty_termios_hw_change);
  *	is a bit of layering violation here with n_tty in terms of the
  *	internal knowledge of this function.
  *
- *	Locking: termios_sem
+ *	Locking: termios_mutex
  */
 
 static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
@@ -508,7 +562,7 @@ static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
  *	functions before using change_termios to do the actual changes.
  *
  *	Locking:
- *		Called functions take ldisc and termios_sem locks
+ *		Called functions take ldisc and termios_mutex locks
  */
 
 static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
@@ -715,7 +769,7 @@ static void set_sgflags(struct ktermios *termios, int flags)
  *	Updates a terminal from the legacy BSD style terminal information
  *	structure.
  *
- *	Locking: termios_sem
+ *	Locking: termios_mutex
  */
 
 static int set_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 37a45db..57029fe 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -100,10 +100,10 @@
 #include <linux/font.h>
 #include <linux/bitops.h>
 #include <linux/notifier.h>
-
-#include <asm/io.h>
+#include <linux/device.h>
+#include <linux/io.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #define MAX_NR_CON_DRIVER 16
 
@@ -2352,8 +2352,6 @@ rescan_last_byte:
 	FLUSH
 	console_conditional_schedule();
 	release_console_sem();
-
-out:
 	notify_update(vc);
 	return n;
 #undef FLUSH
@@ -2784,13 +2782,6 @@ static int con_open(struct tty_struct *tty, struct file *filp)
 	return ret;
 }
 
-/*
- * We take tty_mutex in here to prevent another thread from coming in via init_dev
- * and taking a ref against the tty while we're in the process of forgetting
- * about it and cleaning things up.
- *
- * This is because vcs_remove_sysfs() can sleep and will drop the BKL.
- */
 static void con_close(struct tty_struct *tty, struct file *filp)
 {
 	/* Nothing to do - we defer to shutdown */
@@ -2932,8 +2923,16 @@ static const struct tty_operations con_ops = {
 	.shutdown = con_shutdown
 };
 
-int __init vty_init(void)
+static struct cdev vc0_cdev;
+
+int __init vty_init(const struct file_operations *console_fops)
 {
+	cdev_init(&vc0_cdev, console_fops);
+	if (cdev_add(&vc0_cdev, MKDEV(TTY_MAJOR, 0), 1) ||
+	    register_chrdev_region(MKDEV(TTY_MAJOR, 0), 1, "/dev/vc/0") < 0)
+		panic("Couldn't register /dev/tty0 driver\n");
+	device_create(tty_class, NULL, MKDEV(TTY_MAJOR, 0), NULL, "tty0");
+
 	vcs_init();
 
 	console_driver = alloc_tty_driver(MAX_NR_CONSOLES);
@@ -2952,7 +2951,6 @@ int __init vty_init(void)
 	tty_set_operations(console_driver, &con_ops);
 	if (tty_register_driver(console_driver))
 		panic("Couldn't register console driver\n");
-
 	kbd_init();
 	console_map_init();
 #ifdef CONFIG_PROM_CONSOLE
@@ -3446,7 +3444,7 @@ int register_con_driver(const struct consw *csw, int first, int last)
 	if (retval)
 		goto err;
 
-	con_driver->dev = device_create_drvdata(vtconsole_class, NULL,
+	con_driver->dev = device_create(vtconsole_class, NULL,
 						MKDEV(0, con_driver->node),
 						NULL, "vtcon%i",
 						con_driver->node);
@@ -3557,7 +3555,7 @@ static int __init vtconsole_class_init(void)
 		struct con_driver *con = &registered_con_driver[i];
 
 		if (con->con && !con->dev) {
-			con->dev = device_create_drvdata(vtconsole_class, NULL,
+			con->dev = device_create(vtconsole_class, NULL,
 							 MKDEV(0, con->node),
 							 NULL, "vtcon%i",
 							 con->node);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 6e39c70..6cc7ccc 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -314,6 +314,8 @@ extern int kmsg_redirect;
 extern void console_init(void);
 extern int vcs_init(void);
 
+extern struct class *tty_class;
+
 /**
  *	tty_kref_get		-	get a tty reference
  *	@tty: tty device
@@ -398,6 +400,10 @@ extern int tty_perform_flush(struct tty_struct *tty, unsigned long arg);
 extern dev_t tty_devnum(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
+extern void tty_default_fops(struct file_operations *fops);
+extern int tty_init_dev(struct tty_driver *driver, int idx,
+			struct tty_struct **ret_tty, int first_ok);
+extern void tty_release_dev(struct file *filp);
 
 extern struct mutex tty_mutex;
 
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 1cbd0a7..2f11134 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -96,7 +96,7 @@ void change_console(struct vc_data *new_vc);
 void reset_vc(struct vc_data *vc);
 extern int unbind_con_driver(const struct consw *csw, int first, int last,
 			     int deflt);
-int vty_init(void);
+int vty_init(const struct file_operations *console_fops);
 
 /*
  * vc_screen.c shares this temporary buffer with the console write code so that


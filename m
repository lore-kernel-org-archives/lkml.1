Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbXAaKqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbXAaKqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932977AbXAaKqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:46:20 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60273 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961AbXAaKqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:46:19 -0500
Date: Wed, 31 Jan 2007 09:16:09 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, hch@lst.de, alan@redhat.com
Subject: [PATCH] tty: cleanup release_mem
Message-ID: <Pine.LNX.4.64.0701310915380.4390@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

release_mem contains two copies of exactly the same code.  Refactor
these into a new helper, release_tty.  The only change in behaviour
is that the driver reference count is now decremented after the
master tty has been freed instead of before.

[penberg@cs.helsinki.fi: fix use-after-free in release_tty.]
Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 47a6eac..3bfe6fe 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -154,7 +154,7 @@ static int tty_release(struct inode *, s
 int tty_ioctl(struct inode * inode, struct file * file,
 	      unsigned int cmd, unsigned long arg);
 static int tty_fasync(int fd, struct file * filp, int on);
-static void release_mem(struct tty_struct *tty, int idx);
+static void release_tty(struct tty_struct *tty, int idx);
 
 /**
  *	alloc_tty_struct	-	allocate a tty object
@@ -2003,7 +2003,7 @@ static int init_dev(struct tty_driver *d
 
 	/* 
 	 * All structures have been allocated, so now we install them.
-	 * Failures after this point use release_mem to clean up, so 
+	 * Failures after this point use release_tty to clean up, so 
 	 * there's no need to null out the local pointers.
 	 */
 	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
@@ -2024,8 +2024,8 @@ static int init_dev(struct tty_driver *d
 
 	/* 
 	 * Structures all installed ... call the ldisc open routines.
-	 * If we fail here just call release_mem to clean up.  No need
-	 * to decrement the use counts, as release_mem doesn't care.
+	 * If we fail here just call release_tty to clean up.  No need
+	 * to decrement the use counts, as release_tty doesn't care.
 	 */
 
 	if (tty->ldisc.open) {
@@ -2095,17 +2095,17 @@ fail_no_mem:
 	retval = -ENOMEM;
 	goto end_init;
 
-	/* call the tty release_mem routine to clean out this slot */
+	/* call the tty release_tty routine to clean out this slot */
 release_mem_out:
 	if (printk_ratelimit())
 		printk(KERN_INFO "init_dev: ldisc open failed, "
 				 "clearing slot %d\n", idx);
-	release_mem(tty, idx);
+	release_tty(tty, idx);
 	goto end_init;
 }
 
 /**
- *	release_mem		-	release tty structure memory
+ *	release_one_tty		-	release tty structure memory
  *
  *	Releases memory associated with a tty structure, and clears out the
  *	driver table slots. This function is called when a device is no longer
@@ -2117,37 +2117,14 @@ release_mem_out:
  *	of ttys that the driver keeps.
  *		FIXME: should we require tty_mutex is held here ??
  */
-
-static void release_mem(struct tty_struct *tty, int idx)
+static void release_one_tty(struct tty_struct *tty, int idx)
 {
-	struct tty_struct *o_tty;
-	struct ktermios *tp;
 	int devpts = tty->driver->flags & TTY_DRIVER_DEVPTS_MEM;
-
-	if ((o_tty = tty->link) != NULL) {
-		if (!devpts)
-			o_tty->driver->ttys[idx] = NULL;
-		if (o_tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
-			tp = o_tty->termios;
-			if (!devpts)
-				o_tty->driver->termios[idx] = NULL;
-			kfree(tp);
-
-			tp = o_tty->termios_locked;
-			if (!devpts)
-				o_tty->driver->termios_locked[idx] = NULL;
-			kfree(tp);
-		}
-		o_tty->magic = 0;
-		o_tty->driver->refcount--;
-		file_list_lock();
-		list_del_init(&o_tty->tty_files);
-		file_list_unlock();
-		free_tty_struct(o_tty);
-	}
+	struct ktermios *tp;
 
 	if (!devpts)
 		tty->driver->ttys[idx] = NULL;
+
 	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
 		tp = tty->termios;
 		if (!devpts)
@@ -2160,15 +2137,39 @@ static void release_mem(struct tty_struc
 		kfree(tp);
 	}
 
+
 	tty->magic = 0;
 	tty->driver->refcount--;
+
 	file_list_lock();
 	list_del_init(&tty->tty_files);
 	file_list_unlock();
-	module_put(tty->driver->owner);
+
 	free_tty_struct(tty);
 }
 
+/**
+ *	release_tty		-	release tty structure memory
+ *
+ *	Release both @tty and a possible linked partner (think pty pair),
+ *	and decrement the refcount of the backing module.
+ *
+ *	Locking:
+ *		tty_mutex - sometimes only
+ *		takes the file list lock internally when working on the list
+ *	of ttys that the driver keeps.
+ *		FIXME: should we require tty_mutex is held here ??
+ */
+static void release_tty(struct tty_struct *tty, int idx)
+{
+	struct tty_driver *driver = tty->driver;
+
+	if (tty->link)
+		release_one_tty(tty->link, idx);
+	release_one_tty(tty, idx);
+	module_put(driver->owner);
+}
+
 /*
  * Even releasing the tty structures is a tricky business.. We have
  * to be very careful that the structures are all released at the
@@ -2436,10 +2437,10 @@ #endif
 		tty_set_termios_ldisc(o_tty,N_TTY); 
 	}
 	/*
-	 * The release_mem function takes care of the details of clearing
+	 * The release_tty function takes care of the details of clearing
 	 * the slots and preserving the termios structure.
 	 */
-	release_mem(tty, idx);
+	release_tty(tty, idx);
 
 #ifdef CONFIG_UNIX98_PTYS
 	/* Make this pty number available for reallocation */

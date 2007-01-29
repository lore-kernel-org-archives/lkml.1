Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbXA2SMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbXA2SMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 13:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXA2SMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 13:12:41 -0500
Received: from verein.lst.de ([213.95.11.210]:41593 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbXA2SMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 13:12:40 -0500
Date: Mon, 29 Jan 2007 19:12:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: Alan Cox <alan@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: cleanup release_mem
Message-ID: <20070129181235.GA9063@lst.de>
References: <20070128171244.GA21378@lst.de> <20070129120100.GA4338@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129120100.GA4338@devserv.devel.redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 07:01:00AM -0500, Alan Cox wrote:
> On Sun, Jan 28, 2007 at 06:12:44PM +0100, Christoph Hellwig wrote:
> > release_mem contains two copies of exactly the same code.  Refactor
> > these into a new helper, release_tty.  The only change in behaviour
> > is that the driver reference count is now decremented after the
> > master tty has been freed instead of before.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Acked-by: Alan Cox <alan@redhat.com>
> 
> Please propogate the mutex_ FIXME comment to both functions as it may
> well need to cover tty->link

Okay.  Now that we get into the details I've also added some renaming,
release_mem becomes release_tty and the new factored out function is
release_one_tty.  The difference is documented in the kdoc comments.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/char/tty_io.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_io.c	2007-01-29 10:01:46.000000000 +0100
+++ linux-2.6/drivers/char/tty_io.c	2007-01-29 19:08:06.000000000 +0100
@@ -154,7 +154,7 @@
 int tty_ioctl(struct inode * inode, struct file * file,
 	      unsigned int cmd, unsigned long arg);
 static int tty_fasync(int fd, struct file * filp, int on);
-static void release_mem(struct tty_struct *tty, int idx);
+static void release_tty(struct tty_struct *tty, int idx);
 
 /**
  *	alloc_tty_struct	-	allocate a tty object
@@ -2003,7 +2003,7 @@
 
 	/* 
 	 * All structures have been allocated, so now we install them.
-	 * Failures after this point use release_mem to clean up, so 
+	 * Failures after this point use release_tty to clean up, so 
 	 * there's no need to null out the local pointers.
 	 */
 	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
@@ -2024,8 +2024,8 @@
 
 	/* 
 	 * Structures all installed ... call the ldisc open routines.
-	 * If we fail here just call release_mem to clean up.  No need
-	 * to decrement the use counts, as release_mem doesn't care.
+	 * If we fail here just call release_tty to clean up.  No need
+	 * to decrement the use counts, as release_tty doesn't care.
 	 */
 
 	if (tty->ldisc.open) {
@@ -2095,17 +2095,17 @@
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
@@ -2117,37 +2117,14 @@
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
@@ -2160,15 +2137,37 @@
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
+ *	release_one_tty		-	release tty structure memory
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
+	if (tty->link)
+		release_one_tty(tty->link, idx);
+	release_one_tty(tty, idx);
+	module_put(tty->driver->owner);
+}
+
 /*
  * Even releasing the tty structures is a tricky business.. We have
  * to be very careful that the structures are all released at the
@@ -2436,10 +2435,10 @@
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

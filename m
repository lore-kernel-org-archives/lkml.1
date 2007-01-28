Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbXA1RMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbXA1RMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 12:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932695AbXA1RMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 12:12:50 -0500
Received: from verein.lst.de ([213.95.11.210]:59232 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932692AbXA1RMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 12:12:49 -0500
Date: Sun, 28 Jan 2007 18:12:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: alan@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tty: cleanup release_mem
Message-ID: <20070128171244.GA21378@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

release_mem contains two copies of exactly the same code.  Refactor
these into a new helper, release_tty.  The only change in behaviour
is that the driver reference count is now decremented after the
master tty has been freed instead of before.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/char/tty_io.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_io.c	2007-01-28 16:44:08.000000000 +0100
+++ linux-2.6/drivers/char/tty_io.c	2007-01-28 17:01:37.000000000 +0100
@@ -2105,7 +2105,7 @@
 }
 
 /**
- *	release_mem		-	release tty structure memory
+ *	release_tty		-	release tty structure memory
  *
  *	Releases memory associated with a tty structure, and clears out the
  *	driver table slots. This function is called when a device is no longer
@@ -2117,37 +2117,14 @@
  *	of ttys that the driver keeps.
  *		FIXME: should we require tty_mutex is held here ??
  */
-
-static void release_mem(struct tty_struct *tty, int idx)
+static void release_tty(struct tty_struct *tty, int idx)
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
@@ -2160,15 +2137,25 @@
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
 
+static void release_mem(struct tty_struct *tty, int idx)
+{
+	if (tty->link)
+		release_tty(tty->link, idx);
+	release_tty(tty, idx);
+	module_put(tty->driver->owner);
+}
+
 /*
  * Even releasing the tty structures is a tricky business.. We have
  * to be very careful that the structures are all released at the

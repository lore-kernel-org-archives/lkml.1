Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYJEQXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYJEQXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbYJEQTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:19:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57945 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758535AbYJEQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:19:32 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 50/76] tty: Clean up the tty_init_dev changes further
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:19:32 +0100
Message-ID: <20081005161915.1997.5277.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the naming, style and extract some bits of code into the driver
specific code

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/pty.c         |   49 +++++++++++++++++++++++++++++++++-
 drivers/char/tty_io.c      |   64 +++++++++++++++++---------------------------
 include/linux/tty_driver.h |    9 ++++++
 3 files changed, 81 insertions(+), 41 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 328e8ac..6e148ad 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -391,6 +391,41 @@ static int pty_unix98_ioctl(struct tty_struct *tty, struct file *file,
 	return -ENOIOCTLCMD;
 }
 
+/**
+ *	ptm_unix98_lookup	-	find a pty master
+ *	@driver: ptm driver
+ *	@idx: tty index
+ *
+ *	Look up a pty master device. Called under the tty_mutex for now.
+ *	This provides our locking.
+ */
+
+static struct tty_struct *ptm_unix98_lookup(struct tty_driver *driver, int idx)
+{
+	struct tty_struct *tty = devpts_get_tty(idx);
+	if (tty)
+		tty = tty->link;
+	return tty;
+}
+
+/**
+ *	pts_unix98_lookup	-	find a pty slave
+ *	@driver: pts driver
+ *	@idx: tty index
+ *
+ *	Look up a pty master device. Called under the tty_mutex for now.
+ *	This provides our locking.
+ */
+
+static struct tty_struct *pts_unix98_lookup(struct tty_driver *driver, int idx)
+{
+	struct tty_struct *tty = devpts_get_tty(idx);
+	/* Master must be open before slave */
+	if (!tty)
+		return ERR_PTR(-EIO);
+	return tty;
+}
+
 static void pty_shutdown(struct tty_struct *tty)
 {
 	/* We have our own method as we don't use the tty index */
@@ -399,6 +434,7 @@ static void pty_shutdown(struct tty_struct *tty)
 }
 
 static const struct tty_operations ptm_unix98_ops = {
+	.lookup = ptm_unix98_lookup,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
@@ -411,6 +447,17 @@ static const struct tty_operations ptm_unix98_ops = {
 	.shutdown = pty_shutdown
 };
 
+static const struct tty_operations pty_unix98_ops = {
+	.lookup = pts_unix98_lookup,
+	.open = pty_open,
+	.close = pty_close,
+	.write = pty_write,
+	.write_room = pty_write_room,
+	.flush_buffer = pty_flush_buffer,
+	.chars_in_buffer = pty_chars_in_buffer,
+	.unthrottle = pty_unthrottle,
+	.set_termios = pty_set_termios,
+};
 
 /**
  *	ptmx_open		-	open a unix 98 pty master
@@ -517,7 +564,7 @@ static void __init unix98_pty_init(void)
 	pts_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW |
 		TTY_DRIVER_DYNAMIC_DEV | TTY_DRIVER_DEVPTS_MEM;
 	pts_driver->other = ptm_driver;
-	tty_set_operations(pts_driver, &pty_ops);
+	tty_set_operations(pts_driver, &pty_unix98_ops);
 	
 	if (tty_register_driver(ptm_driver))
 		panic("Couldn't register Unix98 ptm driver");
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index a540849..ac41af8 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1204,53 +1204,38 @@ static void tty_line_name(struct tty_driver *driver, int index, char *p)
 	sprintf(p, "%s%d", driver->name, index + driver->name_base);
 }
 
-/*
- * 	find_tty() - find an existing tty, if any
- * 	@driver: the driver for the tty
- * 	@idx:	 the minor number
+/**
+ *	tty_driver_lookup_tty() - find an existing tty, if any
+ *	@driver: the driver for the tty
+ *	@idx:	 the minor number
  *
- * 	Return the tty, if found or ERR_PTR() otherwise.
+ *	Return the tty, if found or ERR_PTR() otherwise.
  *
- * 	Locking: tty_mutex must be held. If tty is found, the mutex must
- * 		 be held until the 'fast-open' is also done.
+ *	Locking: tty_mutex must be held. If tty is found, the mutex must
+ *	be held until the 'fast-open' is also done. Will change once we
+ *	have refcounting in the driver and per driver locking
  */
-struct tty_struct *find_tty(struct tty_driver *driver, int idx)
+struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver, int idx)
 {
 	struct tty_struct *tty;
 
-	/* check whether we're reopening an existing tty */
-	if (driver->flags & TTY_DRIVER_DEVPTS_MEM) {
-		tty = devpts_get_tty(idx);
-		/*
-		 * If we don't have a tty here on a slave open, it's because
-		 * the master already started the close process and there's
-		 * no relation between devpts file and tty anymore.
-		 */
-		if (!tty && driver->subtype == PTY_TYPE_SLAVE)
-			return ERR_PTR(-EIO);
+	if (driver->ops->lookup)
+		return driver->ops->lookup(driver, idx);
 
-		/*
-		 * tty is safe on because we are called with tty_mutex held
-		 * and release_dev() won't change tty->count or tty->flags
-		 * without grabbing tty_mutex.
-		 */
-		if (tty && driver->subtype == PTY_TYPE_MASTER)
-			tty = tty->link;
-	} else
 		tty = driver->ttys[idx];
 	return tty;
 }
 
-/*
- * 	fast_tty_open()	- fast re-open of an open tty
- * 	@tty	- the tty to open
+/**
+ *	tty_reopen()	- fast re-open of an open tty
+ *	@tty	- the tty to open
  *
- * 	Return 0 on success, -errno on error.
+ *	Return 0 on success, -errno on error.
  *
- * 	Locking: tty_mutex must be held from the time the tty was found
- * 		 till this open completes.
+ *	Locking: tty_mutex must be held from the time the tty was found
+ *		 till this open completes.
  */
-static int fast_tty_open(struct tty_struct *tty)
+static int tty_reopen(struct tty_struct *tty)
 {
 	struct tty_driver *driver = tty->driver;
 
@@ -1271,9 +1256,7 @@ static int fast_tty_open(struct tty_struct *tty)
 	tty->count++;
 	tty->driver = driver; /* N.B. why do this every time?? */
 
-	/* FIXME */
-	if (!test_bit(TTY_LDISC, &tty->flags))
-		printk(KERN_ERR "fast_tty_open: no ldisc\n");
+	WARN_ON(!test_bit(TTY_LDISC, &tty->flags));
 
 	return 0;
 }
@@ -1312,14 +1295,14 @@ int tty_init_dev(struct tty_driver *driver, int idx,
 	int retval = 0;
 
 	/* check whether we're reopening an existing tty */
-	tty = find_tty(driver, idx);
+	tty = tty_driver_lookup_tty(driver, idx);
 	if (IS_ERR(tty)) {
 		retval = PTR_ERR(tty);
 		goto end_init;
 	}
 
 	if (tty) {
-		retval = fast_tty_open(tty);
+		retval = tty_reopen(tty);
 		if (retval)
 			return retval;
 		*ret_tty = tty;
@@ -1440,6 +1423,8 @@ int tty_init_dev(struct tty_driver *driver, int idx,
 	 * All structures have been allocated, so now we install them.
 	 * Failures after this point use release_tty to clean up, so
 	 * there's no need to null out the local pointers.
+	 *
+	 * FIXME: We want a 'driver->install method ?
 	 */
 	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM))
 		driver->ttys[idx] = tty;
@@ -1466,9 +1451,8 @@ int tty_init_dev(struct tty_driver *driver, int idx,
 
 	if (retval)
 		goto release_mem_out;
-success:
-	*ret_tty = tty;
 
+	*ret_tty = tty;
 	/* All paths come through here to release the mutex */
 end_init:
 	return retval;
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 2322313..2c5c35c 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -7,6 +7,14 @@
  * defined; unless noted otherwise, they are optional, and can be
  * filled in with a null pointer.
  *
+ * struct tty_struct * (*lookup)(struct tty_driver *self, int idx)
+ *
+ *	Return the tty device corresponding to idx, NULL if there is not
+ *	one currently in use and an ERR_PTR value on error. Called under
+ *	tty_mutex (for now!)
+ *
+ *	Optional method. Default behaviour is to use the ttys array
+ *
  * int  (*open)(struct tty_struct * tty, struct file * filp);
  *
  * 	This routine is called when a particular tty device is opened.
@@ -203,6 +211,7 @@ struct tty_struct;
 struct tty_driver;
 
 struct tty_operations {
+	struct tty_struct * (*lookup)(struct tty_driver *driver, int idx);
 	int  (*open)(struct tty_struct * tty, struct file * filp);
 	void (*close)(struct tty_struct * tty, struct file * filp);
 	void (*shutdown)(struct tty_struct *tty);


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbYJEQXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbYJEQXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbYJEQUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:20:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57949 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758709AbYJEQUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:20:47 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 52/76] tty: More driver operations
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:20:47 +0100
Message-ID: <20081005162045.1997.69318.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have the lookup operation abstracted which is nice for pty cleanup but
we really want to abstract the add/remove entries as well so that we can
pull the pty code out of the tty core and create a clear defined interface
for the tty driver table.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/pty.c         |   16 ++++++++++++
 drivers/char/tty_io.c      |   57 ++++++++++++++++++++++++++++++++++++--------
 include/linux/tty_driver.h |   16 ++++++++++++
 3 files changed, 79 insertions(+), 10 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 0fdfa05..4e6490b 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -433,8 +433,22 @@ static void pty_shutdown(struct tty_struct *tty)
 	kfree(tty->termios_locked);
 }
 
+/* We have no need to install and remove our tty objects as devpts does all
+   the work for us */
+
+static int pty_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	return 0;
+}
+
+static void pty_remove(struct tty_driver *driver, struct tty_struct *tty)
+{
+}
+
 static const struct tty_operations ptm_unix98_ops = {
 	.lookup = ptm_unix98_lookup,
+	.install = pty_install,
+	.remove = pty_remove,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
@@ -449,6 +463,8 @@ static const struct tty_operations ptm_unix98_ops = {
 
 static const struct tty_operations pty_unix98_ops = {
 	.lookup = pts_unix98_lookup,
+	.install = pty_install,
+	.remove = pty_remove,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 47aa437..888380f 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1189,7 +1189,7 @@ static void pty_line_name(struct tty_driver *driver, int index, char *p)
 }
 
 /**
- *	pty_line_name	-	generate name for a tty
+ *	tty_line_name	-	generate name for a tty
  *	@driver: the tty driver in use
  *	@index: the minor number
  *	@p: output buffer of at least 7 bytes
@@ -1222,13 +1222,51 @@ struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver, int idx)
 	if (driver->ops->lookup)
 		return driver->ops->lookup(driver, idx);
 
-		tty = driver->ttys[idx];
+	tty = driver->ttys[idx];
 	return tty;
 }
 
 /**
- *	tty_reopen()	- fast re-open of an open tty
- *	@tty	- the tty to open
+ *	tty_driver_install_tty() - install a tty entry in the driver
+ *	@driver: the driver for the tty
+ *	@tty: the tty
+ *
+ *	Install a tty object into the driver tables. The tty->index field
+ *	will be set by the time this is called.
+ *
+ *	Locking: tty_mutex for now
+ */
+static int tty_driver_install_tty(struct tty_driver *driver,
+						struct tty_struct *tty)
+{
+	if (driver->ops->install)
+		return driver->ops->install(driver, tty);
+	driver->ttys[tty->index] = tty;
+	return 0;
+}
+
+/**
+ *	tty_driver_remove_tty() - remove a tty from the driver tables
+ *	@driver: the driver for the tty
+ *	@idx:	 the minor number
+ *
+ *	Remvoe a tty object from the driver tables. The tty->index field
+ *	will be set by the time this is called.
+ *
+ *	Locking: tty_mutex for now
+ */
+static void tty_driver_remove_tty(struct tty_driver *driver,
+						struct tty_struct *tty)
+{
+	if (driver->ops->remove)
+		driver->ops->remove(driver, tty);
+	else
+		driver->ttys[tty->index] = NULL;
+}
+
+/*
+ * 	tty_reopen()	- fast re-open of an open tty
+ * 	@tty	- the tty to open
  *
  *	Return 0 on success, -errno on error.
  *
@@ -1423,11 +1461,7 @@ int tty_init_dev(struct tty_driver *driver, int idx,
 	 * All structures have been allocated, so now we install them.
 	 * Failures after this point use release_tty to clean up, so
 	 * there's no need to null out the local pointers.
-	 *
-	 * FIXME: We want a 'driver->install method ?
 	 */
-	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM))
-		driver->ttys[idx] = tty;
 
 	if (!*tp_loc)
 		*tp_loc = tp;
@@ -1441,6 +1475,9 @@ int tty_init_dev(struct tty_driver *driver, int idx,
 	tty_driver_kref_get(driver);
 	tty->count++;
 
+	if (tty_driver_install_tty(driver, tty) < 0)
+		goto release_mem_out;
+
 	/*
 	 * Structures all installed ... call the ldisc open routines.
 	 * If we fail here just call release_tty to clean up.  No need
@@ -1502,7 +1539,7 @@ EXPORT_SYMBOL(tty_free_termios);
 
 void tty_shutdown(struct tty_struct *tty)
 {
-	tty->driver->ttys[tty->index] = NULL;
+	tty_driver_remove_tty(tty->driver, tty);
 	tty_free_termios(tty);
 }
 EXPORT_SYMBOL(tty_shutdown);
@@ -1615,7 +1652,7 @@ void tty_release_dev(struct file *filp)
 				  "free (%s)\n", tty->name);
 		return;
 	}
-	if (!(tty->driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
+	if (!devpts) {
 		if (tty != tty->driver->ttys[idx]) {
 			printk(KERN_DEBUG "tty_release_dev: driver.table[%d] not tty "
 			       "for (%s)\n", idx, tty->name);
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index ba891dd..005d06a 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -15,6 +15,20 @@
  *
  *	Optional method. Default behaviour is to use the ttys array
  *
+ * int (*install)(struct tty_driver *self, struct tty_struct *tty)
+ *
+ *	Install a new tty into the tty driver internal tables. Used in
+ *	conjunction with lookup and remove methods.
+ *
+ *	Optional method. Default behaviour is to use the ttys array
+ *
+ * void (*remove)(struct tty_driver *self, struct tty_struct *tty)
+ *
+ *	Remove a closed tty from the tty driver internal tables. Used in
+ *	conjunction with lookup and remove methods.
+ *
+ *	Optional method. Default behaviour is to use the ttys array
+ *
  * int  (*open)(struct tty_struct * tty, struct file * filp);
  *
  * 	This routine is called when a particular tty device is opened.
@@ -212,6 +226,8 @@ struct tty_driver;
 
 struct tty_operations {
 	struct tty_struct * (*lookup)(struct tty_driver *driver, int idx);
+	int  (*install)(struct tty_driver *driver, struct tty_struct *tty);
+	void (*remove)(struct tty_driver *driver, struct tty_struct *tty);
 	int  (*open)(struct tty_struct * tty, struct file * filp);
 	void (*close)(struct tty_struct * tty, struct file * filp);
 	void (*shutdown)(struct tty_struct *tty);


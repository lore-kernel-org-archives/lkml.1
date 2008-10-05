Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbYJEQYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbYJEQYi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbYJEQVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:21:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57953 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758037AbYJEQVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:21:05 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 54/76] tty: extract the pty init time special cases
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:21:03 +0100
Message-ID: <20081005162100.1997.97568.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The majority of the remaining init_dev code is pty special cases. We
refactor this code into the driver->install method.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/pty.c    |  126 ++++++++++++++++++++++++++++---
 drivers/char/tty_io.c |  198 +++++++++++++++++--------------------------------
 include/linux/tty.h   |    5 +
 3 files changed, 187 insertions(+), 142 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index c984500..c5a192d 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -227,7 +227,58 @@ static void pty_set_termios(struct tty_struct *tty, struct ktermios *old_termios
         tty->termios->c_cflag |= (CS8 | CREAD);
 }
 
+static int pty_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct tty_struct *o_tty;
+	int idx = tty->index;
+	int retval;
+
+	o_tty = alloc_tty_struct();
+	if (!o_tty)
+		return -ENOMEM;
+	if (!try_module_get(driver->other->owner)) {
+		/* This cannot in fact currently happen */
+		free_tty_struct(o_tty);
+		return -ENOMEM;
+	}
+	initialize_tty_struct(o_tty, driver->other, idx);
+
+	/* We always use new tty termios data so we can do this
+	   the easy way .. */
+	retval = tty_init_termios(tty);
+	if (retval)
+		goto free_mem_out;
+
+	retval = tty_init_termios(o_tty);
+	if (retval) {
+		tty_free_termios(tty);
+		goto free_mem_out;
+	}
+	
+	/*
+	 * Everything allocated ... set up the o_tty structure.
+	 */
+	driver->other->ttys[idx] = o_tty;
+	tty_driver_kref_get(driver->other);
+	if (driver->subtype == PTY_TYPE_MASTER)
+		o_tty->count++;
+	/* Establish the links in both directions */
+	tty->link   = o_tty;
+	o_tty->link = tty;
+
+	tty_driver_kref_get(driver);
+	tty->count++;
+	driver->ttys[idx] = tty;
+	return 0;
+free_mem_out:
+	module_put(o_tty->driver->owner);
+	free_tty_struct(o_tty);
+	return -ENOMEM;
+}
+
+
 static const struct tty_operations pty_ops = {
+	.install = pty_install,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
@@ -332,6 +383,7 @@ static inline void legacy_pty_init(void) { }
 int pty_limit = NR_UNIX98_PTY_DEFAULT;
 static int pty_limit_min = 0;
 static int pty_limit_max = NR_UNIX98_PTY_MAX;
+static int pty_count = 0;
 
 static struct cdev ptmx_cdev;
 
@@ -351,6 +403,7 @@ static struct ctl_table pty_table[] = {
 		.procname	= "nr",
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
+		.data		= &pty_count,
 		.proc_handler	= &proc_dointvec,
 	}, {
 		.ctl_name	= 0
@@ -426,7 +479,7 @@ static struct tty_struct *pts_unix98_lookup(struct tty_driver *driver, int idx)
 	return tty;
 }
 
-static void pty_shutdown(struct tty_struct *tty)
+static void pty_unix98_shutdown(struct tty_struct *tty)
 {
 	/* We have our own method as we don't use the tty index */
 	kfree(tty->termios);
@@ -436,19 +489,71 @@ static void pty_shutdown(struct tty_struct *tty)
 /* We have no need to install and remove our tty objects as devpts does all
    the work for us */
 
-static int pty_install(struct tty_driver *driver, struct tty_struct *tty)
+static int pty_unix98_install(struct tty_driver *driver, struct tty_struct *tty)
 {
+	struct tty_struct *o_tty;
+	int idx = tty->index;
+
+	o_tty = alloc_tty_struct();
+	if (!o_tty)
+		return -ENOMEM;
+	if (!try_module_get(driver->other->owner)) {
+		/* This cannot in fact currently happen */
+		free_tty_struct(o_tty);
+		return -ENOMEM;
+	}
+	initialize_tty_struct(o_tty, driver->other, idx);
+
+	tty->termios = kmalloc(sizeof(struct ktermios), GFP_KERNEL);
+	if (tty->termios == NULL)
+		goto free_mem_out;
+	*tty->termios = driver->init_termios;
+	tty->termios_locked = kzalloc(sizeof(struct ktermios), GFP_KERNEL);
+	if (tty->termios_locked == NULL)
+		goto free_mem_out;
+	o_tty->termios = kmalloc(sizeof(struct ktermios), GFP_KERNEL);
+	if (o_tty->termios == NULL)
+		goto free_mem_out;
+	*o_tty->termios = driver->other->init_termios;
+	o_tty->termios_locked = kzalloc(sizeof(struct ktermios), GFP_KERNEL);
+	if (o_tty->termios_locked == NULL)
+		goto free_mem_out;
+
+	tty_driver_kref_get(driver->other);
+	if (driver->subtype == PTY_TYPE_MASTER)
+		o_tty->count++;
+	/* Establish the links in both directions */
+	tty->link   = o_tty;
+	o_tty->link = tty;
+	/*
+	 * All structures have been allocated, so now we install them.
+	 * Failures after this point use release_tty to clean up, so
+	 * there's no need to null out the local pointers.
+	 */
+	tty_driver_kref_get(driver);
+	tty->count++;
+	pty_count++;
 	return 0;
+free_mem_out:
+	kfree(o_tty->termios);
+	module_put(o_tty->driver->owner);
+	free_tty_struct(o_tty);
+	kfree(tty->termios_locked);
+	kfree(tty->termios);
+	free_tty_struct(tty);
+	module_put(driver->owner);
+	return -ENOMEM;
 }
 
-static void pty_remove(struct tty_driver *driver, struct tty_struct *tty)
+static void pty_unix98_remove(struct tty_driver *driver, struct tty_struct *tty)
 {
+	pty_count--;
 }
 
 static const struct tty_operations ptm_unix98_ops = {
 	.lookup = ptm_unix98_lookup,
-	.install = pty_install,
-	.remove = pty_remove,
+	.install = pty_unix98_install,
+	.remove = pty_unix98_remove,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
@@ -458,13 +563,13 @@ static const struct tty_operations ptm_unix98_ops = {
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
 	.ioctl = pty_unix98_ioctl,
-	.shutdown = pty_shutdown
+	.shutdown = pty_unix98_shutdown
 };
 
 static const struct tty_operations pty_unix98_ops = {
 	.lookup = pts_unix98_lookup,
-	.install = pty_install,
-	.remove = pty_remove,
+	.install = pty_unix98_install,
+	.remove = pty_unix98_remove,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
@@ -473,6 +578,7 @@ static const struct tty_operations pty_unix98_ops = {
 	.chars_in_buffer = pty_chars_in_buffer,
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
+	.shutdown = pty_unix98_shutdown
 };
 
 /**
@@ -589,10 +695,6 @@ static void __init unix98_pty_init(void)
 	if (tty_register_driver(pts_driver))
 		panic("Couldn't register Unix98 pts driver");
 
-	/* FIXME: WTF */
-#if 0	
-	pty_table[1].data = &ptm_driver->refcount;
-#endif	
 	register_sysctl_table(pty_root_table);	
 
 	/* Now create the /dev/ptmx special device */
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index b0ad488..e881e9e 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -136,8 +136,6 @@ LIST_HEAD(tty_drivers);			/* linked list of tty drivers */
 DEFINE_MUTEX(tty_mutex);
 EXPORT_SYMBOL(tty_mutex);
 
-static void initialize_tty_struct(struct tty_struct *tty);
-
 static ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
 static ssize_t tty_write(struct file *, const char __user *, size_t, loff_t *);
 ssize_t redirected_tty_write(struct file *, const char __user *,
@@ -166,7 +164,7 @@ static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
  *	Locking: none
  */
 
-static struct tty_struct *alloc_tty_struct(void)
+struct tty_struct *alloc_tty_struct(void)
 {
 	return kzalloc(sizeof(struct tty_struct), GFP_KERNEL);
 }
@@ -180,7 +178,7 @@ static struct tty_struct *alloc_tty_struct(void)
  *	Locking: none. Must be called after tty is definitely unused
  */
 
-static inline void free_tty_struct(struct tty_struct *tty)
+void free_tty_struct(struct tty_struct *tty)
 {
 	kfree(tty->write_buf);
 	tty_buffer_free_all(tty);
@@ -1227,22 +1225,70 @@ struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver, int idx)
 }
 
 /**
+ *	tty_init_termios	-  helper for termios setup
+ *	@tty: the tty to set up
+ *
+ *	Initialise the termios structures for this tty. Thus runs under
+ *	the tty_mutex currently so we can be relaxed about ordering.
+ */
+
+int tty_init_termios(struct tty_struct *tty)
+{
+	struct ktermios *tp, *ltp;
+	int idx = tty->index;
+
+	tp = tty->driver->termios[idx];
+	ltp = tty->driver->termios_locked[idx];
+	if (tp == NULL) {
+		WARN_ON(ltp != NULL);
+		tp = kmalloc(sizeof(struct ktermios), GFP_KERNEL);
+		ltp = kzalloc(sizeof(struct ktermios), GFP_KERNEL);
+		if (tp == NULL || ltp == NULL) {
+			kfree(tp);
+			kfree(ltp);
+			return -ENOMEM;
+		}
+		memcpy(tp, &tty->driver->init_termios,
+						sizeof(struct ktermios));
+		tty->driver->termios[idx] = tp;
+		tty->driver->termios_locked[idx] = ltp;
+	}
+	tty->termios = tp;
+	tty->termios_locked = ltp;
+
+	/* Compatibility until drivers always set this */
+	tty->termios->c_ispeed = tty_termios_input_baud_rate(tty->termios);
+	tty->termios->c_ospeed = tty_termios_baud_rate(tty->termios);
+	return 0;
+}
+
+/**
  *	tty_driver_install_tty() - install a tty entry in the driver
  *	@driver: the driver for the tty
  *	@tty: the tty
  *
  *	Install a tty object into the driver tables. The tty->index field
- *	will be set by the time this is called.
+ *	will be set by the time this is called. This method is responsible
+ *	for ensuring any need additional structures are allocated and
+ *	configured.
  *
  *	Locking: tty_mutex for now
  */
 static int tty_driver_install_tty(struct tty_driver *driver,
 						struct tty_struct *tty)
 {
+	int idx = tty->index;
+
 	if (driver->ops->install)
 		return driver->ops->install(driver, tty);
-	driver->ttys[tty->index] = tty;
-	return 0;
+
+	if (tty_init_termios(tty) == 0) {
+		tty_driver_kref_get(driver);
+		tty->count++;
+		driver->ttys[idx] = tty;
+		return 0;
+	}
+	return -ENOMEM;
 }
 
 /**
@@ -1327,9 +1373,7 @@ static int tty_reopen(struct tty_struct *tty)
 struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 								int first_ok)
 {
-	struct tty_struct *tty, *o_tty;
-	struct ktermios *tp, **tp_loc, *o_tp, **o_tp_loc;
-	struct ktermios *ltp, **ltp_loc, *o_ltp, **o_ltp_loc;
+	struct tty_struct *tty;
 	int retval;
 
 	/* check whether we're reopening an existing tty */
@@ -1361,118 +1405,17 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 	if (!try_module_get(driver->owner))
 		return ERR_PTR(-ENODEV);
 
-	o_tty = NULL;
-	tp = o_tp = NULL;
-	ltp = o_ltp = NULL;
-
 	tty = alloc_tty_struct();
 	if (!tty)
 		goto fail_no_mem;
-	initialize_tty_struct(tty);
-	tty->driver = driver;
-	tty->ops = driver->ops;
-	tty->index = idx;
-	tty_line_name(driver, idx, tty->name);
-
-	if (driver->flags & TTY_DRIVER_DEVPTS_MEM) {
-		tp_loc = &tty->termios;
-		ltp_loc = &tty->termios_locked;
-	} else {
-		tp_loc = &driver->termios[idx];
-		ltp_loc = &driver->termios_locked[idx];
-	}
-
-	if (!*tp_loc) {
-		tp = kmalloc(sizeof(struct ktermios), GFP_KERNEL);
-		if (!tp)
-			goto free_mem_out;
-		*tp = driver->init_termios;
-	}
-
-	if (!*ltp_loc) {
-		ltp = kzalloc(sizeof(struct ktermios), GFP_KERNEL);
-		if (!ltp)
-			goto free_mem_out;
-	}
-
-	if (driver->type == TTY_DRIVER_TYPE_PTY) {
-		o_tty = alloc_tty_struct();
-		if (!o_tty)
-			goto free_mem_out;
-		if (!try_module_get(driver->other->owner)) {
-			/* This cannot in fact currently happen */
-			free_tty_struct(o_tty);
-			o_tty = NULL;
-			goto free_mem_out;
-		}
-		initialize_tty_struct(o_tty);
-		o_tty->driver = driver->other;
-		o_tty->ops = driver->ops;
-		o_tty->index = idx;
-		tty_line_name(driver->other, idx, o_tty->name);
-
-		if (driver->flags & TTY_DRIVER_DEVPTS_MEM) {
-			o_tp_loc = &o_tty->termios;
-			o_ltp_loc = &o_tty->termios_locked;
-		} else {
-			o_tp_loc = &driver->other->termios[idx];
-			o_ltp_loc = &driver->other->termios_locked[idx];
-		}
-
-		if (!*o_tp_loc) {
-			o_tp = kmalloc(sizeof(struct ktermios), GFP_KERNEL);
-			if (!o_tp)
-				goto free_mem_out;
-			*o_tp = driver->other->init_termios;
-		}
-
-		if (!*o_ltp_loc) {
-			o_ltp = kzalloc(sizeof(struct ktermios), GFP_KERNEL);
-			if (!o_ltp)
-				goto free_mem_out;
-		}
-
-		/*
-		 * Everything allocated ... set up the o_tty structure.
-		 */
-		if (!(driver->other->flags & TTY_DRIVER_DEVPTS_MEM))
-			driver->other->ttys[idx] = o_tty;
-		if (!*o_tp_loc)
-			*o_tp_loc = o_tp;
-		if (!*o_ltp_loc)
-			*o_ltp_loc = o_ltp;
-		o_tty->termios = *o_tp_loc;
-		o_tty->termios_locked = *o_ltp_loc;
-		tty_driver_kref_get(driver->other);
-		if (driver->subtype == PTY_TYPE_MASTER)
-			o_tty->count++;
-
-		/* Establish the links in both directions */
-		tty->link   = o_tty;
-		o_tty->link = tty;
-	}
-
-	/*
-	 * All structures have been allocated, so now we install them.
-	 * Failures after this point use release_tty to clean up, so
-	 * there's no need to null out the local pointers.
-	 */
-
-	if (!*tp_loc)
-		*tp_loc = tp;
-	if (!*ltp_loc)
-		*ltp_loc = ltp;
-	tty->termios = *tp_loc;
-	tty->termios_locked = *ltp_loc;
-	/* Compatibility until drivers always set this */
-	tty->termios->c_ispeed = tty_termios_input_baud_rate(tty->termios);
-	tty->termios->c_ospeed = tty_termios_baud_rate(tty->termios);
-	tty_driver_kref_get(driver);
-	tty->count++;
+	initialize_tty_struct(tty, driver, idx);
 
 	retval = tty_driver_install_tty(driver, tty);
-	if (retval < 0)
-		goto release_mem_out;
+	if (retval < 0) {
+		free_tty_struct(tty);
+		module_put(driver->owner);
+		return ERR_PTR(retval);
+	}
 
 	/*
 	 * Structures all installed ... call the ldisc open routines.
@@ -1480,22 +1423,11 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 	 * to decrement the use counts, as release_tty doesn't care.
 	 */
 
-	retval = tty_ldisc_setup(tty, o_tty);
+	retval = tty_ldisc_setup(tty, tty->link);
 	if (retval)
 		goto release_mem_out;
 	return tty;
 
-	/* Release locally allocated memory ... nothing placed in slots */
-free_mem_out:
-	kfree(o_tp);
-	if (o_tty) {
-		module_put(o_tty->driver->owner);
-		free_tty_struct(o_tty);
-	}
-	kfree(ltp);
-	kfree(tp);
-	free_tty_struct(tty);
-
 fail_no_mem:
 	module_put(driver->owner);
 	return ERR_PTR(-ENOMEM);
@@ -2852,7 +2784,8 @@ EXPORT_SYMBOL(do_SAK);
  *	Locking: none - tty in question must not be exposed at this point
  */
 
-static void initialize_tty_struct(struct tty_struct *tty)
+void initialize_tty_struct(struct tty_struct *tty,
+		struct tty_driver *driver, int idx)
 {
 	memset(tty, 0, sizeof(struct tty_struct));
 	kref_init(&tty->kref);
@@ -2873,6 +2806,11 @@ static void initialize_tty_struct(struct tty_struct *tty)
 	spin_lock_init(&tty->ctrl_lock);
 	INIT_LIST_HEAD(&tty->tty_files);
 	INIT_WORK(&tty->SAK_work, do_SAK_work);
+
+	tty->driver = driver;
+	tty->ops = driver->ops;
+	tty->index = idx;
+	tty_line_name(driver, idx, tty->name);
 }
 
 /**
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 54523a3..3c7c757 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -401,9 +401,14 @@ extern dev_t tty_devnum(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
 extern void tty_default_fops(struct file_operations *fops);
+extern struct tty_struct *alloc_tty_struct(void);
+extern void free_tty_struct(struct tty_struct *tty);
+extern void initialize_tty_struct(struct tty_struct *tty,
+		struct tty_driver *driver, int idx);
 extern struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 								int first_ok);
 extern void tty_release_dev(struct file *filp);
+extern int tty_init_termios(struct tty_struct *tty);
 
 extern struct mutex tty_mutex;
 


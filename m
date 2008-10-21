Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbYJUTQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbYJUTQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbYJUTPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:15:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:44718 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475AbYJUTPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:15:14 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
       alan@lxorguk.ukuu.org.uk
Subject: [PATCH 5/7] kgdboc, tty: use tty open to start low level drivers
Date: Tue, 21 Oct 2008 14:14:51 -0500
Message-Id: <1224616493-23237-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1224616493-23237-5-git-send-email-jason.wessel@windriver.com>
References: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-2-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-3-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-4-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 21 Oct 2008 19:14:59.0373 (UTC) FILETIME=[4F8E65D0:01C933B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two new hooks to the tty layer in tty_io.c to allow
kgdboc to open a tty prior to the start of the user space processes,
as well as to open a tty to serial port which has nothing connected on
it.  This is for the purpose of starting the low level serial drivers
such that a control-c can be caught via the RX poll mechanism.

The two new functions, tty_console_poll_open() and
tty_console_poll_close() take care of setting/cleaning up an empty
"struct file *filp" as well as keeping the reference counts correct
for the tty device.  The new function are only accessible if
CONFIG_CONSOLE_POLL as it is a direct extension to the console poll
API.  All the filp operation for the new functions take place in the
tty_io.c so no further functions have to be exported externally as
well as allowing for the internals of the tty layer to remain private.

A few minor changes were needed in tty_io.c to deal with the fact that
the inode and fpath.dentry were NULL with the generic flip structure.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/char/tty_io.c      |   96 +++++++++++++++++++++++++++++++++++++++++---
 drivers/serial/kgdboc.c    |   26 ++++++++----
 include/linux/tty_driver.h |    5 ++
 3 files changed, 113 insertions(+), 14 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index fa44e6b..fe500ec 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -143,6 +143,8 @@ ssize_t redirected_tty_write(struct file *, const char __user *,
 static unsigned int tty_poll(struct file *, poll_table *);
 static int tty_open(struct inode *, struct file *);
 static int tty_release(struct inode *, struct file *);
+static struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
+					 struct inode *inode, int idx);
 long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
 static long tty_compat_ioctl(struct file *file, unsigned int cmd,
@@ -280,6 +282,83 @@ static struct tty_driver *get_tty_driver(dev_t device, int *index)
 }
 
 #ifdef CONFIG_CONSOLE_POLL
+/**
+ *	tty_console_poll_open	-	allocate a tty for a polled device
+ *	@driver: the tty driver
+ *	@filp: file pointer to point to the tty
+ *	@tty_line: the minor device number
+ *
+ *	This routine returns allocates an empty struct file structure
+ *	to allow a polling device to open a tty.  This ultimately
+ *	allows the low level startup code for the uart to only be
+ *	called one time, for either the polling device init or user
+ *	space tty init.
+ */
+int tty_console_poll_open(struct tty_driver *driver, struct file **filp,
+			  int tty_line)
+{
+	int ret = -EIO;
+	struct tty_struct *tty;
+	int inc_tty = 1;
+
+	if (!*filp)
+		*filp = get_empty_filp();
+	if (!*filp)
+		goto out;
+
+	mutex_lock(&tty_mutex);
+	if (!kernel_locked()) {
+		lock_kernel();
+		tty = tty_driver_lookup_tty(driver, NULL, tty_line);
+		if (!tty) {
+			tty = tty_init_dev(driver, tty_line, 0);
+			inc_tty = 0;
+		}
+		(*filp)->private_data = tty;
+		ret = tty->ops->open(tty, *filp);
+		unlock_kernel();
+	} else {
+		tty = tty_driver_lookup_tty(driver, NULL, tty_line);
+		if (!tty) {
+			tty = tty_init_dev(driver, tty_line, 0);
+			inc_tty = 0;
+		}
+		(*filp)->private_data = tty;
+		ret = tty->ops->open(tty, *filp);
+	}
+	if (ret == 0) {
+		file_move(*filp, &tty->tty_files);
+		tty->count += inc_tty;
+	} else {
+		put_filp(*filp);
+		*filp = NULL;
+	}
+	mutex_unlock(&tty_mutex);
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tty_console_poll_open);
+
+/**
+ *	tty_console_poll_close	-	shutdown a tty for a polled device
+ *	@filp: file pointer to point to the tty
+ *
+ *	Deallocate the tty device used by the polling driver, and free
+ *	the associated filp.
+ */
+void tty_console_poll_close(struct file **filp)
+{
+	if (!kernel_locked()) {
+		lock_kernel();
+		tty_release_dev(*filp);
+		unlock_kernel();
+	} else {
+		tty_release_dev(*filp);
+	}
+	put_filp(*filp);
+	*filp = NULL;
+}
+EXPORT_SYMBOL_GPL(tty_console_poll_close);
 
 /**
  *	tty_find_polling_driver	-	find device of a polled tty
@@ -552,6 +631,8 @@ static void do_tty_hangup(struct work_struct *work)
 	file_list_lock();
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
 	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
+		if (!filp->f_op)
+			continue;
 		if (filp->f_op->write == redirected_tty_write)
 			cons_filp = filp;
 		if (filp->f_op->write != tty_write)
@@ -1524,12 +1605,14 @@ void tty_release_dev(struct file *filp)
 	int	devpts;
 	int	idx;
 	char	buf[64];
-	struct 	inode *inode;
+	struct 	inode *inode = NULL;
 
-	inode = filp->f_path.dentry->d_inode;
 	tty = (struct tty_struct *)filp->private_data;
-	if (tty_paranoia_check(tty, inode, "tty_release_dev"))
-		return;
+	if (filp->f_path.dentry) {
+		inode = filp->f_path.dentry->d_inode;
+		if (tty_paranoia_check(tty, inode, "tty_release_dev"))
+			return;
+	}
 
 	check_tty_count(tty, "tty_release_dev");
 
@@ -1723,7 +1806,7 @@ void tty_release_dev(struct file *filp)
 	release_tty(tty, idx);
 
 	/* Make this pty number available for reallocation */
-	if (devpts)
+	if (devpts && inode)
 		devpts_kill_index(inode, idx);
 }
 
@@ -1950,7 +2033,8 @@ static int tty_fasync(int fd, struct file *filp, int on)
 
 	lock_kernel();
 	tty = (struct tty_struct *)filp->private_data;
-	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_fasync"))
+	if (filp->f_path.dentry &&
+	    tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_fasync"))
 		goto out;
 
 	retval = fasync_helper(fd, filp, on, &tty->fasync);
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index d5d35c3..b274a36 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -31,6 +31,7 @@ static struct kparam_string kps = {
 
 static struct tty_driver	*kgdb_tty_driver;
 static int			kgdb_tty_line;
+static struct file		*kgdb_filp;
 
 static int kgdboc_option_setup(char *opt)
 {
@@ -73,6 +74,16 @@ static int kgdboc_rx_callback(u8 c)
 
 __setup("kgdboc=", kgdboc_option_setup);
 
+static void release_kgdboc_tty(void)
+{
+	if (kgdb_tty_driver)
+		kgdb_tty_driver->ops->poll_init(kgdb_tty_driver, kgdb_tty_line,
+						NULL, (void *)-1);
+	if (kgdb_filp)
+		tty_console_poll_close(&kgdb_filp);
+	kgdb_tty_driver = NULL;
+}
+
 static int configure_kgdboc(void)
 {
 	struct tty_driver *p;
@@ -86,10 +97,7 @@ static int configure_kgdboc(void)
 
 	err = -ENODEV;
 	/* If a driver was previously configured remove it now */
-	if (kgdb_tty_driver)
-		kgdb_tty_driver->ops->poll_init(kgdb_tty_driver, kgdb_tty_line,
-						NULL, (void *)-1);
-	kgdb_tty_driver = NULL;
+	release_kgdboc_tty();
 
 	p = tty_find_polling_driver(config, &tty_line);
 	if (!p)
@@ -118,6 +126,11 @@ static int configure_kgdboc(void)
 	if (p->ops->poll_init(p, tty_line, str, kgdboc_rx_callback))
 		goto noconfig;
 
+	/* Open the port and obtain a tty which call low level driver startup */
+	if (tty_console_poll_open(kgdb_tty_driver, &kgdb_filp,
+				  kgdb_tty_line) != 0)
+		goto noconfig;
+
 	err = kgdb_register_io_module(&kgdboc_io_ops);
 	if (err)
 		goto noconfig;
@@ -127,10 +140,7 @@ static int configure_kgdboc(void)
 	return 0;
 
 noconfig:
-	if (kgdb_tty_driver)
-		kgdb_tty_driver->ops->poll_init(kgdb_tty_driver, kgdb_tty_line,
-						NULL, (void *)-1);
-	kgdb_tty_driver = NULL;
+	release_kgdboc_tty();
 	config[0] = 0;
 	configured = 0;
 
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 4c30f16..1af8393 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -310,7 +310,12 @@ extern struct tty_driver *alloc_tty_driver(int lines);
 extern void put_tty_driver(struct tty_driver *driver);
 extern void tty_set_operations(struct tty_driver *driver,
 			const struct tty_operations *op);
+#ifdef CONFIG_CONSOLE_POLL
 extern struct tty_driver *tty_find_polling_driver(char *name, int *line);
+extern int tty_console_poll_open(struct tty_driver *driver,
+			struct file **filp, int line);
+extern void tty_console_poll_close(struct file **filp);
+#endif
 
 extern void tty_driver_kref_put(struct tty_driver *driver);
 extern inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
-- 
1.6.0.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbYJEQYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbYJEQYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758732AbYJEQU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:20:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57951 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758051AbYJEQUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:20:55 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 53/76] tty: Finish fixing up the init_dev interface to use
	ERR_PTR
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:20:55 +0100
Message-ID: <20081005162052.1997.26838.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original suggestion and proposal from Sukadev Bhattiprolu.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/pty.c    |    6 ++++--
 drivers/char/tty_io.c |   52 ++++++++++++++++++++-----------------------------
 include/linux/tty.h   |    4 ++--
 3 files changed, 27 insertions(+), 35 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 4e6490b..c984500 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -501,11 +501,13 @@ static int __ptmx_open(struct inode *inode, struct file *filp)
 		return index;
 
 	mutex_lock(&tty_mutex);
-	retval = tty_init_dev(ptm_driver, index, &tty, 1);
+	tty = tty_init_dev(ptm_driver, index, 1);
 	mutex_unlock(&tty_mutex);
 
-	if (retval)
+	if (IS_ERR(tty)) {
+		retval = PTR_ERR(tty);
 		goto out;
+	}
 
 	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
 	filp->private_data = tty;
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 888380f..b0ad488 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1324,35 +1324,32 @@ static int tty_reopen(struct tty_struct *tty)
  * relaxed for the (most common) case of reopening a tty.
  */
 
-int tty_init_dev(struct tty_driver *driver, int idx,
-	struct tty_struct **ret_tty, int first_ok)
+struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
+								int first_ok)
 {
 	struct tty_struct *tty, *o_tty;
 	struct ktermios *tp, **tp_loc, *o_tp, **o_tp_loc;
 	struct ktermios *ltp, **ltp_loc, *o_ltp, **o_ltp_loc;
-	int retval = 0;
+	int retval;
 
 	/* check whether we're reopening an existing tty */
 	tty = tty_driver_lookup_tty(driver, idx);
-	if (IS_ERR(tty)) {
-		retval = PTR_ERR(tty);
-		goto end_init;
-	}
+
+	if (IS_ERR(tty))
+		return tty;
 
 	if (tty) {
 		retval = tty_reopen(tty);
 		if (retval)
-			return retval;
-		*ret_tty = tty;
-		return 0;
+			return ERR_PTR(retval);
+		return tty;
 	}
 
 	/* Check if pty master is being opened multiple times */
 	if (driver->subtype == PTY_TYPE_MASTER &&
-		(driver->flags & TTY_DRIVER_DEVPTS_MEM) && !first_ok) {
-		retval = -EIO;
-		goto end_init;
-	}
+		(driver->flags & TTY_DRIVER_DEVPTS_MEM) && !first_ok)
+		return ERR_PTR(-EIO);
+
 	/*
 	 * First time open is complex, especially for PTY devices.
 	 * This code guarantees that either everything succeeds and the
@@ -1361,10 +1358,8 @@ int tty_init_dev(struct tty_driver *driver, int idx,
 	 * and locked termios may be retained.)
 	 */
 
-	if (!try_module_get(driver->owner)) {
-		retval = -ENODEV;
-		goto end_init;
-	}
+	if (!try_module_get(driver->owner))
+		return ERR_PTR(-ENODEV);
 
 	o_tty = NULL;
 	tp = o_tp = NULL;
@@ -1475,7 +1470,8 @@ int tty_init_dev(struct tty_driver *driver, int idx,
 	tty_driver_kref_get(driver);
 	tty->count++;
 
-	if (tty_driver_install_tty(driver, tty) < 0)
+	retval = tty_driver_install_tty(driver, tty);
+	if (retval < 0)
 		goto release_mem_out;
 
 	/*
@@ -1485,14 +1481,9 @@ int tty_init_dev(struct tty_driver *driver, int idx,
 	 */
 
 	retval = tty_ldisc_setup(tty, o_tty);
-
 	if (retval)
 		goto release_mem_out;
-
-	*ret_tty = tty;
-	/* All paths come through here to release the mutex */
-end_init:
-	return retval;
+	return tty;
 
 	/* Release locally allocated memory ... nothing placed in slots */
 free_mem_out:
@@ -1507,8 +1498,7 @@ free_mem_out:
 
 fail_no_mem:
 	module_put(driver->owner);
-	retval = -ENOMEM;
-	goto end_init;
+	return ERR_PTR(-ENOMEM);
 
 	/* call the tty release_tty routine to clean out this slot */
 release_mem_out:
@@ -1516,7 +1506,7 @@ release_mem_out:
 		printk(KERN_INFO "tty_init_dev: ldisc open failed, "
 				 "clearing slot %d\n", idx);
 	release_tty(tty, idx);
-	goto end_init;
+	return ERR_PTR(retval);
 }
 
 void tty_free_termios(struct tty_struct *tty)
@@ -1925,11 +1915,11 @@ retry_open:
 		return -ENODEV;
 	}
 got_driver:
-	retval = tty_init_dev(driver, index, &tty, 0);
+	tty = tty_init_dev(driver, index, 0);
 	mutex_unlock(&tty_mutex);
 	tty_driver_kref_put(driver);
-	if (retval)
-		return retval;
+	if (IS_ERR(tty))
+		return PTR_ERR(tty);
 
 	filp->private_data = tty;
 	file_move(filp, &tty->tty_files);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 6cc7ccc..54523a3 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -401,8 +401,8 @@ extern dev_t tty_devnum(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
 extern void tty_default_fops(struct file_operations *fops);
-extern int tty_init_dev(struct tty_driver *driver, int idx,
-			struct tty_struct **ret_tty, int first_ok);
+extern struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
+								int first_ok);
 extern void tty_release_dev(struct file *filp);
 
 extern struct mutex tty_mutex;


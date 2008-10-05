Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbYJEQZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbYJEQZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbYJEQVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:21:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57957 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758048AbYJEQVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:21:20 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 56/76] Add an instance parameter devpts interfaces
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:21:20 +0100
Message-ID: <20081005162116.1997.20579.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Pass-in 'inode' or 'tty' parameter to devpts interfaces.  With multiple
devpts instances, these parameters will be used in subsequent patches
to identify the instance of devpts mounted. The parameters also help
simplify devpts implementation.

Changelog[v3]:
	- minor changes due to merge with ttydev updates
	- rename parameters to emphasize they are ptmx or pts inodes
	- pass-in tty_struct * to devpts_pty_kill() (this will help
	  cleanup the get_node() call in a subsequent patch)

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/pty.c         |   18 ++++++++++--------
 drivers/char/tty_io.c      |   14 ++++++++------
 fs/devpts/inode.c          |   11 ++++++-----
 include/linux/devpts_fs.h  |   31 +++++++++++++++++++++----------
 include/linux/tty_driver.h |    3 ++-
 5 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index c5a192d..a391bad 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -60,7 +60,7 @@ static void pty_close(struct tty_struct * tty, struct file * filp)
 		set_bit(TTY_OTHER_CLOSED, &tty->flags);
 #ifdef CONFIG_UNIX98_PTYS
 		if (tty->driver == ptm_driver)
-			devpts_pty_kill(tty->index);
+			devpts_pty_kill(tty->link);
 #endif
 		tty_vhangup(tty->link);
 	}
@@ -453,9 +453,10 @@ static int pty_unix98_ioctl(struct tty_struct *tty, struct file *file,
  *	This provides our locking.
  */
 
-static struct tty_struct *ptm_unix98_lookup(struct tty_driver *driver, int idx)
+static struct tty_struct *ptm_unix98_lookup(struct tty_driver *driver,
+		struct inode *ptm_inode, int idx)
 {
-	struct tty_struct *tty = devpts_get_tty(idx);
+	struct tty_struct *tty = devpts_get_tty(ptm_inode, idx);
 	if (tty)
 		tty = tty->link;
 	return tty;
@@ -470,9 +471,10 @@ static struct tty_struct *ptm_unix98_lookup(struct tty_driver *driver, int idx)
  *	This provides our locking.
  */
 
-static struct tty_struct *pts_unix98_lookup(struct tty_driver *driver, int idx)
+static struct tty_struct *pts_unix98_lookup(struct tty_driver *driver,
+		struct inode *pts_inode, int idx)
 {
-	struct tty_struct *tty = devpts_get_tty(idx);
+	struct tty_struct *tty = devpts_get_tty(pts_inode, idx);
 	/* Master must be open before slave */
 	if (!tty)
 		return ERR_PTR(-EIO);
@@ -602,7 +604,7 @@ static int __ptmx_open(struct inode *inode, struct file *filp)
 	nonseekable_open(inode, filp);
 
 	/* find a device that is not in use. */
-	index = devpts_new_index();
+	index = devpts_new_index(inode);
 	if (index < 0)
 		return index;
 
@@ -619,7 +621,7 @@ static int __ptmx_open(struct inode *inode, struct file *filp)
 	filp->private_data = tty;
 	file_move(filp, &tty->tty_files);
 
-	retval = devpts_pty_new(tty->link);
+	retval = devpts_pty_new(inode, tty->link);
 	if (retval)
 		goto out1;
 
@@ -630,7 +632,7 @@ out1:
 	tty_release_dev(filp);
 	return retval;
 out:
-	devpts_kill_index(index);
+	devpts_kill_index(inode, index);
 	return retval;
 }
 
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 36098ee..9590839 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1213,12 +1213,13 @@ static void tty_line_name(struct tty_driver *driver, int index, char *p)
  *	be held until the 'fast-open' is also done. Will change once we
  *	have refcounting in the driver and per driver locking
  */
-struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver, int idx)
+struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
+		struct inode *inode, int idx)
 {
 	struct tty_struct *tty;
 
 	if (driver->ops->lookup)
-		return driver->ops->lookup(driver, idx);
+		return driver->ops->lookup(driver, inode, idx);
 
 	tty = driver->ttys[idx];
 	return tty;
@@ -1539,10 +1540,11 @@ void tty_release_dev(struct file *filp)
 	int	devpts;
 	int	idx;
 	char	buf[64];
+	struct 	inode *inode;
 
+	inode = filp->f_path.dentry->d_inode;
 	tty = (struct tty_struct *)filp->private_data;
-	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode,
-							"tty_release_dev"))
+	if (tty_paranoia_check(tty, inode, "tty_release_dev"))
 		return;
 
 	check_tty_count(tty, "tty_release_dev");
@@ -1751,7 +1753,7 @@ void tty_release_dev(struct file *filp)
 
 	/* Make this pty number available for reallocation */
 	if (devpts)
-		devpts_kill_index(idx);
+		devpts_kill_index(inode, idx);
 }
 
 /**
@@ -1836,7 +1838,7 @@ retry_open:
 got_driver:
 	if (!tty) {
 		/* check whether we're reopening an existing tty */
-		tty = tty_driver_lookup_tty(driver, index);
+		tty = tty_driver_lookup_tty(driver, inode, index);
 
 		if (IS_ERR(tty))
 			return PTR_ERR(tty);
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 488eb42..638db9b 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -177,7 +177,7 @@ static struct dentry *get_node(int num)
 	return lookup_one_len(s, root, sprintf(s, "%d", num));
 }
 
-int devpts_new_index(void)
+int devpts_new_index(struct inode *ptmx_inode)
 {
 	int index;
 	int ida_ret;
@@ -205,14 +205,14 @@ retry:
 	return index;
 }
 
-void devpts_kill_index(int idx)
+void devpts_kill_index(struct inode *ptmx_inode, int idx)
 {
 	mutex_lock(&allocated_ptys_lock);
 	ida_remove(&allocated_ptys, idx);
 	mutex_unlock(&allocated_ptys_lock);
 }
 
-int devpts_pty_new(struct tty_struct *tty)
+int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
 {
 	int number = tty->index; /* tty layer puts index from devpts_new_index() in here */
 	struct tty_driver *driver = tty->driver;
@@ -245,7 +245,7 @@ int devpts_pty_new(struct tty_struct *tty)
 	return 0;
 }
 
-struct tty_struct *devpts_get_tty(int number)
+struct tty_struct *devpts_get_tty(struct inode *pts_inode, int number)
 {
 	struct dentry *dentry = get_node(number);
 	struct tty_struct *tty;
@@ -262,8 +262,9 @@ struct tty_struct *devpts_get_tty(int number)
 	return tty;
 }
 
-void devpts_pty_kill(int number)
+void devpts_pty_kill(struct tty_struct *tty)
 {
+	int number = tty->index;
 	struct dentry *dentry = get_node(number);
 
 	if (!IS_ERR(dentry)) {
diff --git a/include/linux/devpts_fs.h b/include/linux/devpts_fs.h
index 154769c..5ce0e5f 100644
--- a/include/linux/devpts_fs.h
+++ b/include/linux/devpts_fs.h
@@ -17,20 +17,31 @@
 
 #ifdef CONFIG_UNIX98_PTYS
 
-int devpts_new_index(void);
-void devpts_kill_index(int idx);
-int devpts_pty_new(struct tty_struct *tty);      /* mknod in devpts */
-struct tty_struct *devpts_get_tty(int number);	 /* get tty structure */
-void devpts_pty_kill(int number);		 /* unlink */
+int devpts_new_index(struct inode *ptmx_inode);
+void devpts_kill_index(struct inode *ptmx_inode, int idx);
+/* mknod in devpts */
+int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty);
+/* get tty structure */
+struct tty_struct *devpts_get_tty(struct inode *pts_inode, int number);
+/* unlink */
+void devpts_pty_kill(struct tty_struct *tty);
 
 #else
 
 /* Dummy stubs in the no-pty case */
-static inline int devpts_new_index(void) { return -EINVAL; }
-static inline void devpts_kill_index(int idx) { }
-static inline int devpts_pty_new(struct tty_struct *tty) { return -EINVAL; }
-static inline struct tty_struct *devpts_get_tty(int number) { return NULL; }
-static inline void devpts_pty_kill(int number) { }
+static inline int devpts_new_index(struct inode *ptmx_inode) { return -EINVAL; }
+static inline void devpts_kill_index(struct inode *ptmx_inode, int idx) { }
+static inline int devpts_pty_new(struct inode *ptmx_inode,
+				struct tty_struct *tty)
+{
+	return -EINVAL;
+}
+static inline struct tty_struct *devpts_get_tty(struct inode *pts_inode,
+		int number)
+{
+	return NULL;
+}
+static inline void devpts_pty_kill(struct tty_struct *tty) { }
 
 #endif
 
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 005d06a..78416b9 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -225,7 +225,8 @@ struct tty_struct;
 struct tty_driver;
 
 struct tty_operations {
-	struct tty_struct * (*lookup)(struct tty_driver *driver, int idx);
+	struct tty_struct * (*lookup)(struct tty_driver *driver,
+			struct inode *inode, int idx);
 	int  (*install)(struct tty_driver *driver, struct tty_struct *tty);
 	void (*remove)(struct tty_driver *driver, struct tty_struct *tty);
 	int  (*open)(struct tty_struct * tty, struct file * filp);


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761713AbYHHVgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761713AbYHHVgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758781AbYHHVgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:36:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795AbYHHVgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:36:43 -0400
Date: Fri, 8 Aug 2008 17:36:25 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org, jirislaby@gmail.com
Subject: [PATCH] vt: kill tty->count usage
Message-ID: <20080808213625.GK20355@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit e0426e6a09954d205da2d674a3d368d2715e3afd fixes a real race but
still isn't enough to prevent these:

kobject_add_internal failed for vcs7 with -EEXIST, don't try to register
things with the same name in the same direc.
Pid: 2967, comm: vcs_stress Not tainted 2.6.25 #10
 [<c04e852e>] kobject_add_internal+0x137/0x149
 [<c04e85d4>] kobject_add_varg+0x35/0x41
 [<c04e8645>] kobject_add+0x43/0x49
 [<c055e54f>] device_add+0x91/0x4b4
 [<c055e984>] device_register+0x12/0x15
 [<c055e9f6>] device_create+0x6f/0x95
 [<c053e69b>] vcs_make_sysfs+0x23/0x4f
 [<c0543aff>] con_open+0x74/0x82
 [<c0538b64>] tty_open+0x188/0x287
 [<c047b1c8>] chrdev_open+0x119/0x135
 [<c04775d4>] __dentry_open+0xcf/0x185
 [<c0477711>] nameidata_to_filp+0x1f/0x33
 [<c047b0af>] ? chrdev_open+0x0/0x135
 [<c0477753>] do_filp_open+0x2e/0x35
 [<c0627da6>] ? _spin_unlock+0x1d/0x20
 [<c04774ef>] ? get_unused_fd_flags+0xc9/0xd3
 [<c047779a>] do_sys_open+0x40/0xb5
 [<c0477851>] sys_open+0x1e/0x26
 [<c0404962>] syscall_call+0x7/0xb
 =======================

and the reason for that is a race in release_dev() that can call driver's close
two or more at the same time. If these are the last two references, both calls
will be made before tty->count is decremented. And most tty drivers check
tty->count to identify the last close so the resources can be released. So
the close() method and the tty->count should happen without concurrency or
each driver can keep the number of the references itself. Holding tty_mutex
before calling driver's close() and updating tty->count is not possible
because some drivers sleep waiting until the tx buffer is empty.

This patch was tested under normal usage and using the stress application I
wrote that triggers the problem more easily.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>

---

 drivers/char/vt.c              |   82 +++++++++++++++++++++++++++++------------
 include/linux/console_struct.h |    2 +
 2 files changed, 60 insertions(+), 24 deletions(-)

--- a/drivers/char/vt.c	2008-08-07 16:06:55.000000000 -0400
+++ b/drivers/char/vt.c	2008-08-08 17:20:19.000000000 -0400
@@ -2730,15 +2730,24 @@ static int con_open(struct tty_struct *t
 {
 	unsigned int currcons = tty->index;
 	int ret = 0;
+	struct vc_data *vc;
 
 	acquire_console_sem();
 	if (tty->driver_data == NULL) {
 		ret = vc_allocate(currcons);
 		if (ret == 0) {
-			struct vc_data *vc = vc_cons[currcons].d;
+			vc = vc_cons[currcons].d;
+
+			if (vc->vc_tty != NULL) {
+				/* we're still releasing this console entry */
+				release_console_sem();
+				return -EBUSY;
+			}
+
 			tty->driver_data = vc;
 			vc->vc_tty = tty;
 
+			kref_init(&vc->kref);
 			if (!tty->winsize.ws_row && !tty->winsize.ws_col) {
 				tty->winsize.ws_row = vc_cons[currcons].d->vc_rows;
 				tty->winsize.ws_col = vc_cons[currcons].d->vc_cols;
@@ -2751,39 +2760,63 @@ static int con_open(struct tty_struct *t
 			release_console_sem();
 			return ret;
 		}
+	} else {
+		vc = tty->driver_data;
+		kref_get(&vc->kref);
 	}
 	release_console_sem();
 	return ret;
 }
 
-/*
- * We take tty_mutex in here to prevent another thread from coming in via init_dev
- * and taking a ref against the tty while we're in the process of forgetting
- * about it and cleaning things up.
- *
- * This is because vcs_remove_sysfs() can sleep and will drop the BKL.
- */
-static void con_close(struct tty_struct *tty, struct file *filp)
+static void con_release(struct kref *kref)
 {
-	mutex_lock(&tty_mutex);
+	struct vc_data *vc = container_of(kref, struct vc_data, kref);
+	struct tty_struct *tty = vc->vc_tty;
+
+	tty->driver_data = NULL;
+
+	/* we must release the semaphore here: vcs_remove_sysfs() may sleep */
+	release_console_sem();
+	vcs_remove_sysfs(tty);
 	acquire_console_sem();
-	if (tty && tty->count == 1) {
-		struct vc_data *vc = tty->driver_data;
 
-		if (vc)
-			vc->vc_tty = NULL;
-		tty->driver_data = NULL;
-		vcs_remove_sysfs(tty);
-		release_console_sem();
-		mutex_unlock(&tty_mutex);
-		/*
-		 * tty_mutex is released, but we still hold BKL, so there is
-		 * still exclusion against init_dev()
-		 */
+	/* now this slot is officially free */
+	vc->vc_tty = NULL;
+}
+
+static void con_close(struct tty_struct *tty, struct file *filp)
+{
+	struct vc_data *vc = tty->driver_data;
+
+	/*
+	 * if this tty was hung up, all the resources have been freed already
+	 */
+	if (tty_hung_up_p(filp))
 		return;
-	}
+
+	acquire_console_sem();
+	/*
+	 * tty->driver_data can be NULL if con_open() fails because tty layer
+	 * will call us even if the first open wasn't successful.
+	 */
+	if (vc != NULL)
+		kref_put(&vc->kref, con_release);
+	release_console_sem();
+}
+
+/*
+ * hangup was called: release all resources. all the currently open files will
+ * have the file_operations changed to hung_up_tty_fops. this means that the
+ * only choice the application has is close and open again.
+ */
+static void con_hangup(struct tty_struct *tty)
+{
+	struct vc_data *vc = tty->driver_data;
+
+	acquire_console_sem();
+	BUG_ON(vc == NULL);
+	con_release(&vc->kref);
 	release_console_sem();
-	mutex_unlock(&tty_mutex);
 }
 
 static int default_italic_color    = 2; // green (ASCII)
@@ -2907,6 +2940,7 @@ static const struct tty_operations con_o
 	.start = con_start,
 	.throttle = con_throttle,
 	.unthrottle = con_unthrottle,
+	.hangup = con_hangup,
 };
 
 int __init vty_init(void)
--- a/include/linux/console_struct.h	2008-05-23 15:53:23.000000000 -0400
+++ b/include/linux/console_struct.h	2008-08-08 11:55:49.000000000 -0400
@@ -15,6 +15,7 @@
 #include <linux/wait.h>
 #include <linux/vt.h>
 #include <linux/workqueue.h>
+#include <linux/kref.h>
 
 struct vt_struct;
 
@@ -108,6 +109,7 @@ struct vc_data {
 	unsigned long	vc_uni_pagedir;
 	unsigned long	*vc_uni_pagedir_loc;  /* [!] Location of uni_pagedir variable for this console */
 	/* additional information is in vt_kern.h */
+	struct kref	kref;
 };
 
 struct vc {

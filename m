Return-Path: <linux-kernel-owner+w=401wt.eu-S932360AbYEATzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbYEATzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYEATze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:55:34 -0400
Received: from mec195e42.tmodns.net ([66.94.25.236]:43678 "EHLO
	atmailx07.tmomail.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751877AbYEATzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:55:33 -0400
X-Greylist: delayed 2034 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 15:55:33 EDT
Date: Thu, 1 May 2008 15:21:32 -0400
From: Aristeu Sergio Rozanski Filho <aris@ruivo.org>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] RFC: vt: fix vcs* sysfs file creation race
Message-ID: <20080501192131.GA4662@jake.ruivo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx engine=3.1.0-0804140000 definitions=main-0805010123
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there's a race on VT open/close path that can trigger messages
like:

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

this happens because con_release() releases acquire_console_sem(),
con_open() acquires it, finds vc_cons[currcons] unused and calls
vcs_make_sysfs() before con_release() is able to call
vcs_remove_sysfs(). vcs_remove_sysfs() can sleep so calling it with
console semaphore taken isn't a good idea.

But this isn't the only problem. Currently release_dev() checks for
tty->count without holding any locks but BKL that is acquired on
tty_release() and several tty drivers also check tty->count and some of
them without even holding any locks. This leads to the case where two
calls to release_dev()/tty->driver->close() can race and both find
tty->count == 2 and don't release anything. I see two possibilities
here:
1) We get rid of tty->count usage on drivers by implementing internal
counters. This solution would allow us to fix each driver before
converting tty->count into a kref and only be used by tty layer.
This proposed patch does eliminate tty->count usage on vt.
2) We kill the current one open/close for each tty_open, only calling
driver's open and close on the first open and last close. By looking on
the tty drivers, none of them do anything important with multiple opens
anyway (but I might be wrong on this).

So, before doing anything more intrusive, I'd to hear which option you
find better.

To reproduce this problem, I use a simple stress program available at
	jake.ruivo.org / ~aris / vcs_stress.c
with a simple script like
	while [ 1 ]; do sleep $((RANDOM % 15)); killall Xorg; done
running multiple vcs_stress sessions also helps

This patch removes the use of tty->count and tty_mutex and replaces it
by an internal kref and changes the code to only set vc_tty to NULL
after the vcs_remove_sysfs() is done.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>

---
 drivers/char/vt.c              |   62 ++++++++++++++++++++++++-----------------
 include/linux/console_struct.h |    2 +
 2 files changed, 39 insertions(+), 25 deletions(-)

--- a/drivers/char/vt.c	2008-04-30 13:10:36.000000000 -0400
+++ b/drivers/char/vt.c	2008-04-30 13:14:20.000000000 -0400
@@ -2719,15 +2719,24 @@ static int con_open(struct tty_struct *t
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
@@ -2736,39 +2745,42 @@ static int con_open(struct tty_struct *t
 			vcs_make_sysfs(tty);
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
-		release_console_sem();
-		vcs_remove_sysfs(tty);
-		mutex_unlock(&tty_mutex);
-		/*
-		 * tty_mutex is released, but we still hold BKL, so there is
-		 * still exclusion against init_dev()
-		 */
-		return;
-	}
+	/* now this slot is officially free */
+	vc->vc_tty = NULL;
+}
+
+static void con_close(struct tty_struct *tty, struct file *filp)
+{
+	struct vc_data *vc = tty->driver_data;
+
+	acquire_console_sem();
+	/*
+	 * tty->driver_data can be NULL if con_open() fails because tty layer
+	 * will call us even if the first open wasn't successful.
+	 */
+	if (vc != NULL)
+		kref_put(&vc->kref, con_release);
 	release_console_sem();
-	mutex_unlock(&tty_mutex);
 }
 
 static int default_italic_color    = 2; // green (ASCII)
--- a/include/linux/console_struct.h	2008-04-30 13:11:03.000000000 -0400
+++ b/include/linux/console_struct.h	2008-04-30 13:14:20.000000000 -0400
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

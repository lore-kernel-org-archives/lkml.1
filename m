Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZCYAso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZCYAso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756964AbZCYAak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:40 -0400
Received: from kroah.org ([198.145.64.141]:54195 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753939AbZCYAaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 51/61] vcs: hook sysfs devices into object lifetime instead of "binding"
Date: Tue, 24 Mar 2009 17:26:55 -0700
Message-Id: <1237940825-22904-51-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

During bootup performance tracing I noticed many occurrences of
vca* device creation and removal, leading to the usual userspace
uevent processing, which are, in this case, rather pointless.

A simple test showing the kernel timing (not including all the
work userspace has to do), gives us these numbers:
  $ time for i in `seq 1000`; do echo a > /dev/tty2; done
  real    0m1.142s
  user    0m0.015s
  sys     0m0.540s

If we move the hook for the vcs* driver core devices from the
tty "binding" to the vc allocation/deallocation, which is what
the vcs* devices represent, we get the following numbers:
  $ time for i in `seq 1000`; do echo a > /dev/tty2; done
  real    0m0.152s
  user    0m0.030s
  sys     0m0.072s

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vc_screen.c |   16 ++++++++--------
 drivers/char/vt.c        |    5 +++--
 include/linux/console.h  |    4 ++--
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/char/vc_screen.c b/drivers/char/vc_screen.c
index 4f3b3f9..d94d25c 100644
--- a/drivers/char/vc_screen.c
+++ b/drivers/char/vc_screen.c
@@ -479,18 +479,18 @@ static const struct file_operations vcs_fops = {
 
 static struct class *vc_class;
 
-void vcs_make_sysfs(struct tty_struct *tty)
+void vcs_make_sysfs(int index)
 {
-	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, tty->index + 1), NULL,
-		      "vcs%u", tty->index + 1);
-	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, tty->index + 129), NULL,
-		      "vcsa%u", tty->index + 1);
+	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, index + 1), NULL,
+		      "vcs%u", index + 1);
+	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, index + 129), NULL,
+		      "vcsa%u", index + 1);
 }
 
-void vcs_remove_sysfs(struct tty_struct *tty)
+void vcs_remove_sysfs(int index)
 {
-	device_destroy(vc_class, MKDEV(VCS_MAJOR, tty->index + 1));
-	device_destroy(vc_class, MKDEV(VCS_MAJOR, tty->index + 129));
+	device_destroy(vc_class, MKDEV(VCS_MAJOR, index + 1));
+	device_destroy(vc_class, MKDEV(VCS_MAJOR, index + 129));
 }
 
 int __init vcs_init(void)
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 7900bd6..2c1d133 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -778,6 +778,7 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	    }
 	    vc->vc_kmalloced = 1;
 	    vc_init(vc, vc->vc_rows, vc->vc_cols, 1);
+	    vcs_make_sysfs(currcons);
 	    atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE, &param);
 	}
 	return 0;
@@ -987,7 +988,9 @@ void vc_deallocate(unsigned int currcons)
 	if (vc_cons_allocated(currcons)) {
 		struct vc_data *vc = vc_cons[currcons].d;
 		struct vt_notifier_param param = { .vc = vc };
+
 		atomic_notifier_call_chain(&vt_notifier_list, VT_DEALLOCATE, &param);
+		vcs_remove_sysfs(currcons);
 		vc->vc_sw->con_deinit(vc);
 		put_pid(vc->vt_pid);
 		module_put(vc->vc_sw->owner);
@@ -2775,7 +2778,6 @@ static int con_open(struct tty_struct *tty, struct file *filp)
 				tty->termios->c_iflag |= IUTF8;
 			else
 				tty->termios->c_iflag &= ~IUTF8;
-			vcs_make_sysfs(tty);
 			release_console_sem();
 			return ret;
 		}
@@ -2795,7 +2797,6 @@ static void con_shutdown(struct tty_struct *tty)
 	BUG_ON(vc == NULL);
 	acquire_console_sem();
 	vc->vc_tty = NULL;
-	vcs_remove_sysfs(tty);
 	release_console_sem();
 	tty_shutdown(tty);
 }
diff --git a/include/linux/console.h b/include/linux/console.h
index a67a90c..dcca533 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -137,8 +137,8 @@ extern void resume_console(void);
 int mda_console_init(void);
 void prom_con_init(void);
 
-void vcs_make_sysfs(struct tty_struct *tty);
-void vcs_remove_sysfs(struct tty_struct *tty);
+void vcs_make_sysfs(int index);
+void vcs_remove_sysfs(int index);
 
 /* Some debug stub to catch some of the obvious races in the VT code */
 #if 1
-- 
1.6.2


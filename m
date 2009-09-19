Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbZISVmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbZISVmN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZISVmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:42:09 -0400
Received: from kroah.org ([198.145.64.141]:40484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbZISVmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:42:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 43/79] vt: add an activate and lock
Date: Sat, 19 Sep 2009 14:36:48 -0700
Message-Id: <1253396244-7885-43-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

X and other graphical interfaces need to be able to flip to a console
and lock it into graphics mode without races.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vt_ioctl.c |   38 +++++++++++++++++++++++++++++++++++++-
 include/linux/vt.h      |    7 +++++++
 2 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index d29fbd4..0fceb8f 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -972,6 +972,41 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		}
 		break;
 
+	case VT_SETACTIVATE:
+	{
+		struct vt_setactivate vsa;
+
+		if (!perm)
+			goto eperm;
+
+		if (copy_from_user(&vsa, (struct vt_setactivate __user *)arg,
+						sizeof(struct vt_setactivate)))
+			return -EFAULT;
+		if (vsa.console == 0 || vsa.console > MAX_NR_CONSOLES)
+			ret = -ENXIO;
+		else {
+			vsa.console--;
+			acquire_console_sem();
+			ret = vc_allocate(vsa.console);
+			if (ret == 0) {
+				struct vc_data *nvc;
+				/* This is safe providing we don't drop the
+				   console sem between vc_allocate and
+				   finishing referencing nvc */
+				nvc = vc_cons[vsa.console].d;
+				nvc->vt_mode = vsa.mode;
+				nvc->vt_mode.frsig = 0;
+				put_pid(nvc->vt_pid);
+				nvc->vt_pid = get_pid(task_pid(current));
+			}
+			release_console_sem();
+			if (ret)
+				break;
+			/* Commence switch and lock */
+			set_console(arg);
+		}
+	}
+
 	/*
 	 * wait until the specified VT has been activated
 	 */
@@ -1342,7 +1377,8 @@ void vc_SAK(struct work_struct *work)
 }
 
 /*
- * Performs the back end of a vt switch
+ * Performs the back end of a vt switch. Called under the console
+ * semaphore.
  */
 static void complete_change_console(struct vc_data *vc)
 {
diff --git a/include/linux/vt.h b/include/linux/vt.h
index 831daf6..7afca0d 100644
--- a/include/linux/vt.h
+++ b/include/linux/vt.h
@@ -77,4 +77,11 @@ struct vt_event {
 
 #define VT_WAITEVENT	0x560E	/* Wait for an event */
 
+struct vt_setactivate {
+	unsigned int console;
+	struct vt_mode mode;
+};
+
+#define VT_SETACTIVATE	0x560F	/* Activate and set the mode of a console */
+
 #endif /* _LINUX_VT_H */
-- 
1.6.4.2


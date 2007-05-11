Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbXEKV3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbXEKV3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758874AbXEKV3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:29:36 -0400
Received: from mailrelay1.nijmegen.internl.net ([217.149.192.44]:44228 "EHLO
	hatert.nijmegen.internl.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758257AbXEKV3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:29:35 -0400
X-Greylist: delayed 14541 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 May 2007 17:29:34 EDT
Message-Id: <20070511172441.531287388@caffeinetrip.com>
References: <20070511172326.008944330@caffeinetrip.com>
User-Agent: quilt/0.46-1
Date: Fri, 11 May 2007 19:23:28 +0200
From: Giel de Nijs <giel@caffeinetrip.com>
To: linux-kernel@vger.kernel.org
Cc: Vojtech Pavlik <vojtech@suse.cz>,
       Dimitry Torokhov <dmitry.torokhov@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Matt Domsch <matt_domsch@dell.com>,
       Rezwanul Kabir <rezwanul_kabir@dell.com>,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: [patch 2/2] input: add ioctls to console for soft release mask read/write
Content-Disposition: inline; filename=add-soft-release-ioctl-to-console.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add KDGETKEYSRL and KDSETKEYSRL to the console to control the soft release
key mask in input_dev.

Signed-off-by: Giel de Nijs <giel@caffeinetrip.com>
---

Index: linux-2.6.21.1/drivers/char/vt_ioctl.c
===================================================================
--- linux-2.6.21.1.orig/drivers/char/vt_ioctl.c	2007-05-10 19:19:32.000000000 +0200
+++ linux-2.6.21.1/drivers/char/vt_ioctl.c	2007-05-11 19:21:52.000000000 +0200
@@ -181,6 +181,29 @@
 	return kc;
 }
 
+static int
+do_kbkeysrl_ioctl(int cmd, struct kbkeysrl __user *user_kbks, int perm)
+{
+	struct kbkeysrl tmp;
+	int srl = 0;
+
+	if (copy_from_user(&tmp, user_kbks, sizeof(struct kbkeysrl)))
+		return -EFAULT;
+	switch (cmd) {
+	case KDGETKEYSRL:
+		srl = getkeysrl(tmp.scancode);
+		if (srl >= 0)
+			srl = put_user(srl, &user_kbks->srl);
+		break;
+	case KDSETKEYSRL:
+		if (!perm)
+			return -EPERM;
+		srl = setkeysrl(tmp.scancode, tmp.srl);
+		break;
+	}
+	return srl;
+}
+
 static inline int
 do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
 {
@@ -571,6 +594,12 @@
 			perm=0;
 		return do_kbkeycode_ioctl(cmd, up, perm);
 
+	case KDGETKEYSRL:
+	case KDSETKEYSRL:
+		if(!capable(CAP_SYS_TTY_CONFIG))
+			perm=0;
+		return do_kbkeysrl_ioctl(cmd, up, perm);
+
 	case KDGKBENT:
 	case KDSKBENT:
 		return do_kdsk_ioctl(cmd, up, perm, kbd);
Index: linux-2.6.21.1/include/linux/kbd_kern.h
===================================================================
--- linux-2.6.21.1.orig/include/linux/kbd_kern.h	2007-05-10 19:20:18.000000000 +0200
+++ linux-2.6.21.1/include/linux/kbd_kern.h	2007-05-10 19:25:59.000000000 +0200
@@ -143,6 +143,8 @@
 
 int getkeycode(unsigned int scancode);
 int setkeycode(unsigned int scancode, unsigned int keycode);
+int getkeysrl(unsigned int scancode);
+int setkeysrl(unsigned int scancode, int srl);
 void compute_shiftstate(void);
 
 /* defkeymap.c */
Index: linux-2.6.21.1/include/linux/kd.h
===================================================================
--- linux-2.6.21.1.orig/include/linux/kd.h	2007-05-10 19:20:27.000000000 +0200
+++ linux-2.6.21.1/include/linux/kd.h	2007-05-10 19:38:52.000000000 +0200
@@ -144,6 +144,13 @@
 
 #define KDFONTOP	0x4B72	/* font operations */
 
+struct kbkeysrl {
+	unsigned int scancode;
+	int srl;
+};
+#define KDGETKEYSRL	0x4B82  /* read kernel soft release key table entry */
+#define KDSETKEYSRL	0x4B83  /* write kernel soft release key table entry */
+
 struct console_font_op {
 	unsigned int op;	/* operation code KD_FONT_OP_* */
 	unsigned int flags;	/* KD_FONT_FLAG_* */
Index: linux-2.6.21.1/drivers/char/keyboard.c
===================================================================
--- linux-2.6.21.1.orig/drivers/char/keyboard.c	2007-05-10 19:19:39.000000000 +0200
+++ linux-2.6.21.1/drivers/char/keyboard.c	2007-05-10 19:39:46.000000000 +0200
@@ -162,7 +162,7 @@
  * Translation of scancodes to keycodes. We set them on only the first attached
  * keyboard - for per-keyboard setting, /dev/input/event is more useful.
  */
-int getkeycode(unsigned int scancode)
+struct input_dev *find_first_keyboard(void)
 {
 	struct list_head *node;
 	struct input_dev *dev = NULL;
@@ -175,6 +175,13 @@
 		}
 	}
 
+	return dev;
+}
+
+int getkeycode(unsigned int scancode)
+{
+	struct input_dev *dev = find_first_keyboard();
+
 	if (!dev)
 		return -ENODEV;
 
@@ -186,18 +193,9 @@
 
 int setkeycode(unsigned int scancode, unsigned int keycode)
 {
-	struct list_head *node;
-	struct input_dev *dev = NULL;
+	struct input_dev *dev = find_first_keyboard();
 	unsigned int i, oldkey;
 
-	list_for_each(node, &kbd_handler.h_list) {
-		struct input_handle *handle = to_handle_h(node);
-		if (handle->dev->keycodesize) {
-			dev = handle->dev;
-			break;
-		}
-	}
-
 	if (!dev)
 		return -ENODEV;
 
@@ -221,6 +219,48 @@
 }
 
 /*
+ * Read/write the soft release bit for scancodes of a keyboard. The soft release
+ * bit is used to mark keys that don't generate a hardware release event.
+ * Here, we only handle the first attached keyboard.
+ */
+int getkeysrl(unsigned int scancode)
+{
+	struct input_dev *dev = find_first_keyboard();
+
+	if (!dev)
+		return -ENODEV;
+
+	if (scancode >= dev->keycodemax)
+		return -EINVAL;
+
+	if (!dev->keysrlmask) /* driver doesn't support soft release */
+		return -EINVAL;
+
+	return !! test_bit(scancode, dev->keysrlmask);
+}
+
+int setkeysrl(unsigned int scancode, int srl)
+{
+	struct input_dev *dev = find_first_keyboard();
+
+	if (!dev)
+		return -ENODEV;
+
+	if (scancode >= dev->keycodemax)
+		return -EINVAL;
+
+	if (!dev->keysrlmask) /* driver doesn't support soft release */
+		return -EINVAL;
+
+	if (srl)
+		set_bit(scancode, dev->keysrlmask);
+	else
+		clear_bit(scancode, dev->keysrlmask);
+
+	return 0;
+}
+
+/*
  * Making beeps and bells.
  */
 static void kd_nosound(unsigned long ignored)
Index: linux-2.6.21.1/include/linux/compat_ioctl.h
===================================================================
--- linux-2.6.21.1.orig/include/linux/compat_ioctl.h	2007-05-10 20:28:43.000000000 +0200
+++ linux-2.6.21.1/include/linux/compat_ioctl.h	2007-05-10 20:30:08.000000000 +0200
@@ -172,6 +172,8 @@
 ULONG_IOCTL(KDSIGACCEPT)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)
+COMPATIBLE_IOCTL(KDGETKEYSRL)
+COMPATIBLE_IOCTL(KDSETKEYSRL)
 ULONG_IOCTL(KIOCSOUND)
 ULONG_IOCTL(KDMKTONE)
 COMPATIBLE_IOCTL(KDGKBTYPE)

-- 


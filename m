Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbZINUd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbZINUd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbZINUd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:33:57 -0400
Received: from www.tglx.de ([62.245.132.106]:53916 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbZINUd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:33:56 -0400
To: dmitry.torokhov@gmail.com
Cc: Franz.Sirl-kernel@lauterbach.com
Cc: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org
Subject: [PATCH] macintosh/hid: keycode-mapping for left click
From: John Ogness <john.ogness@linutronix.de>
Date: Mon, 14 Sep 2009 22:33:20 +0200
Message-ID: <80pr9tz2pb.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds support for mapping the left mouse button to a
keycode. The driver already mapped the middle and right buttons.

Since the single mouse-button on my Apple laptop broke, I figured the
driver might as well support all three buttons. Now I can keep using my
laptop without problems.

The patch is against 2.6.31.

John Ogness

(I do not belong to either linux-input or linux-kernel mailing lists, so
please reply directly. Thanks.)


Signed off by: <john.ogness@linutronix.de>
---
 drivers/macintosh/mac_hid.c |   24 ++++++++++++++++++++----
 include/linux/sysctl.h      |    3 ++-
 kernel/sysctl_check.c       |    1 +
 3 files changed, 23 insertions(+), 5 deletions(-)
Index: linux-2.6.31/drivers/macintosh/mac_hid.c
===================================================================
--- linux-2.6.31.orig/drivers/macintosh/mac_hid.c
+++ linux-2.6.31/drivers/macintosh/mac_hid.c
@@ -19,6 +19,7 @@
 static struct input_dev *emumousebtn;
 static int emumousebtn_input_register(void);
 static int mouse_emulate_buttons;
+static int mouse_button1_keycode;			/* no default */
 static int mouse_button2_keycode = KEY_RIGHTCTRL;	/* right control key */
 static int mouse_button3_keycode = KEY_RIGHTALT;	/* right option key */
 static int mouse_last_keycode;
@@ -35,6 +36,14 @@ static ctl_table mac_hid_files[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= DEV_MAC_HID_MOUSE_BUTTON1_KEYCODE,
+		.procname	= "mouse_button1_keycode",
+		.data		= &mouse_button1_keycode,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= DEV_MAC_HID_MOUSE_BUTTON2_KEYCODE,
 		.procname	= "mouse_button2_keycode",
 		.data		= &mouse_button2_keycode,
@@ -87,12 +96,19 @@ int mac_hid_mouse_emulate_buttons(int ca
 	case 1:
 		/* Called from keyboard.c */
 		if (mouse_emulate_buttons
-		    && (keycode == mouse_button2_keycode
+		    && ((keycode == mouse_button1_keycode
+			 && mouse_button1_keycode)
+			|| keycode == mouse_button2_keycode
 			|| keycode == mouse_button3_keycode)) {
 			if (mouse_emulate_buttons == 1) {
-				input_report_key(emumousebtn,
-						 keycode == mouse_button2_keycode ? BTN_MIDDLE : BTN_RIGHT,
-						 down);
+				unsigned int code;
+				if (keycode == mouse_button1_keycode)
+					code = BTN_LEFT;
+				else if (keycode == mouse_button2_keycode)
+					code = BTN_MIDDLE;
+				else
+					code = BTN_RIGHT;
+				input_report_key(emumousebtn, code, down);
 				input_sync(emumousebtn);
 				return 1;
 			}
Index: linux-2.6.31/include/linux/sysctl.h
===================================================================
--- linux-2.6.31.orig/include/linux/sysctl.h
+++ linux-2.6.31/include/linux/sysctl.h
@@ -916,7 +916,8 @@ enum {
 	DEV_MAC_HID_MOUSE_BUTTON_EMULATION=3,
 	DEV_MAC_HID_MOUSE_BUTTON2_KEYCODE=4,
 	DEV_MAC_HID_MOUSE_BUTTON3_KEYCODE=5,
-	DEV_MAC_HID_ADB_MOUSE_SENDS_KEYCODES=6
+	DEV_MAC_HID_ADB_MOUSE_SENDS_KEYCODES=6,
+	DEV_MAC_HID_MOUSE_BUTTON1_KEYCODE=7,
 };
 
 /* /proc/sys/dev/scsi */
Index: linux-2.6.31/kernel/sysctl_check.c
===================================================================
--- linux-2.6.31.orig/kernel/sysctl_check.c
+++ linux-2.6.31/kernel/sysctl_check.c
@@ -816,6 +816,7 @@ static const struct trans_ctl_table tran
 	/* DEV_MAC_HID_KEYBOARD_SENDS_LINUX_KEYCODES unused */
 	/* DEV_MAC_HID_KEYBOARD_LOCK_KEYCODES unused */
 	{ DEV_MAC_HID_MOUSE_BUTTON_EMULATION,	"mouse_button_emulation" },
+	{ DEV_MAC_HID_MOUSE_BUTTON1_KEYCODE,	"mouse_button1_keycode" },
 	{ DEV_MAC_HID_MOUSE_BUTTON2_KEYCODE,	"mouse_button2_keycode" },
 	{ DEV_MAC_HID_MOUSE_BUTTON3_KEYCODE,	"mouse_button3_keycode" },
 	/* DEV_MAC_HID_ADB_MOUSE_SENDS_KEYCODES unused */

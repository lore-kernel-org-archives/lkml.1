Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbXI2Ign@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbXI2Ign (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 04:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbXI2Igh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 04:36:37 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51277 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbXI2Igg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 04:36:36 -0400
Date: Sat, 29 Sep 2007 10:36:34 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Antonino Daplas <adaplas@gmail.com>
cc: Bill Nottingham <notting@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] make unicode default
Message-ID: <Pine.LNX.4.64.0709291034100.22032@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Make the vt return to the system default when it is reset.
Also make UTF-8 the system default.
Derived from http://lkml.org/lkml/2007/8/31/246

Tested and works as expected.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 drivers/char/keyboard.c |    2 +-
 drivers/char/sysrq.c    |    4 ++--
 drivers/char/vt.c       |    2 +-
 drivers/char/vt_ioctl.c |    2 +-
 include/linux/vt_kern.h |    1 +
 5 files changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6.23/drivers/char/keyboard.c
===================================================================
--- linux-2.6.23.orig/drivers/char/keyboard.c
+++ linux-2.6.23/drivers/char/keyboard.c
@@ -1366,7 +1366,7 @@ int __init kbd_init(void)
 		kbd_table[i].lockstate = KBD_DEFLOCK;
 		kbd_table[i].slockstate = 0;
 		kbd_table[i].modeflags = KBD_DEFMODE;
-		kbd_table[i].kbdmode = VC_XLATE;
+		kbd_table[i].kbdmode = default_utf8 ? VC_UNICODE : VC_XLATE;
 	}
 
 	error = input_register_handler(&kbd_handler);
Index: linux-2.6.23/drivers/char/sysrq.c
===================================================================
--- linux-2.6.23.orig/drivers/char/sysrq.c
+++ linux-2.6.23/drivers/char/sysrq.c
@@ -107,12 +107,12 @@ static void sysrq_handle_unraw(int key, 
 	struct kbd_struct *kbd = &kbd_table[fg_console];
 
 	if (kbd)
-		kbd->kbdmode = VC_XLATE;
+		kbd->kbdmode = default_utf8 ? VC_UNICODE : VC_XLATE;
 }
 static struct sysrq_key_op sysrq_unraw_op = {
 	.handler	= sysrq_handle_unraw,
 	.help_msg	= "unRaw",
-	.action_msg	= "Keyboard mode set to XLATE",
+	.action_msg	= "Keyboard mode set to system default",
 	.enable_mask	= SYSRQ_ENABLE_KEYBOARD,
 };
 #else
Index: linux-2.6.23/drivers/char/vt.c
===================================================================
--- linux-2.6.23.orig/drivers/char/vt.c
+++ linux-2.6.23/drivers/char/vt.c
@@ -158,7 +158,7 @@ static void blank_screen_t(unsigned long
 static void set_palette(struct vc_data *vc);
 
 static int printable;		/* Is console ready for printing? */
-static int default_utf8;
+int default_utf8 = true;
 module_param(default_utf8, int, S_IRUGO | S_IWUSR);
 
 /*
Index: linux-2.6.23/drivers/char/vt_ioctl.c
===================================================================
--- linux-2.6.23.orig/drivers/char/vt_ioctl.c
+++ linux-2.6.23/drivers/char/vt_ioctl.c
@@ -1070,7 +1070,7 @@ int vt_waitactive(int vt)
 void reset_vc(struct vc_data *vc)
 {
 	vc->vc_mode = KD_TEXT;
-	kbd_table[vc->vc_num].kbdmode = VC_XLATE;
+	kbd_table[vc->vc_num].kbdmode = default_utf8 ? VC_UNICODE : VC_XLATE;
 	vc->vt_mode.mode = VT_AUTO;
 	vc->vt_mode.waitv = 0;
 	vc->vt_mode.relsig = 0;
Index: linux-2.6.23/include/linux/vt_kern.h
===================================================================
--- linux-2.6.23.orig/include/linux/vt_kern.h
+++ linux-2.6.23/include/linux/vt_kern.h
@@ -87,6 +87,7 @@ extern int unbind_con_driver(const struc
 extern char con_buf[CON_BUF_SIZE];
 extern struct mutex con_buf_mtx;
 extern char vt_dont_switch;
+extern int default_utf8;
 
 struct vt_spawn_console {
 	spinlock_t lock;


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbYGUUGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbYGUUGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYGUUGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:06:25 -0400
Received: from critter.phunnypharm.org ([67.97.251.11]:48944 "EHLO
	critter.phunnypharm.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYGUUGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:06:25 -0400
X-Greylist: delayed 1387 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2008 16:06:25 EDT
From: Matthew Garrett <mjg59@srcf.ucam.org>
Date: Mon, 21 Jul 2008 15:39:44 -0400
Subject: [PATCH] VT: Restore VT fonts on switch
To: linux-kernel@vger.kernel.org
Message-Id: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all X drivers save and restore fonts on text VTs. Add code to the
kernel to explicitly save and restore them on VT switches.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Ben Collins <ben.collins@canonical.com>
---
 drivers/char/vt_ioctl.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 3211afd..b2ac3d1 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -35,6 +35,8 @@
 #include <linux/kbd_diacr.h>
 #include <linux/selection.h>
 
+#define max_font_size 65536
+
 char vt_dont_switch;
 extern struct tty_driver *console_driver;
 
@@ -1250,6 +1252,7 @@ void vc_SAK(struct work_struct *work)
 static void complete_change_console(struct vc_data *vc)
 {
 	unsigned char old_vc_mode;
+	struct vc_data *oldvc = vc_cons[fg_console].d;
 
 	last_console = fg_console;
 
@@ -1258,9 +1261,31 @@ static void complete_change_console(struct vc_data *vc)
 	 * KD_TEXT mode or vice versa, which means we need to blank or
 	 * unblank the screen later.
 	 */
-	old_vc_mode = vc_cons[fg_console].d->vc_mode;
+	old_vc_mode = oldvc->vc_mode;
+
+#if defined(CONFIG_VGA_CONSOLE)
+	if (old_vc_mode == KD_TEXT && oldvc->vc_sw == &vga_con &&
+	    oldvc->vc_sw->con_font_get) {
+		if (!oldvc->vc_font.data)
+			oldvc->vc_font.data = kmalloc(max_font_size, 
+						      GFP_KERNEL);
+		lock_kernel();
+		oldvc->vc_sw->con_font_get(oldvc, &oldvc->vc_font);
+		unlock_kernel();
+	}
+#endif
 	switch_screen(vc);
 
+#if defined(CONFIG_VGA_CONSOLE)
+	if (vc->vc_mode == KD_TEXT && vc->vc_sw == &vga_con &&
+	    vc->vc_sw->con_font_set) {
+		if (vc->vc_font.data) {
+			lock_kernel();
+			vc->vc_sw->con_font_set(vc, &vc->vc_font, 0);
+			unlock_kernel();
+		}
+	}
+#endif
 	/*
 	 * This can't appear below a successful kill_pid().  If it did,
 	 * then the *blank_screen operation could occur while X, having
-- 
1.5.4.3


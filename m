Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbZLWVW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbZLWVW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbZLWVVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:21:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:45317 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837AbZLWVVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:21:48 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       David Airlie <airlied@linux.ie>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 32/37] kms,kdb: Force unblank a console device
Date: Wed, 23 Dec 2009 15:19:45 -0600
Message-Id: <1261603190-5036-33-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-32-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-13-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-17-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-18-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-19-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-20-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-21-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-22-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-23-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-24-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-25-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-26-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-27-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-28-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-29-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-30-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-31-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-32-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:33.0489 (UTC) FILETIME=[C30A4410:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kgdboc pre exception handler must atomically save the state of the
existing VC console and activate it, if it is blanked.

Before restoring the kernel to a running state, the kgdboc post
exception handler will restore the state of the VC variables that got
changed while atomic.

CC: David Airlie <airlied@linux.ie>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/kgdboc.c       |   59 ++++++++++++++++++++++++++++++++++++-----
 drivers/video/console/fbcon.c |    8 +++++
 2 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 93b18f9..b5d7e71 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -18,6 +18,8 @@
 #include <linux/tty.h>
 #include <linux/console.h>
 #include <linux/input.h>
+#include <linux/vt_kern.h>
+#include <linux/selection.h>
 
 #define MAX_CONFIG_LEN		40
 
@@ -204,13 +206,50 @@ static int param_set_kgdboc_var(const char *kmessage, struct kernel_param *kp)
 	return configure_kgdboc();
 }
 
+#ifdef CONFIG_VT
+static int dbg_orig_vc_mode;
+static int saved_fg_con;
+static int saved_last_con;
+static int saved_want_con;
+
+static void kgdboc_pre_vt_hook(void)
+{
+	struct vc_data *vc = vc_cons[fg_console].d;
+	saved_fg_con = fg_console;
+	saved_last_con = last_console;
+	saved_want_con = want_console;
+	dbg_orig_vc_mode = vc->vc_mode;
+	vc->vc_mode = KD_TEXT;
+	console_blanked = 0;
+	vc->vc_sw->con_blank(vc, 0, 1);
+	vc->vc_sw->con_set_palette(vc, color_table);
+}
+
+static void kgdboc_post_vt_hook(void)
+{
+	fg_console = saved_fg_con;
+	last_console = saved_last_con;
+	want_console = saved_want_con;
+	vc_cons[fg_console].d->vc_mode = dbg_orig_vc_mode;
+}
+#else
+#define kgdboc_pre_vt_hook()
+#define kgdboc_post_vt_hook()
+#endif /* CONFIG_VT */
+
+static int dbg_restore_graphics;
+
 static void kgdboc_pre_exp_handler(void)
 {
-	if (kgdboc_use_kms && dbg_kms_console_core &&
-	    dbg_kms_console_core->activate_console)
-		if (dbg_kms_console_core->activate_console(dbg_kms_console_core))
+	if (!dbg_restore_graphics && kgdboc_use_kms && dbg_kms_console_core &&
+	    dbg_kms_console_core->activate_console) {
+		if (dbg_kms_console_core->activate_console(dbg_kms_console_core)) {
 			printk(KERN_ERR "kgdboc: kernel mode switch error\n");
-
+		} else {
+			dbg_restore_graphics = 1;
+			kgdboc_pre_vt_hook();
+		}
+	}
 	/* Increment the module count when the debugger is active */
 	if (!kgdb_connected)
 		try_module_get(THIS_MODULE);
@@ -222,9 +261,15 @@ static void kgdboc_post_exp_handler(void)
 	if (!kgdb_connected)
 		module_put(THIS_MODULE);
 	if (kgdboc_use_kms && dbg_kms_console_core &&
-	    dbg_kms_console_core->restore_console)
-		if (dbg_kms_console_core->restore_console(dbg_kms_console_core))
-			printk(KERN_ERR "kgdboc: graphics restore failed\n");
+	    dbg_kms_console_core->restore_console) {
+		if (dbg_restore_graphics) {
+			if (dbg_kms_console_core->restore_console(dbg_kms_console_core))
+				printk(KERN_ERR "kgdboc: graphics restore failed\n");
+			dbg_restore_graphics = 0;
+			kgdboc_post_vt_hook();
+		}
+	}
+
 #ifdef CONFIG_KDB_KEYBOARD
 	/* If using the kdb keyboard driver release all the keys. */
 	if (kgdboc_use_kbd)
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 3681c6a..138a25c 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -75,6 +75,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/crc32.h> /* For counting font checksums */
+#include <linux/kgdb.h>
 #include <asm/fb.h>
 #include <asm/irq.h>
 #include <asm/system.h>
@@ -2318,6 +2319,13 @@ static int fbcon_blank(struct vc_data *vc, int blank, int mode_switch)
 		}
 	}
 
+#ifdef CONFIG_KGDB_KDB
+		if (atomic_read(&kgdb_active) != -1) {
+			if (info->fbops->fb_blank)
+				info->fbops->fb_blank(blank, info);
+			return 0;
+		}
+#endif
  	if (!fbcon_is_inactive(vc, info)) {
 		if (ops->blank_state != blank) {
 			ops->blank_state = blank;
-- 
1.6.4.rc1


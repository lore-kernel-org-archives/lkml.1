Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0BLWku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:40:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:44591 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852Ab0BLWjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:39:51 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       David Airlie <airlied@linux.ie>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 3/7] kms,kdb: Force unblank a console device
Date: Fri, 12 Feb 2010 16:36:24 -0600
Message-Id: <1266014188-29505-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
References: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:39:25.0799 (UTC) FILETIME=[3AC8B770:01CAAC34]
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
 drivers/serial/kgdboc.c       |   25 ++++++++++++----
 drivers/video/console/fbcon.c |    7 ++++
 include/linux/kgdb.h          |    8 +++++
 kernel/debug/Makefile         |    1 +
 kernel/debug/kms_hooks.c      |   62 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 96 insertions(+), 7 deletions(-)
 create mode 100644 kernel/debug/kms_hooks.c

diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index bc1fec1..246b7c3 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -220,13 +220,19 @@ static int param_set_kgdboc_var(const char *kmessage, struct kernel_param *kp)
 	return configure_kgdboc();
 }
 
+static int dbg_restore_graphics;
+
 static void kgdboc_pre_exp_handler(void)
 {
-	if (kgdboc_use_kms && dbg_kms_ops &&
-	    dbg_kms_ops->activate_console)
-		if (dbg_kms_ops->activate_console(dbg_kms_ops))
+	if (!dbg_restore_graphics && kgdboc_use_kms && dbg_kms_ops &&
+	    dbg_kms_ops->activate_console) {
+		if (dbg_kms_ops->activate_console(dbg_kms_ops)) {
 			printk(KERN_ERR "kgdboc: kernel mode switch error\n");
-
+		} else {
+			dbg_restore_graphics = 1;
+			dbg_pre_vt_hook();
+		}
+	}
 	/* Increment the module count when the debugger is active */
 	if (!kgdb_connected)
 		try_module_get(THIS_MODULE);
@@ -238,9 +244,14 @@ static void kgdboc_post_exp_handler(void)
 	if (!kgdb_connected)
 		module_put(THIS_MODULE);
 	if (kgdboc_use_kms && dbg_kms_ops &&
-	    dbg_kms_ops->restore_console)
-		if (dbg_kms_ops->restore_console(dbg_kms_ops))
-			printk(KERN_ERR "kgdboc: graphics restore failed\n");
+	    dbg_kms_ops->restore_console) {
+		if (dbg_restore_graphics) {
+			if (dbg_kms_ops->restore_console(dbg_kms_ops))
+				printk(KERN_ERR "kgdboc: graphics restore failed\n");
+			dbg_restore_graphics = 0;
+			dbg_post_vt_hook();
+		}
+	}
 	kgdboc_clear_kbd();
 }
 
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 3681c6a..6f2ed5a 100644
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
@@ -2318,6 +2319,12 @@ static int fbcon_blank(struct vc_data *vc, int blank, int mode_switch)
 		}
 	}
 
+	if (in_dbg_master()) {
+		if (info->fbops->fb_blank)
+			info->fbops->fb_blank(blank, info);
+		return 0;
+	}
+
  	if (!fbcon_is_inactive(vc, info)) {
 		if (ops->blank_state != blank) {
 			ops->blank_state = blank;
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 9cd6baa..81bb298 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -286,6 +286,14 @@ extern atomic_t			kgdb_active;
 #endif /* CONFIG_KGDB */
 
 /* Common to all that include kgdb.h */
+#ifdef CONFIG_VT
+extern void dbg_pre_vt_hook(void);
+extern void dbg_post_vt_hook(void);
+#else /* ! CONFIG_VT */
+#define dbg_pre_vt_hook()
+#define dbg_post_vt_hook()
+#endif /* CONFIG_VT */
+
 struct dbg_kms_ops {
 	int (*activate_console) (struct dbg_kms_ops *ops);
 	int (*restore_console) (struct dbg_kms_ops *ops);
diff --git a/kernel/debug/Makefile b/kernel/debug/Makefile
index c72de00..fe342c0 100644
--- a/kernel/debug/Makefile
+++ b/kernel/debug/Makefile
@@ -3,5 +3,6 @@
 #
 
 obj-$(CONFIG_KGDB) += debug_core.o gdbstub.o
+obj-$(CONFIG_VT) += kms_hooks.o
 obj-$(CONFIG_KGDB_KDB) += kdb/
 
diff --git a/kernel/debug/kms_hooks.c b/kernel/debug/kms_hooks.c
new file mode 100644
index 0000000..c56b7ce
--- /dev/null
+++ b/kernel/debug/kms_hooks.c
@@ -0,0 +1,62 @@
+/*
+ * Created by: Jason Wessel <jason.wessel@windriver.com>
+ *
+ * Copyright (c) 2009 Wind River Systems, Inc.  All Rights Reserved.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifdef CONFIG_VT
+#include <linux/kgdb.h>
+#include <linux/console.h>
+#include <linux/vt_kern.h>
+#include <linux/selection.h>
+#include <linux/kdb.h>
+#include "kdb/kdb_private.h"
+
+static int dbg_orig_vc_mode;
+static int saved_fg_con;
+static int saved_last_con;
+static int saved_want_con;
+
+void dbg_pre_vt_hook(void)
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
+#ifdef CONFIG_KGDB_KDB
+	/* Set the initial LINES variable if it is not already set */
+	if (vc->vc_rows < 999) {
+		int linecount;
+		char lns[4];
+		const char *setargs[3] = {
+			"set",
+			"LINES",
+			lns,
+		};
+		if (kdbgetintenv(setargs[0], &linecount)) {
+			snprintf(lns, 4, "%i", vc->vc_rows);
+			kdb_set(2, setargs);
+		}
+	}
+#endif /* CONFIG_KGDB_KDB */
+}
+EXPORT_SYMBOL_GPL(dbg_pre_vt_hook);
+
+void dbg_post_vt_hook(void)
+{
+	fg_console = saved_fg_con;
+	last_console = saved_last_con;
+	want_console = saved_want_con;
+	vc_cons[fg_console].d->vc_mode = dbg_orig_vc_mode;
+}
+EXPORT_SYMBOL_GPL(dbg_post_vt_hook);
+#endif /* CONFIG_VT */
-- 
1.6.4.rc1


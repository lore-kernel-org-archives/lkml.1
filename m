Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985Ab0ANPEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab0ANPEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873Ab0ANPEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:04:41 -0500
Received: from mail.windriver.com ([147.11.1.11]:47798 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab0ANPBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:01:24 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 30/40] kgdboc,debug_core: Add call backs to allow kernel mode switching
Date: Thu, 14 Jan 2010 08:59:26 -0600
Message-Id: <1263481176-1897-31-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:01:06.0991 (UTC) FILETIME=[663CDBF0:01CA952A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hooks for the kgdb core for registration of the drm layer to provide a
call backs so as to perform kernel mode switching, for use with kdb.

CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/kgdboc.c   |   15 +++++++++++++++
 include/linux/kgdb.h      |   10 ++++++++++
 kernel/debug/debug_core.c |   23 +++++++++++++++++++++++
 3 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 217c9a2..34b0306 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -26,6 +26,7 @@ static struct kgdb_io		kgdboc_io_ops;
 /* -1 = init not run yet, 0 = unconfigured, 1 = configured. */
 static int configured		= -1;
 static int kgdboc_use_kbd;  /* 1 if we use a keyboard */
+static int kgdboc_use_kms;  /* 1 if we use kernel mode switching */
 
 static char config[MAX_CONFIG_LEN];
 static struct kparam_string kps = {
@@ -85,6 +86,11 @@ static int configure_kgdboc(void)
 	kgdboc_io_ops.is_console = 0;
 	kgdboc_use_kbd = 0;
 
+	kgdboc_use_kms = 0;
+	if (strncmp(cptr, "kms,", 4) == 0) {
+		cptr += 4;
+		kgdboc_use_kms = 1;
+	}
 #ifdef CONFIG_KDB_KEYBOARD
 	kgdb_tty_driver = NULL;
 
@@ -200,6 +206,11 @@ static int param_set_kgdboc_var(const char *kmessage, struct kernel_param *kp)
 
 static void kgdboc_pre_exp_handler(void)
 {
+	if (kgdboc_use_kms && dbg_kms_console_core &&
+	    dbg_kms_console_core->activate_console)
+		if (dbg_kms_console_core->activate_console())
+			printk(KERN_ERR "kgdboc: kernel mode switch error\n");
+
 	/* Increment the module count when the debugger is active */
 	if (!kgdb_connected)
 		try_module_get(THIS_MODULE);
@@ -210,6 +221,10 @@ static void kgdboc_post_exp_handler(void)
 	/* decrement the module count when the debugger detaches */
 	if (!kgdb_connected)
 		module_put(THIS_MODULE);
+	if (kgdboc_use_kms && dbg_kms_console_core &&
+	    dbg_kms_console_core->restore_console)
+		if (dbg_kms_console_core->restore_console())
+			printk(KERN_ERR "kgdboc: graphics restore failed\n");
 #ifdef CONFIG_KDB_KEYBOARD
 	/* If using the kdb keyboard driver release all the keys. */
 	if (kgdboc_use_kbd)
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 2d06188..35ad419 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -286,4 +286,14 @@ extern atomic_t			kgdb_active;
 extern void __init early_kgdboc_init(void);
 #endif /* CONFIG_KGDB_SERIAL_CONSOLE */
 #endif /* CONFIG_KGDB */
+
+/* Common to all that include kgdb.h */
+struct dbg_kms_console_ops {
+	int (*activate_console) (void);
+	int (*restore_console) (void);
+};
+
+#ifdef CONFIG_KGDB
+extern struct dbg_kms_console_ops *dbg_kms_console_core;
+#endif
 #endif /* _KGDB_H_ */
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index d755fd1..82c7c47 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -781,6 +781,29 @@ static void kgdb_register_callbacks(void)
 	}
 }
 
+struct dbg_kms_console_ops *dbg_kms_console_core;
+EXPORT_SYMBOL_GPL(dbg_kms_console_core);
+
+int dbg_kms_console_ops_register(struct dbg_kms_console_ops *ops)
+{
+	if (dbg_kms_console_core) {
+		printk(KERN_ERR "dbg_core: KMS ops already in use\n");
+		return -1;
+	}
+	dbg_kms_console_core = ops;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dbg_kms_console_ops_register);
+
+int dbg_kms_console_ops_unregister(struct dbg_kms_console_ops *ops)
+{
+	if (dbg_kms_console_core != ops)
+		printk(KERN_ERR "dbg_core: KMS ops do not match\n");
+	dbg_kms_console_core = NULL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dbg_kms_console_ops_unregister);
+
 static void kgdb_unregister_callbacks(void)
 {
 	/*
-- 
1.6.3.1.9.g95405b


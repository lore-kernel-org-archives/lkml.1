Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbZLWVUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbZLWVUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbZLWVUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:20:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:45112 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbZLWVUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:45 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 30/37] kgdboc,debug_core: Add call backs to allow kernel mode switching
Date: Wed, 23 Dec 2009 15:19:43 -0600
Message-Id: <1261603190-5036-31-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-30-git-send-email-jason.wessel@windriver.com>
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
X-OriginalArrivalTime: 23 Dec 2009 21:20:31.0317 (UTC) FILETIME=[C1BED850:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hooks for the kgdb core for registration of the drm layer to provide a
call backs so as to perform kernel mode switching, for use with kdb.

CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/kgdboc.c   |   15 +++++++++++++++
 include/linux/kgdb.h      |    6 ++++++
 kernel/debug/debug_core.c |   23 +++++++++++++++++++++++
 3 files changed, 44 insertions(+), 0 deletions(-)

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
index 619019a..5ce1158 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -308,6 +308,12 @@ extern int			kgdb_single_step;
 extern atomic_t			kgdb_active;
 extern void kgdb_schedule_breakpoint(void);
 
+struct dbg_kms_console_ops {
+	int (*activate_console) (void);
+	int (*restore_console) (void);
+};
+extern struct dbg_kms_console_ops *dbg_kms_console_core;
+
 #ifdef CONFIG_KGDB_SERIAL_CONSOLE
 extern void __init early_kgdboc_init(void);
 #endif /* CONFIG_KGDB_SERIAL_CONSOLE */
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index b28a0a4..14d7c4e 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -782,6 +782,29 @@ static void kgdb_register_callbacks(void)
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
1.6.4.rc1


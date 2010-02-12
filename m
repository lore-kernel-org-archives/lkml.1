Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab0BLWj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:39:56 -0500
Received: from mail.windriver.com ([147.11.1.11]:44569 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab0BLWjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:39:42 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/7] kgdboc,debug_core: Add call backs to allow kernel mode switching
Date: Fri, 12 Feb 2010 16:36:22 -0600
Message-Id: <1266014188-29505-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
References: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:39:23.0830 (UTC) FILETIME=[399C4560:01CAAC34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hooks for the kgdb core for registration of the drm layer to provide a
call backs so as to perform kernel mode switching, for use with kdb.

[jbarnes@virtuousgeek.org: add ops arg to kgdb console active & restore hooks]

CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/kgdboc.c   |   16 ++++++++++++++++
 include/linux/kgdb.h      |   22 ++++++++++++++++++++++
 kernel/debug/debug_core.c |   23 +++++++++++++++++++++++
 3 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 201cdf5..bc1fec1 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -32,6 +32,7 @@ static struct kparam_string kps = {
 	.maxlen			= MAX_CONFIG_LEN,
 };
 
+static int kgdboc_use_kms;  /* 1 if we use kernel mode switching */
 static struct tty_driver	*kgdb_tty_driver;
 static int			kgdb_tty_line;
 
@@ -116,6 +117,12 @@ static int configure_kgdboc(void)
 	kgdboc_io_ops.is_console = 0;
 	kgdb_tty_driver = NULL;
 
+	kgdboc_use_kms = 0;
+	if (strncmp(cptr, "kms,", 4) == 0) {
+		cptr += 4;
+		kgdboc_use_kms = 1;
+	}
+
 	if (kgdboc_register_kbd(&cptr))
 		goto do_register;
 
@@ -215,6 +222,11 @@ static int param_set_kgdboc_var(const char *kmessage, struct kernel_param *kp)
 
 static void kgdboc_pre_exp_handler(void)
 {
+	if (kgdboc_use_kms && dbg_kms_ops &&
+	    dbg_kms_ops->activate_console)
+		if (dbg_kms_ops->activate_console(dbg_kms_ops))
+			printk(KERN_ERR "kgdboc: kernel mode switch error\n");
+
 	/* Increment the module count when the debugger is active */
 	if (!kgdb_connected)
 		try_module_get(THIS_MODULE);
@@ -225,6 +237,10 @@ static void kgdboc_post_exp_handler(void)
 	/* decrement the module count when the debugger detaches */
 	if (!kgdb_connected)
 		module_put(THIS_MODULE);
+	if (kgdboc_use_kms && dbg_kms_ops &&
+	    dbg_kms_ops->restore_console)
+		if (dbg_kms_ops->restore_console(dbg_kms_ops))
+			printk(KERN_ERR "kgdboc: graphics restore failed\n");
 	kgdboc_clear_kbd();
 }
 
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 6c784ab..9cd6baa 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -283,9 +283,31 @@ extern int kgdb_nmicallback(int cpu, void *regs);
 
 extern int			kgdb_single_step;
 extern atomic_t			kgdb_active;
+#endif /* CONFIG_KGDB */
+
+/* Common to all that include kgdb.h */
+struct dbg_kms_ops {
+	int (*activate_console) (struct dbg_kms_ops *ops);
+	int (*restore_console) (struct dbg_kms_ops *ops);
+};
+
+#ifdef CONFIG_KGDB
 #define in_dbg_master() \
 	(raw_smp_processor_id() == atomic_read(&kgdb_active))
+
+extern struct dbg_kms_ops *dbg_kms_ops;
+extern int dbg_kms_ops_register(struct dbg_kms_ops *ops);
+extern int dbg_kms_ops_unregister(struct dbg_kms_ops *ops);
 #else /* ! CONFIG_KGDB */
 #define in_dbg_master() (0)
+
+static inline int dbg_kms_ops_register(struct dbg_kms_ops *ops)
+{
+	return 0;
+}
+static inline int dbg_kms_ops_unregister(struct dbg_kms_ops *ops)
+{
+	return 0;
+}
 #endif /* ! CONFIG_KGDB */
 #endif /* _KGDB_H_ */
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index f7ebb7f..bcd6286 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -793,6 +793,29 @@ static void kgdb_register_callbacks(void)
 	}
 }
 
+struct dbg_kms_ops *dbg_kms_ops;
+EXPORT_SYMBOL_GPL(dbg_kms_ops);
+
+int dbg_kms_ops_register(struct dbg_kms_ops *ops)
+{
+	if (dbg_kms_ops) {
+		printk(KERN_ERR "dbg_core: KMS ops already in use\n");
+		return -1;
+	}
+	dbg_kms_ops = ops;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dbg_kms_ops_register);
+
+int dbg_kms_ops_unregister(struct dbg_kms_ops *ops)
+{
+	if (dbg_kms_ops != ops)
+		printk(KERN_ERR "dbg_core: KMS ops do not match\n");
+	dbg_kms_ops = NULL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dbg_kms_ops_unregister);
+
 static void kgdb_unregister_callbacks(void)
 {
 	/*
-- 
1.6.4.rc1


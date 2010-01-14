Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809Ab0ANPEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab0ANPEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873Ab0ANPEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:04:05 -0500
Received: from mail.windriver.com ([147.11.1.11]:47810 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab0ANPB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:01:26 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 31/40] kgdb: add ops arg to kgdb console active & restore hooks
Date: Thu, 14 Jan 2010 08:59:27 -0600
Message-Id: <1263481176-1897-32-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:01:08.0929 (UTC) FILETIME=[67649310:01CA952A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>

This allows callers to store the ops structure in a parent device structure.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/kgdboc.c |    4 ++--
 include/linux/kgdb.h    |   17 ++++++++++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 34b0306..93b18f9 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -208,7 +208,7 @@ static void kgdboc_pre_exp_handler(void)
 {
 	if (kgdboc_use_kms && dbg_kms_console_core &&
 	    dbg_kms_console_core->activate_console)
-		if (dbg_kms_console_core->activate_console())
+		if (dbg_kms_console_core->activate_console(dbg_kms_console_core))
 			printk(KERN_ERR "kgdboc: kernel mode switch error\n");
 
 	/* Increment the module count when the debugger is active */
@@ -223,7 +223,7 @@ static void kgdboc_post_exp_handler(void)
 		module_put(THIS_MODULE);
 	if (kgdboc_use_kms && dbg_kms_console_core &&
 	    dbg_kms_console_core->restore_console)
-		if (dbg_kms_console_core->restore_console())
+		if (dbg_kms_console_core->restore_console(dbg_kms_console_core))
 			printk(KERN_ERR "kgdboc: graphics restore failed\n");
 #ifdef CONFIG_KDB_KEYBOARD
 	/* If using the kdb keyboard driver release all the keys. */
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 35ad419..68fa243 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -289,11 +289,22 @@ extern void __init early_kgdboc_init(void);
 
 /* Common to all that include kgdb.h */
 struct dbg_kms_console_ops {
-	int (*activate_console) (void);
-	int (*restore_console) (void);
+	int (*activate_console) (struct dbg_kms_console_ops *ops);
+	int (*restore_console) (struct dbg_kms_console_ops *ops);
 };
 
 #ifdef CONFIG_KGDB
 extern struct dbg_kms_console_ops *dbg_kms_console_core;
-#endif
+extern int dbg_kms_console_ops_register(struct dbg_kms_console_ops *ops);
+extern int dbg_kms_console_ops_unregister(struct dbg_kms_console_ops *ops);
+#else /* ! CONFIG_KGDB */
+static inline int dbg_kms_console_ops_register(struct dbg_kms_console_ops *ops)
+{
+       return 0;
+}
+static inline int dbg_kms_console_ops_unregister(struct dbg_kms_console_ops *ops)
+{
+       return 0;
+}
+#endif /* ! CONFIG_KGDB */
 #endif /* _KGDB_H_ */
-- 
1.6.3.1.9.g95405b


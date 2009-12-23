Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbZLWVU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbZLWVU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbZLWVUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:20:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:45118 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbZLWVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:46 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 31/37] kgdb: add ops arg to kgdb console active & restore hooks
Date: Wed, 23 Dec 2009 15:19:44 -0600
Message-Id: <1261603190-5036-32-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-31-git-send-email-jason.wessel@windriver.com>
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
X-OriginalArrivalTime: 23 Dec 2009 21:20:32.0427 (UTC) FILETIME=[C26837B0:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>

This allows callers to store the ops structure in a parent device structure.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/kgdboc.c |    4 ++--
 include/linux/kgdb.h    |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

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
index 5ce1158..5ba827b 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -309,10 +309,12 @@ extern atomic_t			kgdb_active;
 extern void kgdb_schedule_breakpoint(void);
 
 struct dbg_kms_console_ops {
-	int (*activate_console) (void);
-	int (*restore_console) (void);
+	int (*activate_console) (struct dbg_kms_console_ops *ops);
+	int (*restore_console) (struct dbg_kms_console_ops *ops);
 };
 extern struct dbg_kms_console_ops *dbg_kms_console_core;
+extern int dbg_kms_console_ops_register(struct dbg_kms_console_ops *ops);
+extern int dbg_kms_console_ops_unregister(struct dbg_kms_console_ops *ops);
 
 #ifdef CONFIG_KGDB_SERIAL_CONSOLE
 extern void __init early_kgdboc_init(void);
-- 
1.6.4.rc1


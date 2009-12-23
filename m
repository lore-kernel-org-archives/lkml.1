Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZLWV0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZLWV0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbZLWVUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:20:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:45132 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbZLWVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:46 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 23/37] kgdb: Add the ability to schedule a breakpoint via a tasklet
Date: Wed, 23 Dec 2009 15:19:36 -0600
Message-Id: <1261603190-5036-24-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-23-git-send-email-jason.wessel@windriver.com>
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
X-OriginalArrivalTime: 23 Dec 2009 21:20:23.0536 (UTC) FILETIME=[BD1B8F00:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some kgdb I/O modules require the ability to create a breakpoint
tasklet, such as kgdboc and external modules such as kgdboe.  The
breakpoint tasklet is used as an asynchronous entry point into the
debugger which will have a different function scope than the current
execution path where it might not be safe to have an inline
breakpoint.  This is true of some of the kgdb I/O drivers which share
code with kgdb and rest of the kernel users.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/kgdb.h      |    1 +
 kernel/debug/debug_core.c |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index f46d466..b5de457 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -303,6 +303,7 @@ extern int kgdb_nmicallback(int cpu, void *regs);
 
 extern int			kgdb_single_step;
 extern atomic_t			kgdb_active;
+extern void kgdb_schedule_breakpoint(void);
 
 #ifdef CONFIG_KGDB_SERIAL_CONSOLE
 extern void __init early_kgdboc_init(void);
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 06e73e0..e44e693 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -112,6 +112,7 @@ atomic_t			kgdb_active = ATOMIC_INIT(-1);
  */
 static atomic_t			passive_cpu_wait[NR_CPUS];
 static atomic_t			cpu_in_kgdb[NR_CPUS];
+static atomic_t			kgdb_break_tasklet_var;
 atomic_t			kgdb_setting_breakpoint;
 
 struct task_struct		*kgdb_usethread;
@@ -777,6 +778,31 @@ static void kgdb_unregister_callbacks(void)
 	}
 }
 
+/*
+ * There are times a tasklet needs to be used vs a compiled in
+ * break point so as to cause an exception outside a kgdb I/O module,
+ * such as is the case with kgdboe, where calling a breakpoint in the
+ * I/O driver itself would be fatal.
+ */
+static void kgdb_tasklet_bpt(unsigned long ing)
+{
+	kgdb_breakpoint();
+	atomic_set(&kgdb_break_tasklet_var, 0);
+}
+
+static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);
+
+void kgdb_schedule_breakpoint(void)
+{
+	if (atomic_read(&kgdb_break_tasklet_var) ||
+		atomic_read(&kgdb_active) != -1 ||
+		atomic_read(&kgdb_setting_breakpoint))
+		return;
+	atomic_inc(&kgdb_break_tasklet_var);
+	tasklet_schedule(&kgdb_tasklet_breakpoint);
+}
+EXPORT_SYMBOL_GPL(kgdb_schedule_breakpoint);
+
 static void kgdb_initial_breakpoint(void)
 {
 	kgdb_break_asap = 0;
-- 
1.6.4.rc1


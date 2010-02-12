Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab0BLWgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:36:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:44142 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab0BLWgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:36:39 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 20/28] kgdb: Add the ability to schedule a breakpoint via a tasklet
Date: Fri, 12 Feb 2010 16:35:35 -0600
Message-Id: <1266014143-29444-21-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:36:21.0583 (UTC) FILETIME=[CCFB95F0:01CAAC33]
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
index 19d1b29..ee007ea 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -271,6 +271,7 @@ extern int kgdb_mem2hex(char *mem, char *buf, int count);
 extern int kgdb_hex2mem(char *buf, char *mem, int count);
 
 extern int kgdb_isremovedbreak(unsigned long addr);
+extern void kgdb_schedule_breakpoint(void);
 
 extern int
 kgdb_handle_exception(int ex_vector, int signo, int err_code,
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 8db8e40..ef46af3 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -114,6 +114,7 @@ EXPORT_SYMBOL_GPL(kgdb_active);
  */
 static atomic_t			passive_cpu_wait[NR_CPUS];
 static atomic_t			cpu_in_kgdb[NR_CPUS];
+static atomic_t			kgdb_break_tasklet_var;
 atomic_t			kgdb_setting_breakpoint;
 
 struct task_struct		*kgdb_usethread;
@@ -781,6 +782,31 @@ static void kgdb_unregister_callbacks(void)
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


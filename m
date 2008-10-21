Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYJUTP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYJUTP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYJUTPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:15:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:44621 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524AbYJUTPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:15:04 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/7] kgdb: Add the ability to schedule a breakpoint via a tasklet
Date: Tue, 21 Oct 2008 14:14:47 -0500
Message-Id: <1224616493-23237-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com>
References: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 21 Oct 2008 19:14:54.0810 (UTC) FILETIME=[4CD623A0:01C933B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some kgdb I/O modules require the ability to create a breakpoint
tasklet, such as kgdboc and external modules such as kgdboe.  The
breakpoint tasklet is used as an asynchronous entry point into the
debugger which will have a different function scope than the current
execution path where it might not be safe to have an inline breakpoint
inside the kgdb I/O driver.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/kgdb.h |    1 +
 kernel/kgdb.c        |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 6adcc29..8fdd3cb 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -279,5 +279,6 @@ extern int kgdb_nmicallback(int cpu, void *regs);
 
 extern int			kgdb_single_step;
 extern atomic_t			kgdb_active;
+extern void kgdb_schedule_breakpoint(void);
 
 #endif /* _KGDB_H_ */
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index e4dcfb2..5365d46 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -123,6 +123,7 @@ atomic_t			kgdb_active = ATOMIC_INIT(-1);
  */
 static atomic_t			passive_cpu_wait[NR_CPUS];
 static atomic_t			cpu_in_kgdb[NR_CPUS];
+static atomic_t			kgdb_break_tasklet_var;
 atomic_t			kgdb_setting_breakpoint;
 
 struct task_struct		*kgdb_usethread;
@@ -1623,6 +1624,31 @@ static void kgdb_unregister_callbacks(void)
 	}
 }
 
+/*
+ * There are times a tasklet needs to be used vs a compiled in in
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
1.6.0.2


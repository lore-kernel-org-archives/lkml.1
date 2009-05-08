Return-Path: <linux-kernel-owner+w=401wt.eu-S1764654AbZEHV17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764654AbZEHV17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761057AbZEHVXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:23:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:44769 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970AbZEHVXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:23:37 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 11/13] kgdb: Add the ability to schedule a breakpoint via a tasklet
Date: Fri,  8 May 2009 16:23:18 -0500
Message-Id: <1241817800-9320-12-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241817800-9320-11-git-send-email-jason.wessel@windriver.com>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-2-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-3-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-4-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-5-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-6-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-7-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-8-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-9-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-10-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-11-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 08 May 2009 21:23:32.0513 (UTC) FILETIME=[3D266910:01C9D023]
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
index 166cd07..1fa0bcc 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -270,6 +270,7 @@ extern int kgdb_use_passthrough;
 extern void kgdb_msg_write(const char *s, int len);
 extern int			kgdb_single_step;
 extern atomic_t			kgdb_active;
+extern void kgdb_schedule_breakpoint(void);
 
 #ifdef CONFIG_KGDB_SERIAL_CONSOLE
 extern void __init early_kgdboc_init(void);
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index da738a2..f303410 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -136,6 +136,7 @@ atomic_t			kgdb_active = ATOMIC_INIT(-1);
  */
 static atomic_t			passive_cpu_wait[NR_CPUS];
 static atomic_t			cpu_in_kgdb[NR_CPUS];
+static atomic_t			kgdb_break_tasklet_var;
 atomic_t			kgdb_setting_breakpoint;
 
 struct task_struct		*kgdb_usethread;
@@ -1862,6 +1863,31 @@ static void kgdb_unregister_callbacks(void)
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
1.6.3.rc0.1.gf800


Return-Path: <linux-kernel-owner+w=401wt.eu-S1161260AbXDSHJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161260AbXDSHJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161227AbXDSHJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:09:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36473 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161175AbXDSHIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:08:41 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] macintosh/therm_pm72.c: Convert to kthread API.
Date: Thu, 19 Apr 2007 00:55:42 -0600
Message-Id: <11769657871691-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.0.rc1.gb60d
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com> - unquoted

This patch modifies startup of the kfand to use kthread_run
not a combination of kernel_thread and daemonize, making
the code a little simpler and more maintaintable.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/macintosh/therm_pm72.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
index b002a4b..7e9cbb7 100644
--- a/drivers/macintosh/therm_pm72.c
+++ b/drivers/macintosh/therm_pm72.c
@@ -121,6 +121,7 @@
 #include <linux/reboot.h>
 #include <linux/kmod.h>
 #include <linux/i2c.h>
+#include <linux/kthread.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
@@ -161,7 +162,7 @@ static struct slots_pid_state		slots_state;
 static int				state;
 static int				cpu_count;
 static int				cpu_pid_type;
-static pid_t				ctrl_task;
+static int				ctrl_task;
 static struct completion		ctrl_complete;
 static int				critical_state;
 static int				rackmac;
@@ -1779,8 +1780,6 @@ static int call_critical_overtemp(void)
  */
 static int main_control_loop(void *x)
 {
-	daemonize("kfand");
-
 	DBG("main_control_loop started\n");
 
 	down(&driver_lock);
@@ -1859,7 +1858,6 @@ static int main_control_loop(void *x)
 			machine_power_off();
 		}
 
-		// FIXME: Deal with signals
 		elapsed = jiffies - start;
 		if (elapsed < HZ)
 			schedule_timeout_interruptible(HZ - elapsed);
@@ -1954,9 +1952,12 @@ static int create_control_loops(void)
  */
 static void start_control_loops(void)
 {
+	struct task_struct *task;
 	init_completion(&ctrl_complete);
 
-	ctrl_task = kernel_thread(main_control_loop, NULL, SIGCHLD | CLONE_KERNEL);
+	task = kthread_run(main_control_loop, NULL, "kfand");
+	if (!IS_ERR(task))
+		ctrl_task = 1;
 }
 
 /*
-- 
1.5.0.g53756


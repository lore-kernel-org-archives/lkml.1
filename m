Return-Path: <linux-kernel-owner+w=401wt.eu-S1764476AbYBAEwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764476AbYBAEwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761903AbYBAEmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:42:52 -0500
Received: from mga10.intel.com ([192.55.52.92]:38807 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754433AbYBAEmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:42:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516627"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 30/37] Hibernation: Introduce begin() and end() callbacks
Date: Thu, 31 Jan 2008 23:37:01 -0500
Message-Id: <07f44315b9cfad180296df99bcd38879f063f092.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce global hibernation callback .end() and rename global
hibernation callback .start() to .begin(), in analogy with the
recent modifications of the global suspend callbacks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/sleep/main.c |   14 ++++++++++++--
 include/linux/suspend.h   |   14 +++++++++-----
 kernel/power/disk.c       |   33 ++++++++++++++++++++++++---------
 3 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index c37c4ea..31e8e58 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -281,7 +281,7 @@ static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
 #endif /* CONFIG_SUSPEND */
 
 #ifdef CONFIG_HIBERNATION
-static int acpi_hibernation_start(void)
+static int acpi_hibernation_begin(void)
 {
 	acpi_target_sleep_state = ACPI_STATE_S4;
 	return 0;
@@ -341,6 +341,15 @@ static void acpi_hibernation_finish(void)
 	acpi_target_sleep_state = ACPI_STATE_S0;
 }
 
+static void acpi_hibernation_end(void)
+{
+	/*
+	 * This is necessary in case acpi_hibernation_finish() is not called
+	 * during a failing transition to the sleep state.
+	 */
+	acpi_target_sleep_state = ACPI_STATE_S0;
+}
+
 static int acpi_hibernation_pre_restore(void)
 {
 	acpi_status status;
@@ -356,7 +365,8 @@ static void acpi_hibernation_restore_cleanup(void)
 }
 
 static struct platform_hibernation_ops acpi_hibernation_ops = {
-	.start = acpi_hibernation_start,
+	.begin = acpi_hibernation_begin,
+	.end = acpi_hibernation_end,
 	.pre_snapshot = acpi_hibernation_prepare,
 	.finish = acpi_hibernation_finish,
 	.prepare = acpi_hibernation_prepare,
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index a0b1dbb..646ce2d 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -136,14 +136,17 @@ extern void mark_free_pages(struct zone *zone);
 /**
  * struct platform_hibernation_ops - hibernation platform support
  *
- * The methods in this structure allow a platform to override the default
- * mechanism of shutting down the machine during a hibernation transition.
+ * The methods in this structure allow a platform to carry out special
+ * operations required by it during a hibernation transition.
  *
- * All three methods must be assigned.
+ * All the methods below must be implemented.
  *
- * @start: Tell the platform driver that we're starting hibernation.
+ * @begin: Tell the platform driver that we're starting hibernation.
  *	Called right after shrinking memory and before freezing devices.
  *
+ * @end: Called by the PM core right after resuming devices, to indicate to
+ *	the platform that the system has returned to the working state.
+ *
  * @pre_snapshot: Prepare the platform for creating the hibernation image.
  *	Called right after devices have been frozen and before the nonboot
  *	CPUs are disabled (runs with IRQs on).
@@ -178,7 +181,8 @@ extern void mark_free_pages(struct zone *zone);
  *	thawing devices (runs with IRQs on).
  */
 struct platform_hibernation_ops {
-	int (*start)(void);
+	int (*begin)(void);
+	void (*end)(void);
 	int (*pre_snapshot)(void);
 	void (*finish)(void);
 	int (*prepare)(void);
diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index 64e42ab..53c22d9 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -54,8 +54,8 @@ static struct platform_hibernation_ops *hibernation_ops;
 
 void hibernation_set_ops(struct platform_hibernation_ops *ops)
 {
-	if (ops && !(ops->start && ops->pre_snapshot && ops->finish
-	    && ops->prepare && ops->enter && ops->pre_restore
+	if (ops && !(ops->begin && ops->end &&  ops->pre_snapshot
+	    && ops->prepare && ops->finish && ops->enter && ops->pre_restore
 	    && ops->restore_cleanup)) {
 		WARN_ON(1);
 		return;
@@ -100,14 +100,25 @@ static int hibernation_test(int level) { return 0; }
 #endif /* !CONFIG_PM_DEBUG */
 
 /**
- *	platform_start - tell the platform driver that we're starting
+ *	platform_begin - tell the platform driver that we're starting
  *	hibernation
  */
 
-static int platform_start(int platform_mode)
+static int platform_begin(int platform_mode)
 {
 	return (platform_mode && hibernation_ops) ?
-		hibernation_ops->start() : 0;
+		hibernation_ops->begin() : 0;
+}
+
+/**
+ *	platform_end - tell the platform driver that we've entered the
+ *	working state
+ */
+
+static void platform_end(int platform_mode)
+{
+	if (platform_mode && hibernation_ops)
+		hibernation_ops->end();
 }
 
 /**
@@ -237,9 +248,9 @@ int hibernation_snapshot(int platform_mode)
 	if (error)
 		return error;
 
-	error = platform_start(platform_mode);
+	error = platform_begin(platform_mode);
 	if (error)
-		return error;
+		goto Close;
 
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
@@ -272,6 +283,8 @@ int hibernation_snapshot(int platform_mode)
 	device_resume();
  Resume_console:
 	resume_console();
+ Close:
+	platform_end(platform_mode);
 	return error;
 }
 
@@ -373,9 +386,9 @@ int hibernation_platform_enter(void)
 	 * hibernation_ops->finish() before saving the image, so we should let
 	 * the firmware know that we're going to enter the sleep state after all
 	 */
-	error = hibernation_ops->start();
+	error = hibernation_ops->begin();
 	if (error)
-		return error;
+		goto Close;
 
 	suspend_console();
 	error = device_suspend(PMSG_SUSPEND);
@@ -409,6 +422,8 @@ int hibernation_platform_enter(void)
 	device_resume();
  Resume_console:
 	resume_console();
+ Close:
+	hibernation_ops->end();
 	return error;
 }
 
-- 
1.5.4.rc5.16.gc0279


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbZLMWnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbZLMWnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZLMWnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:43:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42408 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbZLMWnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:43:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 4/5] PM: Add a switch for disabling/enabling asynchronous suspend/resume
Date: Sun, 13 Dec 2009 23:41:44 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <200912132338.30921.rjw@sisk.pl>
In-Reply-To: <200912132338.30921.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912132341.44506.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add sysfs attribute kernel/power/pm_async allowing the user space to
disable and enable async suspend/resume of devices.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c  |    7 ++++---
 drivers/base/power/power.h |    6 +++---
 kernel/power/main.c        |   31 ++++++++++++++++++++++++++++++-
 3 files changed, 37 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -44,6 +44,32 @@ int pm_notifier_call_chain(unsigned long
 			== NOTIFY_BAD) ? -EINVAL : 0;
 }
 
+/* If set, devices may be suspended and resumed asynchronously. */
+int pm_async_enabled = 1;
+
+static ssize_t pm_async_show(struct kobject *kobj, struct kobj_attribute *attr,
+			     char *buf)
+{
+	return sprintf(buf, "%d\n", pm_async_enabled);
+}
+
+static ssize_t pm_async_store(struct kobject *kobj, struct kobj_attribute *attr,
+			      const char *buf, size_t n)
+{
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val))
+		return -EINVAL;
+
+	if (val > 1)
+		return -EINVAL;
+
+	pm_async_enabled = val;
+	return n;
+}
+
+power_attr(pm_async);
+
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
 
@@ -208,9 +234,12 @@ static struct attribute * g[] = {
 #ifdef CONFIG_PM_TRACE
 	&pm_trace_attr.attr,
 #endif
-#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PM_DEBUG)
+#ifdef CONFIG_PM_SLEEP
+	&pm_async_attr.attr,
+#ifdef CONFIG_PM_DEBUG
 	&pm_test_attr.attr,
 #endif
+#endif
 	NULL,
 };
 
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -12,10 +12,10 @@ static inline void pm_runtime_remove(str
 
 #ifdef CONFIG_PM_SLEEP
 
-/*
- * main.c
- */
+/* kernel/power/main.c */
+extern int pm_async_enabled;
 
+/* drivers/base/power/main.c */
 extern struct list_head dpm_list;	/* The active device list */
 
 static inline struct device *to_device(struct list_head *entry)
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -175,7 +175,7 @@ static void dpm_wait(struct device *dev,
 	if (!dev)
 		return;
 
-	if (async || dev->power.async_suspend)
+	if (async || (pm_async_enabled && dev->power.async_suspend))
 		wait_for_completion(&dev->power.completion);
 }
 
@@ -521,7 +521,8 @@ static int device_resume(struct device *
 {
 	INIT_COMPLETION(dev->power.completion);
 
-	if (dev->power.async_suspend && !pm_trace_is_enabled()) {
+	if (pm_async_enabled && dev->power.async_suspend
+	    && !pm_trace_is_enabled()) {
 		get_device(dev);
 		async_schedule(async_resume, dev);
 		return 0;
@@ -806,7 +807,7 @@ static int device_suspend(struct device 
 {
 	INIT_COMPLETION(dev->power.completion);
 
-	if (dev->power.async_suspend) {
+	if (pm_async_enabled && dev->power.async_suspend) {
 		get_device(dev);
 		async_schedule(async_suspend, dev);
 		return 0;


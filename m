Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbXGKHbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbXGKHbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbXGKHbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:31:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:57856 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbXGKHba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:31:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,525,1175497200"; 
   d="scan'208";a="248994245"
Subject: [PATCH 1/2] Kexec jump: Hibernation image operations
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Jul 2007 15:30:34 +0000
Message-Id: <1184167834.12556.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 11 Jul 2007 07:31:23.0585 (UTC) FILETIME=[7BA95B10:01C7C38D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch make it possible to have multiple implementations of
hibernation image operations such as write, read, check, etc, and they
can be switched at run time through writing the
"/sys/power/hibernation_image_ops". The uswsusp is the default
implementation.

Signed-off-by: Huang Ying <ying.huang@intel.com>

 include/linux/suspend.h |   14 ++++++++++
 kernel/power/disk.c     |   64 +++++++++++++++++++++++++++++++++++++++++++-----
 kernel/power/swsusp.c   |   19 ++++++++++++++
 3 files changed, 91 insertions(+), 6 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 9c7cb64..7c552b5 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -50,6 +50,17 @@ struct hibernation_ops {
 	void (*finish)(void);
 };
 
+struct hibernation_image_ops {
+	struct list_head list;
+	char *name;
+	int (*suspend)(void);
+	int (*resume)(void);
+	int (*write)(void);
+	int (*check)(void);
+	int (*read)(void);
+	void (*close)(void);
+};
+
 #if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)
 /* kernel/power/snapshot.c */
 extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
@@ -67,6 +78,7 @@ extern void swsusp_unset_page_free(struct page *);
 extern unsigned long get_safe_page(gfp_t gfp_mask);
 
 extern void hibernation_set_ops(struct hibernation_ops *ops);
+extern void hibernation_add_image_ops(struct hibernation_image_ops *ops);
 extern int hibernate(void);
 #else
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
@@ -76,6 +88,8 @@ static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
 
 static inline void hibernation_set_ops(struct hibernation_ops *ops) {}
+static inline void hibernation_add_image_ops(struct hibernation_image_ops *ops)
+{}
 static inline int hibernate(void) { return -ENOSYS; }
 #endif /* defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND) */
 
diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index f445b9c..1b226e5 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -126,6 +126,18 @@ static void power_down(void)
 	while(1);
 }
 
+static struct hibernation_image_ops *hibernation_image_ops;
+static LIST_HEAD(all_hibernation_image_ops);
+
+void hibernation_add_image_ops(struct hibernation_image_ops *ops)
+{
+	mutex_lock(&pm_mutex);
+	if (list_empty(&all_hibernation_image_ops))
+		hibernation_image_ops = ops;
+	list_add_tail(&ops->list, &all_hibernation_image_ops);
+	mutex_unlock(&pm_mutex);
+}
+
 static void unprepare_processes(void)
 {
 	thaw_processes();
@@ -199,7 +211,7 @@ int hibernate(void)
 
 	pr_debug("PM: snapshotting memory.\n");
 	in_suspend = 1;
-	error = swsusp_suspend();
+	error = hibernation_image_ops->suspend();
 	if (error)
 		goto Enable_cpus;
 
@@ -209,7 +221,7 @@ int hibernate(void)
 		device_resume();
 		resume_console();
 		pr_debug("PM: writing image.\n");
-		error = swsusp_write();
+		error = hibernation_image_ops->write();
 		if (!error)
 			power_down();
 		else {
@@ -277,7 +289,7 @@ static int software_resume(void)
 	}
 
 	pr_debug("PM: Checking swsusp image.\n");
-	error = swsusp_check();
+	error = hibernation_image_ops->check();
 	if (error)
 		goto Unlock;
 
@@ -294,13 +306,13 @@ static int software_resume(void)
 	pr_debug("PM: Preparing processes for restore.\n");
 	error = prepare_processes();
 	if (error) {
-		swsusp_close();
+		hibernation_image_ops->close();
 		goto Done;
 	}
 
 	pr_debug("PM: Reading swsusp image.\n");
 
-	error = swsusp_read();
+	error = hibernation_image_ops->read();
 	if (error) {
 		swsusp_free();
 		goto Thaw;
@@ -315,7 +327,7 @@ static int software_resume(void)
 
 	error = disable_nonboot_cpus();
 	if (!error)
-		swsusp_resume();
+		hibernation_image_ops->resume();
 
 	enable_nonboot_cpus();
  Free:
@@ -448,6 +460,45 @@ static ssize_t disk_store(struct kset *kset, const char *buf, size_t n)
 
 power_attr(disk);
 
+static ssize_t hibernation_image_ops_show(struct kset *kset, char *buf)
+{
+	struct hibernation_image_ops *ops;
+	char *start = buf;
+
+	list_for_each_entry(ops, &all_hibernation_image_ops, list) {
+		if (ops == hibernation_image_ops)
+			buf += sprintf(buf, "[%s] ", ops->name);
+		else
+			buf += sprintf(buf, "%s ", ops->name);
+	}
+	buf += sprintf(buf, "\n");
+	return buf-start;
+}
+
+static ssize_t hibernation_image_ops_store(struct kset *kset, const char *buf,
+					   size_t n)
+{
+	char *p;
+	int len, found = 0;
+	struct hibernation_image_ops *ops;
+
+	p = memchr(buf, '\n', n);
+	len = p ? p - buf : n;
+
+	mutex_lock(&pm_mutex);
+	list_for_each_entry(ops, &all_hibernation_image_ops, list) {
+		if (!strncmp(ops->name, buf, len)) {
+			hibernation_image_ops = ops;
+			found = 1;
+			break;
+		}
+	}
+	mutex_unlock(&pm_mutex);
+	return found ? n : -EINVAL;
+}
+
+power_attr(hibernation_image_ops);
+
 static ssize_t resume_show(struct kset *kset, char *buf)
 {
 	return sprintf(buf,"%d:%d\n", MAJOR(swsusp_resume_device),
@@ -503,6 +554,7 @@ static struct attribute * g[] = {
 	&disk_attr.attr,
 	&resume_attr.attr,
 	&image_size_attr.attr,
+	&hibernation_image_ops_attr.attr,
 	NULL,
 };
 
diff --git a/kernel/power/swsusp.c b/kernel/power/swsusp.c
index 5da304c..b5c0a52 100644
--- a/kernel/power/swsusp.c
+++ b/kernel/power/swsusp.c
@@ -337,3 +337,22 @@ int swsusp_resume(void)
 	local_irq_enable();
 	return error;
 }
+
+static struct hibernation_image_ops uswsusp_hibernation_image_ops =
+{
+	.name = "uswsusp",
+	.suspend = swsusp_suspend,
+	.resume = swsusp_resume,
+	.write = swsusp_write,
+	.check = swsusp_check,
+	.read = swsusp_read,
+	.close = swsusp_close,
+};
+
+static int __init uswsusp_hibernation_init(void)
+{
+	hibernation_add_image_ops(&uswsusp_hibernation_image_ops);
+	return 0;
+}
+
+subsys_initcall(uswsusp_hibernation_init);

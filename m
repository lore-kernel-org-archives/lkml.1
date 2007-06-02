Return-Path: <linux-kernel-owner+w=401wt.eu-S1762612AbXFBAjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762612AbXFBAjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760026AbXFBAja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:39:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58347 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759036AbXFBAj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:39:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH -mm 2/2] PM: Disable usermode helper before hibernation and suspend
Date: Sat, 2 Jun 2007 02:44:49 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
References: <200705272229.21263.rjw@sisk.pl> <200706020241.53788.rjw@sisk.pl>
In-Reply-To: <200706020241.53788.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706020244.50180.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use a hibernation and suspend notifier to disable the user mode helper before
a hibernation/suspend and enable it after the operation.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/kmod.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc3/kernel/kmod.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/kmod.c	2007-05-31 00:00:37.000000000 +0200
+++ linux-2.6.22-rc3/kernel/kmod.c	2007-06-02 00:01:47.000000000 +0200
@@ -33,6 +33,8 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/resource.h>
+#include <linux/notifier.h>
+#include <linux/suspend.h>
 #include <asm/uaccess.h>
 
 extern int max_threads;
@@ -46,6 +48,14 @@ static struct workqueue_struct *khelper_
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 
+/*
+ * If set, both call_usermodehelper_keys() and call_usermodehelper_pipe() exit
+ * immediately returning -EBUSY.  Used for preventing user land processes from
+ * being created after the user land has been frozen during a system-wide
+ * hibernation or suspend operation.
+ */
+static int usermodehelper_disabled;
+
 /**
  * request_module - try to load a kernel module
  * @fmt:     printf style format string for the name of the module
@@ -251,6 +261,24 @@ static void __call_usermodehelper(struct
 		complete(sub_info->complete);
 }
 
+static int usermodehelper_pm_callback(struct notifier_block *nfb,
+					unsigned long action,
+					void *ignored)
+{
+	switch (action) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		usermodehelper_disabled = 1;
+		return NOTIFY_OK;
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		usermodehelper_disabled = 0;
+		return NOTIFY_OK;
+	}
+
+	return NOTIFY_DONE;
+}
+
 /**
  * call_usermodehelper_keys - start a usermode application
  * @path: pathname for the application
@@ -276,7 +304,7 @@ int call_usermodehelper_keys(char *path,
 	struct subprocess_info *sub_info;
 	int retval;
 
-	if (!khelper_wq)
+	if (!khelper_wq || usermodehelper_disabled)
 		return -EBUSY;
 
 	if (path[0] == '\0')
@@ -319,7 +347,7 @@ int call_usermodehelper_pipe(char *path,
 	};
 	struct file *f;
 
-	if (!khelper_wq)
+	if (!khelper_wq || usermodehelper_disabled)
 		return -EBUSY;
 
 	if (path[0] == '\0')
@@ -347,4 +375,5 @@ void __init usermodehelper_init(void)
 {
 	khelper_wq = create_singlethread_workqueue("khelper");
 	BUG_ON(!khelper_wq);
+	pm_notifier(usermodehelper_pm_callback, 0);
 }

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbZGOHii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbZGOHii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZGOHig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:38:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:46564 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbZGOHh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:37:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,403,1243839600"; 
   d="scan'208";a="532942142"
Subject: [PATCH 4/8] introduce device async suspend
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 15:38:40 +0800
Message-Id: <1247643520.26272.81.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


introduce device async suspend.

If boot option "device_async_action" is added,
devices can be suspended asynchronously.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/base/power/main.c |    6 +++++-
 include/linux/async_dev.h |    3 ++-
 drivers/base/async_dev.c        |   13 ++++++++++++-
 3 files changed, 19 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -24,6 +24,7 @@
 #include <linux/resume-trace.h>
 #include <linux/rwsem.h>
 #include <linux/interrupt.h>
+#include <linux/async_dev.h>
 
 #include "../base.h"
 #include "power.h"
@@ -678,7 +679,8 @@ static int dpm_suspend(pm_message_t stat
 		get_device(dev);
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_suspend(dev, state);
+		error = dev_async_schedule(dev, device_suspend, &state,
+						DEV_ASYNC_SUSPEND);
 
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
@@ -693,6 +695,8 @@ static int dpm_suspend(pm_message_t stat
 	}
 	list_splice(&list, dpm_list.prev);
 	mutex_unlock(&dpm_list_mtx);
+
+	dev_async_synchronization();
 	return error;
 }
 
Index: linux-2.6/drivers/base/async_dev.c
===================================================================
--- linux-2.6.orig/drivers/base/async_dev.c
+++ linux-2.6/drivers/base/async_dev.c
@@ -17,6 +17,8 @@
 static LIST_HEAD(dev_async_list);
 static int dev_async_enabled;
 
+typedef int (*dev_async_suspend)(struct device *, pm_message_t);
+
 struct dev_async_context {
 	struct device *dev;
 	void *data;
@@ -27,10 +29,19 @@ struct dev_async_context {
 static int dev_action(struct device *dev, void *func,
 			void *data, int type)
 {
+	int error = 0;
+
 	if (!func)
 		return -EINVAL;
 
-	return 0;
+	switch (type) {
+	case DEV_ASYNC_SUSPEND:
+		error = ((dev_async_suspend)func)(dev, *((pm_message_t *)data));
+		break;
+	default:
+		return -EINVAL;
+	}
+	return error;
 }
 
 static void dev_async_action(void *data, async_cookie_t cookie)
Index: linux-2.6/include/linux/async_dev.h
===================================================================
--- linux-2.6.orig/include/linux/async_dev.h
+++ linux-2.6/include/linux/async_dev.h
@@ -28,7 +28,8 @@ struct dev_async_struct {
 	async_cookie_t cookie;
 };
 
-#define DEV_ASYNC_ACTIONS_ALL	0
+#define DEV_ASYNC_SUSPEND	1
+#define DEV_ASYNC_ACTIONS_ALL	DEV_ASYNC_SUSPEND
 
 extern int dev_async_schedule(struct device *, void *,
 			void *, int);



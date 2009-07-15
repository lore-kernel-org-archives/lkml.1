Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbZGOHiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbZGOHiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZGOHh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:37:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:46564 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971AbZGOHh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:37:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,403,1243839600"; 
   d="scan'208";a="430347232"
Subject: [PATCH 5/8] introduce device async resume
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 15:38:39 +0800
Message-Id: <1247643519.26272.80.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


introduce device async resume.

If boot option "dev_async_action" is added,
devices can be resumed asynhronously.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/base/power/main.c |    4 +++-
 include/linux/async_dev.h |    4 +++-
 drivers/base/async_dev.c        |    1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -445,7 +445,8 @@ static void dpm_resume(pm_message_t stat
 			dev->power.status = DPM_RESUMING;
 			mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume(dev, state);
+			error = dev_async_schedule(dev, device_resume, &state,
+							DEV_ASYNC_RESUME);
 
 			mutex_lock(&dpm_list_mtx);
 			if (error)
@@ -460,6 +461,7 @@ static void dpm_resume(pm_message_t stat
 	}
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
+	dev_async_synchronization();
 }
 
 /**
Index: linux-2.6/include/linux/async_dev.h
===================================================================
--- linux-2.6.orig/include/linux/async_dev.h
+++ linux-2.6/include/linux/async_dev.h
@@ -29,7 +29,9 @@ struct dev_async_struct {
 };
 
 #define DEV_ASYNC_SUSPEND	1
-#define DEV_ASYNC_ACTIONS_ALL	DEV_ASYNC_SUSPEND
+#define DEV_ASYNC_RESUME	2
+#define DEV_ASYNC_ACTIONS_ALL	(DEV_ASYNC_SUSPEND |	\
+				DEV_ASYNC_RESUME)
 
 extern int dev_async_schedule(struct device *, void *,
 			void *, int);
Index: linux-2.6/drivers/base/async_dev.c
===================================================================
--- linux-2.6.orig/drivers/base/async_dev.c
+++ linux-2.6/drivers/base/async_dev.c
@@ -36,6 +36,7 @@ static int dev_action(struct device *dev
 
 	switch (type) {
 	case DEV_ASYNC_SUSPEND:
+	case DEV_ASYNC_RESUME:
 		error = ((dev_async_suspend)func)(dev, *((pm_message_t *)data));
 		break;
 	default:



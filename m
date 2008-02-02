Return-Path: <linux-kernel-owner+w=401wt.eu-S935478AbYBCAAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935478AbYBCAAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935074AbYBBX6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:58:12 -0500
Received: from mail.suse.de ([195.135.220.2]:37359 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935034AbYBBX6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:58:10 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/10] PM: Export device_pm_schedule_removal
Date: Sat,  2 Feb 2008 15:56:01 -0800
Message-Id: <1201996564-21951-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080202234357.GA21721@suse.de>
References: <20080202234357.GA21721@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Move the declaration of device_pm_schedule_removal() to device.h
and make it exported, as it will be used directly by some drivers
for unregistering device objects during suspend/resume cycles in a
safe way.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/main.c  |    1 +
 drivers/base/power/power.h |    1 -
 include/linux/device.h     |    6 ++++++
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 200ed5f..bdc03f7 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -129,6 +129,7 @@ void device_pm_schedule_removal(struct device *dev)
 	list_move_tail(&dev->power.entry, &dpm_destroy);
 	mutex_unlock(&dpm_list_mtx);
 }
+EXPORT_SYMBOL_GPL(device_pm_schedule_removal);
 
 /**
  *	pm_sleep_lock - mutual exclusion for registration and suspend
diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index 6f0dfca..e32d3bd 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -13,7 +13,6 @@ static inline struct device *to_device(struct list_head *entry)
 
 extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
-extern void device_pm_schedule_removal(struct device *);
 extern int pm_sleep_lock(void);
 extern void pm_sleep_unlock(void);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index db375be..479c0b3 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -534,11 +534,17 @@ extern struct device *device_create(struct class *cls, struct device *parent,
 extern void device_destroy(struct class *cls, dev_t devt);
 #ifdef CONFIG_PM_SLEEP
 extern void destroy_suspended_device(struct class *cls, dev_t devt);
+extern void device_pm_schedule_removal(struct device *);
 #else /* !CONFIG_PM_SLEEP */
 static inline void destroy_suspended_device(struct class *cls, dev_t devt)
 {
 	device_destroy(cls, devt);
 }
+
+static inline void device_pm_schedule_removal(struct device *dev)
+{
+	device_unregister(dev);
+}
 #endif /* !CONFIG_PM_SLEEP */
 
 /*
-- 
1.5.3.8


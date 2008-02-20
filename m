Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYBTWS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYBTWS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbYBTWSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:18:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60146 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbYBTWSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:18:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Wed, 20 Feb 2008 23:15:48 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802201604260.7212-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802201604260.7212-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802202315.49032.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of February 2008, Alan Stern wrote:
> On Wed, 20 Feb 2008, Pierre Ossman wrote:
> 
> > > And why not simply fail the suspend if the resume routine doesn't exist
> > > and the suspend routine does?  Maybe with an error message in the
> > > system log.
> > 
> > For the asymmetric case, I guess that would do. But I still want to remove devices when the bus handler has no suspend handling.
> 
> Then it appears the correct approach is to use the new 
> device_pm_schedule_removal() routine.  It schedules the removal of a 
> suspended device for a time when the system suspend is over.

Well, below is an uncompiled and untested but illustrating the idea that
might allow people not to bother with device_pm_schedule_removal()
explicitly and can fix the issue at hand.

[There are some cases that need handling and are not covered here.]

Please have a look.

Thanks,
Rafael

---
 drivers/base/core.c        |    5 ++++-
 drivers/base/power/main.c  |   22 ++++++++++++++++++++++
 drivers/base/power/power.h |    5 +++++
 3 files changed, 31 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -59,6 +59,26 @@ static DECLARE_RWSEM(pm_sleep_rwsem);
 
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
+static struct task_struct *suspending_task;
+static DEFINE_MUTEX(suspending_task_mtx);
+
+bool in_suspend_context(void)
+{
+	bool result;
+
+	mutex_lock(&suspending_task_mtx);
+	result = (suspending_task == current);
+	mutex_unlock(&suspending_task_mtx);
+	return result;
+}
+
+static void set_suspending_task(struct task_struct *task)
+{
+	mutex_lock(&suspending_task_mtx);
+	suspending_task = task;
+	mutex_unlock(&suspending_task_mtx);
+}
+
 /**
  *	device_pm_add - add a device to the list of active devices
  *	@dev:	Device to be added to the list
@@ -272,6 +292,7 @@ static void dpm_resume(void)
 		mutex_lock(&dpm_list_mtx);
 	}
 	mutex_unlock(&dpm_list_mtx);
+	set_suspending_task(NULL);
 }
 
 /**
@@ -460,6 +481,7 @@ static int dpm_suspend(pm_message_t stat
 {
 	int error = 0;
 
+	set_suspending_task(current);
 	mutex_lock(&dpm_list_mtx);
 	while (!list_empty(&dpm_locked)) {
 		struct list_head *entry = dpm_locked.prev;
Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -1162,7 +1162,10 @@ void device_destroy(struct class *class,
 	dev = class_find_device(class, &devt, __match_devt);
 	if (dev) {
 		put_device(dev);
-		device_unregister(dev);
+		if (in_suspend_context())
+			device_pm_schedule_removal(dev);
+		else
+			device_unregister(dev);
 	}
 }
 EXPORT_SYMBOL_GPL(device_destroy);
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -11,6 +11,7 @@ static inline struct device *to_device(s
 	return container_of(entry, struct device, power.entry);
 }
 
+extern bool in_suspend_context(void);
 extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
 extern int pm_sleep_lock(void);
@@ -18,6 +19,10 @@ extern void pm_sleep_unlock(void);
 
 #else /* CONFIG_PM_SLEEP */
 
+static inline bool in_suspend_context(void)
+{
+	return false;
+}
 
 static inline void device_pm_add(struct device *dev)
 {

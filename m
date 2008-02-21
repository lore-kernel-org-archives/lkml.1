Return-Path: <linux-kernel-owner+w=401wt.eu-S933864AbYBUWtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864AbYBUWtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYBUWtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:49:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38936 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbYBUWtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:49:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Thu, 21 Feb 2008 23:47:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802211243240.5473-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802211243240.5473-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802212347.25150.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of February 2008, Alan Stern wrote:
> On Thu, 21 Feb 2008, Rafael J. Wysocki wrote:
> 
> > > > --- linux-2.6.orig/drivers/base/core.c
> > > > +++ linux-2.6/drivers/base/core.c
> > > > @@ -929,6 +929,11 @@ void device_del(struct device *dev)
> > > >  	struct device *parent = dev->parent;
> > > >  	struct class_interface *class_intf;
> > > >  
> > > > +	if (in_suspend_context()) {
> > > > +		get_device(dev);
> > > 
> > > Where is this get_device() undone?  Shouldn't there be an extra 
> > > put_device() added to unregister_dropped_devices()?
> > 
> > No, I don't think so, because unregister_dropped_devices() calls
> > device_unregister() that does the put_device() eventually.
> 
> Ah, yes.
> 
> > If we are called by device_unregister(), the get_device() is needed to balance
> > the put_device() that will be called by device_unregister() after we return.
> > 
> > OTOH, if we are called directly, then we need to balance the put_device()
> > that will be done by device_unregister() called from
> > unregister_dropped_devices().
> > 
> > I hope I didn't miss anything.
> 
> Okay, that sounds right.
> 
> > > > +		device_pm_schedule_removal(dev);
> > > > +		return;
> > > > +	}
> > > >  	device_pm_remove(dev);
> > > >  	if (parent)
> > > >  		klist_del(&dev->knode_parent);
> > > 
> > > And now the change to device_destroy() isn't needed at all.
> > 
> > No, it's not.  Didn't I remove it?  I thought I did.
> 
> Oh yes, you did.
> 
> I see a possible problem in device_resume().  My copy isn't fully 
> up-to-date, but it looks like you call unregister_dropped_devices() 
> before doing the up_write(&pm_sleep_rwsem).  Won't this cause 
> warnings in device_del() about a suspicious caller?

No, it won't, because the devices' semaphores are unlocked by
unregister_dropped_devices() before calling device_unregister().

BTW, below is a simplified version of the patch, without the mutex protecting
suspending_task.  I'd like to push it upstream if it looks good.

Please also have a look at http://bugzilla.kernel.org/show_bug.cgi?id=10030.
There seems to be another issue related to us holding devices' semaphores.
Namely, it looks like, when the user removes the card, a concurrent thread
(from a workqueue) calls device_del() and blocks on the dev->sem held by
us and then something else deadlocks with this thread.  I'll be looking into
this tomorrow.

Thanks,
Rafael

---
 drivers/base/core.c        |    5 +++++
 drivers/base/power/main.c  |    9 +++++++++
 drivers/base/power/power.h |    5 +++++
 3 files changed, 19 insertions(+)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -59,6 +59,13 @@ static DECLARE_RWSEM(pm_sleep_rwsem);
 
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
+static struct task_struct *suspending_task;
+
+bool in_suspend_context(void)
+{
+	return (suspending_task == current);
+}
+
 /**
  *	device_pm_add - add a device to the list of active devices
  *	@dev:	Device to be added to the list
@@ -272,6 +279,7 @@ static void dpm_resume(void)
 		mutex_lock(&dpm_list_mtx);
 	}
 	mutex_unlock(&dpm_list_mtx);
+	suspending_task = NULL;
 }
 
 /**
@@ -460,6 +468,7 @@ static int dpm_suspend(pm_message_t stat
 {
 	int error = 0;
 
+	suspending_task = current;
 	mutex_lock(&dpm_list_mtx);
 	while (!list_empty(&dpm_locked)) {
 		struct list_head *entry = dpm_locked.prev;
Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -929,6 +929,11 @@ void device_del(struct device *dev)
 	struct device *parent = dev->parent;
 	struct class_interface *class_intf;
 
+	if (in_suspend_context()) {
+		get_device(dev);
+		device_pm_schedule_removal(dev);
+		return;
+	}
 	device_pm_remove(dev);
 	if (parent)
 		klist_del(&dev->knode_parent);
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

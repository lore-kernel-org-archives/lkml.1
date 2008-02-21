Return-Path: <linux-kernel-owner+w=401wt.eu-S1760244AbYBUADm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244AbYBUADm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYBUADe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:03:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33203 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbYBUADd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:03:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Thu, 21 Feb 2008 01:02:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802201721080.24031-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802201721080.24031-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802210102.11611.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of February 2008, Alan Stern wrote:
> On Wed, 20 Feb 2008, Rafael J. Wysocki wrote:
> 
> > Well, below is an uncompiled and untested but illustrating the idea that
> > might allow people not to bother with device_pm_schedule_removal()
> > explicitly and can fix the issue at hand.
> > 
> > [There are some cases that need handling and are not covered here.]
> > 
> > Please have a look.
> > 
> > Thanks,
> > Rafael
> 
> > +static struct task_struct *suspending_task;
> > +static DEFINE_MUTEX(suspending_task_mtx);
> 
> I suspect you don't really need this mutex.
> 
> > +bool in_suspend_context(void)
> > +{
> > +	bool result;
> > +
> > +	mutex_lock(&suspending_task_mtx);
> > +	result = (suspending_task == current);
> > +	mutex_unlock(&suspending_task_mtx);
> > +	return result;
> > +}
> 
> If suspending_task == current then you are guaranteed to be serialized, 
> because everything a single task does is serial.

As I said before (but that doesn't seem to reach the list, so I'm repeating),
this is to protect other tasks from reading an inconsistent value of
suspending_task in case they attempt to remove a device concurrently with
respect to us.

While this is not likely to happen right now, because of the freezer, it may
very well happen when the freezer is finally removed.

> > @@ -1162,7 +1162,10 @@ void device_destroy(struct class *class,
> >  	dev = class_find_device(class, &devt, __match_devt);
> >  	if (dev) {
> >  		put_device(dev);
> > -		device_unregister(dev);
> > +		if (in_suspend_context())
> > +			device_pm_schedule_removal(dev);
> > +		else
> > +			device_unregister(dev);
> >  	}
> >  }
> 
> But what about device_del()?  Can a similar change be made there?

Something like the patch below, perhaps?  Again, untested, but compiled this
time. :-)

Thanks,
Rafael

---
 drivers/base/core.c        |    5 +++++
 drivers/base/power/main.c  |   22 ++++++++++++++++++++++
 drivers/base/power/power.h |    5 +++++
 3 files changed, 32 insertions(+)

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

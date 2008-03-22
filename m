Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYCVWTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYCVWTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYCVWS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:18:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48215 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbYCVWSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:18:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 2)
Date: Sat, 22 Mar 2008 23:17:57 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <Pine.LNX.4.44L0.0803202229060.16520-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803202229060.16520-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803222317.58206.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 of March 2008, Alan Stern wrote:
> On Fri, 21 Mar 2008, Rafael J. Wysocki wrote:
> 
> > > One trivial problem is that your dpm_prepare and dpm_complete routines 
> > > go through the list in the wrong order.
> > 
> > I'm not all so sure that the order is actually wrong.  What would be the
> > advantage of the forward order over the current one?
> 
> The advantage is that races no longer matter.
> 
> Suppose you're going through the list backwards and a race occurs, so
> that a child is registered while the parent's prepare() is running.  
> That new child will of course be at the end of dpm_active, so the loop
> in dpm_prepare won't see it (assuming you adopt the approach of using
> only a single list).  But if you go through the list forwards and a new
> child is added, you will naturally see the child when you reach the end
> of the list.  You don't even have to go through the business about
> changing the parent's state back to DPM_ON.
> 
> There are other ways of describing the situation, but they all come 
> down to the same thing.  For instance, this is the way Ben was talking 
> about doing things.
> 
> > > Since dpm_prepare is supposed to go through the list in the forward
> > > direction, logically the "root" of the device tree should be the first
> > > thing "prepared".  This means you should not allow parentless devices
> > > to be registered any time after dpm_prepare has started.  Is that 
> > > liable to cause problems?
> > 
> > I'm still not seeing the advantage of the forward direction in the first place.
> > 
> > Although I don't see what particular problems that may cause, I think the
> > current approach (first, block registrations of new children for each
> > ->prepare()d device and finally block any registrations of new devices) is
> > more natural.
> 
> I suppose for parentless devices it doesn't really matter.  You could
> safely allow them to be registered any time up until dpm_prepare()  
> finishes -- which is what your patch does.  Perhaps the "all_inactive"
> flag should be renamed to "all_prepared".
> 
> > > There may be similar problems with complete().  A number of drivers
> > > check during their resume method for the presence of new children
> > > plugged in while the system was asleep.  All these drivers would have
> > > to be converted over to the new scheme if they weren't permitted to
> > > register the new children before complete() was called.  Of course,
> > > this is easily fixed by permitting new children starting from when
> > > resume() is called rather than when complete() is called.
> > 
> > Well, the problem here was the protection of the correct ordering of the
> > various lists.  However, if the approach with changing 'status' is adopted
> > instead, which seems to be better, we'll be able to unblock the registering
> > of new children before ->resume().
> 
> Yep.  The only thing to watch out for is in device_pm_remove(); it
> would be a disaster if somehow a device was removed while it was being
> prepared/suspended/resumed/completed/whatever.  I know that's not
> supposed to happen but there's nothing to prevent it, especially if
> the device in question doesn't have a driver.  No doubt you can invent
> a way to allow this to happen safely.

Well, that's a separate issue that IMO should be addressed in a separate patch.
Something like the one below comes to mind.

The comment removed by the patch is wrong IMO, because it implies that
device_add() may be called with the device semaphore held and that might
deadlock in bus_attach_device().  Thus, I think we can acquire dev->sem
in device_pm_add() and in device_pm_remove().

Thanks,
Rafael

---
 drivers/base/power/main.c |   21 ++++++++++++++-------
 include/linux/pm.h        |    1 +
 2 files changed, 15 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -41,10 +41,6 @@
  * from the bottom (i.e., end) up and resumed in the opposite order.
  * That way no parent will be suspended while it still has an active
  * child.
- *
- * Since device_pm_add() may be called with a device semaphore held,
- * we must never try to acquire a device semaphore while holding
- * dpm_list_mutex.
  */
 
 LIST_HEAD(dpm_active);
@@ -68,6 +64,7 @@ int device_pm_add(struct device *dev)
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
+	down(&dev->sem);
 	mutex_lock(&dpm_list_mtx);
 	if ((dev->parent && dev->parent->power.sleeping) || all_sleeping) {
 		if (dev->parent->power.sleeping)
@@ -80,10 +77,13 @@ int device_pm_add(struct device *dev)
 		error = -EBUSY;
 	} else {
 		error = dpm_sysfs_add(dev);
-		if (!error)
+		if (!error) {
+			dev->power.present = true;
 			list_add_tail(&dev->power.entry, &dpm_active);
+		}
 	}
 	mutex_unlock(&dpm_list_mtx);
+	up(&dev->sem);
 	return error;
 }
 
@@ -98,10 +98,13 @@ void device_pm_remove(struct device *dev
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
+	down(&dev->sem);
 	mutex_lock(&dpm_list_mtx);
 	dpm_sysfs_remove(dev);
+	dev->power.present = false;
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
+	up(&dev->sem);
 }
 
 /**
@@ -196,6 +199,8 @@ static int resume_device(struct device *
 	TRACE_RESUME(0);
 
 	down(&dev->sem);
+	if (!dev->power.present)
+		goto End;
 
 	if (dev->bus && dev->bus->resume) {
 		dev_dbg(dev,"resuming\n");
@@ -211,7 +216,7 @@ static int resume_device(struct device *
 		dev_dbg(dev,"class resume\n");
 		error = dev->class->resume(dev);
 	}
-
+ End:
 	up(&dev->sem);
 
 	TRACE_RESUME(error);
@@ -366,6 +371,8 @@ static int suspend_device(struct device 
 	int error = 0;
 
 	down(&dev->sem);
+	if (!dev->power.present)
+		goto End;
 
 	if (dev->power.power_state.event) {
 		dev_dbg(dev, "PM: suspend %d-->%d\n",
@@ -389,7 +396,7 @@ static int suspend_device(struct device 
 		error = dev->bus->suspend(dev, state);
 		suspend_report_result(dev->bus->suspend, error);
 	}
-
+ End:
 	up(&dev->sem);
 
 	return error;
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -185,6 +185,7 @@ struct dev_pm_info {
 	unsigned		can_wakeup:1;
 	unsigned		should_wakeup:1;
 	bool			sleeping:1;	/* Owned by the PM core */
+	bool			present:1;	/* Owned by the PM core */
 #ifdef	CONFIG_PM_SLEEP
 	struct list_head	entry;
 #endif

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762216AbYCEVux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762216AbYCEVux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYCEVuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:50:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60802 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbYCEVun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:50:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Make PM core handle device registrations concurrent with suspend/hibernation
Date: Wed, 5 Mar 2008 22:49:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803051118060.4750-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803051118060.4750-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803052249.30306.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 5 of March 2008, Alan Stern wrote:
> On Wed, 5 Mar 2008, Rafael J. Wysocki wrote:
> 
> > -void device_pm_add(struct device *dev)
> > +int device_pm_add(struct device *dev)
> >  {
> > +	int error = 0;
> > +
> >  	pr_debug("PM: Adding info for %s:%s\n",
> >  		 dev->bus ? dev->bus->name : "No Bus",
> >  		 kobject_name(&dev->kobj));
> >  	mutex_lock(&dpm_list_mtx);
> > -	list_add_tail(&dev->power.entry, &dpm_active);
> > +	if (dev->parent && dev->parent->power.sleeping) {
> > +		WARN_ON(true);
> 
> I would prefer to put a dev_warn() line here, so that people reading
> the kernel log can easily tell which device caused the problem and what
> sort of problem it is.  Something like this:
> 
> 		dev_warn(dev, "device added while parent %s is asleep\n",
> 				dev->parent->bus_id);
> 		WARN_ON(true);

Added.

> > @@ -426,6 +406,12 @@ static int dpm_suspend(pm_message_t stat
> >  		struct list_head *entry = dpm_active.prev;
> >  		struct device *dev = to_device(entry);
> >  
> > +		if (dev->parent && dev->parent->power.sleeping) {
> > +			WARN_ON(true);
> > +			error = -EAGAIN;
> > +			break;
> 
> Again, a dev_warn() would be appropriate.

I chose just "WARN_ON(dev->parent && dev->parent->power.sleeping)",
which is shorter. :-)

I don't really expect it to appear and if it's reported, it'll be easy to
figure out everything from the stack trace.

Revised patch below.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Modify the PM core to protect its data structures, specifically the
dpm_active list, from being corrupted if a child of the currently
suspending device is registered concurrently with its ->suspend()
callback.  In that case, since the new device (the child) is added
to dpm_active after its parent, the PM core will attempt to
suspend it after the parent, which is wrong.

Introduce a new member of struct dev_pm_info, called 'sleeping',
and use it to check if the parent of the device being added to
dpm_active has been suspended, in which case the device registration
fails.  Also, use 'sleeping' for checking if the ordering of devices
on dpm_active is correct.

Remove pm_sleep_rwsem which is not necessary any more.

Special thanks to Alan Stern for discussions and suggestions that
lead to the creation of this patch.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/devices.txt |    4 +++
 drivers/base/core.c             |    6 ++++
 drivers/base/power/main.c       |   50 ++++++++++++++--------------------------
 drivers/base/power/power.h      |   23 ++----------------
 include/linux/pm.h              |    1 
 5 files changed, 31 insertions(+), 53 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -183,6 +183,7 @@ typedef struct pm_message {
 struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned		can_wakeup:1;
+	bool			sleeping:1;	/* Owned by the PM core */
 #ifdef	CONFIG_PM_SLEEP
 	unsigned		should_wakeup:1;
 	struct list_head	entry;
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -54,22 +54,31 @@ static LIST_HEAD(dpm_destroy);
 
 static DEFINE_MUTEX(dpm_list_mtx);
 
-static DECLARE_RWSEM(pm_sleep_rwsem);
-
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
 /**
  *	device_pm_add - add a device to the list of active devices
  *	@dev:	Device to be added to the list
  */
-void device_pm_add(struct device *dev)
+int device_pm_add(struct device *dev)
 {
+	int error = 0;
+
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
-	list_add_tail(&dev->power.entry, &dpm_active);
+	if (dev->parent && dev->parent->power.sleeping) {
+		dev_warn(dev,
+			"refusing to add device while parent %s is asleep\n",
+			dev->parent->bus_id);
+		WARN_ON(true);
+		error = -EBUSY;
+	} else {
+		list_add_tail(&dev->power.entry, &dpm_active);
+	}
 	mutex_unlock(&dpm_list_mtx);
+	return error;
 }
 
 /**
@@ -107,32 +116,6 @@ void device_pm_schedule_removal(struct d
 }
 EXPORT_SYMBOL_GPL(device_pm_schedule_removal);
 
-/**
- *	pm_sleep_lock - mutual exclusion for registration and suspend
- *
- *	Returns 0 if no suspend is underway and device registration
- *	may proceed, otherwise -EBUSY.
- */
-int pm_sleep_lock(void)
-{
-	if (down_read_trylock(&pm_sleep_rwsem))
-		return 0;
-
-	return -EBUSY;
-}
-
-/**
- *	pm_sleep_unlock - mutual exclusion for registration and suspend
- *
- *	This routine undoes the effect of device_pm_add_lock
- *	when a device's registration is complete.
- */
-void pm_sleep_unlock(void)
-{
-	up_read(&pm_sleep_rwsem);
-}
-
-
 /*------------------------- Resume routines -------------------------*/
 
 /**
@@ -247,6 +230,7 @@ static void dpm_resume(void)
 		struct device *dev = to_device(entry);
 
 		list_move_tail(entry, &dpm_active);
+		dev->power.sleeping = false;
 		mutex_unlock(&dpm_list_mtx);
 		resume_device(dev);
 		mutex_lock(&dpm_list_mtx);
@@ -285,7 +269,6 @@ void device_resume(void)
 	might_sleep();
 	dpm_resume();
 	unregister_dropped_devices();
-	up_write(&pm_sleep_rwsem);
 }
 EXPORT_SYMBOL_GPL(device_resume);
 
@@ -426,6 +409,9 @@ static int dpm_suspend(pm_message_t stat
 		struct list_head *entry = dpm_active.prev;
 		struct device *dev = to_device(entry);
 
+		WARN_ON(dev->parent && dev->parent->power.sleeping);
+
+		dev->power.sleeping = true;
 		mutex_unlock(&dpm_list_mtx);
 		error = suspend_device(dev, state);
 		mutex_lock(&dpm_list_mtx);
@@ -437,6 +423,7 @@ static int dpm_suspend(pm_message_t stat
 					(error == -EAGAIN ?
 					" (please convert to suspend_late)" :
 					""));
+			dev->power.sleeping = false;
 			break;
 		}
 		if (!list_empty(&dev->power.entry))
@@ -459,7 +446,6 @@ int device_suspend(pm_message_t state)
 	int error;
 
 	might_sleep();
-	down_write(&pm_sleep_rwsem);
 	error = dpm_suspend(state);
 	if (error)
 		device_resume();
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -11,30 +11,13 @@ static inline struct device *to_device(s
 	return container_of(entry, struct device, power.entry);
 }
 
-extern void device_pm_add(struct device *);
+extern int device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
-extern int pm_sleep_lock(void);
-extern void pm_sleep_unlock(void);
 
 #else /* CONFIG_PM_SLEEP */
 
-
-static inline void device_pm_add(struct device *dev)
-{
-}
-
-static inline void device_pm_remove(struct device *dev)
-{
-}
-
-static inline int pm_sleep_lock(void)
-{
-	return 0;
-}
-
-static inline void pm_sleep_unlock(void)
-{
-}
+static inline int device_pm_add(struct device *dev) { return 0; }
+static inline void device_pm_remove(struct device *dev) {}
 
 #endif
 
Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -815,7 +815,11 @@ int device_add(struct device *dev)
 	error = dpm_sysfs_add(dev);
 	if (error)
 		goto PMError;
-	device_pm_add(dev);
+	error = device_pm_add(dev);
+	if (error) {
+		dpm_sysfs_remove(dev);
+		goto PMError;
+	}
 	error = bus_add_device(dev);
 	if (error)
 		goto BusError;
Index: linux-2.6/Documentation/power/devices.txt
===================================================================
--- linux-2.6.orig/Documentation/power/devices.txt
+++ linux-2.6/Documentation/power/devices.txt
@@ -196,6 +196,10 @@ its parent; and can't be removed or susp
 
 The policy is that the device tree should match hardware bus topology.
 (Or at least the control bus, for devices which use multiple busses.)
+In particular, this means that a device registration may fail if the parent of
+the device is suspending (ie. has been chosen by the PM core as the next
+device to suspend) or has already suspended.  Device drivers must be prepared
+to cope with such situations.
 
 
 Suspending Devices

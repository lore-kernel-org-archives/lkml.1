Return-Path: <linux-kernel-owner+w=401wt.eu-S933141AbYB2REU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141AbYB2REU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYB2REH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:04:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60155 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYB2REG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:04:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Fri, 29 Feb 2008 18:02:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802291025450.2140-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802291025450.2140-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802291802.41590.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29 of February 2008, Alan Stern wrote:
> On Fri, 29 Feb 2008, Rafael J. Wysocki wrote:
> 
> > > +There is an unavoidable race between the PM core suspending all the
> > > +children of a device and the device's driver registering new children.
> > > +As a result, it is possible that the core may try to suspend a device
> > > +without first having suspended all of the device's children.  Drivers
> > > +must check for this; a suspend method should return -EBUSY if there are
> > > +unsuspended children.  (The child->power.sleeping field can be used
> > > +for this check.)  In addition, it is illegal to register a child device
> > 
> > s/illegal/invalid/
> 
> How about instead: "attempts to register a child device below a 
> suspended parent will fail.  Hence..."?

OK

> > > +below a suspended parent; hence suspend methods must synchronize with
> > > +other kernel threads that may attempt to add new children.  The suspend
> > > +method must prevent new registrations and wait for concurrent registrations
> > > +to complete before it returns.  New children may be added once more when
> > > +the resume method runs.
[--snip--]
> > > -void device_pm_add(struct device *dev)
> > > +int device_pm_add(struct device *dev)
> > >  {
> > > +	int rc = 0;
> > > +
> > >  	pr_debug("PM: Adding info for %s:%s\n",
> > >  		 dev->bus ? dev->bus->name : "No Bus",
> > >  		 kobject_name(&dev->kobj));
> > >  	mutex_lock(&dpm_list_mtx);
> > > -	list_add_tail(&dev->power.entry, &dpm_active);
> > > +	if (dev->parent) {
> > 
> > Hmm.
> > 
> > Suppose we add a mutex to dev_pm_info, say pm_mtx, and require it to be:
> > (1) taken by suspend_device(dev) (at the beginning)
> > (2) released by resume_device(dev) (at the end)
> > (3) taken (and released) by device_pm_add() if dev is the parent of the device
> >     being added.
> > 
> > In that case, device_pm_add() will block on attepmpts to register devices whose
> > parents are suspended (or suspending) and we're done.  At least so it would
> > seem.
> 
> No; this would repeat the same mistake we were struggling with last
> week.

Not exactly, because in that case we blocked all attempts to register devices,
while I think we can only block those regarding the children of a suspending
(or suspended) device.

> Blocking registration attempts (especially if we start _before_ 
> calling the device's suspend method or end _after_ calling the resume
> method) will lead to deadlocks while suspending or resuming.

I'm not really convinced that it'll happen.  If we make the rule that
registering children from the device's own ->suspend() method is forbidden
(I don't really see why it should be allowed), something like this might work
(it seems to me):

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -186,6 +186,7 @@ struct dev_pm_info {
 #ifdef	CONFIG_PM_SLEEP
 	unsigned		should_wakeup:1;
 	struct list_head	entry;
+	struct mutex		lock;
 #endif
 };
 
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -67,9 +67,14 @@ void device_pm_add(struct device *dev)
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
+	if (dev->parent)
+		mutex_lock(&dev->parent.power.lock);
 	mutex_lock(&dpm_list_mtx);
 	list_add_tail(&dev->power.entry, &dpm_active);
+	mutex_init(&dev->power.lock);
 	mutex_unlock(&dpm_list_mtx);
+	if (dev->parent)
+		mutex_unlock(&dev->parent.power.lock);
 }
 
 /**
@@ -249,6 +254,7 @@ static void dpm_resume(void)
 		list_move_tail(entry, &dpm_active);
 		mutex_unlock(&dpm_list_mtx);
 		resume_device(dev);
+		mutex_unlock(&dev->power.lock);
 		mutex_lock(&dpm_list_mtx);
 	}
 	mutex_unlock(&dpm_list_mtx);
@@ -427,6 +433,13 @@ static int dpm_suspend(pm_message_t stat
 		struct device *dev = to_device(entry);
 
 		mutex_unlock(&dpm_list_mtx);
+		mutex_lock(&dev->power.lock);
+		mutex_lock(&dpm_list_mtx);
+		if (dev != to_device(dpm_active.prev)) {
+			mutex_unlock(&dev->power.lock);
+			continue;
+		}
+		mutex_unlock(&dpm_list_mtx);
 		error = suspend_device(dev, state);
 		mutex_lock(&dpm_list_mtx);
 		if (error) {
@@ -437,6 +450,7 @@ static int dpm_suspend(pm_message_t stat
 					(error == -EAGAIN ?
 					" (please convert to suspend_late)" :
 					""));
+			mutex_unlock(&dev->power.lock);
 			break;
 		}
 		if (!list_empty(&dev->power.entry))

> If the blocking starts after the suspend method returns then it will be 
> safer.  But what's the point?  If a registration attempt is made at 
> that stage, it means there's a bug in the driver.  So failing the 
> registration seems like a reasonable thing to do.

That doesn't buy us anything if drivers don't check whether the registration
succeeded.  And they don't.

> One issue: This rule doesn't allow suspend_late or resume_early methods
> to register any new devices.

Not exactly.  Just the children of suspended devices, which makes a difference
IMO. :-)

> Will that cause problems with the CPU hotplug or ACPI subsystems?  ACPI in
> particular may need to freeze the kacpi_notify workqueue -- in fact, that
> might solve the problem in Bugzilla #9874.

Well, my impression is that we do this thing to prepare for removing the
freezer in the future, so I'd rather solve issues in some other ways than just
by freezing threads that get in the way. ;-)

> > > +		switch (dev->parent->power.sleeping) {
> > > +		case PM_SLEEPING:
> > > +			child_added_while_parent_suspends = true;
> > > +			break;
> > > +		case PM_ASLEEP:
> > > +			dev_err(dev, "added while parent '%s' is asleep\n",
> > > +					dev->parent->bus_id);
> > > +			rc = -EHOSTDOWN;
> > > +			break;
> > > +		default:
> > > +			break;
> > > +		}
> > > +	} else if (all_devices_asleep) {
> > > +		dev_err(dev, "added while all devices are asleep\n");
> > > +		rc = -ENETDOWN;
> > > +	}
> > 
> > The error codes are a bit unusual, but whatever.
> 
> I agree.  But there aren't any -EPOWER* or -EPM* error codes defined!  
> Some should be added, but this patch isn't the place to do it.
> 
> > > @@ -433,10 +446,24 @@ static int dpm_suspend(pm_message_t stat
> > >  					""));
> > >  			break;
> > >  		}
> > > -		mutex_lock(&dpm_list_mtx);
> > > -		if (!list_empty(&dev->power.entry))
> > > -			list_move(&dev->power.entry, &dpm_off);
> > > +		if (dev->power.sleeping != PM_GONE) {
> > > +			if (child_added_while_parent_suspends) {
> > > +				dev_err(dev, "suspended while a child "
> > > +						"was added\n");
> > > +				dev->power.sleeping = PM_WAKING;
> > > +				mutex_unlock(&dpm_list_mtx);
> > 
> > This seems to be a weak spot.  The resuming of the device at this point need
> > not work correctly, given that the system's target state is still a sleep
> > state.
> 
> That may be true.  But this is an error-recovery path intended to work
> around a driver bug.  It doesn't have to guarantee perfect operation, 
> just do its best.
> 
> Remember too that the target state is set before any devices are
> suspended.  Hence, after the state is set there may still be runtime
> resumes taking place.  Those _must_ not fail, which means that this
> resume ought to work also.

They may be handled in a different way, not by ->resume().
 
> > > +				resume_device(dev);
> > > +				mutex_lock(&dpm_list_mtx);
> > > +				if (dev->power.sleeping != PM_GONE)
> > > +					dev->power.sleeping = PM_AWAKE;
> > > +			} else {
> 
> > Well, I wish it could be simpler ...
> 
> Me too.  But until the API is changed, this seems to be the best we can 
> do.  It's not quite as bad as it looks, since a fair amount of the new 
> code is just for reporting on and recovering from bugs in drivers.

Still, it doesn't look very nice ...

Thanks,
Rafael

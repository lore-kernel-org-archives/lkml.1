Return-Path: <linux-kernel-owner+w=401wt.eu-S1764514AbYCEXZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764514AbYCEXZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbYCEXZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:25:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33102 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839AbYCEXZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:25:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Make PM core handle device registrations concurrent with suspend/hibernation
Date: Thu, 6 Mar 2008 00:24:28 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803051658290.4318-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803051658290.4318-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803060024.28850.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 5 of March 2008, Alan Stern wrote:
> On Wed, 5 Mar 2008, Rafael J. Wysocki wrote:
> 
> > On Wednesday, 5 of March 2008, Alan Stern wrote:
> > > On Wed, 5 Mar 2008, Rafael J. Wysocki wrote:
> > > 
> > > > -void device_pm_add(struct device *dev)
> > > > +int device_pm_add(struct device *dev)
> > > >  {
> > > > +	int error = 0;
> > > > +
> > > >  	pr_debug("PM: Adding info for %s:%s\n",
> > > >  		 dev->bus ? dev->bus->name : "No Bus",
> > > >  		 kobject_name(&dev->kobj));
> > > >  	mutex_lock(&dpm_list_mtx);
> > > > -	list_add_tail(&dev->power.entry, &dpm_active);
> > > > +	if (dev->parent && dev->parent->power.sleeping) {
> > > > +		WARN_ON(true);
> > > 
> > > I would prefer to put a dev_warn() line here, so that people reading
> > > the kernel log can easily tell which device caused the problem and what
> > > sort of problem it is.  Something like this:
> > > 
> > > 		dev_warn(dev, "device added while parent %s is asleep\n",
> > > 				dev->parent->bus_id);
> > > 		WARN_ON(true);
> > 
> > Added.
> > 
> > > > @@ -426,6 +406,12 @@ static int dpm_suspend(pm_message_t stat
> > > >  		struct list_head *entry = dpm_active.prev;
> > > >  		struct device *dev = to_device(entry);
> > > >  
> > > > +		if (dev->parent && dev->parent->power.sleeping) {
> > > > +			WARN_ON(true);
> > > > +			error = -EAGAIN;
> > > > +			break;
> > > 
> > > Again, a dev_warn() would be appropriate.
> > 
> > I chose just "WARN_ON(dev->parent && dev->parent->power.sleeping)",
> > which is shorter. :-)
> > 
> > I don't really expect it to appear and if it's reported, it'll be easy to
> > figure out everything from the stack trace.
> 
> Okay.
> 
> > Revised patch below.
> 
> It looks good.  Let's hope it doesn't mess up ACPI too badly...  :-)
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Thanks!

Okay, I also have the appended patch on top of this one. :-)

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Include dpm_sysfs_add() into device_pm_add(), in analogy with
device_pm_remove(), and modify device_add() to call the latter after
bus_add_device(), to avoid situations in which the PM core may
attempt to suspend a device the registration of which has not been
successful.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/core.c       |   15 +++++----------
 drivers/base/power/main.c |    4 +++-
 2 files changed, 8 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -812,17 +812,12 @@ int device_add(struct device *dev)
 	error = device_add_attrs(dev);
 	if (error)
 		goto AttrsError;
-	error = dpm_sysfs_add(dev);
-	if (error)
-		goto PMError;
-	error = device_pm_add(dev);
-	if (error) {
-		dpm_sysfs_remove(dev);
-		goto PMError;
-	}
 	error = bus_add_device(dev);
 	if (error)
 		goto BusError;
+	error = device_pm_add(dev);
+	if (error)
+		goto PMError;
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
@@ -842,9 +837,9 @@ int device_add(struct device *dev)
  Done:
 	put_device(dev);
 	return error;
- BusError:
-	device_pm_remove(dev);
  PMError:
+	bus_remove_device(dev);
+ BusError:
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DEL_DEVICE, dev);
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -75,7 +75,9 @@ int device_pm_add(struct device *dev)
 		WARN_ON(true);
 		error = -EBUSY;
 	} else {
-		list_add_tail(&dev->power.entry, &dpm_active);
+		error = dpm_sysfs_add(dev);
+		if (!error)
+			list_add_tail(&dev->power.entry, &dpm_active);
 	}
 	mutex_unlock(&dpm_list_mtx);
 	return error;

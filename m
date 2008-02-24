Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbYBXNwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbYBXNwl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 08:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYBXNwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 08:52:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52838 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbYBXNwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 08:52:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Sun, 24 Feb 2008 14:51:16 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0802232143050.29968-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802232143050.29968-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802241451.17334.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 of February 2008, Alan Stern wrote:
> On Sun, 24 Feb 2008, Rafael J. Wysocki wrote:
> > On Sunday, 24 of February 2008, Alan Stern wrote:
> > > On Sat, 23 Feb 2008, Rafael J. Wysocki wrote:
> 
> > > I still have no clear idea about what's going on with the ACPI bug in 
> > > #9874.
> > 
> > It seems that the ACPI code is not prepared to cope with a failing device
> > registration, in which case it'd need fixing.  Frankly, I'm afraid there may
> > be more issues like this throughout the tree.
> 
> The fact remains that it is unsafe to register a device during a sleep 
> transition, although if the device's driver doesn't have a suspend or 
> resume method you can probably get away with it.
> 
> > > However perhaps the bug wouldn't occur if we blocked device  
> > > registration until after the resume was finished, instead of failing it 
> > > outright.  Since the registration in this case was done in a workqueue 
> > > thread, blocking wouldn't cause an immediate deadlock.
> > 
> > No, it wouldn't, but the fact that it happens in the ACPI code makes me worry.
> 
> It happened in a workqueue.  There could be lots of similar cases: Some 
> interrupt-driven event causes a hotplug action.  Since the action can't 
> be carried out in interrupt context, the driver has no choice but to 
> defer it to a workqueue or kernel thread.  Blocking that workqueue or 
> kernel thread won't cause a problem _unless_ the driver's 
> suspend/resume methods try to synchronize with it.  That's the 
> difficult case.

Yes.

> > If we block that code and the things it's supposed to do turn out to be
> > necessary for suspending later on, we'll be in trouble.
> 
> Exactly.
> 
> > > @@ -94,14 +102,15 @@ void device_pm_remove(struct device *dev
> > >  			/* No suspend in progress, wait on dev->sem */
> > >  			down(&dev->sem);
> > >  			up_read(&pm_sleep_rwsem);
> > > -		} else {
> > > -			/* Suspend in progress, we may deadlock */
> > > +		} else if (!in_suspend_context()) {
> > > +			/* Suspending in another task, we may deadlock */
> > 
> > Well, that shouldn't really deadlock.  If it does, there is a potential design
> > issue somewhere.  I think it might be better to set up a timer in here too.
> 
> At this point the driver core owns the device semaphore, so the 
> unregistration task will block until the sleep is over.  If the 
> driver's resume method has to synchronize with the unregistration task 
> then it will deadlock.  I agree, it would be a design issue.  In fact, 
> it's the same design issue described earlier in this email.
> 
> > Although IMO it would be even better to just set up a timer and remove the
> > warning altogehter.
> 
> That warning was just for debugging purposes.  A timer in the resume
> path could do the same thing with fewer false alarms, just like the 
> timer in the suspend path.  I have added it to the new patch.

OK

> > >  			dev_warn(dev, "Suspicious %s during suspend\n",
> > >  				__FUNCTION__);
> > >  			dump_stack();
> > >  			/* The user has been warned ... */
> > >  			down(&dev->sem);
> > >  		}
> > > +			/* Otherwise we're okay */
> > >  	}
> > >  	pr_debug("PM: Removing info for %s:%s\n",
> > >  		 dev->bus ? dev->bus->name : "No Bus",
> > 
> > There's a problem here, because we shouldn't release the semaphore if we're
> > in the suspend context.
> 
> Yes, you're right.  It's fixed in the new version.
> 
> > > +static void suspend_timeout(unsigned long _dev)
> > > +{
> > > +	struct device *dev = (struct device *) _dev;
> > > +
> > > +	dev_err(dev, "deadlock during suspend!\n");
> > > +	show_state();
> > 
> > The show_state() seems to be overkill and won't really help if the user can't
> > collect the output on the fly using a serial console or something like this.
> > [The debug stuff printed here should fit a typical laptop screen, ideally.]
> 
> Changed.
> 
> > I'd prefer
> > 
> > 	if (in_suspend_context()) {
> > 		__device_release_driver(dev);
> > 	} else {
> > 		down(&dev->sem);
> > 		__device_release_driver(dev);
> > 		up(&dev->sem);
> > 	}
> 
> Okay.
> 
> You know, with this new patch we probably don't need 
> device_pm_schedule_removal() any more.

No, we don't.  However, because of that dpm_suspend() and device_power_down()
need to be changed not to assume that the removed devices will end up on
dpm_destroy.

> However I have left it in for now.

Well, it's used by the b43, leds and hwrng drivers as well as by some CPU
hotplug notifiers.  They all will have to be changed along with removing it.

> > Well, I'd really feel much more comfortable if we removed the troublesome code
> > for 2.6.25 and reintroduced it along with the above safeguards for 2.6.26.
> > 
> > Of course, this doesn't mean we can't send debug patches for testing to the
> > users who have alraedy reported problems with it. :-)
> 
> Certainly!
> 
> Here's the new version.

IMO you also should add this change in device_power_down():

@@ -388,18 +343,15 @@ int device_power_down(pm_message_t state
 		struct list_head *entry = dpm_off.prev;
 		struct device *dev = to_device(entry);
 
-		list_del_init(&dev->power.entry);
 		error = suspend_device_late(dev, state);
 		if (error) {
 			printk(KERN_ERR "Could not power down device %s: "
 					"error %d\n",
 					kobject_name(&dev->kobj), error);
-			if (list_empty(&dev->power.entry))
-				list_add(&dev->power.entry, &dpm_off);
 			break;
 		}
-		if (list_empty(&dev->power.entry))
-			list_add(&dev->power.entry, &dpm_off_irq);
+		if (!list_empty(&dev->power.entry))
+			list_move(&dev->power.entry, &dpm_off_irq);
 	}
 
 	if (!error)

and the analogous one in dpm_suspend().  Otherwise there would be a problem
if suspend_device_late() itself removed the device (same for device_suspend()).
Of course, that would lead to a problem if device_pm_schedule_removal() were
used for the removal, so the last "!list_empty(&dev->power.entry)" is really
not sufficient - until device_pm_schedule_removal() is removed.

Thanks,
Rafael

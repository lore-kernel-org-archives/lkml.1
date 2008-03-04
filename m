Return-Path: <linux-kernel-owner+w=401wt.eu-S1765362AbYCDVyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765362AbYCDVyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYCDVyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:54:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54238 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbYCDVyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:54:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Make PM core handle device registrations concurrent with suspend/hibernation
Date: Tue, 4 Mar 2008 22:52:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803041041270.4039-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803041041270.4039-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803042252.51440.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 4 of March 2008, Alan Stern wrote:
> On Tue, 4 Mar 2008, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > The appended patch is intended to fix the issue with the PM core that it allows
> > device registrations to complete successfully even if they run concurrently
> > with the suspending of their parents, which may lead to a wrong ordering of
> > devices on the dpm_active list and, as a result, to failures during suspend and
> > hibernation transitions.
> > 
> > Comments welcome.
> 
> > Index: linux-2.6/include/linux/pm.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/pm.h
> > +++ linux-2.6/include/linux/pm.h
> > @@ -186,6 +186,7 @@ struct dev_pm_info {
> >  #ifdef	CONFIG_PM_SLEEP
> >  	unsigned		should_wakeup:1;
> >  	struct list_head	entry;
> > +	bool			sleeping;	/* Owned by the PM core */
> >  #endif
> >  };
> 
> Drivers might want to use this field without having to add protective 
> "#ifdef CONFIG_PM_SLEEP" lines.

I guess you mean that driver writers may not want to make each piece of code
referring to this flag depend on CONFIG_PM_SLEEP.  Any driver that actually
writes to it will be buggy ...

> You can change it to a single-bit bitfield and place it adjacent to
> can_wakeup. 

Yeah, good catch.  I will.

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
> > +	if (dev->parent && dev->parent->power.sleeping)
> > +		error = -EBUSY;
> 
> Add a stack dump?  When this isn't a race, it's the kind of bug we want
> to fix.

Yes, I'll do that.

> > +	else
> > +		list_add_tail(&dev->power.entry, &dpm_active);
> >  	mutex_unlock(&dpm_list_mtx);
> > +	return error;
> >  }
> 
> > @@ -426,6 +404,11 @@ static int dpm_suspend(pm_message_t stat
> >  		struct list_head *entry = dpm_active.prev;
> >  		struct device *dev = to_device(entry);
> >  
> > +		if (dev->parent && dev->parent->power.sleeping) {
> > +			error = -EAGAIN;
> > +			break;
> > +		}
> 
> It's not clear that we want to have this check.  It would cause
> problems if the device ordering got mixed up by device_move(), which is
> pretty much the only way it could be triggered.

Well, isn't it actually dangerous to suspend parents before their children?
What happens, for example, if putting the parent into D3 causes power to be
cut from the children and then we attempt to suspend them?

> If you do want to leave it in, add a stack dump (and perhaps make it 
> not return an error).  This would help force people to figure out safe 
> ways to use device_move().

Yes, I'll add a stack dump here.

In fact, I'm going to add WARN_ON(true) in both places.

> > +		dev->power.sleeping = true;;
> 
> Extra ';'.

Hah, thanks, will remove.

Rafael

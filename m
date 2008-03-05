Return-Path: <linux-kernel-owner+w=401wt.eu-S1763460AbYCEWA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763460AbYCEWA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbYCEWAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:00:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57593 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751349AbYCEWAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:00:08 -0500
Date: Wed, 5 Mar 2008 17:00:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM: Make PM core handle device registrations
 concurrent with suspend/hibernation
In-Reply-To: <200803052249.30306.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803051658290.4318-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Rafael J. Wysocki wrote:

> On Wednesday, 5 of March 2008, Alan Stern wrote:
> > On Wed, 5 Mar 2008, Rafael J. Wysocki wrote:
> > 
> > > -void device_pm_add(struct device *dev)
> > > +int device_pm_add(struct device *dev)
> > >  {
> > > +	int error = 0;
> > > +
> > >  	pr_debug("PM: Adding info for %s:%s\n",
> > >  		 dev->bus ? dev->bus->name : "No Bus",
> > >  		 kobject_name(&dev->kobj));
> > >  	mutex_lock(&dpm_list_mtx);
> > > -	list_add_tail(&dev->power.entry, &dpm_active);
> > > +	if (dev->parent && dev->parent->power.sleeping) {
> > > +		WARN_ON(true);
> > 
> > I would prefer to put a dev_warn() line here, so that people reading
> > the kernel log can easily tell which device caused the problem and what
> > sort of problem it is.  Something like this:
> > 
> > 		dev_warn(dev, "device added while parent %s is asleep\n",
> > 				dev->parent->bus_id);
> > 		WARN_ON(true);
> 
> Added.
> 
> > > @@ -426,6 +406,12 @@ static int dpm_suspend(pm_message_t stat
> > >  		struct list_head *entry = dpm_active.prev;
> > >  		struct device *dev = to_device(entry);
> > >  
> > > +		if (dev->parent && dev->parent->power.sleeping) {
> > > +			WARN_ON(true);
> > > +			error = -EAGAIN;
> > > +			break;
> > 
> > Again, a dev_warn() would be appropriate.
> 
> I chose just "WARN_ON(dev->parent && dev->parent->power.sleeping)",
> which is shorter. :-)
> 
> I don't really expect it to appear and if it's reported, it'll be easy to
> figure out everything from the stack trace.

Okay.

> Revised patch below.

It looks good.  Let's hope it doesn't mess up ACPI too badly...  :-)

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern


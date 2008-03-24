Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYCXVTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYCXVTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 17:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYCXVTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 17:19:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56951 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbYCXVTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 17:19:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 3)
Date: Mon, 24 Mar 2008 22:18:46 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <Pine.LNX.4.44L0.0803241519090.24400-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803241519090.24400-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803242218.47898.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 24 of March 2008, Alan Stern wrote:
> On Mon, 24 Mar 2008, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > This is the 3rd revision of the patch introducing new callbacks for suspend
> > and hibernation.  It has been tested on x86-64.
> ...
> > * The registrations of parentless devices are disabled before the first
> >   ->prepare() method is called and enabled before the first ->resume() method
> >   is called
> 
> It would be okay to wait until after the last prepare() method is
> called.  I don't know if it makes any difference in the end, however.
> 
> > +enum dpm_state {
> > +	DPM_ON,
> > +	DPM_RESUMING,
> > +	DPM_SUSPENDING,
> > +	DPM_OFF,
> > +	DPM_OFF_IRQ,
> > +};
> 
> Can we also have a DPM_PREPARING state, set when ->prepare() is about
> to be called?  The PM core wouldn't make use of it but some drivers
> would.  (I can't think of any use at all for the analogous
> DPM_COMPLETING state, however.)

Hmm.  dev->power.status is protected by dpm_list_mtx.  Do you think it would be
useful to have an accessor function for reading it under the lock?

> > @@ -68,22 +59,30 @@ int device_pm_add(struct device *dev)
> ...
> > +	if (dev->parent) {
> > +		if (dev->parent->power.status > DPM_RESUMING) {
> 
> Clearer to say: if (dev->parent->power.status >= DPM_SUSPENDING) {

OK

> ...
> > +	} else if (transition_started) {
> > +		/*
> > +		 * We refuse to register parentless devices while a PM
> > +		 * transition is in progress in order to avoid leaving them
> > +		 * unhandled down the road
> > +		 */
> 
> Log a warning here?  If this ever happened, it would be the sort of 
> unexpected regression that people get all excited about.

The WARN_ON() below 'Refuse' will trigger.  I think that's sufficient.

> > +		goto Refuse;
> >  	}
> ...
> 
> > +static void dpm_resume(pm_message_t state)
> > +{
> > +	struct list_head list;
> > +
> > +	INIT_LIST_HEAD(&list);
> > +	mutex_lock(&dpm_list_mtx);
> > +	transition_started = false;
> > +	while (!list_empty(&dpm_list)) {
> > +		struct device *dev = to_device(dpm_list.next);
> > +
> > +		if (dev->power.status > DPM_SUSPENDING) {
> 
> Clearer to say: if (dev->power.status >= DPM_OFF) {

OK
 
> Note that if dev->power.status is equal to DPM_SUSPENDING then you 
> don't want to call resume_device(), but you still do want to change 
> dev->power.status to DPM_RESUMING so that new children can be 
> registered.

Ah, I overlooked that.  Will fix.

> > +			dev->power.status = DPM_RESUMING;
> > +			get_device(dev);
> > +			mutex_unlock(&dpm_list_mtx);
> > +
> > +			resume_device(dev, state);
> > +
> > +			mutex_lock(&dpm_list_mtx);
> > +			put_device(dev);
> > +		}
> > +		if (!list_empty(&dev->power.entry))
> > +			list_move_tail(&dev->power.entry, &list);
> 
> A little problem here: You refer to dev after calling put_device().

The device can't be removed at this point, because we hold dpm_list_mtx, which
is needed by device_del().  Still, I'll move the put_device() to avoid
confusion (as well as in all of the other places).

> > +	}
> > +	list_splice(&list, &dpm_list);
> 
> This isn't the way I imagined doing it (your extra "list"), but it's 
> fine.
> 
> ...
> > +static void dpm_complete(pm_message_t state)
> >  {
> ...
> > +			complete_device(dev, state);
> > +
> > +			mutex_lock(&dpm_list_mtx);
> > +			put_device(dev);
> > +		}
> > +		if (!list_empty(&dev->power.entry))
> > +			list_move(&dev->power.entry, &list);
> 
> Same problem with use-after-put.  Also present in dpm_prepare().
> 
> >  	}
> > +	list_splice(&list, &dpm_list);
> >  	mutex_unlock(&dpm_list_mtx);
> >  }
> 
> ...
> >  static int dpm_suspend(pm_message_t state)
> >  {
> ...
> >  		error = suspend_device(dev, state);
> > +
> >  		mutex_lock(&dpm_list_mtx);
> > +		put_device(dev);
> >  		if (error) {
> >  			printk(KERN_ERR "Could not suspend device %s: "
> > -					"error %d%s\n",
> > -					kobject_name(&dev->kobj),
> > -					error,
> > -					(error == -EAGAIN ?
> > -					" (please convert to suspend_late)" :
> > -					""));
> > -			dev->power.sleeping = false;
> > +				"error %d\n", kobject_name(&dev->kobj), error);
> > +			list_splice_init(&dpm_list, &list);
> >  			break;
> >  		}
> > -		if (!list_empty(&dev->power.entry))
> > -			list_move(&dev->power.entry, &dpm_off);
> > +		if (!list_empty(&dev->power.entry)) {
> > +			dev->power.status = DPM_OFF;
> > +			list_move(&dev->power.entry, &list);
> > +		}
> 
> Use-after-put again.
> 
> >  	}
> > -	if (!error)
> > -		all_sleeping = true;
> > +	list_splice(&list, &dpm_list);
> 
> Instead you could eliminate the list_splice_init() above and put here:
> 
> 	list_splice(&list, dpm_list->prev);
> 
> This will move the entries from list to the end of dpm_list.

dpm_list may be empty at this point.  Wouldn't that cause any trouble?

> >  	mutex_unlock(&dpm_list_mtx);
> > +	return error;
> > +}
> 
> On the whole it looks quite good.

Okay, thanks for the comments.

Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYCYUfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYCYUfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbYCYUfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:35:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34632 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbYCYUfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:35:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 3)
Date: Tue, 25 Mar 2008 21:35:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <Pine.LNX.4.44L0.0803251044590.4838-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803251044590.4838-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803252135.04247.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 of March 2008, Alan Stern wrote:
> On Mon, 24 Mar 2008, Rafael J. Wysocki wrote:
> 
> > > Can we also have a DPM_PREPARING state, set when ->prepare() is about
> > > to be called?  The PM core wouldn't make use of it but some drivers
> > > would.  (I can't think of any use at all for the analogous
> > > DPM_COMPLETING state, however.)
> > 
> > Hmm.  dev->power.status is protected by dpm_list_mtx.  Do you think it would be
> > useful to have an accessor function for reading it under the lock?
> 
> I don't think so.  What I have in mind is situations where there 
> accessed has already been synchronized by other means, while the 
> prepare() method is running.  For example:
> 
> 	Task 0				Task 1
> 	------				------
> 	->prepare() is called
> 	Waits for currently-running
> 	  registration in task 1
> 	  to finish
> 	Does other stuff
> 					Receives a request to register
> 					  a new child under dev
> 					Sees that dev->power.state is
> 					  still DPM_ON, so goes ahead
> 					  with the child's registration
> 	->prepare() returns
> 	dev->power.state is set to
> 	  DPM_SUSPENDING
> 					device_pm_add() checks
> 					  dev->power.state and fails
> 					  the registration
> 
> If dev->power.state had been set to DPM_PREPARING before ->prepare() 
> was called, then task 1 would have avoided trying to register the 
> child.
> 
> > > > +			dev->power.status = DPM_RESUMING;
> > > > +			get_device(dev);
> > > > +			mutex_unlock(&dpm_list_mtx);
> > > > +
> > > > +			resume_device(dev, state);
> > > > +
> > > > +			mutex_lock(&dpm_list_mtx);
> > > > +			put_device(dev);
> > > > +		}
> > > > +		if (!list_empty(&dev->power.entry))
> > > > +			list_move_tail(&dev->power.entry, &list);
> > > 
> > > A little problem here: You refer to dev after calling put_device().
> > 
> > The device can't be removed at this point, because we hold dpm_list_mtx, which
> > is needed by device_del().
> 
> True, it can't be removed at this point.  But it _can_ be removed
> between the calls to resume_device() and mutex_lock().
> 
> > > >  	}
> > > > -	if (!error)
> > > > -		all_sleeping = true;
> > > > +	list_splice(&list, &dpm_list);
> > > 
> > > Instead you could eliminate the list_splice_init() above and put here:
> > > 
> > > 	list_splice(&list, dpm_list->prev);
> > > 
> > > This will move the entries from list to the end of dpm_list.
> > 
> > dpm_list may be empty at this point.  Wouldn't that cause any trouble?
> 
> It will still work correctly.  If dpm_list is empty then dpm_list->prev
> is equal to &dpm_list, so it will do the same thing as your current
> code does.
> 
> 
> I just thought of another problem.  At the point where
> local_irq_disable() is called, in between device_suspend() and
> device_power_down(), it is possible in a preemptible kernel that
> another task is holding dpm_list_mtx and is in the middle of updating
> the list pointers.  This would mess up the traversal in
> device_power_down().
> 
> I'm not sure about the best way to prevent this.  Is it legal to call
> unlock_mutex() while interrupts or preemption are disabled?

Well, I think it is, but I'm not sure how that can help.

To prevent the race from happening, we can lock dpm_list_mtx before switching
interrupts off in kernel/power/main.c:suspend_enter() and analogously in
kernel/power/disk.c .

Thanks,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZLIWRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZLIWRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758082AbZLIWRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:17:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55434 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757300AbZLIWRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:17:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async suspend-resume patch w/ rwsems (was: Re: [GIT PULL] PM updates for 2.6.33)
Date: Wed, 9 Dec 2009 23:18:24 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091451250.4120-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912091451250.4120-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912092318.24475.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 December 2009, Alan Stern wrote:
> On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> 
> > For completness, below is the full async suspend/resume patch with rwlocks,
> > that has been (very slightly) tested and doesn't seem to break things.
> > 
> > [Note to Alan: lockdep doesn't seem to complain about the not annotated nested
> > locks.]
> 
> I can't imagine why not.  And wouldn't lockdep get confused by the fact
> that in the async case, the rwsems are released by a different process
> from the one that acquired them?

/me looks at the .config

I have CONFIG_LOCKDEP_SUPPORT set, is there anything else I need to set
in .config?

> > Index: linux-2.6/drivers/base/power/main.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/base/power/main.c
> > +++ linux-2.6/drivers/base/power/main.c
> 
> Should we have an attribute under /sys/power to disable async
> suspend/resume?  It would make testing easier and give people a way to
> work around problems.

I have a separate patch adding that, but I'd prefer to focus on the core
feature first, if possible.

> > @@ -334,25 +337,53 @@ static void pm_dev_err(struct device *de
> >   * The driver of @dev will not receive interrupts while this function is being
> >   * executed.
> >   */
> > -static int device_resume_noirq(struct device *dev, pm_message_t state)
> > +static int __device_resume_noirq(struct device *dev, pm_message_t state)
> >  {
> 
> Do you want to use async tasks in the late-suspend/early-resume stages?  
> I know that USB won't use it, not even for the PCI host controllers --
> not unless the PCI core specifically wants it.  Doing just the regular
> suspend/resume stages may be enough.

I guess so.  It's a leftover from the time I thought PCI might use async
suspend, but it didn't really speed up things at all AFAICS.

I think I'll remove it for now and it's going to be trivial to add it back if
desired.

> > +static int device_resume_noirq(struct device *dev)
> > +{
> > +	down_write(&dev->power.rwsem);
> > +
> > +	if (dev->power.async_suspend && !pm_trace_is_enabled()) {
> 
> If the sysfs attribute exists, then maybe we _should_ allow async with 
> PM tracing enabled.  I don't know; it's your decision.

I don't think it would be reliable in that case, because the RTC might be
written to by two concurrent threads at the same time.

> 			atomic_set(&async_error, error);
> 	}
> 
> 
> > @@ -683,10 +835,12 @@ static int dpm_suspend(pm_message_t stat
> >  
> >  	INIT_LIST_HEAD(&list);
> >  	mutex_lock(&dpm_list_mtx);
> > +	pm_transition = state;
> >  	while (!list_empty(&dpm_list)) {
> >  		struct device *dev = to_device(dpm_list.prev);
> >  
> >  		get_device(dev);
> > +		dev->power.status = DPM_OFF;
> 
> What's that for?  dev->power.status is supposed to be DPM_SUSPENDING 
> until the suspend method is successfully completed.

If the suspend is run asynchronoysly, the main thread will always get a
"success" from device_suspend(), so it can't change power.status on this
basis.  I thought we could set power.status to DPM_OFF upfront and change
it back when error is returned.

The alternative would be to move the modification of power.status to
device_suspend() and async_suspend().  Well, maybe that's better.

> >  		mutex_unlock(&dpm_list_mtx);
> >  
> >  		error = device_suspend(dev, state);
> > @@ -694,16 +848,22 @@ static int dpm_suspend(pm_message_t stat
> >  		mutex_lock(&dpm_list_mtx);
> >  		if (error) {
> >  			pm_dev_err(dev, state, "", error);
> > +			dev->power.status = DPM_SUSPENDING;
> 
> And then this isn't needed.
> 
> >  			put_device(dev);
> >  			break;
> >  		}
> > -		dev->power.status = DPM_OFF;
> 
> This line has to be moved into __device_suspend(), even though it won't 
> be protected by dpm_list_mtx.  The same sort of thing applies to 
> dpm_suspend_noirq() (although nothing needs to be moved if you don't 
> make it async).
> 
> The rest looks okay.

Still, I think I'd rework it to use completions for the reason described in the
message I've just sent (in short, because of the off-tree dependencies
problem).

> How about exporting a wait_for_device_to_resume() routine?  Drivers
> could call it for non-tree resume constraints:
> 
> 	void wait_for_device_to_resume(struct device *other)
> 	{
> 		down_read(&other->power.rwsem);
> 		up_read(&other->power.rwsem);
> 	}
> 
> Unfortunately there is no equivalent for non-tree suspend constraints.

If we use completions, it will be possible to just export something like

dpm_wait(dev)
{
        if (dev)
                wait_for_completion(dev->power.completion);
}

I think.  It appears that will also work for suspend, unless I'm missing
something.

Rafael

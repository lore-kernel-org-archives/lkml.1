Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbZLIWij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbZLIWij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758306AbZLIWid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:38:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35257 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758195AbZLIWid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:38:33 -0500
Date: Wed, 9 Dec 2009 17:38:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ rwsems (was: Re: [GIT PULL] PM
 updates for 2.6.33)
In-Reply-To: <200912092318.24475.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Rafael J. Wysocki wrote:

> On Wednesday 09 December 2009, Alan Stern wrote:
> > On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > > For completness, below is the full async suspend/resume patch with rwlocks,
> > > that has been (very slightly) tested and doesn't seem to break things.
> > > 
> > > [Note to Alan: lockdep doesn't seem to complain about the not annotated nested
> > > locks.]
> > 
> > I can't imagine why not.  And wouldn't lockdep get confused by the fact
> > that in the async case, the rwsems are released by a different process
> > from the one that acquired them?
> 
> /me looks at the .config
> 
> I have CONFIG_LOCKDEP_SUPPORT set, is there anything else I need to set
> in .config?

How about CONFIG_PROVE_LOCKING?  If lockdep really does start 
complaining then switching to completions would be a simple way to 
appease it.

> > > @@ -683,10 +835,12 @@ static int dpm_suspend(pm_message_t stat
> > >  
> > >  	INIT_LIST_HEAD(&list);
> > >  	mutex_lock(&dpm_list_mtx);
> > > +	pm_transition = state;
> > >  	while (!list_empty(&dpm_list)) {
> > >  		struct device *dev = to_device(dpm_list.prev);
> > >  
> > >  		get_device(dev);
> > > +		dev->power.status = DPM_OFF;
> > 
> > What's that for?  dev->power.status is supposed to be DPM_SUSPENDING 
> > until the suspend method is successfully completed.
> 
> If the suspend is run asynchronoysly, the main thread will always get a
> "success" from device_suspend(), so it can't change power.status on this
> basis.  I thought we could set power.status to DPM_OFF upfront and change
> it back when error is returned.
> 
> The alternative would be to move the modification of power.status to
> device_suspend() and async_suspend().  Well, maybe that's better.

Yes, I think so.  Or into __device_suspend().  And the same thing in 
dpm_suspend_noirq().

> > How about exporting a wait_for_device_to_resume() routine?  Drivers
> > could call it for non-tree resume constraints:
> > 
> > 	void wait_for_device_to_resume(struct device *other)
> > 	{
> > 		down_read(&other->power.rwsem);
> > 		up_read(&other->power.rwsem);
> > 	}
> > 
> > Unfortunately there is no equivalent for non-tree suspend constraints.
> 
> If we use completions, it will be possible to just export something like
> 
> dpm_wait(dev)
> {
>         if (dev)
>                 wait_for_completion(dev->power.completion);
> }
> 
> I think.  It appears that will also work for suspend, unless I'm missing
> something.

It will.

Alan Stern


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbXGXWOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbXGXWOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbXGXWON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:14:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57025 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755899AbXGXWOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:14:12 -0400
Date: Tue, 24 Jul 2007 18:14:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: Towards eliminating the freezer
In-Reply-To: <200707242314.52355.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0707241807420.17124-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Rafael J. Wysocki wrote:

> > Then device_suspend() can be simplified:
> > 
> > int device_suspend(pm_message_t state)
> > {
> > 	int error = 0;
> > 
> > 	might_sleep();
> > 	list_for_each_entry_reverse(dev, &dpm_locked, power.entry) {
> > 		error = suspend_device(dev, state);
> > 
> > 		if (error) {
> > 			printk(KERN_ERR "Could not suspend device %s: "
> > 				"error %d%s\n",
> > 				kobject_name(&dev->kobj), error,
> > 				error == -EAGAIN ? " (please convert to suspend_late)" : "");
> > 			break;
> > 		}
> > 		list_move(&dev->power.entry, &dpm_off);
> 
> Is that safe with list_for_each_entry_reverse?

No.  I guess it'll have to resemble the other code.

> Yes, that looks fine. 
> 
> So, who's writing the patch? ;-)

I can do it.  You haven't made any changes to this part of the code, 
have you?  My work tends to be based on Linus's tree, not -mm.

Something to watch out for: With all the extra locking, we run the risk
of blocking the keventd workqueue.  This may or may not matter, but to
be safe perhaps there should be a new general-purpose workqueue which
_expects_ to block (or freeze) during suspends.  Any work routine that 
involves adding or removing a device should go on the new workqueue.

> > Incidentally, what is dpm_mtx for?  It doesn't seem to do anything 
> > useful.  Is it a relic of the former runtime PM support?
> 
> I think so.  IMO it can be removed.
> 
> I also think it would be nicer to have all of the functions in
> drivers/base/power/{main|suspend|resume}.c moved to one file.

Yes, they are all similar enough that there isn't much point keeping 
them separate.

Alan Stern


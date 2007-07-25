Return-Path: <linux-kernel-owner+w=401wt.eu-S1764392AbXGYMPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764392AbXGYMPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXGYMPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:15:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59705 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbXGYMPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:15:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Towards eliminating the freezer
Date: Wed, 25 Jul 2007 14:23:07 +0200
User-Agent: KMail/1.9.5
Cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0707241807420.17124-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707241807420.17124-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251423.08254.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 25 July 2007 00:14, Alan Stern wrote:
> On Tue, 24 Jul 2007, Rafael J. Wysocki wrote:
> 
> > > Then device_suspend() can be simplified:
> > > 
> > > int device_suspend(pm_message_t state)
> > > {
> > > 	int error = 0;
> > > 
> > > 	might_sleep();
> > > 	list_for_each_entry_reverse(dev, &dpm_locked, power.entry) {
> > > 		error = suspend_device(dev, state);
> > > 
> > > 		if (error) {
> > > 			printk(KERN_ERR "Could not suspend device %s: "
> > > 				"error %d%s\n",
> > > 				kobject_name(&dev->kobj), error,
> > > 				error == -EAGAIN ? " (please convert to suspend_late)" : "");
> > > 			break;
> > > 		}
> > > 		list_move(&dev->power.entry, &dpm_off);
> > 
> > Is that safe with list_for_each_entry_reverse?
> 
> No.  I guess it'll have to resemble the other code.
> 
> > Yes, that looks fine. 
> > 
> > So, who's writing the patch? ;-)
> 
> I can do it.  You haven't made any changes to this part of the code, 
> have you?

Yes, I have, quite recently. :-)

> My work tends to be based on Linus's tree, not -mm. 

At the moment they are pretty much in line, at least as far as this code is
concerned.  Anyway, I'm trying to keep track of PM-related patches,
at http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.23-rc1/

> Something to watch out for: With all the extra locking, we run the risk
> of blocking the keventd workqueue.  This may or may not matter, but to
> be safe perhaps there should be a new general-purpose workqueue which
> _expects_ to block (or freeze) during suspends.  Any work routine that 
> involves adding or removing a device should go on the new workqueue.

Yes, this sounds like a good idea.  Still, I think we can check if there are
problems with the keventd workqueue alone, first.

> > > Incidentally, what is dpm_mtx for?  It doesn't seem to do anything 
> > > useful.  Is it a relic of the former runtime PM support?
> > 
> > I think so.  IMO it can be removed.
> > 
> > I also think it would be nicer to have all of the functions in
> > drivers/base/power/{main|suspend|resume}.c moved to one file.
> 
> Yes, they are all similar enough that there isn't much point keeping 
> them separate.

Plus some variables might be made static, like dpm_off or even dpm_list_mtx.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

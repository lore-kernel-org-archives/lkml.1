Return-Path: <linux-kernel-owner+w=401wt.eu-S966751AbZLHWco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966751AbZLHWco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966530AbZLHWcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:32:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966378AbZLHWcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:32:39 -0500
Date: Tue, 8 Dec 2009 14:32:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <Pine.LNX.4.44L0.0912081643290.3046-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912081420220.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912081643290.3046-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Dec 2009, Alan Stern wrote:
> 
> Suppose A and B are unrelated devices and we need to impose the
> off-tree constraint that A suspends after B.

Ah. Ok, I can imagine the off-tree constraints, but part of my "keep it 
simple" was to simply not do them. If there are constraints that aren't 
in the topology of the tree, then I simply don't think that async is worth 
it in the first place.

> You misunderstand.  The suspend algorithm will look like this:
> 
> 	dpm_suspend()
> 	{
> 		list_for_each_entry_reverse(dpm_list, dev) {
> 			down_write(dev->lock);
> 			async_schedule(device_suspend, dev);
> 		}
> 	}
> 
> 	device_suspend(dev)
> 	{
> 		device_for_each_child(dev, child) {
> 			down_read(child->lock);
> 			up_read(child->lock);
> 		}
> 		dev->suspend(dev);	/* May do off-tree down+up pairs */
> 		up_write(dev->lock);
> 	}

Ok, so the above I think work (and see my previous email: I think 
completions would be workable there too).

It's just that I think the "looping over children" is ugly, when I think 
that by doing it the other way around you can make the code simpler and 
only depend on the PM device list and a simple parent pointer access.

I also think that you are wrong that the above somehow protects against 
non-topological dependencies. If the device you want to keep delay 
yourself suspending for is after you in the list, the down_read() on that 
may succeed simply because it hasn't even done its down_write() yet and 
you got scheduled early.

But I guess you could do that by walking the list twice (first to lock 
them all, then to actually call the suspend function). That whole 
two-phase thing, except the first phase _only_ locks, and doesn't do any 
callbacks.

			Linus

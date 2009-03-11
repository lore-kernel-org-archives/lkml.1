Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZCKEvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZCKEvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 00:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbZCKEvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 00:51:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbZCKEvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 00:51:33 -0400
Date: Tue, 10 Mar 2009 21:41:51 -0700
From: Greg KH <gregkh@suse.de>
To: Alex Chiang <achiang@hp.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
	per kobj
Message-ID: <20090311044151.GB25840@suse.de>
References: <20090310232027.GC25665@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310232027.GC25665@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 05:20:27PM -0600, Alex Chiang wrote:
> Hi Vegard, sysfs folks,
> 
> Vegard was nice enough to test my PCI remove/rescan patches under
> kmemcheck. Maybe "torture" is a more appropriate term. ;)
> 
> My patch series introduces a sysfs "remove" attribute for PCI
> devices, which will remove that device (and child devices).
> 
> 	http://thread.gmane.org/gmane.linux.kernel.pci/3495
> 
> Vegard decided that he wanted to do something like:
> 
> 	# while true ; do echo 1 > /sys/bus/pci/devices/.../remove ; done
> 
> which caused a nasty oops in my code. You can see the results of
> his testing in the thread I referenced above.
> 
> After looking at my code for a bit, I decided that maybe it
> wasn't completely my fault. ;) See, I'm using device_schedule_callback()

why?  Are you really in interrupt context here to need to do the remove
at a later time?

> which really is a wrapper around sysfs_schedule_callback() which
> is the way that a sysfs attribute is supposed to remove itself to
> prevent deadlock.

Yeah, it's the scsi code that needed this mess :(

If at all possible, I would recommend not using it.

> The problem that Vegard's test exposed is that if you repeatedly
> call a sysfs attribute that's supposed to remove itself using
> device_schedule_callback, we'll keep scheduling work queue tasks
> with a kobj that we really want to release.
> 
> [nb, I bet that /sys/bus/scsi/devices/.../delete will exhibit the
> same problems]

I think it's harder to remove devices multiple times, as it isn't done
through sysfs, but from another external request.  But I could be wrong.

> This is very racy, and at some point, whatever remove handler
> we've scheduled with device_schedule_callback will end up
> referencing a freed kobj.
> 
> I came up with the below patch which changes the semantics of
> device/sysfs_schedule_callback. We now only allow one in-flight
> callback per kobj, and return -EBUSY if that kobj already has a
> callback scheduled for it.
> 
> This patch, along with my updated 07/11 patch in my series,
> prevents at least the first oops that Vegard reported, and I
> suspect it prevents the second kmemcheck error too, although I
> haven't tested under kmemcheck (yet*).
> 
> I'm looking for comments on the approach I took, specifically:
> 
> 	- are we ok with the new restriction I imposed?
> 	- is it ok to return -EBUSY to our callers?
> 	- is the simple linked list proof of concept
> 	  implementation going to scale too poorly?
> 
> To answer my own first two questions, I checked for callers of
> both device_ and sysfs_schedule_callback, and it looks like
> everyone is using it the same way: to schedule themselves for
> removal. That is, although the interface could be used to
> schedule any sort of callback, the only use case is the removal
> use case. I don't think it will be a problem to limit ourselves
> to one remove callback per kobj.

I agree.

> Maybe this patch really wants to be a new interface called
> sysfs_schedule_callback_once or _single, where we check for an
> already-scheduled callback for a kobj, and if we pass, then we
> simply continue on to the existing, unchanged
> sysfs_schedule_callback. I don't feel too strongly about creating
> a new interface, but my belief is that changing the semantics of
> the existing interface is probably the better solution.
> 
> My opinion on my own third question is that removing a device is
> not in the performance path, so a simple linked list is
> sufficient.
> 
> Depending on the feedback here, I'll resend this patch with a
> full changelog (and giving credit to Vegard/kmemcheck as Ingo
> requested I do) or I can rework it.

I have no objection to this change.  But I really would recommend not
using this interface at all if possible.

thanks,

greg k-h

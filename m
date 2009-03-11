Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbZCKHEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbZCKHEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 03:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbZCKHEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 03:04:06 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:5382 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZCKHEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 03:04:05 -0400
Date: Wed, 11 Mar 2009 01:03:59 -0600
From: Alex Chiang <achiang@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
	per kobj
Message-ID: <20090311070359.GF25665@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
	jbarnes@virtuousgeek.org, tj@kernel.org,
	linux-kernel@vger.kernel.org
References: <20090310232027.GC25665@ldl.fc.hp.com> <20090311044151.GB25840@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311044151.GB25840@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:
> On Tue, Mar 10, 2009 at 05:20:27PM -0600, Alex Chiang wrote:
> > Hi Vegard, sysfs folks,
> > 
> > Vegard was nice enough to test my PCI remove/rescan patches under
> > kmemcheck. Maybe "torture" is a more appropriate term. ;)
> > 
> > My patch series introduces a sysfs "remove" attribute for PCI
> > devices, which will remove that device (and child devices).
> > 
> > 	http://thread.gmane.org/gmane.linux.kernel.pci/3495
> > 
> > Vegard decided that he wanted to do something like:
> > 
> > 	# while true ; do echo 1 > /sys/bus/pci/devices/.../remove ; done
> > 
> > which caused a nasty oops in my code. You can see the results of
> > his testing in the thread I referenced above.
> > 
> > After looking at my code for a bit, I decided that maybe it
> > wasn't completely my fault. ;) See, I'm using device_schedule_callback()
> 
> why?  Are you really in interrupt context here to need to do the remove
> at a later time?

What other interface can I use to remove objects from sysfs?

Demo:

Here's the topology of my machine. Sorry about the long line, but
device 0000:04 is a complex device with an internal bridge and 4
PCI functions.

[root@tahitifp1 ~]# lspci -vt
 +-[0000:03]---00.0-[0000:04-07]----00.0-[0000:05-07]--+-02.0-[0000:06]--+-00.0  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
 |                                                     |                 \-00.1  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
 |                                                     \-04.0-[0000:07]--+-00.0  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
 |                                                                       \-00.1  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter

Here's the state of my machine before I do anything.

[root@tahitifp1 ~]# ls /sys/bus/pci/devices/
0000:00:01.0  0000:00:02.2  0000:02:02.0  0000:05:04.0 0000:08:00.0
0000:00:01.1  0000:00:04.0  0000:02:02.1  0000:06:00.0 0000:0a:00.0
0000:00:01.2  0000:01:01.0  0000:03:00.0  0000:06:00.1
0000:00:02.0  0000:01:01.1  0000:04:00.0  0000:07:00.0
0000:00:02.1  0000:02:01.0  0000:05:02.0  0000:07:00.1

We see the following PCI buses.

[root@tahitifp1 ~]# ls /sys/class/pci_bus/
0000:00  0000:02  0000:04  0000:06  0000:08  0000:0a
0000:01  0000:03  0000:05  0000:07  0000:09  0000:0b

Use my shiny new patch set. :)

[root@tahitifp1 ~]# echo 1 > /sys/bus/pci/devices/0000\:04\:00.0/remove 

Now device 0000:04:00.0 is gone, as are all the devices below it.
Just as we expect.

[root@tahitifp1 ~]# ls /sys/bus/pci/devices/
0000:00:01.0  0000:00:02.0  0000:00:04.0  0000:02:01.0 0000:03:00.0
0000:00:01.1  0000:00:02.1  0000:01:01.0  0000:02:02.0 0000:08:00.0
0000:00:01.2  0000:00:02.2  0000:01:01.1  0000:02:02.1 0000:0a:00.0

And the PCI buses are gone too.

[root@tahitifp1 ~]# ls /sys/class/pci_bus/
0000:00  0000:01  0000:02  0000:03  0000:08  0000:09  0000:0a 0000:0b

Let's get them back with the 2nd part of my shiny patch set.

[root@tahitifp1 ~]# echo 1 > /sys/bus/pci/rescan

All the devices came back:

[root@tahitifp1 ~]# ls /sys/bus/pci/devices/
0000:00:01.0  0000:00:02.2  0000:02:02.0  0000:05:04.0 0000:08:00.0
0000:00:01.1  0000:00:04.0  0000:02:02.1  0000:06:00.0 0000:0a:00.0
0000:00:01.2  0000:01:01.0  0000:03:00.0  0000:06:00.1
0000:00:02.0  0000:01:01.1  0000:04:00.0  0000:07:00.0
0000:00:02.1  0000:02:01.0  0000:05:02.0  0000:07:00.1

And so did our PCI buses.

[root@tahitifp1 ~]# ls /sys/class/pci_bus/
0000:00  0000:02  0000:04  0000:06  0000:08  0000:0a
0000:01  0000:03  0000:05  0000:07  0000:09  0000:0b


What other internal API should I be using for something like the
above to work? Especially if someone does something crazy like
that while loop that Vegard showed?

As I understand it, attempting to allow device 0000:04:00.0 to
directly remove itself in the sysfs attribute's store method will
result in deadlock, is that not the case?

And if it will result in deadlock, then I have to use the
device_schedule_callback() API, right?

> > which really is a wrapper around sysfs_schedule_callback() which
> > is the way that a sysfs attribute is supposed to remove itself to
> > prevent deadlock.
> 
> Yeah, it's the scsi code that needed this mess :(
> 
> If at all possible, I would recommend not using it.
> 
> > The problem that Vegard's test exposed is that if you repeatedly
> > call a sysfs attribute that's supposed to remove itself using
> > device_schedule_callback, we'll keep scheduling work queue tasks
> > with a kobj that we really want to release.
> > 
> > [nb, I bet that /sys/bus/scsi/devices/.../delete will exhibit the
> > same problems]
> 
> I think it's harder to remove devices multiple times, as it isn't done
> through sysfs, but from another external request.  But I could be wrong.

I'm not sure I understand what you mean by this.

> > This is very racy, and at some point, whatever remove handler
> > we've scheduled with device_schedule_callback will end up
> > referencing a freed kobj.
> > 
> > I came up with the below patch which changes the semantics of
> > device/sysfs_schedule_callback. We now only allow one in-flight
> > callback per kobj, and return -EBUSY if that kobj already has a
> > callback scheduled for it.
> > 
> > This patch, along with my updated 07/11 patch in my series,
> > prevents at least the first oops that Vegard reported, and I
> > suspect it prevents the second kmemcheck error too, although I
> > haven't tested under kmemcheck (yet*).
> > 
> > I'm looking for comments on the approach I took, specifically:
> > 
> > 	- are we ok with the new restriction I imposed?
> > 	- is it ok to return -EBUSY to our callers?
> > 	- is the simple linked list proof of concept
> > 	  implementation going to scale too poorly?
> > 
> > To answer my own first two questions, I checked for callers of
> > both device_ and sysfs_schedule_callback, and it looks like
> > everyone is using it the same way: to schedule themselves for
> > removal. That is, although the interface could be used to
> > schedule any sort of callback, the only use case is the removal
> > use case. I don't think it will be a problem to limit ourselves
> > to one remove callback per kobj.
> 
> I agree.
> 
> > Maybe this patch really wants to be a new interface called
> > sysfs_schedule_callback_once or _single, where we check for an
> > already-scheduled callback for a kobj, and if we pass, then we
> > simply continue on to the existing, unchanged
> > sysfs_schedule_callback. I don't feel too strongly about creating
> > a new interface, but my belief is that changing the semantics of
> > the existing interface is probably the better solution.
> > 
> > My opinion on my own third question is that removing a device is
> > not in the performance path, so a simple linked list is
> > sufficient.
> > 
> > Depending on the feedback here, I'll resend this patch with a
> > full changelog (and giving credit to Vegard/kmemcheck as Ingo
> > requested I do) or I can rework it.
> 
> I have no objection to this change.  But I really would recommend not
> using this interface at all if possible.

I'm open to other suggestions, but my imagination (or grepping
skills) must be limited. :)

If, as I suspect, that I really do need to use that interface,
please let me know and I'll re-submit my patch with proper
changelog, etc.

Thanks.

/ac


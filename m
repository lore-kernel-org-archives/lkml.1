Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZCKPfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZCKPfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZCKPfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:35:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:33504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbZCKPfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:35:31 -0400
Date: Wed, 11 Mar 2009 08:32:28 -0700
From: Greg KH <gregkh@suse.de>
To: Alex Chiang <achiang@hp.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
	per kobj
Message-ID: <20090311153228.GA21217@suse.de>
References: <20090310232027.GC25665@ldl.fc.hp.com> <20090311044151.GB25840@suse.de> <20090311070359.GF25665@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311070359.GF25665@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 01:03:59AM -0600, Alex Chiang wrote:
> * Greg KH <gregkh@suse.de>:
> > On Tue, Mar 10, 2009 at 05:20:27PM -0600, Alex Chiang wrote:
> > > Hi Vegard, sysfs folks,
> > > 
> > > Vegard was nice enough to test my PCI remove/rescan patches under
> > > kmemcheck. Maybe "torture" is a more appropriate term. ;)
> > > 
> > > My patch series introduces a sysfs "remove" attribute for PCI
> > > devices, which will remove that device (and child devices).
> > > 
> > > 	http://thread.gmane.org/gmane.linux.kernel.pci/3495
> > > 
> > > Vegard decided that he wanted to do something like:
> > > 
> > > 	# while true ; do echo 1 > /sys/bus/pci/devices/.../remove ; done
> > > 
> > > which caused a nasty oops in my code. You can see the results of
> > > his testing in the thread I referenced above.
> > > 
> > > After looking at my code for a bit, I decided that maybe it
> > > wasn't completely my fault. ;) See, I'm using device_schedule_callback()
> > 
> > why?  Are you really in interrupt context here to need to do the remove
> > at a later time?
> 
> What other interface can I use to remove objects from sysfs?

What everyone else does, device_unregister()?  SCSI can't do this
because it is in interrupt context at the moment, that is why it delays
the action from happening.

> Demo:
> 
> Here's the topology of my machine. Sorry about the long line, but
> device 0000:04 is a complex device with an internal bridge and 4
> PCI functions.
> 
> [root@tahitifp1 ~]# lspci -vt
>  +-[0000:03]---00.0-[0000:04-07]----00.0-[0000:05-07]--+-02.0-[0000:06]--+-00.0  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
>  |                                                     |                 \-00.1  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
>  |                                                     \-04.0-[0000:07]--+-00.0  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
>  |                                                                       \-00.1  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
> 
> Here's the state of my machine before I do anything.
> 
> [root@tahitifp1 ~]# ls /sys/bus/pci/devices/
> 0000:00:01.0  0000:00:02.2  0000:02:02.0  0000:05:04.0 0000:08:00.0
> 0000:00:01.1  0000:00:04.0  0000:02:02.1  0000:06:00.0 0000:0a:00.0
> 0000:00:01.2  0000:01:01.0  0000:03:00.0  0000:06:00.1
> 0000:00:02.0  0000:01:01.1  0000:04:00.0  0000:07:00.0
> 0000:00:02.1  0000:02:01.0  0000:05:02.0  0000:07:00.1
> 
> We see the following PCI buses.
> 
> [root@tahitifp1 ~]# ls /sys/class/pci_bus/
> 0000:00  0000:02  0000:04  0000:06  0000:08  0000:0a
> 0000:01  0000:03  0000:05  0000:07  0000:09  0000:0b
> 
> Use my shiny new patch set. :)
> 
> [root@tahitifp1 ~]# echo 1 > /sys/bus/pci/devices/0000\:04\:00.0/remove 
> 
> Now device 0000:04:00.0 is gone, as are all the devices below it.
> Just as we expect.

And this is just what other subsystems do (like USB) when their device
disappears, nothing new here :)

Why can't you use device_unregister()?  Or, you could use device_del(),
which lets you rely on the fact that the device structure is still
around for a bit, but it will disappear from sysfs.  Just don't forget
to do the final put_device() on it to free the memory and "really"
release it.

Or am I missing something else here?

thanks,

greg k-h

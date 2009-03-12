Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbZCLA1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbZCLA1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZCLA1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:27:40 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:1857 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZCLA1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:27:39 -0400
Date: Wed, 11 Mar 2009 18:27:37 -0600
From: Alex Chiang <achiang@hp.com>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <gregkh@suse.de>, Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
	per kobj
Message-ID: <20090312002737.GB17345@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Tejun Heo <tj@kernel.org>,
	Greg KH <gregkh@suse.de>, Vegard Nossum <vegard.nossum@gmail.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
	jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
References: <20090310232027.GC25665@ldl.fc.hp.com> <20090311044151.GB25840@suse.de> <20090311070359.GF25665@ldl.fc.hp.com> <49B76640.6010109@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B76640.6010109@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tejun Heo <tj@kernel.org>:
> Alex Chiang wrote:
> > * Greg KH <gregkh@suse.de>:
> >> On Tue, Mar 10, 2009 at 05:20:27PM -0600, Alex Chiang wrote:
> >>> Hi Vegard, sysfs folks,
> >>>
> >>> Vegard was nice enough to test my PCI remove/rescan patches under
> >>> kmemcheck. Maybe "torture" is a more appropriate term. ;)
> >>>
> >>> My patch series introduces a sysfs "remove" attribute for PCI
> >>> devices, which will remove that device (and child devices).
> >>>
> >>> 	http://thread.gmane.org/gmane.linux.kernel.pci/3495
> >>>
> >>> Vegard decided that he wanted to do something like:
> >>>
> >>> 	# while true ; do echo 1 > /sys/bus/pci/devices/.../remove ; done
> >>>
> >>> which caused a nasty oops in my code. You can see the results of
> >>> his testing in the thread I referenced above.
> >>>
> >>> After looking at my code for a bit, I decided that maybe it
> >>> wasn't completely my fault. ;) See, I'm using device_schedule_callback()
> >> why?  Are you really in interrupt context here to need to do the remove
> >> at a later time?
> > 
> > What other interface can I use to remove objects from sysfs?
> 
> I haven't read your code yet but I seem to recall doing something
> similar.  Ah.. okay, this one didn't get in and I forgot about this.
> 
>   http://thread.gmane.org/gmane.linux.kernel/582130
> 
> But, yeah, committing suicide is currently quite hariy.  I tought SCSI
> did it correctly with all the grab/release dances.  Does SCSI have the
> problem too?

I haven't dived into the SCSI code yet, but they are doing some
sort of magic that I don't understand with their state machine.

Regardless, I think we have two issues.

	1. The existing callback mechanism that everyone hates
	has a "bug".

	2. Your suicide patches haven't made it into mainline yet.

The reason that I think that the "bug" is with the callback
mechanism is because any caller can repeatedly schedule suicide
over and over again, and the callback handler will eventually get
a stale pointer. Rather than make all the callsites handle the
locking, doesn't it make more sense for the infrastructure to do
it?

I realize we're trying to fix something that everyone wants to go
away, but the PCI rescan patches add some pretty useful
functionality and pretty much ready to go except for this. I
could add the bookkeeping into my suicide path, but that's
actually a slightly bigger patch, because now I have to malloc my
own callback structs. And again, I think it's more appropriate to
put that sort of code into the core.

Can we fix 1 in the short term and move towards 2 as the real
solution?

Thanks.

/ac


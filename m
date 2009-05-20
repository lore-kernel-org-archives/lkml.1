Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbZETRVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbZETRVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbZETRVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:21:44 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47075 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbZETRVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:21:42 -0400
Date: Wed, 20 May 2009 22:51:14 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "menage@google.com" <menage@google.com>
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
Message-ID: <20090520172114.GA32078@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090519073942.GA10864@sli10-desk.sh.intel.com> <1242722454.26820.461.camel@twins> <20090519084852.GA13682@sli10-desk.sh.intel.com> <1242723364.26820.466.camel@twins> <1242729538.26820.497.camel@twins> <alpine.LFD.2.00.0905191429440.29241@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0905191429440.29241@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Len Brown <lenb@kernel.org> [2009-05-19 15:01:46]:

> > ... the point is, we
> > don't need a new interface to force a cpu idle. Hotplug does that.
> >
> > Furthermore, we should not want anything outside of that, either the cpu
> > is there available for work, or its not -- halfway measures don't make
> > sense.
> > 
> > Furthermore, we already have power aware scheduling which tries to
> > aggregate idle time on cpu/core/packages so as to maximize the idle time
> > power savings. Use it there.
> 
> Some context...
> 
> In the past, server room power and thermal issues were handled
> either by spending too much money to provision power and
> thermals for theoretical worst case, or by abruptly shutting off
> servers when hard limits were reached.
> 
> Going forward, platforms are getting smarter, measuring how
> much power is drawn from the power supply, measuring the room
> thermals etc. so that real dollars can be saved by deploying
> systems that exceed the theoretical worst case if the power
> and thermal limits are enforced.
> 
> So if server approaches a budget, the platform
> will notify the OS to limit its P-states, and limit its T-states
> in order to draw less power.
> 
> If that is not sufficient, the platform will ask us to take
> processors off-line.  These are not processors that are otherwise idle
> -- those are already saving as much power as they can --
> these are processors that are fully utilized.
> 
> So power-aware scheduling is moot here, this isn't the
> partially idle case, this is the fully utilized case.

Hi Len,

Over and above power-aware scheduling we have been exploring
possibility of forcefully idle cpu for power savings.  This is mostly
useful in thermal case that you have mentioned and also to provide
fine grain power vs performance trade-offs.  Creating idle times and
consolidating idle time efficiently in order to evacuate cores and
packages provides a framework to exploit C-States apart from P-States
and T-States that you have mentioned above.  Addition of C-States
control to save power and heat may make the system do more
instructions at a given power/thermal constraint.

Reference: http://lkml.org/lkml/2009/5/13/173
 
> If power draw continues to be too high, the platform
> will simply ask us to take more processors off line.
> 
> If this dance doesn't reduce power below that required,
> the platform will be shut off.
> 
> So it is sufficient to simply not schedule cpu burners
> on the 'idled' processor.  Interrupts should generally
> not matter -- and if they do, we'll end up simply idling
> an additional processor.

The requirements and use cases are clear.

> > > > Besides, a hot removed cpu will do a dead loop halt, which isn't power saving
> > > > efficient. To make hot removed cpu enters deep C-state is in whish list for a
> > > > long time, but still not available. The acpi_processor_idle is a module, and
> > > > cpuidle governor potentially can't handle offline cpu.
> > > 
> > > Then fix that hot-unplug idle loop. I agree that the hlt thing is silly,
> > > and I've no idea why its still there, seems like a much better candidate
> > > for your efforts than this.
> 
> CONFIG_HOTPLUG_CPU has been problematic in the past.
> It does more than what we need here, so we thought
> a lighter-weight and lower-latency method that simply
> didn't schedule to the idled cpu would suffice.
> 
> Personally, I don't think that CONFIG_HOTPLUG_CPU should exist,
> taking processors on and off-line should be part of CONFIG_SMP.
> 
> A while back when I selected CONFIG_HOTPLUG_CPU from ACPI && SMP,
> there was a torrent of outrage that it infringed on user's right's
> to save that additional 18KB of memory that CONFIG_HOTPLUG_CPU
> includes that SMP does not...
> 
> We are fixing the hotplug-unplug idle loop, but there
> turns out to be some issues with it related to idle
> processors with interrupts disabled that don't actually
> get down into the deep C-states we request:-(

Fixing the hot-unplug idle loop will help us use the cpu-hotplug
infrastructure for many other purposes like power/thermal management
purposes. Do you think there could be some workaround/solution for
this in short term?

> So this is why you see a patch for a "halfway measure",
> it does what is necessary, and does nothing more.

Peter had detailed comments on this aspect.

--Vaidy


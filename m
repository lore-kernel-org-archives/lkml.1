Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbZE1HqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbZE1HqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758495AbZE1Hpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:45:35 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37174 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759321AbZE1Hpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:45:34 -0400
Date: Thu, 28 May 2009 13:14:59 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "menage@google.com" <menage@google.com>
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
Message-ID: <20090528074459.GE11879@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090519073942.GA10864@sli10-desk.sh.intel.com> <1242722454.26820.461.camel@twins> <20090519084852.GA13682@sli10-desk.sh.intel.com> <1242723364.26820.466.camel@twins> <1242729538.26820.497.camel@twins> <20090519133725.GA16709@dirshya.in.ibm.com> <alpine.LFD.2.00.0905272211510.25587@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0905272211510.25587@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Len Brown <lenb@kernel.org> [2009-05-27 22:34:38]:

> On Tue, 19 May 2009, Vaidyanathan Srinivasan wrote:
> 
> > We tried similar approaches to create idle time for power savings, but
> > cpu hotplug interface seem to be a clean choice.  There could be
> > issues with the interface, we should fix it.  Is there any other
> > reason why cpuhotplug is 'ugly' other than its performance (speed)?
> > 
> > I have tried few load balancer hacks to evacuate cores but not a solid
> > design yet.  It has its advantages but still needs more work.
> > 
> > http://lkml.org/lkml/2009/5/13/173
> 
> Thanks for the pointer.
> I agree with Andi, please avoid the term "throttling", since
> it has been used for ages to refer processor clock throttling --
> which is actually significantly less effective at saving
> energy than what you are trying to do.  (not the word "energy"
> here, where the word "power" is incorrectly used in the thread above)

Yes, you are right.  This throttling is used to refer to hardware
methods to slow down things and it is less effective in saving energy.
It reduces average power but make the work load run much longer and
consume more energy.
 
> "core evacuation" is a better description, I agree, though I wonder
> why you don't simply call it "forced idling", since that is what
> you are trying to do.

Yes, core evacuation is what I propose, but actually what we are doing
is starving or throttling tasks in software to create idle time, just
to make the description clear.
 
> > > Furthermore, we should not want anything outside of that, either the cpu
> > > is there available for work, or its not -- halfway measures don't make
> > > sense.
> > > 
> > > Furthermore, we already have power aware scheduling which tries to
> > > aggregate idle time on cpu/core/packages so as to maximize the idle time
> > > power savings. Use it there.
> > 
> > Power aware scheduling can optimally accumulate idle times.  Framework
> > to create idle time to force idle cores is good and useful for power
> > savings.  Other than the speed of online/offline I do not know of any
> > other major issue for using cpu hotplug for this purpose.
> 
> It sounds like you want to use this technique more often
> that I had in mind.  You are thinking of a warm rack, which
> may stay warm all day long.  I am thinking of a rack which
> has a theoretical power draw higher than the providioned
> electrical supply.  As there is a huge difference between
> actual and theoretical power draw, this saves many dollars.

Yes, this framework can be used more often to balance average power
consumption in systems.  Exploiting the margin between theoretical
limits and practical usage will definitely save money in a data
center.  Present generation power capping techniques and related
infrastructure are available to exploit this margin.

Core evacuation can compliment this safety limit mechanism by
providing more fine grain control.

> So what you're looking at is more frequent use than we need,
> and that is fine -- as long as you exhaust P-states first --
> since forcing cores to be idle has a more severe performance
> impact than running at a deeper P-state.

Yes, that is the idea.  After getting all core to lowest P-State, we
can further cut power by forcing idle.  Even when not at the lowest
P-State, forced idle of complete packages may save more power as
compared to running all cores in a large system at lowest P-State.
This is generally not the case, but the framework can be more flexible
and provide more degrees of control.

> I didn't see P-states addressed in your thread.

P-States can be flexibly managed using the present cpufreq governors.
Ondemand, conservative or userspace can provide us with the required
level of control from userspace.  Idle cores will be at lowest
P-States and C-State in case of ondemand governor.  Independent of the
P-States the idle cores will save power from C-State and hence cpufreq
governors does not make an impact.

In the case of busy cores, end users can decide to pick conservative
or userspace governor before invoking core evacuation.

The main motivation for the core evacuation framework is to provide
another degree of control to exploit C-States based power savings
apart from P-State manipulation (for which good framework already
exist).

> > > > > Besides, a hot removed cpu will do a dead loop halt, which isn't power saving
> > > > > efficient. To make hot removed cpu enters deep C-state is in whish list for a
> > > > > long time, but still not available. The acpi_processor_idle is a module, and
> > > > > cpuidle governor potentially can't handle offline cpu.
> > > > 
> > > > Then fix that hot-unplug idle loop. I agree that the hlt thing is silly,
> > > > and I've no idea why its still there, seems like a much better candidate
> > > > for your efforts than this.
> > 
> > I agree with Peter.  We need to make cpu hotplug save power first and
> > later improve upon its performance.
> 
> We do have a patch to fix the offline idle loop to save power.

This will definitely help the objective.  I have looked at Venki's
patch.  We certainly need that feature even outside of the current
context where we want to hotplug faulty CPUs or setup special system
configurations where all cores in a package is not to be used.

> We can use hotplug in the short term until something better comes along.
> Yes, it will break cpusets, just like Shaohua's original patch broke them 
> -- and that will make using it inappropriate for some customers.

It will good to have a solution that does not affect user policy.
Otherwise that will discourage its adoption and usability.  But the
cpu-hotplug solution will work in short term.

> While I think this mechanism is important, I don't think that a large %
> of customers will deploy it.  I think the ones that deploy it will do so
> to save money on electrical provisioning, not on pushing the limits
> of their air conditioner.  So I don't expect its performance requirement
> to be extremely severe.  I don't think it will justify tuning the
> performance of cpu-hotplug, which I don't think was ever intended
> to be in the performance path.

The motivation to improve cpu-hotplug is that we have begin to find
more uses for the framework and if there are issues, this is a good
time to fix it.  Opportunities to improve performance should be
explored because we will have to hotplug multiple CPUs to have an
impact.  The number of cores in the system will become quite large and
we will always have to hotplug multiple cpus to isolate a package for
hardware faults or power saving purposes.

On a system with 4096 CPUs, perhaps 128 cores my be a package or
entity that needs to go off in bulk.  We will certainly not be dealing
with online/offline of one or two cpus in such a system.  Well this is
an extreme case and weired example.  Hope you get the idea on why we
should try to improve cpu-hotplug path.

Thanks for the detailed comments and suggestions.

--Vaidy

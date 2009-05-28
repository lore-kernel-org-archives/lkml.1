Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbZE1Ces@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbZE1Ces (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 22:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbZE1Cek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 22:34:40 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:31915 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZE1Cej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 22:34:39 -0400
Date: Wed, 27 May 2009 22:34:38 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "menage@google.com" <menage@google.com>
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
In-reply-to: <20090519133725.GA16709@dirshya.in.ibm.com>
Message-id: <alpine.LFD.2.00.0905272211510.25587@localhost.localdomain>
References: <20090519073942.GA10864@sli10-desk.sh.intel.com>
 <1242722454.26820.461.camel@twins>
 <20090519084852.GA13682@sli10-desk.sh.intel.com>
 <1242723364.26820.466.camel@twins> <1242729538.26820.497.camel@twins>
 <20090519133725.GA16709@dirshya.in.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009, Vaidyanathan Srinivasan wrote:

> We tried similar approaches to create idle time for power savings, but
> cpu hotplug interface seem to be a clean choice.  There could be
> issues with the interface, we should fix it.  Is there any other
> reason why cpuhotplug is 'ugly' other than its performance (speed)?
> 
> I have tried few load balancer hacks to evacuate cores but not a solid
> design yet.  It has its advantages but still needs more work.
> 
> http://lkml.org/lkml/2009/5/13/173

Thanks for the pointer.
I agree with Andi, please avoid the term "throttling", since
it has been used for ages to refer processor clock throttling --
which is actually significantly less effective at saving
energy than what you are trying to do.  (not the word "energy"
here, where the word "power" is incorrectly used in the thread above)

"core evacuation" is a better description, I agree, though I wonder
why you don't simply call it "forced idling", since that is what
you are trying to do.

> > Furthermore, we should not want anything outside of that, either the cpu
> > is there available for work, or its not -- halfway measures don't make
> > sense.
> > 
> > Furthermore, we already have power aware scheduling which tries to
> > aggregate idle time on cpu/core/packages so as to maximize the idle time
> > power savings. Use it there.
> 
> Power aware scheduling can optimally accumulate idle times.  Framework
> to create idle time to force idle cores is good and useful for power
> savings.  Other than the speed of online/offline I do not know of any
> other major issue for using cpu hotplug for this purpose.

It sounds like you want to use this technique more often
that I had in mind.  You are thinking of a warm rack, which
may stay warm all day long.  I am thinking of a rack which
has a theoretical power draw higher than the providioned
electrical supply.  As there is a huge difference between
actual and theoretical power draw, this saves many dollars.

So what you're looking at is more frequent use than we need,
and that is fine -- as long as you exhaust P-states first --
since forcing cores to be idle has a more severe performance
impact than running at a deeper P-state.

I didn't see P-states addressed in your thread.

> > > > Besides, a hot removed cpu will do a dead loop halt, which isn't power saving
> > > > efficient. To make hot removed cpu enters deep C-state is in whish list for a
> > > > long time, but still not available. The acpi_processor_idle is a module, and
> > > > cpuidle governor potentially can't handle offline cpu.
> > > 
> > > Then fix that hot-unplug idle loop. I agree that the hlt thing is silly,
> > > and I've no idea why its still there, seems like a much better candidate
> > > for your efforts than this.
> 
> I agree with Peter.  We need to make cpu hotplug save power first and
> later improve upon its performance.

We do have a patch to fix the offline idle loop to save power.
We can use hotplug in the short term until something better comes along.
Yes, it will break cpusets, just like Shaohua's original patch broke them 
-- and that will make using it inappropriate for some customers.

While I think this mechanism is important, I don't think that a large %
of customers will deploy it.  I think the ones that deploy it will do so
to save money on electrical provisioning, not on pushing the limits
of their air conditioner.  So I don't expect its performance requirement
to be extremely severe.  I don't think it will justify tuning the
performance of cpu-hotplug, which I don't think was ever intended
to be in the performance path.

-Len

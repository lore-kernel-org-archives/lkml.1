Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbZD1QL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbZD1QL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932798AbZD1QLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:11:13 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:34847 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761191AbZD1QLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:11:12 -0400
Date: Tue, 28 Apr 2009 21:41:14 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Saving power by cpu evacuation using
	sched_mc=n
Message-ID: <20090428161114.GD7178@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090426204029.17495.46609.stgit@drishya.in.ibm.com> <1240826954.8216.8.camel@twins> <20090427142044.GA7178@dirshya.in.ibm.com> <1240907618.7620.86.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1240907618.7620.86.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-04-28 10:33:38]:

> On Mon, 2009-04-27 at 19:50 +0530, Vaidyanathan Srinivasan wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-04-27 12:09:14]:
> 
> > > The whole thing seems to be targeted at thermal management, not power
> > > saving. Therefore using the power saving stuff is backwards.
> > 
> > The framework is useful for power savings and thermal management.
> > Actually we can generalise this a framework to throttle cores.
> 
> To what purpose?

Throttling work will save power and reduce heat.  I was thinking that
to reduce heat we may have to take different cores off at different
times.  
 
> > Power savings need only core evacuation, kernel can decide the most
> > optimum cores to evacuate for best power savings.  While in thermal
> > management we will additional need a 'vector' parameter to direct the
> > load to different parts of the system and level the heat generated.
> 
> Power saving should not generate idle, it should just accumulate idle in
> the most favourable way.

Agreed.  I am looking for ideas to accumulate idles to a single core
or multiple of cores.

> Thermal management must generate idle to avoid hardware breakdown etc.
> Does it really need more than a single max_thermal_capacity knob? That
> is, does it really matter which die in the machine generates the heat?
> 
> If so, why?

I think so because the apart from over-heat trip, we have an
opportunity to reduce leakage power which is proportional to
temperature.  Uniformly heating all core can save us leakage power.
But spreading work for this purpose is not favourable because we will
not goto package idle states. 

We still need to consolidate idle times across system to certain cores
and also periodically keep shifting these idle cores.

Just an idea and possibility, flame me if this weird enough :)  

> > > Provide a knob that provides max_thermal_capacity, and schedule
> > > accordingly.
> > 
> > Yes, we can pick a generic name and use this as a function of total
> > system capacity to indicate number of cores to evacuate.
> 
> No, it should be in a thermal unit, not nr of cores.

Thermal unit is not as intuitive as cores or system capacity right?
Are you suggesting that we specify the maximum heat that can be
generated?
 
> > > FWIW I utterly hate these force idle things because they cause the
> > > scheduler to become non-work conserving, but I have to concede that
> > > software will likely be more suited to handle the thermal overload issue
> > > than hardware will ever be -- so for that use case I'm willing to go
> > > along.
> > 
> > Yes, I agree with your opinion.  However if we can come up with
> > a clean framework to take cores out of scheduler's view, then the work
> > conserving nature of the scheduler can be preserved on the sub-set of
> > cores.  Inserting idle states is more intrusive than leaving out full
> > cores.
> 
> Not really, when you consider the machine (or load-balance domain)
> taking out a few cores it still non-work preserving as you take away
> capacity.

Agreed.  But cpu offline, cpufreq governors, and multi-threaded
CPUs do take away capacity from scheduler today.

> I'm against taking out capacity for anything other than thermal
> management -- full stop.

Are we entering the domain of resource management now?  Should
throttling work be a resource management problem?

> > > Also, the user interface should be that single thermal capacity knob,
> > > more fine grained control is undesired.
> > 
> > For power savings, a single evacuation knob will do.  While for
> > thermal we will need additional parameters to choose the right cores
> > to evacuate.  Some sort of directional/vector parameter.
> 
> Why? are machines that non-uniform in cooling capacity that it really
> matters which core generates the heat? Sounds like badly designed
> hardware to me.
> 
> I would expect it to only be the total head generated/power taken from
> the rack unit.

Your point is correct as long as we want to prevent a thermal trip.
But in future systems we have an opportunity to save power by reducing
the core temperature at the same heat output.  Basically uniformly
heating all cores rather than just one part of the system even if we
are within the total thermal limit can help save leakage power.

> > > Also, before you continue, expand on the interaction with realtime
> > > processes.
> > 
> > Sure.  We will run into complications with respect to realtime
> > scheduling.  You had earlier pointed out a need for variable cpu power
> > to achieve fairness for non-realtime tasks in the presence of realtime
> > tasks.  We should re-visit that idea.
> 
> There is that, another point is load generated by SCHED_OTHER tasks
> pushing the machine in thermal overload should not shut down the
> capacity needed for the real-time tasks.

Yes, this is an interesting and valid requirement.  We should be able
to limit capacity to selected scheduler classes

--Vaidy


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbYKVSCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbYKVSCu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 13:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758735AbYKVSCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 13:02:41 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:36505 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709AbYKVSCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 13:02:39 -0500
Date: Sat, 22 Nov 2008 23:36:21 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: David Collier-Brown <David.Collier-Brown@Sun.COM>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@Sun.COM>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH v4 1/7] sched: Framework for
	sched_mc/smt_power_savings=N
Message-ID: <20081122180621.GA5441@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: David Collier-Brown <David.Collier-Brown@Sun.COM>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@Sun.COM>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Gregory Haskins <gregory.haskins@gmail.com>
References: <20081121082533.27075.12056.stgit@drishya.in.ibm.com> <20081121083052.27075.87221.stgit@drishya.in.ibm.com> <49270FF3.6080302@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <49270FF3.6080302@sun.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Collier-Brown <David.Collier-Brown@Sun.COM> [2008-11-21 19:45:55]:

> Vaidyanathan Srinivasan wrote:
> > From: Gautham R Shenoy <ego@in.ibm.com>
> > 
> > ***  RFC patch of work in progress and not for inclusion. ***
> > 
> > Currently the sched_mc/smt_power_savings variable is a boolean, which either
> > enables or disables topology based power savings. This extends the behaviour of
> > the variable from boolean to multivalued, such that based on the value, we
> > decide how aggressively do we want to perform topology based powersavings
> > balance.
> > 
> > Variable levels of power saving tunable would benefit end user to match the
> > required level of power savings vs performance trade off depending on the
> > system configuration and workloads.
> > 
> > This initial version makes the sched_mc_power_savings global variable to take
> > more values (0,1,2).
> 
>   Might I suggest a dimensioned number rather than a relative one?
> One might say that 100 represents the full power of a system, meaning
> that all chips/cores are running at full speed, whereas 50 means that
> the power system would attempt to halve the resources available, and
> would return a value that represents the value that the power system
> believes it has achieved.  For example, if it could only reduce the
> clock speed by 10%, on a old uniprocessor, it would return 90.

Ideally we would like to have such a metric :)  However practically
the power savings and performance tradeoff depends on 

1) System configuration (topology, cpu type, cpu features)
2) Workload -- memory bound, IO bound, cpu bound
3) Environment -- system temperature 

and many more dimensions that we have not considered yet!

What you are asking for may have been possible if the CPUs were very
simple and performance and power directly corresponded to operating
frequency.  Modern CPUs have very widely varying operating
characteristics that greatly depend on workload type. Hence deriving
a metric for power vs performance tradeoff will be very inaccurate and
useless.

We may be able to design the framework in such a way that each level
of settings will provide increasing levels of power savings with
little or no performance impact (depending on the workload).

Power consumption at sched_mc=0 > sched_mc=1 > sched_mc=2 but not in
linear scale. 

Also, this is only one of the component of the power saving tunables.
There are various governor settings and platform setting that may
affect the power consumption.

 
>   An additional, second value it might return might be the power
> reduction it believed it had achieved.

Measuring the actual power being consumed will be useful for sys
admins to choose the correct settings.  However this is platform
dependent and best left to the platform management tools as compared
to generic scheduler.

We would expect the end user to use the platform management tools to
collect and trend the power consumption data and correlate with the
power saving tunables to decide the best power vs performance
tradeoffs.
 
>   These, by the way, are what my Tadpole GUI shows (;-)) so I'm just
> following someone else's lead.

Can you please provide more details.  I could not get a google hit on
the Tadpole GUI which is relevant to this discussion.  

Thanks,
Vaidy

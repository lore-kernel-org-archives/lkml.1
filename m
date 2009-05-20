Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbZETRhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbZETRhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbZETRg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:36:59 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:59722 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbZETRg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:36:58 -0400
Date: Wed, 20 May 2009 23:06:35 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Len Brown <lenb@kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "menage@google.com" <menage@google.com>
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
Message-ID: <20090520173635.GB32078@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1242722454.26820.461.camel@twins> <20090519084852.GA13682@sli10-desk.sh.intel.com> <1242723364.26820.466.camel@twins> <1242729538.26820.497.camel@twins> <alpine.LFD.2.00.0905191429440.29241@localhost.localdomain> <1242772601.26820.527.camel@twins> <87ljosnfzb.fsf@basil.nowhere.org> <1242821825.26820.583.camel@twins> <20090520131301.GF8684@one.firstfloor.org> <1242826915.26820.609.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1242826915.26820.609.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2009-05-20 15:41:55]:

> On Wed, 2009-05-20 at 15:13 +0200, Andi Kleen wrote:
> > Thanks for the explanation.
> > 
> > My naive reaction would be to fail if the socket to be taken out
> > is the only member of some cpuset. Or maybe break affinities in this case.
> 
> Right, breaking affinities would go against the policy of the admin, I'm
> not sure we'd want to go there. We could start generating msgs about how
> we're in thermal trouble and the given configuration is obstructing
> counter measures etc..
> 
> Currently hot-unplug does break affinities, but that's an explicit
> action by the admin himself, so he gets what he asks for (and we do
> generate complaints in syslog about it).
> 
> [ Same scenario for the HPC guys who affinity fix all their threads to
>   specific cpus, there's really nothing you can do there. Then again
>   such folks generally run their machines at 100% so they'd better
>   be able to deal with their thermal peak capacity anyway. ]
> 
> > > You really want to start shrinking the generic computational capacity
> > > first.
> > 
> > One general issue to remember that if you don't react to the platform hint 
> > the platform will likely force a lower p-state on you to not exceed
> > the thermal limits, making everyone slower. 
> > 
> > (this will likely also not make your real time process happy)
> 
> Quite.
> 
> > So it's a bit more than a hint; it's more like a command "or else"
> > 
> > So it's a good idea to react or at least make at least a reasonable attempt 
> > to react.
> 
> Sure, does the thing give more than a: 'react now, or else' impulse?
> That is, can we see it coming, or will we have to deal with it when
> we're there?
> 
> The latter also has the problem that you have to react very quickly.
> 
> > > The thing is, you cannot simply rip cpus out from under a system, people
> > > might rely on them being there and have policy attached to them -- esp.
> > > people touching cpusets should know that a machine isn't configured
> > > homogeneous and any odd cpu will do.
> > 
> > Ok, so do you think it's possible to figure out based on the cpuset
> > graph / real time runqueue if a socket can be taken out? 
> 
> Right, so all of this depends on a number of things, how frequent and
> how fast would these situations occur?
> 
> I would think they'd be rare events, otherwise you really messed up your
> infrastructure. I also think reaction times should be in the seconds,
> otherwise you're cutting it way to close.
> 
> 
> The work IBM has been doing is centered around overloading neighbouring
> packages in order to keep some idle. The overload is exposed as a
> percentage.
> 
> This works within scheduling domains, so if you carve your machine up in
> tiny (<= 1 package) domains its impossible to do anything (corner case,
> we could send cries for help syslog's way).
> 
> I was hoping we could control the situation with that. But for that to
> work we need some gradual information in order to make that
> thermal<->overload feedback work.

The advantages of this method is to reduce load on one package and not
target a particular CPU.  This is less restrictive and can allow the
load balancer to work out the details.  Keeping a core idle on an
average (over a time interval) is good enough to reduce the power and
heat.  

Here we need not touch the RT jobs or break use space policies.  We
effectively reduce capacity and let the loadbalancer have the
flexibility of figuring out which CPU should not be scheduled now.

That said, this is not useful for a 'cpu cache error' case, in which
case you will have to cpu-hot-unplug anyway.  You don't want any
interrupts/timers to land there in an unreliable CPU.

Overloading the powersave load balancer to assume reduced capacity on
some of the packages while overloading some others packages is the
core idea.  The RFC patches still need a lot of work to meet the
required functionality.

--Vaidy

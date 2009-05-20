Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZETOqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZETOqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZETOpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:45:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52746 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbZETOpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:45:50 -0400
Date: Wed, 20 May 2009 16:45:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Len Brown <lenb@kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
Message-ID: <20090520144546.GA4753@basil.nowhere.org>
References: <1242722454.26820.461.camel@twins> <20090519084852.GA13682@sli10-desk.sh.intel.com> <1242723364.26820.466.camel@twins> <1242729538.26820.497.camel@twins> <alpine.LFD.2.00.0905191429440.29241@localhost.localdomain> <1242772601.26820.527.camel@twins> <87ljosnfzb.fsf@basil.nowhere.org> <1242821825.26820.583.camel@twins> <20090520131301.GF8684@one.firstfloor.org> <1242826915.26820.609.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242826915.26820.609.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 03:41:55PM +0200, Peter Zijlstra wrote:
> On Wed, 2009-05-20 at 15:13 +0200, Andi Kleen wrote:
> > Thanks for the explanation.
> > 
> > My naive reaction would be to fail if the socket to be taken out
> > is the only member of some cpuset. Or maybe break affinities in this case.
> 
> Right, breaking affinities would go against the policy of the admin, I'm
> not sure we'd want to go there. 

> We could start generating msgs about how
> we're in thermal trouble and the given configuration is obstructing
> counter measures etc..

Makes sense.

> 
> Currently hot-unplug does break affinities, but that's an explicit
> action by the admin himself, so he gets what he asks for (and we do

I have some code which can do it implicitely too in mcelog (not yet out).
Basically the CPU can detect when its caches have a problem and the reaction
is then to offline the affected CPUs. But that's a very obscure case
and the alternative is to die.

> generate complaints in syslog about it).

One possible alternative would be also "weak breaking", as in remembering
the old affinities and reinstating them once the CPU becomes online again.

> [ Same scenario for the HPC guys who affinity fix all their threads to
>   specific cpus, there's really nothing you can do there. Then again
>   such folks generally run their machines at 100% so they'd better
>   be able to deal with their thermal peak capacity anyway. ]

Yes. Same for real time. These guys are really not expected to use
these advanced power management features. 

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

My understanding it is a quite strong hint: "do the best you can"
So yes doing it quickly would be good.

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

My assumption too.

> infrastructure. I also think reaction times should be in the seconds,
> otherwise you're cutting it way to close.

Yep.

> I was hoping we could control the situation with that. But for that to
> work we need some gradual information in order to make that
> thermal<->overload feedback work.
> 
> 
> A single: idle a core now (< 'n' sec) or die, isn't really helpful.

That's what you get unfortuantely.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

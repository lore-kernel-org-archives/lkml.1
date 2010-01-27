Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761Ab0A0NXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0A0NXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683Ab0A0NXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:23:51 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46802 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab0A0NXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:23:49 -0500
Date: Wed, 27 Jan 2010 05:23:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       arjan@infradead.org
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
	non-dynticked CPU
Message-ID: <20100127132345.GR6807@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100125034816.GA14043@linux.vnet.ibm.com> <873a1sft9q.fsf@basil.nowhere.org> <20100127052050.GC6807@linux.vnet.ibm.com> <20100127094336.GA12522@basil.fritz.box> <20100127100136.GM6807@linux.vnet.ibm.com> <20100127101342.GC12522@basil.fritz.box> <20100127114459.GP6807@linux.vnet.ibm.com> <20100127121150.GD12522@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127121150.GD12522@basil.fritz.box>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 01:11:50PM +0100, Andi Kleen wrote:
> > From what I can see, most people would want RCU_FAST_NO_HZ=n.  Only
> 
> Most people do not recompile their kernel. And even those
> that do most likely will not have enough information to make
> an informed choice at build time.

I believe that only a few embedded people will be using RCU_FAST_NO_HZ=y.

> > people with extreme power-consumption concerns would likely care enough
> > to select this.
> 
> What would a distributor shipping binary kernels use?

RCU_FAST_NO_HZ=n.

> > > But I think in this case scalability is not the key thing to check
> > > for, but expected idle latency. Even on a large system if near all
> > > CPUs are idle spending some time to keep them idle even longer is a good
> > > thing. But only if the CPUs actually benefit from long idle.
> > 
> > The larger the number of CPUs, the lower the probability of all of them
> > going idle, so the less difference this patch makes.  Perhaps some
> 
> My shiny new 8 CPU threads desktop is not less likely to go idle when I do 
> nothing on it than an older dual core 2 CPU thread desktop.
> 
> Especially not given all the recent optimizations (no idle tick)
> in this area etc. 
> 
> And core/thread counts are growing. In terms of CPU numbers today's
> large machine is tomorrow's small machine.

But your shiny new 8-CPU threads desktop runs off of AC power, right?
If so, I don't think you will care about a 4-5-tick delay for the last
CPU going into dyntick-idle mode.

And I bet you won't be able to measure the difference on your
battery-powered laptop.

> > I do need to query from interrupt context, but could potentially have a
> > notifier set up state for me.  Still, the real question is "how important
> > is a small reduction in power consumption?"
> 
> I think any (measurable) power saving is important. Also on modern Intel
> CPUs power saving often directly translates into performance:
> if more cores are idle the others can clock faster.

OK, I am testing a corrected patch with the kernel configuration
parameter.  If you can show a measureable difference on typical
desktop/server systems, then we can look into doing something more
generally useful.

> > I took a quick look at te pm_qos_latency, and, as you note, it doesn't
> > really seem to be designed to handle this situation.
> 
> It could be extended for it. It's just software after all,
> we can change it.

Of course we can change it.  But should we?

> > And we really should not be gold-plating this thing.  I have one requester
> > (off list) who needs it badly, and who is willing to deal with a kernel
> > configuration parameter.  I have no other requesters, and therefore
> > cannot reasonably anticipate their needs.  As a result, we cannot justify
> > building any kind of infrastructure beyond what is reasonable for the
> > single requester.
> 
> If this has a measurable power advantage I think it's better to
> do the extra steps to make it usable everywhere, with automatic heuristics 
> and no Kconfig hacks. 

I would agree with the following:

	If this has a measurable power advantage -on- -a- -large-
	-fraction- -of- -systems-, then it -might- be better to do
	extra steps to make it usable everywhere, which -might- involve
	heuristics instead of a kernel configuration parameter.

> If it's not then it's probably not worth merging.

This is not necessarily the case.  It can make a lot of sense to try
something for a special case, and then use the experience gained in
that special case to produce a good solution.  On the other hand, it
does not necessarily make sense to do a lot of possibly useless work
based on vague guesses as to what is needed.

If we merge the special case, then others have the opportunity to try it
out, thus getting us the experience required to see (1) if soemthing
more general-purpose is needed in the first place and (2) if so, what
that more general-purpose thing might look like.

							Thanx, Paul

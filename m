Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbYCFPW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbYCFPW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYCFPWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:22:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59000 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYCFPWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:22:20 -0500
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: maxk@qualcomm.com, mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, rientjes@google.com
In-Reply-To: <20080306074729.6233e537.pj@sgi.com>
References: <20080227222103.673194000@chello.nl>
	 <1204311351.6243.130.camel@lappy> <20080229190223.GA17820@elte.hu>
	 <47C87084.3090208@qualcomm.com> <1204318980.6243.133.camel@lappy>
	 <47C8771C.1070001@qualcomm.com> <1204545445.11412.6.camel@twins>
	 <20080303113621.1dfdda87.pj@sgi.com> <1204567052.6241.4.camel@lappy>
	 <20080303121033.c8c9651c.pj@sgi.com> <1204568316.8514.18.camel@twins>
	 <20080304013534.4e51ae48.pj@sgi.com> <1204628762.6241.46.camel@lappy>
	 <47CDA885.3000103@qualcomm.com> <20080304191159.a02be58b.pj@sgi.com>
	 <1204706272.6241.79.camel@lappy>  <20080306074729.6233e537.pj@sgi.com>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 16:21:25 +0100
Message-Id: <1204816885.6241.265.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-06 at 07:47 -0600, Paul Jackson wrote:
> Peter wrote:
> > How about we make this in-kernel boot set, that by default contains all
> > IRQs, all unbounded kthreads and all of user-space.
> 
> If I understood your proposal, the /cgroup/irq cpuset is rather an
> odd cpuset -- it seems to be just used to place the 'system' irqs on
> the specified CPUs.  This is not the usual use of cpusets, which are
> to associate a set of tasks with some resources.  In your example,
> the 'tasks' file in /cgroup/irqs is probably empty, right?

Likely; if for instance you'd want some unbound kernel threads to join
in that overlapping set, then perhaps that name would be badly chosen.

Although I'm not sure which unbound kernel threads would benefit from
such treatment.

> And then you have to argue that certain incompatibilities this
> causes are tolerable:
> 
> > (Upgrading a kernel would require distributing some new userspace
> > anyway, right? - and we could offer a .config option to disable the boot
> > set for those who do upgrade kernels without upgrading user-space).
> 
> No ... we normally do our best not to force apps to change source
> code, or where possible not even force them to recompile, to run on
> new kernels.

Perhaps we're talking about something else here; how bad would it be to
require:

for irq in `cat /cgroup/boot/irqs` ; do echo $irq > /cgroup/irqs; done

be added to rc.local or fully replace your home-brew boot cpuset script?
Its basically an update for that script, giving the exact same semantics
to its user, but moving the larger part of it in-kernel.

> > So by providing a .config option for strict backward compatibility,
> 
> That sort of alternative is useless when dealing with the major
> distros.  They choose one config for half or all of their entire
> market (perhaps distinguishing personal PC from server, but no more).
> They enable everything that doesn't break something they care about.

Sure, but your application vendors will need to re-certify their
applications to run on new distros, sometimes even re-compile because
ABI changes and the like. Certainly providing a new script in the new
version certified for a new distro isn't too much work?

> > > How does all this interact with /proc/irq/N/smp_affinity?
> > 
> > Much the same way the cpuset cpus_allowed interacts with a task's
> > cpus_allowed. That is, cs->cpus_allowed is a mask on top of the provided
> > affinity.
> 
> Ok - something like that could be done, if we had to, just as
> a cpusets 'mems' masks mbind and set_mempolicy nodemasks, and
> a cpusets 'cpus' masks sched_setaffinity cpumasks.
> 
> Could be ... I suppose ... if we had to ... however ...
> 
> 
> I suspect that the reason you had the odd /cgroup/irqs cpuset is that
> it wasn't clear what to do with the irqs of cpusets that had both:
>  1) overlapping cpus, and
>  2) specified different lists of irqs.
> 
> In my view, you are trying to:
>  A] force the <<irq, cpu>, Boolean> mapping into linear lists, and
>  B] then trying to force those linear lists into the cpuset hierarchy.
> 
> With each capability that we've added to cpusets, beginning with CPUs
> and Memory Nodes themselves, and more recently with sched_domains,
> I've strived to keep cpusets fully hierarchical and nestable, supporting
> arbitrary combinations of overlapping CPUs and Memory Nodes.
> 
> What we have here, in this cpuset-irq proposal, I claim, is another
> example of trying to put in a tree what is essentially flat.
> 
> No ... that last paragraph is wrong.  It's worse than that.
> 
> The mapping of <cpu, irq> pairs to Boolean ("can we direct this irq
> to this CPU - yes or no?") is not flat; it's a two-dimensional matrix
> of Boolean.
> 
> So you're [A] squinting out the left eye, flattening the <irq, cpu> map
> to a linear list; then [B] squinting out the right eye and flattening
> the cpuset hierarchy into a flat world; and then exclaiming "Gee,
> these two worlds have similar shape, so let's join them!"
> 
> Why, why, why?  Why such insanity?
> 
> What in tarnation are you trying to do, that's painful or impossible
> to do, with what we have now?

Assign a map of cpus where irqs will default into, and a way to
explicitly move them out of it.

> The only opportunity I've sensed in all this so far is some sort
> of Karnaugh-map factoring of the <<irq, cpu>, Boolean> matrix, as
> an improved representation of the simple, brute force, low level
> /proc/irq/N/smp_affinity map. 

>  Sets of irqs that held a common
> usage pattern could be named, and sets of CPUs that had similar irq
> needs could be named (or named lists of existing cpusets might be
> a suitable proxy for some, not all, such sets), and then this map
> could be represented using these named sets. 

>  Mind you, I don't see
> that big a gain from presenting a second way of looking at what we
> can already see by the current, simple-minded, way, because the
> elegance of being able to group together common clusters (e.g.,
> the set of CPUs that all get the same set of RealTime IRQ's) of the
> existing smp_affinity map is offset by the added complexities of
> having to deal with two ways of saying the same thing. 

>  But perhaps
> I'm missing some real opportunity here to gain significant leverage
> on some problem.  If that's so, then perhaps some new cgroup would
> be appropriate, representing this new interface, pairing named sets
> of irqs to sets with sets of CPUs.  And perhaps, for -some- system
> configurations, it would make sense to use the cgroup capability
> to mount multiple cgroup subsystems together, in a common mount.

> Perhaps ...  I haven't seen what would be sufficient motivation to
> justify such an effort, but I can imagine that such could succeed,
> if some need, as yet unforseen by myself, existed.

So, yes, cgroups are perhaps awkward because they group tasks whereas
the current problem is grouping IRQs.

Because we're mapping them onto CPUs, cpusets came to mind.

The thing we 'need', is to provide named groups of irqs and for each
such a group specify a cpu mask that is appropriate.

Grouping them makes sense in that we want to make a functional division.
Some IRQs serve a system as a whole, others serve a subset. Typical
subsets could be a RT process space bounded to a cpu/mem domain.

Other usable subsets could be limiting the IRQs of node local network
and IO cards to the cpu/mem domain that runs the application that uses
them.

So we group irqs like:

  system_on_nodes_1_2_and_3 (default)
  big_io_app_on_nodes_2_and_3
  rt_app_on_node_4

Where, again, you see a strong similarity to the cpu/mem divisions
already made by cpusets.

I understand its somewhat at odds with the hierarchical nature of the
<task, cpu/mem> mapping you currently have. But its not too far away
either.

Do you see what we want to do, and why our - perhaps misguided - choice
for cpusets? Creating a whole new cgroup controller is also weird
because we don't deal in tasks.

[ Aside from grouping existing IRQs we also want to provide a way to
designate a default group for new IRQs. But I think such functionality
will fall into place once we can agree on the rest.]


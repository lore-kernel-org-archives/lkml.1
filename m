Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZEERuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZEERuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZEERt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:49:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45773 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbZEERt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:49:56 -0400
Date: Tue, 5 May 2009 19:54:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: adapt CPU topology detection for AMD Magny-Cours
Message-ID: <20090505175434.GP23223@one.firstfloor.org>
References: <20090504173330.GF28728@alberich.amd.com> <87vdogbp4g.fsf@basil.nowhere.org> <20090505092238.GB29045@alberich.amd.com> <20090505093520.GL23223@one.firstfloor.org> <20090505104848.GC29045@alberich.amd.com> <20090505144027.GD29045@alberich.amd.com> <20090505153159.GN23223@one.firstfloor.org> <20090505164733.GA2868@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505164733.GA2868@alberich.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 06:47:33PM +0200, Andreas Herrmann wrote:
> > > > First I must say it's unclear to me if CPU topology is really generally
> > > > useful to export to the user.
> > > 
> > > I think it is useful.
> > 
> > You forgot to state for what?
> 
> You are kidding, aren't you? Isn't this obvious?
> Why shouldn't a user be interested in stuff like core_siblings and
> thread_siblings? Maybe a user want to make scheduling decisions based
> on that and pin tasks accordingly?

my earlier point was in this case they should pin based on cache topology
(= cost of cache line transfer in cache) or on memory topology (cost of 
sharing data out of cache). cpu topology seems comparatively unimportant 
compared to the first two. 

> > > (a) Are you saying that users have to check NUMA distances when they
> > >     want to pin tasks on certain CPUs?
> > 
> > CPU == core ? No you just bind to that CPU. Was that a trick question?
> 
> Of course that was no trick question -- at most a stupid typo. (Sometimes
> in Linux CPU == core.) So, no, sorry I meant "certain cores".
> (And I meant not pinning to one core but to a set of cores).

I suspect you meant pinning to a node :) numactl --cpunodebind=...

> 
> > > SLIT and SRAT are not sufficient.
> > > 
> > > The kernel 
> > 
> > Which part of the kernel?
> 
> I provided this info in my first reply to you. Here it is again:
> 
>   "The kernel needs to know this when accessing processor
>    configuration space, when accessing shared MSRs or for counting
>    northbridge specific events."

Wait, but only a "internal node" shares MSRs and that is just
a node anyways isn't it? So that code just needs to look for nodes.

Ok I think you were worried about NUMA off, but still providing
a "fake mini NUMA" seems inferior to me than just always providing
a basic NUMA (even if it's all the same distance) for this case.

Anyways if it's really not working to use nodes for this internally
(although I must admit it's not fully clear to me why not)
I think it's ok to add this information internally; the part
i just object is extending the already stretched cpuinfo interface
for it and exporting such information without designing a proper
flexible future proof interface. 
 
> To translate this for you. Potential users are
> - EDAC ;-)
> - other MCA related stuff (e.g. L3 cache index disable)

Surely that's handled with the existing cache topology.

> - performance monitoring
> - most probably everything that accesses processor configuration
>   space and shared MSRs

It's just the same as a NUMA node. Not different from old systems.
The code can just look that up.

> You didn't read all my mails regarding this topic.
> The patches fixup sibling information for Magny-Cours. This info is
> not only exposed to /proc/cpuinfo but also with cpu-topology
> information in sysfs. I don't see why
> /sys/devices/system/cpu/cpuX/topology is an old ad-hoc hack.

Ok need to check that. I hope it didn't do the graph hardcoding
like your cpuinfo patch though.  After all sysfs is flexible
enough to express arbitary graphs and if something is moved
there it should be a flexible interface. Again I'm not sure
it's really needed though. Having three different topologies
for scheduling is likely not a very good idea in any case.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

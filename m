Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbZEEL5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbZEEL5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 07:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZEEL52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 07:57:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33471 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbZEEL51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 07:57:27 -0400
Date: Tue, 5 May 2009 14:02:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: adapt CPU topology detection for AMD Magny-Cours
Message-ID: <20090505120206.GM23223@one.firstfloor.org>
References: <20090504173330.GF28728@alberich.amd.com> <87vdogbp4g.fsf@basil.nowhere.org> <20090505092238.GB29045@alberich.amd.com> <20090505093520.GL23223@one.firstfloor.org> <20090505104848.GC29045@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505104848.GC29045@alberich.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 12:48:48PM +0200, Andreas Herrmann wrote:
> On Tue, May 05, 2009 at 11:35:20AM +0200, Andi Kleen wrote:
> > > Best example is node interleaving. Usually you won't get a SRAT table
> > > on such a system.
> > 
> > That sounds like a BIOS bug. It should supply a suitable SLIT/SRAT
> > even for this case. Or perhaps if the BIOS are really that broken
> > add a suitable quirk that provides distances, but better fix the BIOSes.
> 
> How do you define SRAT when node interleaving is enabled?
> (Defining same distances between all nodes, describing only one node,
> or omitting SRAT entirely? I've observed that the latter is common
> behavior.)

Either a memory less node with 10 distance (which seems to be envogue 
recently for some reason) or multiple nodes with 10 distance.

> 
> > > Thus you see just one NUMA node in
> > > /sys/devices/system/node.  But on such a configuration you still see
> > > (and you want to see) the correct CPU topology information in
> > > /sys/devices/system/cpu/cpuX/topology. Based on that you always can
> > > figure out which cores are on the same physical package independent of
> > > availability and contents of SRAT and even with kernels that are
> > > compiled w/o NUMA support.
> > 
> > So you're adding a x86 specific mini NUMA for kernels without NUMA
> > (which btw becomes more and more an exotic case -- modern distros
> > are normally unconditionally NUMA) Doesn't seem very useful.
> 
> No, I just tried to give an example why you can't derive CPU topology

First I must say it's unclear to me if CPU topology is really generally
useful to export to the user. If they want to know how far cores
are away they should look at cache sharing and NUMA distances (especially
cache topology gives a very good approximation anyways). For other
purposes like power management just having arbitary sets (x is shared
with y in a set without hierarchy) seems to work just fine.

Then traditionally there were special cases for SMT and for packages
(for error containment etc.) and some hacks for licensing, but these
don't really apply in your case or can be already expressed in other
ways.

If there is really a good use case for exporting CPU topology I would
argue for not adding another adhoc level, but just export a SLIT
style arbitary distance table somewhere in sys. That would support to express 
any possible future hierarchies too. But again I have doubts that's really
needed at all.


> > and you're making it even worse, adding another strange special case.
> 
> It's an abstraction -- I think of it just as another level in the CPU

It's not a general abstraction, just another ad-hoc hack.

> hierarchy -- where existing CPUs and multi-node CPUs fit in:
> 
>   physical package --> processor node --> processor core --> thread
> 
> I guess the problem is that you are associating node always with NUMA.
> Would it help to rename cpu_node_id to something else?

Nope. It's a general problem, renaming it won't make it better.

> or something entirely different?
> 
> > On the other hand NUMA topology is comparatively straight forward and well 
> > understood and it's flexible enough to express your case too.
> > 
> > >    physical package == two northbridges (two nodes)
> > > 
> > > and this needs to be represented somehow in the kernel.
> > 
> > It's just two nodes with a very fast interconnect.
> 
> In fact, I also thought about representing each internal node as one
> physical package. But that is even worse as you can't figure out which
> node is on the same socket. 

That's what the physical id is for.

> The best solution is to reflect the correct CPU topology (all levels
> of the hierarchy) in the kernel. As another use case: for power
> management you might want to know both which cores are on which
> internal node _and_ which nodes are on the same physical package.

The powernow driver needs to know this?

The question is really if it needs to be generally known. That
seems doubtful.

> 
> > > > Who needs this additional information?
> > > 
> > > The kernel needs to know this when accessing processor configuration
> > > space, when accessing shared MSRs or for counting northbridge specific
> > > events.
> > 
> > You're saying there are MSRs shared between the two in package nodes?
> 
> No. I referred to NB MSRs that are shared between the cores on the
> same (internal) node.

Just check siblings then.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

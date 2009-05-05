Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbZEEP1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbZEEP1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbZEEP1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:27:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52847 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbZEEP1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:27:22 -0400
Date: Tue, 5 May 2009 17:31:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: adapt CPU topology detection for AMD Magny-Cours
Message-ID: <20090505153159.GN23223@one.firstfloor.org>
References: <20090504173330.GF28728@alberich.amd.com> <87vdogbp4g.fsf@basil.nowhere.org> <20090505092238.GB29045@alberich.amd.com> <20090505093520.GL23223@one.firstfloor.org> <20090505104848.GC29045@alberich.amd.com> <20090505144027.GD29045@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505144027.GD29045@alberich.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 04:40:27PM +0200, Andreas Herrmann wrote:

I think the general problem with your patchset is that it seems
more like a solution in search of a problem, instead of the proper other
way around.

> > > > > Thus you see just one NUMA node in
> > > > > /sys/devices/system/node.  But on such a configuration you still see
> > > > > (and you want to see) the correct CPU topology information in
> > > > > /sys/devices/system/cpu/cpuX/topology. Based on that you always can
> > > > > figure out which cores are on the same physical package independent of
> > > > > availability and contents of SRAT and even with kernels that are
> > > > > compiled w/o NUMA support.
> > > > 
> > > > So you're adding a x86 specific mini NUMA for kernels without NUMA
> > > > (which btw becomes more and more an exotic case -- modern distros
> > > > are normally unconditionally NUMA) Doesn't seem very useful.
> > > 
> > > No, I just tried to give an example why you can't derive CPU topology
> > 
> > First I must say it's unclear to me if CPU topology is really generally
> > useful to export to the user.
> 
> I think it is useful.

You forgot to state for what?

> 
> (Linux already provides this kind of information.  But it should pass
> only useful/correct information to user space. For Magny-Cours sibling
> information provided by current Linux kernel is not very useful.)
> 
> > If they want to know how far cores
> > are away they should look at cache sharing and NUMA distances (especially
> > cache topology gives a very good approximation anyways). For other
> > purposes like power management just having arbitary sets (x is shared
> > with y in a set without hierarchy) seems to work just fine.
> 
> (a) Are you saying that users have to check NUMA distances when they
>     want to pin tasks on certain CPUs?

CPU == core ? No you just bind to that CPU. Was that a trick question?

If you mean package -- they should probably just bind to one of the two nodes.

> 
> (b) Just an example, if SRAT describes
> 
>     "Either a memory less node with 10 distance (which seems to be
>      envogue recently for some reason) or multiple nodes with 10
>      distance."
> 
>     how would you do (a) to pin tasks say on the same internal node or

Even if they have 10 distance the internal nodes would be still
different. So you can just say "bind to node N" and that would
be one of the internal nodes.

>     on the same physical package? That is not straightforward. But

Bind to all nodes with zero distance from me.

>     representing entire CPU topology in sysfs makes this obvious.

You didn't do that.

> 
> > Then traditionally there were special cases for SMT and for packages
> > (for error containment etc.) and some hacks for licensing, but these
> > don't really apply in your case or can be already expressed in other
> > ways.
> 
> Yes, it's a new "special case" which can't be expressed in other ways.

You seem to assume that it's obviously useful to express. Perhaps
I'm dumb, but can you explain for what?


> SLIT and SRAT are not sufficient.
> 
> The kernel 

Which part of the kernel?

> needs to know which cores are on same internal node. The

If internal core is a north bridge then that's just a NUMA node.

> > > > and you're making it even worse, adding another strange special case.
> > > 
> > > It's an abstraction -- I think of it just as another level in the CPU
> > 
> > It's not a general abstraction, just another ad-hoc hack.
> 
> Fine.
> But do you have any coNSTructive and usable suggestion how Linux

Yes, sysfs and arbitary SLIT like topology like above. But of course a use 
case would need to be established for it first. If there's no use case
there shouldn't be any code either.

> should handle topology information for multi-node processors?
> 
> > > hierarchy -- where existing CPUs and multi-node CPUs fit in:
> > > 
> > >   physical package --> processor node --> processor core --> thread
> > > 
> > > I guess the problem is that you are associating node always with NUMA.
> > > Would it help to rename cpu_node_id to something else?
> > 
> > Nope. It's a general problem, renaming it won't make it better.
> 
> I don't see "a general problem". There is just a new CPU introducing a
> topology that slightly differs from what we had so far. Adapting the
> kernel shouldn't be that problematic.

The general problem is that you're trying to stretch an old ad-hoc
hack (siblings etc. in /proc/cpuinfo) to a complicated new graph structure
and the interface is just not up to that.

As a exercise you can try to write a user space program that uses
these fields to query the topology. It will be a mess.

We went through the same with the caches. Initially /proc/cpuinfo
tried to express the caches. At some point it just became too messy
and cpuinfo now only gives a very simplified "legacy" field and
the real information is in /sys. It went into /sys because there 
was a clear use case. If there's a clear use case for exposing
complex CPU topology (so far that's still an open question
due to lack of good examples) then also a new proper non hacky
interface in /sys would make sense.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

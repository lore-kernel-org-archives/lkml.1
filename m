Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbZEEOlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbZEEOlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZEEOlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:41:11 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:2489 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751812AbZEEOlK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:41:10 -0400
X-BigFish: VPS-20(zz1432R98dR1805M936fJzz1202hzzz32i6bh15fn)
X-FB-SS: 5,13,
X-WSS-ID: 0KJ6E3X-02-1A2-01
Date: Tue, 5 May 2009 16:40:27 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090505144027.GD29045@alberich.amd.com>
References: <20090504173330.GF28728@alberich.amd.com> <87vdogbp4g.fsf@basil.nowhere.org> <20090505092238.GB29045@alberich.amd.com> <20090505093520.GL23223@one.firstfloor.org> <20090505104848.GC29045@alberich.amd.com> <20090505120206.GM23223@one.firstfloor
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090505120206.GM23223@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 May 2009 14:40:49.0994 (UTC) FILETIME=[7BED5AA0:01C9CD8F]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 02:02:06PM +0200, Andi Kleen wrote:
> On Tue, May 05, 2009 at 12:48:48PM +0200, Andreas Herrmann wrote:
> > On Tue, May 05, 2009 at 11:35:20AM +0200, Andi Kleen wrote:
> > > > Best example is node interleaving. Usually you won't get a SRAT table
> > > > on such a system.
> > > 
> > > That sounds like a BIOS bug. It should supply a suitable SLIT/SRAT
> > > even for this case. Or perhaps if the BIOS are really that broken
> > > add a suitable quirk that provides distances, but better fix the BIOSes.
> > 
> > How do you define SRAT when node interleaving is enabled?
> > (Defining same distances between all nodes, describing only one node,
> > or omitting SRAT entirely? I've observed that the latter is common
> > behavior.)
> 
> Either a memory less node with 10 distance (which seems to be envogue 
> recently for some reason) or multiple nodes with 10 distance.

See below -- (a) and (b).

> > > > Thus you see just one NUMA node in
> > > > /sys/devices/system/node.  But on such a configuration you still see
> > > > (and you want to see) the correct CPU topology information in
> > > > /sys/devices/system/cpu/cpuX/topology. Based on that you always can
> > > > figure out which cores are on the same physical package independent of
> > > > availability and contents of SRAT and even with kernels that are
> > > > compiled w/o NUMA support.
> > > 
> > > So you're adding a x86 specific mini NUMA for kernels without NUMA
> > > (which btw becomes more and more an exotic case -- modern distros
> > > are normally unconditionally NUMA) Doesn't seem very useful.
> > 
> > No, I just tried to give an example why you can't derive CPU topology
> 
> First I must say it's unclear to me if CPU topology is really generally
> useful to export to the user.

I think it is useful.

(Linux already provides this kind of information.  But it should pass
only useful/correct information to user space. For Magny-Cours sibling
information provided by current Linux kernel is not very useful.)

> If they want to know how far cores
> are away they should look at cache sharing and NUMA distances (especially
> cache topology gives a very good approximation anyways). For other
> purposes like power management just having arbitary sets (x is shared
> with y in a set without hierarchy) seems to work just fine.

(a) Are you saying that users have to check NUMA distances when they
    want to pin tasks on certain CPUs?

(b) Just an example, if SRAT describes

    "Either a memory less node with 10 distance (which seems to be
     envogue recently for some reason) or multiple nodes with 10
     distance."

    how would you do (a) to pin tasks say on the same internal node or
    on the same physical package? That is not straightforward. But
    representing entire CPU topology in sysfs makes this obvious.

> Then traditionally there were special cases for SMT and for packages
> (for error containment etc.) and some hacks for licensing, but these
> don't really apply in your case or can be already expressed in other
> ways.

Yes, it's a new "special case" which can't be expressed in other ways.
SLIT and SRAT are not sufficient.

The kernel needs to know which cores are on same internal node. The
way my patches do it is to fix core_siblings to refer to siblings on
same internal node instead of physical processor.

Another approach would have been:
- to keep core_siblings as is (to specify siblings on same physical
  processor)
- and to introduce a new cpu mask to specify siblings on same internal
  node

> If there is really a good use case for exporting CPU topology I would
> argue for not adding another adhoc level, but just export a SLIT
> style arbitary distance table somewhere in sys. That would support to express 
> any possible future hierarchies too. But again I have doubts that's really
> needed at all.

I don't agree on this.

> > > and you're making it even worse, adding another strange special case.
> > 
> > It's an abstraction -- I think of it just as another level in the CPU
> 
> It's not a general abstraction, just another ad-hoc hack.

Fine.
But do you have any constructive and usable suggestion how Linux
should handle topology information for multi-node processors?

> > hierarchy -- where existing CPUs and multi-node CPUs fit in:
> > 
> >   physical package --> processor node --> processor core --> thread
> > 
> > I guess the problem is that you are associating node always with NUMA.
> > Would it help to rename cpu_node_id to something else?
> 
> Nope. It's a general problem, renaming it won't make it better.

I don't see "a general problem". There is just a new CPU introducing a
topology that slightly differs from what we had so far. Adapting the
kernel shouldn't be that problematic.

> > or something entirely different?
> > 
> > > On the other hand NUMA topology is comparatively straight forward and well 
> > > understood and it's flexible enough to express your case too.
> > > 
> > > >    physical package == two northbridges (two nodes)
> > > > 
> > > > and this needs to be represented somehow in the kernel.
> > > 
> > > It's just two nodes with a very fast interconnect.
> > 
> > In fact, I also thought about representing each internal node as one
> > physical package. But that is even worse as you can't figure out which
> > node is on the same socket. 
> 
> That's what the physical id is for.

Seconded. The physical id is for identifying the socket. That
implies that phys_proc_id != id_of_internal_node, right?

  <snip>

> > > You're saying there are MSRs shared between the two in package nodes?
> > 
> > No. I referred to NB MSRs that are shared between the cores on the
> > same (internal) node.
> 
> Just check siblings then.

I can't "just check siblings" if core_siblings represent all cores on
the same physical package.


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632



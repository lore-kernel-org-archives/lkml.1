Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbZEEKtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbZEEKtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 06:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZEEKtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 06:49:24 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:56671
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752007AbZEEKtX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 06:49:23 -0400
X-BigFish: VPS-29(zz1432R14e0Q98dR1805M1442J936fJzz1202hzzz32i6bh15fn43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJ63DW-01-B6O-01
Date: Tue, 5 May 2009 12:48:48 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090505104848.GC29045@alberich.amd.com>
References: <20090504173330.GF28728@alberich.amd.com> <87vdogbp4g.fsf@basil.nowhere.org> <20090505092238.GB29045@alberich.amd.com> <20090505093520.GL23223@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090505093520.GL23223@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 May 2009 10:49:10.0421 (UTC) FILETIME=[1F22D450:01C9CD6F]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 11:35:20AM +0200, Andi Kleen wrote:
> > Best example is node interleaving. Usually you won't get a SRAT table
> > on such a system.
> 
> That sounds like a BIOS bug. It should supply a suitable SLIT/SRAT
> even for this case. Or perhaps if the BIOS are really that broken
> add a suitable quirk that provides distances, but better fix the BIOSes.

How do you define SRAT when node interleaving is enabled?
(Defining same distances between all nodes, describing only one node,
or omitting SRAT entirely? I've observed that the latter is common
behavior.)

> > Thus you see just one NUMA node in
> > /sys/devices/system/node.  But on such a configuration you still see
> > (and you want to see) the correct CPU topology information in
> > /sys/devices/system/cpu/cpuX/topology. Based on that you always can
> > figure out which cores are on the same physical package independent of
> > availability and contents of SRAT and even with kernels that are
> > compiled w/o NUMA support.
> 
> So you're adding a x86 specific mini NUMA for kernels without NUMA
> (which btw becomes more and more an exotic case -- modern distros
> are normally unconditionally NUMA) Doesn't seem very useful.

No, I just tried to give an example why you can't derive CPU topology
from NUMA topology.

IMHO we have two sorts of topology information:
(1) CPU topology (physical package, core siblings, thread siblings)
(2) NUMA topology

Of course also for non-NUMA systems the kernel detects and provides (1).

> My problem with that is that imho the x86 topology information is already
> too complicated --

Well, it won't be simpler in the future. But it shouldn't be too complicate
to understand it if its' properly represented and documented.

> i suspect very few people can make sense of it --
> and you're making it even worse, adding another strange special case.

It's an abstraction -- I think of it just as another level in the CPU
hierarchy -- where existing CPUs and multi-node CPUs fit in:

  physical package --> processor node --> processor core --> thread

I guess the problem is that you are associating node always with NUMA.
Would it help to rename cpu_node_id to something else?

I suggested to introduce

 cpu_node_id (in style of AMD specs)

How about

 cpu_chip_id (in the style of MCM - multi-chip module ;-)
 cpu_nb_id   (nb == northbridge, introducing kind of northbridge domain)
 cpu_die_id

or something entirely different?

> On the other hand NUMA topology is comparatively straight forward and well 
> understood and it's flexible enough to express your case too.
> 
> >    physical package == two northbridges (two nodes)
> > 
> > and this needs to be represented somehow in the kernel.
> 
> It's just two nodes with a very fast interconnect.

In fact, I also thought about representing each internal node as one
physical package. But that is even worse as you can't figure out which
node is on the same socket. And "physical package id" is used as
socket information.

The best solution is to reflect the correct CPU topology (all levels
of the hierarchy) in the kernel. As another use case: for power
management you might want to know both which cores are on which
internal node _and_ which nodes are on the same physical package.

> > > Who needs this additional information?
> > 
> > The kernel needs to know this when accessing processor configuration
> > space, when accessing shared MSRs or for counting northbridge specific
> > events.
> 
> You're saying there are MSRs shared between the two in package nodes?

No. I referred to NB MSRs that are shared between the cores on the
same (internal) node.


Regards,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632



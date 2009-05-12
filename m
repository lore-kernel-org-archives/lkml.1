Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZELPGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZELPGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbZELPG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:06:27 -0400
Received: from relay2.sgi.com ([192.48.179.30]:37784 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756218AbZELPG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:06:26 -0400
Date: Tue, 12 May 2009 10:06:22 -0500
From: Jack Steiner <steiner@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
Message-ID: <20090512150622.GA10015@sgi.com>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com> <4A0894A5.9000209@zytor.com> <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 03:25:39PM -0700, David Rientjes wrote:
> On Mon, 11 May 2009, H. Peter Anvin wrote:
> 
> > > In your example of two cpus (0-1) that are remote to the system's only
> > > memory and two cpus (2-3) that have affinity to that memory, it appears as
> > > though the kernel is considering cpus 2-3 and the memory to be a node and
> > > cpus 0-1 to be a memoryless node.
> > > 
> > > That's a pretty useless scenario for memoryless node support, actually,
> > > unless there's a third node with memory that cpus 0-1 have a different
> > > distance to.  cpus 0-1 have no memory that is local, so the "remote" memory
> > > should be considered local to them.
> > > 
> > 
> > Should it?  It seems to me that CPUs 0-1 should be antipreferentially
> > scheduled, since they will have slower access to the memory than CPUs 2-3.
> > Since in this case all the memory is in the same place you could argue that
> > SMP distances could do the same job, which is of course true.
> > 
> > However, consider now:
> > 
> > CPU [0-1]	- no memory
> > CPU [2-3]	- memory
> > CPU [4-5]	- memory
> > 
> > Each node is equidistant, but for the memory nodes there is differences
> > between their own local memory and the remote memory.
> > 
> > CPU [0-1] cannot be considered local in either node, since they are further
> > away from the memory than either, and furthermore, unlike either of the memory
> > nodes, they have no preference for memory from either of the other two nodes
> > (quite on the contrary; they would probably benefit from drawing from both.)
> > 
> 
> Right, there's no difference from Jack's scenario if the three nodes are 
> equiadistant.  I was thinking of a topology where cpu 0-1 was closer to, 
> for example, cpu 2-3's memory than cpu 4-5's.

Agree.

We actually have configurations that match both scenarios above. The
system is a blade-based system with 2 processor sockets per blade.
Memory is socket attached and each socket is in a unique PXM.

For the case where 1 socket on a blade has memory & the other does not,
the memoryless socket is very close to it's neighbor and much further from
memory on any other blade.

For the case where neither socket has memory, the blade is equidistant
from 14 nodes located on adjacent blades.

One final point. In case you think this configuration makes no sense, the
sockets actually have memory. However, none of the memory is directly
accessible to the OS nor can it be referenced by cores located on the
processor sockets. The memory is reserved for high speed access to special
blade-attached IO devices. The IO devices need large 2**2n sized chunks of
memory. If the memory is fragmented so that a portion can be used by the
OS, then the max chunk size is reduced by a factor of 4.

> 
> The particular topology you're referring to should have a slit that 
> describes the relative distances in each direction differently.  The pxms 
> that these cpus belong to will always be local to itself, but ACPI 3.0 
> allows distances for different directions between the same pxms to be 
> different.
> 
> That means it's possible that cpus 0-1 above have local distance to all 
> memory and cpus 2-3 (and cpus 4-5) have remote distance to all nodes other 
> than itself.
> 
> numactl --hardware would show something like this:
> 
> 		0	1	2
> 	0	10	10	10
> 	1	20	10	20
> 	2	20	20	10
> 
> which is valid according to the ACPI specification.  This is based on the 
> pxms to which the cpus belong so this topology would describe all members 
> of those pxms and not just memory.

The BIOS currently defines unique PXMs for all nodes as implied above. The
SLIT currently looks like:
 		0	1	2
 	0	10	20	20
 	1	20	10	20
 	2	20	20	10

but I understand your point. This is an easy fix.


--- jack

	

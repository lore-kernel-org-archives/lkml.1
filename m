Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZGAMXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZGAMXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZGAMXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:23:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40855 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZGAMXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:23:11 -0400
Date: Wed, 1 Jul 2009 14:23:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve lpage NUMA support
Message-ID: <20090701122312.GP6760@one.firstfloor.org>
References: <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org> <4A4A9DC6.6020003@kernel.org> <20090701064250.GM6760@one.firstfloor.org> <4A4B38C5.1070504@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4B38C5.1070504@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 07:21:57PM +0900, Tejun Heo wrote:
> > using possible per cpu data I picked in current git: icmp.c
> 
> I was talking about percpu allocator proper.  Yeap, the major work
> would be in auditing and converting for_each_possible_cpu() users.

and testing. that's the hard part. cpu hotplug is normally not well
tested. Any code change that requires lots of new code for 
it will be a problem because that code will then likely bitrot.

> >         kfree(net->ipv4.icmp_sk);
> >         net->ipv4.icmp_sk = NULL;
> > }
> > 
> > You would need to convert that to use a CPU notifier and callbacks
> > setting up the sockets. Then make sure there are no races in all of
> > this. And get it somehow tested (where is the user base who
> > tests cpu hotplug?) 
> 
> Maybe it would be better to allocate percpu sockets as proper percpu
> variables.  

That would be like percpu dentries.

A socket is a very complex structure. Trying to pull it out 
of its normal allocators would be a bad idea.

I actually had a patch some time ago to move this one over
to callbacks, but it was already difficult, and I dropped
it.

> Initialization would still need callback mechanism tho.  I
> was thinking about adding @init callback to percpu_alloc(), which
> would be much simpler than doing full cpu hotplug callback.

I'm not sure it will be actually simpler. It's not just
initializing the structure, but all the other set up to make
it known to the world.

> 
> > And there is lots of similar code all over the tree
> 
> For static percpu variables, it'll be mostly about converting
> for_each_possible_cpu() to for_each_used_cpu() as both allocation and
> initialization can be handled by percpu proper.  For dynamic areas,

That's the easy part, but you would still need all the callbacks 
for the extension case.

> allocation can be handled by percpu proper but cpus coming online
> would need more work to convert.  It'll take some effort but there
> aren't too many alloc_percpu() users yet and I don't think it will be

alloc_percpu()? It affects all DEFINE_PER_CPU users. My current
tree has hundreds.

> too difficult.  I wouldn't know for sure before I actually try tho.

I think it's clear that you haven't tried yet :)

I wrote quite a few per cpu callback handlers over the years and
in my experience they are all nasty code with subtle races. The problem
is that instead of having a single subset init function which
is just single threaded and doesn't need to worry about races
you now have multi threaded init, which tends to be a can of worms.

I think a far saner strategy than rewriting every user of DEFINE_PER_CPU,
ending up with lots of badly tested code is to:

- Fix the few large size percpu pigs that are problematic today to
allocate in a callback.
- Then once the per cpu data in all configurations is <200k (better
<100 in the non debug builds) again just keep pre-allocating like we always did
- Possibly adjust the vmalloc area on 32bit based on the possible
CPU map at the cost of the direct mapping, to make sure there's always enough 
mapping space.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

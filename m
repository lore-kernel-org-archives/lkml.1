Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbZGTIcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbZGTIcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 04:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbZGTIcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 04:32:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:58006 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZGTIcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 04:32:16 -0400
Date: Mon, 20 Jul 2009 10:32:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, fche@redhat.com, cl@linux-foundation.org
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already using mudflap
Message-ID: <20090720083212.GA7070@wotan.suse.de>
References: <1247215920.32044.3.camel@penberg-laptop> <20090710090351.GD14666@wotan.suse.de> <1247217263.771.8.camel@penberg-laptop> <20090710092921.GF14666@wotan.suse.de> <1247218826.771.15.camel@penberg-laptop> <alpine.DEB.2.00.0907100243010.14601@chino.kir.corp.google.com> <1247219506.771.22.camel@penberg-laptop> <alpine.DEB.2.00.0907100253560.14601@chino.kir.corp.google.com> <20090715145907.GE7298@wotan.suse.de> <alpine.DEB.2.00.0907151309540.22582@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907151309540.22582@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 01:19:27PM -0700, David Rientjes wrote:
> On Wed, 15 Jul 2009, Nick Piggin wrote:
> 
> > > It's my opinion that slab is on its way out when there's no benchmark that 
> > > shows it is superior by any significant amount.  If that happens (and if 
> > > its successor is slub, slqb, or a yet to be implemented allocator), we can 
> > > probably start a discussion on what's in and what's out at that time.
> > 
> > How are you running your netperf test? Over localhost or remotely?
> > It is a 16 core system? NUMA?
> > 
> 
> I ran it remotely using two machines on the same rack.  Both were four 
> quad-core UMA systems.

OK, I feared as much ;) I concede localhost testing isn't a good
idea when doing networking tests (especially where cache hotness
of things is concerned). So my numbers don't mean too much.
I'll try to rig up some remote tests (don't have very good network
setups here). Are you just using single 1GbE, or more?

 
> > It seems pretty variable when I run it here, although there seems
> > to be a pretty clear upper bound on performance, where a lot of the
> > results land around (then others go anywhere down to less than half
> > that performance).
> > 
> 
> My results from my slub partial slab thrashing patchset comparing slab and 
> slub were with a variety of different thread counts, each a multiple of 
> the number of cores.  The most notable slub regression always appeared in 
> the higher thread counts with this script:

Yes, I was using your script you put in the earlier post. I did
run varying numbers of threads, but so much noise in the results
that I just cut it to a single (high) thread count to get enough
runs.

 
> #!/bin/bash
> 
> TIME=60				# seconds
> HOSTNAME=hostname.goes.here	# netserver
> 
> NR_CPUS=$(grep ^processor /proc/cpuinfo | wc -l)
> echo NR_CPUS=$NR_CPUS
> 
> run_netperf() {
> 	for i in $(seq 1 $1); do
> 		netperf -H $HOSTNAME -t TCP_RR -l $TIME &
> 	done
> }
> 
> ITERATIONS=0
> while [ $ITERATIONS -lt 10 ]; do
> 	RATE=0
> 	ITERATIONS=$[$ITERATIONS + 1]	
> 	THREADS=$[$NR_CPUS * $ITERATIONS]
> 	RESULTS=$(run_netperf $THREADS | grep -v '[a-zA-Z]' | awk '{ print $6 }')
> 
> 	for j in $RESULTS; do
> 		RATE=$[$RATE + ${j/.*}]
> 	done
> 	echo threads=$THREADS rate=$RATE
> done
> 
> > Anyway, tried to get an idea of performance on my 8 core NUMA system,
> > over localhost, and just at 64 threads. Ran the test 60 times for
> > each allocator.
> > 
> > Rates for 2.6.31-rc2 (+slqb from Pekka's tree)
> > SLAB: 1869710
> > SLQB: 1859710
> > SLUB: 1769400
> > 
> 
> Great, slqb doesn't regress nearly as much as slub did.

No, although let's see if I can get some remote numbers.

 
> These statistics do show that pulling slab out in favor of slub 
> prematurely is probably inadvisible, however, when the performance 
> achieved with slab in this benchmark is far beyond slub's upper bound.

Well these, and others, I agree. You're not the only one unhappy
with slub performance (and I wouldn't have wasted my time with
slqb if I was happy with it). I think we can give SLUB some more
time though if Christoph has some improvements.

 
> > Now I didn't reboot or restart netperf server during runs, so there
> > is possibility of results drifting for some reason (eg. due to
> > cache/node placment).
> > 
> 
> SLUB should perform slightly better after the first run on a NUMA system 
> since its partial lists (for kmalloc-256 and kmalloc-2048) should be 
> populated with free slabs, which avoid costly page allocations, because of 
> min_partial.

Yeah, although it's probably within the noise really. But I can
turn it into a pseudo-UMA system as well, so I will try with that
too.

Thanks,
Nick


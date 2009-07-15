Return-Path: <linux-kernel-owner+w=401wt.eu-S932277AbZGOUTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbZGOUTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbZGOUTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:19:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:23976 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbZGOUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:19:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=glfFvW4ON6Q7jUBdvpTRwc0p5RrFS4yj8Y8smJ4ZWBp0zswxK+Le/+g6IB92zJIy1
	jpiK5mqLznnb3UDms/i6Q==
Date: Wed, 15 Jul 2009 13:19:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, fche@redhat.com, cl@linux-foundation.org
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap
In-Reply-To: <20090715145907.GE7298@wotan.suse.de>
Message-ID: <alpine.DEB.2.00.0907151309540.22582@chino.kir.corp.google.com>
References: <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com> <20090710084745.GA26752@elte.hu> <1247215920.32044.3.camel@penberg-laptop> <20090710090351.GD14666@wotan.suse.de> <1247217263.771.8.camel@penberg-laptop> <20090710092921.GF14666@wotan.suse.de>
 <1247218826.771.15.camel@penberg-laptop> <alpine.DEB.2.00.0907100243010.14601@chino.kir.corp.google.com> <1247219506.771.22.camel@penberg-laptop> <alpine.DEB.2.00.0907100253560.14601@chino.kir.corp.google.com> <20090715145907.GE7298@wotan.suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009, Nick Piggin wrote:

> > It's my opinion that slab is on its way out when there's no benchmark that 
> > shows it is superior by any significant amount.  If that happens (and if 
> > its successor is slub, slqb, or a yet to be implemented allocator), we can 
> > probably start a discussion on what's in and what's out at that time.
> 
> How are you running your netperf test? Over localhost or remotely?
> It is a 16 core system? NUMA?
> 

I ran it remotely using two machines on the same rack.  Both were four 
quad-core UMA systems.

> It seems pretty variable when I run it here, although there seems
> to be a pretty clear upper bound on performance, where a lot of the
> results land around (then others go anywhere down to less than half
> that performance).
> 

My results from my slub partial slab thrashing patchset comparing slab and 
slub were with a variety of different thread counts, each a multiple of 
the number of cores.  The most notable slub regression always appeared in 
the higher thread counts with this script:

#!/bin/bash

TIME=60				# seconds
HOSTNAME=hostname.goes.here	# netserver

NR_CPUS=$(grep ^processor /proc/cpuinfo | wc -l)
echo NR_CPUS=$NR_CPUS

run_netperf() {
	for i in $(seq 1 $1); do
		netperf -H $HOSTNAME -t TCP_RR -l $TIME &
	done
}

ITERATIONS=0
while [ $ITERATIONS -lt 10 ]; do
	RATE=0
	ITERATIONS=$[$ITERATIONS + 1]	
	THREADS=$[$NR_CPUS * $ITERATIONS]
	RESULTS=$(run_netperf $THREADS | grep -v '[a-zA-Z]' | awk '{ print $6 }')

	for j in $RESULTS; do
		RATE=$[$RATE + ${j/.*}]
	done
	echo threads=$THREADS rate=$RATE
done

> Anyway, tried to get an idea of performance on my 8 core NUMA system,
> over localhost, and just at 64 threads. Ran the test 60 times for
> each allocator.
> 
> Rates for 2.6.31-rc2 (+slqb from Pekka's tree)
> SLAB: 1869710
> SLQB: 1859710
> SLUB: 1769400
> 

Great, slqb doesn't regress nearly as much as slub did.

These statistics do show that pulling slab out in favor of slub 
prematurely is probably inadvisible, however, when the performance 
achieved with slab in this benchmark is far beyond slub's upper bound.

> Now I didn't reboot or restart netperf server during runs, so there
> is possibility of results drifting for some reason (eg. due to
> cache/node placment).
> 

SLUB should perform slightly better after the first run on a NUMA system 
since its partial lists (for kmalloc-256 and kmalloc-2048) should be 
populated with free slabs, which avoid costly page allocations, because of 
min_partial.

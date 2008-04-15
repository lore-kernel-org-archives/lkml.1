Return-Path: <linux-kernel-owner+w=401wt.eu-S1765770AbYDOREt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765770AbYDOREt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 13:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbYDOREl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 13:04:41 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:14938 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbYDOREk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:04:40 -0400
Message-ID: <4804E022.4070408@hp.com>
Date: Tue, 15 Apr 2008 13:04:34 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Block IO: more io-cpu-affinity results
References: <4804A3E4.1060605@hp.com>
In-Reply-To: <4804A3E4.1060605@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan D. Brunelle wrote:
> On a 4-way IA64 box we are seeing definite improvements in overall
> system responsiveness w/ the patch series currently in Jens'
> io-cpu-affinity branch on his block IO git repository. In this
> microbenchmark, I peg 4 processes to 4 separate processors: 2 are doing
> CPU-intensive work (sqrts) and 2 are doing IO-intensive work (4KB direct
> reads from RAID array cache - thus limiting physical disk accesses).
> 
> There are 2 variables: whether rq_affinity is on or off for the devices
> under test for the IO-intensive procs, and whether the IO-intensive
> procs are pegged onto the same CPU as is handling IRQs for its device.
> The results are averaged over 4-minute runs per permutation.
> 
> When the IO-intensive procs are pegged onto the CPU that is handling
> IRQs for its device, we see no real difference between rq_affinity on or
> off:
> 
> rq=0 local=1     66.616 (M sqrt/sec)   12.312 (K ios/sec)
> rq=1 local=1     66.616 (M sqrt/sec)   12.314 (K ios/sec)
> 
> Both see 66.616 million sqrts per second, and 12,300 IOs per second.
> 
> However, when we move the 2 IO-intensive threads onto CPUs that are not
> handling its IRQs, we see a definite improvement - both in terms of the
> amount of CPU-intensive work we can do (about 4%), as well as the number
> of IOs per second achieved (about 1%):
> 
> rq=0 local=0     61.929 (M sqrt/sec)   11.911 (K ios/sec)
> rq=1 local=0     64.386 (M sqrt/sec)   12.026 (K ios/sec)
> 
> Alan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

This is even more noticeable on a larger system - a 16-way IA64 box - so
now 8 CPUs are doing IO-intensive and 8 are doing CPU-intensive loads.

rq=0 local=1    266.437 (M sqrt/sec)   50.018 (K ios/sec)
rq=1 local=1    266.399 (M sqrt/sec)   50.035 (K ios/sec)

rq=0 local=0    219.692 (M sqrt/sec)   39.842 (K ios/sec)
rq=1 local=0    247.406 (M sqrt/sec)   44.995 (K ios/sec)

By setting rq=1 when IOs are being remoted, we see a 12.61% improvement
on the CPU-intensive processes, and 12.93% improvement for the
IO-intensive loads.




However, if we remove the affinitization of the processes - just start
up 16 processes (8 IO-intensive + 8 CPU-intensive), and let the
scheduler associate processes w/ CPUs as normal, we see a very different
picture (single run of 4 minutes per rq value):

rq=0 local=0    261.050 (M sqrt/sec)   49.147 (K ios/sec)
rq=1 local=0    264.481 (M sqrt/sec)   42.817 (K ios/sec)

Setting rq to 1 yields about a 1.31% improvement for the CPU-intensive
tasks, but a 12.88% reduction in IO-intensive performance.




But that is subject to some initial placement randomness, doing ten
30-second runs, I'm seeing:

rq=0 M sqrt/sec: min=228.877, avg=240.043, max=256.925
rq=1 M sqrt/sec: min=237.202, avg=249.405, max=258.302

rq=0 K ios/sec : min= 46.198, avg= 47.760, max= 50.057
rq=1 K ios/sec : min= 38.076, avg= 41.007, max= 43.271

Which works out to a 14.14% decrease in ios/sec when RQ=1, with only a
3.90% increase in the CPU-intensive performance.

I'll need to do some work to see what's causing the problem in these
latter tests...

Alan

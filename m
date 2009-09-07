Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZIGMQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZIGMQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbZIGMQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:16:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56756 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbZIGMQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:16:18 -0400
Date: Mon, 7 Sep 2009 14:16:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: kernel@kolivas.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       efault@gmx.de
Subject: [quad core results] BFS vs. mainline scheduler benchmarks and
	measurements
Message-ID: <20090907121613.GA32097@elte.hu>
References: <20090906205952.GA6516@elte.hu> <200909070405.23936.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909070405.23936.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Pop <elendil@planet.nl> wrote:

> Ingo Molnar wrote:
> > So the testbox i picked fits into the upper portion of what i
> > consider a sane range of systems to tune for - and should still fit
> > into BFS's design bracket as well according to your description:
> > it's a dual quad core system with hyperthreading.
> 
> Ingo,
> 
> Nice that you've looked into this.
> 
> Would it be possible for you to run the same tests on e.g. a dual 
> core and/or a UP system (or maybe just offline some CPUs?)? It 
> would be very interesting to see whether BFS does better in the 
> lower portion of the range, or if the differences you show between 
> the two schedulers are consistent across the range.

Sure!

Note that usually we can extrapolate ballpark-figure quad and dual 
socket results from 8 core results. Trends as drastic as the ones 
i reported do not get reversed as one shrinks the number of cores. 

[ This technique is not universal - for example borderline graphs
  on cannot be extrapolated down reliably - but the graphs i 
  posted were far from borderline. ]

Con posted single-socket quad comparisons/graphs so to make it 100% 
apples to apples i re-tested with a single-socket (non-NUMA) quad as 
well, and have uploaded the new graphs/results to:

  kernel build performance on quad:
     http://redhat.com/~mingo/misc/bfs-vs-tip-kbuild-quad.jpg

  pipe performance on quad:
     http://redhat.com/~mingo/misc/bfs-vs-tip-pipe-quad.jpg

  messaging performance (hackbench) on quad:
     http://redhat.com/~mingo/misc/bfs-vs-tip-messaging-quad.jpg

  OLTP performance (postgresql + sysbench) on quad:
     http://redhat.com/~mingo/misc/bfs-vs-tip-oltp-quad.jpg

It shows similar curves and behavior to the 8-core results i posted 
- BFS is slower than mainline in virtually every measurement. The 
ratios are different for different parts of the graphs - but the 
trend is similar.

I also re-ran a few standalone kernel latency tests with a single 
quad:

lat_tcp:

  BFS:          TCP latency using localhost: 16.9926 microseconds
  sched-devel:  TCP latency using localhost: 12.4141 microseconds [36.8% faster]

  as a comparison, the 8 core lat_tcp result was:

  BFS:          TCP latency using localhost: 16.5608 microseconds
  sched-devel:  TCP latency using localhost: 13.5528 microseconds [22.1% faster]

lat_pipe quad result:

  BFS:          Pipe latency: 4.6978 microseconds
  sched-devel:  Pipe latency: 2.6860 microseconds [74.8% faster]

  as a comparison, the 8 core lat_pipe result was:

  BFS:          Pipe latency: 4.9703 microseconds
  sched-devel:  Pipe latency: 2.6137 microseconds [90.1% faster]

On the desktop interactivity front, i also still saw that bad 
starvation artifact with BFS with multiple copies of CPU-bound 
pipe-test-1m.c running in parallel:

   http://redhat.com/~mingo/cfs-scheduler/tools/pipe-test-1m.c

Start up a few copies of them like this:

  for ((i=0;i<32;i++)); do ./pipe-test-1m & done

and the quad eventually came to a halt here - until the tasks 
finished running.

I also tested a few key data points on dual core and it shows 
similar trends as well (as expected from the 8 and 4 core results).

But ... i'd really encourage everyone to test these things yourself 
as well and not take anyone's word on this as granted. The more 
people provide numbers, the better. The latest BFS patch can be 
found at:

  http://ck.kolivas.org/patches/bfs/

The mainline sched-devel tree can be found at:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo

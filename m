Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbZFWNZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbZFWNZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZFWNZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:25:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41732 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbZFWNZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:25:13 -0400
Date: Tue, 23 Jun 2009 15:25:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
Message-ID: <20090623132506.GA32002@elte.hu>
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623131450.GA31519@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > I guess there are still a lot of things on the TODOlist but I'd 
> > like to understand a bit more where things are going. Sorry I 
> > didn't read all the archives about this, there are way too many 
> > of them recently :)
> 
> Yeah, there's indeed still a lot on the TODO list :-)
> 
> CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE is a Barcelona hardware event, 
> so if you know that it maps to raw ID 0x100000e0 then you can 
> always extend the events that 'perf' knows about via raw events:
> 
>  $ perf stat -e cycles -e instructions -e r1000ffe0 ./hackbench 10

Note, beyond using raw events, if you are interested in profiling 
out 'locality badness' of your app, you are probably quite well 
served with the default metrics on Barcelona as well:

 $ perf stat ~/hackbench  10
 Time: 0.205

  Performance counter stats for '/home/mingo/hackbench 10':

    2187.328436  task-clock-msecs     #      3.315 CPUs 
          54554  context-switches     #      0.025 M/sec
           1160  CPU-migrations       #      0.001 M/sec
          17755  page-faults          #      0.008 M/sec
     4995437535  cycles               #   2283.808 M/sec
     2150881875  instructions         #      0.431 IPC  
      644099534  cache-references     #    294.469 M/sec
        8516562  cache-misses         #      3.894 M/sec

    0.659895237  seconds time elapsed.

The cache-misses event is sufficiently well-represented to be 
meaningful to profile based on it. Raw DRAM access stats can be 
useful too - but they are generally layered much later and your app 
can hurt already flip-flopping its working set, without hitting too 
hard on the DRAM channels.

So perhaps 'cache-misses' is a good first-level approximation metric 
to measure and profile along. You can get a good 
(last-level-)cache-misses profile using the auto-freq counters:

  perf record -e cache-misses -F 10000 ./your-app

The '-F 10000' tells the kernel to do 10 KHz sampling of your-app, 
regardless of how frequent cache-misses are. The tools (perf report) 
will take the weight of events into account, so it's all 
well-normalized between the functions.

So you dont need to specify the 'sampling interval' by hand to get a 
sufficient number of samples, you just specify a sampling frequency 
- and the perfcounters subsystem takes care of the rest.

Also, your system wont over-sample nor under-sample if your workload 
idles around occasionally.

	Ingo

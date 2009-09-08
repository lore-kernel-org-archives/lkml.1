Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZIHIEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZIHIEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZIHIEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:04:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47483 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbZIHIEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:04:37 -0400
Date: Tue, 8 Sep 2009 10:04:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Pietikainen <pp@ee.oulu.fi>
Cc: Michael Buesch <mb@bu3sch.de>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Felix Fietkau <nbd@openwrt.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090908080427.GA7070@elte.hu>
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu> <200909072051.13748.mb@bu3sch.de> <20090907205701.GA8590@elte.hu> <20090907232415.GA17182@ee.oulu.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907232415.GA17182@ee.oulu.fi>
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


* Pekka Pietikainen <pp@ee.oulu.fi> wrote:

> On Mon, Sep 07, 2009 at 10:57:01PM +0200, Ingo Molnar wrote:
> > > > Could you profile it please? Also, what's the context-switch rate?
> > > 
> > > As far as I can tell, the broadcom mips architecture does not have 
> > > profiling support. It does only have some proprietary profiling 
> > > registers that nobody wrote kernel support for, yet.
> > Well, what does 'vmstat 1' show - how many context switches are 
> > there per second on the iperf server? In theory if it's a truly 
> > saturated box, there shouldnt be many - just a single iperf task 
>
> Yay, finally something that's measurable in this thread \o/

My initial posting in this thread contains 6 separate types of 
measurements, rather extensive ones. Out of those, 4 measurements 
were latency oriented, two were throughput oriented. Plenty of data, 
plenty of results, and very good reproducability.

> Gigabit Ethernet iperf on an Atom or so might be something that 
> shows similar effects yet is debuggable. Anyone feel like taking a 
> shot?

I tried iperf on x86 and simulated saturation and no, there's no BFS 
versus mainline performance difference that i can measure - simply 
because a saturated iperf server does not schedule much - it's busy 
handling all that networking workload.

I did notice that iperf is somewhat noisy: it can easily have weird 
outliers regardless of which scheduler is used. That could be an 
effect of queueing/timing: depending on precisely what order packets 
arrive and they get queued by the networking stack, does get a 
cache-effective pathway of packets get opened - while with slightly 
different timings, that pathway closes and we get much worse 
queueing performance. I saw noise on the order of magnitude of 10%, 
so iperf has to be measured carefully before drawing conclusions.

> That beast doing iperf probably ends up making it go quite close 
> to it's limits (IO, mem bw, cpu). IIRC the routing/bridging 
> performance is something like 40Mbps (depends a lot on the model, 
> corresponds pretty well with the Mhz of the beast).
> 
> Maybe not totally unlike what make -j16 does to a 1-4 core box?

No, a single iperf session is very different from kbuild make -j16. 

Firstly, iperf server is just a single long-lived task - so we 
context-switch between that and the idle thread , [and perhaps a 
kernel thread such as ksoftirqd]. The scheduler essentially has no 
leeway what task to schedule and for how long: if there's work going 
on the iperf server task will run - if there's none, the idle task 
runs. [modulo ksoftirqd - depending on the driver model and 
dependent on precise timings.]

kbuild -j16 on the other hand is a complex hierarchy and mixture of 
thousands of short-lived and long-lived tasks. The scheduler has a 
lot of leeway to decide what to schedule and for how long.

>From a scheduler perspective the two workloads could not be any more 
different. Kbuild does test scheduler decisions in non-trivial ways 
- iperf server does not really.

	Ingo

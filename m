Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZIHKM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZIHKM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 06:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZIHKM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 06:12:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52507 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062AbZIHKM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:12:27 -0400
Date: Tue, 8 Sep 2009 12:12:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: Pekka Pietikainen <pp@ee.oulu.fi>, Michael Buesch <mb@bu3sch.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090908101221.GA21533@elte.hu>
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu> <200909072051.13748.mb@bu3sch.de> <20090907205701.GA8590@elte.hu> <20090907232415.GA17182@ee.oulu.fi> <20090908080427.GA7070@elte.hu> <4AA6123F.7020704@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA6123F.7020704@arcor.de>
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


* Nikos Chantziaras <realnc@arcor.de> wrote:

> On 09/08/2009 11:04 AM, Ingo Molnar wrote:
>>
>> * Pekka Pietikainen<pp@ee.oulu.fi>  wrote:
>>
>>> On Mon, Sep 07, 2009 at 10:57:01PM +0200, Ingo Molnar wrote:
>>>>>> Could you profile it please? Also, what's the context-switch rate?
>>>>>
>>>>> As far as I can tell, the broadcom mips architecture does not have
>>>>> profiling support. It does only have some proprietary profiling
>>>>> registers that nobody wrote kernel support for, yet.
>>>> Well, what does 'vmstat 1' show - how many context switches are
>>>> there per second on the iperf server? In theory if it's a truly
>>>> saturated box, there shouldnt be many - just a single iperf task
>>>
>>> Yay, finally something that's measurable in this thread \o/
>>
>> My initial posting in this thread contains 6 separate types of 
>> measurements, rather extensive ones. Out of those, 4 measurements 
>> were latency oriented, two were throughput oriented. Plenty of 
>> data, plenty of results, and very good reproducability.
>
> None of which involve latency-prone GUI applications running on 
> cheap commodity hardware though. [...]

The lat_tcp, lat_pipe and pipe-test numbers are all benchmarks that 
characterise such workloads - they show the latency of context 
switches.

I also tested where Con posted numbers that BFS has an edge over 
mainline: kbuild performance. Should i not have done that?

Also note the interbench latency measurements that Con posted:

   http://ck.kolivas.org/patches/bfs/interbench-bfs-cfs.txt

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load    Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None      0.004 +/- 0.00436    0.006             100            100
Video     0.008 +/- 0.00879    0.015             100            100
X         0.006 +/- 0.0067     0.014             100            100
Burn      0.005 +/- 0.00563    0.009             100            100
Write     0.005 +/- 0.00887     0.16             100            100
Read      0.006 +/- 0.00696    0.018             100            100
Compile   0.007 +/- 0.00751    0.019             100            100

Versus the mainline scheduler:

--- Benchmarking simulated cpu of Audio in the presence of simulated ---
Load    Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
None      0.005 +/- 0.00562    0.007             100            100
Video     0.003 +/- 0.00333    0.009             100            100
X         0.003 +/- 0.00409     0.01             100            100
Burn      0.004 +/- 0.00415    0.006             100            100
Write     0.005 +/- 0.00592    0.021             100            100
Read      0.004 +/- 0.00463    0.009             100            100
Compile   0.003 +/- 0.00426    0.014             100            100

look at those standard deviation numbers, their spread is way too 
high, often 50% or more - very hard to compare such noisy data. 

Furthermore, they happen to show the 2.6.30 mainline scheduler 
outperforming BFS in almost every interactivity metric.

Check it for yourself and compare the entries. I havent made those 
measurements, Con did.

For example 'Compile' latencies:

--- Benchmarking simulated cpu of Audio in the presence of simulated Load
                  Latency +/- SD (ms)  Max Latency   % Desired CPU  % Deadlines Met
 v2.6.30: Compile   0.003 +/- 0.00426    0.014             100            100
     BFS: Compile   0.007 +/- 0.00751    0.019             100            100

but ... with a near 100% standard deviation that's pretty hard to 
judge. The Max Latency went from 14 usecs under v2.6.30 to 19 usecs 
on BFS.

> [...]  I listed examples where mainline seems to behave 
> sub-optimal and ways to reproduce them but this doesn't seem to be 
> an area of interest.

It is an area of interest of course. That's how the interactivity 
results above became possible.

	Ingo

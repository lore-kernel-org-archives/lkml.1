Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZF2SOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZF2SOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbZF2SOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:14:31 -0400
Received: from smtpauth01.csee.onr.siteprotect.com ([64.26.60.145]:40690 "EHLO
	smtpauth01.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581AbZF2SOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:14:30 -0400
Date: Mon, 29 Jun 2009 14:25:46 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [numbers] perfmon/pfmon overhead of 17%-94%
In-Reply-To: <20090627064404.GA19368@elte.hu>
Message-ID: <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
 <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy>
 <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy> <20090627060432.GB16200@elte.hu>
 <20090627064404.GA19368@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

> Ingo Molnar <mingo@elte.hu> wrote:
>> Vince Weaver <vince@deater.net> wrote:

> That is in the 0.0001% measurement overhead range (per 'perf stat' 
> invocation) for any realistic app that does something worth 
> measuring

I'm just curious about this "app worth measuring" idea.

Do you intend for performance counters to simply be "oprofile done right"
or do you intend it to be a generic way of exposing performance counters 
to userspace?

For the research my co-workers and I are currently working on the former 
is uninteresting.  If we wanted oprofile, we'd use it.

What matters for us is getting very exact counts of counters on programs 
that are being run as deterministically as possible.  This includes 
very small programs, and counts like retired_instructions, load/store 
ratios, uop_counts, etc.

This may be uninteresting to you, but it is important to us.  Hence my 
interest in the capabilities of the infrastructure finally getting merged 
into the kernel.

> Besides, you compare perfcounters to perfmon

what else shoud I be comparing it to?

> (which you seem to be a contributor of)

is that not allowed?

> workloads? [ In fact in one of the scheduler-tests perfmon has a 
> whopping measurement overhead of _nine billion_ cycles, it increased 
> total runtime of the workload from 3.3 seconds to 6.6 seconds. (!) ]

I'm sure the perfmon2 people would welcome any patches you have to fix 
this problem.

as I said, I am looking for aggregate counts for deterministic programs.
Compared to the ovreheads of 50x for DBI-based tools like Valgrind, or 
1000x for "cycle-accurate" simulations, then even overhead of 2x really 
isn't that bad.

Counting cycles or time is always a dangerous thing when performance 
counters are involved.  Things as trivial as compiler, object link-order,
length of the executable name, number of environment variables, number of 
ELF auxilliary vectors, etc, can all vastly change what results you get. 
I'd reccomend the following paper for more details:

   "Producing wrong data without doing anything obviously wrong"
   by Mytkowicz et al.
   http://www-plan.cs.colorado.edu/klipto/mytkowicz-asplos09.pdf


> If the 5 thousand cycles measurement overhead _still_ matters to you 
> under such circumstances then by all means please submit the patches 
> to improve it. Despite your claims this is totally fixable with the 
> current perfcounters design, Peter outlined the steps of how to 
> solve it, you can utilize ptrace if you want to.

Is it really "totally" fixible?  I don't just mean getting the overhead 
from ~3000 down to ~100, I mean down to zero.

> Here are the more detailed perfmon/pfmon measurement overhead
> numbers.
>
> ...
>
> I.e. this workload runs 17% slower under pfmon, the measurement
> overhead is about 1.45 billion cycles.
>
> ..
>
> That's an about 94% measurement overhead, or about 9.2 _billion_
> cycles overhead on this test-system.

I'm more interested in very CPU-intensive benchmarks.  I ran some 
experiments with gcc and equake from the spec2k benchmark suite.

This is on a 32-bit AMD Athlon(tm) XP 2000+ machine


gcc.200 (spec2k)

+ 2.6.30-03984-g45e3e19, configured with perf counters disabled

    108.44s +/- 0.7

+ 2.6.30-03984-g45e3e19, perf stat -e 0:1:u --

    109.17s +/- 0.7

*** For a slowdown of about 0.6%

+ 2.6.29.5 (unpatched)

   115.31s +/- 0.5

+ 2.6.29.5 with perfmon2 patches applied,  pfmon -e retired_instructions,cpu_clk_unhalted

   115.62 +/- 0.5

** For a slowdown of about 0.2%

So in this case, perfmon2 had less overhead, though it's so small overhead 
as to be lost in the noise.  Why the 2.6.30-git kernel 
seems to be much faster on this hardware, I don't know.


equake (spec2k)

+ 2.6.30-03984-g45e3e19, configured with perf counters disabled

    392.77s +/- 1.5

+ 2.6.30-03984-g45e3e19, perf stat -e 0:1:u --

    393.45s +/- 0.7

*** For a slowdown of about 0.17%

+ 2.6.29.5 (unpatched)

   429.25s +/- 1.7

+ 2.6.29.5 with perfmon2 patches applied,  pfmon -e retired_instructions,cpu_clk_unhalted

   428.91 +/- 0.8

** For a _speedup_ of about 0.08%

So again the difference in overheads is in the noise.  Again I am not sure 
why 2.6.30-git is so much faster on this hardware.

As for counter results, in this case retired instructions:

gcc.200
   perf:  72,618,643,132 +/- 8million
   pfmon: 72,618,519,792 +/- 5million

equake
   perf:  144,952,319,472 +/- 8000
   pfmon: 144,952,327,906 +/-  500

So in the equake case you can easily see that the few thousand instruction 
overhead from perf can show up even on long-running programs.

In any case, the point I am trying to make is that perf counters are used 
by a wide variety of people in a wide variety of ways, with lots of 
different performance/accuracy tradeoffs.  Don't limit the API just 
because you can't envision a use for certain features.

Vince



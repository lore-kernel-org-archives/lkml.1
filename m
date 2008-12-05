Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbYLEGb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbYLEGb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 01:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYLEGbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 01:31:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34208 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbYLEGbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 01:31:49 -0500
Date: Fri, 5 Dec 2008 07:31:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081205063131.GB12785@elte.hu>
References: <20081204225345.654705757@linutronix.de> <18744.29747.728320.652642@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18744.29747.728320.652642@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Thomas Gleixner writes:
> 
> > We'd like to announce a brand new implementation of performance counter
> > support for Linux. It is a very simple and extensible design that has the
> > potential to implement the full range of features we would expect from such
> > a subsystem.
> 
> Looks like the sort of thing I was thinking about a year or so ago when 
> I was trying to come up with a simpler API than perfmon2. However, it 
> turned out that my design, and I believe yours too, can't do some 
> things that users really want to do with performance counters.
> 
> One thing that this sort of thing can't do is to get values from 
> multiple counters that correlate with each other.  For instance, we 
> would often want to count, say, L2 cache misses and instructions 
> completed at the same time, and be able to read both counters at very 
> close to the same time, so that we can measure average L2 cache misses 
> per instruction completed, which is useful.

This can be done in a very natural way with our abstraction, and the 
"hello.c" example happens to do exactly that:

  aldebaran:~/perf-counter-test> ./hello
  doing perf_counter_open() call:
  counter[0]... fd: 3.
  counter[1]... fd: 4.
  counter[0] delta: 10866 cycles
  counter[1] delta: 414 cycles
  counter[0] delta: 23640 cycles
  counter[1] delta: 3673 cycles
  counter[0] delta: 28225 cycles
  counter[1] delta: 3695 cycles

This counts cycles executed and instructions executed, and reads the two 
counters out at the same time.

I just modified it to measure the exact example you mentioned above - L2 
cache misses and instructions completed, sampled once every second:

  titan:~/perf-counter-test> ./hello
  doing perf_counter_open() call:

  counter[0] delta: 1 cachemisses
  counter[1] delta: 497 instructions

  counter[0] delta: 14 cachemisses
  counter[1] delta: 4303 instructions

  counter[0] delta: 6 cachemisses
  counter[1] delta: 3666 instructions

  counter[0] delta: 2 cachemisses
  counter[1] delta: 3641 instructions

  counter[0] delta: 1 cachemisses
  counter[1] delta: 3641 instructions

It's a matter of:

        fd1 = perf_counter_open(PERF_COUNT_CACHE_MISSES, 0, 0, 0, -1);
        fd2 = perf_counter_open(PERF_COUNT_INSTRUCTIONS, 0, 0, 0, -1);

So it's very much possible. (If i've missed something about your example 
then please let me know.)

> Another problem is that this abstraction provides no way to deal with 
> interrelationships between counters.  For example, on PowerPC it is 
> common to have a facility where one counter overflowing can cause all 
> the other counters to freeze.  I don't see this abstraction providing 
> any way to handle that.

We could add that facility if it makes sense - there's no reason why 
there couldnt be event interaction between counters - we just went for 
the most common event variants in v1.

Btw., i'm curious, why would we want to do that? It skews the results if 
the task continues executing and counters stop. To get the highest 
quality profiling output the counters should follow the true state of the 
task that is profiled - and events should be passed to the monitoring 
task asynchronously. The _events_ can contain precise coupled information 
- but the counters should continue.

What i'd do is what hello.c does: if you want to read out multiple 
counters at once, you can read them out at once.

(Again, please explain in more detail if i have missed something about 
your observation.)

	Ingo

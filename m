Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYLPT5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYLPT5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYLPT47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:56:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57869 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbYLPT46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:56:58 -0500
Message-ID: <494807D2.3060808@redhat.com>
Date: Tue, 16 Dec 2008 14:56:02 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Robert Richter <robert.richter@amd.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Stephane Eranian <eranian@googlemail.com>,
       Paul Mackerras <paulus@samba.org>, Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       perfctr-devel@lists.sourceforge.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Perfctr-devel] [patch] Performance Counters for Linux, v4
References: <20081214212829.GA9435@elte.hu>
In-Reply-To: <20081214212829.GA9435@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> We are pleased to announce the v4 release of our performance counters 
> subsystem implementation. The kernel changes can be picked up from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters/core
> 
>   (also in the master branch. There's also a kernel patch attached 
>    below.)


PAPI also has the concept of event presets to hide some of the event
selection details. The following URL lists the presets and which
processors they are supported on:

http://icl.cs.utk.edu/projects/papi/presets.html

Looking through the PAPI preset events can see lots of variation due
to the difference in what precisely the performance monitoring
hardware support within the processor.  The following events are
defined in include/linux/perf_counter.h. It would be helpful to state
what is meant by of the following events:

PERF_COUNT_CYCLES
PERF_COUNT_INSTRUCTIONS
PERF_COUNT_CACHE_REFERENCES
PERF_COUNT_CACHE_MISSES
PERF_COUNT_BRANCH_INSTRUCTIONS
PERF_COUNT_BRANCH_MISSES

PERF_COUNT_CYCLES and PERF_COUNT_INSTRUCTIONS

Is this the cpu clock rate to compute clocks per instruction (CPI)? On
some processors there are several possible sources of "cycles":

      Reference clock frequency (fixed frequency, e.g. always 2.2GHz)
      Cycles of processor subject to frequency changes and halts

Is PERF_COUNT_INSTRUCTIONS the instructions actually retired by the
processor and would be used with PERF_COUNT_CYCLES to estimate CPI? In
the case of a SMT (symetric multi-threaded) processor these are
going to be kept on a per-virtual-CPU basis?


PERF_COUNT_CACHE_REFERENCES and PERF_COUNT_CACHE_MISSES

PERF_COUNT_CACHE_REFERENCES and PERF_COUNT_CACHE_MISSES are not single
monolitic events on many processors. There are multiple cache
levels. The L1 cache most processors have separate instruction and
data caches and require multiple counters to implement. Would these
refer to the last level of cache before memory and just be used to
compute the hit/miss rate for that last level? Some processors in the
same family have L2 and some processors have L3 cache. The setup code
would need to distinguish between these processor variants.

What memory references and misses are included and excluded in cache operation 
counts? TLB accesses? Cache eviction/snooping operations?


PERF_COUNT_BRANCH_INSTRUCTIONS and PERF_COUNT_BRANCH_MISSES

Assume the PERF_COUNT_BRANCH_INSTRUCTIONS and PERF_COUNT_BRANCH_MISSES
refer only to retired instructions are are used to compute branch
misprediction ratio. Speculative instructions don't count for these numbers.



Any thought to including events that are not in the Intel architected events 
such as ITLB/DTLB accesses and misses?

-Will

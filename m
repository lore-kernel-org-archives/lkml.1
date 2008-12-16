Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbYLPTsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbYLPTsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYLPTrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:47:53 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33912 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbYLPTrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:47:52 -0500
Message-ID: <494805E4.2040008@linux.vnet.ibm.com>
Date: Tue, 16 Dec 2008 11:47:48 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Vince Weaver <vince@deater.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
References: <20081214212829.GA9435@elte.hu> <Pine.LNX.4.64.0812161232170.6249@pianoman.cluster.toy>
In-Reply-To: <Pine.LNX.4.64.0812161232170.6249@pianoman.cluster.toy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince Weaver wrote:
> 
> I'm trying to evaluate this new proposal for the kind of workloads I use 
> performance counters for, and even the simplest tests don't work.
> 
> I'm trying to do a simple aggragate count for some benchmarks here using 
> timec and I'm getting poor results.
> 
> Are any of the problems I'm reporting going to be fixed?
> 
> In any case, I was testing aggregate counts on a longer running 
> benchmark, this time equake from the spec2k benchmark suite, still on 
> the q6600.
> 
> If I only count retired instructions, I get consistent results:
> 
>   timec -e 1
> 
>       119175255369  instructions         (events)
>       119175255561  instructions         (events)
>       119175255383  instructions         (events)
> 
> 
> however the minute I add another count, say cycles so I can calculate 
> CPI/IPC the results for instructions are suddenly off by 33%.
> 
> Needless to say, perfmon can handle reading both cycles and instructions 
> at the same time.
> 
> 
>   timec -e 0, -e 1
>        91758816320  cycles               (events)
>        79428247907  instructions         (events)
> 
>        91849140396  cycles               (events)
>        79449560742  instructions         (events)
> 
> 
> It gets worse when trying to look at cache statistics:
> 
>    timec -e 1 -e 2 -e 3
> 
>        59611457943  instructions         (events)
>         1872499771  cache references     (events)
>           97471971  cache misses         (events)
> 
>        59601907232  instructions         (events)
>         1871766376  cache references     (events)
>           97435199  cache misses         (events)
> 
> and so on
> 
>    timec -e1 -e2 -e3 -e4
> 
> 
>        47671703285  instructions         (events)
>         1498246999  cache references     (events)
>           77838085  cache misses         (events)
>         3394839360  branches             (events)
> 
>        47666131604  instructions         (events)
>         1497069685  cache references     (events)
>           78065325  cache misses         (events)
>         3393244879  branches             (events)
> 
> 
> 
> So apparently this performance counter infrastructure will always be 
> useless for trying to get plain aggregate counts?  It's the simplest 
> case to get right, so it makes me wonder about the design of the rest of 
> the infrastructure.
> 
> Vince

Your test case demonstrates that scaling is missing from the current 
version of Performance Counters for Linux.

When each set of events is scheduled onto a set of hardware event 
counters, in order to scale the results properly, a cycles counter needs 
to be included in each set as well.

When the counts are read up, the counts from each set need to be scaled 
by a factor of
(total cycles)/(cycles in that set)

This is something that can be handled by perfmon3 (full) because set 
multiplexing is explicitly programmed, not transparent as it is in 
Ingo's current code.  In perfmon3, the set switching can be determined 
by events counter overflow, as well as time.

In common with both perfmon3 and Ingo's solution is that as more and 
more events are scheduled onto the same set of hardware registers, the 
accuracy drops and has to be compensated with longer run times.

Another source of error is that if the sets are rotated across the 
hardware at a fixed periodic rate, if there's any correlation between 
that rate and what's going on in the program being analyzed, the results 
will be dubious.  Ideally, you'd want to have some sort of pseudo-random 
set switching rate to mitigate this sort of problem.

If Ingo could make some sort of provision for including a cycles count 
in every set, and then transparently performing the scaling, that would 
make it easier to use.  As it stands now, I don't think there's any way 
to recover the needed scaling information, because you cannot tell what 
events are in what sets and how many cycles are associated with each set.

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com


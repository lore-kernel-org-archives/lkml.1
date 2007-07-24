Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbXGXIUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbXGXIUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759020AbXGXITp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:19:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47182 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829AbXGXITm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:19:42 -0400
Date: Tue, 24 Jul 2007 10:19:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: System hangs on running kernbench
Message-ID: <20070724081912.GA28019@elte.hu>
References: <20070718075648.GA4235@linux.vnet.ibm.com> <20070724071320.GA12169@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724071320.GA12169@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> Basically, "make -s -j" workload hanged the machine, leading to lot of 
> OOM killings. This was on a 8-cpu machine with no swap space 
> configured and 4GB RAM. The same workload works "fine" (runs to 
> completion) on 2.6.22.

while i agree that the 32msec was too low, i think the problem is that 
"make -s -j" is a workload that has no guarantee of "success" on that 
system. The box does not have enough RAM to service it and does not have 
enough swap to survive it. In make -j, jobs are started without any 
throttling whatsoever. _Any_ control mechanism within the kernel can act 
as an "accidental throttle": for example IO could artificially slow it 
down to reduce job rate and keep RAM usage below the critical level. Or 
a kernel bug could cause tasks to be delayed and thus let the make -j 
"succeed". Or some bad kernel inefficiency in sys_fork() could have this 
effect too. It is very important that we dont look at every random 
number that a system can produce as a "benchmark", we really have to 
consider what happens behind it.

> I played with the scheduler tunables a bit and found that the problem 
> goes away if I set sched_granularity_ns to 100ms (default value 32ms).

yep - 32msecs was too low, please try -rc1 too: i've increased the 
granularity limit so it should be larger than 32ms. Reduce CONFIG_HZ as 
well if you are on a more server-type system.

> So my theory is this: 32ms preemption granularity is too low value for 
> any compile thread to make "usefull" progress. As a result of this 
> rapid context switch, job retiral rate slows down compared to job 
> arrival rate. This builds up job pressure on the system very quickly 
> (than may have happened with 100ms default granularity_ns or 2.6.22 
> kernel), leading to OOM killings (and hang).

By increasing the granularity the timings change - one can imagine 
workloads where _reducing_ the granularity would result in an effective 
throttling of the workload. I'm sure a workload could be constructed on 
the old scheduler too where its 100 msecs isnt enough either, only 
200msecs would help. That thinking never ends - you cannot tune 
non-throttled workloads. We've got to be really careful about this.

	Ingo

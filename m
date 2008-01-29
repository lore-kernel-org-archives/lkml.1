Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYA2FeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYA2FeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYA2FeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:34:04 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42366 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYA2FeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:34:02 -0500
Date: Tue, 29 Jan 2008 11:17:42 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Guillaume Chazarain" <guichaz@yahoo.fr>
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com
Subject: Re: High wake up latencies with FAIR_USER_SCHED
Message-ID: <20080129054742.GA7902@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <3d8471ca0801271201o5a41955cg552ef06a2f821285@mail.gmail.com> <20080128023129.GD1044@linux.vnet.ibm.com> <3d8471ca0801280857m2ea8518ds2ad8d5346f756a0e@mail.gmail.com> <3d8471ca0801281213l5ec62984i763afb22216cb423@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca0801281213l5ec62984i763afb22216cb423@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 09:13:53PM +0100, Guillaume Chazarain wrote:
> Unfortunately it seems to not be completely fixed, with this script:

The maximum scheduling latency of a task with group scheduler is:

	Lmax = latency to schedule group entity at level0 + 
	       latency to schedule group entity at level1 +
	       ...
	       latency to schedule task entity at last level

More the hierarchical levels, more the latency looks like. This is particularly 
so because vruntime (and not wall-clock time) is used as the basis of preemption
of entities.  The latency at each level also depends on number of entities at 
that level and sysctl_sched_latency/sched_nr_latency setting.

In this case, we only have two levels - userid + task. So the max scheduling 
latency is:

      Lmax = latency to schedule uid1 group entity (L0) +
	     latency to schedule the sleeper task within uid1 group (L1)

In the first script that you had, uid1 had only one sleeper task, while uid2 has
two cpu-hogs. This means L1 is always zero for the sleeper task. L0 is also 
substantially reduced with the patch I sent (giving sleep credit for group 
level entities). Thus we were able to get low scheduling latencies in the case 
of first script.

The second script you have sent is generating two tasks (sleeper + hog) under 
uid 1 and one cpuhog task under uid 2. Consequently the group-entity 
corresponding to uid 1 is always active and hence there is no question of giving
credit to it for sleeping.

As a result, we should expect worst-case latencies of upto [2 * 10 = 20ms] in 
this case. The results you have fall within this range.

In case of !FAIR_USER_SCHED, the sleeper task always gets sleep-credits
and hence its latency is drastically reduced.

IMHO this is expected results and if someone really needs to cut down
this latency, they can reduce sysctl_sched_latency (which will be bad
from perf standpoint, as we will cause more cache thrashing with that).


> #!/usr/bin/python
> 
> import os
> import time
> 
> SLEEP_TIME = 0.1
> SAMPLES = 5
> PRINT_DELAY = 0.5
> 
> def print_wakeup_latency():
>     times = []
>     last_print = 0
>     while True:
>         start = time.time()
>         time.sleep(SLEEP_TIME)
>         end = time.time()
>         times.insert(0, end - start - SLEEP_TIME)
>         del times[SAMPLES:]
>         if end > last_print + PRINT_DELAY:
>             copy = times[:]
>             copy.sort()
>             print '%f ms' % (copy[len(copy)/2] * 1000)
>             last_print = end
> 
> if os.fork() == 0:
>     if os.fork() == 0:
>         os.setuid(1)
>         while True:
>             pass
>     else:
>         os.setuid(2)
>         while True:
>             pass
> else:
>     os.setuid(1)
>     print_wakeup_latency()
> 
> I get seemingly unpredictable latencies (with or without the patch applied):
> 
> # ./sched.py
> 14.810944 ms
> 19.829893 ms
> 1.968050 ms
> 8.021021 ms
> -0.017977 ms
> 4.926109 ms
> 11.958027 ms
> 5.995893 ms
> 1.992130 ms
> 0.007057 ms
> 0.217819 ms
> -0.004864 ms
> 5.907202 ms
> 6.547832 ms
> -0.012970 ms
> 0.209951 ms
> -0.002003 ms
> 4.989052 ms
> 
> Without FAIR_USER_SCHED, latencies are consistently in the noise.
> Also, I forgot to mention that I'm on a single CPU.
> 
> Thanks for the help.
> 
> -- 
> Guillaume

-- 
Regards,
vatsa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbYDBIkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbYDBIkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 04:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYDBIkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 04:40:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53642 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYDBIkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 04:40:06 -0400
Message-ID: <47F34625.6000600@jp.fujitsu.com>
Date: Wed, 02 Apr 2008 17:39:01 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] Customize sched domain via cpuset
References: <47F21BE3.5030705@jp.fujitsu.com> <20080401065534.a6267b96.pj@sgi.com>
In-Reply-To: <20080401065534.a6267b96.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Interesting ...

Thank you for saying that ;-)

> So, we have two flags here.  One flag "sched_wake_idle_far" that will
> cause the current task to search farther for an idle CPU when it wakes
> up another task that needs a CPU on which to run, and the other flag
> "sched_balance_newidle_far" that will cause a soon-to-idle CPU to search
> farther for a task it might pull over and run, instead of going idle.
> 
> I am tempted to ask if we should not elaborate this in one dimension,
> and simplify it in another dimension.
> 
> First the simplification side: do we need both flags?  Yes, they are
> two distinct cases in the code, but perhaps practical uses will always
> end up setting both flags the same way.  If that's the case, then we
> are just burdening the user of these flags with understanding a detail
> that didn't matter to them: did a waking task or an idle CPU provoke
> the search?  Do you have or know of a situation where you actually
> desire to enable one flag while disabling the other?

Yes, we need both flags.

At least in case of hackbench (results are attached bottom),
I couldn't find any positive effect with enabling "sched_wake_idle_far",
but "sched_balance_newidle_far" shows significant gains.

It doesn't mean "sched_wake_idle_far" is useless everywhere.
As Peter pointed, when we have a lot of very short running tasks,
"sched_wake_idle_far" accelerates task propagation and its throughput.
There are definitely such situations (and in fact it's where I'm now).

Put simply, if the system tend to be idle, then "push to idle" strategy
works well.  OTOH if the system tend to be busy, then "pull by idle"
strategy works well.  Else, both strategy will work but besides of all
there is a question: how much searching cost can you pay?

So, it is case by case, depend on the situation.

> For the elaboration side: your proposal has just two-level's of
> distance, near and far.  Perhaps, as architectures become more
> elaborate and hierarchies deeper, we would want N-level's of distance,
> and the ability to request such load balancing for all levels "n"
> for our choice of "n" <= N.
> 
> If we did both the above, then we might have a single per-cpuset file
> that took an integer value ... this "n".  If (n == 0), that might mean
> no such balancing at all.  If (n == 1), that might mean just the
> nearest balancing, for example, to the hyperthread within the same core,
> on some current Intel architectures.  If (n == 2), then that might mean,
> on the same architectures, that balancing could occur across cores
> within the same package.  If (n == 3) then that might mean, again on
> that architecture, that balancing could occur across packages on the
> same node board.  As architectures evolve over time, the exact details
> of what each value of "n" mean would evolve, but always higher "n"
> would enable balancing across a wider portion of the system.
> 
> Please understand I am just brain storming here.  I don't know that
> the alternatives I considered above are preferrable or not to what
> your patch presents.

Now we already have such levels in sched domain, so if "n" is given,
I can choice:
   0: (none)
   1: cpu_domain - balance to hyperthreads in a core
   2: core_domain - balance to cores in a package
   3: phys_domain - balance to packages in a node
( 4: node_domain - balance to nodes in a chunk of nodes )
( 5: allnodes_domain - global balance )

It looks easy... but how do you handle if cpusets are overlapping?

Thanks,
H.Seto

-----
(@ CPUx8 ((Dual-Core Itanium2 x 2 sockets) x 2 nodes), 8GB mem)

[root@HACKBENCH]# echo 0 > /dev/cpuset/sched_balance_newidle_far
[root@HACKBENCH]# echo 0 > /dev/cpuset/sched_wake_idle_far
[root@HACKBENCH]# for i in `seq 50 50 250` ; do ./hackbench $i ; done
Time: 1.956
Time: 4.008
Time: 5.918
Time: 8.269
Time: 10.216
[root@HACKBENCH]# for i in `seq 50 50 250` ; do ./hackbench $i ; done
Time: 1.918
Time: 3.964
Time: 5.732
Time: 8.013
Time: 10.028
[root@HACKBENCH]# for i in `seq 50 50 250` ; do ./hackbench $i ; done
Time: 1.925
Time: 3.824
Time: 5.893
Time: 7.975
Time: 10.373
[root@HACKBENCH]# echo 0 > /dev/cpuset/sched_balance_newidle_far
[root@HACKBENCH]# echo 1 > /dev/cpuset/sched_wake_idle_far
[root@HACKBENCH]# for i in `seq 50 50 250` ; do ./hackbench $i ; done
Time: 2.153
Time: 3.749
Time: 5.846
Time: 8.088
Time: 9.996
[root@HACKBENCH]# for i in `seq 50 50 250` ; do ./hackbench $i ; done
Time: 1.845
Time: 3.932
Time: 6.137
Time: 8.062
Time: 10.282
[root@HACKBENCH]# for i in `seq 50 50 250` ; do ./hackbench $i ; done
Time: 1.963
Time: 4.040
Time: 5.837
Time: 8.017
Time: 9.718
[root@HACKBENCH]# echo 1 > /dev/cpuset/sched_balance_newidle_far
[root@HACKBENCH]# echo 0 > /dev/cpuset/sched_wake_idle_far
[root@HACKBENCH]# for i in `seq 50 50 250` ; do ./hackbench $i ; done
Time: 1.725
Time: 3.412
Time: 5.275
Time: 7.441
Time: 8.974
[root@HACKBENCH]# for i in `seq 50 50 250` ; do ./hackbench $i ; done
Time: 1.674
Time: 3.334
Time: 5.374
Time: 7.204
Time: 8.903
[root@HACKBENCH]# for i in `seq 50 50 250` ; do ./hackbench $i ; done
Time: 1.689
Time: 3.281
Time: 5.002
Time: 7.245
Time: 9.039
[root@HACKBENCH]# echo 1 > /dev/cpuset/sched_balance_newidle_far
[root@HACKBENCH]# echo 1 > /dev/cpuset/sched_wake_idle_far
[root@HACKBENCH]# for i in `seq 50 50 250` ; do ./hackbench $i ; done
Time: 1.923
Time: 3.697
Time: 5.632
Time: 7.379
Time: 9.223
[root@HACKBENCH]# for i in `seq 50 50 250` ; do ./hackbench $i ; done
Time: 1.809
Time: 3.656
Time: 5.746
Time: 7.386
Time: 9.399
[root@HACKBENCH]# for i in `seq 50 50 250` ; do ./hackbench $i ; done
Time: 1.832
Time: 3.743
Time: 5.580
Time: 7.477
Time: 9.163


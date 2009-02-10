Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZBJOqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZBJOqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZBJOqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:46:42 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:53028 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbZBJOql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:46:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XsC1HrLUwGqKNcOTq7eubMqnPGWqWCr9FlsrGCVPQ1gIvLPTP77RKhDvybyTHtCe2N
         T203Fj4yDKJ2arlrFHW8oetz5LxXTIJaHibijXA0NE7b4ro4iqTJ+XcDEzlTz81YKtte
         GzWLg2ONqpnG+jf26d3XYM1cIlA0OhvHRIV9I=
MIME-Version: 1.0
In-Reply-To: <1234271177.23438.24.camel@twins>
References: <b6a2d2e20902091130ha452a97rcfaa2972bfdbe710@mail.gmail.com>
	 <1234209174.5951.165.camel@laptop>
	 <b6a2d2e20902091204p2391799p160ce13971e9f779@mail.gmail.com>
	 <1234271177.23438.24.camel@twins>
Date: Tue, 10 Feb 2009 14:46:40 +0000
Message-ID: <b6a2d2e20902100646q6c7073cse86b8f5790a120ac@mail.gmail.com>
Subject: Re: cgroup, RT reservation per core(s)?
From: Rolando Martins <rolando.martins@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/10/09, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2009-02-09 at 20:04 +0000, Rolando Martins wrote:
>
>  > I should have elaborated this more:
>  >
>  >                      root
>  >                   ----|----
>  >                   |          |
>  > (0.5 mem) 0         1 (100% rt, 0.5 mem)
>  >                          ---------
>  >                          |    |    |
>  >                          2   3   4  (33% rt for each group, 33% mem
>  > per group(0.165))
>  > Rol
>
>
>
> Right, i think this can be done.
>
>  You would indeed need cpusets and sched-cgroups.
>
>  Split the machine in 2 using cpusets.
>
>    ___R___
>   /       \
>   A         B
>
>  Where R is the root cpuset, and A and B are the siblings.
>  Assign A one half the cpus, and B the other half.
>  Disable load-balancing on R.
>
>  Then using sched cgroups create the hierarchy
>
>   ____1____
>   /    |    \
>  2     3     4
>
>  Where 1 can be the root group if you like.
>
>  Assign 1 a utilization limit of 100%, and 2,3 and 4 a utilization limit
>  of 33% each.
>
>  Then place the tasks that get 100% cputime on your 2 cpus in cpuset A
>  and sched group 1.
>
>  Place your other tasks in B,{2-4} respectively.
>
>  The reason this works is that bandwidth distribution is sched domain
>  wide, and by disabling load-balancing on R, you split the schedule
>  domain.
>
>  I've never actually tried anything like this, let me know if it
>  works ;-)
>
On 2/10/09, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2009-02-09 at 20:04 +0000, Rolando Martins wrote:
>
>  > I should have elaborated this more:
>  >
>  >                      root
>  >                   ----|----
>  >                   |          |
>  > (0.5 mem) 0         1 (100% rt, 0.5 mem)
>  >                          ---------
>  >                          |    |    |
>  >                          2   3   4  (33% rt for each group, 33% mem
>  > per group(0.165))
>  > Rol
>
>
>
> Right, i think this can be done.
>
>  You would indeed need cpusets and sched-cgroups.
>
>  Split the machine in 2 using cpusets.
>
>    ___R___
>   /       \
>   A         B
>
>  Where R is the root cpuset, and A and B are the siblings.
>  Assign A one half the cpus, and B the other half.
>  Disable load-balancing on R.
>
>  Then using sched cgroups create the hierarchy
>
>   ____1____
>   /    |    \
>  2     3     4
>
>  Where 1 can be the root group if you like.
>
>  Assign 1 a utilization limit of 100%, and 2,3 and 4 a utilization limit
>  of 33% each.
>
>  Then place the tasks that get 100% cputime on your 2 cpus in cpuset A
>  and sched group 1.
>
>  Place your other tasks in B,{2-4} respectively.
>
>  The reason this works is that bandwidth distribution is sched domain
>  wide, and by disabling load-balancing on R, you split the schedule
>  domain.
>
>  I've never actually tried anything like this, let me know if it
>  works ;-)
>

Thanks Peter, it works!
I am thinking for different strategies to be used in my rt middleware
project, and I think there is a limitation.
If I wanted to have some RT on the B cpuset, I couldn't because I
assigned A.cpu.rt_runtime_ns = root.cpu.rt_runtime_ns (then subdivided
the A cpuset, with 2,3,4, each one having A.cpu.rt_runtime_ns/3).

This happens because there is a global /proc/sys/kernel/sched_rt_runtime_us and
/proc/sys/kernel/sched_rt_period_us.
What do you think about adding a separate tuple (runtime,period) for
each core/cpu?

In this case:
/proc/sys/kernel/sched_rt_runtime_us_0
/proc/sys/kernel/sched_rt_period_us_0
...
/proc/sys/kernel/sched_rt_runtime_us_n (n, cpu count)
/proc/sys/kernel/sched_rt_period_us_n


Given this, we could the following:

mkdir /dev/cgroup/A
echo 0-1 > /dev/cgroup/A/cpuset.cpus
echo 0 > /dev/cgroup/A/cpuset.mems
echo 1000000 > /dev/cgroup/A/cpu.rt_period_us
echo 1000000 > /dev/cgroup/A/cpu.rt_runtime_us

This would only work if we could allocate
(cpu.rt_runtime_us,cpu.rt_period_us) in both CPU 0 and CPU 1,
otherwise fail.

mkdir /dev/cgroup/B
echo 2-3 > /dev/cgroup/B/cpuset.cpus
echo 0 > /dev/cgroup/B/cpuset.mems
echo 1000000 > /dev/cgroup/B/cpu.rt_period_us
echo 800000 > /dev/cgroup/B/cpu.rt_runtime_us
The same here, failed if we couldn't allocate 0.8 in both CPU 2 and CPU 3.

Does this make sense? ;)

Rol

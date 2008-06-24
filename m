Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbYFXGPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbYFXGPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYFXGOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:14:53 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51527 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYFXGOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:14:52 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5323"; a="4171896"
Message-ID: <486090DC.7010705@qualcomm.com>
Date: Mon, 23 Jun 2008 23:14:52 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Daniel K." <dk@uw.no>, mingo@elte.hu,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Jackson <pj@sgi.com>, Gregory Haskins <ghaskins@novell.com>
Subject: Re: RT-Scheduler/cgroups: Possible overuse of resources assigned
 via cpu.rt_period_us and cpu.rt_runtime_us
References: <485917CF.1010401@uw.no> <1213799836.16944.244.camel@twins>
In-Reply-To: <1213799836.16944.244.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2008-06-18 at 16:12 +0200, Daniel K. wrote:
>> mkdir /dev/cgroup
>> mount -t cgroup -o cpu,cpuset cgroup /dev/cgroup
>>
>> mkdir /dev/cgroup/0
>>
>> echo 3 > /dev/cgroup/0/cpuset.cpus
>> echo 0 > /dev/cgroup/0/cpuset.mems
>> echo 100000 > /dev/cgroup/0/cpu.rt_period_us
>> echo   5000 > /dev/cgroup/0/cpu.rt_runtime_us
>>
>> schedtool -R -p 1 -e burnP6 &
>> [1] 3309
>> echo 3309 > /dev/cgroup/0/tasks
>>
>> At this point I'd expect the burnP6 task to use 5% of the available CPU
>> resources in the cgroup (5000/100000), but the real CPU usage, as
>> reported by top, is 20% This is 4 times the expected result, and as I
>> have 4 cores, I think there is a strong hint of correlation there.
>>
>> Maybe with a 4 core system there really is 4 000 000 us available for
>> every 1 wall-time second?
> 
> Indeed. In effect each cpu (see below on specifics) gets the
> runtime/period you specify, and it moves unused runtime between cpus.
> 
>> However, I have only assigned one core (3) to _this_ cgroup, so I think
>> this cgroup is overusing its assigned resources.
>>
>> What do you think?
> 
> I think you're on to something :-)
> 
> It uses root domains, that is the largest domain this cpu is part of
> that has load-balancing enabled.
> 
> So while you have made your process part of the cgroup and the cpuset,
> there is no strong relation between them, that is to say, I could either
> mount the cpuset or cpu controller on a different mount point and add
> tasks to one but not the other.
Daniel is probably really confused by now :).

> So the relation I used is that of load-balance domains.
That's the key thing.

> So in order to get what you intended, do something like:
> 
> mount none /dev/cpuset cgroup -o cpuset
> mount none /cgroup/cpu cgroup -o cpu
> 
> mkdir /dev/cpuset/root
> mkdir /dev/cpuset/rt
> 
> #
> # this might not actually make the kernel happy
> # as it might attempt (and possibly succeed in)
> # moving cpu bound kernel threads
> #
> for i in `cat /dev/cpuset/tasks`; do
> 	echo $i > /dev/cpuset/root/tasks;
> done
It won't let you add tasks before adding cpus.

> echo 0-2 > /dev/cpuset/root/cpuset.cpus
> echo 3 > /dev/cpuset/rt/cpuset.cpus
> 
> echo 0 > /dev/cpuset/cpuset.sched_load_balance
> 
> mkdir /cgroup/cpu/foo
> echo 100000 > /cgroup/cpu/foo/cpu.rt_period_us
> echo   5000 > /cgroup/cpu/foo/cpu.rt_runtime_us
> 
> echo $$ > /dev/cpuset/rt/tasks
> echo $$ > /cgroup/cpu/foo/tasks
> 
> chrt -r -p 1 burnP6 &

That seems too complicated :). There is no need to mount them separately. The
only part that was missing from Daniel's example is the sched_load_balance
thingy otherwise he can still have a single cgroup unless I missing something.
In other words:

mkdir /dev/cgroup
mount -t cgroup -o cpu,cpuset cgroup /dev/cgroup

# Setup first domain (cpu 0-2)
mkdir /dev/cgroup/0
echo 0-2 > /dev/cgroup/0/cpuset.cpus
echo 0 > /dev/cgroup/0/cpuset.mems

# Setup second domain (cpu 3)
mkdir /dev/cgroup/1
echo 3 > /dev/cgroup/1/cpuset.cpus
echo 0 > /dev/cgroup/1/cpuset.mems

# Do not balance between domains
echo 0 > /dev/cpuset/cpuset.sched_load_balance

# Move all tasks into first domain if needed
...

# Setup RT bandwidth for second domain
echo 100000 > /dev/cgroup/1/cpu.rt_period_us
echo   5000 > /dev/cgroup/1/cpu.rt_runtime_us

schedtool -R -p 1 -e burnP6 &
[1] 3309
echo 3309 > /dev/cgroup/1/tasks

Max

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYFROha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYFROha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYFROhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:37:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38518 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbYFROhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:37:22 -0400
Subject: Re: RT-Scheduler/cgroups: Possible overuse of resources assigned
	via cpu.rt_period_us and cpu.rt_runtime_us
From: Peter Zijlstra <peterz@infradead.org>
To: "Daniel K." <dk@uw.no>
Cc: mingo@elte.hu, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Max Krasnyanskiy <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <485917CF.1010401@uw.no>
References: <485917CF.1010401@uw.no>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 16:37:16 +0200
Message-Id: <1213799836.16944.244.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 16:12 +0200, Daniel K. wrote:
> mkdir /dev/cgroup
> mount -t cgroup -o cpu,cpuset cgroup /dev/cgroup
> 
> mkdir /dev/cgroup/0
> 
> echo 3 > /dev/cgroup/0/cpuset.cpus
> echo 0 > /dev/cgroup/0/cpuset.mems
> echo 100000 > /dev/cgroup/0/cpu.rt_period_us
> echo   5000 > /dev/cgroup/0/cpu.rt_runtime_us
> 
> schedtool -R -p 1 -e burnP6 &
> [1] 3309
> echo 3309 > /dev/cgroup/0/tasks
> 
> At this point I'd expect the burnP6 task to use 5% of the available CPU
> resources in the cgroup (5000/100000), but the real CPU usage, as
> reported by top, is 20% This is 4 times the expected result, and as I
> have 4 cores, I think there is a strong hint of correlation there.
> 
> Maybe with a 4 core system there really is 4 000 000 us available for
> every 1 wall-time second?

Indeed. In effect each cpu (see below on specifics) gets the
runtime/period you specify, and it moves unused runtime between cpus.

> However, I have only assigned one core (3) to _this_ cgroup, so I think
> this cgroup is overusing its assigned resources.
> 
> What do you think?

I think you're on to something :-)

It uses root domains, that is the largest domain this cpu is part of
that has load-balancing enabled.

So while you have made your process part of the cgroup and the cpuset,
there is no strong relation between them, that is to say, I could either
mount the cpuset or cpu controller on a different mount point and add
tasks to one but not the other.

So the relation I used is that of load-balance domains.

So in order to get what you intended, do something like:


mount none /dev/cpuset cgroup -o cpuset
mount none /cgroup/cpu cgroup -o cpu

mkdir /dev/cpuset/root
mkdir /dev/cpuset/rt

#
# this might not actually make the kernel happy
# as it might attempt (and possibly succeed in)
# moving cpu bound kernel threads
#
for i in `cat /dev/cpuset/tasks`; do
	echo $i > /dev/cpuset/root/tasks;
done

echo 0-2 > /dev/cpuset/root/cpuset.cpus
echo 3 > /dev/cpuset/rt/cpuset.cpus

echo 0 > /dev/cpuset/cpuset.sched_load_balance

mkdir /cgroup/cpu/foo
echo 100000 > /cgroup/cpu/foo/cpu.rt_period_us
echo   5000 > /cgroup/cpu/foo/cpu.rt_runtime_us

echo $$ > /dev/cpuset/rt/tasks
echo $$ > /cgroup/cpu/foo/tasks

chrt -r -p 1 burnP6 &





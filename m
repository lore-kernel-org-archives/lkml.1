Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbZKCC0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbZKCC0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 21:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbZKCC0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 21:26:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58099 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbZKCC0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 21:26:53 -0500
Message-ID: <4AEF94E8.3030403@cn.fujitsu.com>
Date: Tue, 03 Nov 2009 11:26:48 +0900
From: Miao Xie <miaox@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [BUG] cpu controller can't provide fair CPU time for each group
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter.

I found two problems about cpu controller:
1) cpu controller didn't provide fair CPU time to groups when the tasks
    attached into those groups were bound to the same logic CPU.
2) cpu controller didn't provide fair CPU time to groups when shares of
    each group <= 2 * nr_cpus.

The detail is following:
1) The first one is that cpu controller didn't provide fair CPU time to
    groups when the tasks attached into those groups were bound to the
    same logic CPU.

    The reason is that there is something with the computing of the per
    cpu shares.

    on my test box with 16 logic CPU, I did the following manipulation:
    a. create 2 cpu controller groups.
    b. attach a task into one group and 2 tasks into the other.
    c. bind three tasks to the same logic cpu.
             +--------+     +--------+
             | group1 |     | group2 |
             +--------+     +--------+
                 |              |
    CPU0      Task A      Task B & Task C

    The following is the reproduce steps:
    # mkdir /dev/cpuctl
    # mount -t cgroup -o cpu,noprefix cpuctl /dev/cpuctl
    # mkdir /dev/cpuctl/1
    # mkdir /dev/cpuctl/2
    # cat /dev/zero > /dev/null &
    # pid1=$!
    # echo $pid1 > /dev/cpuctl/1/tasks
    # taskset -p -c 0 $pid1
    # cat /dev/zero > /dev/null &
    # pid2=$!
    # echo $pid2 > /dev/cpuctl/2/tasks
    # taskset -p -c 0 $pid2
    # cat /dev/zero > /dev/null &
    # pid3=$!
    # echo $pid3 > /dev/cpuctl/2/tasks
    # taskset -p -c 0 $pid3

    some time later, I found the the task in the group1 got the 35% CPU time not
    50% CPU time. It was very strange that this result against the expected.

    this problem was caused by the wrong computing of the per cpu shares.
    According to the design of the cpu controller, the shares of each cpu
    controller group will be divided for every CPU by the workload of each
    logic CPU.
       cpu[i] shares = group shares * CPU[i] workload / sum(CPU workload)

    But if the CPU has no task, cpu controller will pretend there is one of
    average load, usually this average load is 1024, the load of the task whose
    nice is zero. So in the test, the shares of group1 on CPU0 is:
       1024 * (1 * 1024) / ((1 * 1024 + 15 * 1024)) = 64
    and the shares of group2 on CPU0 is:
       1024 * (2 * 1024) / ((2 * 1024 + 15 * 1024)) = 120
    The scheduler of the CPU0 provided CPU time to each group by the shares
    above. The bug occured.

2) The second problem is that cpu controller didn't provide fair CPU time to
    groups when shares of each group <= 2 * nr_cpus

    The reason is that per cpu shares was set to MIN_SHARES(=2) if shares of
    each group <= 2 * nr_cpus.

    on the test box with 16 logic CPU, we do the following test:
    a. create two cpu controller groups
    b. attach 32 tasks into each group
    c. set shares of the first group to 16, the other to 32
             +--------+     +--------+
             | group1 |     | group2 |
             +--------+     +--------+
	        |shares=16     |shares=32
                 |              |
              16 Tasks       32 Tasks

    some time later, the first group got 50% CPU time, not 33%. It also was very
    strange that this result against the expected.

    It is because the shares of cpuctl group was small, and there is many logic
    CPU. So per cpu shares that was computed was less than MIN_SHARES, and then
    was set to MIN_SHARES.

    Maybe 16 and 32 is not used usually. We can set a usual number(such as 1024)
    to avoid this problem on my box. But the number of CPU on a machine will
    become more and more in the future. If the number of CPU is greater than 512,
    this bug will occur even we set shares of group to 1024. This is a usual
    number. At this rate, the usual user will feel strange.




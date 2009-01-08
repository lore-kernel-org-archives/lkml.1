Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbZAHDhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbZAHDhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 22:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZAHDh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 22:37:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63739 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbZAHDh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 22:37:27 -0500
Message-ID: <4965747E.60804@cn.fujitsu.com>
Date: Thu, 08 Jan 2009 11:35:26 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sched: fair group's bug
References: <4965573B.60801@cn.fujitsu.com>
In-Reply-To: <4965573B.60801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2009-1-8 9:30 Miao Xie wrote:
> I tested fair group scheduler on my hyper-threading x86_64 box(2 CPU * 2 HT)
> and found the deviation of the groups' CPU usage was larger than 2.6.26
> when *offline* a CPU or do hotplug frequently. It is less than 1% On 2.6.26，but
> On current kernel, it is often greater than 4%, even than 10% by accident.
> 
> A test program which reproduces the problem on current kernel is attached.
> This program forks a lot of child tasks and attachs these child tasks into each
> CPU controller group, then the parent task gets and checks the CPU usage of
> every group every 5 seconds.(All of the child tasks do the same work - repeat
> doing sqrt)
> 						Child Task 1
> 						  while(!end)
> 						      sqrt(f);
> 				Group 1		......
> 						Child Task m
> 						  while(!end)
> 						      sqrt(f);
> 				-----------------------------
> Parent Task             	Group 2		......
>   get and check the CPU		......		......
>   usage of every group		-----------------------------
> 						Child Task m*n-m+1
> 						  while(!end)
> 						      sqrt(f);
> 				Group n		......
> 						Child Task m*n
> 						  while(!end)
> 						      sqrt(f);
> 
> Steps to reproduce:
> # mkdir /dev/cpuctl
> # mount -t cgroup -o cpu,noprefix xxx /dev/cpuctl
> # ./cpuctl

Sorry. I forgot the step of offline CPU. The correct steps is following:
# echo 0 > /sys/devices/system/cpu/cpu3/online
# mkdir /dev/cpuctl
# mount -t cgroup -o cpu,noprefix xxx /dev/cpuctl
# ./cpuctl

> output on current kernel:
> -------------------------
> Group   Shares  Actual(%)       Expect(%)
> 0       1024    41.68           50.00
> 1       1024    58.32           50.00
> 0th group's usage is out of range(deviation = 8.32)
> 1th group's usage is out of range(deviation = 8.32)
> --------------------------
> 
> output on 2.6.26
> -------------------------
> Group   Shares  Actual(%)       Expect(%)
> 0       1024    50.03           50.00
> 1       1024    49.97           50.00
> --------------------------
> 
> On 2.6.26, the deviation may be greater than 4% at the beginning, but the scheduler
> adjusts soon, and don't occur the large deviation for ever.
> 
> Bisect located below patch:
> commit c09595f63bb1909c5dc4dca288f4fe818561b5f3
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Jun 27 13:41:14 2008 +0200
> 
>     sched: revert revert of: fair-group: SMP-nice for group scheduling
> 
>     Try again..
> 
>     Initial commit: 18d95a2832c1392a2d63227a7a6d433cb9f2037e
>     Revert: 6363ca57c76b7b83639ca8c83fc285fa26a7880e
> 
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>     Cc: Mike Galbraith <efault@gmx.de>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> Besides that, We found other problems by the attached program.
> 1. some tasks are hungry in the fair group.
> 	Steps to reproduce:
> 	# mkdir /dev/cpuctl
> 	# mount -t cgroup -o cpu,noprefix xxx /dev/cpuctl
> 	# ./cpuctl -g 1 -v
> 	--------------------
> 	1th Check Result:
> 	Group	Shares	Actual(%)	Expect(%)
> 	0	1024	100.00		100.00
> 	Each task's usage:
> 		Task in Group 0:
> 			Task	Usage(%)
> 			5395	0.000000
> 			5396	0.000000
> 		 	5397	0.000000
> 			5398	16.677785
> 			5399	16.677785
> 			5400	16.744496
> 			5401	16.611074
> 			5402	33.288859
> 
> 2. some groups broke the limit of the fair group and get more CPU time When
>    the groups is hiberarchy. Such as:
> 		top group
> 		    |
> 		 group 1
> 		/	\
> 	      task1	group 2
> 			   |
> 			task 2
> 	Steps to reproduce:
> 	# mkdir /dev/cpuctl
> 	# mount -t cgroup -o cpu,noprefix xxx /dev/cpuctl
> 	# ./cpuctl -H
> 	-------------------------
> 	Group	Shares	Actual(%)	Expect(%)
> 	0	1024	60.17		88.89
> 	1	1024    39.83		11.11
> 



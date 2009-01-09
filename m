Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZAICrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZAICrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 21:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZAICrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 21:47:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58050 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbZAICrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 21:47:04 -0500
Message-ID: <4966BA32.5000400@cn.fujitsu.com>
Date: Fri, 09 Jan 2009 10:45:06 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
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

This patch fixed the following problems. But the regression above still exists.

commit 0a582440ff546e2c6610d1acec325e91b4efd313
Author: Mike Galbraith <efault@gmx.de>
Date:   Fri Jan 2 12:16:42 2009 +0100

    sched: fix sched_slice()

    Impact: fix bad-interactivity buglet

    Fix sched_slice() to emit a sane result whether a task is currently
    enqueued or not.

    Signed-off-by: Mike Galbraith <efault@gmx.de>
    Tested-by: Jayson King <dev@jaysonking.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

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



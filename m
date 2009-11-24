Return-Path: <linux-kernel-owner+w=401wt.eu-S932868AbZKXNLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbZKXNLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932548AbZKXNL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:11:29 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:44331 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbZKXNL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:11:29 -0500
Subject: [PATCH 0/1] Correct sorting problem in cfq_service_tree_add
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 08:11:33 -0500
Message-ID: <1259068293.3019.15.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found this whilst reviewing the CFQ I/O scheduler code: Currently, this
routine only sorts using the I/O priority class - it does not properly
sort prioritized queues within a specific class. The patch changes the
sort to utilize the full I/O priority (class & priority).

A simple test shows the problem & fixed results: on a 16-way box, for
each of 12 attached disks I started up 17 processes (one process at each
possible class/priority). Each process operated on a separate file in
the file system. I then did two types of tests: (a) direct/synchronous
and (b) direct/asynchronous w/ an 80/20 read/write split.

I then tabulated the overall I/O performed per task: (first column is
priority class (1==RT, 2==BE, 3==IDLE), second column is the I/O
priority (0==highest), then two groupings of read/write data moved
(total KiBs over a span of 120 seconds):

Synchronous:
         2.6.32-rc8     2.6.32-rc8+patch
        Read    Write     Read    Write
     ----------------   ----------------
1 0 |  311164  310760 |  424260  424116 | 
1 1 |  129712  129792 |  390208  393232 | 
1 2 |   72312   71284 |     448     420 | 
1 3 |   40364   41052 |      28      20 | 
1 4 |   26788   26352 |      28      24 | 
1 5 |   16936   16940 |      52      32 | 
1 6 |   11196   11140 |      28      20 | 
1 7 |    6476    6648 |      20      28 | 

2 0 |      24      24 |      40       8 | 
2 1 |      24      24 |      12      36 | 
2 2 |      20      28 |      20      28 | 
2 3 |      28      20 |      24      24 | 
2 4 |      28      20 |      28      20 | 
2 5 |      28      20 |      20      28 | 
2 6 |      24      24 |      20      28 | 
2 7 |      24      24 |      36      12 | 

3   |      36      12 |      28      20 |
     ----------------   ----------------
Sum    615184  614164    815300  818096

You can see that due to the "random" nature of the unpatched kernel
lower priority real-time processes get elevated I/O amounts. With the
patched kernel, real-time priorities 0&1 get the vast majority of the
available throughput (as expected). [Basically: priority 0 & 1
flip-flop: when priority 0's I/O finishes, priority 1's gets inserted
then priority 0 comes back with another I/O quick enough (most of the
time) and bumps all the other queues out of the way.]

More I/O is performed with the patched kernel (most likely) because
there is much less thrashing/seeking on the disk.

Asynchronous:
         2.6.32-rc8     2.6.32-rc8+patch
        Read    Write     Read    Write
     ----------------   ----------------
1 0 | 1969220 1967036 | 2272660 2266220 | 
1 1 |   65880   66216 |   71552   71424 | 
1 2 |   30760   30808 |    3532    3508 | 
1 3 |   17352   17336 |    2996    3148 | 
1 4 |   11496   11288 |    3028    3116 | 
1 5 |    7836    8036 |    3008    3136 | 
1 6 |    5432    5448 |    2992    3152 | 
1 7 |    3692    3860 |    3068    3076 | 

2 0 |    3172    2972 |    3052    3092 | 
2 1 |    3100    3044 |    3000    3144 | 
2 2 |    3140    3004 |    3056    3088 | 
2 3 |    3108    3036 |    3084    3060 | 
2 4 |    3116    3028 |    2968    3176 | 
2 5 |    3068    3076 |    3096    3048 | 
2 6 |    2884    3260 |    3084    3060 | 
2 7 |    3112    3032 |    3208    2936 | 

3   |    3172    2972 |    2968    3176 | 
     ----------------   ----------------
Sum   2139540 2137452   2390352  2384560

With Asynch I/O priority 0 gets the vast (vast!) majority of the
bandwidth because it is issuing more I/Os in one go (128 asynch I/Os at
a time).


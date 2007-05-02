Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbXEBJIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbXEBJIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbXEBJIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:08:21 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:51385 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbXEBJIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:08:20 -0400
Message-ID: <463854F3.3020403@linux.vnet.ibm.com>
Date: Wed, 02 May 2007 14:38:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v8
References: <20070501212223.GA29867@elte.hu>
In-Reply-To: <20070501212223.GA29867@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Changes since -v7:
> 
>  - powerpc debug output and build warning fixes (Balbir Singh)
> 
>  - documentation fixes (Zach Carter)
> 
>  - interactivity: precise load calculation and load smoothing
> 
> As usual, any sort of feedback, bugreport, fix and suggestion is more 
> than welcome,
> 
> 	Ingo

Hi, Ingo,

I would like to report, what I think is a regression with -v8.

With -v7 I would run the n/n+1 test. Basically on a system with
n cpus, I would run n+1 tasks and see how their load is distributed.
I usually find that the last two tasks would get stuck on one CPU
on the system and would get half the cpu time as their other peers.
I think this issue has been around for long even before CFS. But
while I was investigating that, I found that with -v8, all the n+1 tasks are
stuck on the same cpu.

Output of /proc/sched_debug

# cat /proc/sched_debug
Sched Debug Version: v0.02
now at 1507287574145 nsecs

cpu: 0
   .nr_running            : 0
   .raw_weighted_load     : 0
   .nr_switches           : 111130
   .nr_load_updates       : 376821
   .nr_uninterruptible    : 18446744073709551550
   .next_balance          : 4295269119
   .curr->pid             : 0
   .clock                 : 7431167968202137
   .prev_clock_raw        : 7431167968202136
   .clock_warps           : 0
   .clock_unstable_events : 0
   .clock_max_delta       : 0
   .fair_clock            : 26969582038
   .prev_fair_clock       : 26969539422
   .exec_clock            : 9881536864
   .prev_exec_clock       : 9881494248
   .wait_runtime          : 116431647
   .cpu_load[0]           : 0
   .cpu_load[1]           : 0
   .cpu_load[2]           : 0
   .cpu_load[3]           : 0
   .cpu_load[4]           : 0

runnable tasks:
            task   PID      tree-key         delta       waiting  switches 
prio    wstart-fair       sum-exec       sum-wait
----------------------------------------------------------------------------------------------------------------------------

cpu: 1
   .nr_running            : 0
   .raw_weighted_load     : 0
   .nr_switches           : 56374
   .nr_load_updates       : 376767
   .nr_uninterruptible    : 156
   .next_balance          : 4295269118
   .curr->pid             : 0
   .clock                 : 7431167857161633
   .prev_clock_raw        : 7431167857161632
   .clock_warps           : 0
   .clock_unstable_events : 0
   .clock_max_delta       : 0
   .fair_clock            : 34038615236
   .prev_fair_clock       : 34038615236
   .exec_clock            : 18764126904
   .prev_exec_clock       : 18764126904
   .wait_runtime          : 132146856
   .cpu_load[0]           : 0
   .cpu_load[1]           : 0
   .cpu_load[2]           : 0
   .cpu_load[3]           : 0
   .cpu_load[4]           : 0

runnable tasks:
            task   PID      tree-key         delta       waiting  switches 
prio    wstart-fair       sum-exec       sum-wait
----------------------------------------------------------------------------------------------------------------------------

cpu: 2
   .nr_running            : 5
   .raw_weighted_load     : 5120
   .nr_switches           : 140351
   .nr_load_updates       : 376767
   .nr_uninterruptible    : 18446744073709551559
   .next_balance          : 4295269128
   .curr->pid             : 6462
   .clock                 : 7431167968695481
   .prev_clock_raw        : 7431167968695480
   .clock_warps           : 0
   .clock_unstable_events : 0
   .clock_max_delta       : 0
   .fair_clock            : 178895812434
   .prev_fair_clock       : 178895727748
   .exec_clock            : 858569069824
   .prev_exec_clock       : 858568528616
   .wait_runtime          : 2643237421
   .cpu_load[0]           : 0
   .cpu_load[1]           : 0
   .cpu_load[2]           : 0
   .cpu_load[3]           : 0
   .cpu_load[4]           : 0

runnable tasks:
            task   PID      tree-key         delta       waiting  switches 
prio    wstart-fair       sum-exec       sum-wait
----------------------------------------------------------------------------------------------------------------------------
R          bash  6462  178897659138       1846704      -1846958     19646 
120  -178895812434   169799117688   135410790136
            bash  6461  178897934427       2121993      -7673376     19538 
  120       -5551118   169989747968   135499300276
            bash  6460  178898353788       2541354      -6492732     19608 
  120       -3951111   170136703840   135648219117
            bash  6459  178899921997       4109563      -6460948     19747 
  120       -2351093   170559324432   135812802778
            bash  6458  178901052918       5240484      -5991881     19756 
  120        -751111   171257975848   135805570391

cpu: 3
   .nr_running            : 1  .prev_fair_clock       : 24318712701
   .exec_clock            : 20098322728
   .prev_exec_clock       : 20098322728
   .wait_runtime          : 178370619
   .cpu_load[0]           : 0
   .cpu_load[1]           : 0
   .cpu_load[2]           : 0
   .cpu_load[3]           : 0
   .cpu_load[4]           : 0

runnable tasks:
            task   PID      tree-key         delta       waiting  switches 
prio    wstart-fair       sum-exec       sum-wait
----------------------------------------------------------------------------------------------------------------------------
R           cat  7524   24318779730         67029        -67029         3 
120   -24318712701        1661560           2277


   .raw_weighted_load     : 1024
   .nr_switches           : 43253
   .nr_load_updates       : 376767
   .nr_uninterruptible    : 18446744073709551583
   .next_balance          : 4295269180
   .curr->pid             : 7524
   .clock                 : 7431167970150081
   .prev_clock_raw        : 7431167970150080
   .clock_warps           : 0
   .clock_unstable_events : 0
   .clock_max_delta       : 0
   .fair_clock            : 24318712701


Output of top

  6459 root      20   0  4912  792  252 R   20  0.0   8:29.33 bash 

  6458 root      20   0  4912  792  252 R   20  0.0   8:29.90 bash 

  6460 root      20   0  4912  792  252 R   20  0.0   8:28.94 bash 

  6461 root      20   0  4912  792  252 R   20  0.0   8:28.88 bash 

  6462 root      20   0  4912  792  252 R   20  0.0   8:28.54 bash 





-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

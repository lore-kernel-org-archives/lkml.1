Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbXKSSv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbXKSSv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXKSSvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:51:19 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:52368 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752AbXKSSvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:51:18 -0500
Date: Mon, 19 Nov 2007 10:51:16 -0800
From: Micah Dowty <micah@vmware.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>,
       Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071119185116.GA28173@vmware.com>
References: <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com> <20071115213510.GA16079@vmware.com> <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com> <20071116024408.GA20322@vmware.com> <20071116060700.GD16273@elte.hu> <b647ffbd0711160248v444d8f64ic72a17fcb56adc6d@mail.gmail.com> <20071116221404.GC31527@vmware.com> <b647ffbd0711161526p2faf5abt2457084f1996c735@mail.gmail.com> <20071117010352.GA13666@vmware.com> <b647ffbd0711171110q9f695e1qb42ba73dc23b626d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0711171110q9f695e1qb42ba73dc23b626d@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 08:10:35PM +0100, Dmitry Adamushko wrote:
> Micah,
> 
> ok, would it be possible to get "cat /proc/schedstat" output at the
> moment when you observe the 'problem'? So we could try to analyze
> behavior of the load balancer (yeah, we should have probably started
> with this step)

No problem. Here are the two schedstat snapshots. With my priosched.c
test program running with one CPU idle, I did a "cat /proc/schedstat",
waited a couple seconds, then repeated:

micah@micah-64:~$ cat /proc/schedstat 
version 14
timestamp 4366722208
cpu0 0 0 0 785868111 0 828020771 12621812 22703872 14096041 9504937730116 23603703739504 815398959
domain0 03 8766051 8760123 95 14544377 6374 0 13 8760110 7369 6771 0 20835105 605 0 1 6770 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7026998 0 24826
cpu1 0 0 0 783505304 0 860700497 26129151 41776419 34749418 10682815341474 1753703225423 834571346
domain0 03 8685595 8677710 224 7037051 8127 0 76 8677634 7500 7320 7 471762 179 0 8 7312 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 8607831 0 36753
micah@micah-64:~$ cat /proc/schedstat 
version 14
timestamp 4366723231
cpu0 0 0 0 785868111 0 828021128 12621812 22703965 14096130 9509029340381 23603703795868 815399316
domain0 03 8766051 8760123 95 14544377 6374 0 13 8760110 7374 6776 0 20835105 605 0 1 6775 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7027010 0 24826
cpu1 0 0 0 783505304 0 860708521 26132612 41780521 34753508 10683770853336 1753758309667 834575909
domain0 03 8685718 8677833 224 7037051 8127 0 76 8677757 7500 7320 7 471762 179 0 8 7312 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 8607835 0 36753

I had been experimenting with both schedstat and sched_debug while
trying to identify the original problem I observed with VMware's
code. During the course of that investigation, I wrote a little tool
to graph schedstat output in real-time.

The tool itself is in a public Subversion reporitory:
  http://svn.navi.cx/misc/trunk/rtgraph/schedstat-grapher.py
  (Requires the other Python modules in that directory, and PyGTK)

This screenshot was taken just after the priosched.c test program
flipped from the "bad" state to the "good" state. It had been running
on one CPU for a while, and something caused it to rebalance properly
onto both CPUs while this graph was being recorded. You can see that
in the "bad" state, cpu0 was trying to rebalance but it was failing
because there was no busier group (idle_nobusyg):

  http://navi.cx/~micah/priosched-graph-1.png

While in the "bad" state, the sched_debug output shows clearly why we
were hitting idle_nobusyg. One CPU has both busy-loop threads in its
runqueue, the other CPU is mostly idle but it has an elevated CPU load
proportional to the high priority thread's priority boost.

micah@micah-64:~$ cat /proc/sched_debug 
Sched Debug Version: v0.05-v20, 2.6.23.1 #1
now at 287991360677873 nsecs

cpu#0, 2593.095 MHz
  .nr_running                    : 0
  .load                          : 0
  .ls.delta_fair                 : 27950
  .ls.delta_exec                 : 1958562
  .nr_switches                   : 42562597
  .nr_load_updates               : 71998668
  .nr_uninterruptible            : 2731
  .jiffies                       : 4366886827
  .next_balance                  : 4366886830
  .curr->pid                     : 0
  .clock                         : 288012673563036
  .idle_clock                    : 0
  .prev_clock_raw                : 287377858327690
  .clock_warps                   : 0
  .clock_overflows               : 50589
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 4000250
  .cpu_load[0]                   : 58784
  .cpu_load[1]                   : 64246
  .cpu_load[2]                   : 65333
  .cpu_load[3]                   : 63586
  .cpu_load[4]                   : 61992

cfs_rq
  .fair_clock                    : 9034352848909
  .exec_clock                    : 10184480087500
  .wait_runtime                  : 0
  .wait_runtime_overruns         : 10356815
  .wait_runtime_underruns        : 1551195
  .sleeper_bonus                 : 33752273
  .wait_runtime_rq_sum           : 0

runnable tasks:
            task   PID        tree-key         delta       waiting  switches  prio        sum-exec        sum-wait       sum-sleep    wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------

cpu#1, 2593.095 MHz
  .nr_running                    : 3
  .load                          : 3072
  .ls.delta_fair                 : 247507
  .ls.delta_exec                 : 1148874
  .nr_switches                   : 78415958
  .nr_load_updates               : 71998585
  .nr_uninterruptible            : -2731
  .jiffies                       : 4366886827
  .next_balance                  : 4366886976
  .curr->pid                     : 16252
  .clock                         : 288012340795477
  .idle_clock                    : 0
  .prev_clock_raw                : 287377857592876
  .clock_warps                   : 0
  .clock_overflows               : 18670
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 4000250
  .cpu_load[0]                   : 7136
  .cpu_load[1]                   : 4591
  .cpu_load[2]                   : 3319
  .cpu_load[3]                   : 2691
  .cpu_load[4]                   : 2391

cfs_rq
  .fair_clock                    : 10089416808778
  .exec_clock                    : 11099173384388
  .wait_runtime                  : -74868320
  .wait_runtime_overruns         : 18282511
  .wait_runtime_underruns        : 1233484
  .sleeper_bonus                 : 3602202
  .wait_runtime_rq_sum           : -74868320

runnable tasks:
            task   PID        tree-key         delta       waiting  switches  prio        sum-exec        sum-wait       sum-sleep    wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------
       priosched 16248  10089447384328      30575550     -31397913       172   120      1665860833       -80591108               0               0              17
       priosched 16249  10089453683739      36874961     -39698014       148   120      1670430581       -63070307               0               0              13
R            cat 16252  10089420581171       3772393      -3772393         1   120           73354          -22393           90430               0               0


Thanks,
--Micah

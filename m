Return-Path: <linux-kernel-owner+w=401wt.eu-S1764287AbXFEOER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764287AbXFEOER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760512AbXFEOEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:04:04 -0400
Received: from waste.org ([66.93.16.53]:39141 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760024AbXFEOEC (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:04:02 -0400
Date: Tue, 5 Jun 2007 09:03:42 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070605140342.GR11115@waste.org>
References: <20070604173710.GR11166@waste.org> <20070604175436.GC30274@elte.hu> <20070604184106.GG11115@waste.org> <20070605071904.GB25163@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605071904.GB25163@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 09:19:04AM +0200, Ingo Molnar wrote:
> 
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > sleep_max                :         57476665627
> > block_max                :   18014060106626075
> 
> hm, this block_max looks a bit suspect, it's 003fffb1359e341b. Does your 
> box make any use of cpufreq? (what CPU is it?)

Yes, I use the conservative governor. As I posted yesterday, setting
the governor to performance doesn't help: the CPU hog drives the CPU
to full speed.

> > 24936 13:39:44.469677 rt_sigprocmask(SIG_UNBLOCK, [USR1], NULL, 8) = 0
> > 24936 13:39:44.469765 read(7, 0xbfe6c010, 8) = -1 EINTR (Interrupted system call)
> > 24936 13:39:48.699490 --- SIGUSR1 (User defined signal 1) @ 0 (0) ---
> 
> hm, this indeed implicates some wakeup problem. lguest task 24936's 
> relevant stats are:
> 
>  block_start              :                   0
>  sleep_max                :            21492554
>  block_max                :            27044576
>  exec_max                 :             4008057
>  wait_max                 :          1253670288
> 
> the wait_max means it was delayed on the runqueue for 1.2 seconds. Could 
> you try to get a /proc/sched_debug snapshot done exactly during the 
> 'delay' window - it's 4 seconds so you should in theory be able to 
> trigger it by doing something like:
> 
>   sleep 3; cat /proc/sched_debug > sched_debug.txt
> 
> Click into the lguest window and trigger the delay.

I did:

while true; do sleep 1; cat /proc/sched_debug > sched_debug.txt; done

and got this, hopefully inside the window:

Sched Debug Version: v0.02
now at 257428593818894 nsecs

cpu: 0
  .nr_running            : 3
  .raw_weighted_load     : 2063
  .nr_switches           : 242830075
  .nr_load_updates       : 30172063
  .nr_uninterruptible    : 0
  .jiffies               : 64282148
  .next_balance          : 0
  .curr->pid             : 27182
  .clock                 : 125650217819008823
  .prev_clock_raw        : 257428516403535
  .clock_warps           : 9
  .clock_unstable_events : 41133344
  .clock_max_delta       : 3954619
  .fair_clock            : 125631632368075562
  .prev_fair_clock       : 0
  .exec_clock            : 125649753800946713
  .prev_exec_clock       : 0
  .wait_runtime          : -12865352643
  .wait_runtime_overruns : 41121996
  .wait_runtime_underruns: 4107250
  .cpu_load[0]           : 1039
  .cpu_load[1]           : 1039
  .cpu_load[2]           : 1039
  .cpu_load[3]           : 1041
  .cpu_load[4]           : 1053
  .wait_runtime_rq_sum   : -48091562

runnable tasks:
            task   PID        tree-key         delta       waiting  switches  prio        sum-exec        sum-wait       sum-sleep    wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------
R            cat 27182 125631632367998747        -76815        -91562         6   120          250189          -91562           75163               0               0
          python 26973 125631632404141566      36066004     -24000000     25486   120     93635486661     -1940103390          140903              49            2069
          lguest 26986 125631633015454796     647379234     -24000000      1481   139         7638721     37069331905     90071079196            1461               2


-- 
Mathematics is the supreme nostalgia of our time.

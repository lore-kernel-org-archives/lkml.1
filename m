Return-Path: <linux-kernel-owner+w=401wt.eu-S933684AbXGWQoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbXGWQoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762943AbXGWQnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:43:51 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:39085 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762701AbXGWQnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:43:50 -0400
Message-ID: <46A4DAE5.4010302@free.fr>
Date: Mon, 23 Jul 2007 18:44:21 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-rt-users@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Pin-pointing the root of unusual application latencies
References: <469600F7.3060603@free.fr> <20070723095357.GA886@elte.hu> <46A4B7C2.1070304@free.fr> <20070723160442.GA7995@elte.hu>
In-Reply-To: <20070723160442.GA7995@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> add 'notrace' to the definition of read_tsc in arch/i386/kernel/tsc.c

OK.

> (or do echo 1 > /proc/sys/kernel/trace_use_raw_cycles
> if you are using recent enough -rt)

Is patch-2.6.20-rt8 recent enough?

# ./trace-it 1 >trace
# cat trace
preemption latency trace v1.1.5 on 2.6.20.7-rt8
--------------------------------------------------------------------
  latency: 1000034 us, #10083/10083, CPU#0 | (M:rt VP:0, KP:0, SP:1 HP:1)
     -----------------
     | task: trace-it-939 (uid:0 nice:0 policy:0 rt_prio:0)
     -----------------

                  _------=> CPU#
                 / _-----=> irqs-off
                | / _----=> need-resched
                || / _---=> hardirq/softirq
                ||| / _--=> preempt-depth
                |||| /
                |||||     delay
    cmd     pid ||||| time  |   caller
       \   /    |||||   \   |   /
trace-it-939   0D...    0us : user_trace_start (sys_prctl)
trace-it-939   0....    0us : rt_up (user_trace_start)
trace-it-939   0...1    1us : rt_mutex_unlock (rt_up)
trace-it-939   0D...    1us+< (0)
trace-it-939   0....    4us > sys_rt_sigprocmask (00000000 bfadff4c 
000000d8)
trace-it-939   0....    5us : sys_rt_sigprocmask (sysenter_past_esp)
trace-it-939   0....    5us : copy_from_user (sys_rt_sigprocmask)
trace-it-939   0....    5us : __copy_from_user_ll (copy_from_user)
trace-it-939   0....    5us : sigprocmask (sys_rt_sigprocmask)
trace-it-939   0....    5us : __lock_text_start (sigprocmask)
trace-it-939   0....    6us : recalc_sigpending (sigprocmask)
[...]
   <idle>-0     0DN.. 1000027us : __sched_text_start (cpu_idle)
   <idle>-0     0DN.1 1000027us : __sched_text_start (c0100f30 0 0)
   <idle>-0     0DN.1 1000027us : sched_clock (__sched_text_start)
   <idle>-0     0D..2 1000028us : __switch_to (__sched_text_start)
trace-it-939   0D..2 1000028us : __sched_text_start <<idle>-0> (20 -2)
trace-it-939   0D..1 1000029us : trace_stop_sched_switched 
(__sched_text_start)
trace-it-939   0.... 1000029us : hrtimer_cancel (do_nanosleep)
trace-it-939   0.... 1000030us : hrtimer_try_to_cancel (hrtimer_cancel)
trace-it-939   0D... 1000031us < (0)
trace-it-939   0.... 1000032us > sys_prctl (00000000 00000000 000000d8)
trace-it-939   0.... 1000032us : sys_prctl (sysenter_past_esp)
trace-it-939   0.... 1000032us : user_trace_stop (sys_prctl)
trace-it-939   0D... 1000033us : user_trace_stop (sys_prctl)

This looks better.

I will let my test program run overnight.

Regards.

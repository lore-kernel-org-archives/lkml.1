Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZEITtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZEITtt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 15:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZEITtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 15:49:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbZEITtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 15:49:39 -0400
Date: Sat, 9 May 2009 12:45:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/5] hrtimer: per-cpu cached values of ktime
In-Reply-To: <20090508170028.630419454@chello.nl>
Message-ID: <alpine.LFD.2.01.0905091234510.3586@localhost.localdomain>
References: <20090508165219.469818319@chello.nl> <20090508170028.630419454@chello.nl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 May 2009, Peter Zijlstra wrote:
>
> The regular (hrtimer driven) tick calls ktime_get() 4 times:
> 
> hrtimer_interupt()
>   ktimer_get()
>   __run_hrtimer()
>     tick_sched_timer()
>       ktimer_get()
>       update_process_times()
>         run_local_timers()
>         rcu_pending()
>         printk_tick()
>         scheduler_tick()
>           sched_clock_tick()
>             ktime_get()
>           perf_counter_task_tick()
>         run_posix_cpu_timers()
>       profile_tick()
>       hrtimer_forward()
>     hrtimer_enqueue()
>       tick_program_event()
>         tick_dev_program_event()
>           ktime_get()
> 
> Reduce that to 2 by caching the 1st ktime_get(). By clearing the state on
> irq_exit() this always works, even for !hrtimer ticks.

Ugh. This looks pretty horrid. That special-case cache is just nasty.

Would it be entirely impossible to just instead do ktime_get() once at the 
top and just pass it down. Yes, yes, it would involve calling convention 
changes, but that sounds way saner than having an ad-hoc cache like this.

With this, you now have magic rules for when you can use the "get from 
cache" version, and time goes backwards if you mix them by mistake (ie you 
use a non-caching "ktime_get()" in between two caching "ktime_irq_get()" 
calls, and now time will have gone backwards from the second to the third 
case).

It just seems to be very hacky.

			Linus

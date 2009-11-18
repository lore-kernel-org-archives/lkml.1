Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbZKRTaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbZKRTaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 14:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbZKRTaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 14:30:30 -0500
Received: from www.tglx.de ([62.245.132.106]:54856 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758089AbZKRTa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 14:30:29 -0500
Date: Wed, 18 Nov 2009 20:30:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: akpm@linux-foundation.org
cc: Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
       feng.tang@intel.com, Peter Zijlstra <peterz@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch for 2.6.32? 1/3] hrtimers: remove the "timer_stats_active"
 check when setting the start info
In-Reply-To: <200911172214.nAHMEBh2023787@imap1.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
References: <200911172214.nAHMEBh2023787@imap1.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009, akpm@linux-foundation.org wrote:

Back to LKML with some more cc's.

> From: Feng Tang <feng.tang@intel.com>
> 
> Recent hrtimer code will set the start info to a hrtimer only when that
> flag is set, then the start info of all hrtimers will always be
> uninitialised before a "echo 1 > /proc/timer_stats", thus the
> /proc/timer_lists will have something like:
> 
> active timers:
>  #0: <c27d46b0>, tick_sched_timer, S:01, <(null)>, /-1
>  # expires at 91062000000-91062000000 nsecs [in 156071 to 156071 nsecs]
>  #1: <efb81b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
>  # expires at 91062300331-91062350331 nsecs [in 456402 to 506402 nsecs]
>  #2: <efac9b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
>  # expires at 91068699811-91068749811 nsecs [in 6855882 to 6905882 nsecs]
>  #3: <efacdb6c>, hrtimer_wakeup, S:01, <(null)>, /-1
>  # expires at 91068755511-91068805511 nsecs [in 6911582 to 6961582 nsecs]
>  #4: <efa95b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
>  # expires at 91068806066-91068856066 nsecs [in 6962137 to 7012137 nsecs]
>  .....
> 
> This patch fixes it.

This patch does more than that and it does not mention it in the
change log. The change log is also missing the context which
introduced this regression.

Just to get the context straight:

commit 507e1231 (timer stats: Optimize by adding quick check to avoid
function calls) commit 507e1231 added the timer_stats_active check in
timer_stats_hrtimer_set_start_info() to reduce the overhead when timer
stats are inactive.

As an unintentional side effect it introduced the above regression in
/proc/timer_list.

>  static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
>  {
> -	if (likely(!timer_stats_active))
> -		return;

This is fine. It reverts the hrtimer part of commit 507e1231 and fixes
the /proc/timer_list regression for the price of the same overhead
which we had before that commit.

That's the immediate fix which needs to go to Linus and stable.

>  	__timer_stats_hrtimer_set_start_info(timer, __builtin_return_address(0));
>  }
>  
> diff -puN kernel/hrtimer.c~hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info kernel/hrtimer.c
> --- a/kernel/hrtimer.c~hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info
> +++ a/kernel/hrtimer.c
> @@ -750,7 +750,7 @@ static inline void hrtimer_init_timer_hr
>  #ifdef CONFIG_TIMER_STATS
>  void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer, void *addr)
>  {
> -	if (timer->start_site)
> +	if (timer->start_site == addr && timer->start_pid == current->pid)

This part is unrelated to the above regression and is wrong for the
following reasons:

  1) it runs the memcpy when the start_site changes even when the pid
     is the same, which is extremly bad for tick->sched_timer as this
     timer is re(armed) frequently from different places when NOHZ=y.

  2) it runs the memcpy when the pid changes which is even worse for
     tick->sched_timer as this timer is re(armed) frequently from
     hrtimer_interrupt which hits random pids and would therefor
     report completely wrong pid/comm info.

This needs more thought and is definitely neither -rc7 nor stable
material.

Thanks,

	tglx

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbZFWPIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbZFWPIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbZFWPIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:08:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59315 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbZFWPIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:08:34 -0400
Date: Tue, 23 Jun 2009 17:08:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mustafa Mesanovic <mustafa.mesanovic@de.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/Resend] timer stats: add quick check to avoid function
	calls
Message-ID: <20090623150803.GD13415@elte.hu>
References: <20090623161212.5af942c0@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623161212.5af942c0@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> When the kernel is configured with CONFIG_TIMER_STATS but timer stats
> are runtime disabled we still get calls to __timer_stats_timer_set_start_info
> which initializes some fields in the corresponding struct timer_list.
> 
> So add some quick checks in the the timer stats setup functions to avoid
> function calls to __timer_stats_timer_set_start_info when timer stats are
> disabled.
> 
> In an artificial workload that does nothing but playing ping pong with a
> single tcp packet via loopback this decreases cpu consumption by 1 - 1.5%.
> 
> This is part of a modified function trace output on SLES11:
> 
> perl-2497  [00] 28630647177732388 [+  125]: sk_reset_timer <-tcp_v4_rcv
> perl-2497  [00] 28630647177732513 [+  125]: mod_timer <-sk_reset_timer
> perl-2497  [00] 28630647177732638 [+  125]: __timer_stats_timer_set_start_info <-mod_timer
> perl-2497  [00] 28630647177732763 [+  125]: __mod_timer <-mod_timer
> perl-2497  [00] 28630647177732888 [+  125]: __timer_stats_timer_set_start_info <-__mod_timer
> perl-2497  [00] 28630647177733013 [+   93]: lock_timer_base <-__mod_timer

makes sense.

Only one very small detail:

> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> 
>  include/linux/hrtimer.h   |    6 ++++++
>  include/linux/timer.h     |    4 ++++
>  kernel/time/timer_stats.c |   16 ++++++++--------
>  kernel/timer.c            |    2 ++
>  4 files changed, 20 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/include/linux/hrtimer.h
> ===================================================================
> --- linux-2.6.orig/include/linux/hrtimer.h
> +++ linux-2.6/include/linux/hrtimer.h
> @@ -438,12 +438,16 @@ extern void sysrq_timer_list_show(void);
>   */
>  #ifdef CONFIG_TIMER_STATS
>  
> +extern int timer_stats_active;
> +
>  extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
>  				     void *timerf, char *comm,
>  				     unsigned int timer_flag);
>  
>  static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
>  {
> +	if (likely(!timer->start_pid))
> +		return;
>  	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
>  				 timer->function, timer->start_comm, 0);
>  }
> @@ -453,6 +457,8 @@ extern void __timer_stats_hrtimer_set_st
>  
>  static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
>  {
> +	if (likely(!timer_stats_active))
> +		return;
>  	__timer_stats_hrtimer_set_start_info(timer, __builtin_return_address(0));
>  }
>  
> Index: linux-2.6/include/linux/timer.h
> ===================================================================
> --- linux-2.6.orig/include/linux/timer.h
> +++ linux-2.6/include/linux/timer.h
> @@ -187,6 +187,8 @@ extern unsigned long get_next_timer_inte
>   */
>  #ifdef CONFIG_TIMER_STATS
>  
> +extern int timer_stats_active;

Why is this declared twice, once in hrtimer.h and once in timer.h? 
One should suffice, right?

	Ingo

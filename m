Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbYLTULM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbYLTULM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 15:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYLTUK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 15:10:57 -0500
Received: from www.tglx.de ([62.245.132.106]:37768 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYLTUK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 15:10:57 -0500
Date: Sat, 20 Dec 2008 21:10:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Eric Sesterhenn <snakebyte@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] posix-timers: CLOCK_MONOTONIC_RAW: fix the usage of
 ->it_clock
In-Reply-To: <20081220174817.GA5273@redhat.com>
Message-ID: <alpine.LFD.2.00.0812202108180.3376@localhost.localdomain>
References: <20081219172549.GA25722@alice> <alpine.LFD.2.00.0812192243350.3376@localhost.localdomain> <20081220161457.GA26499@redhat.com> <20081220163033.GB26499@redhat.com> <20081220174817.GA5273@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2008, Oleg Nesterov wrote:

> (compile tested)
> 
> common_timer_create() and common_timer_set() blindly pass ->it_clock to
> hrtimer_init() as clock_id. This used to work until CLOCK_MONOTONIC_RAW
> was introduced, now we should be careful.
> 
> Perhaps it makes sense to add BUG_ON(clock_id >= HRTIMER_MAX_CLOCK_BASES)
> to __hrtimer_init(), the wrong clock_id leads to catastrophe.
> 
> Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> --- K-28/kernel/posix-timers.c~CLOCK_MONOTONIC_RAW	2008-12-02 17:12:40.000000000 +0100
> +++ K-28/kernel/posix-timers.c	2008-12-20 18:23:28.000000000 +0100
> @@ -191,12 +191,20 @@ static inline int common_clock_set(const
>  	return do_sys_settimeofday(tp, NULL);
>  }
>  
> -static int common_timer_create(struct k_itimer *new_timer)
> +static inline int
> +__common_timer_init(struct k_itimer *timer, enum hrtimer_mode mode)
>  {
> -	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
> +	clockid_t clock_id = timer->it_clock ?
> +				CLOCK_MONOTONIC : CLOCK_REALTIME;
> +	hrtimer_init(&timer->it.real.timer, clock_id, mode);
>  	return 0;
>  }

No, this is wrong. We do not want to create a timer for
CLOCK_MONOTONIC_RAW.

	tglx

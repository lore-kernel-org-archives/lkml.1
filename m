Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbZCLKLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbZCLKLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZCLKLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:11:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39797 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZCLKLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:11:45 -0400
Subject: Re: [PATCH 4/6] futex: Use current->time_slack_ns for rt tasks too
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20090312075559.9856.28822.stgit@Aeon>
References: <20090312075349.9856.83687.stgit@Aeon>
	 <20090312075559.9856.28822.stgit@Aeon>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 11:11:26 +0100
Message-Id: <1236852686.5090.113.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 00:55 -0700, Darren Hart wrote:
> RT tasks should set their timer slack to 0 on their own.  This patch removes
> the 'if (rt_task()) slack = 0;' block in futex_wait.

That wording makes me uncomfortable, either they do and this patch is
good, or they don't and you've now wrecked stuff :-)

A quick git grep suggests the latter..

> Build and boot tested on a 4 way Intel x86_64 workstation.  Passes basic
> pthread_mutex and PI tests out of ltp/testcases/realtime.
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
> 
>  kernel/futex.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index e149545..6579912 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1253,16 +1253,13 @@ retry:
>  		if (!abs_time)
>  			schedule();
>  		else {
> -			unsigned long slack;
> -			slack = current->timer_slack_ns;
> -			if (rt_task(current))
> -				slack = 0;
>  			hrtimer_init_on_stack(&t.timer,
>  					      clockrt ? CLOCK_REALTIME :
>  					      CLOCK_MONOTONIC,
>  					      HRTIMER_MODE_ABS);
>  			hrtimer_init_sleeper(&t, current);
> -			hrtimer_set_expires_range_ns(&t.timer, *abs_time, slack);
> +			hrtimer_set_expires_range_ns(&t.timer, *abs_time,
> +						     current->timer_slack_ns);
>  
>  			hrtimer_start_expires(&t.timer, HRTIMER_MODE_ABS);
>  			if (!hrtimer_active(&t.timer))
> 


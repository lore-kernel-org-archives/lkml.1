Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992Ab0ALKQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab0ALKQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 05:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837Ab0ALKQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 05:16:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:36295 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab0ALKQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 05:16:29 -0500
Subject: Re: [PATCH] sched: reassign prev and switch_count when 
 reacquire_kernel_lock() fail
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <2674af741001102238w7b0ddcadref00d345e2181d11@mail.gmail.com>
References: <2674af741001102238w7b0ddcadref00d345e2181d11@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 11:16:23 +0100
Message-ID: <1263291383.4244.109.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 14:38 +0800, Yong Zhang wrote:
> From 4c04fbbd43f3fef7a3b9471a0000c399c2e045ed Mon Sep 17 00:00:00 2001
> From: Yong Zhang <yong.zhang0@gmail.com>
> Date: Mon, 11 Jan 2010 14:21:25 +0800
> Subject: [PATCH] sched: reassign prev and switch_count when
> reacquire_kernel_lock() fail
> 
> Assume A->B schedule is processing, if B have acquired BKL before and
> it need reschedule this time. Then on B's context, it will go to
> need_resched_nonpreemptible for reschedule. But at this time, prev
> and switch_count are related to A. It's wrong and will lead to
> incorrect scheduler statistics.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Looks good, picked it up, thanks!

> ---
>  kernel/sched.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index c535cc4..4508fe7 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5530,8 +5530,11 @@ need_resched_nonpreemptible:
> 
>  	post_schedule(rq);
> 
> -	if (unlikely(reacquire_kernel_lock(current) < 0))
> +	if (unlikely(reacquire_kernel_lock(current) < 0)) {
> +		prev = rq->curr;
> +		switch_count = &prev->nivcsw;
>  		goto need_resched_nonpreemptible;
> +	}
> 
>  	preempt_enable_no_resched();
>  	if (need_resched())



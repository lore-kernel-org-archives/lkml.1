Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbZC1AAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbZC1AAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZC0X75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:59:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:53196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZC0X74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:59:56 -0400
Subject: Re: [PATCH 2/2] posix-timers: fix RLIMIT_CPU &&
 setitimer(CPUCLOCK_PROF)
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Lojkin <ia6432@inbox.ru>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <20090327000610.GA10108@redhat.com>
References: <20090327000610.GA10108@redhat.com>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 00:59:28 +0100
Message-Id: <1238198368.4039.320.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 01:06 +0100, Oleg Nesterov wrote:
> update_rlimit_cpu() tries to optimize out set_process_cpu_timer() in case
> when we already have CPUCLOCK_PROF timer which should expire first. But it
> uses cputime_lt() instead of cputime_gt().
> 
> Test case:
> 
> 	int main(void)
> 	{
> 		struct itimerval it = {
> 			.it_value = { .tv_sec = 1000 },
> 		};
> 
> 		assert(!setitimer(ITIMER_PROF, &it, NULL));
> 
> 		struct rlimit rl = {
> 			.rlim_cur = 1,
> 			.rlim_max = 1,
> 		};
> 
> 		assert(!setrlimit(RLIMIT_CPU, &rl));
> 
> 		for (;;)
> 			;
> 
> 		return 0;
> 	}
> 
> Without this patch, the task is not killed as RLIMIT_CPU demands.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Nice catch,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> --- 6.29/kernel/posix-cpu-timers.c~2_UPDATE_RLIM	2009-03-23 18:13:57.000000000 +0100
> +++ 6.29/kernel/posix-cpu-timers.c	2009-03-27 00:45:31.000000000 +0100
> @@ -18,7 +18,7 @@ void update_rlimit_cpu(unsigned long rli
>  
>  	cputime = secs_to_cputime(rlim_new);
>  	if (cputime_eq(current->signal->it_prof_expires, cputime_zero) ||
> -	    cputime_lt(current->signal->it_prof_expires, cputime)) {
> +	    cputime_gt(current->signal->it_prof_expires, cputime)) {
>  		spin_lock_irq(&current->sighand->siglock);
>  		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
>  		spin_unlock_irq(&current->sighand->siglock);
> 


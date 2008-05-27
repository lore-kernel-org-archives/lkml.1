Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbYE0R3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbYE0R3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYE0R3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:29:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbYE0R3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:29:47 -0400
Subject: Re: [PATCH] softlockup: fix NMI hangs due to lock race - 2.6.26-rc
	regression
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <483C4391.8040002@windriver.com>
References: <483C4391.8040002@windriver.com>
Content-Type: text/plain
Date: Tue, 27 May 2008 19:28:54 +0200
Message-Id: <1211909335.6463.296.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-27 at 12:23 -0500, Jason Wessel wrote:
> The touch_nmi_watchdog() routine on x86 ultimately calls
> touch_softlockup_watchdog().  The problem is that to touch the
> softlockup watchdog, the cpu_clock code has to be called which could
> involve multiple cpu locks and can lead to a hard hang if one of the
> locks is held by a processor that is not going to return anytime soon
> (such as could be the case with kgdb or perhaps even with some other
> kind of exception).
> 
> This patch causes the public version of the
> touch_softlockup_watchdog() to defer the cpu clock access to a later
> point.
> 
> The test case for this problem is to use the following kernel config
> options:
> 
> CONFIG_KGDB_TESTS=y
> CONFIG_KGDB_TESTS_ON_BOOT=y
> CONFIG_KGDB_TESTS_BOOT_STRING="V1F100I100000"
> 
> It should be noted that kgdb test suite and these options were not
> available until 2.6.26-rc2, so it was necessary to patch the kgdb 
> test suite during the bisection.
> 
> I would consider this patch a regression fix because the problem first
> appeared in commit 27ec4407790d075c325e1f4da0a19c56953cce23 when some
> logic was added to try to periodically sync the clocks.  It was
> possible to work around this particular problem by simply not
> performing the sync anytime the system was in a critical context.
> This was ok until commit 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd,
> which added config option CONFIG_HAVE_UNSTABLE_SCHED_CLOCK and some
> multi-cpu locks to sync the clocks.  It became clear that accessing
> this code from an nmi was the source of the lockups.  Avoiding the
> access to the low level clock code from an code inside the NMI
> processing also fixed the problem with the 27ec44... commit.


While I do not object to this approach, I ran into something similar
while poking at .25-rt.

How about we make sched_clock_cpu() use trylocks to update the ->clock
value, and on failure just return the ->clock without updating it?

> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> 
> ---
>  kernel/softlockup.c |   15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> --- a/kernel/softlockup.c
> +++ b/kernel/softlockup.c
> @@ -49,12 +49,17 @@ static unsigned long get_timestamp(int t
>  	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
>  }
>  
> -void touch_softlockup_watchdog(void)
> +static void __touch_softlockup_watchdog(void)
>  {
>  	int this_cpu = raw_smp_processor_id();
>  
>  	__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
>  }
> +
> +void touch_softlockup_watchdog(void)
> +{
> +	__raw_get_cpu_var(touch_timestamp) = 0;
> +}
>  EXPORT_SYMBOL(touch_softlockup_watchdog);
>  
>  void touch_all_softlockup_watchdogs(void)
> @@ -80,7 +85,7 @@ void softlockup_tick(void)
>  	unsigned long now;
>  
>  	if (touch_timestamp == 0) {
> -		touch_softlockup_watchdog();
> +		__touch_softlockup_watchdog();
>  		return;
>  	}
>  
> @@ -95,7 +100,7 @@ void softlockup_tick(void)
>  
>  	/* do not print during early bootup: */
>  	if (unlikely(system_state != SYSTEM_RUNNING)) {
> -		touch_softlockup_watchdog();
> +		__touch_softlockup_watchdog();
>  		return;
>  	}
>  
> @@ -214,7 +219,7 @@ static int watchdog(void *__bind_cpu)
>  	sched_setscheduler(current, SCHED_FIFO, &param);
>  
>  	/* initialize timestamp */
> -	touch_softlockup_watchdog();
> +	__touch_softlockup_watchdog();
>  
>  	set_current_state(TASK_INTERRUPTIBLE);
>  	/*
> @@ -223,7 +228,7 @@ static int watchdog(void *__bind_cpu)
>  	 * debug-printout triggers in softlockup_tick().
>  	 */
>  	while (!kthread_should_stop()) {
> -		touch_softlockup_watchdog();
> +		__touch_softlockup_watchdog();
>  		schedule();
>  
>  		if (kthread_should_stop())


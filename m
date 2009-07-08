Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbZGHAxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbZGHAxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 20:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZGHAxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 20:53:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52333 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbZGHAxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 20:53:30 -0400
Date: Wed, 8 Jul 2009 02:50:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] sched: Remove SYSTEM_RUNNING checks from
	cond_resched*()
Message-ID: <20090708005000.GA12380@redhat.com>
References: <20090707235812.GA12824@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707235812.GA12824@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08, Anton Vorontsov wrote:
>
> but I'm curious if removing the checks makes sense
> nowadays.
...
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6560,8 +6560,7 @@ static void __cond_resched(void)
>
>  int __sched _cond_resched(void)
>  {
> -	if (need_resched() && !(preempt_count() & PREEMPT_ACTIVE) &&
> -					system_state == SYSTEM_RUNNING) {
> +	if (need_resched() && !(preempt_count() & PREEMPT_ACTIVE)) {
>  		__cond_resched();
>  		return 1;
>  	}

and, with CONFIG_PREEMPT preempt_schedule() does not check system_state,
so it looks really strange cond_resched() does check SYSTEM_RUNNING.



debug_smp_processor_id() looks strange too:
	
	/*
	 * It is valid to assume CPU-locality during early bootup:
	 */
	if (system_state != SYSTEM_RUNNING)
		goto out;

this doesn't look right, smp_init() is called before we set
SYSTEM_RUNNING.

Hmm, and

	/*
	 * Kernel threads bound to a single CPU can safely use
	 * smp_processor_id():
	 */
	if (cpumask_equal(&current->cpus_allowed, cpumask_of(this_cpu)))
		goto out;

perhaps this should use PF_THREAD_BOUND ?

Oleg.


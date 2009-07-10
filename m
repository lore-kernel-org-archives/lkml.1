Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZGJPA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZGJPA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZGJPAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:00:50 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:42253 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbZGJPAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:00:49 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/2] sched: Drop the need_resched() loop from
 cond_resched()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247237391-5352-1-git-send-email-fweisbec@gmail.com>
References: <1247237391-5352-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 17:00:45 +0200
Message-Id: <1247238045.7529.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 16:49 +0200, Frederic Weisbecker wrote:
> The schedule() function is a loop that reschedules the current task
> while the TIF_NEED_RESCHED flag is set:
> 
> void schedule(void)
> {
> need_resched:
> 	/* schedule code */
> 	if (need_resched())
> 		goto need_resched;
> }
> 
> And cond_resched() repeat this loop:
> 
> do {
> 	add_preempt_count(PREEMPT_ACTIVE);
> 	schedule();
> 	sub_preempt_count(PREEMPT_ACTIVE);
> } while(need_resched());
> 
> This loop is needless because schedule() already did the check and
> nothing can set TIF_NEED_RESCHED between schedule() exit and the loop
> check in need_resched().
> 
> Then remove this needless loop.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  kernel/sched.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 4d1e387..87ecac1 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6613,11 +6613,9 @@ static void __cond_resched(void)
>  	 * PREEMPT_ACTIVE, which could trigger a second
>  	 * cond_resched() call.
>  	 */
> -	do {
> -		add_preempt_count(PREEMPT_ACTIVE);
> -		schedule();
> -		sub_preempt_count(PREEMPT_ACTIVE);
> -	} while (need_resched());
> +	add_preempt_count(PREEMPT_ACTIVE);
> +	schedule();
> +	sub_preempt_count(PREEMPT_ACTIVE);
>  }
>  
>  int __sched _cond_resched(void)


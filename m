Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZIRTzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZIRTzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZIRTzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:55:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48805 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbZIRTy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:54:59 -0400
Date: Fri, 18 Sep 2009 21:54:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Langsdorf <mark.langsdorf@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Prevent immediate process rescheduling
Message-ID: <20090918195455.GC11726@elte.hu>
References: <200909181449.12311.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909181449.12311.mark.langsdorf@amd.com>
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


(fixed the Cc: lines)

* Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> Prevent the scheduler from immediately rescheduling a process
> that just yielded if there is another process available.
> 
> Originally suggested by Mike Galbraith (efault@gmx.de).
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> ---
>  kernel/sched_fair.c |   16 +++++++++++++++-
>  1 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 652e8bd..4fad08f 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -353,11 +353,25 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
>  {
>  	struct rb_node *left = cfs_rq->rb_leftmost;
> +	struct sched_entity *se, *curr;
>  
>  	if (!left)
>  		return NULL;
>  
> -	return rb_entry(left, struct sched_entity, run_node);
> +	se = rb_entry(left, struct sched_entity, run_node);
> +	curr = &current->se;
> +
> +	/* 
> +	 * Don't select the entity who just tried to schedule away
> +	 * if there's another entity available.
> +	 */
> +	if (unlikely(se == curr && cfs_rq->nr_running > 1)) {
> +		struct rb_node *next_node = rb_next(&curr->run_node);
> +		if (next_node)
> +			se = rb_entry(next_node, struct sched_entity, run_node);
> +	}
> +
> +	return se;
>  }

I suspect some real workload is the motivation of this - what is that 
workload?

	Ingo

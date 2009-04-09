Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbZDIF72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbZDIF72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZDIF7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:59:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:49366 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZDIF7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:59:14 -0400
Subject: Re: sched: remove redundant hierarchy walk in check_preempt_wakeup
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0904081520320.30317@kitami.corp.google.com>
References: <alpine.DEB.1.00.0904081520320.30317@kitami.corp.google.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Apr 2009 08:00:53 +0200
Message-Id: <1239256853.13185.1131.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 15:29 -0700, Paul Turner wrote:
> Hi Ingo, Peter,
> 
> In check_preempt_wakeup we walk up until both entities are queued on the
> same cfs_rq.  After the iteration of vruntime vs wall-clock pre-emption 
> changes the current check now checks at every level of the tree above 
> this.  However, unless I'm missing something at this point they should
> have a common parent.

Yes, you're right, and them having a common parent means the rest of the
preemption checks will be against itself.

> --
> 
> sched: remove redundant hierarchy walk in check_preempt_wakeup
> 
> Under group scheduling we traverse up until we are at common siblings to make
> the wakeup comparison on.
> 
> At this point however, they should have the same parent so continuing to check
> up the tree is redundant.
> 
> Signed-off-by: Paul Turner <pjt@google.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  kernel/sched_fair.c |   13 +++----------
>  1 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 3816f21..5f9650e 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1487,17 +1487,10 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
>  
>  	find_matching_se(&se, &pse);
>  
> -	while (se) {
> -		BUG_ON(!pse);
> +	BUG_ON(!pse);
>  
> -		if (wakeup_preempt_entity(se, pse) == 1) {
> -			resched_task(curr);
> -			break;
> -		}
> -
> -		se = parent_entity(se);
> -		pse = parent_entity(pse);
> -	}
> +	if (wakeup_preempt_entity(se, pse) == 1)
> +		resched_task(curr);
>  }
>  
>  static struct task_struct *pick_next_task_fair(struct rq *rq)

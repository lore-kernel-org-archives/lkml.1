Return-Path: <linux-kernel-owner+w=401wt.eu-S1762402AbYF3NZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762402AbYF3NZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbYF3NZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:25:18 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:63857 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbYF3NZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:25:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hNOG3E8+Dz6NvYA8Xqh3C6dbAtu15z6EAGQLe0efJy4T0JQSgAOQTWNMtgb801km0d
         311+3htD1uXjgSwF6avYC11q1H82x0wYnwUFAt265h0sZ/grJAyuzIHMFzS4njY1RYIu
         qRwbyrZo1pAoklaVd0P+QCg5F3iBZqgyhgptY=
Date: Mon, 30 Jun 2008 15:25:12 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueues: implement flush_work()
Message-ID: <20080630132512.GA2663@ami.dom.local>
References: <20080629144926.GA4347@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080629144926.GA4347@tv-sign.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 06:49:26PM +0400, Oleg Nesterov wrote:
...
> --- 26-rc2/kernel/workqueue.c~WQ_2_FLUSH_WORK	2008-06-12 21:28:13.000000000 +0400
> +++ 26-rc2/kernel/workqueue.c	2008-06-29 18:20:33.000000000 +0400
> @@ -399,6 +399,52 @@ void flush_workqueue(struct workqueue_st
>  }
>  EXPORT_SYMBOL_GPL(flush_workqueue);
>  
> +/**
> + * flush_work - block until a work_struct's callback has terminated
> + * @work: the work which is to be flushed
> + *
> + * It is expected that, prior to calling flush_work(), the caller has
> + * arranged for the work to not be requeued, otherwise it doesn't make
> + * sense to use this function.
> + */

I missed this before, and probably it's not required, but "Returns..."
could be added here.

> +int flush_work(struct work_struct *work)
> +{
> +	struct cpu_workqueue_struct *cwq;
> +	struct list_head *prev;
> +	struct wq_barrier barr;
> +
> +	might_sleep();
> +	cwq = get_wq_data(work);
> +	if (!cwq)
> +		return 0;
> +
> +	prev = NULL;
> +	spin_lock_irq(&cwq->lock);
> +	if (!list_empty(&work->entry)) {
> +		/*
> +		 * See the comment near try_to_grab_pending()->smp_rmb().
> +		 * If it was re-queued under us we are not going to wait.
> +		 */
> +		smp_rmb();
> +		if (unlikely(cwq != get_wq_data(work)))
> +			goto out;
> +		prev = &work->entry;
> +	} else {

Probably it doesn't matter too much, but one little doubt: don't we
need (for consistency) smp_rmb() for this branch as well? It seems
this cwq could be read out of order here too.

> +		if (cwq->current_work != work)
> +			goto out;
> +		prev = &cwq->worklist;
> +	}
> +	insert_wq_barrier(cwq, &barr, prev->next);
> +out:
> +	spin_unlock_irq(&cwq->lock);
> +	if (!prev)
> +		return 0;
> +
> +	wait_for_completion(&barr.done);
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(flush_work);
> +
>  /*
>   * Upon a successful return (>= 0), the caller "owns" WORK_STRUCT_PENDING bit,
>   * so this work can't be re-armed in any way.
> 

Otherwise, all looks correct to me as before.

Regards,
Jarek P.

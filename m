Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZHUAVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZHUAVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 20:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932122AbZHUAVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 20:21:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755311AbZHUAVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 20:21:35 -0400
Date: Thu, 20 Aug 2009 17:20:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       htejun@gmail.com, bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       jens.axboe@oracle.com
Subject: Re: [PATCH 2/6] workqueue: add support for lazy workqueues
Message-Id: <20090820172027.cdc41d1e.akpm@linux-foundation.org>
In-Reply-To: <1250763466-24282-5-git-send-email-jens.axboe@oracle.com>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
	<1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
	<1250763466-24282-3-git-send-email-jens.axboe@oracle.com>
	<1250763466-24282-4-git-send-email-jens.axboe@oracle.com>
	<1250763466-24282-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 12:17:39 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> Lazy workqueues are like normal workqueues, except they don't
> start a thread per CPU by default. Instead threads are started
> when they are needed, and exit when they have been idle for
> some time.
> 
>
> ...
>
> @@ -280,7 +309,34 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
>  		trace_workqueue_execution(cwq->thread, work);
>  		cwq->current_work = work;
>  		list_del_init(cwq->worklist.next);
> +		cpu = smp_processor_id();
>  		spin_unlock_irq(&cwq->lock);
> +		did_work = 1;
> +
> +		/*
> +		 * If work->cpu isn't us, then we need to create the target
> +		 * workqueue thread (if someone didn't already do that) and
> +		 * move the work over there.
> +		 */
> +		if ((cwq->wq->flags & WQ_F_LAZY) && work->cpu != cpu) {
> +			struct cpu_workqueue_struct *__cwq;
> +			struct task_struct *p;
> +			int err;
> +
> +			__cwq = wq_per_cpu(cwq->wq, work->cpu);
> +			p = __cwq->thread;
> +			if (!p)
> +				err = create_workqueue_thread(__cwq, work->cpu);
> +			p = __cwq->thread;
> +			if (p) {
> +				if (work->cpu >= 0)

It's an unsigned int.  This test is always true.

> +					kthread_bind(p, work->cpu);

I wonder what happens if work->cpu isn't online any more.

> +				insert_work(__cwq, work, &__cwq->worklist);
> +				wake_up_process(p);
> +				goto out;
> +			}
> +		}
> +
>  
>  		BUG_ON(get_wq_data(work) != cwq);
>  		work_clear_pending(work);
>
> ...
>

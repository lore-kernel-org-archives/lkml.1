Return-Path: <linux-kernel-owner+w=401wt.eu-S965337AbXDYMOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337AbXDYMOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964780AbXDYMOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:14:51 -0400
Received: from mx10.go2.pl ([193.17.41.74]:36718 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965337AbXDYMOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:14:50 -0400
Date: Wed, 25 Apr 2007 14:20:38 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070425122038.GE1613@ff.dom.local>
References: <20070419002548.72689f0e.akpm@linux-foundation.org> <20070419102122.GA93@tv-sign.ru> <20070420092201.GC1695@ff.dom.local> <20070420170836.GB470@tv-sign.ru> <20070423090030.GC1684@ff.dom.local> <20070423163312.GA129@tv-sign.ru> <20070424115322.GA2423@ff.dom.local> <20070424185537.GA5029@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424185537.GA5029@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2 cents more...

On Tue, Apr 24, 2007 at 10:55:37PM +0400, Oleg Nesterov wrote:
...
> --- OLD/kernel/workqueue.c~1_CRDW	2007-04-13 17:43:23.000000000 +0400
> +++ OLD/kernel/workqueue.c	2007-04-24 22:41:15.000000000 +0400
> @@ -242,11 +242,11 @@ static void run_workqueue(struct cpu_wor
...
>  
> +static void needs_a_good_name(struct workqueue_struct *wq,

If you don't prefer something original, I think this
could be something like:

wait_on_work_[on_each | each_cpu | per_cpu] etc.

...
>  /**
> @@ -532,22 +534,34 @@ EXPORT_SYMBOL(flush_scheduled_work);
>  /**
>   * cancel_rearming_delayed_work - kill off a delayed work whose handler rearms the delayed work.
>   * @dwork: the delayed work struct
> - *
> - * Note that the work callback function may still be running on return from
> - * cancel_delayed_work(). Run flush_workqueue() or cancel_work_sync() to wait
> - * on it.

Probably there should be added a few words about changes.

>   */
>  void cancel_rearming_delayed_work(struct delayed_work *dwork)
>  {
> -	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
> -
> -	/* Was it ever queued ? */
> -	if (cwq != NULL) {
> -		struct workqueue_struct *wq = cwq->wq;
> -
> -		while (!cancel_delayed_work(dwork))
> -			flush_workqueue(wq);
> -	}
> +	struct work_struct *work = &dwork->work;
> +	struct cpu_workqueue_struct *cwq = get_wq_data(work);
> +	int retry;
> +
> +	if (!cwq)
> +		return;
> +
> +	do {
> +		retry = 1;
> +		spin_lock_irq(&cwq->lock);
> +		/* CPU_DEAD in progress may change cwq */
> +		if (likely(cwq == get_wq_data(work))) {
> +			list_del_init(&work->entry);
> +			__set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
> +			retry = try_to_del_timer_sync(&dwork->timer) < 0;
> +		}

		else
			retry = 0;

> +		spin_unlock_irq(&cwq->lock);
> +	} while (unlikely(retry));
...

Cheers,
Jarek P.

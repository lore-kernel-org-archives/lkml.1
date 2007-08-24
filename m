Return-Path: <linux-kernel-owner+w=401wt.eu-S934174AbXHXCbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174AbXHXCbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 22:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932669AbXHXCb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 22:31:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:58902 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621AbXHXCb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 22:31:26 -0400
Message-ID: <46CEEA94.2070902@windriver.com>
Date: Fri, 24 Aug 2007 10:26:28 -0400
From: taoyue <yue.tao@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Katz <jeremy.katz@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] sigqueue_free: fix the race with collect_signal()
References: <20070823134538.GA1358@tv-sign.ru>
In-Reply-To: <20070823134538.GA1358@tv-sign.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Aug 2007 02:29:41.0868 (UTC) FILETIME=[A05F8AC0:01C7E5F6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> Spotted by taoyue <yue.tao@windriver.com> and Jeremy Katz <jeremy.katz@windriver.com>.
>
> collect_signal:				sigqueue_free:
>
> 	list_del_init(&first->list);
> 						if (!list_empty(&q->list)) {
> 							// not taken
> 						}
> 						q->flags &= ~SIGQUEUE_PREALLOC;
>
> 	__sigqueue_free(first);			__sigqueue_free(q);
>
> Now, __sigqueue_free() is called twice on the same "struct sigqueue" with the
> obviously bad implications.
>
> In particular, this double free breaks the array_cache->avail logic, so the
> same sigqueue could be "allocated" twice, and the bug can manifest itself via
> the "impossible" BUG_ON(!SIGQUEUE_PREALLOC) in sigqueue_free/send_sigqueue.
>
> Hopefully this can explain these mysterious bug-reports, see
>
> 	http://marc.info/?t=118766926500003
> 	http://marc.info/?t=118466273000005
>
> Alexey Dobriyan reports this patch makes the difference for the testcase, but
> nobody has an access to the application which opened the problems originally.
>
> Also, this patch removes tasklist lock/unlock, ->siglock is enough.
>
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
>
> --- t/kernel/signal.c~SQFREE	2007-08-22 20:06:31.000000000 +0400
> +++ t/kernel/signal.c	2007-08-23 16:02:57.000000000 +0400
> @@ -1297,20 +1297,19 @@ struct sigqueue *sigqueue_alloc(void)
>  void sigqueue_free(struct sigqueue *q)
>  {
>  	unsigned long flags;
> +	spinlock_t *lock = &current->sighand->siglock;
> +
>  	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
>  	/*
>  	 * If the signal is still pending remove it from the
> -	 * pending queue.
> +	 * pending queue. We must hold ->siglock while testing
> +	 * q->list to serialize with collect_signal().
>  	 */
> -	if (unlikely(!list_empty(&q->list))) {
> -		spinlock_t *lock = &current->sighand->siglock;
> -		read_lock(&tasklist_lock);
> -		spin_lock_irqsave(lock, flags);
> -		if (!list_empty(&q->list))
> -			list_del_init(&q->list);
> -		spin_unlock_irqrestore(lock, flags);
> -		read_unlock(&tasklist_lock);
> -	}
> +	spin_lock_irqsave(lock, flags);
> +	if (!list_empty(&q->list))
> +		list_del_init(&q->list);
> +	spin_unlock_irqrestore(lock, flags);
> +
>  	q->flags &= ~SIGQUEUE_PREALLOC;
>  	__sigqueue_free(q);
>  }
>
>
>   
    Applying previous patch，it seems likely that the __sigqueue_free() is also called twice.

collect_signal:				sigqueue_free:

	list_del_init(&first->list);
                                        spin_lock_irqsave(lock, flags);
                                        if (!list_empty(&q->list))
                                              list_del_init(&q->list);
                                        spin_unlock_irqrestore(lock, flags);
                                        q->flags &= ~SIGQUEUE_PREALLOC;

        __sigqueue_free(first);		__sigqueue_free(q);



yue.tao

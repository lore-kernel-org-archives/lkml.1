Return-Path: <linux-kernel-owner+w=401wt.eu-S1765298AbXHXHqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765298AbXHXHqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 03:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbXHXHq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 03:46:29 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42706 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbXHXHq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 03:46:28 -0400
Date: Fri, 24 Aug 2007 11:45:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: taoyue <yue.tao@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] sigqueue_free: fix the race with collect_signal()
Message-ID: <20070824074558.GA86@tv-sign.ru>
References: <20070823134538.GA1358@tv-sign.ru> <46CEEA94.2070902@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CEEA94.2070902@windriver.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, taoyue wrote:
>
> Oleg Nesterov wrote:
> >
> >--- t/kernel/signal.c~SQFREE	2007-08-22 20:06:31.000000000 +0400
> >+++ t/kernel/signal.c	2007-08-23 16:02:57.000000000 +0400
> >@@ -1297,20 +1297,19 @@ struct sigqueue *sigqueue_alloc(void)
> > void sigqueue_free(struct sigqueue *q)
> > {
> > 	unsigned long flags;
> >+	spinlock_t *lock = &current->sighand->siglock;
> >+
> > 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
> > 	/*
> > 	 * If the signal is still pending remove it from the
> >-	 * pending queue.
> >+	 * pending queue. We must hold ->siglock while testing
> >+	 * q->list to serialize with collect_signal().
> > 	 */
> >-	if (unlikely(!list_empty(&q->list))) {
> >-		spinlock_t *lock = &current->sighand->siglock;
> >-		read_lock(&tasklist_lock);
> >-		spin_lock_irqsave(lock, flags);
> >-		if (!list_empty(&q->list))
> >-			list_del_init(&q->list);
> >-		spin_unlock_irqrestore(lock, flags);
> >-		read_unlock(&tasklist_lock);
> >-	}
> >+	spin_lock_irqsave(lock, flags);
> >+	if (!list_empty(&q->list))
> >+		list_del_init(&q->list);
> >+	spin_unlock_irqrestore(lock, flags);
> >+
> > 	q->flags &= ~SIGQUEUE_PREALLOC;
> > 	__sigqueue_free(q);
> > }
> >
> >
> >  
>    Applying previous patch???it seems likely that the __sigqueue_free() is 
>    also called twice.
> 
> collect_signal:				sigqueue_free:
> 
> 	list_del_init(&first->list);
>                                        spin_lock_irqsave(lock, flags);
                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                                        if (!list_empty(&q->list))
>                                              list_del_init(&q->list);
>                                        spin_unlock_irqrestore(lock, flags);
>                                        q->flags &= ~SIGQUEUE_PREALLOC;
> 
>        __sigqueue_free(first);		__sigqueue_free(q);

collect_signal() is always called under ->siglock which is also taken by
sigqueue_free(), so this is not possible.

Basically, this patch is the same one-liner I sent you before

	http://marc.info/?l=linux-kernel&m=118772206603453&w=2

(Thanks for the additional testing and report, btw).

P.S. It would be nice to know if this patch solves the problems reported
by Jeremy, but his email is disabled.

Oleg.


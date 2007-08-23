Return-Path: <linux-kernel-owner+w=401wt.eu-S933233AbXHWWHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbXHWWHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933084AbXHWWGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:06:52 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:45579 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933067AbXHWWGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:06:51 -0400
Date: Fri, 24 Aug 2007 02:05:28 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Katz <jeremy.katz@windriver.com>, taoyue <yue.tao@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] sigqueue_free: fix the race with collect_signal()
Message-ID: <20070823220528.GA308@tv-sign.ru>
References: <20070823134538.GA1358@tv-sign.ru> <46CDFDD2.4010600@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CDFDD2.4010600@us.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23, Sukadev Bhattiprolu wrote:
>
> Oleg Nesterov wrote:
> >Spotted by taoyue <yue.tao@windriver.com> and Jeremy Katz 
> ><jeremy.katz@windriver.com>.
> >
> >collect_signal:				sigqueue_free:
> >
> >	list_del_init(&first->list);
> >						if (!list_empty(&q->list)) {
> >							// not taken
> >						}
> >						q->flags &= 
> >						~SIGQUEUE_PREALLOC;
> >
> >	__sigqueue_free(first);			__sigqueue_free(q);
> >
> >Now, __sigqueue_free() is called twice on the same "struct sigqueue" with 
> >the
> >obviously bad implications.
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
> >  
> Hmm, but the existing code _does_ take the siglock here. Is that not 
> sufficient ?

Yes, it does, and this is sufficient, so the patch removes tasklist_lock.

> Isn't the first list_empty() check without lock only an optimization for 
> the common
> case ?

Yes, this is optimization, but I strongly believe it is wrong. Please look
at the race description above.

!list_empty(&q->list) does _not_ necessary mean that q is not used and we can
free it. It is possible that collect_signal() just removed this sigqueue from
list (list_empty(&q->list) becomes true) and going to free it.

The whole point is: we can't check list_empty() without ->siglock, this is
racy, and leads to double-free.

Oleg.


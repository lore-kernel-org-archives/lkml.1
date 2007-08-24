Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbXHXLGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbXHXLGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 07:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbXHXLG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 07:06:26 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51725 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845AbXHXLGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 07:06:25 -0400
Date: Fri, 24 Aug 2007 15:08:36 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: taoyue <yue.tao@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] sigqueue_free: fix the race with collect_signal()
Message-ID: <20070824110836.GA74@tv-sign.ru>
References: <20070823134538.GA1358@tv-sign.ru> <46CEEA94.2070902@windriver.com> <20070824074558.GA86@tv-sign.ru> <46CF4DCB.6030304@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CF4DCB.6030304@windriver.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, taoyue wrote:
>
> Oleg Nesterov wrote:
> >>
> >>collect_signal:				sigqueue_free:
> >>
> >>	list_del_init(&first->list);
> >>                                       spin_lock_irqsave(lock, flags);
> >>    
> >                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >  
> >>                                       if (!list_empty(&q->list))
> >>                                             list_del_init(&q->list);
> >>                                       spin_unlock_irqrestore(lock, 
> >>                                       flags);
> >>                                       q->flags &= ~SIGQUEUE_PREALLOC;
> >>
> >>       __sigqueue_free(first);		__sigqueue_free(q);
> >>    
> >
> >collect_signal() is always called under ->siglock which is also taken by
> >sigqueue_free(), so this is not possible.
> >
> >Basically, this patch is the same one-liner I sent you before
> >
> >	http://marc.info/?l=linux-kernel&m=118772206603453&w=2
> >
> >(Thanks for the additional testing and report, btw).
> >
> >P.S. It would be nice to know if this patch solves the problems reported
> >by Jeremy, but his email is disabled.
> >
> >Oleg.
> >
> >  
> I know, using current->sighand->siglock to prevent one sigqueue
> is free twice. I want to know whether it is possible that the two
> function is called in different thread. If that, the spin_lock is useless.

Not sure I understand. Yes, it is possible they are called by 2 different
threads, that is why we had a race. But all threads in the same thread
group have the same ->sighand, and thus the same ->sighand->siglock.

Oleg.


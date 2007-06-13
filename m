Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbXFMWgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbXFMWgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbXFMWgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:36:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:52014 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484AbXFMWgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:36:24 -0400
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
	internal errnos
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <20070613151530.GA232@tv-sign.ru>
References: <87hcplvdkl.wl%takeuchi_satoru@jp.fujitsu.com>
	 <20070606105900.DE5E94D0592@magilla.localdomain>
	 <20070613151530.GA232@tv-sign.ru>
Content-Type: text/plain
Date: Thu, 14 Jun 2007 08:36:00 +1000
Message-Id: <1181774160.14818.333.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 19:15 +0400, Oleg Nesterov wrote:
> 
> This breaks cancel_freezing(). Somehow we should clear TIF_SIGPENDING
> for kernel threads. Otherwise we may have subtle failures if
> try_to_freeze_tasks() fails.

The freezer is crap... news at 11. Maybe a quick hack would be to let it
clear sigpending if tsk->mm == NULL but that's ugly. Note that there's
anything pretty about the freezer anyway...

> Also, whith this change do_sigaction()->recalc_sigpending_and_wake()
> doesn't make sense any longer, yes?

Well.. why was it _and_wake() in the first place anyway ? Or do I miss
something ? Why would we need to wake a thread for which we are removing
signals ?

What about something like:

			do {
				rm_from_queue_full(&mask, &t->pending);
-				recalc_sigpending_and_wake(t);
				t = next_thread(t);
			} while (t != current);
+			recalc_sigpending();

> > @@ -385,7 +391,8 @@ int dequeue_signal(struct task_struct *t
> >                       }
> >               }
> >       }
> > -     recalc_sigpending_tsk(tsk);
> > +     if (likely(tsk == current))
> > +             recalc_sigpending();
> 
> In theory, flush_signals(t) needs a similar change. However, it is
> always
> called with t == current. Perhaps it makes sense to make it
> flush_signals(void) ?

Agreed.

> Do you see any valid usage of flush_signals(t) when t != current ?
> 
> (Actually, imho the same is true for dequeue_signal(). Except for
> signalfd.c
>  dequeue_signal() should operate on current. Perhaps it would be a bit
> cleaner
>  to have dequeue_signal_tsk(tsk) and dequeue_signal(void), the latter
> does
>  recalc_sigpending).

That's been part of the discussion so far ... so yes, maybe. I also
think dequeue_signal_tsk would then only dequeue shared signals... But
then, that means signalfd would have to do a if (tsk == current) to
know which one to call...

So at the end of the day, easier to test it inside dequeue_signal().

Ben.



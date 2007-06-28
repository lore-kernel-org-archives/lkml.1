Return-Path: <linux-kernel-owner+w=401wt.eu-S1762049AbXF1OM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762049AbXF1OM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbXF1OMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:12:43 -0400
Received: from mail.screens.ru ([213.234.233.54]:53716 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926AbXF1OMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:12:41 -0400
Date: Thu, 28 Jun 2007 18:12:46 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Jeff Layton <jlayton@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] RFC: have tcp_recvmsg() check kthread_should_stop() and treat it as if it were signalled
Message-ID: <20070628141246.GA95@tv-sign.ru>
References: <20070608123527.9b4cdafe.jlayton@redhat.com> <E1HwpmG-0008LW-00@gondolin.me.apana.org.au> <20070609070826.7bd3480c.jlayton@redhat.com> <a781481a0706251241n36126456x7f4b445a86d1a68f@mail.gmail.com> <20070626115449.GA92@tv-sign.ru> <a781481a0706261553i1e65e620o884708d0b068b0f8@mail.gmail.com> <20070627122437.GA158@tv-sign.ru> <a781481a0706271744i9181641sff43e2053dde0f9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0706271744i9181641sff43e2053dde0f9@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(trimmed the cc: list)

On 06/28, Satyam Sharma wrote:
>
> On 6/27/07, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> >
> >Contrary, I believe we should avoid signals when it
> >comes to kernel threads.
>
> And I agree, but there's quite a subtle difference between signals being
> used like they normally are, and this case here. Fact is, there is simply
> no other way to break out of certain functions (if there was, I would've
> preferred that myself).
>
> In fact, what I'm proposing is that kthreads should *not* be tinkering
> with (flushing, handling, dequeueing, whatever) signals at all, because
> like you mentioned, if they do that, it's possible that the TIF_SIGPENDING
> could get lost.

But we do have kthreads which call dequeue_signal(). And perhaps some
kthread treats SIGKILL as "urgent exit with a lot of printks" while
kthread_should_stop() means "exit gracefully".

> >I am talking about the case
> >when wait_event_interruptible() should not fail (unless something bad
> >happens) inside the "while (!kthread_should_stop())" loop.
> >Note also that kthread could use TASK_INTERRUPTIBLE sleep
> >[...] and because it knows that all signals are ignored.
>
> Ok, I think you're saying that if a kthread used wait_event_interruptible
> (and was not expecting signals, because it ignores them), then bad
> things (say exit in inconsistent state, etc) will happen if we break that
> wait_event_interruptible unexpectedly.

No. Of course, kthread should check the error and doesn't exit in
inconsistent state.

The question is: why should we break (say) tcp_recvmsg() inside
"while (!kthread_should_stop())" loop if it is supposed to succeed
unless something bad happens? (I mean, we may have a kthread which
doesn't expect the failure unless something bad happens).

OK, let me give a silly example. The correctly written kthread should check
the result of kmalloc(), yes? kthread(k) means that k should exit anyway, yes?
So let's change kthread_stop(k) to also set TIF_MEMDIE, this means that
__alloc_pages() will fail quickly when get_page_from_freelist() doesn't
succeed, but won't start pageout() which may take a while. Please don't
explain me why this suggestion is bad :), I am just trying to illustrate
my point.

I believe kthread_stop() should not send the signal. Just because it could
be actually dequeued by kthread, and it may have some special meaning for
this kthread.

Perhaps it makes sense to do signal_wake_up() (sets TIF_SIGPENDING and wakes
up), recalc_sigpending() could be changed to take kthread_should_stop() into
account (so TIF_SIGPENDING can't be cleared). Once again, I _personally_ do
not like this too much, but yes, I see your point, and I can't say such a
change is "wrong".

Hmm... actually, such a change breaks the

	while (signal_pending(current))
		dequeue_signal_and_so_something();

loop, see jffs2_garbage_collect_thread() for example.

In short, I think that kthread_stop() + TIF_SIGPENDING should be a special
case, the signal should be sent explicitly before kthread_stop(), like
cifs does. After all, the caller of kthread_stop(k) should know what and
why k does.

In any case, that kind of the changes can break things, just because
this means API change.

> And thirdly, what I'm proposing is putting the check for checking the
> SIGKILL in kthread_should_stop itself, in /addition/ to the
> kthread_stop_info.k == current check.

This is what I can't understand completely. Why should we check SIGKILL
or signal_pending() in addition to kthread_stop_info.k, what is the point?

Oleg.


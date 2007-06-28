Return-Path: <linux-kernel-owner+w=401wt.eu-S1764289AbXF1Pof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764289AbXF1Pof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbXF1Po2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:44:28 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:58733 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbXF1Po1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=soIsNo1hqCO62uGJwjk9e+el18JhX6JDy3HqHJ6kLgm8XfVkfyZsWyKjMntBz3JKElehYEhINahosVaZ8oSVv4AOdP82gbD3+hh7sy6u3LP+XmiXkuASKwbjGT0uSq2GOjXGo4qba4IFEgraCaNjL0JiTNmQh30HBCD+FxrF0io=
Message-ID: <a781481a0706280844l7eec6067gd576d88619463fe9@mail.gmail.com>
Date: Thu, 28 Jun 2007 21:14:24 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [PATCH] RFC: have tcp_recvmsg() check kthread_should_stop() and treat it as if it were signalled
Cc: "Jeff Layton" <jlayton@redhat.com>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20070628141246.GA95@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070608123527.9b4cdafe.jlayton@redhat.com>
	 <E1HwpmG-0008LW-00@gondolin.me.apana.org.au>
	 <20070609070826.7bd3480c.jlayton@redhat.com>
	 <a781481a0706251241n36126456x7f4b445a86d1a68f@mail.gmail.com>
	 <20070626115449.GA92@tv-sign.ru>
	 <a781481a0706261553i1e65e620o884708d0b068b0f8@mail.gmail.com>
	 <20070627122437.GA158@tv-sign.ru>
	 <a781481a0706271744i9181641sff43e2053dde0f9@mail.gmail.com>
	 <20070628141246.GA95@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/07, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> (trimmed the cc: list)
> On 06/28, Satyam Sharma wrote:
> > On 6/27/07, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> > >
> > >Contrary, I believe we should avoid signals when it
> > >comes to kernel threads.
> >
> > And I agree, but there's quite a subtle difference between signals being
> > used like they normally are, and this case here. Fact is, there is simply
> > no other way to break out of certain functions (if there was, I would've
> > preferred that myself).
> >
> > In fact, what I'm proposing is that kthreads should *not* be tinkering
> > with (flushing, handling, dequeueing, whatever) signals at all, because
> > like you mentioned, if they do that, it's possible that the TIF_SIGPENDING
> > could get lost.
>
> But we do have kthreads which call dequeue_signal(). And perhaps some
> kthread treats SIGKILL as "urgent exit with a lot of printks" while
> kthread_should_stop() means "exit gracefully".
> [..]
> I believe kthread_stop() should not send the signal. Just because it could
> be actually dequeued by kthread, and it may have some special meaning for
> this kthread.
> [...]
> Hmm... actually, such a change breaks the
>
>         while (signal_pending(current))
>                 dequeue_signal_and_so_something();
>
> loop, see jffs2_garbage_collect_thread() for example.
>
> In short, I think that kthread_stop() + TIF_SIGPENDING should be a special
> case, the signal should be sent explicitly before kthread_stop(), like
> cifs does.

The existence of such kthreads (that dabble in signals, although I guess
everybody here agrees kernel threads have no business dabbling in them)
is the *only* reason I didn't submit my proposal as an actual patch :-)

Perhaps "one day" we'll clean up all such cases, and fix up kthread
semantics to simply outlaw signal-handling in kernel threads (I just
can't convince myself there could be a good justifiable reason to do
that). When that's done, and seeing that kthreadd_setup() does
ignore_signals(), kthread_stop() could become simply force_sig() ...

> [...]
> This is what I can't understand completely. Why should we check SIGKILL
> or signal_pending() in addition to kthread_stop_info.k, what is the point?

... so kthread_stop_info will go away too.

> After all, the caller of kthread_stop(k) should know what and
> why k does.

One, the kthread code could change over time. Two, the solution
to the problem is un-intuitive for the user to do. The API should
know such cases, and handle them well too. The caller of
kthread_stop() would expect it to do the expected, after all (i.e.
stop the kthread :-)

> In any case, that kind of the changes can break things, just because
> this means API change.

Well, kthreads are a kernel-internal API anyway, I guess as long as we
fix all users, we're fine.

> > >I am talking about the case
> > >when wait_event_interruptible() should not fail (unless something bad
> > >happens) inside the "while (!kthread_should_stop())" loop.
> > >Note also that kthread could use TASK_INTERRUPTIBLE sleep
> > >[...] and because it knows that all signals are ignored.
> >
> > Ok, I think you're saying that if a kthread used wait_event_interruptible
> > (and was not expecting signals, because it ignores them), then bad
> > things (say exit in inconsistent state, etc) will happen if we break that
> > wait_event_interruptible unexpectedly.
>
> No. Of course, kthread should check the error and doesn't exit in
> inconsistent state.
>
> The question is: why should we break (say) tcp_recvmsg() inside
> "while (!kthread_should_stop())" loop if it is supposed to succeed
> unless something bad happens? (I mean, we may have a kthread which
> doesn't expect the failure unless something bad happens).

First, I don't quite understand this "not expecting failure" /
"something bad happens" bit at all.

Second, we *must* break that tcp_recvmsg() inside the kthread's
main loop, of course! We want it stopped, after all, and if we don't
make it "break" out of that function, the kthread _will_never_exit_.

[ What's worse, several kthreads are part of modules, and are
created during the module_init() and so the module_exit() function
needs to call kthread_stop() to clean it up. But the
wait_for_completion() in kthread_stop() will never unblock, and so
this would also mean the rmmod will _hang_ and module will never
get unloaded too. ]

> OK, let me give a silly example. The correctly written kthread should check
> the result of kmalloc(), yes? kthread(k) means that k should exit anyway, yes?
> So let's change kthread_stop(k) to also set TIF_MEMDIE, this means that
> __alloc_pages() will fail quickly when get_page_from_freelist() doesn't
> succeed, but won't start pageout() which may take a while. Please don't
> explain me why this suggestion is bad :), I am just trying to illustrate
> my point.

Your example / analogy is indeed *very* bad :-) Please note that this
whole thing is about functions that will _simply_*never*_exit_ever_
_unless_ given a signal. [ I think you've been misunderstanding my
proposal that I want to send a SIGKILL / signal to the kthread just
to ensure it gets stopped / killed "fast" or "asap" etc ... No! The only
reason I got into this was because kthread_stop() is an API that
fails to do what it should be doing if the corresponding kthread simply
happens to be executing certain functions in the kernel that will
*never* breakout unless given a signal. ]

But finally, I do agree that kthreads already exist out there who want
to dabble in signals and we can't break them, so perhaps the signal
method for kthread_stop() will have to wait for now. [ BTW even there
we're safe as long as we check kthread_stop() _before_ flushing or
dequeueing the signals, but then that'll be an ugly rule to try and
enforce, of course. ]

Satyam

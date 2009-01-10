Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZAJW1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZAJW1x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZAJW1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:27:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34543 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZAJW1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:27:43 -0500
Date: Sat, 10 Jan 2009 23:24:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Scott James Remnant <scott@canonical.com>
Cc: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20090110222434.GA24414@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107205322.5F8C7FC3E0@magilla.sf.frob.com> <1231598714.11642.53.camel@quest> <20090110155720.GA10954@redhat.com> <1231607252.11642.103.camel@quest> <20090110181340.GA14978@redhat.com> <1231618407.11642.196.camel@quest>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231618407.11642.196.camel@quest>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Scott James Remnant wrote:
>
> On Sat, 2009-01-10 at 19:13 +0100, Oleg Nesterov wrote:
>
> > I never argued with this. And, let me repeat. I am not arguing against
> > waitfd! Actually, I always try to avoid the "do we need this feature"
> > discussions.
> >
> Unless I'm misinterpreting you, you're saying that you don't understand
> why we should change any current behaviour?  My post is attempting to
> illustrate why we should.

Scott. How many times should I repeat: I am _not_ arguing against
waitfd.

But to clarify, neither I vote for it. I don't really care. Except
I do care about the code if it will be merged, that is why I entered
this thread.

> > What I disagree with is that waitfd adds the functionality which does
> > not exists currently.
> >
> I'm not saying that it doesn't at all; in fact I gave an example of how
> you implement the exact same functionality today.

This means I was confused. Because I thought you point is we can't poll
for childs without signalfd. And all I asked was: why do you think so.
I do understand that waitfd can be handy.

> In fact, because main loops use select()/poll(), for the SIGCHLD case
> you'd never use signalfd() at all!
>
> Unless I'm missing something, the following two examples are identical
> in behaviour:
>
> using signalfd:
> ...
> using pselect:

Yes, and that is why I mentioned that ppoll() alone is enough.

> But the pselect() version is neater.  Which is why I started the
> previous reply off with "why have signalfd() at all?"

Unlike waitfd, there are things which we just can not do without signalfd,
even if we have ppol/pselect. For example: wait for the signal, but not
dequeue it.

> One of them was attempting to explain what you don't understand here,
> I'll try and be more verbose...
> ...
> ~~Calling waitpid() does not clear the pending signal.~~
>
> This is the important bit.
>
> If a further process dies while we're inside the waitpid() loop, we will
> most likely reap that straight away.  But this does not clear the
> pending signal.  The main loop will be woken up again, even though it
> does not need to be.
>
> Thus:
>
>  - child process #1 dies
>  - main loop woken up by SIGCHLD
>  - pending status of signal cleared
>  - enter wait loop
>  - child process #2 dies
>  - SIGCHLD pending again
>  - waitpid() called first time, child process #1 reaped
>  - waitpid() called second time, child process #2 reaped
>    (SIGCHLD still pending)
>  - waitpid() called third time, no child processes remain
>  - exit wait loop
>  - back to top of main loop, immediately woken up by pending SIGCHLD
>  - pending status of signal cleared
>  - enter wait loop
>  - waitpid() called first time, but no child processes remain
>    (we reaped it last time round)
>  - exit wait loop
>  - back to top of main loop, sleep

Scott, I don't really understand why are you trying to explain this
all to me. I do understand this. At least I hope ;)

Yes this is possible, and I see no problems here.

>  - SIGCHLD not pending, but waitpid() will not block
>
>    This is true in all example usage; after you've called the read() on
>    the signalfd - or the pselect() has woken, SIGCHLD is probably no
>    longer pending but waitpid() will not block
>
>    Compare with select() behaviour; if you fail to read() from the fd,
>    select() wakes up yet again
>
>  - SIGCHLD pending, but waitpid() will block
>
>    This is true if you exhaust the wait queue in a loop,

... and this too.

> All SIGCHLD is useful for is to get your main loop out of
> select()/poll(); you must always exhaust the wait queue every time you
> have woken up.

Yes, and yes, and yes. Scott, I am sorry, I failed to read to the end
so perhaps I missed something ;)

> --- kernel/signal.c~	2009-01-10 20:04:50.000000000 +0000
> +++ kernel/signal.c	2009-01-10 20:05:24.000000000 +0000
> @@ -816,8 +816,10 @@
>  	 * exactly one non-rt signal, so that we can get more
>  	 * detailed information about the cause of the signal.
>  	 */
> -	if (legacy_queue(pending, sig))
> +	if (legacy_queue(pending, sig)) {
> +		signalfd_notify(t, sig);
>  		return 0;
> +	}

I'd prefer to not discuss this here, but I am not sure I understand.
There should not be no threads which need the wakeup from here, and
I can't see how this change can help.

> A more orthogonal example would be pselect().  That implemented, in the
> kernel, a syscall that it actually wasn't possible to implement in
> userspace

Yes, exactly,

> The argument for waitfd() or similar in the kernel is because there are
> races in userspace that we can't solve.

And now I don't understand you again. Please show me which races we
_can not_ solve in userspace without waitfd?

Yes we can race with the exiting childs while doing waitpid() in a loop,
so we can make the unnecessary syscall. But please do not tell me _this_
is the race we can't solve. This is _harmless_. Unlike the problems
with the poor user-space implementations of pselect/ppol.

Oleg.


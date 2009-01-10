Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZAJSRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZAJSRF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZAJSQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:16:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55230 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbZAJSQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:16:54 -0500
Date: Sat, 10 Jan 2009 19:13:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Scott James Remnant <scott@canonical.com>
Cc: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20090110181340.GA14978@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107205322.5F8C7FC3E0@magilla.sf.frob.com> <1231598714.11642.53.camel@quest> <20090110155720.GA10954@redhat.com> <1231607252.11642.103.camel@quest>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231607252.11642.103.camel@quest>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Scott James Remnant wrote:
>
> On Sat, 2009-01-10 at 16:57 +0100, Oleg Nesterov wrote:
>
> > I can't understand why should we change ->exit_signal if we want to
> > use signalfd. Yes, SIGCHLD is not rt. So what?
> >
> > We do not need multiple signals in queue if we want to reap multiple
> > zombies. Once we have a single SIGCHLD (reported by signalfd or
> > whatever) we can do do_wait(WNOHANG) in a loop.
> >
> Well, a good reason why is that it makes things much easier to do in
> userspace.

I never argued with this. And, let me repeat. I am not arguing against
waitfd! Actually, I always try to avoid the "do we need this feature"
discussions.

What I disagree with is that waitfd adds the functionality which does
not exists currently.

> You may as well ask why we have signalfd() at all, and what was wrong
> with sigaction() and ordinary signal handlers?  Well, lots of things

Cough. You don't have to explain me why signalfd is nice ;) I participated
in discussion when it was created.

> So let's compare userspace code for trying to reap children using
> signalfd();
>
> First, what we have today:
>
> [...snip the code...]
>
> Pros:
>  - code exists today

That is what I meant. Not more.

> Cons:
>  - having siginfo_t returned by read() is pointless, we can't use it

Indeed. We use read() only to wait for the signal death.

>  - double loop isn't pretty

Nice argument to add the new syscall ;)

>  - strange waitid() API in case of WNOHANG and no child

Heh. I also don't like this ;) A reason for waitfd ?

>  - incompatible structures for signalfd()'s read result and waitid(),
>    despite being logically the same structure! :-/

I could blaim waitfd because it fills siginfo in the manner which
is not compatible with signalfd, despite logically the same structure.

>  - can't simultaneously clear pending signal and wait, so we always have
>    to go back round the main loop if a child dies after the read()

Can't understand... waitfd doesn't clear the signal too?

And you forget to mention another drwaback with the current code:
a lot of pathetic comments ;)

> Since there's no point listening to SIGCHLD, it's a complete no-op, we
> don't respond to it at all.  We only need to use it to wake up the main
> loop.

Yes, sure, indeed, of course.

> The wait() loop tends to be at the bottom of the main loop
> somewhere, completely outside of the fd processing.

Huh.

> Now, what if signalfd() would always queue pending signals even if
> they're non-RT?

Well, I think this is off-topic, and more importantly I don't think
this change is possible.

> So what about
> waitfd()

Yes, the user-space code (for this particular artificial example)
becomes simpler. Following this logic, let's add sys_copyfile()
to kernel? From time to time I regret we don't have it...

(from another thread)
> > I am not sure we are talking about the same thing, but afaics poll() +
> > signalfd can work to (say) reap the childs. Actually, ppoll() alone is
> > enough.
> >
> Last time I checked, ppoll() was not actually implemented across all
> architectures in a manner that solved the race it was intended to solve.
>
> I'd be delighted to learn that this had been fixed? :-)

Scott, this is unfair. Yes, some arches do not implement restore_sigmask()
logic. So what? Let's suppose ppoll() has a bug. So, this means we should
add waitfd? No, let's fix ppol(), and waitfd is orthogonal. Imho.


Again, again, again. Please don't forget about "I am not arguing against".
But I don't buy your arguments.

Oleg.


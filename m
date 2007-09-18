Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbXIRJBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbXIRJBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbXIRJBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:01:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:40516 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752608AbXIRJBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:01:12 -0400
Cc: lee.schermerhorn@hp.com, torvalds@linux-foundation.org,
       vda.linux@googlemail.com, rdunlap@xenotime.net, corbet@lwn.net,
       hch@lst.de, tglx@linutronix.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, geoff@gclare.org.uk, drepper@redhat.com,
       davidel@xmailserver.org
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 18 Sep 2007 11:01:10 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <38485.145.64.134.222.1190102719.squirrel@www.hardeman.nu>
Message-ID: <20070918090110.235160@gmx.net>
MIME-Version: 1.0
References: <46EF7DDA.2070401@gmx.net> <46EF7E82.8040503@gmx.net>
 <38485.145.64.134.222.1190102719.squirrel@www.hardeman.nu>
Subject: Re: RFC: A revised timerfd API
To: =?iso-8859-1?Q?=22David_H=E4rdeman=22?= <david@hardeman.nu>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1926hEJLdZ27uDgaW/7/Rp5tpmBoZ+QsuyzIwHU1+
 0jiTq4E7dxAt9QQwbTPmtvMAdYQK66pEL+JA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: 7qTacqkcTiE+YdX+HGVw6CB9ZUVSRFeK
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

Thanks for taking a look at this.

> On Tue, September 18, 2007 09:30, Michael Kerrisk wrote:
> > ====> b) Create a timerfd interface analogous to POSIX timers
> >
> > Create an interface analogous to POSIX timers:
> > fd = timerfd_create(clockid, flags);
> > timerfd_settime(fd, flags, newtimervalue, &time_to_next_expire);
> > timerfd_gettime(fd, &time_to_next_expire);
> ...
> > ====> c) Integrate timerfd with POSIX timers
> >
> > Make a very simple timerfd call that is integrated with the
> > POSIX timers API.  The POSIX timers API is detailed here:
> > http://linux.die.net/man/3/timer_create
> > http://linux.die.net/man/3/timer_settime
> >
> > Under the POSIX timers API, a new timer is created using:
> >
> > int timer_create(clockid_t clockid, struct sigevent *evp,
> >         timer_t *timerid);
> >
> > We could then have a timerfd() call that returns a file descriptor
> > for the newly created 'timerid':
> >
> > fd = timerfd(timer_t timerid);
> 
> Wouldn't this remove some of the usefulness of the timerfd?
> 
> For example, if a timerfd is one of the fd's that is returned by a
> epoll_wait syscall, you manually need to do the mapping between the
> timerfd and the timerid in order to be able to modify the timer.

You're right, that makes the interface more clumsy. +1 for
the disadvantages.  And of course solution (d) also suffers
this problem.

> The advantage of solution b) above is that the fd is everything that is
> needed to work with the timer.

Yes, true.  Solution (b) would also be relatively easier (for me)
to implement.

> With solution c) you have to keep two
> references to the same timer around and use one of them depending on what
> you want to do with the timer.

Yes.  (And the same for option (d).)

> Also, if the timerfd is close():d, does that remove the underlying timer
> (invalidate the timerid) as well?

My gut feeling would be to say that closing the timerfd would not
remove the underlying timer (so the timerid would remain valid).
One could even do things like recreating a file descriptor
for the timer using another timerfd() call.  

But now that raises the question: what are the semantics if
timerfd() is called  more than once on the same timerid? 
Perhaps a read() from any one of them (destructively)
reads the expiration count, as though one had read from a 
dup()ed the file descriptor.  All in all, solution (c) 
starts to look overly complex, and maybe suffers from 
various dirty corners in the API.  (Solution (d) feels 
slightly better, because the creation of the file descriptor
and the timerid are integrated into a single call, and the
fact that it integrates with an existing API, but
it still has the limitation you describe above.)

Cheers,

Michael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbXIRJK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbXIRJK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbXIRJKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:10:13 -0400
Received: from www.osadl.org ([213.239.205.134]:36920 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754156AbXIRJKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:10:11 -0400
Subject: Re: RFC: A revised timerfd API
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>, geoff@gclare.org.uk,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <rdunlap@xenotime.net>, vda.linux@googlemail.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <46EF7E82.8040503@gmx.net>
References: <46EF7DDA.2070401@gmx.net>  <46EF7E82.8040503@gmx.net>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 11:10:07 +0200
Message-Id: <1190106607.2995.97.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

On Tue, 2007-09-18 at 09:30 +0200, Michael Kerrisk wrote:
> ====> a) Add an argument (a multiplexing timerfd() system call)
> Disadvantage:
> Jon Corbet pointed out
> (http://thread.gmane.org/gmane.linux.kernel/559193/focus=570709 )
> that this interface was starting to look like a multiplexing syscall,
> because there is no case where all of the arguments are used (see
> the use-case descriptions in the earlier mail).
> 
> I'm inclined to agree with Jon; therefore one of the remaining
> solutions may be preferable

I agree. It's ugly.

> ====> b) Create a timerfd interface analogous to POSIX timers
> 
> Create an interface analogous to POSIX timers:
> 
> fd = timerfd_create(clockid, flags);
> 
> timerfd_settime(fd, flags, newtimervalue, &time_to_next_expire);
> 
> timerfd_gettime(fd, &time_to_next_expire);
> 
> Under this proposal, the manner of making a timer that does not
> need "get-while-set" functionality remains fairly simple:
> 
>     fd = timerfd_create(clockid);
> 
>     timerfd_settime(fd, flags, newtimervalue, NULL);
> 
> Advantage: this would be a clean, fully functional API, and well
> understood by virtue of its analogy with the POSIX timers API.
> 
> Disadvantage: 3 new system calls, rather than 1.
> 
> This solution would be sufficient, IMO, but one of the
> next solutions might be better.

I'm not scared by the 3 system calls. I rather fear that we end up
reimplementing half of the existing posix timer code.

> ====> c) Integrate timerfd with POSIX timers
> 
> Make a very simple timerfd call that is integrated with the
> POSIX timers API.  The POSIX timers API is detailed here:
> http://linux.die.net/man/3/timer_create
> http://linux.die.net/man/3/timer_settime
> 
> Under the POSIX timers API, a new timer is created using:
> 
> int timer_create(clockid_t clockid, struct sigevent *evp,
>         timer_t *timerid);
> 
> We could then have a timerfd() call that returns a file descriptor
> for the newly created 'timerid':
> 
> fd = timerfd(timer_t timerid);
> 
> We could then use the POSIX timers API to operate on the timer
> (start it / modify it / fetch timer value):
> 
> int timer_settime(timer_t timerid, int flags,
>         const struct itimerspec *value,
>         struct itimerspec *ovalue);
> int timer_gettime(timer_t timerid, struct itimerspec *value);
> 
> And then read() from 'fd' as before.
> 
> In the simple case (no "get" or "get-while-setting" functionality),
> the use of API (c) would be:
> 
>     timer_create(clockid, &evp, &timerid);
> 
>     fd = timerfd(timerid);
> 
>     timer_settime(timerid, flags, &newvalue, NULL));
> 
> Advantages:
>   1. Integration with an existing API.
>   2. Adds just a single system call.
>   3. It _might_ be possible to construct an interface that allows
>      userland programs to do things like creating a timer fd for
>      a POSIX timer that was created via some library that doesn't
>      actually know about timer fds.  (I can already see problems with
>      this, since that library will already expect to be delivering
>      timer notifications somehow (via threads or signals), and it may
>      be difficult to make the two notification mechanisms play
>      together in a sane way.  But maybe someone else has a take on
>      this that can rescue this idea.)
> 
> Disadvantages:
>   1. Starts to get a little more clunky to use in the simple
>      case shown above.
> 
> This strikes me as a more attractive solution than (b), if we can do
> it properly -- that means: if we can achieve advantage 3
> in some reasonable way.  If we can't achieve that, then probably
> the next solution is better.

The main problem here is, that there is no way to tell the posix timer
code that the delivery of the timer is through the file descriptor and
not via the usual posix timer mechanisms. We need something like the
SIGEV_TIMERFD flag to make the posix timer code aware of that.

> ====> d) extend the POSIX timers API
> 
> Under the POSIX timers API, the evp argument of timer_create() is a
> structure that allows the caller to specify how timer expirations
> should be notified.  There are the following possibilities
> (differentiated by the value assigned to evp.sigev_notify):
> 
>   i) notify via a signal: the caller specifies which signal the
>      kernel should deliver when the timer expires.
>      (SIGEV_SIGNAL)
>  ii) notify by delivering a signal to the thread whose thread ID
>      is specified in evp.  (This is Linux specific.)
>      (SIGEV_THREAD_ID)
> iii) notify via a thread: when the timer expires, the system starts
>      a new thread which receives an argument that was specified in
>      the evp structure. (SIGEV_THREAD)
>  iv) no notification: the caller can monitor the timer state using
>      timer_gettime(). (SIGEV_NONE)
> 
> In all of the above cases, the return value from timer_create()
> is 0 for success, or -1 for failure.
> 
> We could extend the interface as follows:
> 
> 1) Add a new flag for evp.sigev_notify: SIGEV_TIMERFD.
>    This flag indicates that the caller wants timer
>    notification via a file descriptor.
> 2) Whenevp.sigev_notify == SIGEV_TIMERFD, have a successful
>    timer_create() call return a file descriptor (i.e., an
>    integer >= 0).
> 
> Advantages:
>   1. Integration with an existing API.
>   2. No new system calls are required.
>   3. This idea might even have a chance of getting standardized in
>      POSIX one day, since (IMO) it integrates fairly cleanly with
>      an existing API.
> 
> Disadvantages:
>   1. The fact that the return value of a successful timer_create()
>      is different for the SIGEV_TIMERFD case is a bit of a wart.

What happens on close(fd) ? Is the posix timer automatically destroyed ?
Is the file descriptor invalidated when the timer is destroyed via
timer_delete(timer_id) ? The automatic file descriptor creation is a bit
ugly.

I'd rather see a combination of c) and d) as a solution:

Notify the posix timer code that the timer delivery is done via the file
descriptor mechanism (SIGEV_TIMERFD). 

Use a new syscall to open a file descriptor on that timer. 

When the file descriptor is closed the timer is not destroyed, but
delivery disabled (analogous to the SIGEV_NONE case), so you can reopen
and reactivate it later on.

This way we have it nicely integrated into the posix timer code and keep
the existing semantics of posix timers intact.

We need to think about the open file descriptor in the timer_delete()
case as well, but this should be not too hard to sort out.

	tglx





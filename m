Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbXIRJaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbXIRJaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbXIRJaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:30:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:49890 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754406AbXIRJaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:30:09 -0400
Cc: Lee.Schermerhorn@hp.com, torvalds@linux-foundation.org,
       vda.linux@googlemail.com, rdunlap@xenotime.net, corbet@lwn.net,
       hch@lst.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       geoff@gclare.org.uk, drepper@redhat.com, davidel@xmailserver.org,
       =?iso-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 18 Sep 2007 11:30:07 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <1190106607.2995.97.camel@chaos>
Message-ID: <20070918093007.223350@gmx.net>
MIME-Version: 1.0
References: <46EF7DDA.2070401@gmx.net>  <46EF7E82.8040503@gmx.net>
 <1190106607.2995.97.camel@chaos>
Subject: Re: RFC: A revised timerfd API
To: Thomas Gleixner <tglx@linutronix.de>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+cE7cxSj6cwzoAG/xev8XIW9ZUNCVo5q5q/7Qrvz
 vvDfD9Qypv11/jyEA7dH3DQzmkKZRNsdFH+Q== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: p6jcclUeX1V6KZLyF2ByJWh/SDc4NMwR
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> On Tue, 2007-09-18 at 09:30 +0200, Michael Kerrisk wrote:
> > ====> a) Add an argument (a multiplexing timerfd() system call)
> > Disadvantage:
> > Jon Corbet pointed out
> > (http://thread.gmane.org/gmane.linux.kernel/559193/focus=570709 )
> > that this interface was starting to look like a multiplexing syscall,
> > because there is no case where all of the arguments are used (see
> > the use-case descriptions in the earlier mail).
> > 
> > I'm inclined to agree with Jon; therefore one of the remaining
> > solutions may be preferable
> 
> I agree. It's ugly.

Fair enough.  I mainly tried to do things that way to minimize
the change from the Davide's original interface.

> > ====> b) Create a timerfd interface analogous to POSIX timers
> > 
> > Create an interface analogous to POSIX timers:
> > 
> > fd = timerfd_create(clockid, flags);
> > 
> > timerfd_settime(fd, flags, newtimervalue, &time_to_next_expire);
> > 
> > timerfd_gettime(fd, &time_to_next_expire);
> > 
> > Under this proposal, the manner of making a timer that does not
> > need "get-while-set" functionality remains fairly simple:
> > 
> >     fd = timerfd_create(clockid);
> > 
> >     timerfd_settime(fd, flags, newtimervalue, NULL);
> > 
> > Advantage: this would be a clean, fully functional API, and well
> > understood by virtue of its analogy with the POSIX timers API.
> > 
> > Disadvantage: 3 new system calls, rather than 1.
> > 
> > This solution would be sufficient, IMO, but one of the
> > next solutions might be better.
> 
> I'm not scared by the 3 system calls. I rather fear that we end up
> reimplementing half of the existing posix timer code.

Yes.  Perhaps some refactoring might be required, if we went 
down this route.

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
> > 
> > We could then use the POSIX timers API to operate on the timer
> > (start it / modify it / fetch timer value):
> > 
> > int timer_settime(timer_t timerid, int flags,
> >         const struct itimerspec *value,
> >         struct itimerspec *ovalue);
> > int timer_gettime(timer_t timerid, struct itimerspec *value);
> > 
> > And then read() from 'fd' as before.
> > 
> > In the simple case (no "get" or "get-while-setting" functionality),
> > the use of API (c) would be:
> > 
> >     timer_create(clockid, &evp, &timerid);
> > 
> >     fd = timerfd(timerid);
> > 
> >     timer_settime(timerid, flags, &newvalue, NULL));
> > 
> > Advantages:
> >   1. Integration with an existing API.
> >   2. Adds just a single system call.
> >   3. It _might_ be possible to construct an interface that allows
> >      userland programs to do things like creating a timer fd for
> >      a POSIX timer that was created via some library that doesn't
> >      actually know about timer fds.  (I can already see problems with
> >      this, since that library will already expect to be delivering
> >      timer notifications somehow (via threads or signals), and it may
> >      be difficult to make the two notification mechanisms play
> >      together in a sane way.  But maybe someone else has a take on
> >      this that can rescue this idea.)
> > 
> > Disadvantages:
> >   1. Starts to get a little more clunky to use in the simple
> >      case shown above.
> > 
> > This strikes me as a more attractive solution than (b), if we can do
> > it properly -- that means: if we can achieve advantage 3
> > in some reasonable way.  If we can't achieve that, then probably
> > the next solution is better.
> 
> The main problem here is, that there is no way to tell the posix timer
> code that the delivery of the timer is through the file descriptor and
> not via the usual posix timer mechanisms. We need something like the
> SIGEV_TIMERFD flag to make the posix timer code aware of that.

Well, I left it it kind of open whether the expiration 
notification might be delivered via both the traditional
mechanism, and via the tiemrfd.  But I realize that all
may get overly complex.

> > ====> d) extend the POSIX timers API
> > 
> > Under the POSIX timers API, the evp argument of timer_create() is a
> > structure that allows the caller to specify how timer expirations
> > should be notified.  There are the following possibilities
> > (differentiated by the value assigned to evp.sigev_notify):
> > 
> >   i) notify via a signal: the caller specifies which signal the
> >      kernel should deliver when the timer expires.
> >      (SIGEV_SIGNAL)
> >  ii) notify by delivering a signal to the thread whose thread ID
> >      is specified in evp.  (This is Linux specific.)
> >      (SIGEV_THREAD_ID)
> > iii) notify via a thread: when the timer expires, the system starts
> >      a new thread which receives an argument that was specified in
> >      the evp structure. (SIGEV_THREAD)
> >  iv) no notification: the caller can monitor the timer state using
> >      timer_gettime(). (SIGEV_NONE)
> > 
> > In all of the above cases, the return value from timer_create()
> > is 0 for success, or -1 for failure.
> > 
> > We could extend the interface as follows:
> > 
> > 1) Add a new flag for evp.sigev_notify: SIGEV_TIMERFD.
> >    This flag indicates that the caller wants timer
> >    notification via a file descriptor.
> > 2) Whenevp.sigev_notify == SIGEV_TIMERFD, have a successful
> >    timer_create() call return a file descriptor (i.e., an
> >    integer >= 0).
> > 
> > Advantages:
> >   1. Integration with an existing API.
> >   2. No new system calls are required.
> >   3. This idea might even have a chance of getting standardized in
> >      POSIX one day, since (IMO) it integrates fairly cleanly with
> >      an existing API.
> > 
> > Disadvantages:
> >   1. The fact that the return value of a successful timer_create()
> >      is different for the SIGEV_TIMERFD case is a bit of a wart.
> 
> What happens on close(fd) ? Is the posix timer automatically destroyed ?

I would say not (see also my reply to David Härdeman.)

> Is the file descriptor invalidated when the timer is destroyed via
> timer_delete(timer_id) ? The automatic file descriptor creation is a bit
> ugly.

Yes, it is a little ugly.

> I'd rather see a combination of c) and d) as a solution:
> 
> Notify the posix timer code that the timer delivery is done via the file
> descriptor mechanism (SIGEV_TIMERFD). 
> 
> Use a new syscall to open a file descriptor on that timer. 
> 
> When the file descriptor is closed the timer is not destroyed, but
> delivery disabled (analogous to the SIGEV_NONE case), so you can reopen
> and reactivate it later on.
> 
> This way we have it nicely integrated into the posix timer code and keep
> the existing semantics of posix timers intact.
> 
> We need to think about the open file descriptor in the timer_delete()
> case as well, but this should be not too hard to sort out.

This seems like a workable idea also.  But note David Härdeman's
critique of options c & d: the existence of a coupled timerfd 
and a timerid means that the application must maintain a mapping
between the two, so that after an epoll call (for example) that 
says the timerfd is ready, the timer can be manipulated using
the corresponding timerfd.  This isn't IMO a fatal flaw, but
it does make the API a little more clumsy.

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.


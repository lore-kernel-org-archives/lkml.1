Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbXIVNPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbXIVNPi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 09:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXIVNPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 09:15:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:44228 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751496AbXIVNPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 09:15:30 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX188Ec5bWtM8xdn5XfF9HNE4JId43d9m3mb30kmt/L
	lV+8Lo6SZ0vX0G
Message-ID: <46F514C9.5010208@gmx.net>
Date: Sat, 22 Sep 2007 15:12:41 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Ulrich Drepper <drepper@redhat.com>, geoff@gclare.org.uk,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@xenotime.net>,
       vda.linux@googlemail.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       =?UTF-8?B?RGF2aWQgSMOkcmRlbWE=?= =?UTF-8?B?bg==?= 
	<david@hardeman.nu>
Subject: Re: RFC: A revised timerfd API
References: <46EF7DDA.2070401@gmx.net> <Pine.LNX.4.64.0709180936480.22956@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0709180936480.22956@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide, Andrew, Linus, et al.

At the start of this thread
(http://thread.gmane.org/gmane.linux.kernel/581115 ), I proposed 4
alternatives to Davide's original timerfd API.  Based on the feedback in
that thread (and one or two earlier comments):

Let's dismiss option (a), since it is an unlovely multiplexing interface.

Option (b) seems a viable.  The most notable concern was from Thomas
Gleixner, that we might end up duplicating code from the POSIX timers API
within the timerfd API -- some eventual refactoring might mitigate this
problem.

Option (c) seems overly complex.  In addition, David Härdeman pointed out
that option (c) (and, I realised afterwards, option (d)) require the
userland programmer to maintain a mapping between timerfd file descriptors
and POSIX timer IDs.  Thomas Gleixner proposed an API that: attempts to
avoid that problem; mixes features of options (c) and (d); and probably
helps avoid redundancy of kernel code between the timerfd system and the
POSIX timers system.  I'll flesh out that API now as I understand it:

====> e) Integrate timerfd() with the POSIX timers API in such a way that
the POSIX timers API understands timerfd file descriptors.

Under the POSIX timers API, a new timer is created using:

int timer_create(clockid_t clockid, struct sigevent *evp,
        timer_t *timerid);

When making this call, we would specify evp.sigev_notify to a new flag
value SIGEV_TIMERFD, to inform the system that this timer will deliver
notification via a timerfd file descriptor.

We would then have a timerfd() call that returns a file descriptor
for the newly created 'timerid':

fd = timerfd(timer_t timerid);

(A variant here would be to have timer_create() directly return a file
descriptor when SIGEV_TIMERFD is specified, although this breaks the
traditional semantics that timer_create() only returns 0 on success.)

We could then use the POSIX timers API to operate on the timer
(start it / modify it / fetch timer value):

int timer_settime(timer_t timerid, int flags,
        const struct itimerspec *value,
        struct itimerspec *ovalue);
int timer_gettime(timer_t timerid, struct itimerspec *value);

The difference here is that 'timerid' could be either:

1) the timerid value returned from timer_create(); or

2) the value (fd | POSIX_TIMER_FD), where POSIX_TIMER_FD is a
   flag (perhaps the topmost bit set on) that indicates that
   the rest of the value is a file descriptor.  With this
   information, the kernel can do a lookup to find the
   corresponding timerfd and perform the required operation
   on it.

Advantages:
  1. Userland programs don't need to maintain a mapping between
     timer IDs and file descriptors.
  2. Adds just a single system call.

Disadvantages:
  1. This design stretches the POSIX timers API in strange
     ways.  My option (d) also did this to a lesser extent,
     and that felt slightly uncomfortable.  Option (e)
     makes more uncomfortable still.  As David Härdeman
     pointed out, overloading file descriptors with flags looks
     ugly, and I can't thing of any other syscall that does
     that.  In addition this idea probably breaks POSIX, since
     'timer_t' is only required to be an arithmetic type: it
     need not specifically be an integer type (although it is
     on Linux).

=====

The upshot is that of the 5 alternatives, I favor option (b).  David
Härdeman also expressed a preference for option (b) and it was Davide's
least disliked alternative ;-).

So I'm inclined to implement option (b), unless someone has strong
objections.  Davide, could I persuade you to help?

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

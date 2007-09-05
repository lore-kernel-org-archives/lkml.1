Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbXIEPcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbXIEPcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbXIEPcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:32:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:36152 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755231AbXIEPcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:32:04 -0400
Cc: corbet@lwn.net, jengelh@computergmbh.de, hch@lst.de, stable@kernel.org,
       drepper@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rdunlap@xenotime.net,
       vda.linux@googlemail.com, davidel@xmailserver.org
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 05 Sep 2007 17:32:01 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <200709051312.21873.vda.linux@googlemail.com>
Message-ID: <20070905153201.236690@gmx.net>
MIME-Version: 1.0
References: <20070825064114.107820@gmx.net>
 <20070904011800.762523a4.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
 <200709051312.21873.vda.linux@googlemail.com>
Subject: timerfd redux
To: akpm@linux-foundation.org
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/8uGFGRFX8dNOp0U5dX/VWWUM+bZ0Hfb0CkNhV/j
 YeW1m++uocMb0tjcbSnSf1XrMh6FdECnnHpA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: w/LtfkBoMmA6IM3zEGBn7KY5MjQ1N536
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Was: Re: [PATCH] Revised timerfd() interface]

> Michael, could you please refresh our memories with a brief,
> from-scratch summary of what the current interface is, followed
> by a summary of what you believe to be the shortcomings to be? 

Andrew,

I'll break this up into parts:

1. the existing timerfd interface
2. timerfd limitations
3. possible solutions
     a) Add an argument
     b) Create an interface similar to POSIX timers
     c) Integrate timerfd with POSIX timers

Cheers,

Michael


1: the existing timerfd interface
=================================

In 2.6.22, Davide added timerfd() with the following interface:

returned_fd = timerfd(int fd, int clockid, int flags,
                      struct itimerspec *utimer);

If fd is -1, a new timer is created and started.  The syscall
returns a file descriptor for the timer. 'utimer' specifies
the initial expiration and interval of the timer.
'clockid' is CLOCK_REALTIME or CLOCK_REALTIME.  The 'utimer'
value is relative, unless TFD_TIMER_ABSTIME is specified in
'flags', in which case the initial expiration is specified
absolutely.

If 'fd' is not -1, then the call modifies the existing timer
referred to by the file descriptor 'fd'.  The 'clockid', 'flags',
and 'utimer' can all be modified.  The return value is 'fd'.

The key feature of timerfd() is that the caller can use
select/poll/epoll to wait on traditional file descriptors and
one or more timers.

read() from a timerfd file descriptor (should) return a 4-byte
integer that is the number of timer expirations since the last
read.  (If no expiration has so far occurred, read() will block.)

IMPORTANT POINT: as implemented in 2.6.22, timerfd was broken:
only a single byte of info was returned by read().  I regard
this as a virtue: it gives us something closer to a blank slate
for fixing the problems described below; furthermore,
arguably at this point we could buy ourselves time by
pulling timerfd() from 2.6.23, and taking more time to get
things right in 2.6.24.

(More details on timerfd() can be found here: 
http://lwn.net/Articles/245533/)

2. timerfd limitations
======================

Unix has two older timer interfaces:

* setitimer/getitimer and

* POSIX timers (timer_create/timer_settime/timer_gettime).

timerfd() lacks two features that are present in the older
interfaces:

* Retrieve the previous setting of an existing timer when
  setting a new value for the timer.

* Non-destructively fetch the timer remaining until the
  next expiration of the timer.

The fact that this functionality is present in both older APIs
strongly suggests that various applications really need both
functionalities.  

(Davide has argued that timerfd() doesn't need the
get-while-setting functionality because we can create multiple
timerfd timers.  However, POSIX timers also allow multiple
timer instances, but nevertheless provide get-while-setting.
I would estimate that this functionality would be useful for
libraries that want to create and control a (single) timerfd
file descriptor that is returned to the caller.)

3. possible solutions
=====================

====> a) Add an argument

I proposed adding a further argument to timerfd(): old_utmr,
which could be used to return the time remaining until
expiry for an existing timer 
(http://marc.info/?l=linux-kernel&m=118669430305788&w=2 ).
I proposed semantics that would allow get and
get-while-setting functionality.

Jon Corbet pointed out that my suggestion was starting
to look like a multiplexing syscall.  I agree.  I now
favor one of the remaining solutions.

====> b) Create an interface similar to POSIX timers

Create an interface analogous to POSIX timers:

fd = timerfd_create(clockid, flags);

timerfd_settime(fd, flags, newtimervalue, &time_to_next_expire);

timerfd_gettime(fd, &time_to_next_expire);

Advantage: this would be a clean, fully functional API, and well
understood by virtue of its analogy with the POSIX timers API.

Disadvantage: three new system calls, rather than 1.

This solution would be sufficient, IMO, but the
next solution might be better.

====> c) Integrate timerfd with POSIX timers

Make a very simple timerfd call that is integrated with
the POSIX timers API.  A POSIX timer is created using:

int timer_create(clockid_t clockid, struct sigevent *evp,
        timer_t *timerid);

We could then have a timerfd() call that returns a file descriptor
for the newly created 'timerid':

fd = timerfd(timer_t timerid);

We could then use the POSIX timers API to operate on the timer
(start it / modify it / fetch timer value):

int timer_gettime(timer_t timerid, struct itimerspec *value);
int timer_settime(timer_t timerid, int flags,
        const struct itimerspec *value,
        struct itimerspec *ovalue); 

And then read from 'fd' as before.

Advantages:
  1. Integration with an existing API.
  2. Adds just a single system call
  3. This strikes me as the most beautiful solution,
     if we can do it properly.

Disadvantage: I'm not yet completely clear whether there are some
features of the POSIX timers API that might preclude a clean
integration.  In particular, we would need to think a little
about the semantics of timer_getoverrun():

int timer_getoverrun(timer_t timerid);

I suspect it's fine, but we better think about it a little.

We would also have to think about how the 'evp' argument
of timer_create() would be used.  This might be trickier.
(Simplest might be to require evp.sigev_notify to be
SIGEV_NONE, or perhaps a new flag, SIGEV_TIMERFD.)

=== END ===

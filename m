Return-Path: <linux-kernel-owner+w=401wt.eu-S1764739AbXIMGOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764739AbXIMGOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 02:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXIMGO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 02:14:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:48462 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754493AbXIMGO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 02:14:28 -0400
Cc: davidel@xmailserver.org, vda.linux@googlemail.com, rdunlap@xenotime.net,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, drepper@redhat.com, stable@kernel.org,
       hch@lst.de, jengelh@computergmbh.de, corbet@lwn.net
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 13 Sep 2007 08:14:27 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <20070912193920.441cf901.akpm@linux-foundation.org>
Message-ID: <20070913061427.321790@gmx.net>
MIME-Version: 1.0
References: <20070825064114.107820@gmx.net>
	<20070904011800.762523a4.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
	<200709051312.21873.vda.linux@googlemail.com>	<20070905153201.236690@gmx.net>
 <20070912193920.441cf901.akpm@linux-foundation.org>
Subject: Re: timerfd redux
To: Andrew Morton <akpm@linux-foundation.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/3L/BuPiT3Z/c9fOR0Fx3S8OU3QeoYgVABIdhOOE
 gBnkkxv34D+fTiDbtlx5kwuwtwzKW9TZWZmg== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: e+fRc4gweWUoR87+CHRzRuwxU3U4Nw9T
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > [Was: Re: [PATCH] Revised timerfd() interface]
> > 
> > > Michael, could you please refresh our memories with a brief,
> > > from-scratch summary of what the current interface is, followed
> > > by a summary of what you believe to be the shortcomings to be? 
> > 
> > Andrew,
> > 
> > I'll break this up into parts:
> > 
> > 1. the existing timerfd interface
> > 2. timerfd limitations
> > 3. possible solutions
> >      a) Add an argument
> >      b) Create an interface similar to POSIX timers
> >      c) Integrate timerfd with POSIX timers
> > 
> > Cheers,
> > 
> > Michael
> > 
> > 
> > 1: the existing timerfd interface
> > =================================
> > 
> > In 2.6.22, Davide added timerfd() with the following interface:
> > 
> > returned_fd = timerfd(int fd, int clockid, int flags,
> >                       struct itimerspec *utimer);
> > 
> > If fd is -1, a new timer is created and started.  The syscall
> > returns a file descriptor for the timer. 'utimer' specifies
> > the initial expiration and interval of the timer.
> > 'clockid' is CLOCK_REALTIME or CLOCK_REALTIME.  The 'utimer'
> > value is relative, unless TFD_TIMER_ABSTIME is specified in
> > 'flags', in which case the initial expiration is specified
> > absolutely.
> > 
> > If 'fd' is not -1, then the call modifies the existing timer
> > referred to by the file descriptor 'fd'.  The 'clockid', 'flags',
> > and 'utimer' can all be modified.  The return value is 'fd'.
> > 
> > The key feature of timerfd() is that the caller can use
> > select/poll/epoll to wait on traditional file descriptors and
> > one or more timers.
> > 
> > read() from a timerfd file descriptor (should) return a 4-byte
> > integer that is the number of timer expirations since the last
> > read.  (If no expiration has so far occurred, read() will block.)
> > 
> > IMPORTANT POINT: as implemented in 2.6.22, timerfd was broken:
> > only a single byte of info was returned by read().  I regard
> > this as a virtue: it gives us something closer to a blank slate
> > for fixing the problems described below; furthermore,
> > arguably at this point we could buy ourselves time by
> > pulling timerfd() from 2.6.23, and taking more time to get
> > things right in 2.6.24.
> > 
> > (More details on timerfd() can be found here: 
> > http://lwn.net/Articles/245533/)
> 
> OK.
> 
> > 2. timerfd limitations
> > ======================
> > 
> > Unix has two older timer interfaces:
> > 
> > * setitimer/getitimer and
> > 
> > * POSIX timers (timer_create/timer_settime/timer_gettime).
> > 
> > timerfd() lacks two features that are present in the older
> > interfaces:
> > 
> > * Retrieve the previous setting of an existing timer when
> >   setting a new value for the timer.
> > 
> > * Non-destructively fetch the timer remaining until the
> >   next expiration of the timer.
> > 
> > The fact that this functionality is present in both older APIs
> > strongly suggests that various applications really need both
> > functionalities.  
> 
> Yes, I can imagine applications wanting to do those things.
> 
> > (Davide has argued that timerfd() doesn't need the
> > get-while-setting functionality because we can create multiple
> > timerfd timers.  However, POSIX timers also allow multiple
> > timer instances, but nevertheless provide get-while-setting.
> > I would estimate that this functionality would be useful for
> > libraries that want to create and control a (single) timerfd
> > file descriptor that is returned to the caller.)
> 
> Sure.  If you're implementing a timeout and you want to reset it, you
> might indeed want to know how close the old one was to expiring.
> 
> Davide's proposal sounds like an awkward workaround for missing
> functionality.

In the other thread I commented that the userspace solution
starts to look pretty complex, and I doubt that it can
be made to work in all cases.

> Does Davide have a proposal for the non-destructive fetch?

I don't think so, since he disagrees about it's necessity.

> > 3. possible solutions
> 
> I don't think we'll have this settled and coded in time for 2.6.23.  So I
> think the prudent thing to do is to push this back to 2.6.24 and not 
> offer sys_timerfd() in 2.6.23.

I think this would be wise.  I'd like to talk with Davide some
more about the possibilities.

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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbXIFG60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbXIFG60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 02:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbXIFG6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 02:58:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:58367 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751577AbXIFG6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 02:58:18 -0400
Cc: akpm@linux-foundation.org, corbet@lwn.net, jengelh@computergmbh.de,
       hch@lst.de, stable@kernel.org, drepper@redhat.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rdunlap@xenotime.net
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 06 Sep 2007 08:58:16 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0709051604320.5320@alien.or.mcafeemobile.com>
Message-ID: <20070906065816.194530@gmx.net>
MIME-Version: 1.0
References: <20070825064114.107820@gmx.net>
 <Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
 <46DD116C.4040301@gmx.net>
 <20070904011800.762523a4.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
 <20070904204932.208520@gmx.net>
 <Pine.LNX.4.64.0709041541500.7326@alien.or.mcafeemobile.com>
 <20070905000831.313400@gmx.net>
 <Pine.LNX.4.64.0709050901420.11426@alien.or.mcafeemobile.com>
 <20070905162352.236680@gmx.net>
 <Pine.LNX.4.64.0709051251290.11804@alien.or.mcafeemobile.com>
 <20070905225033.236700@gmx.net>
 <Pine.LNX.4.64.0709051604320.5320@alien.or.mcafeemobile.com>
Subject: Re: [PATCH] Revised timerfd() interface
To: Davide Libenzi <davidel@xmailserver.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+/KL0+0vm/FJswn/dw3i6ZZWranXNFKaz2ez+gE9
 s0ODoRGi1q3h3znBBwBUy7iIcq3q4cBOBHqA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: P53qcrYBRkkNc9LlCGVqbkZudWkvKFNF
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

> > > > > > > > As I think about this more, I see more problems with
> > > > > > > > your argument.  timerfd needs the ability to get and 
> > > > > > > > get-while-setting just as much as the earlier APIs.
> > > > > > > > Consider a library that creates a timerfd file descriptor
> > > > > > > > that
> > > > > > > > is handed off to an application: that library may want
> > > > > > > > to modify the timer settings without having to create a
> > > > > > > > new file descriptor (the app mey not be able to be told
> > > > > > > > about
> > > > > > > > the new fd).  Your argument just doesn't hold, AFAICS.
> > > > > > > 
> > > > > > > Such hypotethical library, in case it really wanted to offer
> > > > > > > such 
> > > > > > > functionality, could simply return an handle instead of the
> > > > > > > raw fd, and take care of all that stuff in userspace.
> > > > > > 
> > > > > > Did I miss something?  Is it not the case that as soon as the
> > > > > > library returns a handle, rather than an fd, then the whole
> > > > > > advantage of timerfd() (being able to select/poll/epoll on 
> > > > > > the timer as well as other fds) is lost?  
> > > > > 
> > > > > Why? The handle would simply be a little struct where the
> > > > > timerfd fd is 
> > > > > stored, and a XXX_getfd() would return it.
> > > > > So my point is, I doubt such functionalities are really needed,
> > > > > and I 
> > > > > also argue that the kernel is the best place for such wrapper 
                                       ^
(By the way, I assume that back there, there was a missing "not",
right?)

> > > > > code to go.
> > > > 
> > > > So what happens if one thread (via the library) wants modify
> > > > a timer's settings at the same timer as another thread is 
> > > > select()ing on it?  The first thread can't do this by creating
> > > > a new timerfd timer, since it wants to affect the select()
> > > > in the other thread?
> > > 
> > > It can be done w/out any problems. The select thread will be notified 
> > > whenever the new timer setting expires.
> > 
> > We are going in circles here.  I think you are missing my point.
> > Consider the following
> > 
> > [[
> > Thread A: calls library function which creates a timerfd file
> > descriptor.
> > 
> > Thread B: calls select() on the timerfd file descriptor.
> > 
> > Thread A: calls library function which wants to:
> >    a) modify timer settings, and retrieve copy of current timer
> >       settings, and later
> >    b) restore old timer settings.
> > ]]
> > 
> > This seems a quite reasonable use-case to me, and the existing
> > interface simply can't support it.
> 
> "Quite reasonable"? :)
> I honestly doubt it, but anyway. 

You are asserting this in the face of two previous APIs designed 
by people who (at least in the case of POSIX timers) probably 
thoroughly examined and discussed existing APIs and practice.

> Modulo error checking:

I'm not sure what problem this code is supposed to solve.  It
doesn't solve the problem I have in mind; see below.

> struct tfd {
> 	int fd, clockid;
> 	struct itimerspec ts;
> };
> 
> struct tfd *tfd_create(int clockid, int flags, const struct itimerspec
> *ts) {
> 	struct tfd *th;
> 	th = malloc(sizeof(*th));
> 	th->clockid = clockid;
> 	th->ts = *ts;
> 	th->fd = timerfd(-1, clockid, flags, ts);
> 	return th;
> }
> 
> void tfd_close(struct tfd *th) {
> 	close(th->fd);
> 	free(th);
> }
> 
> int tfd_getfd(const struct tfd *th) {
> 	return th->fd;
> }
> 
> int tfd_gettime(const struct tfd *th, int *clockid, struct itimerspec *ts)
> {
> 	*clockid = th->clockid;
> 	*ts = th->ts;
> 	return 0;
> }

This function is *not at all* equivalent to the "get"
functionality of the previous APIs.  The "get" functionality
of POSIX timers (for example) returns a structure that contains
the timer interval and the *time until the next expiration of
the timer* (not the initial timer string, as your code above
does).

So come up with a reliable, race-free way of doing that in
userspace.  Then make it work for both CLOCK_MONOTONIC and
CLOCK_REALTIME timers.  (You'll certainly need to be making
some additional system calls, by the way: at least some
calls to clock_gettime().)

> int tfd_settime(struct tfd *th, int clockid, int flags,
> 		const struct itimerspec *ts) {
> 	th->fd = timerfd(th->fd, clockid, flags, ts);
> 	th->clockid = clockid;
> 	th->ts = *ts;
> 	return 0;
> }
> 
> Wrap the get/set with a mutex in case you plan to shoot yourself in a 
> foot by doing get/set from multiple threads ;)
> So, once again:
> 
> - I sincerly doubt the above is common usage/design patters for timerfds

See my comments above in this message.  You may doubt it, but
all of the earlier API designers did not.

>   * timerfds are not a common global resource, ala signals, that requires 
>     get+set+restore pattern - you can have many of them set to different 
>     times

No!  In the example I described the library is able to create and
control exactly *one* timerfd file descriptor.  It wants to hand
that fd back to the application and then perform arbitrary
manipulations of the timer's settings.  Meanwhile the application
needs to (repeatedly) monitor that one file descriptor in a
select()/poll()/epoll() (and so the library can't just arbitrarily
create further file descriptors).

> - Those IMO *very* special use cases can be handled in userspace with few 
>   lines of code, *if* really needed

You have not demonstrated this ;-).  Your userspace code does
not solve the problem.

Best regards,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.


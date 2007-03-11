Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbXCKXuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbXCKXuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 19:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964815AbXCKXuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 19:50:12 -0400
Received: from rwcrmhc15.comcast.net ([216.148.227.155]:39562 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810AbXCKXuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 19:50:10 -0400
Subject: Re: [patch 6/9] signalfd/timerfd v3 - timerfd core ...
From: Nicholas Miell <nmiell@comcast.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.64.0703111610360.4936@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5031.1173654242.6>
	 <Pine.LNX.4.64.0703111610360.4936@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 16:50:08 -0700
Message-Id: <1173657008.2964.6.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-11 at 16:13 -0700, Davide Libenzi wrote:
> On Sun, 11 Mar 2007, Davide Libenzi wrote:
> 
> > This patch introduces a new system call for timers events delivered
> > though file descriptors. This allows timer event to be used with
> > standard POSIX poll(2), select(2) and read(2). As a consequence of
> > supporting the Linux f_op->poll subsystem, they can be used with
> > epoll(2) too.
> > The system call is defined as:
> > 
> > int timerfd(int ufd, int clockid, int tmrtype, const struct timespec *utmr);
> > 
> > The "ufd" parameter allows for re-use (re-programming) of an existing
> > timerfd w/out going through the close/open cycle (same as signalfd).
> > If "ufd" is -1, s new file descriptor will be created, otherwise the
> > existing "ufd" will be re-programmed.
> > The "clockid" parameter is either CLOCK_MONOTONIC or CLOCK_REALTIME.
> > The "tmrtype" parameter allows to specify the timer type. The following
> > values are supported:
> > 
> >     TFD_TIMER_REL
> >         The time specified in the "utmr" parameter is a relative time
> > 	from NOW.
> > 
> >     TFD_TIMER_ABS
> >         The timer specified in the "utmr" parameter is an absolute time.
> > 
> >     TFD_TIMER_SEQ
> >         The time specified in the "utmr" parameter is an interval at
> > 	which a continuous clock rate will be generated.
> > 
> 
> Duh! Forgot to update the documenation. Now timerfd() gets an itimerspec.
> For TFD_TIMER_REL only the it_interval is valid, and it's the relative 
> time. For TFD_TIMER_ABS, only the it_value is valid, and that the expiry 
> absolute time. For TFD_TIMER_SEQ, it_value tells when the first tick 
> should be generated, and it_interval tells the period of the following 
> ticks.
> 

You should probably make it behave like the other things that use
itimerspec, just to avoid confusion -- i.e. timers are relative by
default, there's a flag that makes them absolute, they expire when
it_value specifies, and repeat every it_interval nanoseconds if
it_interval is non-zero.

i.e.

int timerfd(int ufd, int clockid, int flags, const struct timespec
*utmr);

with TFD_TIMER_ABS in flags making the timer absolute instead of
relative (and no TFD_TIMER_REL or TFD_TIMER_SEQ at all).

-- 
Nicholas Miell <nmiell@comcast.net>


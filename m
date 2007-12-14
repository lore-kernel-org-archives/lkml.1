Return-Path: <linux-kernel-owner+w=401wt.eu-S935149AbXLNANp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935149AbXLNANp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934925AbXLNANX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:13:23 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:36260 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934855AbXLNANW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:13:22 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 13 Dec 2007 16:13:19 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, tytso@thunk.org,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       Christoph Hellwig <hch@lst.de>,
       Linux Torvalds <torvalds@linux-foundation.org>
Subject: Re: Tesing of / bugs in new timerfd API
In-Reply-To: <cfd18e0f0712131416y6159af46v6d0c91d75130cd69@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0712131603010.10881@alien.or.mcafeemobile.com>
References: <47614369.3060906@gmail.com>  <Pine.LNX.4.64.0712131333030.10881@alien.or.mcafeemobile.com>
 <cfd18e0f0712131416y6159af46v6d0c91d75130cd69@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007, Michael Kerrisk wrote:

> > > BUG 2:
> > > The last sentence does not match the implementation.
> > > (Nor is it consistent with the behavior of POSIX timers.
> > > And I *think* things did work correctly in the original
> > > timerfd() implementation, but I have not gone back to check.)
> > >
> > > Suppose that we set an absolute timer to expire 100 seconds
> > > in the future.  Then according to this sentence of the man
> > > page then each subsequent call to timerfd_gettime() should
> > > retrun an itimerspec structure whose it_value steadily
> > > decreases from 100 to 0 (when the timer expires).  (This
> > > is the behavior in the analogous situation with POSIX timers
> > > and with setitimer()/getitimer().)
> > >
> > > However, the implementation of timerfd_gettime() always
> > > returns the "time when the timer would next expire", and
> > > this value depends on whether TFD_TIMER_ABSTIME was specified
> > > when setting the timer.
> >
> > This is been like that from the beginning of the new API. So no, the
> > previous was behaving exactly the same WRT this feature.
> > Is this something really needed?
> 
> Three reasons that I think of off the top of my head (and there might
> well be more reasosn) why this should change:
> 
> a) consistency with the other two timer APIs (POSIX timers
> (timer_create(), etc.), and setitimer()/getitimer()).
> 
> b) Returning the amount of time until the next expiration  is more
> useful to userland: I'd say the most common case is for userland to
> want to know how long until the next expiration occurs, or to adjust
> that time by adding/subtracting some value to the existing setting.
> That is difficult to with the current implementation: the userland app
> must use timer_gettime(), call clock_gettime(), and calculate the
> difference between the two, in order to know how much time remains
> until the next timer expiration.

Bah, I don't want to argue with that because otherwise it starts going 
towards the "typical" use cases listing, that can be found the same exact 
reasons to have one or the other way. And we end up wasting lots of time.
We'd just have to move another thing that userspace could do, inside the 
kernel (subtract the current value returned by hrtimer_forward() in 
->expires with "now").




> c) Currently, the information returned differs depending on whether
> TFD_TIMER_ABSTIME is specified -- this is not the case for the
> analogous situation for POSIX timers.  For POSIX timers, the returned
> setting is always the amount of time until the timer next expires.
> This inconsistency is messy for applications -- the application may
> not (be able to) know whether or not the timer it is examining was set
> using TFD_TIMER_ABSTIME (the timerfd might have been created by a
> library, for example).

Hmm... the time returned is always the next absolute time when the next 
timer tick will go off. It does not depend on TFD_TIMER_ABSTIME. I return 
the ->expires field of the timer, and hrtimer_forward() sets it to the 
next absolute time.




- Davide



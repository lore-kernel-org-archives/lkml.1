Return-Path: <linux-kernel-owner+w=401wt.eu-S933624AbXLMWQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624AbXLMWQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbXLMWQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:16:28 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:23505 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbXLMWQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:16:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fjr4XBlLL9P3+G88jZp+SseL0XbhhtZcbzzUar5Ec/eAbODCLvtHv+M9e7ENSkkGxLLZ7+KSIt5w8SE1eg9IYJ+u2gEZdMYSk/G58H8Cv/oMopFw6Vr9SKwPWRfK1bccSm+YmX2G0UJm63W4hJmkVl2VDGzUrx8JTvnPX7MSjXo=
Message-ID: <cfd18e0f0712131416y6159af46v6d0c91d75130cd69@mail.gmail.com>
Date: Thu, 13 Dec 2007 23:16:25 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: Tesing of / bugs in new timerfd API
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, tytso@thunk.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Greg KH" <gregkh@suse.de>,
       "Christoph Hellwig" <hch@lst.de>,
       "Linux Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712131333030.10881@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47614369.3060906@gmail.com>
	 <Pine.LNX.4.64.0712131333030.10881@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

On Dec 13, 2007 10:49 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Thu, 13 Dec 2007, Michael Kerrisk wrote:
>
> > Davide, Andrew,
> >
> > I applied Davide's v3 patchset (sent into LKML on 25 Nov) against
> > 2.4.24-rc3, and did various tests (all on x86).  Several tests
> > were done using the program at the foot of this mail.  Various others
> > were done by cobbling together bits of code that I haven't included
> > here.
>
> Thanks for such a thorough test Michael.

You're welcome!

[...]

> > BUG 2:
> > The last sentence does not match the implementation.
> > (Nor is it consistent with the behavior of POSIX timers.
> > And I *think* things did work correctly in the original
> > timerfd() implementation, but I have not gone back to check.)
> >
> > Suppose that we set an absolute timer to expire 100 seconds
> > in the future.  Then according to this sentence of the man
> > page then each subsequent call to timerfd_gettime() should
> > retrun an itimerspec structure whose it_value steadily
> > decreases from 100 to 0 (when the timer expires).  (This
> > is the behavior in the analogous situation with POSIX timers
> > and with setitimer()/getitimer().)
> >
> > However, the implementation of timerfd_gettime() always
> > returns the "time when the timer would next expire", and
> > this value depends on whether TFD_TIMER_ABSTIME was specified
> > when setting the timer.
>
> This is been like that from the beginning of the new API. So no, the
> previous was behaving exactly the same WRT this feature.
> Is this something really needed?

Three reasons that I think of off the top of my head (and there might
well be more reasosn) why this should change:

a) consistency with the other two timer APIs (POSIX timers
(timer_create(), etc.), and setitimer()/getitimer()).

b) Returning the amount of time until the next expiration  is more
useful to userland: I'd say the most common case is for userland to
want to know how long until the next expiration occurs, or to adjust
that time by adding/subtracting some value to the existing setting.
That is difficult to with the current implementation: the userland app
must use timer_gettime(), call clock_gettime(), and calculate the
difference between the two, in order to know how much time remains
until the next timer expiration.

c) Currently, the information returned differs depending on whether
TFD_TIMER_ABSTIME is specified -- this is not the case for the
analogous situation for POSIX timers.  For POSIX timers, the returned
setting is always the amount of time until the timer next expires.
This inconsistency is messy for applications -- the application may
not (be able to) know whether or not the timer it is examining was set
using TFD_TIMER_ABSTIME (the timerfd might have been created by a
library, for example).

Cheers,

Michael

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/

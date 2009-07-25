Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZGYLsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZGYLsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 07:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZGYLsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 07:48:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37118 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751522AbZGYLsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 07:48:37 -0400
Date: Sat, 25 Jul 2009 12:48:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
Message-ID: <20090725124859.530d158b@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
References: <200907240145.31935.rjw@sisk.pl>
	<2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
	<200907241721.45943.rjw@sisk.pl>
	<20090724164058.21a054e6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't know where you got that idea from. Avoiding breaking user space
> > unneccessarily is good but if its buggy you often can't do anything about
> > it.
> 
> Alan, he got that idea from me.
> 
> We don't do regressions. If user space depended on old behavior, we don't 
> change behavior

I think there are two bugs being confused here. The first kdesu bug isn't
the EIO one. It's just busted userspace code that happened to be lucky.
It's also impossible to keep that "luck" going. The other problem is the
EIO - which is a bug.

> And regardless of that, I do not think EIO is the right thing to return at 
> all. If the other side of a pty went away, return 0 and possibly send a 
> HUP, or whatever. What did we do before?

If the other side of a pty goes away we send SIGHUP and at that point
return -EIO as required by POSIX, SuS and various other things. You
cannot return "EOF" as that means the user caused an EOF event (eg hit
^D).

There is a bug going on here (the one that bites emacs meta-whatever
compile) where you get an -EIO and that seems to be timing related due to
flushing. I'm currently working on that one. I suspect we will need to
make the close on the writer wait for the data to be flushed through the
reader side and I'm testing some fixes for that.

So there are two things here that need not to be muddled up:

1. 	Case where kdesu from logging what is going on and code
inspection does:

	read
	not what I wanted
	discard the lot
	read
	oh damn I missed the bit I wanted

If we go back to the old pty approach we break ppp, locking rules and
everything else, and re-introduce DoS attacks (and some worse ones) going
back to 2.0 if not earlier.

2.	A case where previously it happened that

	write(pty, "Wibble", 6);
	close(pty);

	would *usually* block on close until the "Wibble" was consumed the
	other end. (ie logically speaking the buffering is on the writer
	not the reader)

	We can implement that (although probably a timeout to avoid
	certain deadlocks is needed)

I plan to fix #2 but not #1. There really isn't any way to keep #1 true.
Although the spec has nothing to say about #2 every implementation I've
you get the wibble reliably and we used to, so it needs fixing.

Alan

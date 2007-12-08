Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbXLHUFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbXLHUFc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXLHUFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:05:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52246 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbXLHUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:05:24 -0500
Subject: Re: lockdep problem conversion semaphore->mutex (dev->sem)
From: Peter Zijlstra <peterz@infradead.org>
To: Remy Bohmer <linux@bohmer.net>
Cc: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dgc@sgi.com>
In-Reply-To: <3efb10970712081152o2d4abcfbo634a8d2445c09699@mail.gmail.com>
References: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com>
	 <1197116185.31440.1.camel@twins>
	 <1197132792.1568.162.camel@jnielson-xp.ddns.mvista.com>
	 <1197133910.6353.33.camel@lappy>
	 <1197133577.1568.166.camel@jnielson-xp.ddns.mvista.com>
	 <1197135413.6353.36.camel@lappy>
	 <3efb10970712081152o2d4abcfbo634a8d2445c09699@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 21:04:36 +0100
Message-Id: <1197144276.6353.44.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-08 at 20:52 +0100, Remy Bohmer wrote:
> Hello Peter and Daniel,
> 
> > Yeah, it are different lock instances, however by virtue of sharing the
> > same lock init site, they belong to the same lock class. Lockdep works
> > by tracking class dependancies, not instance dependancies.
> 
> The device and its parent both indeed have different
> pointers/instances. I saw that during debugging yesterday, so I
> already expected this was not really a bug, but a false positive of
> lockdep.
> 
> > By generalizing to classes it can detect locking errors before they
> > actually occur.
> 
> Basically that is a good thing...
> But... now we do not transfer the dev->sem to a mutex, because lockdep
> will start generating false positives, and thus we mask the lockdep
> error, by not converting the dev->sem to what it really is...
> 
> This does give me a bad feeling about this...  In short, we are
> implementing workarounds in good code code to hide bugs in
> debug-tooling... ?!

Its not a bug, its a feature! :-)

> So, any suggestions on how to fix lockdep? Anyone some good hints
> where I can start?
> Is it that fundamental to lockdep that it cannot be fixed without
> breaking it, or do we have to instrument the code that tells lockdep
> to ignore this particular mutex?

I have a good idea on how to annotate this, but not yet the time to do
so. Aside from the nesting problems, the dev->sem has other problems as
well. Converting this is rather non-trivial.

I'd not put it as harshly as you put it though, lockdep makes some
assumptions which can lead to false positives - otoh these assumptions
often end up pointing out 'curious' locking coupled to 'curious' data
structures. And fixing up these things often leads to better and simpler
code.

The emphasis is on often, this is one of the cases where this is not so.
So while it does restain the creativity of locking it often ends up
being for the better.

And while you might not see it in-tree anymore, lockdep does help out
tremendously while developing new code. I'm sure that without it the
locking would be in a much worse state than it is today.


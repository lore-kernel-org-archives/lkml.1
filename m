Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbXEYCnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbXEYCnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 22:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbXEYCnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 22:43:12 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843AbXEYCnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 22:43:10 -0400
Date: Thu, 24 May 2007 19:41:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
In-Reply-To: <1180059605.3997.100.camel@nigel.suspend2.net>
Message-ID: <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org>
References: <1179870110.16656.2.camel@localhost> 
 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> 
 <1180008394.15600.26.camel@localhost>  <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
  <20070524200435.GA9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
  <20070524220017.GC9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
  <20070524221743.GD9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
  <20070524231852.GG9604@elf.ucw.cz>  <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
  <1180058123.3997.91.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org>
 <1180059605.3997.100.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Nigel Cunningham wrote:
> 
> To answer the question, I guess the answer is that although they're
> different creatures, they have similarities. This is one of them, which
> is why I could make the mistake I did. Nothing in the issue being
> discussed was unique to suspend-to-ram. Perhaps we (or at least I) focus
> too much on the similarities, but that doesn't mean they're not there.

I agree that the current bug is not unique to STR. In fact, I think Romano 
tested both STD and STR, and both had the same bug with the 60s timeout.

But what irritates me is that STR really shouldn't have _had_ that bug at 
all. The only reason STR had the same bug as STD was exactly the fact that 
the two features are too closely inter-twined in the kernel. 

That irritates me hugely. We had a bug we should never had had! We had a 
bug because people are sharing code that shouldn't be shared! We had a bug 
because of code that makes no sense in the first place!

I agree that disk snapshotting is much harder. If we had a bug just in 
that part, I wouldn't mind it so much. Getting hard problems wrong isn't 
something you should be ashamed of. What I mind is that the _easier_ 
problem got infected by all the bugs from the _harder_ issue. That just 
makes me really really angry and frustrated.

Look at it this way: if you designed a CPU, and you made the integer 
code-path share everything with the floating point side, because "addition 
is addition", and as a result the latency for the simple arithmetic and 
logical ops in integer ALU was four cycles, what would you be?

You'd be a moron, that's what. 

And that is _exactly_ what the current STD/STR code does. It says "suspend 
is suspend" and tries to share the same pipeline, even though the two 
operations are totally different, and share nothing but the name people 
use for it (and even the name is really pretty weak, and I've tried to 
get people to use some other name for STD).

So yes,the two things _do_ share the problem, but they really really 
shouldn't. There's no reason to think that they should. And it drives me 
absolutely bonkers that people seem to have such a hard time seeing that.

That said, I think freezing is crap even for snapshotting/suspend-to-disk, 
but the point of the above rant is to show how insane it is to think that 
problems and complexity in one area should translate into problems and 
complexity in another area.

And if the snapshot people want to screw up their snapshots with freezing, 
I don't actually care that much. I'd much rather have working STR. As it 
is now, they're now _both_ broken.

			Linus

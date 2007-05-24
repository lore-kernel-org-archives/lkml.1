Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbXEXWMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbXEXWMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXEXWMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:12:40 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbXEXWMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:12:39 -0400
Date: Thu, 24 May 2007 15:10:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Romano Giannetti <romanol@upcomillas.es>,
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
In-Reply-To: <20070524220017.GC9604@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org> <4652070D.3090509@redhat.com>
 <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
 <20070521212522.GL3429@sequoia.sous-sol.org> <1179870110.16656.2.camel@localhost>
 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
 <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
 <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
 <20070524220017.GC9604@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Pavel Machek wrote:
> > 
> > Equally arguably, we should just have a "resume_late()" call that can be 
> > used to do this after everything is up and running.
> 
> Yes, we can do that. But userland will see devices "not there" for a
> few seconds after boot.

No they won't.

Why the HELL cannot you realize that kernel threads are different?

The right thing to do is AND HAS ALWAYS BEEN, to stop and start user 
threads only around the whole thing.

Don't touch those kernel threads. Stop freezing them.

Then, what you do is:
 - stop user space
 - suspend
 - resume
 - start user space

and at no point do you touch any kernel threads.

And yes, that "resume" part is multi-phase. We already have 
"resume_early()" to do bus-level setup, and then "resume()" to do the 
"make devices work". I was suggesting adding a "resume_late()" phase to 
let the devices do things that require other devices to work, like doing 
firmware loading.

But stopping kernel threads is STUPID. As long as we continue to do that, 
it will never _ever_ work.

Yeah, we could re-start the kernel thread before "resume_late()", but the 
fact is, they shouldn't have been stopped in the first place.

			Linus

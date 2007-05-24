Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbXEXXTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbXEXXTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXEXXTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:19:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43290 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753546AbXEXXTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:19:07 -0400
Date: Fri, 25 May 2007 01:18:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Romano Giannetti <romanol@upcomillas.es>,
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
Message-ID: <20070524231852.GG9604@elf.ucw.cz>
References: <1179870110.16656.2.camel@localhost> <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org> <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org> <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org> <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org> <20070524221743.GD9604@elf.ucw.cz> <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Why the HELL cannot you realize that kernel threads are different?
> > 
> > Ugh? We are talking about request_firmware() here, right? That's
> > calling userland helper to load the firmware...? Looks like USER
> > thread to me.
> 
> Right. And if we had had the nice old /sbin/hotplug thing, it would all 
> have worked fine - because it would just have done an execve(), and things 
> would be happy.
> 
> But people screwed that up too, and now udevd is an undebuggable user 
> thread. Shit happens. See my other email about why even user threads can 
> probably not be frozen, and the whole freezer thing is misdesigned.

I'm not ready to redesign udevd :-(.

Your other mail proves that either

1) we can stop freezing udevd, and pray udevd does not become confused
by "half hardware not available" while system is being suspended

_or_

2) we need to preload firmware during _suspend_. I AM TELLING THAT TO
PEOPLE FOR FIVE YEARS NOW.

> And I repeat: PowerPC had working and stable suspend five _years_ ago, 
> without any of that freezing crud. We should rip it out.

Imageine we killed freezer. Also imagine Romano has IDE card his
PCMCIA slot. Kaboom, we solved nothing. We'll either deadlock or do
something very nasty to the filesystem on the IDE card ... because
we'll have udevd running, but fs on IDE card not available.

That does not work. "Not freezing udevd" only makes problems hard to
trigger, see?

Now... "should we rip freezer out of suspend" is a different story. It
does not help _here_. We still need to load the firmware during
_suspend_.

[Can you ack this point and we can have nice flamewar about ripping
out freezer?]

But I'd actually like to get rid of freezer for suspend (I believe
it is needed for hibernation) -- we'll need to do similar that for
runtime suspending of devices, anyway. But "just rip it out" will
cause some hard to debug breakage, we need to somehow audit the
drivers, or ask driver writers to audit them or something. ... and
yes, ripping freezer out _will_ make drivers more complex. Your video
capture card will now have to deal with

"ouch, I was already told to suspend, and now someone is calling my
ioctls() ?!".
								
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

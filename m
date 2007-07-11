Return-Path: <linux-kernel-owner+w=401wt.eu-S1765083AbXGKWeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765083AbXGKWeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXGKWeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:34:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764361AbXGKWeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:34:04 -0400
Date: Wed, 11 Jul 2007 15:33:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
cc: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
In-Reply-To: <29701.1184191888@turing-police.cc.vt.edu>
Message-ID: <alpine.LFD.0.999.0707111524510.20061@woody.linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
 <20070711211638.GE18767@one.firstfloor.org> <28188.1184190381@turing-police.cc.vt.edu>
            <20070711215412.GZ4306@sequoia.sous-sol.org>
 <29701.1184191888@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jul 2007, Valdis.Kletnieks@vt.edu wrote:
> 
> <Takes a closer look at the patches>  D'Oh! :)  Yeah, the -rc4 version I'm
> looking at is like a dozen 1-3K patches setting up and cleaning up, and then
> one monster 65K patch doing the clockevents conversion, then another 6 or 8
> small ones.
> 
> Yeah, that one big patch really doesn't look separable to me. 

I think it should be.

That big patch really does do a *lot* more than just the "clockevents 
conversion". It does all the hpet clock setup changes etc that are about 
the hardware, and have *nothing* to do with actually changing the 
interfaces.

For example, look at the hpet.c part of that patch. Totally independent 
cleanups of everything else.

Or look at the changes to __setup_APIC_LVTT(). Same thing. 

All the actual hardware interface changes are *totally* independent of the 
software interface changes, and a lot of them are just cleanups.

But those hardware interface changes are easily the things that can break, 
where some cleanup results in register writes being done in a different 
order or something, and so if there's a bug there (and it's not visible on 
most setups), now you cannot tell where the bug is.

Another example: setup_APIC_timer() used to wait for a timer interrupt 
trigger to happen on the i8259 timer (or HPET). That code just got 
removed (or maybe it got moved so subtly that I just don't see it). 

What has that got to do with switching from the old timer interface to the 
new one?

NOTHING.

So those kinds of changes that change hardware access functions should 
have been done separately. Maybe there's a machine where that early 
synchronization was necessary for some subtle timing reason. If so, 
removing it sounds like a bug, no? Wouldn't it have been nice to see that 
removal as a separate patch that was independent of the interface switch- 
over?

I'd be a *lot* happier with switching over interfaces if I thought that 
the low-level hardware drivers didn't change at the same time. But they 
*do* change, afaik.

		Linus

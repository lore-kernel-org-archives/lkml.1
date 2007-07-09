Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbXGIT0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbXGIT0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbXGIT0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:26:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754368AbXGIT0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:26:33 -0400
Date: Mon, 9 Jul 2007 12:26:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: queued spinlock code and results
In-Reply-To: <Pine.LNX.4.64.0707091140440.15898@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.999.0707091212410.3412@woody.linux-foundation.org>
References: <20070708043228.GB22397@wotan.suse.de>
 <Pine.LNX.4.64.0707091140440.15898@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Jul 2007, Davide Libenzi wrote:
> 
> So in this box, and in this test, the double-short Z-lock seems faster 
> than a double-byte. I've no idea why, since it uses two ops more and an 
> extra register.

At this kind of level, the exact instruction scheduling can make a big 
difference.

The extra register usage won't matter if there is no register pressure, 
and any extra instructions can actually happen to *help*, if they end up 
just aligning something just the right way.

There can also be various random effects of prefixes: decoding x86 
instructions is basically a very uarch-specific issue, and for all we know 
it might be that the AMD setup may well end up behaving differently from 
most Intel chips (and within the Intel family, the netburst situation is 
likely different from the other P6-derived cores).

For example, does a single prefix decode faster? It could be that the 
combination of "lock" _and_ "opsize" prefixes is problematic (as in a 
16-bit locked "lock xaddw"), and causes a decode hickup, but that "lock" 
and "opsize" on their own don't cause any decoder issues (ie doing the 
"lock" on the 32-bit xadd, and just the "opsize" prefix on the 16-bit decw 
both are fast).

But on another uarch it might work out the other way: if "lock" is always 
a complex op, then having a opsize prefix on that one might be "free", and 
then you're better combining them for the locked 16-bit xadd, and having 
the releasing "decb" not have any prefix at all.

And regardless of that, just a random "it happened to get aligned that 
way" (where "alignment" might be about hitting the cache-line just right, 
but might also be about just having the right instruction mix to get the 
intel decoders to run at their full 4-1-1-1 capacity), causing the timing 
differences.

So before taking these numbers as any kind of "real" values, I'd suggest:

 - trying it out on at least a few different uarchs (Opteron, P4 and Core 
   2 all have quite different restrictions on decoding)

 - possibly trying it out with things in different order and different 
   compiler options (-O2 vs -Os), trying to cause different kinds of 
   alignment issues.

Also, just a small nit: in the kernel, the locking would _not_ be inlined 
(but the unlocking would), so marking the lock functions "inline" is 
probably a bad idea. Without the inline, it's likely more realistic, and 
the effects of register pressure will be hidden. Because of the uninlining 
nature of locks, I think you can generally ignore the "one or two 
registers" issue - you'll have three caller-clobbered registers to play 
with regardless.

			Linus

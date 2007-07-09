Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbXGITrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbXGITrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbXGITrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:47:10 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3494 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbXGITrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:47:09 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 9 Jul 2007 12:47:06 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: queued spinlock code and results
In-Reply-To: <alpine.LFD.0.999.0707091212410.3412@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707091241350.15898@alien.or.mcafeemobile.com>
References: <20070708043228.GB22397@wotan.suse.de>
 <Pine.LNX.4.64.0707091140440.15898@alien.or.mcafeemobile.com>
 <alpine.LFD.0.999.0707091212410.3412@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Linus Torvalds wrote:

> On Mon, 9 Jul 2007, Davide Libenzi wrote:
> > 
> > So in this box, and in this test, the double-short Z-lock seems faster 
> > than a double-byte. I've no idea why, since it uses two ops more and an 
> > extra register.
> 
> At this kind of level, the exact instruction scheduling can make a big 
> difference.
> 
> The extra register usage won't matter if there is no register pressure, 
> and any extra instructions can actually happen to *help*, if they end up 
> just aligning something just the right way.
> 
> There can also be various random effects of prefixes: decoding x86 
> instructions is basically a very uarch-specific issue, and for all we know 
> it might be that the AMD setup may well end up behaving differently from 
> most Intel chips (and within the Intel family, the netburst situation is 
> likely different from the other P6-derived cores).
> 
> For example, does a single prefix decode faster? It could be that the 
> combination of "lock" _and_ "opsize" prefixes is problematic (as in a 
> 16-bit locked "lock xaddw"), and causes a decode hickup, but that "lock" 
> and "opsize" on their own don't cause any decoder issues (ie doing the 
> "lock" on the 32-bit xadd, and just the "opsize" prefix on the 16-bit decw 
> both are fast).
> 
> But on another uarch it might work out the other way: if "lock" is always 
> a complex op, then having a opsize prefix on that one might be "free", and 
> then you're better combining them for the locked 16-bit xadd, and having 
> the releasing "decb" not have any prefix at all.
> 
> And regardless of that, just a random "it happened to get aligned that 
> way" (where "alignment" might be about hitting the cache-line just right, 
> but might also be about just having the right instruction mix to get the 
> intel decoders to run at their full 4-1-1-1 capacity), causing the timing 
> differences.
> 
> So before taking these numbers as any kind of "real" values, I'd suggest:
> 
>  - trying it out on at least a few different uarchs (Opteron, P4 and Core 
>    2 all have quite different restrictions on decoding)
> 
>  - possibly trying it out with things in different order and different 
>    compiler options (-O2 vs -Os), trying to cause different kinds of 
>    alignment issues.
> 
> Also, just a small nit: in the kernel, the locking would _not_ be inlined 
> (but the unlocking would), so marking the lock functions "inline" is 
> probably a bad idea. Without the inline, it's likely more realistic, and 
> the effects of register pressure will be hidden. Because of the uninlining 
> nature of locks, I think you can generally ignore the "one or two 
> registers" issue - you'll have three caller-clobbered registers to play 
> with regardless.

Indeed, with no inline, on a P4 (with -O2), numbers betweeen xadd-lock 
and zadd-lock gets closer:

inc-lock in cache takes 35.15ns
xadd-lock in cache takes 43.84ns
vadd-lock in cache takes 53.51ns
zadd-lock in cache takes 43.28ns
inc-lock out of cache takes 122.92ns
xadd-lock out of cache takes 126.98ns
vadd-lock out of cache takes 172.36ns
zadd-lock out of cache takes 126.01ns

The always-lfence instruction in vadd-lock really is painfull though.
If numbers are close, and given that spinlock size considering structure 
alignments should not matter much, wouldn't it be better to use a double 
short and remove the 256 CPUs cap?



- Davide



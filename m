Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZGCTif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZGCTif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757128AbZGCTi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:38:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756475AbZGCTi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:38:27 -0400
Date: Fri, 3 Jul 2009 12:38:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <eric.dumazet@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: atomic64: inline atomic64_read()
In-Reply-To: <20090703191709.GA17057@elte.hu>
Message-ID: <alpine.LFD.2.01.0907031221340.3210@localhost.localdomain>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain> <tip-9103cab145a93cef13378632b332a824758a2f6f@git.kernel.org> <4A4E1AA2.30002@gmail.com> <20090703180450.GB3405@elte.hu> <alpine.LFD.2.01.0907031207030.3210@localhost.localdomain>
 <20090703191709.GA17057@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Btw, it's entirely possible that we could have a faster "atomic64_read()" 
if we have some guarantees about the behavior of the counter.

For example, let's assume that the counter is known to be monotonic: in 
that case, we could do a 64-bit read with something like

  u64 atomic64_read_monotonic(atomic64_t *p)
  {
	unsigned int last = read_high_word(p);
	do {
		lfence;
		low = read_low_word(p);
		high = last;
		lfence;
		last = read_high_word;
	} while (last != high)
	return ((u64)high << 32) | low;
  }

which is not necessarily all that much faster than the cmpxchg8b (the two 
lfence's aren't going to be cheap), but keeping the cacheline in a shared 
state might be a win.

Here, the "monotonic" part is only important because the above would not 
work in case the counter switches back and forth, ie if the value ever 
does an atomic increment and then an atomic decrement like this:

	0x0ffffffff -> 0x100000000 -> 0x0ffffffff

then the above read logic might see a "stable" high word of 0 (before and 
after), and a low word of 0 (in the middle), and think that the counter 
really was 0 at one point.

But if it's a strictly monotonic counter, or has some other stability 
guarantees (the way we have certain stability guarantees on PTE's, for 
example: we know that the high bits can only change if the low bits 
changed the present bit), you can sometimes do tricks like the above.

Do we actually _have_ any performance-critical 64-bit counters that have 
monotonicity guarantees? I have no idea. I'm just throwing out the notion.

			Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbZGCQ74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbZGCQ74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbZGCQ7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:59:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754382AbZGCQ7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:59:48 -0400
Date: Fri, 3 Jul 2009 09:58:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, paulus@samba.org,
       acme@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       arnd@arndb.de, fweisbec@gmail.com, dhowells@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:perfcounters/urgent] x86: atomic64: The atomic64_t data
 type should be 8 bytes aligned on 32-bit too
In-Reply-To: <tip-bbf2a330d92c5afccfd17592ba9ccd50f41cf748@git.kernel.org>
Message-ID: <alpine.LFD.2.01.0907030947300.3210@localhost.localdomain>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain> <tip-bbf2a330d92c5afccfd17592ba9ccd50f41cf748@git.kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Jul 2009, tip-bot for Eric Dumazet wrote:
> 
> x86: atomic64: The atomic64_t data type should be 8 bytes aligned on 32-bit too
> 
> Locked instructions on two cache lines at once are painful. If
> atomic64_t uses two cache lines, my test program is 10x slower.
> 
> The chance for that is significant: 4/32 or 12.5%.

Btw, the comments here are not strictly correct.

It's not necessarily even about "two cachelines". It's true that crossing 
cachelines is extra painful, but from a CPU core angle, there's another 
access width that matters almost as much, namely the width of the bus 
between the core and the L1 cache. If it's not aligned to that, the core 
needs to do each 8-byte read/write as two accesses, even if it's to the 
same cacheline, and that complicates things.

The cacheline itself is generally larger than the cache access width. I 
could easily see a 64B cacheline, but a 256b (32B) bus between the cache 
and the core.

Making the atomics be naturally aligned means that you never cross either 
one, of course.

			Linus

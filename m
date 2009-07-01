Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZGARVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZGARVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbZGARVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:21:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbZGARVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:21:10 -0400
Date: Wed, 1 Jul 2009 10:20:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: mingo@elte.hu, akpm@linux-foundation.org, paulus@samba.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] FRV: Implement atomic64_t
In-Reply-To: <20090701164700.29780.15103.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain>
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Jul 2009, David Howells wrote:
> +
> +#define ATOMIC64_INIT(i)	{ (i) }
> +#define atomic64_read(v)	((v)->counter)
> +#define atomic64_set(v, i)	(((v)->counter) = (i))

These seem to be buggy.

At least "atomic64_read()" needs to make sure to actually read it 
atomically - otherwise you'll do two 32-bit reads, and that just gets 
crap. Imagine if somebody is adding 1 to 0x00000000ffffffff, and then 
"atomic64_read()" reads it as two accesses in the wrong place, and gets 
either 0, or 0x00000001ffffffff, both of which are totally incorrect.

The case of 'atomic64_set()' is _slightly_ less clear, because I think we 
use it mostly for initializers, so atomicity is often not strictly 
required. But at least on x86, we do guarantee that it sets it atomically 
too.

Btw, Ingo: I looked at the x86-32 versions to be sure, and noticed a 
couple of buglets:

 - atomic64_xchg uses "atomic_read()". Sure, it happens to work, since 
   the "atomic_read()" is not type-safe, and gets a non-atomic 64-bit 
   read, but that looks really really bogus.

   It _should_ use __atomic64_read(), and the 64-bit versions should use a 
   different counter name ("counter64"?) or we should use an inline 
   function for atomic_read(), so that the type safety issue gets fixed.

 - atomic64_read() is being stupid with the whole loop thing. It _should_ 
   just do

	static inline unsigned long long atomic64_read(atomic64_t *ptr)
	{
		unsigned long long old = __atomic64_read(ptr);
		return cmpxchg8b(ptr, old, old);
	}

   and that's it. No loop. cmpxchg8b() will return the right thing.

 - Similarly, atomic64_add_return() is bogus for the same reasons: using 
   the wrong 'atomic_read()', and unnecessarily ignoring the returned old 
   value. It probably should do

	static inline unsigned long long
	atomic64_add_return(unsigned long long delta, atomic64_t *ptr)
	{
		unsigned long long old;

		old = __atomic_read64(ptr);
		for (;;) {
			unsigned long long tmp, new;
			new = old + delta;
			tmp = atomic64_cmpxchg(ptr, old, new);
			if (tmp == old)
				return new;
			old = tmp;
		}
	}

   or something. NOTE NOTE NOTE! Not tested!

Those functions also almost certainly should _not_ be inlined. They need 
so many registers that inlining them is crazy.

			Linus

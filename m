Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbZGBVNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbZGBVNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbZGBVNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:13:21 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:43672 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbZGBVNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:13:21 -0400
Message-ID: <4A4D2239.5000602@gmail.com>
Date: Thu, 02 Jul 2009 23:10:17 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, mingo@elte.hu,
       akpm@linux-foundation.org, paulus@samba.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] FRV: Implement atomic64_t
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 02 Jul 2009 23:10:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> 
> On Wed, 1 Jul 2009, David Howells wrote:
>> +
>> +#define ATOMIC64_INIT(i)	{ (i) }
>> +#define atomic64_read(v)	((v)->counter)
>> +#define atomic64_set(v, i)	(((v)->counter) = (i))
> 
> These seem to be buggy.
> 
> At least "atomic64_read()" needs to make sure to actually read it 
> atomically - otherwise you'll do two 32-bit reads, and that just gets 
> crap. Imagine if somebody is adding 1 to 0x00000000ffffffff, and then 
> "atomic64_read()" reads it as two accesses in the wrong place, and gets 
> either 0, or 0x00000001ffffffff, both of which are totally incorrect.
> 
> The case of 'atomic64_set()' is _slightly_ less clear, because I think we 
> use it mostly for initializers, so atomicity is often not strictly 
> required. But at least on x86, we do guarantee that it sets it atomically 
> too.
> 
> Btw, Ingo: I looked at the x86-32 versions to be sure, and noticed a 
> couple of buglets:
> 
>  - atomic64_xchg uses "atomic_read()". Sure, it happens to work, since 
>    the "atomic_read()" is not type-safe, and gets a non-atomic 64-bit 
>    read, but that looks really really bogus.
> 
>    It _should_ use __atomic64_read(), and the 64-bit versions should use a 
>    different counter name ("counter64"?) or we should use an inline 
>    function for atomic_read(), so that the type safety issue gets fixed.
> 
>  - atomic64_read() is being stupid with the whole loop thing. It _should_ 
>    just do
> 
> 	static inline unsigned long long atomic64_read(atomic64_t *ptr)
> 	{
> 		unsigned long long old = __atomic64_read(ptr);
> 		return cmpxchg8b(ptr, old, old);
> 	}
> 
>    and that's it. No loop. cmpxchg8b() will return the right thing.

Using a fixed initial value (instead of __atomic64_read()) is even faster, 
it apparently permits cpu to use an appropriate bus transaction.

static inline unsigned long long atomic64_read(atomic64_t *ptr)
{
	unsigned long long old = 0LL ;

	return cmpxchg8b(&ptr->counter, old, old);
}

I also rewrote cmpxchg8b() to not use %edi register but a generic "+m" constraint.

static inline unsigned long long
cmpxchg8b(unsigned long long *ptr, unsigned long long old, unsigned long long new)
{
        unsigned long low = new;
        unsigned long high = new >> 32;

        asm volatile(
                LOCK_PREFIX "cmpxchg8b %1\n"
                     :  "+A" (old), "+m" (*ptr)
                     :  "b" (low), "c" (high)
                     );
        return old;
}



I got a 4 x speedup on a dual quad core (Intel E5450) machine if all cpus try 
to *read* the same atomic64 location.

I tried various init value and got additional 5 % speedup chosing a
value *most probably* different than actual atomic64 one,
like (1LL << 32), with nice asm output...

static inline unsigned long long atomic64_read(atomic64_t *ptr)
{
	unsigned long long old = (1LL << 32) ;

	return cmpxchg8b(&ptr->counter, old, old);
}

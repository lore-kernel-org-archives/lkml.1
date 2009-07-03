Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbZGCLSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbZGCLSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 07:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZGCLSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 07:18:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41271 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbZGCLSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 07:18:04 -0400
Date: Fri, 3 Jul 2009 13:17:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       paulus@samba.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] FRV: Implement atomic64_t
Message-ID: <20090703111755.GA7161@elte.hu>
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <4A4D2239.5000602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A4D2239.5000602@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Linus Torvalds a écrit :
> > 
> > On Wed, 1 Jul 2009, David Howells wrote:
> >> +
> >> +#define ATOMIC64_INIT(i)	{ (i) }
> >> +#define atomic64_read(v)	((v)->counter)
> >> +#define atomic64_set(v, i)	(((v)->counter) = (i))
> > 
> > These seem to be buggy.
> > 
> > At least "atomic64_read()" needs to make sure to actually read it 
> > atomically - otherwise you'll do two 32-bit reads, and that just gets 
> > crap. Imagine if somebody is adding 1 to 0x00000000ffffffff, and then 
> > "atomic64_read()" reads it as two accesses in the wrong place, and gets 
> > either 0, or 0x00000001ffffffff, both of which are totally incorrect.
> > 
> > The case of 'atomic64_set()' is _slightly_ less clear, because I think we 
> > use it mostly for initializers, so atomicity is often not strictly 
> > required. But at least on x86, we do guarantee that it sets it atomically 
> > too.
> > 
> > Btw, Ingo: I looked at the x86-32 versions to be sure, and noticed a 
> > couple of buglets:
> > 
> >  - atomic64_xchg uses "atomic_read()". Sure, it happens to work, since 
> >    the "atomic_read()" is not type-safe, and gets a non-atomic 64-bit 
> >    read, but that looks really really bogus.
> > 
> >    It _should_ use __atomic64_read(), and the 64-bit versions should use a 
> >    different counter name ("counter64"?) or we should use an inline 
> >    function for atomic_read(), so that the type safety issue gets fixed.
> > 
> >  - atomic64_read() is being stupid with the whole loop thing. It _should_ 
> >    just do
> > 
> > 	static inline unsigned long long atomic64_read(atomic64_t *ptr)
> > 	{
> > 		unsigned long long old = __atomic64_read(ptr);
> > 		return cmpxchg8b(ptr, old, old);
> > 	}
> > 
> >    and that's it. No loop. cmpxchg8b() will return the right thing.
> 
> Using a fixed initial value (instead of __atomic64_read()) is even faster, 
> it apparently permits cpu to use an appropriate bus transaction.
> 
> static inline unsigned long long atomic64_read(atomic64_t *ptr)
> {
> 	unsigned long long old = 0LL ;
> 
> 	return cmpxchg8b(&ptr->counter, old, old);
> }

Good point. I've done a simple:

u64 atomic64_read(atomic64_t *ptr)
{
        return cmpxchg8b(ptr, 0, 0);
}

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbXF0ULR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbXF0ULR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbXF0ULH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:11:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39537 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbXF0ULG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:11:06 -0400
Date: Wed, 27 Jun 2007 22:10:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       Chuck Ebbert <cebbert@redhat.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Miklos Szeredi <miklos@szeredi.hu>, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070627201008.GA957@elte.hu>
References: <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org> <4680D162.9050603@yahoo.com.au> <alpine.LFD.0.98.0706261016200.8675@woody.linux-foundation.org> <4681F448.3040201@yahoo.com.au> <alpine.LFD.0.98.0706262249590.8675@woody.linux-foundation.org> <alpine.LFD.0.98.0706271233300.8675@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706271233300.8675@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> With the sequence counters, the situation is more complex:
> 
> 	CPU #0					CPU #1
> 
> 	A (= code before the spinlock)
> 
> 	lock xadd mem	(serializing instruction)
> 
> 	B (= code afte xadd, but not inside lock)
> 
> 						lock release
> 
> 	cmp head, tail
> 
> 	C (= code inside the lock)
> 
> Now, B is basically the empty set, but that's not the issue I worry 
> about. The thing is, I can guarantee by the Intel memory ordering 
> rules that neither B nor C will ever have memops that leak past the 
> "xadd", but I'm not at all as sure that we cannot have memops in C 
> that leak into B!
> 
> And B really isn't protected by the lock - it may run while another 
> CPU still holds the lock, and we know the other CPU released it only 
> as part of the compare. But that compare isn't a serializing 
> instruction!
> 
> IOW, I could imagine a load inside C being speculated, and being moved 
> *ahead* of the load that compares the spinlock head with the tail! 
> IOW, the load that is _inside_ the spinlock has effectively moved to 
> outside the protected region, and the spinlock isn't really a reliable 
> mutual exclusion barrier any more!
> 
> (Yes, there is a data-dependency on the compare, but it is only used 
> for a conditional branch, and conditional branches are control 
> dependencies and can be speculated, so CPU speculation can easily 
> break that apparent dependency chain and do later loads *before* the 
> spinlock load completes!)
> 
> Now, I have good reason to believe that all Intel and AMD CPU's have a 
> stricter-than-documented memory ordering, and that your spinlock may 
> actually work perfectly well. But it still worries me. As far as I can 
> tell, there's a theoretical problem with your spinlock implementation.

hm, i agree with you that this is problematic. Especially on an SMT CPU 
it would be a big architectural restriction if prefetches couldnt cross 
cache misses. (and that's the only way i could see Nick's scheme 
working: MESI coherency coupled with the speculative use of that 
cacheline's value never "surviving" a MESI invalidation of that 
cacheline. That would guarantee that once we have the lock, any 
speculative result is fully coherent and no other CPU has modified it.)

	Ingo

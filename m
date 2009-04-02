Return-Path: <linux-kernel-owner+w=401wt.eu-S934246AbZDBCNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934246AbZDBCNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 22:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZDBCMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 22:12:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54324 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbZDBCMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 22:12:49 -0400
Date: Thu, 2 Apr 2009 04:10:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, grundler@parisc-linux.org,
       takata@linux-m32r.org, benh@kernel.crashing.org, rth@twiddle.net,
       ink@jurassic.park.msu.ru, heiko.carstens@de.ibm.com,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
	default percpu allocator
Message-ID: <20090402021024.GA26446@elte.hu>
References: <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com> <49D2B209.9060000@kernel.org> <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com> <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain> <20090401223241.GA28168@elte.hu> <20090401225754.GN8014@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401225754.GN8014@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Thu, Apr 02, 2009 at 12:32:41AM +0200, Ingo Molnar wrote:
> > And free_percpu(NULL) does this:
> > 
> > void free_percpu(void *ptr)
> > {
> >         void *addr = __pcpu_ptr_to_addr(ptr);
> >         struct pcpu_chunk *chunk;
> >         unsigned long flags;
> >         int off;
> > 
> >         if (!ptr)
> >                 return;
> 
> Why don't we rewrite this as:
> 
> -	void *addr = __pcpu_ptr_to_addr(ptr);
> +	void *addr;
> ...
> 	if (!ptr)
> 		return;
> 	addr = __pcpu_ptr_to_addr(ptr);
> 
> if kfree(NULL) is really that important, we should avoid doing this
> extra work, not just rely on the variable being cache-hot.

Yes, of course we can fix that, the NULL fastpath needs no access to 
anything but the call parameter.

Note that my argument was different though: that assumptions about 
variable correlation are very hard to track and validate, and that 
IMHO we should be using __read_mostly generously (we know _that_ 
attribute with a rather high likelyhood), and we should group the 
remaining variables together, starting at a cacheline aligned 
address.

A sub-argument was that the boundary between global variables from 
different .o files should perhaps not be 'merged' together (on SMP), 
because the sharing effects are not maintainable: an example of 
badness is the sb_lock false cacheline sharing that Christoph's 
patch triggered (randomly).

A sub-sub argument was that perhaps we should not split .data and 
.bss variables into separate sections - it doubles the chance of 
false cacheline sharing and spreads the cacheline footprint.

	Ingo

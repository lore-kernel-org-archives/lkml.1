Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbYHRHzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbYHRHzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYHRHzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:55:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60505 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbYHRHze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:55:34 -0400
Date: Mon, 18 Aug 2008 09:54:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
Message-ID: <20080818075459.GH30694@elte.hu>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org> <20080817173319.GA2450@elte.hu> <200808181109.43203.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808181109.43203.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Monday 18 August 2008 03:33:19 Ingo Molnar wrote:
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > Gag me now.
> > >
> > > Why not just do
> > >
> > >  #define __BBO(c)                sizeof(const char[1 - 2*!!(c)])
> > >  #define __BBONC(c)              __BBO(!__builtin_constant_p(c))
> > >  #define BUILD_BUG_ON_ZERO(c)    (__BBO(c) - __BBONC(c))
> > >  #define BUILD_BUG_ON(c)         (void)BUILD_BUG_ON_ZERO(c)
> > >
> > > and be done with it?
> >
> > yeah, i first tried a few variants of that (compile-time warnings are
> > much better than link time warnings), but none worked when i tested
> > various failure modes.
> 
> Hey, I thought I was the "undisputed ruler of Ugly-land".
> 
> How about this instead:
> 
> #define BUILD_BUG_ON(condition)						\
> do {									\
> 	static struct { char arr[1 - 2*!!(condition)]; } x __maybe_unused;	\
> } while(0)

hm, have you tried it and do we get a severe enough link error about 
that? If the macro gets ignored by the compiler that's really a hard 
error - such things are essential safeguards of kernel sanity:

	/*
	 * Build-time sanity checks on the kernel image and module
	 * area mappings. (these are purely build-time and produce no code)
	 */
	BUILD_BUG_ON(MODULES_VADDR < KERNEL_IMAGE_START);
	BUILD_BUG_ON(MODULES_VADDR-KERNEL_IMAGE_START < KERNEL_IMAGE_SIZE);
	BUILD_BUG_ON(MODULES_LEN + KERNEL_IMAGE_SIZE > 2*PUD_SIZE);
	BUILD_BUG_ON((KERNEL_IMAGE_START & ~PMD_MASK) != 0);
	BUILD_BUG_ON((MODULES_VADDR & ~PMD_MASK) != 0);
	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
	BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) ==
				(__START_KERNEL & PGDIR_MASK)));
	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) <= MODULES_END);

( and propagating them into runtime failures not only increases bloat,
  it also makes failures harder to debug. These checks 'run' _early_. )

Link time warnings are easy enough to miss.

So unless there's a better way of doing it all at compile time (i'd 
really prefer that!) i'd prefer the link time error about botched 
BUILD_BUG_ON() conditions - as my commits introduce.

	Ingo

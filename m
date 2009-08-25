Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZHYIlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZHYIlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZHYIlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:41:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56396 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbZHYIlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:41:00 -0400
Date: Tue, 25 Aug 2009 10:40:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
	memory  (f6f6e1a4), by kmemleak's scan_block()
Message-ID: <20090825084052.GE17692@elte.hu>
References: <20090825071959.GA25877@elte.hu> <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com> <1251187716.7261.2.camel@penberg-laptop> <1251188859.15678.6.camel@pc1117.cambridge.arm.com> <1251189105.7261.4.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251189105.7261.4.camel@penberg-laptop>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, 2009-08-25 at 09:27 +0100, Catalin Marinas wrote:
> > On Tue, 2009-08-25 at 11:08 +0300, Pekka Enberg wrote:
> > > On Tue, 2009-08-25 at 10:04 +0200, Vegard Nossum wrote:
> > > > 2009/8/25 Ingo Molnar <mingo@elte.hu>:
> > > > > FYI, -tip testing triggered the following kmemcheck warning in
> > > > > kmemleak:
> > > > >
> > > > > PM: Adding info for No Bus:vcsa7
> > > > > WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6f6e1a4)
> > > > > d873f9f600000000c42ae4c1005c87f70000000070665f666978656400000000
> > > > >  i i i i u u u u i i i i i i i i i i i i i i i i i i i i i u u u
> > [...]
> > > > Already the patch to make kmemcheck and kmemleak mutually exclusive is
> > > > underway. It is not surprising that kmemleak is scanning uninitialized
> > > > memory. But if you say that you have tried it before, it is strange
> > > > that it didn't appear until now.
> > > 
> > > Why isn't it surprising? Yes, it's non-fatal for kmemleak to scan
> > > uninitialized memory but we could be looking at non-initialized struct
> > > member that's a bug waiting to happen elsewhere in the code (that
> > > doesn't trigger often).
> > 
> > It isn't surprising to me either. Kmemleak scans the memory periodically
> > but it cannot know whether such memory was initialised or not to avoid
> > scanning it. So I would expect such warnings if both kmemleak and
> > kmemcheck are enabled. Scanning uninitialised memory is fine with
> > kmemleak, it just increases the number of false negatives (with
> > SLAB_DEBUG enabled, however, the allocated blocks are pre-initialised).
> > 
> > So kmemleak and kmemcheck should be exclusive, unless there is a way for
> > kmemleak to validate an address with kmemcheck before deciding whether
> > to scan a memory block.
> 
> It's possible. Look at the kmemcheck_shadow_lookup() and 
> kmemcheck_shadow_test() calls in kmemcheck_read_strict(), for 
> example.
> 
> Vegard, what do you think? I think making kmemcheck and kmemleak 
> play nice with each other is useful for people like Ingo who do 
> automated testing.

There's already a couple of exclusion rules in kmemcheck:

menuconfig KMEMCHECK
        bool "kmemcheck: trap use of uninitialized memory"
        depends on DEBUG_KERNEL
        depends on !X86_USE_3DNOW
        depends on SLUB || SLAB
        depends on !CC_OPTIMIZE_FOR_SIZE
        depends on !FUNCTION_TRACER

such type of Kconfig driven exclusion is usually a somewhat lame way 
to express limitations in the software.

CC_OPTIMIZE_FOR_SIZE is an externality that cannot be eliminated, 
but the others could be improved - and we should definitely not 
extend the list of exclusions.

	Ingo

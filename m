Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbYHQSpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbYHQSpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 14:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYHQSpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 14:45:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbYHQSpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 14:45:47 -0400
Date: Sun, 17 Aug 2008 20:45:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
Message-ID: <20080817184510.GA16508@elte.hu>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <200808162055.45136.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808161305170.3324@nehalem.linux-foundation.org> <20080817103241.GB21303@elte.hu> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org> <20080817173319.GA2450@elte.hu> <alpine.LFD.1.10.0808171129350.3324@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808171129350.3324@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 17 Aug 2008, Ingo Molnar wrote:
> > 
> > try the patch below - it only gives this error during build:
> 
> Well, you didn't do it right:
> 
> > +#define __BBO(c)                sizeof(const char[1 - 2*!!(c)])
> > +#define __BBONC(c)              __BBO(!__builtin_constant_p(c))
> > +#define BUILD_BUG_ON_ZERO2(c)    (__BBO(c) - __BBONC(c))
> > +#define BUILD_BUG_ON2(c)         (void)BUILD_BUG_ON_ZERO(c)
> 
> Look at the #define of BUILD_BUG_ON2 a bit more.
> 
> Hint: you're using the _wrong_ BUILD_BUG_ON_ZERO. The old one, not the v2 
> one!

yeah, i already tried various variants earlier today so i really didnt try
that hard with yours. (and i pointed out this mistake in the previous mail)

> That said, with that fixed, there's still something wrong. It does seem 
> like gcc has some very odd interaction there with __builtin_constant_p. 
> Odd.

yeah. I tried various integer arithmetic expressions (which the array trick
relies on) and it didnt work as expected - it's always zero. It only makes
a difference when used in comparisons. (and that's where the kernel uses
__builtin_constant_p quite heavily, and it works fine there.)

Odd indeed.

	Ingo

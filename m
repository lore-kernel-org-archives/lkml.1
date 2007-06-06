Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbXFFHam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbXFFHam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXFFHae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:30:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57608 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbXFFHad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:30:33 -0400
Date: Wed, 6 Jun 2007 09:30:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] kernel/sched{,_fair}.c: make code static
Message-ID: <20070606073023.GA11250@elte.hu>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070605215056.GJ5500@stusta.de> <20070605235441.7b132e27.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605235441.7b132e27.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > 
> > ---
> > 
> > BTW: Please don't #include C files in sched.c
> 
> Yeah.

In this case it's not that bad. It makes the source quite a bit cleaner 
and avoids having to create artificial interfaces, global functions, 
etc. between the .o's.

> > -long div64_s(s64 divident, unsigned long divisor)
> > +static long div64_s(s64 divident, unsigned long divisor)
> 
> "divident" does appear to be a word, but I suspect "dividend" was 
> intended.

yeah indeed - fixed.

> Why is this function lurking in the CPU scheduler rather than in 
> lib/somewhere.c?
> 
> Doesn't an unsigned divide give the same result as a signed one?

no! 0xfffffff0 / 2 is 0x7fffffff when the division is unsigned, and 
7ffffff8 (== -8) when signed. On x86 the silicon only offers us unsigned 
64-bit division, so we first have to make '+16' out of -16, then divide 
by 2, and turn the +4 into -4. (On x86_64 there's no such problem, 
there's an idiv and a div 64-bit instruction as well, and gcc picks the 
right one depending on the type of the variable.)

i think Roman has recently done a nice cleanup patch that introduces 
this? I'll change CFS to use that interface once it's upstream.

	Ingo

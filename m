Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbZBDW2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbZBDW2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbZBDW2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:28:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656AbZBDW2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:28:00 -0500
Date: Wed, 4 Feb 2009 23:25:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] timer fix
Message-ID: <20090204222543.GA19944@elte.hu>
References: <20090204192551.GA19539@elte.hu> <alpine.LFD.2.00.0902041400100.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902041400100.3247@localhost.localdomain>
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

> On Wed, 4 Feb 2009, Ingo Molnar wrote:
> >
> > Pavel Emelyanov (1):
> >       x86: fix hpet timer reinit for x86_64
> > 
> > 
> >  arch/x86/kernel/hpet.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> > index 64d5ad0..ec319d1 100644
> > --- a/arch/x86/kernel/hpet.c
> > +++ b/arch/x86/kernel/hpet.c
> > @@ -1075,7 +1075,7 @@ static void hpet_rtc_timer_reinit(void)
> >  		hpet_t1_cmp += delta;
> >  		hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
> >  		lost_ints++;
> > -	} while ((long)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
> > +	} while ((long)(hpet_readl(HPET_COUNTER) - (u32)hpet_t1_cmp) > 0);
> 
> This is bordering on not being correct.

yeah, i had to look twice. The only reason i left it that way was because i 
couldnt reproduce the problem and hpet is hellishly fragile and this patch 
was tested so i chickened out.

OTOH that fragility is partly because such constructs have piled up so you 
very much have a valid point ...

We'll clean this up. I've already added the clean 32-bit casts - which also 
has another advantage: it does not actually trust the hw to always return 
32-bit values - it explicitly cuts to 32 bits and does signed arithmetics on 
that. Will also do the helper function cleanup to abstract the counter 
arithmetics away.

> In particular, think about when HPET_COUNTER or hpet_t1_cmp overflows in 
> 32 bits, and what you want to happen. If you do the subtract add test in 
> 64 bits, it will simply do the wrong thing. Think what happens if 
> hpet_t1_cmp is actually _larger_ than HPET_COUNTER, but overflowed in 32 
> bits, and you're now looking at:
> 
> 	(long) (0xffffffff - 0x00000001)
> 
> which is actually > 0, so the thing will continue to loop INCORRECTLY. It 
> should have stopped (and _would_ have stopped on 32-bit x86).

yeah, allowing that to happen is just wrong.

	Ingo

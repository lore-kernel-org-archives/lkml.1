Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbYDNHw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbYDNHw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbYDNHwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:52:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40837 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbYDNHwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:52:18 -0400
Date: Mon, 14 Apr 2008 09:52:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: linux-kernel@vger.kernel.org, heukelum@fastmail.fm
Subject: Re: [PATCH] x86: always_inline wrapper for x86's test_bit
Message-ID: <20080414075204.GI16163@elte.hu>
References: <20080413112308.GA23426@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413112308.GA23426@mailshack.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> On x86, test_bit is currently implemented as a preprocessor macro. It 
> uses gcc's __builtin_constant_p to determine if the bit position is 
> known at compile time and defers to one of two functions depending on 
> that. This changes the same logic to an __always_inline wrapper 
> instead.

thanks Alexander, applied.

> Hi Ingo,
> 
> This patch is a cleanup, changing a macro into an inline function.
> 
> However, the size comparison here is interesting. Allowing gcc to 
> uninline functions marked inline causes a nice decrease in size for a 
> defconfig, but on my tiny config the size increases.
> 
>    text    data     bss     dec     hex vmlinux/i386
> 4850554  474688  622592 5947834  5ac1ba defconfig+forced inlining
> 4850888  474688  622592 5948168  5ac308 defconfig+forced inlining (patched)
> 4721175  474688  622592 5818455  58c857 defconfig (uninlining)
> 4705595  474688  622592 5802875  588b7b defconfig (uninlining, patched)
>    
>    text    data     bss     dec     hex vmlinux/i386
>  759524   77400   81920  918844   e053c tiny (forced inlining)
>  759562   77400   81920  918882   e0562 tiny (forced inlining, patched)
>  787508   77400   81920  946828   e728c tiny (uninlining)
>  784492   77400   81920  943812   e66c4 tiny (uninlining, patched)

when gcc is allowed to uninline (the new CONFIG_OPTIMIZE_INLINING=y 
feature in x86.git/latest) then your change gives a nice size reduction 
of around 0.400% on both large and small kernel images.

the size increase on the 'big' kernel is small, and it's rather 
immaterial as well, forced-inlining kernels are +3.080% larger anyway.

the behavior on tiny is interesting - could you post the config you used 
for your tiny kernel?

what would be interesting to see is the effect of allowing gcc to 
optimize for size (CONFIG_CC_OPTIMIZE_FOR_SIZE=y) - and compare 
!CC_OPTIMIZE_FOR_SIZE+!OPTIMIZE_INLINING against 
CC_OPTIMIZE_FOR_SIZE=y+OPTIMIZE_INLINING=y kernels - the size difference 
should be _brutal_.

> If gcc decides to emit a separate function instead of inlining it, the 
> image can have multiple instances of this uninlined function. 
> Moreover, gcc decides if a function is too big to be inlined using a 
> heuristic and sometimes gets it wrong. In particular, it uninlined 
> constant_bit_test which indeed looks a bit big, but should reduce to a 
> single assembly instruction after constant folding.

yep, gcc could definitely improve here. But if we never give it the 
possibility to do so (by always forcing inlining) then gcc (or any other 
compiler) wont really be optimized for Linux in this area.

we saw that with CC_OPTIMIZE_FOR_SIZE=y well - when the Linux kernel 
started using it then both the correctness and the quality of gcc's -Os 
output improved.

> So I guess we should sprinkle some __always_inlines in the core parts 
> of the kernel? The most problematic ones are easily spotted using: nm 
> -S vmlinux|uniq -f2 -D

yes - butwe should use a separate (new) __hint_always_inline tag - and 
keep __always_inline for the cases where the code _must_ be inlined for 
correctness reasons. (there are a few places where we do that)

	Ingo

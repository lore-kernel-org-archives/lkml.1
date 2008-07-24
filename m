Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbYGXV5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbYGXV5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 17:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYGXV5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 17:57:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbYGXV5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 17:57:46 -0400
Date: Thu, 24 Jul 2008 14:54:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: "x86@kernel.org" <x86@kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x64, fpu: fix possible FPU leakage in error conditions
In-Reply-To: <20080724212351.GM14380@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.1.10.0807241431180.8109@nehalem.linux-foundation.org>
References: <20080724180429.GI14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org> <20080724185053.GJ14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241154260.3237@nehalem.linux-foundation.org>
 <20080724202728.GL14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241330210.15524@nehalem.linux-foundation.org> <20080724212351.GM14380@linux-os.sc.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Jul 2008, Suresh Siddha wrote:
> 
> Meanwhile, I wanted to keep this patch simple, so that it can be easily
> applied to -stable series aswell.

Hmm. There's somethign more fundamentally wrong, it really shouldn't be 
this ugly.

For example, the signal handler path right now does

	if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
		goto badframe;
	err |= restore_i387(buf);

but the thing is, the only really valid reason for "restore_i387()" to 
fail is because the read failed.

Which in turn implies that if it fails, it should just do the same thing 
as that access_ok() failure did!

So why doesn't it just do

	if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
		goto badframe;
	if (restore_i387(buf))
		goto badframe:

because I don't see why that path should even _care_ about the i387 
details? Especially since it doesn't even try to do that if the buffer 
pointer is totally bogus..

What am I missing? This code looks unnecessarily complex, and your patch 
makes it even harder to follow. Is this complexity really needed and worth 
it?

Also, looking at that "math_state_restore()" thing some more, I can't for 
the life of me convince myself that even just initializing the state is 
enough. We've used math before, and if we cannot restore it from the 
fxsave area, why would we _ever_ say that it's ok to try to continue with 
some _other_ state?

IOW, rather than resetting it, shouldn't we force a SIGFPE or something?

Sorry for being difficult, but I'd much rather get the x87 state handling 
_right_ and make it logically consistent than paper over yet another 
mistake we've done in this area. For example, regular 32-bit x86 doesn't 
do any of this crap. It just does "restore_fpu()" in math_state_restore().

Why does x86-64 need to do anythign else? It's not even a user address, it 
cannot take page faults. So exactly what are we protecting against? 

I may well be missing something here, so please fill me in..

			Linus

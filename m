Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbXKLTJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbXKLTJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbXKLTJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:09:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbXKLTJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:09:46 -0500
Date: Mon, 12 Nov 2007 11:08:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: ak@suse.de, linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: [patch] x86: fix taking DNA during 64bit sigreturn
In-Reply-To: <20071111192758.GA21851@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.0.9999.0711121044130.30499@woody.linux-foundation.org>
References: <20071111192758.GA21851@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Nov 2007, Siddha, Suresh B wrote:
>
> restore sigcontext is taking a DNA exception while restoring FP context from
> the user stack, during the sigreturn. Appended patch fixes it by doing clts()
> if the app doesn't touch FP during the signal handler execution. This will
> stop generating a DNA, during the fxrstor in the sigreturn.
> 
> This improves 64-bit lat_sig numbers by ~30% on my core2 platform.

The sad part here is that the 32-bit kernel doesn't seem to have this 
problem at all, and has it fixed thanks to just having cleaner 
abstractions (eg the "unlazy_fpu()" function will just automatically clear 
TS_USEDFPU as part of __save_init_fpu()).

In comparison, the x86-64 math handling is a total friggin mess. Maybe 
it's not *beautiful* in the 32-bit path either, but most of the complexity 
in the 32-bit stuff is due to just the complexity of interactions. In the 
64-bit code, the complexity seems to come largely from just being crap, 
crap, crap.

The *real* fix for this is almost certainly to just get rid of the 64-bit 
code entirely, and use the 32-bit code as the base for one single unified 
setup. The 32-bit code should be largely a superset of the 64-bit code 
anyway, since it has to handle more cases, and does it more cleanly.

Oh, well. Your patch looks good for now.

Btw: the 64-bit code looks like it might have preemption issues too. 
Another bug that seems to be fixed in the 32-bit codepath.

Anybody willing to try to do that unification around the 32-bit code? The 
biggest issue with the 64-bit code is to avoid the extra rex prefix for 
"fxsave", which means that the fxsave/fxrstor thing is done with

	"rex64/fxsave %P2(%1)"
		: "m" (tsk->thread.i387.fxsave)
		: "cdaSDb" (tsk),
		  "i" (offsetof(__typeof__(*tsk), thread.i387.fxsave)));

which isn't exactly pretty, but the memory address generation works fine 
in 32-bit code too, and the rex override is easily done with

	#ifdef CONFIG_X86_64
	  #define REX64 "rex64/"
	#else
	  #define REX64 ""
	#endif

and then you just use

	REX64 "fxsave"

in the asm statements instead.

So I'll apply this patch for 2.6.24, but considering that it really looks 
like x86-64 is preempt-broken too, if somebody does a larger patch that 
does the above merge and tests it, I would be open to apply that too. It 
does seem to be a real bug (having a scheduling event in the signal path 
between the actual fxsave and the clearing of the bits would *seem* to 
possibly screw up the FP state!)

But maybe I'm missing some reason why it doesn't matter. The 32-bit code 
was fixed back in 2003 (commit 5bff44fc272b948a85e893a007d01b9dfb3ad04f 
"Be a lot more careful about TS_USEDFPU and preemption" in the historical 
tree with a comment like this:

    We had some races where we tested (or set) TS_USEDFPU together
    with sequences that depended on the setting (like clearing or
    setting the TS flag in %cr0) and we could be preempted in between,
    which screws up the FPU state, since preemption will itself change
    USEDFPU and the TS flag.

and maybe it's just the 32-bit tree being unnecessarily careful. It's long 
enough ago that I don't remember the details, but I have a dim memory of 
there actually being some state corruption involved.

			Linus

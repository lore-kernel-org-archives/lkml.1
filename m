Return-Path: <linux-kernel-owner+w=401wt.eu-S1764993AbXJSC52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764993AbXJSC52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 22:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760080AbXJSC5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 22:57:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758963AbXJSC5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 22:57:17 -0400
Date: Thu, 18 Oct 2007 19:55:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] synchronize_irq needs a barrier
In-Reply-To: <20071019023219.GB8453@gondor.apana.org.au>
Message-ID: <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au> <1192745137.7367.40.camel@pasglop>
 <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org>
 <1192749449.7367.51.camel@pasglop> <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org>
 <20071019023219.GB8453@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Oct 2007, Herbert Xu wrote:
>
> In other words I think this patch is great :)

Hey, I appreciate it, but I do think that the "spinlock only to 
immediately unlock it again" is pretty horrid.

I'm convinced that there should be some way to do this without actually 
taking the lock. I *think* it should work with something like

	for (;;) {
		smp_rmb();
		if (!spin_is_locked(&desc->lock)) {
			smp_rmb();
			if (!(desc->status & IRQ_INPROGRESS)
				break;
		}
		cpu_relax();
	}

instead. Which basically requires that we see the descriptor lock being 
not held, before we see the IRQ_INPROGRESS bit being clear. Put another 
way: it loops until it sees the lock having been released, and the 
IRQ_INPROGRESS bit being clear after that.

The above requires no serializing instructions on x86, which is a good 
goal (now that smp_rmb() is just a compiler barrier). And it doesn't 
actually have to bounce any cachelines.

And it doesn't have that ugly "get lock only to release it", which just 
makes me go "Eww!".

But it's a bit subtler. It basically depends on the fact that 
spin_unlock() obviously has to make sure that there is a release barrier 
in the unlock, so any writes done (to the IRQ_INPROGRESS bit) within the 
locked region *must* be visible before the spinlock itself has been 
released.

So somebody should:
 - use another pair of eyes and brains to back me up on this.
 - write up some coherent changelog entry, using the emails that have 
   passed back and forth.
 - actually turn the above into a tested patch with a comment.

And I'm pushing for that "somebody" being somebody else than me ;)

			Linus

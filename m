Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbXI2NRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbXI2NRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 09:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXI2NRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 09:17:11 -0400
Received: from ns1.suse.de ([195.135.220.2]:35957 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbXI2NRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 09:17:09 -0400
Date: Sat, 29 Sep 2007 15:17:08 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch] x86: improved memory barrier implementation
Message-ID: <20070929131708.GD14159@wotan.suse.de>
References: <20070928154832.GB12538@wotan.suse.de> <20070928170719.2f617a7a@the-village.bc.nu> <alpine.LFD.0.999.0709280911100.3579@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709280911100.3579@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 09:15:06AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 28 Sep 2007, Alan Cox wrote:
> > 
> > However 
> > - You've not shown the patch has any performance gain
> 
> It would be nice to see this.

Actually, in a userspace test I have (which actually does enough
work to trigger out of order operations on my core2 but is otherwise
pretty trivial), lfence takes 13 cycles, sfence takes 40 (neither of
which actually solve the problem of load vs store ordering, but at
least they might be operating on a slightly utilised memory subsystem
rather than the stupidest possible microbenchmark).

The dummy lock op takes around 75 cycles (of course, the core2 would
always use the fences, but older CPUs will not and will be worse at the
lock op too, probably).

I suppose these could take significantly longer if there are uncached
memory operations and such (I wasn't doing any significant amount
of IO) -- I can't be sure, though.

So it isn't much, but it could be helpful. If the code is important enough
to go without locks and instead use complex barriers, it might easily be
worth saving this kind of cycles on.


> > - You've probably broken Pentium Pro
> 
> Probably not a big deal, but yeah, we should have that broken-ppro option.

Will add, I'll ask Alan to specify what he'd like to see there.


> > - and for modern processors its still not remotely clear your patch is
> > correct because of NT stores.
> 
> This one I disagree with. The *old* code doesn't honor NT stores *either*. 
> 
> The fact is, if you use NT stores and then depend on ordering, it has 
> nothing what-so-ever to do with spinlocks or smp_[rw]mb. You need to use 
> the DMA barriers (ie the non-smp ones).
> 
> The non-temporal stores should be basically considered to be "IO", not any 
> normal memory operation.

Maybe you're thinking of uncached / WC? Non-temporal stores to cacheable
RAM apparently can go out of order too, and they are being used in the kernel
for some things. Likewise for rep stos, apparently. But this means they are
already at odds with spin_unlock, unless they are enclosed with mfences 
everywhere they are used (of which I think most are not). So this is an
existing bug in the kernel.

So again the question comes up -- do we promote these kinds of stores
to be regular x86 citizens, keep the strong memory barriers as they are, and
eat 40 cycles with an sfence before each spin_unlock store; or do we fix the
few users of non-temporal stores and continue with the model we've always
had where stores are in-order? Or I guess the implicit option is to do nothing
until some poor bastard has the pleasure of having to debug some problem.

Anyway, just keep in mind that this patch is not making any changes
which are not already fundamentally broken. Sure, it might happen to
cause more actual individual cases to break, but if they just happened
to be using real locking instead of explicit barriers, they would be
broken anyway, right? (IOW, any new breakage is already conceptually
broken, even if OK in practice due to the overstrictness of our current
barriers).

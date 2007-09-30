Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbXI3DQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbXI3DQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 23:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXI3DQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 23:16:51 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53138 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbXI3DQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 23:16:50 -0400
Date: Sat, 29 Sep 2007 20:16:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch] i386: remove comment about barriers
Message-ID: <20070930031647.GG9119@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070929132848.GA21169@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070929132848.GA21169@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 03:28:48PM +0200, Nick Piggin wrote:
> Hi,
> 
> OK this was going to be a quick patch, but after sleeping on it, I think
> it deserves a better analysis... I can prove the comment is incorrect with a
> test program, but I'm not as sure about my thinking that leads me to call it
> also misleading.
> 
> The comment being removed by this patch is incorrect and misleading (I think). 
> 
> 1. load  ...
> 2. store 1 -> X
> 3. wmb
> 4. rmb
> 5. load  a <- Y
> 6. store ...
> 
> 4 will only ensure ordering of 1 with 5.
> 3 will only ensure ordering of 2 with 6.
> 
> Further, a CPU with strictly in-order stores will still only provide that
> 2 and 6 are ordered (effectively, it is the same as a weakly ordered CPU
> with wmb after every store).
> 
> In all cases, 5 may still be executed before 2 is visible to other CPUs!

Yes, even on x86.

> The additional piece of the puzzle that mb() provides is the store/load
> ordering, which fundamentally cannot be achieved with any combination of rmb()s
> and wmb()s.

True.

> This can be an unexpected result if one expected any sort of global ordering
> guarantee to barriers (eg. that the barriers themselves are sequentially
> consistent with other types of barriers).  However sfence or lfence barriers
> need only provide an ordering partial ordering of meomry operations -- Consider
> that wmb may be implemented as nothing more than inserting a special barrier
> entry in the store queue, or, in the case of x86, it can be a noop as the store
> queue is in order. And an rmb may be implemented as a directive to prevent
> subsequent loads only so long as their are no previous outstanding loads (while
> there could be stores still in store queues).
> 
> I can actually see the occasional load/store being reordered around lfence on
> my core2. That doesn't prove my above assertions, but it does show the comment
> is wrong (unless my program is -- can send it out by request).
> 
> So:
> mb() and smp_mb() always have and always will require a full mfence or lock
> prefixed instruction on x86. And we should remove this comment.

Yes, because x86 allows loads to be executed before earlier stores,
so load-store ordering must be explicitly enforced.

> [ This is true for x86's sfence/lfence, but raises a question about Linux's
> memory barriers. Does anybody expect that a sequence of smp_wmb and smp_rmb
> would ever provide a full smp_mb barrier? I've always assumed no, but I
> don't know if it is actually documented? ]

Anyone that does expect this needs to adjust their expectations.  ;-)

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Nick Piggin <npiggin@suse.de>
> 
> ---
> Index: linux-2.6/include/asm-i386/system.h
> ===================================================================
> --- linux-2.6.orig/include/asm-i386/system.h
> +++ linux-2.6/include/asm-i386/system.h
> @@ -214,11 +214,6 @@ static inline unsigned long get_limit(un
>   */
>   
> 
> -/* 
> - * Actually only lfence would be needed for mb() because all stores done 
> - * by the kernel should be already ordered. But keep a full barrier for now. 
> - */
> -
>  #define mb() alternative("lock; addl $0,0(%%esp)", "mfence", X86_FEATURE_XMM2)
>  #define rmb() alternative("lock; addl $0,0(%%esp)", "lfence", X86_FEATURE_XMM2)
> 

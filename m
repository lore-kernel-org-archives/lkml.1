Return-Path: <linux-kernel-owner+w=401wt.eu-S965882AbXJQAao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965882AbXJQAao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762164AbXJQAaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:30:35 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:40497 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761926AbXJQAae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:30:34 -0400
Date: Wed, 17 Oct 2007 02:30:32 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Nick Piggin <npiggin@suse.de>
cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise barriers)
In-Reply-To: <20071016232153.GC29378@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0710170212090.15954@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz>
 <20071015143732.01d99af8@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz>
 <20071016002229.GA5851@wotan.suse.de> <Pine.LNX.4.64.0710161221300.1315@artax.karlin.mff.cuni.cz>
 <20071016222921.GA29378@wotan.suse.de> <Pine.LNX.4.64.0710170049450.19210@artax.karlin.mff.cuni.cz>
 <20071016232153.GC29378@wotan.suse.de>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > You already must not place any data structures into WC memory --- for 
> > example, spinlocks wouldn't work there.
> 
> What do you mean "already"?

I mean "in current kernel" (I checked it in 2.6.22)

> If we already have drivers loading data from
> WC memory, then rmb() needs to order them, whether or not they actually
> need it. If that were prohibitively costly, then we'd introduce a new
> barrier which does not order WC memory, right?
> 
> 
> > wmb() also won't work on WC 
> > memory, because it assumes that writes are ordered.
> 
> You mean the one defined like this:
>   #define wmb()   asm volatile("sfence" ::: "memory")
> ? If it assumed writes are ordered, then it would just be a barrier().

You read wrong part of the include file. Really, it is 
(2.6.22,include/asm-i386/system.h):
#ifdef CONFIG_X86_OOSTORE
#define wmb() alternative("lock; addl $0,0(%%esp)", "sfence", 
X86_FEATURE_XMM)
#else
#define wmb()   __asm__ __volatile__ ("": : :"memory")
#endif

CONFIG_X86_OOSTORE is dependent on MWINCHIP3D || MWINCHIP2 || MWINCHIPC6
--- so on Intel and AMD, it is really just barrier().

So drivers can't assume that wmb() works on write-combining memory.

> > > Doing that would lead to an unmaintainable mess. If drivers don't 
> > > need rmb, then they don't call it.
> > 
> > If wmb() doesn't currently work on write-combining memory, why should 
> > rmb() work there?
> 
> I don't understand why you say wmb() doesn't work on WC memory.

Because it is defined as __asm__ __volatile__ ("": : :"memory")

And WC memory can reorder writes (WB memory can't).

> > The purpose of rmb() is to enforce ordering on architectures that don't 
> > force it in hardware --- that is not the case of x86.
> 
> Well it clearly is the case because I just pointed you to a document
> that says they can go out of order.

> If you want to argue that existing
> implementations do not, then by all means go ahead and send a patch to
> Linus and see what he says about it ;)

I mean this: wmb() assumes that the data to be ordered are not in WC 
memory. rmb() assumes that the data can be in WC memory (lfence is only 
useful on WC --- it doesn't have any effect on other memory types).

Mikulas

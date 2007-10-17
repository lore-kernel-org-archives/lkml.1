Return-Path: <linux-kernel-owner+w=401wt.eu-S1760468AbXJQMYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468AbXJQMYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 08:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbXJQMYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 08:24:37 -0400
Received: from mx1.suse.de ([195.135.220.2]:33535 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbXJQMYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 08:24:36 -0400
Date: Wed, 17 Oct 2007 14:24:35 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise barriers)
Message-ID: <20071017122435.GA14401@wotan.suse.de>
References: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz> <20071015143732.01d99af8@laptopd505.fenrus.org> <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz> <20071016002229.GA5851@wotan.suse.de> <Pine.LNX.4.64.0710161221300.1315@artax.karlin.mff.cuni.cz> <20071016222921.GA29378@wotan.suse.de> <Pine.LNX.4.64.0710170049450.19210@artax.karlin.mff.cuni.cz> <20071016232153.GC29378@wotan.suse.de> <Pine.LNX.4.64.0710170212090.15954@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710170212090.15954@artax.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 02:30:32AM +0200, Mikulas Patocka wrote:
> > > You already must not place any data structures into WC memory --- for 
> > > example, spinlocks wouldn't work there.
> > 
> > What do you mean "already"?
> 
> I mean "in current kernel" (I checked it in 2.6.22)

Ahh, that's not "current kernel", though ;)

4071c718555d955a35e9651f77086096ad87d498

 
> > If we already have drivers loading data from
> > WC memory, then rmb() needs to order them, whether or not they actually
> > need it. If that were prohibitively costly, then we'd introduce a new
> > barrier which does not order WC memory, right?
> > 
> > 
> > > wmb() also won't work on WC 
> > > memory, because it assumes that writes are ordered.
> > 
> > You mean the one defined like this:
> >   #define wmb()   asm volatile("sfence" ::: "memory")
> > ? If it assumed writes are ordered, then it would just be a barrier().
> 
> You read wrong part of the include file. Really, it is 
> (2.6.22,include/asm-i386/system.h):
> #ifdef CONFIG_X86_OOSTORE
> #define wmb() alternative("lock; addl $0,0(%%esp)", "sfence", 
> X86_FEATURE_XMM)
> #else
> #define wmb()   __asm__ __volatile__ ("": : :"memory")
> #endif
> 
> CONFIG_X86_OOSTORE is dependent on MWINCHIP3D || MWINCHIP2 || MWINCHIPC6
> --- so on Intel and AMD, it is really just barrier().
> 
> So drivers can't assume that wmb() works on write-combining memory.

Drivers should be able to assume that wmb() orders _everything_ (except
some whacky Altix thing, which I really want to fold under wmb at some
point anyway).

So I decided that old x86 semantics isn't right, and now it really is a
lock op / sfence everywhere.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYHPVEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYHPVEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 17:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYHPVEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 17:04:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:37087 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYHPVEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 17:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QqsdS+Pg+meRJ68VEtmmWHQKABqeXS3pw6xTXNFLiRU6E1WAp9QrKjlkBpFFQ/bNDg
         FLVeX24IrSybQwebuLrSDeU63RMaT749gTTWtGSzkaiV3j1ktKNTqlpsc+1XpZrQUSZK
         ZCI+GOx2d8L04ZIu/PT/rYYkC6QaxwJUsxUWc=
Date: Sun, 17 Aug 2008 01:04:39 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] De-macro spin_trylock_irq, spin_trylock_irqsave,
	write_trylock_irqsave
Message-ID: <20080816210439.GB5151@martell.zuzino.mipt.ru>
References: <20080816095951.GA19926@martell.zuzino.mipt.ru> <20080816134600.GC20652@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080816134600.GC20652@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 03:46:00PM +0200, Ingo Molnar wrote:
> 
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > 1) de-macro, remove ({ usages as side-effect,
> > 2) change calling convention to not accept "flags" by value -- trylock
> >    functions can modify them, so by-value is misleading, and number of users
> >    is relatively low.
> > 3) de-macro spin_trylock_irq() for a change.
> 
> > +++ b/kernel/sched.c
> > @@ -1174,7 +1174,7 @@ static void resched_cpu(int cpu)
> >  	struct rq *rq = cpu_rq(cpu);
> >  	unsigned long flags;
> >  
> > -	if (!spin_trylock_irqsave(&rq->lock, flags))
> > +	if (!spin_trylock_irqsave(&rq->lock, &flags))
> >  		return;
> 
> hm, i dont really like this assymetric calling convention to other 
> locking primitives that all take 'flags' as a value. 
> [spin_lock_irqsave(), etc.]
> 
> so what's the point really? It sure does not make actual usage more 
> readable.

Only slightly, reader is hinted that flags can be changed, otherwise
they will be passed by value.

> If we switched _all_ primitives to use flags as a pointer, 
> that might make sense, in theory.

We can't really, and I don't propose that: ~8700 usages of
spin_lock_irqsave, ~1300 usages of local_irq_save. However for code
which has small number of users, why not?



The prehistory of this patch is that I'm deeply in spinlock and
irqflags.h headers for clean irq_flags_t conversion and overall
implession is that they're horrible.

Just the joke with local_irq_enable() defined via raw_local_irq_enable()
and several lines below in the opposite order.

The patch is about slightly cleaner code close to C. ;-)

> (but it would also be hugely invasive, 
> with not much upside with tons of downside like years of migration 
> fallout and having to rewrite hundreds of kernel hacking books ;-) )

I want my money back for scheduler chapter from "Understanding the Linux Kernel"!


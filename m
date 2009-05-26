Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZEZP7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZEZP7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZEZP72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:59:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60062 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZEZP71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:59:27 -0400
Date: Tue, 26 May 2009 16:59:06 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090526155906.GC26713@n2100.arm.linux.org.uk>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090526145950.GB26713@n2100.arm.linux.org.uk> <20090526153654.GA17096@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526153654.GA17096@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 11:36:54AM -0400, Mathieu Desnoyers wrote:
> > diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
> > index bd4dc8e..e9889c2 100644
> > --- a/arch/arm/include/asm/system.h
> > +++ b/arch/arm/include/asm/system.h
> > @@ -248,6 +248,8 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
> >  	unsigned int tmp;
> >  #endif
> >  
> > +	smp_mb();
> > +
> >  	switch (size) {
> >  #if __LINUX_ARM_ARCH__ >= 6
> >  	case 1:
> > @@ -258,7 +260,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
> >  		"	bne	1b"
> >  			: "=&r" (ret), "=&r" (tmp)
> >  			: "r" (x), "r" (ptr)
> > -			: "memory", "cc");
> > +			: "cc");
> 
> I would not remove the "memory" constraint in here. Anyway it's just a
> compiler barrier, I doubt it would make anyting faster (due to the
> following smp_mb() added), but it surely makes things harder to
> understand.

If you don't already know that smp_mb() is always a compiler barrier then
I guess it's true, but then if you don't know what the barriers are defined
to be, should you be trying to understand atomic ops?

> If we determine that some reorderings are not possible on ARM, we might
> eventually change rmb() for a simple barrier() and make atomic op
> barriers a bit more lightweight.

There seems to be no "read memory barrier" on ARM - the dmb instruction
can be restricted to writes, but not just reads.

Moreover, there's a comment in the architecture reference manual that
implementations which don't provide the other dmb variants must default
to doing the full dmb, but then goes on to say that programs should not
rely on this (what... that the relaxed dmb()s have any effect what so
ever?)

Suggest we don't go anywhere near those until ARMv7 stuff has matured
for a few years and these details resolved.

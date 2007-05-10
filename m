Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbXEJGgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbXEJGgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbXEJGgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:36:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:37015 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945AbXEJGgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:36:07 -0400
Subject: Re: [PATCH 2/3] Add hard_irq_disable()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20070509224113.cca81a24.akpm@linux-foundation.org>
References: <20070510052622.3E8D5DDF4B@ozlabs.org>
	 <20070509224113.cca81a24.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 May 2007 16:35:51 +1000
Message-Id: <1178778951.14928.215.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 22:41 -0700, Andrew Morton wrote:
> On Thu, 10 May 2007 15:25:58 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > --- linux-cell.orig/include/linux/interrupt.h	2007-05-10 14:51:22.000000000 +1000
> > +++ linux-cell/include/linux/interrupt.h	2007-05-10 15:18:04.000000000 +1000
> > @@ -241,6 +241,16 @@ static inline void __deprecated save_and
> >  #define save_and_cli(x)	save_and_cli(&x)
> >  #endif /* CONFIG_SMP */
> >  
> > +/* Some architectures might implement lazy enabling/disabling of
> > + * interrupts. In some cases, such as stop_machine, we might want
> > + * to ensure that after a local_irq_disable(), interrupts have
> > + * really been disabled in hardware. Such architectures need to
> > + * implement the following hook.
> > + */
> > +#ifndef hard_irq_disable
> > +#define hard_irq_disable()	do { } while(0)
> > +#endif
> 
> We absolutely require that the architecture's hard_irq_disable() be defined
> when we do this.  If it happens that the definition of hard_irq_disable()
> is implemented three levels deep in nested includes then we risk getting
> into a situation where different .c files see different implementations of
> hard_irq_disable(), which could lead to confusing results, to say the least.

Yes, I'm indeed a bit worried about that... I've been wondering what's
the best include path here... I tried to follow who gets to hw_irq.h and
didn't come to any conclusive results.

powerpc gets it from asm/system.h but I haven't verified other arch
(though it only matters on arch that have their own here).

I've verified that a #error on ppc up there will not trigger thus it's
fine on powerpc, but I agree it's a bit fragile.

> Your implementation comes via the inclusion of system.h which then includes
> hw_irq.h.  That's perhaps a little fragile and it would be better to
> 
> a) include in the comment the name of the arch file which must implement
>    hard_irq_disable() and
> 
> b) include that file directly from this one.

Fair enough. I was just worried that including hw_irq.h here might cause
trouble for some archs though (as I said, we get it indirectly on
powerpc via some other asm thingy, not via some linux/*.h). I've looked
around and seen all sort of horrors in arch include dependencies
(including some circular stuff that must work by mere luck).

> Oh, and your comment layout style is wrong ;)

What about my comment layout style ? I've been using that forever ... Or
do you mean I should use a function documentation style layout there ?

Cheers,
Ben.


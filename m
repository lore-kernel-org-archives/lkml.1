Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbXEJGqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbXEJGqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbXEJGp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:45:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:61085 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbXEJGp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bhZGh2KgDL05rDFCF4/xZQ3XjYA/VFbaq6T8r9rAI4qVW0XwL4P/6ZZAnQiO9gZKmaxeUhrvywfghU6rNfmVne9xrJzn5gCaEjBoBN9HnOO3vVs5hXlFam/kOPV1C8GsWqW1XHyQhJ9LrH96D0C4Rv27jkP9Xp64tAdSPFwEtEo=
Message-ID: <a781481a0705092345rf9fdc9cs8495516299a28fae@mail.gmail.com>
Date: Thu, 10 May 2007 12:15:55 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] Add hard_irq_disable()
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <20070509224113.cca81a24.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070510052622.3E8D5DDF4B@ozlabs.org>
	 <20070509224113.cca81a24.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 5/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 10 May 2007 15:25:58 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>
> > --- linux-cell.orig/include/linux/interrupt.h 2007-05-10 14:51:22.000000000 +1000
> > +++ linux-cell/include/linux/interrupt.h      2007-05-10 15:18:04.000000000 +1000
> > @@ -241,6 +241,16 @@ static inline void __deprecated save_and
> >  #define save_and_cli(x)      save_and_cli(&x)
> >  #endif /* CONFIG_SMP */
> >
> > +/* Some architectures might implement lazy enabling/disabling of
> > + * interrupts. In some cases, such as stop_machine, we might want
> > + * to ensure that after a local_irq_disable(), interrupts have
> > + * really been disabled in hardware. Such architectures need to
> > + * implement the following hook.
> > + */
> > +#ifndef hard_irq_disable
> > +#define hard_irq_disable()   do { } while(0)
> > +#endif
>
> We absolutely require that the architecture's hard_irq_disable() be defined
> when we do this.  If it happens that the definition of hard_irq_disable()
> is implemented three levels deep in nested includes then we risk getting
> into a situation where different .c files see different implementations of
> hard_irq_disable(), which could lead to confusing results, to say the least.

So you're saying that this mechanism forces the arch (that really
wants hard_irq_disable) to _#define_ hard_irq_disable (as a macro),
and if it implements it as an inline function, for example, then we're
screwed?

> Your implementation comes via the inclusion of system.h which then includes
> hw_irq.h.  That's perhaps a little fragile and it would be better to
>
> a) include in the comment the name of the arch file which must implement
>    hard_irq_disable() and
>
> b) include that file directly from this one.

Hmmm. How about:

1. Introduce some CONFIG_WANTS_HARD_IRQ_DISABLE that is #defined (or
left undefined) by the arch/.../defconfig (depending upon whether or
not that arch implements a hard_irq_disable() for itself or not)

2. Then pull-in that code into include/linux/interrupt.h somehow
(through some known / fixed header file, or through asm/system.h, or
anyhow -- it doesn't really matter)

3. And:

#ifndef CONFIG_WANTS_HARD_IRQ_DISABLE
#define hard_irq_disable() do { } while(0)
#endif

We don't need to standardize on some particular arch-specific header
filename in this case.

Comments?

Satyam

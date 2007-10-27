Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbXJ0UOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbXJ0UOt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 16:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXJ0UOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 16:14:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:13820 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbXJ0UOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 16:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=sIYzPbaoIyNRl/nEJqk56OnjQg1qQMhu5wexXjuPFvN9Xg2hwBRADpD7Tj0o/30kgYRW9SfoONBKI79A6W2Jcm9g+jElyObOCJuiri+FifGrDctOKvNPrRwiMASrA/XeixNozNf4PMIXq6j7HH/FkBHmrS7cPr06SY3UO/N/J6M=
Date: Sun, 28 Oct 2007 00:14:29 +0400
To: Roman Zippel <zippel@linux-m68k.org>
Cc: torvalds@osdl.org, akpm@osdl.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Message-ID: <20071027201429.GE9816@martell.zuzino.mipt.ru>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0710272114590.1818@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710272114590.1818@scrub.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 09:20:43PM +0200, Roman Zippel wrote:
> On Sun, 21 Oct 2007, Alexey Dobriyan wrote:
> 
> > So far remedies were:
> > a) grep(1) -- obviously fragile. I tried at some point grepping for
> >    spin_lock_irqsave(), found quite a few, but it became booooring quickly.
> > b) BUILD_BUG_ON(sizeof(flags) != sizeof(unsigned long)) -- was tried,
> >    brutally broke some arches, survived one commit before revert :^)
> >    Doesn't work on i386 where sizeof(unsigned int) == sizeof(unsigned long).
> > 
> > So it would be nice to have something more robust.
> 
> If it's just about the type checking, something like below should pretty 
> much do the same.

It won't catch, the following if both variables are unsigned long:

	spin_lock_irqsave(&lock, flags);
		[stuff]
	spin_unlock_irqrestore(&lock, foo->flags);

It won't catch "static unsigned long flags;". With sparse, we can
eventually mark type as "on-stack only".

> > * irq_flags_t allows arch maintainers to eventually switch to something
> >   smaller than "unsigned long" if they want to.
> 
> Considering how painful this conversion could be, the question is whether 
> this is really needed.

In the long run, I believe, this is needed. We want more bugs to be
found automatically, so we can have more time for non-trivial bugs.

> Comments so far suggest some archs don't need all 
> of it, but does someone need more?

I don't know.

> --- linux-2.6.orig/include/linux/irqflags.h
> +++ linux-2.6/include/linux/irqflags.h
> @@ -41,6 +41,10 @@
>  # define INIT_TRACE_IRQFLAGS
>  #endif
>  
> +static __always_inline void __irq_flags_check(unsigned long *flags)
> +{
> +}
> +
>  #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
>  
>  #include <asm/irqflags.h>
> @@ -50,10 +54,11 @@
>  #define local_irq_disable() \
>  	do { raw_local_irq_disable(); trace_hardirqs_off(); } while (0)
>  #define local_irq_save(flags) \
> -	do { raw_local_irq_save(flags); trace_hardirqs_off(); } while (0)
> +	do { __irq_flags_check(&flags); raw_local_irq_save(flags); trace_hardirqs_off(); } while (0)
>  
>  #define local_irq_restore(flags)				\
>  	do {							\
> +		__irq_flags_check(&flags);			\
>  		if (raw_irqs_disabled_flags(flags)) {		\
>  			raw_local_irq_restore(flags);		\
>  			trace_hardirqs_off();			\
> @@ -69,8 +74,8 @@
>   */
>  # define raw_local_irq_disable()	local_irq_disable()
>  # define raw_local_irq_enable()		local_irq_enable()
> -# define raw_local_irq_save(flags)	local_irq_save(flags)
> -# define raw_local_irq_restore(flags)	local_irq_restore(flags)
> +# define raw_local_irq_save(flags)	({ __irq_flags_check(&flags); local_irq_save(flags); })
> +# define raw_local_irq_restore(flags)	({ __irq_flags_check(&flags); local_irq_restore(flags); })
>  #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
>  
>  #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT

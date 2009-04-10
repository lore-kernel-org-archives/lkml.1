Return-Path: <linux-kernel-owner+w=401wt.eu-S937590AbZDJRpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937590AbZDJRpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZDJRpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:45:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:10132 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZDJRpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:45:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ay/vjERY2yJ5MV/dlSRVZYEaiolnaxFqu6/4ph6Nj9uryF6b53LMmrf83fn/EgtbPa
         kxi0uBY3OHx/rdumoDSaWjOSWN30nulCHEHx6raAj8oJVYvhNdR5xmLphVx3DuBLCIaw
         cveUURGhT9k2aQkuoyNs9o9ccUO2578V4lrg8=
Date: Fri, 10 Apr 2009 21:45:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [git-pull -tip] x86: declaration patches
Message-ID: <20090410174524.GC8204@lenovo>
References: <1239381184.23116.5.camel@ht.satnam> <20090410172925.GA24446@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410172925.GA24446@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Fri, Apr 10, 2009 at 07:29:25PM +0200]
| Hi Jaswinder.
| 
| > diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
| > index 7309c0a..2f35e81 100644
| > --- a/arch/x86/include/asm/hw_irq.h
| > +++ b/arch/x86/include/asm/hw_irq.h
| > @@ -81,6 +81,11 @@ extern void eisa_set_level_irq(unsigned int irq);
| >  /* SMP */
| >  extern void smp_apic_timer_interrupt(struct pt_regs *);
| >  extern void smp_spurious_interrupt(struct pt_regs *);
| > +#ifdef CONFIG_X86_32
| > +extern void smp_generic_interrupt(struct pt_regs *);
| > +#else
| > +extern asmlinkage void smp_generic_interrupt(struct pt_regs *);
| > +#endif
| >  extern void smp_error_interrupt(struct pt_regs *);
| >  #ifdef CONFIG_SMP
| >  extern void smp_reschedule_interrupt(struct pt_regs *);
| > @@ -93,6 +98,15 @@ extern asmlinkage void smp_invalidate_interrupt(struct pt_regs *);
| >  #endif
| >  #endif
| >  
| > +#ifdef CONFIG_X86_IO_APIC
| > +#ifdef CONFIG_X86_32
| > +extern void smp_irq_move_cleanup_interrupt(void);
| > +#else
| > +extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
| > +#endif
| > +#endif
| 
| The above is a lot ifdefs just to:
| 1) use asmlinkage only on 64 bit
| 2) hide the prototype if do not implement the function
| 
| Is there any relevant cost associated with asmlinkage or could we just make it
| always asmlinkage?

Hi,

as far as I see asmlinkage is just (on X86-64 after
all substitution) nothing, ie:

#define asmlinkage

(until we pass __cplusplus, do we ever?)

Which means we could safely pass asmlinkage on X86-64
in case if X86-32 requires it.

Like

| > +#ifdef CONFIG_X86_32
| > +extern void smp_generic_interrupt(struct pt_regs *);
| > +#else
| > +extern asmlinkage void smp_generic_interrupt(struct pt_regs *);
| > +#endif

could be just written as
	extern void smp_generic_interrupt(struct pt_regs *);
for both.

        Cyrill

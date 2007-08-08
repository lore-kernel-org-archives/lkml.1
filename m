Return-Path: <linux-kernel-owner+w=401wt.eu-S935556AbXHHOti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935556AbXHHOti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbXHHOt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:49:27 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:13851 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbXHHOtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:49:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NyyN2BhcVphnO0b88AFWdIXSJHoF7pBO2y5A2y83fZ0bZxMxBpFUQc/yGGK/wX0Yf/yLj3p8HFY/tderiwfbke+kGiGfl5MRn39EObW4iMG3tMrQ+15oaT9zIwdoMb4RrqGRoxdM3R9+Sqlob6RGfccigHkFjGuI5/fo62QksaE=
Message-ID: <5d6222a80708080749t35c5c0ceo8b3b8f0cce50c666@mail.gmail.com>
Date: Wed, 8 Aug 2007 11:49:22 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <200708081200.13669.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <1186546847263-git-send-email-gcosta@redhat.com>
	 <11865468513077-git-send-email-gcosta@redhat.com>
	 <200708081200.13669.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Andi Kleen <ak@suse.de> wrote:
>
> Is this really synced with the latest version of the i386 code?
Roasted already commented on this. I will check out and change it here.

>
> > +#ifdef CONFIG_PARAVIRT
> > +#include <asm/paravirt.h>
> > +#endif
>
>
> > +#include <linux/errno.h>
> > +#include <linux/module.h>
> > +#include <linux/efi.h>
> > +#include <linux/bcd.h>
> > +#include <linux/start_kernel.h>
> > +
> > +#include <asm/bug.h>
> > +#include <asm/paravirt.h>
> > +#include <asm/desc.h>
> > +#include <asm/setup.h>
> > +#include <asm/irq.h>
> > +#include <asm/delay.h>
> > +#include <asm/fixmap.h>
> > +#include <asm/apic.h>
> > +#include <asm/tlbflush.h>
> > +#include <asm/msr.h>
> > +#include <asm/page.h>
> > +#include <asm/pgtable.h>
> > +#include <asm/proto.h>
> > +#include <asm/e820.h>
> > +#include <asm/time.h>
> > +#include <asm/asm-offsets.h>
> > +#include <asm/smp.h>
> > +#include <asm/irqflags.h>
>
>
> Are the includes really all needed?
delay.h is not needed anymore. Most of them, could be maybe moved to
paravirt.c , which is the one that really needs all the native_
things. Yeah, it will be better code this way, will change.

>
> > +     if (opfunc == NULL)
> > +             /* If there's no function, patch it with a ud2a (BUG) */
> > +             ret = paravirt_patch_insns(site, len, start_ud2a, end_ud2a);
>
> This will actually give corrupted BUGs because you don't supply
> the full inline BUG header. Perhaps another trap would be better.

You mean this:
> > +#include <asm/bug.h>
?

>
> > +EXPORT_SYMBOL(paravirt_ops);
>
> Definitely _GPL at least.
Sure.

>
> Should be native_paravirt_ops I guess

makes sense.

> > +
> > + * This generates an indirect call based on the operation type number.
>
> The macros here don't
>

> > +static inline unsigned long read_msr(unsigned int msr)
> > +{
> > +     int __err;
>
> No need for __ in inlines
Right. Thanks.


> > +/* The paravirtualized I/O functions */
> > +static inline void slow_down_io(void) {
>
> I doubt this needs to be inline and it's large
In a second look, i386 have such a function in io.h because they need
slow_down_io in a bunch of I/O instructions. It seems that we do not.
Could we just get rid of it, then?

> > +     __asm__ __volatile__(paravirt_alt(PARAVIRT_CALL)
>
> No __*__ in new code please

Yup, will fix.

> > +                          : "=a"(f)
> > +                          : paravirt_type(save_fl),
> > +                            paravirt_clobber(CLBR_RAX)
> > +                          : "memory", "cc");
> > +     return f;
> > +}
> > +
> > +static inline void raw_local_irq_restore(unsigned long f)
> > +{
> > +     __asm__ __volatile__(paravirt_alt(PARAVIRT_CALL)
> > +                          :
> > +                          : "D" (f),
>
> Have you investigated if a different input register generates better/smaller
> code? I would assume rdi to be usually used already for the caller's
> arguments so it will produce spilling
>
> Similar for the rax return in the other functions.
I don't think we can do different. These functions can be patched, and
if it happens, they will put their return value in rax. So we'd better
expect it there.
Same goes for rdi, as they will expect the value to be there as an input.

I don't think it will spill in the normal case, as rdi is already the
parameter. So the compiler will just leave it there, untouched.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."

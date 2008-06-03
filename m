Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYFCWwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYFCWwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbYFCWwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:52:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49928
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753491AbYFCWwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:52:15 -0400
Date: Tue, 03 Jun 2008 15:52:14 -0700 (PDT)
Message-Id: <20080603.155214.34351559.davem@davemloft.net>
To: sam@ravnborg.org
Cc: sparclinux@vger.kernel.org, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]: sparc64: Add Niagara2 RNG driver.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080517065437.GA8092@uranus.ravnborg.org>
References: <20080516.165354.213801515.davem@davemloft.net>
	<20080517065437.GA8092@uranus.ravnborg.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 17 May 2008 08:54:37 +0200

> > diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> > index c8b7300..32b327b 100644
> > --- a/drivers/char/hw_random/Makefile
> > +++ b/drivers/char/hw_random/Makefile
> > @@ -7,6 +7,8 @@ rng-core-y := core.o
> >  obj-$(CONFIG_HW_RANDOM_INTEL) += intel-rng.o
> >  obj-$(CONFIG_HW_RANDOM_AMD) += amd-rng.o
> >  obj-$(CONFIG_HW_RANDOM_GEODE) += geode-rng.o
> > +obj-$(CONFIG_HW_RANDOM_N2RNG) += n2-rng.o
> > +n2-rng-objs := n2-drv.o n2-asm.o
> 
> These days the preferred syntax is:
> 
> n2-rng-y := n2-drv.o n2-asm.o
> 
> Following this scheme in general allows us to easily
> introduce:
> n2-rng-$(CONFIG_FOO) += foo.o

Thanks I've fixed this.

> > +#include <asm/hypervisor.h>
> > +#include "n2rng.h"
> > +
> > +	.text
> 
> I had expected:
> 
> 	.section .text, "aw"
> 
> here??

".text" is used consistently for this in the first 5 assembler files
I tossed into my editor (arch/x86/kernel/head_{32,64},
arch/x86/kernel/entry_{32,64}.S, arch/powerpc/kernel/head_64.S)
I don't see any value in using the expanded version, especially is
"aw" is not the default on some platform for some reason, that
detail is hidden in the assembler's implementation of ".text"

> > +	.globl	sun4v_rng_get_diag_ctl
> > +	.type	sun4v_rng_get_diag_ctl,#function
> > +sun4v_rng_get_diag_ctl:
> > +	mov	HV_FAST_RNG_GET_DIAG_CTL, %o5
> > +	ta	HV_FAST_TRAP
> > +	retl
> > +	 nop
> > +	.size	sun4v_rng_get_diag_ctl,.-sun4v_rng_get_diag_ctl
> 
> Any specific reason why you do not use:
> 
> ENTRY(sun4v_rng_get_diag_ctl)
>      mov     HV_FAST_RNG_GET_DIAG_CTL, %o5
>      ta      HV_FAST_TRAP
>      retl
>       nop
> ENDPROC(sun4v_rng_get_diag_ctl)

I simply didn't know they existed and were usable. :-)
I've changed the assembler code to use them, thanks.

Longer term I'll need to define __ALIGN et al. on sparc
so that a more appropriate fill constant is used.  It
should be a NOP in sections that should contain instructions
and 0x90 is not a NOP on sparc :-)

But it's harmless to use what's there now, so there is no
need for me to define a specific __ALIGN before using
ENTRY and ENDPROC.

Thanks for your feedback.

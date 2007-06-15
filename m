Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbXFOP5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbXFOP5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbXFOP5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:57:45 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48451 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbXFOP5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:57:44 -0400
Date: Fri, 15 Jun 2007 21:27:15 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org,
       "Natalie.Protasevich@unisys.com" <Natalie.Protasevich@unisys.com>,
       akpm@linux-foundation.org
Subject: Re: CONFIG_X86_ES7000=y, CONFIG_X86_GENERICARCH=n, CONFIG_ACPI=y build broken
Message-ID: <20070615155715.GB9230@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <adad5017zpt.fsf@cisco.com> <20070613173741.GA23618@in.ibm.com> <adamyz34mim.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adamyz34mim.fsf@cisco.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 01:39:29PM -0700, Roland Dreier wrote:
>  > Can you please try the attached patch? I have compiled it with CONFIG_ES7000=y
>  > and CONFIG_X86_GENERICARCH=n. But don't have any ES7000 machine to test it.
> 
> I actually don't have anything remotely like ES7000 iether.  I just
> found the problem while tracking down another randconfig failure.
> 
>  > Subarch build procedure is not straightforward and this patch adds to the
>  > misery. Please suggest if there is a better way of handling things.
> 
>  > +/*
>  > + * This file also gets compiled if CONFIG_X86_GENERICARCH is set. Generic
>  > + * arch already has got following function definitions (asm-generic/es7000.c)
>  > + * hence no need to define these for that case.
>  > + */
>  > +#ifndef CONFIG_X86_GENERICARCH
> 
> Seems it would be cleaner to figure out some way to build es7000.c for
> if CONFIG_X86_ES7000 is set?  Or just move them here all the time?
> 
>  > --- linux-2.6.22-rc4-git4/include/asm-i386/mach-es7000/mach_mpparse.h~i386-es7000-build-breakage-fix	2007-06-13 22:52:14.000000000 +0530
>  > +++ linux-2.6.22-rc4-git4-vivek/include/asm-i386/mach-es7000/mach_mpparse.h	2007-06-13 22:52:14.000000000 +0530
>  > @@ -18,6 +18,12 @@ extern int parse_unisys_oem (char *oempt
>  >  extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
>  >  extern void setup_unisys(void);
>  >  
>  > +#ifndef CONFIG_X86_GENERICARCH
>  > +extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
>  > +extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
>  > +				char *productid);
>  > +#endif
> 
> It seems that this #ifndef is not needed -- even if there is another
> declaration of these functions that is visible, the signatures should
> match so it should be OK.
> 

Compiler does throw warning as one set of functions is static and
other is not.

arch/i386/mach-generic/es7000.c:37: warning: static declaration of 'mps_oem_check' follows non-static declaration
include/asm/mach-es7000/mach_mpparse.h:23: warning: previous declaration of 'mps_oem_check' was here
arch/i386/mach-generic/es7000.c:50: warning: static declaration of 'acpi_madt_oem_check' follows non-static declaration
include/asm/mach-es7000/mach_mpparse.h:21: warning: previous declaration of 'acpi_madt_oem_check' was here

Thanks
Vivek

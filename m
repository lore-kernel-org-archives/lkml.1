Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbXFMWXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbXFMWXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbXFMWW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:22:58 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:46907 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbXFMWW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:22:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eOvf9EUJgFSbRm/v8U9RFpH/b6MMiaStaH3mr6GF2FOmA09zqZnvpjbVSWSmq6PxOJhJ0d/TA4+WJk7VfZHpCwPlGbE9xQW9FslcauNdiUotSDGmgkhOo+vhkHLWo3LQhXxtbOnpe5otvp0iLZyYnfRXgUTnIP/QmZvWslnQhLk=
Message-ID: <32209efe0706131522n42eff7b1hfea6a6252289e280@mail.gmail.com>
Date: Wed, 13 Jun 2007 15:22:55 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: linux-kernel@vger.kernel.org, rdreier@cisco.com, akpm@linux-foundation.org,
       vgoyal@in.ibm.com
Subject: Re: CONFIG_X86_ES7000=y, CONFIG_X86_GENERICARCH=n, CONFIG_ACPI=y build broken
In-Reply-To: <19D0D50E9B1D0A40A9F0323DBFA04ACC023B0EB9@USRV-EXCH4.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19D0D50E9B1D0A40A9F0323DBFA04ACC023B0EB9@USRV-EXCH4.na.uis.unisys.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  > Can you please try the attached patch? I have compiled it with
> CONFIG_ES7000=y
>  > and CONFIG_X86_GENERICARCH=n. But don't have any ES7000 machine to
> test it.
>
> I actually don't have anything remotely like ES7000 iether.  I just
> found the problem while tracking down another randconfig failure.
>
>  > Subarch build procedure is not straightforward and this patch adds to
> the
>  > misery. Please suggest if there is a better way of handling things.
>
>  > +/*
>  > + * This file also gets compiled if CONFIG_X86_GENERICARCH is set.
> Generic
>  > + * arch already has got following function definitions
> (asm-generic/es7000.c)
>  > + * hence no need to define these for that case.
>  > + */
>  > +#ifndef CONFIG_X86_GENERICARCH
>
> Seems it would be cleaner to figure out some way to build es7000.c for
> if CONFIG_X86_ES7000 is set?  Or just move them here all the time?
>
>  > ---
> linux-2.6.22-rc4-git4/include/asm-i386/mach-es7000/mach_mpparse.h~i386-e
> s7000-build-breakage-fix        2007-06-13 22:52:14.000000000 +0530
>  > +++
> linux-2.6.22-rc4-git4-vivek/include/asm-i386/mach-es7000/mach_mpparse.h
> 2007-06-13 22:52:14.000000000 +0530
>  > @@ -18,6 +18,12 @@ extern int parse_unisys_oem (char *oempt
>  >  extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
>  >  extern void setup_unisys(void);
>  >
>  > +#ifndef CONFIG_X86_GENERICARCH
>  > +extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
>  > +extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
>  > +                            char *productid);
>  > +#endif
>
> It seems that this #ifndef is not needed -- even if there is another
> declaration of these functions that is visible, the signatures should
> match so it should be OK.

I just finished my test builds with and without GENERIC, so I can
suggest just move all functions to arch/i386/mach-es7000/es7000plat.c
- es7000_sw_apic() ,es7000_enable_apic_mode(),acpi_madt_oem_check(),
mps_oem_check() and make them non-static - from
arch/i386/mach-generic/es7000.c and I think I externed couple things
in asm/mach-es7000/mach_apic.h. So the file
arch/i386/mach-generic/es7000.c looks very simple:
/*  * APIC driver for the Unisys ES7000 chipset.
 */
#define APIC_DEFINITION 1
#include <linux/threads.h>
#include <linux/cpumask.h>
#include <asm/smp.h>
#include <asm/mpspec.h>
#include <asm/genapic.h>
#include <asm/fixmap.h>
#include <asm/apicdef.h>
#include <linux/kernel.h>
#include <linux/string.h>
#include <linux/smp.h>
#include <linux/init.h>
#include <asm/mach-es7000/mach_apicdef.h>
#include <asm/mach-es7000/mach_apic.h>
#include <asm/mach-es7000/mach_ipi.h>
#include <asm/mach-es7000/mach_mpparse.h>
#include <asm/mach-es7000/mach_wakecpu.h>

static int probe_es7000(void)
{
        /* probed later in mptable/ACPI hooks */
        return 0;
}

struct genapic apic_es7000 = APIC_INIT("es7000", probe_es7000);


and no ifdefs. Sorry for this skimpy description without actual patch...
I can send a patch later on, or you guys can try it yourselves :)
sorry have such a tight time this afternoon, only can back to my
computer after 7-8 pm...
Regards,
--Natalie

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbXFMSxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbXFMSxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbXFMSxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:53:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:37992 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbXFMSxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nDr8Mqt9SP4xOj3Re5Xt5ZYyLAzuNf33XY3yLC1mz0cjoNk8eEicS0JAvhsoQQSPqWKb5QpZeS9W/cilTXZmfmW7zb8RB8Bi7qZEjSuh/Aremwmt148NhPW7Gxdqt3rZ6nEL2i25GPjnW44EIHa/EClUGqnag5AKt7o45UR/Hd4=
Message-ID: <32209efe0706131153w524ebcb4pcbe8318d225ba0e0@mail.gmail.com>
Date: Wed, 13 Jun 2007 11:53:22 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: RE: CONFIG_X86_ES7000=y, CONFIG_X86_GENERICARCH=n, CONFIG_ACPI=y build broken
In-Reply-To: <32209efe0706131107w157fd59bk22f1fe62e4d1c733@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19D0D50E9B1D0A40A9F0323DBFA04ACC023B0EB8@USRV-EXCH4.na.uis.unisys.com>
	 <32209efe0706131107w157fd59bk22f1fe62e4d1c733@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Vivek Goyal [mailto:vgoyal@in.ibm.com]
> Sent: Wednesday, June 13, 2007 11:38 AM
> To: Roland Dreier
> Cc: linux-kernel@vger.kernel.org; Protasevich, Natalie;
> akpm@linux-foundation.org
> Subject: Re: CONFIG_X86_ES7000=y, CONFIG_X86_GENERICARCH=n,
> CONFIG_ACPI=y build broken
>
> On Tue, Jun 12, 2007 at 12:13:50PM -0700, Roland Dreier wrote:
> > (sending to Vivek since he seems to be one of the last people to touch
> > this code)
> >
> > For some strange reason I found myself compiling a kernel with
> > CONFIG_X86_ES7000 and CONFIG_ACPI set and CONFIG_X86_GENERICARCH not
> > set.  It died with
> >
> >     arch/i386/kernel/built-in.o: In function `acpi_parse_madt':
> >     boot.c:(.init.text+0x68b7): undefined reference to
> `acpi_madt_oem_check'
> >     arch/i386/kernel/built-in.o: In function `get_smp_config':
> >     (.init.text+0x9f98): undefined reference to `mps_oem_check'
> >     arch/i386/kernel/built-in.o: In function `connect_bsp_APIC':
> >     (.init.text+0xa340): undefined reference to `enable_apic_mode'
> >     arch/i386/kernel/built-in.o: In function `connect_bsp_APIC':
> >     (.init.text+0xa370): undefined reference to `enable_apic_mode'
> >
> > this seems to be because eg acpi_madt_oem_check() and mps_oem_check()
> > are defined in arch/i386/mach-generic/es7000.c, but arch/i386/Makefile
> > only goes into mach-generic if CONFIG_X86_GENERICARCH is set.
> > I didn't track down why enable_apic_mode is broken yet.
> >
>

Vivek,
I also have a patch that seems to work... I did remove the functions
from mach-generic/es7000.c and added them same place you did, so the
code is not duplicated and I didn't have to make any ifdefs.
As soon as your patch works though I think it's fine.
Thanks,
--Natalie

> Hi Roland,
>
> Can you please try the attached patch? I have compiled it with
> CONFIG_ES7000=y
> and CONFIG_X86_GENERICARCH=n. But don't have any ES7000 machine to test
> it.
>
> I have compiled and booted the kernel on my machine with
> CONFIG_X86_GENERICARCH=y.
>
> Subarch build procedure is not straightforward and this patch adds to
> the
> misery. Please suggest if there is a better way of handling things.
>
>
>
> o Commit 1833d6bc72893265f22addd79cf52e6987496e0f broke the build if
>   compiled with CONFIG_ES7000=y and CONFIG_X86_GENERICARCH=n
>
> o Fix the build issue. Provided the definitions of missing functions.
>
>
> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
> ---
>
>  linux-2.6.22-rc4-git4-vivek/arch/i386/mach-es7000/es7000plat.c
> |   48 ++++++++++
>  linux-2.6.22-rc4-git4-vivek/include/asm-i386/mach-es7000/mach_apic.h
> |    4
>  linux-2.6.22-rc4-git4-vivek/include/asm-i386/mach-es7000/mach_mpparse.h
> |    6 +
>  3 files changed, 58 insertions(+)
>
> diff -puN
> arch/i386/mach-es7000/es7000plat.c~i386-es7000-build-breakage-fix
> arch/i386/mach-es7000/es7000plat.c
> ---
> linux-2.6.22-rc4-git4/arch/i386/mach-es7000/es7000plat.c~i386-es7000-bui
> ld-breakage-fix 2007-06-13 22:52:14.000000000 +0530
> +++ linux-2.6.22-rc4-git4-vivek/arch/i386/mach-es7000/es7000plat.c
> 2007-06-13 22:53:03.000000000 +0530
> @@ -40,6 +40,7 @@
>  #include <asm/smp.h>
>  #include <asm/apicdef.h>
>  #include "es7000.h"
> +#include <mach_mpparse.h>
>
>  /*
>   * ES7000 Globals
> @@ -174,6 +175,53 @@ find_unisys_acpi_oem_table(unsigned long
>  }
>  #endif
>
> +/*
> + * This file also gets compiled if CONFIG_X86_GENERICARCH is set.
> Generic
> + * arch already has got following function definitions
> (asm-generic/es7000.c)
> + * hence no need to define these for that case.
> + */
> +#ifndef CONFIG_X86_GENERICARCH
> +void es7000_sw_apic(void);
> +void __init enable_apic_mode(void)
> +{
> +       es7000_sw_apic();
> +       return;
> +}
> +
> +__init int mps_oem_check(struct mp_config_table *mpc, char *oem,
> +               char *productid)
> +{
> +       if (mpc->mpc_oemptr) {
> +               struct mp_config_oemtable *oem_table =
> +                       (struct mp_config_oemtable *)mpc->mpc_oemptr;
> +               if (!strncmp(oem, "UNISYS", 6))
> +                       return parse_unisys_oem((char *)oem_table);
> +       }
> +       return 0;
> +}
> +#ifdef CONFIG_ACPI
> +/* Hook from generic ACPI tables.c */
> +int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
> +{
> +       unsigned long oem_addr;
> +       if (!find_unisys_acpi_oem_table(&oem_addr)) {
> +               if (es7000_check_dsdt())
> +                       return parse_unisys_oem((char *)oem_addr);
> +               else {
> +                       setup_unisys();
> +                       return 1;
> +               }
> +       }
> +       return 0;
> +}
> +#else
> +int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
> +{
> +       return 0;
> +}
> +#endif
> +#endif /* COFIG_X86_GENERICARCH */
> +
>  static void
>  es7000_spin(int n)
>  {
> diff -puN
> include/asm-i386/mach-es7000/mach_apic.h~i386-es7000-build-breakage-fix
> include/asm-i386/mach-es7000/mach_apic.h
> ---
> linux-2.6.22-rc4-git4/include/asm-i386/mach-es7000/mach_apic.h~i386-es70
> 00-build-breakage-fix   2007-06-13 22:52:14.000000000 +0530
> +++ linux-2.6.22-rc4-git4-vivek/include/asm-i386/mach-es7000/mach_apic.h
> 2007-06-13 22:52:14.000000000 +0530
> @@ -73,6 +73,10 @@ static inline void init_apic_ldr(void)
>         apic_write_around(APIC_LDR, val);
>  }
>
> +#ifndef CONFIG_X86_GENERICARCH
> +extern void enable_apic_mode(void);
> +#endif
> +
>  extern int apic_version [MAX_APICS];
>  static inline void setup_apic_routing(void)
>  {
> diff -puN
> include/asm-i386/mach-es7000/mach_mpparse.h~i386-es7000-build-breakage-f
> ix include/asm-i386/mach-es7000/mach_mpparse.h
> ---
> linux-2.6.22-rc4-git4/include/asm-i386/mach-es7000/mach_mpparse.h~i386-e
> s7000-build-breakage-fix        2007-06-13 22:52:14.000000000 +0530
> +++
> linux-2.6.22-rc4-git4-vivek/include/asm-i386/mach-es7000/mach_mpparse.h
> 2007-06-13 22:52:14.000000000 +0530
> @@ -18,6 +18,12 @@ extern int parse_unisys_oem (char *oempt
>  extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
>  extern void setup_unisys(void);
>
> +#ifndef CONFIG_X86_GENERICARCH
> +extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
> +extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
> +                               char *productid);
> +#endif
> +
>  #ifdef CONFIG_ACPI
>
>  static inline int es7000_check_dsdt(void)
> _
>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbXFQOfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbXFQOfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 10:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbXFQOex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 10:34:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:43614 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbXFQOex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 10:34:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RGlfz+7eF6ti8weEWSBQKeulPqTIlU1CUVShERF7o2cE4TZp9Z9kuW1BqQpb4gL8NaLFxG62lLn2NkobvqZoYa8o+CoufHEnNDH8/LRCP6rQzl5+0tEmsEi+7YHg7DbQzCgLbvs4gOOSKqBw3Fl7e4oI/oIia4rk3jJKcB5YVT4=
Message-ID: <32209efe0706170734h569e7039s1dadb58a096843d1@mail.gmail.com>
Date: Sun, 17 Jun 2007 07:34:51 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: vgoyal@in.ibm.com, linux-kernel@vger.kernel.org, rdreier@cisco.com,
       akpm@linux-foundation.org
Subject: RE: CONFIG_X86_ES7000=y, CONFIG_X86_GENERICARCH=n, CONFIG_ACPI=y build broken
In-Reply-To: <19D0D50E9B1D0A40A9F0323DBFA04ACC023B0EBD@USRV-EXCH4.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19D0D50E9B1D0A40A9F0323DBFA04ACC023B0EBD@USRV-EXCH4.na.uis.unisys.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jun 13, 2007 at 01:39:29PM -0700, Roland Dreier wrote:
> >  > Can you please try the attached patch? I have compiled it with
> CONFIG_ES7000=y
> >  > and CONFIG_X86_GENERICARCH=n. But don't have any ES7000 machine to
> test it.
> >
> > I actually don't have anything remotely like ES7000 iether.  I just
> > found the problem while tracking down another randconfig failure.
> >
> >  > Subarch build procedure is not straightforward and this patch adds
> to the
> >  > misery. Please suggest if there is a better way of handling things.
> >
> >  > +/*
> >  > + * This file also gets compiled if CONFIG_X86_GENERICARCH is set.
> Generic
> >  > + * arch already has got following function definitions
> (asm-generic/es7000.c)
> >  > + * hence no need to define these for that case.
> >  > + */
> >  > +#ifndef CONFIG_X86_GENERICARCH
> >
> > Seems it would be cleaner to figure out some way to build es7000.c for
> > if CONFIG_X86_ES7000 is set?  Or just move them here all the time?
> >
> >  > ---
> linux-2.6.22-rc4-git4/include/asm-i386/mach-es7000/mach_mpparse.h~i386-e
> s7000-build-breakage-fix        2007-06-13 22:52:14.000000000 +0530
> >  > +++
> linux-2.6.22-rc4-git4-vivek/include/asm-i386/mach-es7000/mach_mpparse.h
> 2007-06-13 22:52:14.000000000 +0530
> >  > @@ -18,6 +18,12 @@ extern int parse_unisys_oem (char *oempt
> >  >  extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
> >  >  extern void setup_unisys(void);
> >  >
> >  > +#ifndef CONFIG_X86_GENERICARCH
> >  > +extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
> >  > +extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
> >  > +                          char *productid);
> >  > +#endif
> >
> > It seems that this #ifndef is not needed -- even if there is another
> > declaration of these functions that is visible, the signatures should
> > match so it should be OK.
> >
>
> Compiler does throw warning as one set of functions is static and
> other is not.
>
> arch/i386/mach-generic/es7000.c:37: warning: static declaration of
> 'mps_oem_check' follows non-static declaration
> include/asm/mach-es7000/mach_mpparse.h:23: warning: previous declaration
> of 'mps_oem_check' was here
> arch/i386/mach-generic/es7000.c:50: warning: static declaration of
> 'acpi_madt_oem_check' follows non-static declaration
> include/asm/mach-es7000/mach_mpparse.h:21: warning: previous declaration
> of 'acpi_madt_oem_check' was here

Here is the patch that does work - but... I do have warnings that I
haven't noticed initially when compile for ES7000 case:

...
  CC      arch/i386/kernel/acpi/boot.o
include/asm-i386/mach-es7000/mach_mpparse.h:56: warning:
'mps_oem_check' defined but not used
  CC      arch/i386/kernel/mpparse.o
...
include/asm-i386/mach-es7000/mach_mpparse.h:35: warning:
'acpi_madt_oem_check' defined but not used
  CC      arch/i386/kernel/apic.o
...
  CC      arch/i386/kernel/nmi.o

I'm afraid I will have to do something ugly or ifdef to get rid of
this warning, so I guess I'd rather take yours, Vivec :) since it
compiles and runs cleanly.
Thanks!
--Natalie

---------------------------------------------------------------------------------
diff -Naur linux-2.6/arch/i386/mach-es7000/es7000plat.c
linux-2.6-mod/arch/i386/mach-es7000/es7000plat.c---
linux-2.6/arch/i386/mach-es7000/es7000plat.c        2007-06-12
21:16:15.000000000 -0700
+++ linux-2.6-mod/arch/i386/mach-es7000/es7000plat.c    2007-06-17
06:56:49.000000000 -0700
@@ -277,3 +277,11 @@
                return;
        }
 }
+
+void __init
+enable_apic_mode(void)
+{
+       es7000_sw_apic();
+       return;
+}
+
diff -Naur linux-2.6/arch/i386/mach-generic/es7000.c
linux-2.6-mod/arch/i386/mach-generic/es7000.c
--- linux-2.6/arch/i386/mach-generic/es7000.c   2007-06-12
21:16:15.000000000 -0700
+++ linux-2.6-mod/arch/i386/mach-generic/es7000.c       2007-06-17
06:57:20.000000000 -0700
@@ -26,44 +26,6 @@
 }

 extern void es7000_sw_apic(void);
-static void __init enable_apic_mode(void)
-{
-       es7000_sw_apic();
-       return;
-}
-
-static __init int mps_oem_check(struct mp_config_table *mpc, char *oem,
-               char *productid)
-{
-       if (mpc->mpc_oemptr) {
-               struct mp_config_oemtable *oem_table =
-                       (struct mp_config_oemtable *)mpc->mpc_oemptr;
-               if (!strncmp(oem, "UNISYS", 6))
-                       return parse_unisys_oem((char *)oem_table);
-       }
-       return 0;
-}
-
-#ifdef CONFIG_ACPI
-/* Hook from generic ACPI tables.c */
-static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
-{
-       unsigned long oem_addr;
-       if (!find_unisys_acpi_oem_table(&oem_addr)) {
-               if (es7000_check_dsdt())
-                       return parse_unisys_oem((char *)oem_addr);
-               else {
-                       setup_unisys();
-                       return 1;
-               }
-       }
-       return 0;
-}
-#else
-static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
-{
-       return 0;
-}
-#endif
+extern void enable_apic_mode(void);

 struct genapic apic_es7000 = APIC_INIT("es7000", probe_es7000); diff
-Naur linux-2.6/include/asm-i386/mach-es7000/mach_apic.h
linux-2.6-mod/include/asm-i386/mach-es7000/mach_apic.h
--- linux-2.6/include/asm-i386/mach-es7000/mach_apic.h  2007-06-12
21:16:18.000000000 -0700
+++ linux-2.6-mod/include/asm-i386/mach-es7000/mach_apic.h
2007-06-17 06:51:48.000000000 -0700
@@ -199,4 +199,6 @@
        return cpuid_apic >> index_msb;
 }

+extern void enable_apic_mode(void);
+
 #endif /* __ASM_MACH_APIC_H */ diff -Naur
linux-2.6/include/asm-i386/mach-es7000/mach_mpparse.h
linux-2.6-mod/include/asm-i386/mach-es7000/mach_mpparse.h
--- linux-2.6/include/asm-i386/mach-es7000/mach_mpparse.h
2007-06-12 21:16:18.000000000 -0700
+++ linux-2.6-mod/include/asm-i386/mach-es7000/mach_mpparse.h
2007-06-17 06:54:54.000000000 -0700
@@ -29,6 +29,38 @@
                return 1;
        return 0;
 }
+
+/* Hook from generic ACPI tables.c */
+static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+       unsigned long oem_addr;
+       if (!find_unisys_acpi_oem_table(&oem_addr)) {
+               if (es7000_check_dsdt())
+                       return parse_unisys_oem((char *)oem_addr);
+               else {
+                       setup_unisys();
+                       return 1;
+               }
+       }
 #endif

+static __init int mps_oem_check(struct mp_config_table *mpc, char *oem,
+               char *productid)
+{
+       if (mpc->mpc_oemptr) {
+               struct mp_config_oemtable *oem_table =
+                       (struct mp_config_oemtable *)mpc->mpc_oemptr;
+               if (!strncmp(oem, "UNISYS", 6))
+                       return parse_unisys_oem((char *)oem_table);
+       }
+       return 0;
+}
+
 #endif /* __ASM_MACH_MPPARSE_H */

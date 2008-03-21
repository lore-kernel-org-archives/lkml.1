Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYCUG3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYCUG3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 02:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYCUG3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 02:29:04 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:61559 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbYCUG3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 02:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S57cRzh3yf8z6tSZ3QwaxmlxQkFW56roakJNX6JDdswXK/iARJlg+L36UIArfNEQtzI2NLb/QkloHwatLdsNvK9Mva3y0kEyg9hYGjzjbTrooBD5O6MHo7WVsBuM8GaII7hhLd1ICQh3afJnrrAYdao8gki6Ska+Sa5axAlUQmU=
Message-ID: <86802c440803202328s8a58b5dkc91644936258a9dc@mail.gmail.com>
Date: Thu, 20 Mar 2008 23:28:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [patch 2/4] x86: Fix build breakage when PCI is define and PARAVIRT is not
Cc: "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       "Andi Kleen" <ak@suse.de>, shai@scalex86.org
In-Reply-To: <47E339D1.3080509@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080320073740.GA9414@localdomain>
	 <20080320074116.GC9414@localdomain> <47E339D1.3080509@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 9:30 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Ravikiran G Thirumalai wrote:
>  > - Fix the the build breakage when PARAVIRT is defined
>  >   but PCI is not
>  >   This fixes problem reported at:
>  >       http://marc.info/?l=linux-kernel&m=120525966600698&w=2
>  > - Make is_vsmp_box() available even when PARAVIRT is not defined.
>  >   This is needed to determine if tsc's are reliable as a time source
>  >   even when PARAVIRT is not defined.
>  > - split vsmp_init to use is_vsmp_box() and set_vsmp_pv_ops()
>  >   set_vsmp_pv_ops will do nothing if PCI is not enabled in the config.
>  >
>
>  I'm a bit confused by all the config dependencies.  I had assumed that
>  VSMP depended on both PCI and PARAVIRT.  Is this not actually true?  You
>  can have a VSMP system without either or both of PCI/PARAVIRT?
>
>  The structure of the code suggests that at the very least VSMP depends
>  on PCI (it never makes sense to enable VSMP on a non-PCI system), and
>  therefore a number of your config decisions can just be predicated on VSMP.
>
>
>  > Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
>  >
>  > Index: linux.git.trees/arch/x86/kernel/Makefile
>  > ===================================================================
>  > --- linux.git.trees.orig/arch/x86/kernel/Makefile     2008-03-19 13:39:29.000000000 -0700
>  > +++ linux.git.trees/arch/x86/kernel/Makefile  2008-03-19 13:46:14.400935607 -0700
>  > @@ -60,7 +60,7 @@ obj-$(CONFIG_KEXEC)         += relocate_kernel_
>  >  obj-$(CONFIG_CRASH_DUMP)     += crash_dump_$(BITS).o
>  >  obj-$(CONFIG_X86_NUMAQ)              += numaq_32.o
>  >  obj-$(CONFIG_X86_SUMMIT_NUMA)        += summit_32.o
>  > -obj-$(CONFIG_PARAVIRT)               += vsmp_64.o
>  > +obj-y                                += vsmp_64.o
>  >
>
>  Couldn't this be make obj-$(CONFIG_X86_VSMP)?
>
>
>
>  >  obj-$(CONFIG_KPROBES)                += kprobes.o
>  >  obj-$(CONFIG_MODULES)                += module_$(BITS).o
>  >  obj-$(CONFIG_ACPI_SRAT)      += srat_32.o
>  > Index: linux.git.trees/arch/x86/kernel/setup_64.c
>  > ===================================================================
>  > --- linux.git.trees.orig/arch/x86/kernel/setup_64.c   2008-03-19 13:39:29.000000000 -0700
>  > +++ linux.git.trees/arch/x86/kernel/setup_64.c        2008-03-19 13:57:43.951337318 -0700
>  > @@ -353,9 +353,7 @@ void __init setup_arch(char **cmdline_p)
>  >       if (efi_enabled)
>  >               efi_init();
>  >
>  > -#ifdef       CONFIG_PARAVIRT
>  >       vsmp_init();
>  > -#endif
>  >
>  >       dmi_scan_machine();
>  >
>  > Index: linux.git.trees/arch/x86/kernel/vsmp_64.c
>  > ===================================================================
>  > --- linux.git.trees.orig/arch/x86/kernel/vsmp_64.c    2008-03-19 13:39:50.000000000 -0700
>  > +++ linux.git.trees/arch/x86/kernel/vsmp_64.c 2008-03-19 20:53:34.267707163 -0700
>  > @@ -19,6 +19,7 @@
>  >  #include <asm/io.h>
>  >  #include <asm/paravirt.h>
>  >
>  > +#if defined CONFIG_PCI && defined CONFIG_PARAVIRT
>  >  /*
>  >   * Interrupt control on vSMPowered systems:
>  >   * ~AC is a shadow of IF.  If IF is 'on' AC should be 'off'
>  > @@ -72,39 +73,11 @@ static unsigned __init vsmp_patch(u8 typ
>  >
>  >  }
>  >
>  > -static int vsmp = -1;
>  > -
>  > -int is_vsmp_box(void)
>  > -{
>  > -     if (vsmp != -1)
>  > -             return vsmp;
>  > -
>  > -     vsmp = 0;
>  > -     if (!early_pci_allowed())
>  > -             return vsmp;
>  > -
>  > -     /* Check if we are running on a ScaleMP vSMP box */
>  > -     if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) ==
>  > -          PCI_VENDOR_ID_SCALEMP) &&
>  > -         (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) ==
>  > -         PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
>  > -             vsmp = 1;
>  > -
>  > -     return vsmp;
>  > -}
>  > -
>  > -void __init vsmp_init(void)
>  > +static void __init set_vsmp_pv_ops(void)
>  >  {
>  >       void *address;
>  >       unsigned int cap, ctl, cfg;
>  >
>  > -     if (!is_vsmp_box())
>  > -             return;
>  > -
>  > -     if (!early_pci_allowed())
>  > -             return;
>  > -
>  > -     /* If we are, use the distinguished irq functions */
>  >       pv_irq_ops.irq_disable = vsmp_irq_disable;
>  >       pv_irq_ops.irq_enable  = vsmp_irq_enable;
>  >       pv_irq_ops.save_fl  = vsmp_save_fl;
>  > @@ -127,5 +100,46 @@ void __init vsmp_init(void)
>  >       }
>  >
>  >       early_iounmap(address, 8);
>  > +}
>  > +#else
>  > +static void __init set_vsmp_pv_ops(void)
>  > +{
>  > +}
>  > +#endif
>  > +
>  > +#ifdef CONFIG_PCI
>  > +static int vsmp = -1;
>  > +
>  > +int is_vsmp_box(void)
>  > +{
>  > +     if (vsmp != -1)
>  > +             return vsmp;
>  > +
>  > +     vsmp = 0;
>  > +     if (!early_pci_allowed())
>  > +             return vsmp;
>  > +
>  > +     /* Check if we are running on a ScaleMP vSMP box */
>  > +     if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) ==
>  > +          PCI_VENDOR_ID_SCALEMP) &&
>  > +         (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) ==
>  > +         PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
>  > +             vsmp = 1;
>  > +
>  > +     return vsmp;
>  > +}
>  > +#else
>  > +int is_vsmp_box(void)
>  > +{
>  > +     return 0;
>  > +}
>  > +#endif
>  >
>
>  Rather than doing this, I'd propose putting
>
>  #ifndef CONFIG_X86_VSMP
>  static inline int is_vsmp_box(void)
>  {
>     return 0;
>  }
>  #endif
>
>  in a header, and then making the definition in vsmp_64.c unconditional
>  (or rather, the whole of vsmp_64.o conditional on CONFIG_X86_VSMP).
>
>
>  > +
>  > +void __init vsmp_init(void)
>  > +{
>  > +     if (!is_vsmp_box())
>  > +             return;
>  > +
>  > +     set_vsmp_pv_ops();
>  >       return;
>  >  }
>  >
>
>  Similarly with this.
>
>
>  > Index: linux.git.trees/include/asm-x86/apic.h
>  > ===================================================================
>  > --- linux.git.trees.orig/include/asm-x86/apic.h       2008-03-19 13:39:29.000000000 -0700
>  > +++ linux.git.trees/include/asm-x86/apic.h    2008-03-19 13:57:14.550893819 -0700
>  > @@ -51,19 +51,16 @@ extern unsigned boot_cpu_id;
>  >   */
>  >  #ifdef CONFIG_PARAVIRT
>  >  #include <asm/paravirt.h>
>  > -extern int is_vsmp_box(void);
>  >  #else
>  >  #define apic_write native_apic_write
>  >  #define apic_write_atomic native_apic_write_atomic
>  >  #define apic_read native_apic_read
>  >  #define setup_boot_clock setup_boot_APIC_clock
>  >  #define setup_secondary_clock setup_secondary_APIC_clock
>  > -static int inline is_vsmp_box(void)
>  > -{
>  > -     return 0;
>  > -}
>  >  #endif
>  >
>  > +extern int is_vsmp_box(void);
>  > +
>  >
>
>  This was almost right, except it should have been in a #ifdef
>  CONFIG_X86_VSMP block.
>
>
agreed

http://lkml.org/lkml/2008/3/18/76

YH

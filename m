Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270AbXKMI0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbXKMI0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 03:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbXKMI0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 03:26:41 -0500
Received: from www.tglx.de ([62.245.132.106]:53943 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXKMI0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 03:26:40 -0500
Date: Tue, 13 Nov 2007 09:26:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] arch/x86/kernel/setup_64.c compile error
 (MMOTM-2007-11-10-19-05)
In-Reply-To: <20071112172841.b4dc21b5.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0711130916540.3265@localhost.localdomain>
References: <200711112234.lABMYo0n004269@agora.fsl.cs.sunysb.edu> <20071112172841.b4dc21b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2007, Andrew Morton wrote:
> hm, that doesn't seem right.  We want to run the early quirks on non-ACPI
> kernel too, surely?
> 
> If so then the fix would be to move the early_quirks() declaration from
> include/asm-x86/acpi_[32|64].h into, say, include/asm-x86/pci.h.  And while
> we're there, do the config dependency in the correct way:

Yeah, the same fix is in the cleanup branch. I push this one Linus wards.

      tglx

> From: Andrew Morton <akpm@linux-foundation.org>
> 
> With CONFIG_ACPI=n:
> 
> arch/x86/kernel/setup_64.c: In function 'setup_arch':
> arch/x86/kernel/setup_64.c:420: error: implicit declaration of function 'early_quirks'
> 
> because the early_quirks() declaraion is inside an ACPI header file.
> 
> Move it out of there and into include/asm-x86/pci.h and clean a few related
> things up.
> 
> Cc: Erez Zadok <ezk@cs.sunysb.edu>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86/kernel/early-quirks.c |    1 +
>  arch/x86/kernel/setup_32.c     |    3 +--
>  arch/x86/kernel/setup_64.c     |    2 --
>  include/asm-x86/acpi_32.h      |    2 --
>  include/asm-x86/acpi_64.h      |    2 --
>  include/asm-x86/pci.h          |    4 ++++
>  6 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff -puN include/asm-x86/acpi_32.h~x86-early_quirks-fix-build include/asm-x86/acpi_32.h
> --- a/include/asm-x86/acpi_32.h~x86-early_quirks-fix-build
> +++ a/include/asm-x86/acpi_32.h
> @@ -79,8 +79,6 @@ int __acpi_release_global_lock(unsigned 
>          :"=r"(n_hi), "=r"(n_lo)     \
>          :"0"(n_hi), "1"(n_lo))
>  
> -extern void early_quirks(void);
> -
>  #ifdef CONFIG_ACPI
>  extern int acpi_lapic;
>  extern int acpi_ioapic;
> diff -puN include/asm-x86/acpi_64.h~x86-early_quirks-fix-build include/asm-x86/acpi_64.h
> --- a/include/asm-x86/acpi_64.h~x86-early_quirks-fix-build
> +++ a/include/asm-x86/acpi_64.h
> @@ -78,8 +78,6 @@ int __acpi_release_global_lock(unsigned 
>          :"=r"(n_hi), "=r"(n_lo)     \
>          :"0"(n_hi), "1"(n_lo))
>  
> -extern void early_quirks(void);
> -
>  #ifdef CONFIG_ACPI
>  extern int acpi_lapic;
>  extern int acpi_ioapic;
> diff -puN include/asm-x86/pci.h~x86-early_quirks-fix-build include/asm-x86/pci.h
> --- a/include/asm-x86/pci.h~x86-early_quirks-fix-build
> +++ a/include/asm-x86/pci.h
> @@ -40,8 +40,12 @@ static inline int pci_proc_domain(struct
>  
>  #ifdef CONFIG_PCI
>  extern unsigned int pcibios_assign_all_busses(void);
> +extern void early_quirks(void);
>  #else
>  #define pcibios_assign_all_busses()	0
> +static inline void early_quirks(void)
> +{
> +}
>  #endif
>  #define pcibios_scan_all_fns(a, b)	0
>  
> diff -puN arch/x86/kernel/setup_32.c~x86-early_quirks-fix-build arch/x86/kernel/setup_32.c
> --- a/arch/x86/kernel/setup_32.c~x86-early_quirks-fix-build
> +++ a/arch/x86/kernel/setup_32.c
> @@ -41,6 +41,7 @@
>  #include <linux/edd.h>
>  #include <linux/nodemask.h>
>  #include <linux/kexec.h>
> +#include <linux/pci.h>
>  #include <linux/crash_dump.h>
>  #include <linux/dmi.h>
>  #include <linux/pfn.h>
> @@ -732,9 +733,7 @@ void __init setup_arch(char **cmdline_p)
>  	acpi_boot_table_init();
>  #endif
>  
> -#ifdef CONFIG_PCI
>  	early_quirks();
> -#endif
>  
>  #ifdef CONFIG_ACPI
>  	acpi_boot_init();
> diff -puN arch/x86/kernel/setup_64.c~x86-early_quirks-fix-build arch/x86/kernel/setup_64.c
> --- a/arch/x86/kernel/setup_64.c~x86-early_quirks-fix-build
> +++ a/arch/x86/kernel/setup_64.c
> @@ -408,9 +408,7 @@ void __init setup_arch(char **cmdline_p)
>  	reserve_crashkernel();
>  	paging_init();
>  
> -#ifdef CONFIG_PCI
>  	early_quirks();
> -#endif
>  
>  	/*
>  	 * set this early, so we dont allocate cpu0
> diff -puN arch/x86/kernel/early-quirks.c~x86-early_quirks-fix-build arch/x86/kernel/early-quirks.c
> --- a/arch/x86/kernel/early-quirks.c~x86-early_quirks-fix-build
> +++ a/arch/x86/kernel/early-quirks.c
> @@ -12,6 +12,7 @@
>  #include <linux/pci.h>
>  #include <linux/acpi.h>
>  #include <linux/pci_ids.h>
> +
>  #include <asm/pci-direct.h>
>  #include <asm/dma.h>
>  #include <asm/io_apic.h>
> _
> 

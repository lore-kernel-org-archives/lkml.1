Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZERU6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZERU6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZERU6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:58:43 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:31584 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbZERU6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:58:42 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH, v2] x86: add X86_UPDATE_MPTABLE option
Date: Mon, 18 May 2009 14:58:37 -0600
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Len Brown <lenb@kernel.org>
References: <4A0DC7DC.7000204@kernel.org> <200905180941.06988.bjorn.helgaas@hp.com> <4A11A21D.1080301@kernel.org>
In-Reply-To: <4A11A21D.1080301@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905181458.39429.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 May 2009 11:59:57 am Yinghai Lu wrote:
> 
> so could enable it for special purpose.
> 1. for acpi enabled kernel kexec kernel without acpi
> 2. for crossing check mptable or have correct mptable
> 
> even with this option enabled, user still need to use
> update_mpatble or alloc_mptable in command line
> 
> v2: update to make it depends on KEXEC according to Bjorn

Wait a minute.  I did raise the possibility of a config option,
but only in the context of code whose only purpose was to help
debug the BIOS.  And I suggested that code like that might not
belong in the mainline at all.

But this code is not like that, since you apparently need it for
kexec in general.  I don't think you should add an additional
config option just for this code.  A new option would just add
complexity for no benefit.

Bjorn

>    esp system have several cards and there is bridge in those cards

> [ Impact: new config option to disable update_mptable ]
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Len Brown <lenb@kernel.org>
> 
> ---
>  arch/x86/Kconfig              |   10 ++++++++++
>  arch/x86/include/asm/mpspec.h |    6 +++---
>  arch/x86/kernel/acpi/boot.c   |    3 ++-
>  arch/x86/kernel/mpparse.c     |    4 ++++
>  4 files changed, 19 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/arch/x86/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig
> +++ linux-2.6/arch/x86/Kconfig
> @@ -292,6 +292,16 @@ config X86_MPPARSE
>  	  For old smp systems that do not have proper acpi support. Newer systems
>  	  (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
>  
> +config X86_UPDATE_MPTABLE
> +	bool "Enable update mptable according to ACPI"
> +	default n
> +	depends on X86_MPPARSE && ACPI && KEXEC
> +	---help---
> +	  Some systems do not have correct mptable. With "update_mptable" or
> +	  "alloc_mptable" kernel could try to update mptable according to DSDT.
> +	  Then could use kexec to start second kernel (even old) without ACPI
> +	  support compiled in or "acpi=off"
> +
>  config X86_BIGSMP
>  	bool "Support for big SMP systems with more than 8 CPUs"
>  	depends on X86_32 && SMP
> Index: linux-2.6/arch/x86/kernel/acpi/boot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
> +++ linux-2.6/arch/x86/kernel/acpi/boot.c
> @@ -1159,7 +1159,7 @@ void __init mp_config_acpi_legacy_irqs(v
>  static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
>  			int polarity)
>  {
> -#ifdef CONFIG_X86_MPPARSE
> +#ifdef CONFIG_X86_UPDATE_MPTABLE
>  	struct mpc_intsrc mp_irq;
>  	struct pci_dev *pdev;
>  	unsigned char number;
> @@ -1191,6 +1191,7 @@ static int mp_config_acpi_gsi(struct dev
>  
>  	save_mp_irq(&mp_irq);
>  #endif
> +
>  	return 0;
>  }
>  
> Index: linux-2.6/arch/x86/kernel/mpparse.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/mpparse.c
> +++ linux-2.6/arch/x86/kernel/mpparse.c
> @@ -797,6 +797,8 @@ void __init find_smp_config(void)
>  	__find_smp_config(1);
>  }
>  
> +#ifdef CONFIG_X86_UPDATE_MPTABLE
> +
>  #ifdef CONFIG_X86_IO_APIC
>  static u8 __initdata irq_used[MAX_IRQ_SOURCES];
>  
> @@ -1080,3 +1082,5 @@ static int __init update_mp_table(void)
>  }
>  
>  late_initcall(update_mp_table);
> +
> +#endif /* CONFIG_X86_UPDATE_MPTABLE */
> Index: linux-2.6/arch/x86/include/asm/mpspec.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/mpspec.h
> +++ linux-2.6/arch/x86/include/asm/mpspec.h
> @@ -60,10 +60,8 @@ extern void get_smp_config(void);
>  
>  #ifdef CONFIG_X86_MPPARSE
>  extern void find_smp_config(void);
> -extern void early_reserve_e820_mpc_new(void);
>  #else
>  static inline void find_smp_config(void) { }
> -static inline void early_reserve_e820_mpc_new(void) { }
>  #endif
>  
>  void __cpuinit generic_processor_info(int apicid, int version);
> @@ -87,13 +85,15 @@ static inline int acpi_probe_gsi(void)
>  }
>  #endif /* CONFIG_ACPI */
>  
> -#ifdef CONFIG_X86_MPPARSE
> +#ifdef CONFIG_X86_UPDATE_MPTABLE
>  extern int enable_update_mptable;
> +extern void early_reserve_e820_mpc_new(void);
>  #else
>  static inline int enable_update_mptable(void)
>  {
>  	return 0;
>  }
> +static inline void early_reserve_e820_mpc_new(void) { }
>  #endif
>  
>  #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
> 



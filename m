Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbZCYNA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbZCYNA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZCYNAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:00:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40653 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbZCYNAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:00:13 -0400
Date: Wed, 25 Mar 2009 13:59:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, akataria@vmware.com
Subject: Re: [PATCH -tip] x86: move vmware to hypervisor
Message-ID: <20090325125955.GB516@elte.hu>
References: <1237281581.7907.2.camel@ht.satnam> <20090317093919.GD6477@elte.hu> <1237283318.7907.9.camel@ht.satnam> <49BFC6CB.9070603@zytor.com> <1237958994.5556.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237958994.5556.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Tue, 2009-03-17 at 08:50 -0700, H. Peter Anvin wrote:
> > Jaswinder Singh Rajput wrote:
> > >> I dont really like this one. KVM is a hypervisor too, and so is 
> > >> Xen and lguest. VMware is one of the many types of a 
> > >> hypervisors.
> > > 
> > > Can we use common hypervisor for Xen, lguest, vmware, etc.
> > > And Xen, lguest, vmware will be the sub-options.
> > 
> > Obviously.  We spent a lot of time breaking up the cpu stuff into common
> > and vendor-specific portions, we shouldn't go backwards w.r.t. hypervisors.
> > 	
> 
> OK, agreed.
> 
> But atleast give freedom to users to disable this who are not willing to
> use it.
> 
> Currently hypervisor is used only used by VMWARE, so is I prepare this
> freedom patch:
> 
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Wed, 25 Mar 2009 10:40:01 +0530
> Subject: [PATCH] x86: Introduce CONFIG_X86_VMWARE option
> 
> Impact: freedom to choose
> 
> Gives freedom to users to select or suppress CONFIG_X86_VMWARE option.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/Kconfig                  |    7 +++++++
>  arch/x86/include/asm/hypervisor.h |    9 +++++++++
>  arch/x86/kernel/cpu/Makefile      |    2 +-
>  3 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f5d7d29..56e1a9c 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -554,6 +554,13 @@ config HPET_EMULATE_RTC
>  	def_bool y
>  	depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
>  
> +config X86_VMWARE
> +	bool
> +	default n
> +	prompt "X86 VMware support"
> +	---help---
> +	 Enable X86 VMware Hypervisor support.
> +
>  # Mark as embedded because too many people got it wrong.
>  # The code disables itself when not needed.
>  config DMI
> diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
> index 369f5c5..c08ae75 100644
> --- a/arch/x86/include/asm/hypervisor.h
> +++ b/arch/x86/include/asm/hypervisor.h
> @@ -20,7 +20,16 @@
>  #ifndef ASM_X86__HYPERVISOR_H
>  #define ASM_X86__HYPERVISOR_H
>  
> +#ifdef CONFIG_X86_VMWARE
>  extern unsigned long get_hypervisor_tsc_freq(void);
>  extern void init_hypervisor(struct cpuinfo_x86 *c);
> +#else
> +static inline unsigned long get_hypervisor_tsc_freq(void)
> +{
> +	return 0;
> +}
> +
> +static inline void init_hypervisor(struct cpuinfo_x86 *c) {}
> +#endif
>  
>  #endif
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index 3efcb2b..24372f7 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -9,11 +9,11 @@ endif
>  
>  obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
>  obj-y			+= proc.o capflags.o powerflags.o common.o
> -obj-y			+= vmware.o hypervisor.o
>  
>  obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
>  obj-$(CONFIG_X86_64)	+= bugs_64.o
>  
> +obj-$(CONFIG_X86_VMWARE)		+= vmware.o hypervisor.o
>  obj-$(CONFIG_X86_CPU_DEBUG)		+= cpu_debug.o

vmware can be considered a CPU here, so i think making the disabling 
also depend on PROCESSOR_SELECT.

	Ingo

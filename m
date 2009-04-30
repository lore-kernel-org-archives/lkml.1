Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbZD3PlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbZD3PlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762271AbZD3PlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:41:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36868 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762181AbZD3PlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:41:09 -0400
Date: Thu, 30 Apr 2009 17:40:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tobias Doerffel <tobias.doerffel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
Message-ID: <20090430154051.GA3346@elte.hu>
References: <200904301408.09370.tobias.doerffel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904301408.09370.tobias.doerffel@gmail.com>
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


* Tobias Doerffel <tobias.doerffel@gmail.com> wrote:

> Hi,
> 
> as some of you already might know, work is going on to make GCC 
> fully support Intel Atom architecture specifics, i.e. make 
> -mtune=atom generate code optimized for in-order architectures 
> like Intel Atom [1].
> 
> I therefore started to make up a small patch which adds Intel Atom 
> as a new processor family which can be selected upon 
> configuration. It's nothing special and also requires a patched 
> GCC. I'd just like to get some feedback on it, i.e. is 
> X86_L1_CACHE_SHIFT=6 ok for Atom CPUs (I was not able to find any 
> information on Atom's cacheline size)? Any chance to include this 
> patch once the Atom patch went into GCC mainline (probably in GCC 
> 4.5)? Any other objections?
> 
> Please Cc me, I'm not on the list.
> 
> Regards,
> 
> Tobias
> 
> [1] http://gcc.gnu.org/viewcvs/branches/ix86/atom/
> 
> 

> From 6aa86b4431619d38849d469c70904afe1e5a8ca0 Mon Sep 17 00:00:00 2001
> From: Tobias Doerffel <tobias.doerffel@gmail.com>
> Date: Thu, 30 Apr 2009 12:36:46 +0200
> Subject: [PATCH] x86: add specific support for Intel Atom architecture
> 
> This adds another option when selecting CPU family so the kernel can
> be optimized for Intel Atom CPUs. This patch requires a GCC with a
> patch applied which adds specific Intel Atom support.
> ---
>  arch/x86/Kconfig.cpu          |   19 ++++++++++++++-----
>  arch/x86/Makefile_32.cpu      |    1 +
>  arch/x86/include/asm/module.h |    2 ++
>  3 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
> index 8130334..8e565b7 100644
> --- a/arch/x86/Kconfig.cpu
> +++ b/arch/x86/Kconfig.cpu
> @@ -262,6 +262,15 @@ config MCORE2
>  	  family in /proc/cpuinfo. Newer ones have 6 and older ones 15
>  	  (not a typo)
>  
> +config MATOM
> +	bool "Intel Atom"
> +	depends on X86_32
> +	---help---
> +
> +	  Select this for Intel Atom platform. Intel Atom CPUs have an in-order
> +	  pipelining architecture and thus can benefit from in-order optimized
> +	  code (requires Intel Atom patch in GCC).
> +
>  config GENERIC_CPU
>  	bool "Generic-x86-64"
>  	depends on X86_64
> @@ -310,7 +319,7 @@ config X86_L1_CACHE_SHIFT
>  	default "7" if MPENTIUM4 || MPSC
>  	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
>  	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
> -	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7 || X86_GENERIC || GENERIC_CPU
> +	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
>  
>  config X86_XADD
>  	def_bool y
> @@ -355,11 +364,11 @@ config X86_ALIGNMENT_16
>  
>  config X86_INTEL_USERCOPY
>  	def_bool y
> -	depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX || X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2
> +	depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX || X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2 || MATOM
>  
>  config X86_USE_PPRO_CHECKSUM
>  	def_bool y
> -	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2
> +	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM
>  
>  config X86_USE_3DNOW
>  	def_bool y
> @@ -387,7 +396,7 @@ config X86_P6_NOP
>  
>  config X86_TSC
>  	def_bool y
> -	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
> +	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2 || MATOM) && !X86_NUMAQ) || X86_64
>  
>  config X86_CMPXCHG64
>  	def_bool y
> @@ -397,7 +406,7 @@ config X86_CMPXCHG64
>  # generates cmov.
>  config X86_CMOV
>  	def_bool y
> -	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64)
> +	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM)
>  
>  config X86_MINIMUM_CPU_FAMILY
>  	int
> diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
> index 80177ec..07a11b0 100644
> --- a/arch/x86/Makefile_32.cpu
> +++ b/arch/x86/Makefile_32.cpu
> @@ -33,6 +33,7 @@ cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-f
>  cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
>  cflags-$(CONFIG_MVIAC7)		+= -march=i686
>  cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call tune,core2)
> +cflags-$(CONFIG_MATOM)		+= -march=atom $(call tune,atom)
>  
>  # AMD Elan support
>  cflags-$(CONFIG_X86_ELAN)	+= -march=i486
> diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
> index 47d6274..e959c4a 100644
> --- a/arch/x86/include/asm/module.h
> +++ b/arch/x86/include/asm/module.h
> @@ -28,6 +28,8 @@ struct mod_arch_specific {};
>  #define MODULE_PROC_FAMILY "586MMX "
>  #elif defined CONFIG_MCORE2
>  #define MODULE_PROC_FAMILY "CORE2 "
> +#elif defined CONFIG_MATOM
> +#define MODULE_PROC_FAMILY "ATOM "
>  #elif defined CONFIG_M686
>  #define MODULE_PROC_FAMILY "686 "
>  #elif defined CONFIG_MPENTIUMII

Makes sense. One question would be X86_L1_CACHE_SHIFT - you set it 
to 2^6 == 64 - that's correct i think, most Atoms come with 64 byte 
L2 cache AFAIK.

I've Cc:-ed Intel folks - is this assumption about 64 bytes correct?

	Ingo

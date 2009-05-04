Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbZEDHW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbZEDHW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 03:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZEDHWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 03:22:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57894 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbZEDHWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 03:22:49 -0400
To: Tobias Doerffel <tobias.doerffel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
From: Andi Kleen <andi@firstfloor.org>
References: <200904301408.09370.tobias.doerffel@gmail.com>
Date: Mon, 04 May 2009 09:22:46 +0200
In-Reply-To: <200904301408.09370.tobias.doerffel@gmail.com> (Tobias Doerffel's message of "Thu, 30 Apr 2009 14:08:04 +0200")
Message-ID: <877i0xib7d.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Doerffel <tobias.doerffel@gmail.com> writes:

> Hi,
>
> as some of you already might know, work is going on to make GCC fully support 
> Intel Atom architecture specifics, i.e. make -mtune=atom generate code 
> optimized for in-order architectures like Intel Atom [1].
>
> I therefore started to make up a small patch which adds Intel Atom as a new 
> processor family which can be selected upon configuration. It's nothing 
> special and also requires a patched GCC. I'd just like to get some feedback on 
> it, i.e. is X86_L1_CACHE_SHIFT=6 ok for Atom CPUs (I was not able to find any 
> information on Atom's cacheline size)?

64bytes.

> Any chance to include this patch once 
> the Atom patch went into GCC mainline (probably in GCC 4.5)? Any other 

atom support already went into gcc mainline.

> objections?
>
> Please Cc me, I'm not on the list.

FWIW I have a similar patch, but I haven't submitted it yet due
to lack of benchmark numbers.

Some comments on yours.

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

This is wrong, There are Atom CPUs which support 64bit code too.

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


I don't think that's necessarily a good idea. You would need benchmarks showing
that intel user copy performs better on Atom than the original one. Do you have
some?

>  
>  config X86_USE_PPRO_CHECKSUM
>  	def_bool y
> -	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2
> +	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM

Similar here. Atom is quite different from PPro/K8.

  
>  config X86_USE_3DNOW

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

That needs to be in the 64bit version too.


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

This should be obsolete anyways, you can just uses CORE2. They have compatible ISAs.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

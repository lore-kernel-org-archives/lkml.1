Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYEWNU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYEWNU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756395AbYEWNUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:20:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4559 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755031AbYEWNUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:20:40 -0400
Date: Fri, 23 May 2008 15:13:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com
Subject: Re: [X86] Move the 64-bit Centaur specific parts out of setup_64.c
Message-ID: <20080523131304.GB9245@ucw.cz>
References: <200805221944.m4MJiAGi029848@gelk.kernelslacker.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805221944.m4MJiAGi029848@gelk.kernelslacker.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Create a separate centaur_64.c file in the cpu/ dir for
> the useful parts to live in.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> ---
>  arch/x86/kernel/cpu/Makefile     |    1 +
>  arch/x86/kernel/cpu/centaur_64.c |   28 ++++++++++++++++++++++++++++
>  arch/x86/kernel/setup_64.c       |   29 ++---------------------------
>  3 files changed, 31 insertions(+), 27 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/centaur_64.c
> 
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index b7a1192..c77a1c5 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_X86_32)	+= amd.o
>  obj-$(CONFIG_X86_64)	+= amd_64.o
>  obj-$(CONFIG_X86_32)	+= cyrix.o
>  obj-$(CONFIG_X86_32)	+= centaur.o
> +obj-$(CONFIG_X86_64)	+= centaur_64.o
>  obj-$(CONFIG_X86_32)	+= transmeta.o
>  obj-$(CONFIG_X86_32)	+= intel.o
>  obj-$(CONFIG_X86_64)	+= intel_64.o
> diff --git a/arch/x86/kernel/cpu/centaur_64.c b/arch/x86/kernel/cpu/centaur_64.c
> new file mode 100644
> index 0000000..08e07b5
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/centaur_64.c
> @@ -0,0 +1,28 @@
> +#include <linux/init.h>
> +#include <linux/smp.h>
> +
> +void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
> +{
> +	if (c->x86 == 0x6 && c->x86_model >= 0xf)
> +		set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability);
> +}
> +
> +void __cpuinit init_centaur(struct cpuinfo_x86 *c)
> +{
> +	/* Cache sizes */
> +	unsigned n;
> +
> +	n = c->extended_cpuid_level;
> +	if (n >= 0x80000008) {
> +		unsigned eax = cpuid_eax(0x80000008);
> +		c->x86_virt_bits = (eax >> 8) & 0xff;
> +		c->x86_phys_bits = eax & 0xff;
> +	}
> +
> +	if (c->x86 == 0x6 && c->x86_model >= 0xf) {
> +		c->x86_cache_alignment = c->x86_clflush_size * 2;
> +		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
> +		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
> +	}
> +	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
> +}
> diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
> index b3d25d6..9159f85 100644
> --- a/arch/x86/kernel/setup_64.c
> +++ b/arch/x86/kernel/setup_64.c
> @@ -614,33 +614,6 @@ out:
>  #endif
>  }
>  
> -
> -static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
> -{
> -	if (c->x86 == 0x6 && c->x86_model >= 0xf)
> -		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
> -}
> -
> -static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
> -{
> -	/* Cache sizes */
> -	unsigned n;
> -
> -	n = c->extended_cpuid_level;
> -	if (n >= 0x80000008) {
> -		unsigned eax = cpuid_eax(0x80000008);
> -		c->x86_virt_bits = (eax >> 8) & 0xff;
> -		c->x86_phys_bits = eax & 0xff;
> -	}
> -
> -	if (c->x86 == 0x6 && c->x86_model >= 0xf) {
> -		c->x86_cache_alignment = c->x86_clflush_size * 2;
> -		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
> -		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
> -	}
> -	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
> -}
> -
>  static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)

Are there 64-bit capable centaurs? Wow...
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

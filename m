Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbZCZONT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbZCZONT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZCZONF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:13:05 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:55064 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZCZOND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:13:03 -0400
X-BigFish: VPS-44(zz1432R62a3L98dR936eQ1805M936fK655Ozz1202hzz5a6ciz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KH4A4S-04-HOJ-01
Date: Thu, 26 Mar 2009 15:12:29 +0100
From: Robert Richter <robert.richter@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -tip] x86: unification of cpu/bugs.c
Message-ID: <20090326141228.GT7030@erda.amd.com>
References: <1238068930.2507.1.camel@ht.satnam> <20090326131236.GE3226@erda.amd.com> <1238074955.2507.5.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1238074955.2507.5.camel@ht.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 26 Mar 2009 14:12:29.0904 (UTC) FILETIME=[E6123500:01C9AE1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.03.09 19:12:35, Jaswinder Singh Rajput wrote:
> On Thu, 2009-03-26 at 14:12 +0100, Robert Richter wrote:
> > On 26.03.09 17:32:09, Jaswinder Singh Rajput wrote:
> > > This patch is based on -tip x86/core:
> > > 
> > > From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > Date: Thu, 26 Mar 2009 17:14:38 +0530
> > > Subject: [PATCH] x86: unification of cpu/bugs.c
> > > 
> > > Impact: Unification, cleanup
> > > 
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > ---
> > >  arch/x86/kernel/cpu/Makefile  |    5 +--
> > >  arch/x86/kernel/cpu/bugs.c    |   74 ++++++++++++++++++++++++++--------------
> > >  arch/x86/kernel/cpu/bugs_64.c |   33 ------------------
> > >  3 files changed, 50 insertions(+), 62 deletions(-)
> > >  delete mode 100644 arch/x86/kernel/cpu/bugs_64.c
> > 
> > Jaswinder,
> > 
> > please send separate patches for separate changes (e.g. make separate
> > whitespace changes).
> > 
> 
> Ok I removed cleanup:
> 
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Thu, 26 Mar 2009 17:14:38 +0530
> Subject: [PATCH] x86: unification of cpu/bugs.c
> 
> Impact: unification
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/cpu/Makefile  |    5 +--
>  arch/x86/kernel/cpu/bugs.c    |   52 ++++++++++++++++++++++++++++++++--------
>  arch/x86/kernel/cpu/bugs_64.c |   33 --------------------------
>  3 files changed, 43 insertions(+), 47 deletions(-)
>  delete mode 100644 arch/x86/kernel/cpu/bugs_64.c
> 
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index 4e242f9..90a96ee 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -9,10 +9,9 @@ endif
>  
>  obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
>  obj-y			+= proc.o capflags.o powerflags.o common.o
> -obj-y			+= vmware.o hypervisor.o
> +obj-y			+= vmware.o hypervisor.o bugs.o
>  
> -obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
> -obj-$(CONFIG_X86_64)	+= bugs_64.o
> +obj-$(CONFIG_X86_32)			+= cmpxchg.o
>  
>  obj-$(CONFIG_X86_CPU_DEBUG)		+= cpu_debug.o
>  
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index c8e315f..9be7218 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -6,17 +6,23 @@
>   *        <rreilova@ececs.uc.edu>
>   *	- Channing Corn (tests & fixes),
>   *	- Andrew D. Balsa (code cleanup).
> + *
> + *  Copyright (C) 2000 SuSE
>   */
> -#include <linux/init.h>
> +
>  #include <linux/utsname.h>
> -#include <asm/bugs.h>
> -#include <asm/processor.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +
>  #include <asm/processor-flags.h>
> +#include <asm/alternative.h>
> +#include <asm/processor.h>
> +#include <asm/paravirt.h>
>  #include <asm/i387.h>
> +#include <asm/bugs.h>
>  #include <asm/msr.h>
> -#include <asm/paravirt.h>
> -#include <asm/alternative.h>
>  
> +#ifdef CONFIG_X86_32
>  static int __init no_halt(char *s)
>  {
>  	boot_cpu_data.hlt_works_ok = 0;
> @@ -151,6 +157,22 @@ static void __init check_config(void)
>  #endif
>  }
>  
> +/*
> + * Check various bugs
> + */
> +static void __init check_various_bugs(void)
> +{
> +	check_config();
> +	check_fpu();
> +	check_hlt();
> +	check_popad();
> +
> +	init_utsname()->machine[1] =
> +		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);

Did you evaluate why these functions are 32 bit only? Same applies to
64 bit below. It seems this is not a unification and instead only some
move-around of code.

-Robert

> +}
> +#else /* CONFIG_X86_32 */
> +static inline void __init check_various_bugs(void) {}
> +#endif /* CONFIG_X86_32 */
>  
>  void __init check_bugs(void)
>  {
> @@ -159,11 +181,19 @@ void __init check_bugs(void)
>  	printk("CPU: ");
>  	print_cpu_info(&boot_cpu_data);
>  #endif
> -	check_config();
> -	check_fpu();
> -	check_hlt();
> -	check_popad();
> -	init_utsname()->machine[1] =
> -		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
> +	check_various_bugs();
>  	alternative_instructions();
> +
> +#ifdef CONFIG_X86_64
> +	/*
> +	 * Make sure the first 2MB area is not mapped by huge pages
> +	 * There are typically fixed size MTRRs in there and overlapping
> +	 * MTRRs into large pages causes slow downs.
> +	 *
> +	 * Right now we don't do that with gbpages because there seems
> +	 * very little benefit for that case.
> +	 */
> +	if (!direct_gbpages)
> +		set_memory_4k((unsigned long)__va(0), 1);
> +#endif /* CONFIG_X86_64 */
>  }
> diff --git a/arch/x86/kernel/cpu/bugs_64.c b/arch/x86/kernel/cpu/bugs_64.c
> deleted file mode 100644
> index 9a3ed06..0000000
> --- a/arch/x86/kernel/cpu/bugs_64.c
> +++ /dev/null
> @@ -1,33 +0,0 @@
> -/*
> - *  Copyright (C) 1994  Linus Torvalds
> - *  Copyright (C) 2000  SuSE
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/init.h>
> -#include <asm/alternative.h>
> -#include <asm/bugs.h>
> -#include <asm/processor.h>
> -#include <asm/mtrr.h>
> -#include <asm/cacheflush.h>
> -
> -void __init check_bugs(void)
> -{
> -	identify_boot_cpu();
> -#if !defined(CONFIG_SMP)
> -	printk("CPU: ");
> -	print_cpu_info(&boot_cpu_data);
> -#endif
> -	alternative_instructions();
> -
> -	/*
> -	 * Make sure the first 2MB area is not mapped by huge pages
> -	 * There are typically fixed size MTRRs in there and overlapping
> -	 * MTRRs into large pages causes slow downs.
> -	 *
> -	 * Right now we don't do that with gbpages because there seems
> -	 * very little benefit for that case.
> -	 */
> -	if (!direct_gbpages)
> -		set_memory_4k((unsigned long)__va(0), 1);
> -}
> -- 
> 1.6.0.6
> 
> 
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


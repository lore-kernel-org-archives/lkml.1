Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZINMz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZINMz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbZINMzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:55:23 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:28742
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750891AbZINMzW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:55:22 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1432R98dNzz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KPYP81-03-JZP-01
Date: Mon, 14 Sep 2009 14:55:11 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: hpa@zytor.com
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, msr: unify rdmsr_on_cpus/wrmsr_on_cpus
Message-ID: <20090914125511.GC13615@aftab>
References: <4A7099E8.30003@zytor.com>
 <1248945002-2931-2-git-send-email-borislav.petkov@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1248945002-2931-2-git-send-email-borislav.petkov@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 Sep 2009 12:55:11.0816 (UTC) FILETIME=[989B2480:01CA353A]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

care to pick up the one below too while the merge window is still open?

On Thu, Jul 30, 2009 at 11:10:02AM +0200, Borislav Petkov wrote:
> Since rdmsr_on_cpus and wrmsr_on_cpus are almost identical, unify them
> into a common __rwmsr_on_cpus helper thus avoiding code duplication.
> 
> While at it, convert cpumask_t's to const struct cpumask *.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
> 
> This one is .32 material.
> 
>  arch/x86/include/asm/msr.h |    4 +-
>  arch/x86/lib/msr.c         |   46 ++++++++++++++++++-------------------------
>  2 files changed, 21 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
> index 48ad9d2..f2f4309 100644
> --- a/arch/x86/include/asm/msr.h
> +++ b/arch/x86/include/asm/msr.h
> @@ -224,8 +224,8 @@ do {                                                            \
>  #ifdef CONFIG_SMP
>  int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
>  int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
> -void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
> -void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
> +void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
> +void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
>  int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
>  int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
>  #else  /*  CONFIG_SMP  */
> diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
> index caa24ac..2f26cf4 100644
> --- a/arch/x86/lib/msr.c
> +++ b/arch/x86/lib/msr.c
> @@ -71,14 +71,9 @@ int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
>  }
>  EXPORT_SYMBOL(wrmsr_on_cpu);
>  
> -/* rdmsr on a bunch of CPUs
> - *
> - * @mask:       which CPUs
> - * @msr_no:     which MSR
> - * @msrs:       array of MSR values
> - *
> - */
> -void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
> +static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
> +			    struct msr *msrs,
> +			    void (*msr_func) (void *info))
>  {
>  	struct msr_info rv;
>  	int this_cpu;
> @@ -92,11 +87,23 @@ void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
>  	this_cpu = get_cpu();
>  
>  	if (cpumask_test_cpu(this_cpu, mask))
> -		__rdmsr_on_cpu(&rv);
> +		msr_func(&rv);
>  
> -	smp_call_function_many(mask, __rdmsr_on_cpu, &rv, 1);
> +	smp_call_function_many(mask, msr_func, &rv, 1);
>  	put_cpu();
>  }
> +
> +/* rdmsr on a bunch of CPUs
> + *
> + * @mask:       which CPUs
> + * @msr_no:     which MSR
> + * @msrs:       array of MSR values
> + *
> + */
> +void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
> +{
> +	__rwmsr_on_cpus(mask, msr_no, msrs, __rdmsr_on_cpu);
> +}
>  EXPORT_SYMBOL(rdmsr_on_cpus);
>  
>  /*
> @@ -107,24 +114,9 @@ EXPORT_SYMBOL(rdmsr_on_cpus);
>   * @msrs:       array of MSR values
>   *
>   */
> -void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
> +void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
>  {
> -	struct msr_info rv;
> -	int this_cpu;
> -
> -	memset(&rv, 0, sizeof(rv));
> -
> -	rv.off    = cpumask_first(mask);
> -	rv.msrs   = msrs;
> -	rv.msr_no = msr_no;
> -
> -	this_cpu = get_cpu();
> -
> -	if (cpumask_test_cpu(this_cpu, mask))
> -		__wrmsr_on_cpu(&rv);
> -
> -	smp_call_function_many(mask, __wrmsr_on_cpu, &rv, 1);
> -	put_cpu();
> +	__rwmsr_on_cpus(mask, msr_no, msrs, __wrmsr_on_cpu);
>  }
>  EXPORT_SYMBOL(wrmsr_on_cpus);
>  
> -- 
> 1.6.3.3
> 
> _______________________________________________
> osrc-patches mailing list
> osrc-patches@elbe.amd.com
> https://ddcwww.amd.com/mailman/listinfo/osrc-patches

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


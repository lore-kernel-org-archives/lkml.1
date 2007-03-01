Return-Path: <linux-kernel-owner+w=401wt.eu-S1752352AbXCAH7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbXCAH7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbXCAH7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:59:11 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35317 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbXCAH7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:59:10 -0500
Date: Thu, 1 Mar 2007 13:29:00 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, judith@linux-foundation.org,
       fastboot@lists.osdl.org, ebiederm@xmission.com, ak@suse.de
Subject: Re: [Fastboot] [PATCH 2/5] Use the APIC to determine the hardware processor id -	i386
Message-ID: <20070301075900.GA17405@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <1172733419.1498.269.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1172733419.1498.269.camel@sebastian.intellilink.co.jp>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 04:16:59PM +0900, Fernando Luis Vázquez Cao wrote:
> Use the APIC to determine the hardware processor id when APIC support
> has been selected, independently of whether CONFIG_SMP is set or not.
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.21-rc2/include/asm-i386/smp.h linux-2.6.21-rc2-hwcpuid/include/asm-i386/smp.h
> --- linux-2.6.21-rc2/include/asm-i386/smp.h	2007-03-01 14:02:21.000000000 +0900
> +++ linux-2.6.21-rc2-hwcpuid/include/asm-i386/smp.h	2007-03-01 14:08:50.000000000 +0900
> @@ -74,20 +74,6 @@ static inline int num_booting_cpus(void)
>  	return cpus_weight(cpu_callout_map);
>  }
>  
> -#ifdef CONFIG_X86_LOCAL_APIC
> -
> -#ifdef APIC_DEFINITION
> -extern int hard_smp_processor_id(void);
> -#else
> -#include <mach_apicdef.h>
> -static inline int hard_smp_processor_id(void)
> -{
> -	/* we don't want to mark this access volatile - bad code generation */
> -	return GET_APIC_ID(*(unsigned long *)(APIC_BASE+APIC_ID));
> -}
> -#endif
> -#endif
> -
>  extern int safe_smp_processor_id(void);
>  extern int __cpu_disable(void);
>  extern void __cpu_die(unsigned int cpu);
> @@ -102,10 +88,23 @@ extern unsigned int num_processors;
>  
>  #define NO_PROC_ID		0xFF		/* No processor magic marker */
>  
> -#endif
> +#endif /* CONFIG_SMP */
>  
>  #ifndef __ASSEMBLY__
>  
> +#ifdef CONFIG_X86_LOCAL_APIC
> +#ifdef APIC_DEFINITION
> +extern int hard_smp_processor_id(void);
> +#else
> +#include <mach_apicdef.h>
> +static inline int hard_smp_processor_id(void)
> +{
> +	/* we don't want to mark this access volatile - bad code generation */
> +	return GET_APIC_ID(*(unsigned long *)(APIC_BASE+APIC_ID));
> +}
> +#endif /* APIC_DEFINITION */
> +#endif /* CONFIG_X86_LOCAL_APIC */
> +

I think compilation will fail if CONFIG_X86_LOCAL_APIC=n and I build a UP
kernel? There is no definition of hard_smp_processor_id in that case.

Otherwise, as a concept it seems to make sense that hard_smp_processor_id()
is not necessarily zero on UP systems.

Thanks
Vivek

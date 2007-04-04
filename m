Return-Path: <linux-kernel-owner+w=401wt.eu-S2992777AbXDDJBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992777AbXDDJBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992774AbXDDJBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:01:19 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:51125 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992777AbXDDJBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:01:18 -0400
Subject: Re: [PATCH 3/4] Use the APIC to determine the hardware processor
	id - x86_64
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ak@suse.de, ebiederm@xmission.com,
       horms@verge.net.au, tony.luck@intel.com, vgoyal@in.ibm.com
In-Reply-To: <1175676997.26920.136.camel@sebastian.intellilink.co.jp>
References: <1175676997.26920.136.camel@sebastian.intellilink.co.jp>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Wed, 04 Apr 2007 18:01:16 +0900
Message-Id: <1175677276.1888.3.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 17:56 +0900, Fernando Luis Vázquez Cao wrote:
> hard_smp_processor_id used to be just a macro that hard-coded
> hard_smp_processor_id to 0 in the non SMP case.  When booting non SMP
> kernels on hardware where the boot ioapic id is not 0 this turns out to
> be a problem.  This is happens frequently in the case of kdump and once
> in a great while in the case of real hardware.
> 
> Use the APIC to determine the hardware processor id in both UP and SMP
> kernels to fix this issue.
> 
> Notice that hard_smp_processor_id is only used by SMP code or by code
> that works
> with apics so we do not need to handle the case when apics are not
> present and hard_smp_processor_id should never be called there.
I attached the explanation of the i386 patch here by mistake. Use the
text below instead:

--
Use the APIC to determine the hardware processor id in both UP and SMP
kernels.
--

Thank you.

> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.21-rc5-orig/include/asm-x86_64/smp.h linux-2.6.21-rc5/include/asm-x86_64/smp.h
> --- linux-2.6.21-rc5-orig/include/asm-x86_64/smp.h	2007-04-04 15:57:31.000000000 +0900
> +++ linux-2.6.21-rc5/include/asm-x86_64/smp.h	2007-04-04 16:25:52.000000000 +0900
> @@ -59,12 +59,6 @@ static inline int num_booting_cpus(void)
>  
>  #define raw_smp_processor_id() read_pda(cpunumber)
>  
> -static inline int hard_smp_processor_id(void)
> -{
> -	/* we don't want to mark this access volatile - bad code generation */
> -	return GET_APIC_ID(*(unsigned int *)(APIC_BASE+APIC_ID));
> -}
> -
>  extern int __cpu_disable(void);
>  extern void __cpu_die(unsigned int cpu);
>  extern void prefill_possible_map(void);
> @@ -73,10 +67,14 @@ extern unsigned __cpuinitdata disabled_c
>  
>  #define NO_PROC_ID		0xFF		/* No processor magic marker */
>  
> -#else /* CONFIG_SMP */
> -#define hard_smp_processor_id() 0
>  #endif /* CONFIG_SMP */
>  
> +static inline int hard_smp_processor_id(void)
> +{
> +	/* we don't want to mark this access volatile - bad code generation */
> +	return GET_APIC_ID(*(unsigned int *)(APIC_BASE+APIC_ID));
> +}
> +
>  /*
>   * Some lowlevel functions might want to know about
>   * the real APIC ID <-> CPU # mapping.
> 


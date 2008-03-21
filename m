Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYCUR4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYCUR4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYCUR4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:56:11 -0400
Received: from www.tglx.de ([62.245.132.106]:46582 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbYCUR4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:56:10 -0400
Date: Fri, 21 Mar 2008 18:55:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: andreas.herrmann3@amd.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [6/7] Split large page mapping for AMD TSEG
In-Reply-To: <20080312025332.B5DFC1B41D1@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803211851150.3781@apollo.tec.linutronix.de>
References: <20080312353.598285931@firstfloor.org> <20080312025332.B5DFC1B41D1@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Andi Kleen wrote:
> On AMD SMM protected memory is part of the address map, but handled
> internally like an MTRR. That leads to large pages getting split
> internally which has some performance implications. Check for the
> AMD TSEG MSR and split the large page mapping on that area 
> explicitely if it is part of the direct mapping. 
> 
> There is also SMM ASEG, but it is in the first 1MB and already covered by 
> the earlier split first page patch.
> 
> Idea for this came from an earlier patch by Andreas Herrmann
> 
> On a RevF dual Socket Opteron system kernbench shows a clear
> improvement from this:
> (together with the earlier patches in this series, especially the 
> split first 2MB patch) 
> 
> [lower is better]
>               no split stddev         split  stddev    delta
> Elapsed Time   87.146 (0.727516)     84.296 (1.09098)  -3.2%
> User Time     274.537 (4.05226)     273.692 (3.34344)  -0.3%
> System Time    34.907 (0.42492)      34.508 (0.26832)  -1.1%
> Percent CPU   322.5   (38.3007)     326.5   (44.5128)  +1.2%
> 
> => About 3.2% improvement in elapsed time for kernbench.
> 
> With GB pages on AMD Fam1h the impact of splitting is much higher of course,
> since it would split two full GB pages (together with the first
> 1MB split patch) instead of two 2MB pages.  I could not benchmark
> a clear difference in kernbench on gbpages, so I kept it disabled
> for that case

Hmm. Where is this SMM memory usually located ?
 
> That was only limited benchmarking of course, so if someone
> was interested in running more tests for the gbpages case
> that could be revisited (contributions welcome)
> 
> I didn't bother implementing this for 32bit because it is very
> unlikely the 32bit lowmem mapping overlaps into the TSEG near 4GB
> and the 2MB low split is already handled for both.

Please keep 32bit and 64bit in sync. The setup code has been merged
and we don't want to have needless separation.

Thanks,
	tglx


> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/kernel/setup_64.c  |   13 +++++++++++++
>  include/asm-x86/msr-index.h |    1 +
>  2 files changed, 14 insertions(+)
> 
> Index: linux/arch/x86/kernel/setup_64.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/setup_64.c
> +++ linux/arch/x86/kernel/setup_64.c
> @@ -721,6 +721,20 @@ static void __cpuinit init_amd(struct cp
>  
>  	if (amd_apic_timer_broken())
>  		disable_apic_timer = 1;
> +
> +	if (!direct_gbpages &&
> +		c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
> +		unsigned long tseg;
> +
> +		/*
> +		 * Split up direct mapping around the TSEG SMM area.
> +		 * Don't do it for gbpages because there seems very little
> +		 * benefit in doing so.
> +		 */
> +		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg) &&
> +		(tseg >> PMD_SHIFT) < (end_pfn_map >> (PMD_SHIFT-PAGE_SHIFT)))
> +			set_memory_4k((unsigned long)__va(tseg), 1);
> +	}
>  }
>  
>  void __cpuinit detect_ht(struct cpuinfo_x86 *c)
> Index: linux/include/asm-x86/msr-index.h
> ===================================================================
> --- linux.orig/include/asm-x86/msr-index.h
> +++ linux/include/asm-x86/msr-index.h
> @@ -109,6 +109,7 @@
>  #define MSR_K8_SYSCFG			0xc0010010
>  #define MSR_K8_HWCR			0xc0010015
>  #define MSR_K8_ENABLE_C1E		0xc0010055
> +#define MSR_K8_TSEG_ADDR		0xc0010112
>  #define K8_MTRRFIXRANGE_DRAM_ENABLE	0x00040000 /* MtrrFixDramEn bit    */
>  #define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */
>  #define K8_MTRR_RDMEM_WRMEM_MASK	0x18181818 /* Mask: RdMem|WrMem    */
> 

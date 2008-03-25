Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbYCYL5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbYCYL5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 07:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYCYL5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 07:57:25 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:32874 "EHLO
	outbound1-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753278AbYCYL5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 07:57:24 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JYABUZ-03-J2W-01
Date: Tue, 25 Mar 2008 12:56:59 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [6/7] Split large page mapping for AMD TSEG
Message-ID: <20080325115659.GM17986@amd.com>
References: <20080312353.598285931@firstfloor.org> <20080312025332.B5DFC1B41D1@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312025332.B5DFC1B41D1@basil.firstfloor.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 25 Mar 2008 11:56:59.0926 (UTC) FILETIME=[55098360:01C88E6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 03:53:32AM +0100, Andi Kleen wrote:
> 
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
> 
> That was only limited benchmarking of course, so if someone
> was interested in running more tests for the gbpages case
> that could be revisited (contributions welcome)
> 
> I didn't bother implementing this for 32bit because it is very
> unlikely the 32bit lowmem mapping overlaps into the TSEG near 4GB
> and the 2MB low split is already handled for both.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>


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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


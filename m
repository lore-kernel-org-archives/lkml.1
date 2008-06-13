Return-Path: <linux-kernel-owner+w=401wt.eu-S1761155AbYFMGzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155AbYFMGzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 02:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYFMGzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 02:55:41 -0400
Received: from mail-va3.bigfish.com ([216.32.180.112]:27552 "EHLO
	mail88-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753328AbYFMGzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 02:55:40 -0400
X-BigFish: VPS-31(z34a4nz1432R98dR7efV1805Mzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K2E38H-02-GVH-01
Date: Fri, 13 Jun 2008 08:55:24 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>
Subject: Re: [patch 3/6] x86: use cpuinfo to check for interrupt pending
	message msr
Message-ID: <20080613065524.GE7763@alberich.amd.com>
References: <20080610171639.551369443@linutronix.de> <20080610171712.304283554@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610171712.304283554@linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Jun 2008 06:55:26.0731 (UTC) FILETIME=[75B30DB0:01C8CD22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 10:28:47AM -0000, Thomas Gleixner wrote:
> No need to do a cpuid(1) again. The cpuinfo structure has all
> necessary information already.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
> 
> ---
>  arch/x86/kernel/cpu/amd.c  |   41 +++++++++++++++--------------------------
>  arch/x86/kernel/setup_64.c |   38 +++++++++++++++-----------------------
>  2 files changed, 30 insertions(+), 49 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/cpu/amd.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
> +++ linux-2.6/arch/x86/kernel/cpu/amd.c
> @@ -25,35 +25,24 @@ extern void vide(void);
>  __asm__(".align 4\nvide: ret");
>  
>  #ifdef CONFIG_X86_LOCAL_APIC
> -#define CPUID_PROCESSOR_SIGNATURE       1
> -#define CPUID_XFAM              0x0ff00000
> -#define CPUID_XFAM_K8           0x00000000
> -#define CPUID_XFAM_10H          0x00100000
> -#define CPUID_XFAM_11H          0x00200000
> -#define CPUID_XMOD              0x000f0000
> -#define CPUID_XMOD_REV_F        0x00040000
>  
>  /* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
> -static __cpuinit int amd_apic_timer_broken(void)
> +static __cpuinit int amd_apic_timer_broken(struct cpuinfo_x86 *c)
>  {
>  	u32 lo, hi;
> -	u32 eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
> -	switch (eax & CPUID_XFAM) {
> -	case CPUID_XFAM_K8:
> -		if ((eax & CPUID_XMOD) < CPUID_XMOD_REV_F)
> -			break;
> -	case CPUID_XFAM_10H:
> -	case CPUID_XFAM_11H:
> -		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
> -		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
> -			if (smp_processor_id() != boot_cpu_physical_apicid)
> -				printk(KERN_INFO "AMD C1E detected late. "
> -				       "	Force timer broadcast.\n");
> -			return 1;
> -		}
> -		break;
> -	default:
> -		/* err on the side of caution */
> +
> +	if (c->x86 < 0x0F)
> +		return 0;
> +
> +	/* Family 0x0f models < rev F do not have this MSR */
> +	if (c->x86 == 0x0f && c->x86_model < 0x40)
> +		return 0;

Just some minor nitpicking.
Older AMD family 0xf CPUs have this Interrupt Pending Message
Register. But they do not support C1E and thus bits 27 and 28 of this
MSR are reserved.


Andreas



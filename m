Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZKHKZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZKHKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 05:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbZKHKZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 05:25:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52754 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbZKHKZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 05:25:26 -0500
Date: Sun, 8 Nov 2009 11:25:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yong Wang <yong.y.wang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, therm: Only read the initial value of thermal LVT
 entry on BSP
Message-ID: <20091108102520.GC7233@elte.hu>
References: <20091107001736.GA30790@ywang-moblin2.bj.intel.com>
 <1257562565.4083.485.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257562565.4083.485.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Fri, 2009-11-06 at 16:17 -0800, Yong Wang wrote:
> > Only read the initial value of thermal LVT entry on BSP. The initial
> > value of thermal LVT entries on all APs always reads 0x10000 because
> > APs are woken up by BSP issuing INIT-SIPI-SIPI sequence to them and
> > LVT registers are reset to 0s except for mask bits which are set to
> > 1s when APs receive INIT IPI.
> > 
> > Also restore the value that BIOS has programmed on AP based on BSP's
> > info we saved since BIOS is always setting the same value for all
> > threads/cores.
> 
> Yong, I have appended a new patch with an enhanced change log and
> subject. In future, when you modify and post another version of the
> patch, can you please update the patch version and elaborate what has
> changed, why etc, so that it will be easier for the reviewers.
> 
> Ingo/Peter, please review and queue this patch from Yong. Thanks.
> ---
> 
> From: Yong Wang <yong.y.wang@intel.com>
> Subject: x86: under bios control, restore AP's APIC_LVTTHMR to the BSP value
> 
> On platforms where bios handles the thermal monitor interrupt,
> APIC_LVTTHMR on each logical CPU is programmed to generate a SMI and OS
> can't touch it.
> 
> Unfortunately AP bringup sequence using INIT-SIPI-SIPI clear all
> the LVT entries except the mask bit. Essentially this results in
> all LVT entries including the thermal monitoring interrupt set to masked
> (clearing the bios programmed value for APIC_LVTTHMR).
> 
> And this leads to kernel take over the thermal monitoring interrupt
> on AP's but not on BSP (leaving the bios programmed value only on BSP).
> 
> As a result of this, we have seen system hangs when the thermal
> monitoring interrupt is generated.
> 
> Fix this by reading the initial value of thermal LVT entry on BSP
> and if bios has taken over the control, then program the same value
> on all AP's and leave the thermal monitoring interrupt control
> on all the logical cpu's to the bios.
> 
> Signed-off-by: Yong Wang <yong.y.wang@intel.com>
> Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: stable@kernel.org
> ---
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index b3a1dba..1fd42db 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -259,6 +259,7 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
>  	unsigned int cpu = smp_processor_id();
>  	int tm2 = 0;
>  	u32 l, h;
> +	static u32 lvtthmr;
>  
>  	/* Thermal monitoring depends on ACPI and clock modulation*/
>  	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
> @@ -270,7 +271,24 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
>  	 * since it might be delivered via SMI already:
>  	 */
>  	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
> -	h = apic_read(APIC_LVTTHMR);
> +
> +	/*
> +	 * Only read the initial value of thermal LVT entry on BSP. The
> +	 * initial value of thermal LVT entries on all APs always reads
> +	 * 0x10000 because APs are woken up by BSP issuing INIT-SIPI-SIPI
> +	 * sequence to them and LVT registers are reset to 0s except for
> +	 * the mask bits which are set to 1s when APs receive INIT IPI.
> +	 * Also restore the value that BIOS has programmed on AP based on
> +	 * BSP's info we saved since BIOS is always setting the same value
> +	 * for all threads/cores
> +	 */
> +	if (cpu == 0)
> +		lvtthmr = apic_read(APIC_LVTTHMR);
> +	else
> +		apic_write(APIC_LVTTHMR, lvtthmr);
> +
> +	h = lvtthmr;
> +

i dont disagree with the fix, but could we please do it a bit cleaner, 
and initialize a proper file-scope lvtthrm_init value from a different 
boot-CPU-only function? (not intel_init_thermal)

that makes it cleaner, and also it will work if we dont boot on cpu==0. 
(should that ever occur)

Thanks,

	Ingo


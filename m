Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbYDXGFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbYDXGFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 02:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYDXGFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 02:05:22 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:39636 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYDXGFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 02:05:20 -0400
Message-ID: <4810231B.6020105@linux.vnet.ibm.com>
Date: Thu, 24 Apr 2008 11:35:15 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: kernel list <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, nacc@us.ibm.com
Subject: Re: [BUG] 2.6.25-rc2-git4 - Regression Kernel oops  while running
 kernbench and tbench on powerpc
References: <47BC40BC.3040405@linux.vnet.ibm.com> <18427.11023.8067.795279@cargo.ozlabs.ibm.com> <47FB5C5A.5020104@linux.vnet.ibm.com> <18427.65299.403151.344959@cargo.ozlabs.ibm.com> <47FC5227.3030501@linux.vnet.ibm.com> <18435.11286.201115.396713@cargo.ozlabs.ibm.com> <48035C03.10104@linux.vnet.ibm.com> <18446.61538.620549.715043@cargo.ozlabs.ibm.com>
In-Reply-To: <18446.61538.620549.715043@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Kamalesh Babulal writes:
> 
>> After applying the patch above and the patch posted on
>> http://lkml.org/lkml/2008/4/8/42
>> the bug had the following information,
> 
> Thanks.  The patch below, against Linus' current git tree, fixes one
> bug that might be the cause of the problem, and also attempts to
> detect the erroneous situation earlier and fix it up, and also print
> some debug information.  Please try to reproduce the problem with this
> patch applied, and if there are any console log messages starting with
> SLB: or FWNMI:, please send me the console log.
> 
> Paul.
> 
> diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
> index c0db5b7..f7f0962 100644
> --- a/arch/powerpc/kernel/entry_64.S
> +++ b/arch/powerpc/kernel/entry_64.S
> @@ -439,6 +439,19 @@ END_FTR_SECTION_IFSET(CPU_FTR_1T_SEGMENT)
>  	mr	r1,r8		/* start using new stack pointer */
>  	std	r7,PACAKSAVE(r13)
> 
> +	/* check that SLB entry 2 contains the right thing */
> +	clrrdi	r6,r1,28
> +	clrldi.	r0,r6,2
> +	beq	3f
> +	li	r0,2
> +	slbmfee	r7,r0
> +	oris	r6,r6,SLB_ESID_V@h
> +	cmpd	r6,r7
> +	beq	3f
> +	bl	bad_slb_switch
> +	ld	r3,PACACURRENT(r13)
> +	addi	r3,r3,THREAD
> +3:
>  	ld	r6,_CCR(r1)
>  	mtcrf	0xFF,r6
> 
> @@ -540,6 +553,19 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_ISERIES)
>  	ld	r4,_XER(r1)
>  	mtspr	SPRN_XER,r4
> 
> +	/* check that SLB entry 2 contains the right thing */
> +	clrrdi	r6,r1,28	/* stack ESID */
> +	clrldi.	r0,r6,2
> +	beq	57f
> +	li	r0,2
> +	slbmfee	r7,r0
> +	oris	r6,r6,SLB_ESID_V@h
> +	cmpd	r6,r7
> +	beq	57f
> +	addi	r3,r1,STACK_FRAME_OVERHEAD
> +	bl	bad_slb_exc
> +	ld	r3,_MSR(r1)
> +57:
>  	REST_8GPRS(5, r1)
> 
>  	andi.	r0,r3,MSR_RI
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index be35ffa..c938134 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -45,6 +45,7 @@
>  #include <asm/system.h>
>  #include <asm/mpic.h>
>  #include <asm/vdso_datapage.h>
> +#include <asm/mmu.h>
>  #ifdef CONFIG_PPC64
>  #include <asm/paca.h>
>  #endif
> @@ -580,6 +581,10 @@ int __devinit start_secondary(void *unused)
>  	atomic_inc(&init_mm.mm_count);
>  	current->active_mm = &init_mm;
> 
> +	/* Bolt in the entry for the kernel stack now */
> +	if (cpu_has_feature(CPU_FTR_SLB))
> +		slb_flush_and_rebolt();
> +
>  	smp_store_cpu_info(cpu);
>  	set_dec(tb_ticks_per_jiffy);
>  	preempt_disable();
> diff --git a/arch/powerpc/mm/slb.c b/arch/powerpc/mm/slb.c
> index 906daed..bb7765b 100644
> --- a/arch/powerpc/mm/slb.c
> +++ b/arch/powerpc/mm/slb.c
> @@ -309,3 +309,34 @@ void slb_initialize(void)
>  	 * one. */
>  	asm volatile("isync":::"memory");
>  }
> +
> +static void dump_slb(void)
> +{
> +	long entry;
> +	unsigned long esid, vsid;
> +
> +	printk(KERN_EMERG "SLB contents now:\n");
> +	for (entry = 0; entry < 64; ++entry) {
> +		asm volatile("slbmfee  %0,%1" : "=r" (esid) : "r" (entry));
> +		if (esid == 0)
> +			/* valid bit is clear along with everything else */
> +			continue;
> +		asm volatile("slbmfev  %0,%1" : "=r" (vsid) : "r" (entry));
> +		printk(KERN_EMERG "%d: %.16lx %.16lx\n", entry, esid, vsid);
> +	}
> +}
> +
> +void bad_slb_exc(struct pt_regs *regs)
> +{
> +	printk(KERN_EMERG "SLB: stack not bolted on exception return\n");
> +	dump_slb();
> +	slb_flush_and_rebolt();
> +	show_regs(regs);
> +}
> +
> +void bad_slb_switch(void)
> +{
> +	printk(KERN_EMERG "SLB: stack not bolted on context switch\n");
> +	dump_slb();
> +	slb_flush_and_rebolt();
> +}
> diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
> index a1ab25c..ed68083 100644
> --- a/arch/powerpc/platforms/pseries/ras.c
> +++ b/arch/powerpc/platforms/pseries/ras.c
> @@ -325,6 +325,8 @@ static int recover_mce(struct pt_regs *regs, struct rtas_error_log * err)
> 
>  	if (err->disposition == RTAS_DISP_FULLY_RECOVERED) {
>  		/* Platform corrected itself */
> +		printk(KERN_ALERT "FWNMI: platform corrected error %.16lx\n",
> +		       *(unsigned long *)err);
>  		nonfatal = 1;
>  	} else if ((regs->msr & MSR_RI) &&
>  		   user_mode(regs) &&

Hi Paul,

Thanks, after applying the patch the oops is not reproducible on the machine. The console
log had no message starting with SLB: or FWNMI:. I have updated the bugzilla also.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

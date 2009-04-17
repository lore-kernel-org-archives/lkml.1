Return-Path: <linux-kernel-owner+w=401wt.eu-S1760768AbZDQLYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768AbZDQLYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 07:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbZDQLYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 07:24:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50517 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbZDQLYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 07:24:16 -0400
Message-ID: <49E866C7.4080707@jp.fujitsu.com>
Date: Fri, 17 Apr 2009 20:23:51 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [14/28] x86: MCE: Add MSR read wrappers for easier error
 injection
References: <20090407507.636692542@firstfloor.org> <20090407150756.23F221D046E@basil.firstfloor.org>
In-Reply-To: <20090407150756.23F221D046E@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> This will be used by future patches to allow machine check error injection.
> Right now it's a nop, except for adding some wrappers around the MSR reads.
> 
> This is early in the sequence to avoid too many conflicts.
> 
> Andi Kleen <ak@linux.intel.com>
> 
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  arch/x86/kernel/cpu/mcheck/mce_64.c |   37 ++++++++++++++++++++++++------------
>  1 file changed, 25 insertions(+), 12 deletions(-)
> 
> Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
> +++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:12.000000000 +0200
> @@ -171,6 +171,19 @@
>  	panic(msg);
>  }

Since you introduce X86_MCE_INJECT in later patch,
how about this style?

#ifdef CONFIG_X86_MCE_INJECT
#define mce_rdmsrl(msr,v) (v) = __mce_rdmsrl((msr))
#define mce_wrmsrl(msr,v) __mce_wrmsrl((msr),(v))
static u64 __mce_rdmsrl(u32 msr)
{
 ...
}
static void __mce_wrmsrl(u32 msr, u64 v)
{
 ...
}
#else
#define mce_rdmsrl(msr,v) rdmsrl((msr),(v))
#define mce_wrmsrl(msr,v) wrmsrl((msr),(v)) 
#endif /* CONFIG_X86_MCE_INJECT */


Thanks,
H.Seto

>  
> +/* MSR access wrappers used for error injection */
> +static u64 mce_rdmsrl(u32 msr)
> +{
> +	u64 v;
> +	rdmsrl(msr, v);
> +	return v;
> +}
> +
> +static void mce_wrmsrl(u32 msr, u64 v)
> +{
> +	wrmsrl(msr, v);
> +}
> +
>  int mce_available(struct cpuinfo_x86 *c)
>  {
>  	if (mce_dont_init)
> @@ -188,7 +201,7 @@
>  		m->cs = 0;
>  	}
>  	if (rip_msr)
> -		rdmsrl(rip_msr, m->ip);
> +		m->ip = mce_rdmsrl(rip_msr);
>  }
>  
>  /*
> @@ -250,7 +263,7 @@
>  
>  	mce_setup(&m);
>  
> -	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
> +	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
>  	for (i = 0; i < banks; i++) {
>  		if (!bank[i] || !test_bit(i, *b))
>  			continue;
> @@ -261,7 +274,7 @@
>  		m.tsc = 0;
>  
>  		barrier();
> -		rdmsrl(MSR_IA32_MC0_STATUS + i*4, m.status);
> +		m.status = mce_rdmsrl(MSR_IA32_MC0_STATUS + i*4);
>  		if (!(m.status & MCI_STATUS_VAL))
>  			continue;
>  
> @@ -276,9 +289,9 @@
>  			continue;
>  
>  		if (m.status & MCI_STATUS_MISCV)
> -			rdmsrl(MSR_IA32_MC0_MISC + i*4, m.misc);
> +			m.misc = mce_rdmsrl(MSR_IA32_MC0_MISC + i*4);
>  		if (m.status & MCI_STATUS_ADDRV)
> -			rdmsrl(MSR_IA32_MC0_ADDR + i*4, m.addr);
> +			m.addr = mce_rdmsrl(MSR_IA32_MC0_ADDR + i*4);
>  
>  		if (!(flags & MCP_TIMESTAMP))
>  			m.tsc = 0;
> @@ -294,7 +307,7 @@
>  		/*
>  		 * Clear state for this bank.
>  		 */
> -		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
> +		mce_wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
>  	}
>  
>  	/*
> @@ -342,8 +355,8 @@
>  		goto out;
>  
>  	mce_setup(&m);
> +	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
>  
> -	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
>  	/* if the restart IP is not valid, we're done for */
>  	if (!(m.mcgstatus & MCG_STATUS_RIPV))
>  		no_way_out = 1;
> @@ -360,7 +373,7 @@
>  		m.addr = 0;
>  		m.bank = i;
>  
> -		rdmsrl(MSR_IA32_MC0_STATUS + i*4, m.status);
> +		m.status = mce_rdmsrl(MSR_IA32_MC0_STATUS + i*4);
>  		if ((m.status & MCI_STATUS_VAL) == 0)
>  			continue;
>  
> @@ -400,9 +413,9 @@
>  		}
>  
>  		if (m.status & MCI_STATUS_MISCV)
> -			rdmsrl(MSR_IA32_MC0_MISC + i*4, m.misc);
> +			m.misc = mce_rdmsrl(MSR_IA32_MC0_MISC + i*4);
>  		if (m.status & MCI_STATUS_ADDRV)
> -			rdmsrl(MSR_IA32_MC0_ADDR + i*4, m.addr);
> +			m.addr = mce_rdmsrl(MSR_IA32_MC0_ADDR + i*4);
>  
>  		mce_get_rip(&m, regs);
>  		mce_log(&m);
> @@ -467,9 +480,9 @@
>  	/* the last thing we do is clear state */
>  	for (i = 0; i < banks; i++) {
>  		if (test_bit(i, toclear))
> -			wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
> +			mce_wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
>  	}
> -	wrmsrl(MSR_IA32_MCG_STATUS, 0);
> +	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
>  out:
>  	atomic_dec(&mce_entry);
>  	sync_core();
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


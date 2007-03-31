Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbXCaILH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbXCaILH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXCaILH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:11:07 -0400
Received: from gw.goop.org ([64.81.55.164]:34983 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbXCaILF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:11:05 -0400
Message-ID: <460E1796.2070607@goop.org>
Date: Sat, 31 Mar 2007 01:11:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] VMI paravirt-ops bugfix for 2.6.21
References: <460E1FC7.5030107@vmware.com>
In-Reply-To: <460E1FC7.5030107@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Critical bugfix; when using software RAID, potentially USB or AIO in
> highmem configurations, drivers are allowed to use kmap_atomic from
> interrupt context.  This is incompatible with the current implementation
> of lazy MMU mode, and means the kmap will silently fail, causing either
> memory corruption or kernel panics.  This bug is only visible with >970
> megs of RAM and extreme memory pressure, but nontheless extremely serious.
>   

Why's that?  Don't some things get preferentially allocated out of highmem?

> The fix is to disable interrupts on the CPU when entering a lazy MMU
> state; this is totally safe, as preemption is already disabled, and
> lazy update state can neither be nested nor overlapping.  Thus per-cpu
> variables to track the state and flags can be used to disable interrupts
> during this critical region.
>
> Signed-off-by: Zachary Amsden <zach@vmware.com>
>
> diff -r be8c61492e28 arch/i386/kernel/vmi.c
> --- a/arch/i386/kernel/vmi.c	Fri Mar 30 14:13:45 2007 -0700
> +++ b/arch/i386/kernel/vmi.c	Fri Mar 30 14:18:16 2007 -0700
> @@ -69,6 +69,7 @@ struct {
>  	void (*flush_tlb)(int);
>  	void (*set_initial_ap_state)(int, int);
>  	void (*halt)(void);
> + 	void (*set_lazy_mode)(int mode);
>  } vmi_ops;
>  
>  /* XXX move this to alternative.h */
> @@ -574,6 +575,31 @@ vmi_startup_ipi_hook(int phys_apicid, un
>  }
>  #endif
>  
> +static void vmi_set_lazy_mode(int new_mode)
> +{
> +	static DEFINE_PER_CPU(int, mode);
> +	static DEFINE_PER_CPU(unsigned long, flags);
> +	int cpu = smp_processor_id();
> +
> +	if (!vmi_ops.set_lazy_mode)
> +		return;
> +
> +	/*
> +	 * Modes do not nest or overlap, so we can simply disable
> +	 * irqs when entering a mode and re-enable when leaving.
> +	 */
> +	BUG_ON(per_cpu(mode, cpu) && new_mode);
> +	BUG_ON(!new_mode && !per_cpu(mode, cpu));
>   

It's probably better to use __get_cpu_var() rather than per_cpu(X,
smp_processor_id());  It's a real pity there's no ^^ operator...

> +	
> +	if (new_mode)
> +		local_irq_save(per_cpu(flags, cpu));
> +	else
> +		local_irq_restore(per_cpu(flags, cpu));
>   

The comment only talks about disabling interrupts for lazy_mmu, but this
seems to do it for lazy_cpu as well.  Is that OK?  What happens if
someone wants to change interrupt states under lazy_cpu; I can't think
of an inherent reason why that wouldn't be allowed (though I don't think
it happens now).

This kind of logic is a bit clunky anyway; would it be better to simply
have separate enable/disable functions?  Or at least separate functions
per mode?

Anyway,

Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

    J

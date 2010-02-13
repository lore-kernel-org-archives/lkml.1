Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0BMMEV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 07:04:21 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:42035 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab0BMMEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 07:04:20 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical flat clean up
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 13 Feb 2010 04:04:10 -0800
In-Reply-To: <4B7676BB.8030608@kernel.org> (Yinghai Lu's message of "Sat\, 13 Feb 2010 01\:54\:03 -0800")
Message-ID: <m1ljexpcjp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 02/12/2010 07:44 PM, Eric W. Biederman wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>> 
>>> ---------spareirq radix tree related ----------------
>>> 94007e8: irq: remove not need bootmem code
>>> 4b0d3fa: radix: move radix init early
>>> 56af1a9: sparseirq: change irq_desc_ptrs to static
>>> b236235: sparseirq: use radix_tree instead of ptrs array
>>> 5918787: x86: remove arch_probe_nr_irqs
>>>
>>> so could reduce nr_irqs limitation for bunch ixgbe...
>>>
>>> ---------------x86 logical flat related -----------
>>> f5954c4: use nr_cpus= to set nr_cpu_ids early
>>> 7b8d6a9: x86: use num_processors for possible cpus
>>> d79d1de: x86: make 32bit apic flat to physflat switch like 64bit
>> 
>> Thanks for keeping this work alive.
>> 
>> I just skimmed through do_IRQ and I happened to notice that
>> we have an unnecessary inefficiency that using a radix tree for
>> irq_to_desc will magnify.
>> 
>> handle_irq should take an struct irq_desc * instead of a unsigned int irq.
>> 
>> and the per cpu vector_irq array should become a per cpu vector_desc array.
>> 
>> As soon as irq_to_desc is more than &irq_desc[irq] this saves us work
>> and cache line misses  at the cost of a simple code cleanup.
>> 
>
> please check
>
> Subject: [PATCH] x86: use vector_desc instead of vector_irq
>
> Eric pointed out that radix tree version of irq_to_desc will magnify delay on the path
> of handle_irq.
> use vector_desc to reduce the calling of irq_to_desc.
>
> next step: need to change all ack, mask, umask, eoi for all irq_chip to take irq_desc
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>  
>  #ifdef CONFIG_X86_LOCAL_APIC
> Index: linux-2.6/arch/x86/lguest/boot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/lguest/boot.c
> +++ linux-2.6/arch/x86/lguest/boot.c
> @@ -819,7 +819,7 @@ static void __init lguest_init_IRQ(void)
>  
>  	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
>  		/* Some systems map "vectors" to interrupts weirdly.  Not us! */
> -		__get_cpu_var(vector_irq)[i] = i - FIRST_EXTERNAL_VECTOR;
> +		__get_cpu_var(vector_desc)[i] = irq_to_desc(i - FIRST_EXTERNAL_VECTOR);
>  		if (i != SYSCALL_VECTOR)
>  			set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
>  	}

YH It appears that irq_to_desc_alloc_node has not been called yet
so the setting of vector_desc needs to move to lguest_setup_irq.

Eric




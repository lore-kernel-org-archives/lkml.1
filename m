Return-Path: <linux-kernel-owner+w=401wt.eu-S1946459AbXBCOcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946459AbXBCOcN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 09:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946463AbXBCOcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 09:32:13 -0500
Received: from vsmtp12.tin.it ([212.216.176.206]:46219 "EHLO vsmtp12.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946459AbXBCOcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 09:32:12 -0500
Date: Sat, 3 Feb 2007 15:31:34 +0100 (CET)
From: l.genoni@oltrelinux.com
X-X-Sender: venom@Phoenix.oltrelinux.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, "Lu, Yinghai" <yinghai.lu@amd.com>,
       Luigi Genoni <luigi.genoni@pirelli.com>, Ingo Molnar <mingo@elte.hu>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       l.genoni@sns.it
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq
 migration.
In-Reply-To: <m1d54r3cbk.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0702031528550.10108@Phoenix.oltrelinux.com>
References: <200701221116.13154.luigi.genoni@pirelli.com>
 <200702021848.55921.luigi.genoni@pirelli.com> <m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
 <200702021905.39922.luigi.genoni@pirelli.com> <m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
 <m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com> <20070202170500.57b6c3a3.akpm@linux-foundation.org>
 <1170487929.3073.988.camel@laptopd505.fenrus.org> <m1d54r3cbk.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As I reported when I tested this patch, it works, but I could see an 
abnormally high load averay while triggering the error message. anyway, it 
is better to have an high load averag three or four times higher than what 
you would expect then a crash/reboot. isn't it? :)

Luigi Genoni

p.s.
will test the other definitive patch on montday on both 8 and 16 CPU 
system.

On Sat, 3 Feb 2007, Eric W. Biederman wrote:

> Date: Sat, 03 Feb 2007 00:55:11 -0700
> From: Eric W. Biederman <ebiederm@xmission.com>
> To: Arjan van de Ven <arjan@infradead.org>
> Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
>     "Lu, Yinghai" <yinghai.lu@amd.com>,
>     Luigi Genoni <luigi.genoni@pirelli.com>, Ingo Molnar <mingo@elte.hu>,
>     Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
> Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq
>     migration.
> Resent-Date: Sat, 03 Feb 2007 09:05:10 +0100
> Resent-From: <l.genoni@sns.it>
> 
> Arjan van de Ven <arjan@infradead.org> writes:
>
>>>> Once the migration operation is complete we know we will receive
>>>> no more interrupts on this vector so the irq pending state for
>>>> this irq will no longer be updated.  If the irq is not pending and
>>>> we are in the intermediate state we immediately free the vector,
>>>> otherwise in we free the vector in do_IRQ when the pending irq
>>>> arrives.
>>>
>>> So is this a for-2.6.20 thing?  The bug was present in 2.6.19, so
>>> I assume it doesn't affect many people?
>>
>> I got a few reports of this; irqbalance may trigger this kernel bug it
>> seems... I would suggest to consider this for 2.6.20 since it's a
>> hard-hang case
>
>
> Yes.  The bug I fixed will not happen if you don't migrate irqs.
>
> At the very least we want the patch below (already in -mm)
> that makes it not a hard hang case.
>
> Subject: [PATCH] x86_64:  Survive having no irq mapping for a vector
>
> Occasionally the kernel has bugs that result in no irq being
> found for a given cpu vector.  If we acknowledge the irq
> the system has a good chance of continuing even though we dropped
> an missed an irq message.  If we continue to simply print a
> message and drop and not acknowledge the irq the system is
> likely to become non-responsive shortly there after.
>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
> arch/x86_64/kernel/irq.c |   11 ++++++++---
> 1 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86_64/kernel/irq.c b/arch/x86_64/kernel/irq.c
> index 0c06af6..648055a 100644
> --- a/arch/x86_64/kernel/irq.c
> +++ b/arch/x86_64/kernel/irq.c
> @@ -120,9 +120,14 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
>
> 	if (likely(irq < NR_IRQS))
> 		generic_handle_irq(irq);
> -	else if (printk_ratelimit())
> -		printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",
> -			__func__, smp_processor_id(), vector);
> +	else {
> +		if (!disable_apic)
> +			ack_APIC_irq();
> +
> +		if (printk_ratelimit())
> +			printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",
> +				__func__, smp_processor_id(), vector);
> +	}
>
> 	irq_exit();
>
> -- 
> 1.4.4.1.g278f
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

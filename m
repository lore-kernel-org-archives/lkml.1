Return-Path: <linux-kernel-owner+w=401wt.eu-S934741AbXJSRbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934741AbXJSRbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762751AbXJSRbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:31:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50124 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957AbXJSRbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:31:41 -0400
Message-ID: <4718E9F8.2000606@garzik.org>
Date: Fri, 19 Oct 2007 13:31:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Re: [PATCH 2/9] irq-remove: arch non-trivial
References: <20071019075443.GA6407@havoc.gtf.org> <20071019075543.GC6407@havoc.gtf.org> <4718E134.70101@goop.org>
In-Reply-To: <4718E134.70101@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Jeff Garzik wrote:
>> commit 8d45690dd90b18daaa21b981ab20caf393220bf0
>> Author: Jeff Garzik <jeff@garzik.org>
>> Date:   Fri Oct 19 00:46:23 2007 -0400
>>
>>     [IRQ ARG REMOVAL] various non-trivial arch updates
>>
>>  arch/x86/kernel/vm86_32.c     |    3 ++-
>>  include/asm-x86/irq_regs_32.h |   25 +++++++++++++++++++++++++
>>  2 files changed, 27 insertions(+), 1 deletion(-)
>>
>> 8d45690dd90b18daaa21b981ab20caf393220bf0
>> diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
>> index 157e4be..18aae9e 100644
>> --- a/arch/x86/kernel/vm86_32.c
>> +++ b/arch/x86/kernel/vm86_32.c
>> @@ -739,10 +739,11 @@ static int irqbits;
>>  	| (1 << SIGUSR1) | (1 << SIGUSR2) | (1 << SIGIO)  | (1 << SIGURG) \
>>  	| (1 << SIGUNUSED) )
>>  	
>> -static irqreturn_t irq_handler(int intno, void *dev_id)
>> +static irqreturn_t irq_handler(void *dev_id)
>>  {
>>  	int irq_bit;
>>  	unsigned long flags;
>> +	unsigned int intno = get_irqfunc_irq();
>>  
>>  	spin_lock_irqsave(&irqbits_lock, flags);	
>>  	irq_bit = 1 << intno;
>> diff --git a/include/asm-x86/irq_regs_32.h b/include/asm-x86/irq_regs_32.h
>> index 3368b20..68a531d 100644
>> --- a/include/asm-x86/irq_regs_32.h
>> +++ b/include/asm-x86/irq_regs_32.h
>> @@ -26,4 +26,29 @@ static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
>>  	return old_regs;
>>  }
>>  
>> +DECLARE_PER_CPU(unsigned int, __irqfunc_irqs);
>> +
>> +static inline unsigned int get_irqfunc_irq(void)
>> +{
>> +	return __get_cpu_var(__irqfunc_irqs);
>> +}
>> +
>> +#if 0
>> +static inline unsigned int set_irqfunc_irq(unsigned int new_irq)
>> +{
>> +	unsigned int old_irq, *pirq = &__get_cpu_var(__irqfunc_irqs);
>> +
>> +	old_irq = *pirq;
>> +	*pirq = new_irq;
>> +	return old_irq;
>> +}
>> +#else
>> +static inline void set_irqfunc_irq(unsigned int new_irq)
>> +{
>> +	int *pirq = &__get_cpu_var(__irqfunc_irqs);
>> +
>> +	*pirq = new_irq;
>>   
> 
> x86_write_percpu(__irqfunc_irqs, new_irq) would be slightly more
> efficient here.  Any why the pointer anyway?

Why the pointer?  Honestly, I cannot recall.  Its most likely due to my 
ignorance of the per-cpu API, which always seemed more complicated than 
I wished :)

This code was carried from the original days when pt_regs was removed 
from the irq handler arguments, so that's probably why x86_write_percpu 
was not employed.

I'll make note to fix that up...

	Jeff




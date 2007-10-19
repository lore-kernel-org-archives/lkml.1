Return-Path: <linux-kernel-owner+w=401wt.eu-S935434AbXJSSV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935434AbXJSSV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759667AbXJSSVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:21:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35490 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760209AbXJSSVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:21:49 -0400
Message-ID: <4718F5BB.5010301@garzik.org>
Date: Fri, 19 Oct 2007 14:21:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] irq-remove: core
References: <20071019075443.GA6407@havoc.gtf.org>	<20071019075508.GB6407@havoc.gtf.org> <m1ir53gev4.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ir53gev4.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> commit 008b5fcf3c1d8456005de26ddd4256b1369225e8
>> Author: Jeff Garzik <jeff@garzik.org>
>> Date:   Fri Oct 19 00:45:51 2007 -0400
>>
>>     [IRQ ARG REMOVAL] core interrupt delivery infrastructure updates
>>
>>  include/asm-generic/irq_regs.h |   25 +++++++++++++++++++++++++
>>  include/linux/interrupt.h      |    4 ++--
>>  kernel/irq/handle.c            |    5 +++--
>>  kernel/irq/manage.c            |    4 ++--
>>  kernel/irq/spurious.c          |    3 ++-
>>  lib/irq_regs.c                 |    5 +++++
>>  6 files changed, 39 insertions(+), 7 deletions(-)
>>
>> 008b5fcf3c1d8456005de26ddd4256b1369225e8
>> diff --git a/include/asm-generic/irq_regs.h b/include/asm-generic/irq_regs.h
>> index 5ae1d07..1d99ef4 100644
>> --- a/include/asm-generic/irq_regs.h
>> +++ b/include/asm-generic/irq_regs.h
>> @@ -34,4 +34,29 @@ static inline struct pt_regs *set_irq_regs(struct pt_regs
>> *new_regs)
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
>> +}
>> +#endif
> 
> Please look at handle_IRQ_event.  Local irqs are enabled so irq
> recursion can happen.  So not handling old_irq is a big nasty
> bug.

Do you think set_irqfunc_irq() should be called at all the callsites of 
set_irq_regs(), or one the fix you mention is applied, do you think 
current model is sufficient?

	Jeff




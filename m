Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYH1Rdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYH1Rdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYH1Rdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:33:44 -0400
Received: from gw.goop.org ([64.81.55.164]:44819 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbYH1Rdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:33:43 -0400
Message-ID: <48B6E174.7070308@goop.org>
Date: Thu, 28 Aug 2008 10:33:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC 3/3] x86: use mwait for trigger API
References: <48A70192.7020002@goop.org> <200808281425.57336.borntraeger@de.ibm.com>
In-Reply-To: <200808281425.57336.borntraeger@de.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Samstag, 16. August 2008 schrieb Jeremy Fitzhardinge:
>
> Seems that this cant work. We never reset the t->cpus bits. That means we 
> never mwait after a kick.
>   

Yeah, I have to admit I never tested this code (it was an RFC, after
all).  And after Arjan said that mwait is unusable, I didn't spend any
more effort on it.

> See:
>
>   
>> +void mwait_trigger_reset(trigger_t *t)
>> +{
>> +	unsigned long flags;
>> +
>> +	t->trigger = 0;
>> +
>> +	local_save_flags(flags);
>> +	__get_cpu_var(mwait_saved_flags) = flags;
>> +
>> +	__monitor(&t->trigger, 0, 0);
>> +}
>> +
>> +void mwait_trigger_wait(trigger_t *t)
>> +{
>> +	unsigned long flags = __get_cpu_var(mwait_saved_flags);
>> +	int cpu = smp_processor_id();
>> +
>> +	if (irqs_disabled_flags(flags)) {
>> +		while(!cpu_isset(cpu, t->cpus)) {
>>     
>
> We check the bits here
>
>   
>> +			__mwait(0, 0);
>> +			barrier();
>> +			__monitor(&t->trigger, 0, 0);
>> +		}
>> +	} else {
>> +		while(!cpu_isset(cpu, t->cpus)) {
>>     
>
> and here
>
>   
>> +			__sti_mwait(0, 0);
>> +			barrier();
>> +			local_irq_disable();
>> +			__monitor(&t->trigger, 0, 0);
>> +		}
>> +	}
>>     

Must have lost a line somewhere.  It's supposed to clear the bit here,
before wait returns.

    J

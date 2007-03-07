Return-Path: <linux-kernel-owner+w=401wt.eu-S965548AbXCGOzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965548AbXCGOzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422673AbXCGOzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:55:37 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:19927 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965548AbXCGOzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:55:36 -0500
Message-ID: <45EED260.80109@ru.mvista.com>
Date: Wed, 07 Mar 2007 17:55:28 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org
Subject: Re: v2.6.19-rt6, yum/rpm
References: <20061205171114.GA25926@elte.hu> <4582CAD6.9040404@ru.mvista.com> <20061215161952.GA29191@elte.hu> <45C20CC6.2070201@ru.mvista.com> <20070201173855.GA29309@elte.hu> <20070201174900.GA31866@elte.hu> <45C22AFF.6060102@ru.mvista.com>
In-Reply-To: <45C22AFF.6060102@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>>> could you resend them to me please?

>>>>   Seeing that GENERIC_TIME has been thrown out from the -rt patch, 
>>>> [...]

>>> hm, i did that accidentally during a rebase. That was certainly not 
>>> meant to be a persistent condition.

>> ok, the delta below is what i've managed to restore from your PPC 
>> patches so far. Looks like this was truly a comedy of errors: i 
>> accidentally dropped the big ppc-gtod patch,

[...]

>>     Ingo

>> Index: linux/arch/powerpc/platforms/cell/interrupt.c
>> ===================================================================
>> --- linux.orig/arch/powerpc/platforms/cell/interrupt.c
>> +++ linux/arch/powerpc/platforms/cell/interrupt.c
>> @@ -90,6 +90,7 @@ static struct irq_chip iic_chip = {
>>      .typename = " CELL-IIC ",
>>      .mask = iic_mask,
>>      .unmask = iic_unmask,
>> +    .ack = iic_eoi,
>>      .eoi = iic_eoi,
>>  };
>>  
>> Index: linux/arch/powerpc/platforms/iseries/irq.c
>> ===================================================================
>> --- linux.orig/arch/powerpc/platforms/iseries/irq.c
>> +++ linux/arch/powerpc/platforms/iseries/irq.c
>> @@ -279,6 +279,7 @@ static struct irq_chip iseries_pic = {
>>      .shutdown    = iseries_shutdown_IRQ,
>>      .unmask        = iseries_enable_IRQ,
>>      .mask        = iseries_disable_IRQ,
>> +    .ack        = iseries_end_IRQ,
>>      .eoi        = iseries_end_IRQ
>>  };
>>  
>> Index: linux/arch/powerpc/platforms/pseries/xics.c
>> ===================================================================
>> --- linux.orig/arch/powerpc/platforms/pseries/xics.c
>> +++ linux/arch/powerpc/platforms/pseries/xics.c
>> @@ -456,6 +456,7 @@ static struct irq_chip xics_pic_direct =
>>      .startup = xics_startup,
>>      .mask = xics_mask_irq,
>>      .unmask = xics_unmask_irq,
>> +    .ack = xics_eoi_direct,
>>      .eoi = xics_eoi_direct,
>>      .set_affinity = xics_set_affinity
>>  };
>> @@ -466,6 +467,7 @@ static struct irq_chip xics_pic_lpar = {
>>      .startup = xics_startup,
>>      .mask = xics_mask_irq,
>>      .unmask = xics_unmask_irq,
>> +    .ack = xics_eoi_lpar,
>>      .eoi = xics_eoi_lpar,
>>      .set_affinity = xics_set_affinity
>>  };
>> Index: linux/arch/powerpc/sysdev/mpic.c
>> ===================================================================
>> --- linux.orig/arch/powerpc/sysdev/mpic.c
>> +++ linux/arch/powerpc/sysdev/mpic.c
>> @@ -767,6 +767,7 @@ static int mpic_set_irq_type(unsigned in
>>  static struct irq_chip mpic_irq_chip = {
>>      .mask        = mpic_mask_irq,
>>      .unmask        = mpic_unmask_irq,
>> +    .ack        = mpic_end_irq,
>>      .eoi        = mpic_end_irq,
>>      .set_type    = mpic_set_irq_type,
>>  };

>    These changes have been refused in favor of "fasetoi" flow fix.

    Ugh, seeing them 2.6.20-rt8 still -- *please* remove, they're now useless 
and quite ugly...

>> Index: linux/kernel/latency_trace.c
>> ===================================================================
>> --- linux.orig/kernel/latency_trace.c
>> +++ linux/kernel/latency_trace.c
>> @@ -1774,8 +1774,8 @@ check_critical_timing(int cpu, struct cp
>>  #ifndef CONFIG_CRITICAL_LATENCY_HIST
>>      if (!preempt_thresh && preempt_max_latency > delta) {
>>          printk("bug: updating %016Lx > %016Lx?\n",
>> -            preempt_max_latency, delta);
>> -        printk("  [%016Lx %016Lx %016Lx]\n", T0, T1, T2);
>> +            (u64)preempt_max_latency, (u64)delta);
>> +        printk("  [%016Lx %016Lx %016Lx]\n", (u64)T0, (u64)T1, (u64)T2);
>>      }
>>  #endif

>    IIRC, this is a fragment of my another refused patch (maybe the first 
> take on it?)... Should be outdated now.

    Ugh, I'm seeing this one in 2.6.20-rt8 still... *Please* remove it -- it's 
*useless* with the current -rt code.

WBR, Sergei

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbZA3NIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbZA3NIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 08:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZA3NIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 08:08:06 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:59619 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbZA3NIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 08:08:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VRo/m80Pat8vzU7yUMBtTnBG4/uzjeyZfkiqmRH7yqL1Uue6M4NWTgYyLiZ3EPR6qA
         8pHUFbl78qqkjJjvbidHKMG0HfQyjNaqcNuVJ2J+djdpNjKvBpHkJj3vBhY49eQpyUQW
         8w1WNYNt0gGCUn2FDFGjgsCTjTa4dp0nptKfc=
Date: Fri, 30 Jan 2009 08:07:57 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: avorontsov@ru.mvista.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: 2.6.28-rt on PowerPC
Message-ID: <20090130130757.GB31192@yoda.jdub.homelinux.org>
References: <20090129213429.GA29014@oksana.dev.rtsoft.ru> <1233270043.3833.57.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233270043.3833.57.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 06:00:43PM -0500, Steven Rostedt wrote:
>
>On Fri, 2009-01-30 at 00:34 +0300, Anton Vorontsov wrote:
>> Hi Steven,
>> 
>> I know 2.6.28-rt isn't yet ready, but I could not resist to try
>> it anyway. ;-)
>> 
>> Here are few issues and ways to solve them:
>> 
>> Currently the -rt tree doesn't link for arch/powerpc:
>> 
>>   LD      .tmp_vmlinux1
>>   arch/powerpc/kernel/built-in.o: In function `show_interrupts':
>>   (.text+0x27bc): undefined reference to `__call_bad_lock_func'
>>   arch/powerpc/kernel/built-in.o: In function `show_interrupts':
>>   (.text+0x28b0): undefined reference to `__call_bad_lock_func'
>>   make: *** [.tmp_vmlinux1] Error 1
>
>Thanks! I have not yet had the chance to apply any arch patches yet. I
>do plan on doing so after getting the code mostly working on x86.
>
>> 
>> This can be trivially fixed:
>> 
>> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
>> index 838857f..cc7dd12 100644
>> --- a/arch/powerpc/kernel/irq.c
>> +++ b/arch/powerpc/kernel/irq.c
>> @@ -183,7 +183,7 @@ int show_interrupts(struct seq_file *p, void *v)
>>  
>>  	if (i < NR_IRQS) {
>>  		desc = get_irq_desc(i);
>> -		acquire_lock_irqsave(&desc->lock, flags);
>> +		spin_lock_irqsave(&desc->lock, flags);
>>  		action = desc->action;
>>  		if (!action || !action->handler)
>>  			goto skip;
>> @@ -204,7 +204,7 @@ int show_interrupts(struct seq_file *p, void *v)
>>  			seq_printf(p, ", %s", action->name);
>>  		seq_putc(p, '\n');
>>  skip:
>> -		release_lock_irqrestore(&desc->lock, flags);
>> +		spin_unlock_irqrestore(&desc->lock, flags);
>>  	} else if (i == NR_IRQS) {
>>  #if defined(CONFIG_PPC32) && defined(CONFIG_TAU_INT)
>>  		if (tau_initialized){
>> 
>> --
>> 
>> 
>> 
>> While booting, this bug appears:
>> 
>> BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
>> in_atomic(): 1 [00010001], irqs_disabled(): 1, pid: 1, name: swapper
>> Call Trace:
>> [cf82f9a0] [c0008be8] show_stack+0x4c/0x16c (unreliable)
>> [cf82f9e0] [c001c184] __might_sleep+0xd8/0xf8
>> [cf82f9f0] [c02b7758] rt_spin_lock+0x30/0x78
>> [cf82fa00] [c001853c] ipic_mask_irq+0x3c/0xb0
>> [cf82fa20] [c0054064] handle_level_irq+0x40/0x178
>> [cf82fa40] [c00068ec] do_IRQ+0x68/0xe0
>> [cf82fa50] [c0012924] ret_from_except+0x0/0x14
>> --- Exception: 501 at internal_add_timer+0x4/0xe0
>> 
>> This is trivially solved by converting arch/powerpc/sysdev/ipic.c
>> back to spinlocks (ipic_lock).
>> 
>> Assuming that converting-back is automatic, there are few other
>> chained interrupt controllers you might want to convert-back:
>> 
>> arch/powerpc/sysdev/i8259.c (i8259_lock)
>> arch/powerpc/sysdev/mpic.c (mpic_lock)
>> arch/powerpc/sysdev/qe_lib/qe_ic.c (qe_ic_lock)

arch/powerpc/sysdev/uic.c has spin_locks in the struct for each
UIC instance.  They can be cascaded as well.

josh

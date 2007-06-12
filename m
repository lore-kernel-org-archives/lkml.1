Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbXFLSWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbXFLSWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbXFLSWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:22:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42580 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbXFLSWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:22:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: Re: [PATCH] x86: Document the hotplug code is incompatible with x86 irq handling
References: <m1tztt3yqy.fsf@ebiederm.dsl.xmission.com>
	<20070607140102.GA9094@ucw.cz>
Date: Tue, 12 Jun 2007 12:19:48 -0600
In-Reply-To: <20070607140102.GA9094@ucw.cz> (Pavel Machek's message of "Thu, 7
	Jun 2007 14:01:02 +0000")
Message-ID: <m1bqflox17.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> Hi!
>
>> I just realized that except for doing the code review and noticing
>> that the current cpu hotplug code is fundamentally incompatible
>> with x86 I haven't done anything about it.  So here is my patch
>> to document what is wrong.
>> 
>> The current cpu hotplug code requires irqs to be migrated from a cpu
>> outside of irq context.  On x86 ioapics simply do not support this,
>> making the code unfixable without major redesign of the generic cpu
>> hotplug code.
>> 
>> So this patch makes CPU_HOTPLUG on x86 depend on CONFIG_BROKEN
>> and adds a WARN_ON so people that do enable it are not in doubt about
>> which part of the code is broken, even if it does work for them.
>
>
>> --- a/arch/i386/kernel/irq.c
>> +++ b/arch/i386/kernel/irq.c
>> @@ -312,6 +312,19 @@ void fixup_irqs(cpumask_t map)
>>  	unsigned int irq;
>>  	static int warned;
>>  
>> +	/* 
>> +	 * Function is so wrong at so many levels.
>> +	 * - We migrate irqs that are directed at the cpu we are
>> +	 *   removing.
>
> Is this about irq pinning?

Sorry. That should have been: We migrate irqs that are not directed at the
cpu we are removing.  (We are migrating irqs when it is unnecessary).

>> +	 * - We cannot safely migrate ioapic irqs on x86 except in
>> +	 *   side of irq context.
>
> 'inside'?
>
> Can you be more specific for this one?

Yes inside. 

An irq migration currently requires two instances of the irq firing to
complete.  Once on the source cpu once on the target cpu.

Migrating irqs while the irq is alive is a royal pain.

>> +	 * Since someone probably finds this useful just warn very
>> +	 * loudly until cpu hotplug is redesigned.
>> +	 */
>> +	WARN_ON(1);
>
> Ugh, no, this does not warn anyone. This will just make people ask me
> why they see stack trace while suspending... and we are not interested
> in the stack trace, anyway.
>
> printk(KERN_WARNING)?


Because you are calling unfixably broken code.  That should be a decent
incentive to do something else won't it?

IOAPICs do not support what the code is doing here.  There is lots of
practical evidence including bad experiences and practical tests that
support this.

I suspect the only reason you don't have problems is that the irqs are
already shut down at the source before we get to this code path.

>> index 5ce9443..a61c4f2 100644
>> --- a/arch/x86_64/Kconfig
>> +++ b/arch/x86_64/Kconfig
>> @@ -429,7 +429,7 @@ config NR_CPUS
>>  
>>  config HOTPLUG_CPU
>>  	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
>> -	depends on SMP && HOTPLUG && EXPERIMENTAL
>> +	depends on SMP && HOTPLUG && EXPERIMENTAL && BROKEN
>>  	help
>
> Great, this will force everyone and their dog to enable broken, making
> broken useless. Please don't.

CONFIG_BROKEN is quite likely excessive but the code is totally and
unfixably broken.  So it still doesn't feel wrong to me.

Perhaps we should just disable swap suspend on SMP until we get a
design that can be implemented correctly on existing hardware.  I am
not happy with people telling me that we must keep broken code because
people with brand new SMP laptops will scream otherwise.  Since the
fundamental problems in this code path don't appear to bite people
very frequently I don't mind waiting while an alternative solution is
debugged and tested, but there is no way it makes sense to keep this
code in service more for more than a kernel release or two.

Eric

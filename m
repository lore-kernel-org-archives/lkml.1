Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbZICUl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbZICUl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932242AbZICUl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:41:27 -0400
Received: from claw.goop.org ([74.207.240.146]:37651 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241AbZICUl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:41:27 -0400
Message-ID: <4AA029F8.2070002@goop.org>
Date: Thu, 03 Sep 2009 13:41:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/i386: make sure stack-protector segment base is cache
 aligned
References: <4AA01893.6000507@goop.org> <4AA01D4F.1080707@gmail.com>
In-Reply-To: <4AA01D4F.1080707@gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/09 12:47, Eric Dumazet wrote:
> Jeremy Fitzhardinge a écrit :
>   
>> The Intel Optimization Reference Guide says:
>>
>> 	In Intel Atom microarchitecture, the address generation unit
>> 	assumes that the segment base will be 0 by default. Non-zero
>> 	segment base will cause load and store operations to experience
>> 	a delay.
>> 		- If the segment base isn't aligned to a cache line
>> 		  boundary, the max throughput of memory operations is
>> 		  reduced to one [e]very 9 cycles.
>> 	[...]
>> 	Assembly/Compiler Coding Rule 15. (H impact, ML generality)
>> 	For Intel Atom processors, use segments with base set to 0
>> 	whenever possible; avoid non-zero segment base address that is
>> 	not aligned to cache line boundary at all cost.
>>
>> We can't avoid having a non-zero base for the stack-protector segment, but
>> we can make it cache-aligned.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
>> index 0bfcf7e..f7d2c8f 100644
>> --- a/arch/x86/include/asm/processor.h
>> +++ b/arch/x86/include/asm/processor.h
>> @@ -403,7 +403,17 @@ extern unsigned long kernel_eflags;
>>  extern asmlinkage void ignore_sysret(void);
>>  #else	/* X86_64 */
>>  #ifdef CONFIG_CC_STACKPROTECTOR
>> -DECLARE_PER_CPU(unsigned long, stack_canary);
>> +/*
>> + * Make sure stack canary segment base is cached-aligned:
>> + *   "For Intel Atom processors, avoid non zero segment base address
>> + *    that is not aligned to cache line boundary at all cost."
>> + * (Optim Ref Manual Assembly/Compiler Coding Rule 15.)
>> + */
>> +struct stack_canary {
>> +	char __pad[20];		/* canary at %gs:20 */
>> +	unsigned long canary;
>> +};
>> +DECLARE_PER_CPU(struct stack_canary, stack_canary) ____cacheline_aligned;
>>     
> DECLARE_PER_CPU_SHARED_ALIGNED()
>
> Or else, we'll have many holes in percpu section, because of linker encapsulation
>   

That's only cache aligned when SMP is enabled, to avoid false cacheline
sharing.  In this case we need it unconditionally cache-aligned.

    J

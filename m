Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbZICVIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbZICVIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932299AbZICVIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:08:45 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:48785 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbZICVIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:08:44 -0400
Message-ID: <4AA03016.8000904@gmail.com>
Date: Thu, 03 Sep 2009 23:07:34 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/i386: make sure stack-protector segment base is cache
 aligned
References: <4AA01893.6000507@goop.org> <4AA01D4F.1080707@gmail.com> <4AA029F8.2070002@goop.org>
In-Reply-To: <4AA029F8.2070002@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 03 Sep 2009 23:07:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge a écrit :
> On 09/03/09 12:47, Eric Dumazet wrote:
>> Jeremy Fitzhardinge a écrit :
>>   
>>> The Intel Optimization Reference Guide says:
>>>
>>> 	In Intel Atom microarchitecture, the address generation unit
>>> 	assumes that the segment base will be 0 by default. Non-zero
>>> 	segment base will cause load and store operations to experience
>>> 	a delay.
>>> 		- If the segment base isn't aligned to a cache line
>>> 		  boundary, the max throughput of memory operations is
>>> 		  reduced to one [e]very 9 cycles.
>>> 	[...]
>>> 	Assembly/Compiler Coding Rule 15. (H impact, ML generality)
>>> 	For Intel Atom processors, use segments with base set to 0
>>> 	whenever possible; avoid non-zero segment base address that is
>>> 	not aligned to cache line boundary at all cost.
>>>
>>> We can't avoid having a non-zero base for the stack-protector segment, but
>>> we can make it cache-aligned.
>>>
>>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>>
>>> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
>>> index 0bfcf7e..f7d2c8f 100644
>>> --- a/arch/x86/include/asm/processor.h
>>> +++ b/arch/x86/include/asm/processor.h
>>> @@ -403,7 +403,17 @@ extern unsigned long kernel_eflags;
>>>  extern asmlinkage void ignore_sysret(void);
>>>  #else	/* X86_64 */
>>>  #ifdef CONFIG_CC_STACKPROTECTOR
>>> -DECLARE_PER_CPU(unsigned long, stack_canary);
>>> +/*
>>> + * Make sure stack canary segment base is cached-aligned:
>>> + *   "For Intel Atom processors, avoid non zero segment base address
>>> + *    that is not aligned to cache line boundary at all cost."
>>> + * (Optim Ref Manual Assembly/Compiler Coding Rule 15.)
>>> + */
>>> +struct stack_canary {
>>> +	char __pad[20];		/* canary at %gs:20 */
>>> +	unsigned long canary;
>>> +};
>>> +DECLARE_PER_CPU(struct stack_canary, stack_canary) ____cacheline_aligned;
>>>     
>> DECLARE_PER_CPU_SHARED_ALIGNED()
>>
>> Or else, we'll have many holes in percpu section, because of linker encapsulation
>>   
> 
> That's only cache aligned when SMP is enabled, to avoid false cacheline
> sharing.  In this case we need it unconditionally cache-aligned.

I was referring to .data.percpu alignement requirements, not to false sharing.

When we put a object with an align(64) requirement into a section, linker
has to put this 2**6 alignment in resulting section.

When several .o are linked together, linker has to take the biggest alignement,
and has to put holes.

Check .data.percpu size in vmlinux before and after your patch, to make sure
it doesnt grow too much :)

therefore, ____cacheline_aligned objects should be placed in
.data.percpu.shared_aligned

I suggest running following script and check .data.percpu alignments
are 2**2

# find . -name built-in.o|xargs objdump -h |grep percpu
 17 .data.percpu  00000018  00000000  00000000  0001db40  2**2
 12 .data.percpu  00000018  00000000  00000000  00015e80  2**2
 15 .data.percpu  000010a8  00000000  00000000  00012ec4  2**2
 31 .data.percpu.shared_aligned 0000055c  00000000  00000000  00085740  2**6
 33 .data.percpu  0000178c  00000000  00000000  00086880  2**2
 19 .data.percpu  000000bc  00000000  00000000  00006c64  2**2
 21 .data.percpu  00000010  00000000  00000000  00018990  2**2
 19 .data.percpu  0000000c  00000000  00000000  00008fb4  2**2
 30 .data.percpu  000018c0  00000000  00000000  0003cd50  2**3
 32 .data.percpu.shared_aligned 00000100  00000000  00000000  0003ee40  2**6
 43 .data.percpu.page_aligned 00001000  00000000  00000000  00048000  2**12
 14 .data.percpu  0000005c  00000000  00000000  0000a8a0  2**2
 22 .data.percpu  0000134c  00000000  00000000  0000d7a8  2**3
 23 .data.percpu.page_aligned 00001000  00000000  00000000  0000f000  2**12
 11 .data.percpu  00000014  00000000  00000000  00001428  2**2
 31 .data.percpu  000020b8  00000000  00000000  00045660  2**3
 33 .data.percpu.shared_aligned 00000108  00000000  00000000  00047f40  2**6
 44 .data.percpu.page_aligned 00001000  00000000  00000000  00052000  2**12
 21 .data.percpu  000007f8  00000000  00000000  00006b94  2**2
 25 .data.percpu.shared_aligned 00000008  00000000  00000000  00007400  2**6
 11 .data.percpu  000000e0  00000000  00000000  0000146c  2**2
  6 .data.percpu  000000dc  00000000  00000000  000003c0  2**2
 41 .data.percpu  000001c4  00000000  00000000  00261d00  2**2
 18 .data.percpu  00000004  00000000  00000000  00009f6c  2**2
 18 .data.percpu  000000bc  00000000  00000000  00003e4c  2**2
 23 .data.percpu  00000014  00000000  00000000  00027814  2**2
 16 .data.percpu  00000004  00000000  00000000  000012f0  2**2
 27 .data.percpu  0000000c  00000000  00000000  0003d97c  2**2
 28 .data.percpu  00000a68  00000000  00000000  000324e0  2**2
 18 .data.percpu  00000008  00000000  00000000  00013b44  2**2
 20 .data.percpu  000004fc  00000000  00000000  001263d4  2**2
 18 .data.percpu  00000188  00000000  00000000  0001e0d8  2**2
 19 .data.percpu  00000194  00000000  00000000  00030840  2**2
 19 .data.percpu  000001d4  00000000  00000000  0004a508  2**2
 26 .data.percpu  00000040  00000000  00000000  000bc370  2**2

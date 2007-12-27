Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbXL0HDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbXL0HDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 02:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbXL0HDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 02:03:04 -0500
Received: from il.qumranet.com ([82.166.9.18]:35115 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbXL0HDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 02:03:02 -0500
Message-ID: <47734E24.4050405@qumranet.com>
Date: Thu, 27 Dec 2007 09:03:00 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH 06/55] KVM: Per-architecture hypercall definitions
References: <1198667160-22953-1-git-send-email-avi@qumranet.com> <1198667160-22953-7-git-send-email-avi@qumranet.com> <20071226193226.GA8844@elf.ucw.cz>
In-Reply-To: <20071226193226.GA8844@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[copying Anthony, the original author]

Pavel Machek wrote:
> Hi!
>
>   
>> Currently kvm provides hypercalls only for x86* architectures. To
>> provide hypercall infrastructure for other kvm architectures I split
>> kvm_para.h into a generic header file and architecture specific
>> definitions.
>>     

>> diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
>> new file mode 100644
>> index 0000000..c6f3fd8
>> --- /dev/null
>> +++ b/include/asm-x86/kvm_para.h
>> @@ -0,0 +1,105 @@
>> +#ifndef __X86_KVM_PARA_H
>> +#define __X86_KVM_PARA_H
>> +
>> +/* This CPUID returns the signature 'KVMKVMKVM' in ebx, ecx, and edx.  It
>> + * should be used to determine that a VM is running under KVM.
>> + */
>> +#define KVM_CPUID_SIGNATURE	0x40000000
>>     
>
> so it returns 'KVMKVMKVM' in %rax, too? 
>
>   

No, as documented. 'KVMKVMKVM' is spread among all three registers (9 
bytes won't fit into one...)

>> +/* For KVM hypercalls, a three-byte sequence of either the vmrun or the vmmrun
>> + * instruction.  The hypervisor may replace it with something else but only the
>> + * instructions are guaranteed to be supported.
>> + *
>> + * Up to four arguments may be passed in rbx, rcx, rdx, and rsi respectively.
>> + * The hypercall number should be placed in rax and the return
>>     
>
> rax? First, this file is shared with i386, AFAICT.
>   

rax is used here in the sense of 'rax on x86-64, eax on i386'.  I guess 
this should be documented.

>   
>> + * placed in rax.  No other registers will be clobbered unless explicited
>> + * noted by the particular hypercall.
>> + */
>> +
>> +static inline long kvm_hypercall0(unsigned int nr)
>> +{
>> +	long ret;
>> +	asm volatile(KVM_HYPERCALL
>> +		     : "=a"(ret)
>> +		     : "a"(nr));
>>     
>
> Second, if it is to be placed in rax, nr should be unsigned long?
>
>
>   

Hm.  Since hypercall numbers are shared with i386, we can't have >4G of 
them.  So the hypercall number should be redefined to be in eax, 
regardless of arch (while the arguments still are unsigned longs).

>> +static inline int kvm_para_available(void)
>> +{
>> +	unsigned int eax, ebx, ecx, edx;
>> +	char signature[13];
>> +
>> +	cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
>> +	memcpy(signature + 0, &ebx, 4);
>> +	memcpy(signature + 4, &ecx, 4);
>> +	memcpy(signature + 8, &edx, 4);
>>     
>
>   
>> +	signature[12] = 0;
>> +
>>     
>                                ebx|ecx|ed
>   
>> +	if (strcmp(signature, "KVMKVMKVM") == 0)
>> +		return 1;
>>     
>
> Should the comment say
>
>   
>> +/* This CPUID returns the signature 'KVMKVMKVM\0\0\0' in ebx, ecx, and edx.  It
>> + * should be used to determine that a VM is running under KVM.
>> + */
>>     
>
> Plus, I'd use memcmp, and actually test for those zeros, too.
>
> ...which probably can be done later, as this is pure move...
> 									Pavel
>   

Or maybe direct 32-bit compares, and document the 32-bit values of the 
registers directly, to avoid any chance of confusion.

Thanks for the comments, I'll update the patches.


-- 
error compiling committee.c: too many arguments to function


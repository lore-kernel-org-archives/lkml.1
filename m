Return-Path: <linux-kernel-owner+w=401wt.eu-S964796AbXH0Rt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbXH0Rt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbXH0Rts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:49:48 -0400
Received: from il.qumranet.com ([82.166.9.18]:41499 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677AbXH0Rtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:49:47 -0400
Message-ID: <46D30E25.1090607@qumranet.com>
Date: Mon, 27 Aug 2007 20:47:17 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Implement emulator_write_phys()
References: <11882278064002-git-send-email-aliguori@us.ibm.com>	 <1188227808405-git-send-email-aliguori@us.ibm.com>	 <46D2F1B7.70604@qumranet.com> <1188235419.6364.2.camel@squirrel>	 <46D3095A.6020305@qumranet.com> <1188236391.6364.14.camel@squirrel>
In-Reply-To: <1188236391.6364.14.camel@squirrel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> On Mon, 2007-08-27 at 20:26 +0300, Avi Kivity wrote:
>   
>> Anthony Liguori wrote:
>>     
>>> On Mon, 2007-08-27 at 18:45 +0300, Avi Kivity wrote:
>>>   
>>>       
>>>> Anthony Liguori wrote:
>>>>     
>>>>         
>>>>> Since a hypercall may span two pages and is a gva, we need a function to write
>>>>> to a gva that may span multiple pages.  emulator_write_phys() seems like the
>>>>> logical choice for this.
>>>>>
>>>>> @@ -962,8 +962,35 @@ static int emulator_write_std(unsigned long addr,
>>>>>  			      unsigned int bytes,
>>>>>  			      struct kvm_vcpu *vcpu
>>>>>       
>>>>>           
>>>> I think that emulator_write_emulated(), except for being awkwardly 
>>>> named, should do the job.  We have enough APIs.
>>>>
>>>> But!  We may not overwrite the hypercall instruction while a vcpu may be 
>>>> executing, since there's no atomicity guarantee for code fetch.  We have 
>>>> to to be out of guest mode while writing that insn.
>>>>     
>>>>         
>>> Hrm, good catch.
>>>
>>> How can we get out of guest mode given SMP guest support?
>>>
>>>   
>>>       
>> kvm_flush_remote_tlbs() is something that can be generalized.  
>> Basically, you set a bit in each vcpu and send an IPI to take them out.
>>
>> But that's deadlock prone and complex.  Maybe you can just take 
>> kvm->lock, zap the mmu and the flush tlbs, and patch the instruction at 
>> your leisure, as no vcpu will be able to map memory until the lock is 
>> released.
>>     
>
> This works for shadow paging but not necessarily with NPT.  

NPT will have tlb and 2nd level pagetable flushing (to support memory 
unplug, ballooning, guest swapping, and the like) so it's safe to assume 
that it will continue to work.


> Do code
> fetches really not respect atomic writes?  We could switch to a 32-bit
> atomic operation and that should result in no worse than the code being
> patched twice.
>   

I think they don't respect it (the data cache and insn cache and fetch 
pipeline are very separated for performance reasons, so it's not 
unexpected).

I think the Intel manual has some guidelines on self-modifying code.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.


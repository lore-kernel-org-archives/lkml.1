Return-Path: <linux-kernel-owner+w=401wt.eu-S1758495AbYFSOqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbYFSOqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 10:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbYFSOqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 10:46:37 -0400
Received: from gw.goop.org ([64.81.55.164]:53715 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbYFSOqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 10:46:36 -0400
Message-ID: <485A7122.8090200@goop.org>
Date: Thu, 19 Jun 2008 07:45:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH] i386: fix vmalloc_sync_all() for Xen
References: <48591049.76E4.0078.0@novell.com> <485969A4.6090406@goop.org> <485A465D.76E4.0078.0@novell.com>
In-Reply-To: <485A465D.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>> Given that the usermode PGDs will never need syncing, I think it would 
>> be better to use KERNEL_PGD_PTRS, and define
>>
>> #define sync_index(a) (((a) >> PMD_SHIFT) - KERNEL_PGD_BOUNDARY)
>>
>> for a massive 192 byte saving in bss.
>>     
>
> I was considering that, too, but didn't do so for simplicity's sake. If I'll
> have to re-spin the patch, I may as well do it.
>
>   
>>> +	for (address = start; address >= TASK_SIZE; address += PMD_SIZE) {
>>>   
>>>       
>> Would it be better - especially for the Xen case - to only iterate from 
>> TASK_SIZE to FIXADDR_TOP rather than wrapping around?  What will 
>> vmalloc_sync_one do on Xen mappings?
>>     
>
> Could be done, but since there will never be any out-of-sync Xen entries,
> it doesn't hurt doing the full pass. I agree it would possibly be more
> correct,though.
>
>   
>>> +		if (!test_bit(sync_index(address), insync)) {
>>>   
>>>       
>> It's probably worth reversing this test and removing a layer of indentation.
>>     
>
> How? There's a second if() following this one, so we can't just 'continue;'
> here.
>   

That second if() block seems completely redundant:

		if (address == start && test_bit(pgd_index(address), insync))
			start = address + PGDIR_SIZE;

All it does it update "start", but start isn't used anywhere else in the 
loop.

>>>  			spin_lock_irqsave(&pgd_lock, flags);
>>> +			if (unlikely(list_empty(&pgd_list))) {
>>> +				spin_unlock_irqrestore(&pgd_lock, flags);
>>> +				return;
>>> +			}
>>>   
>>>       
>> This seems a bit warty.  If the list is empty, then won't the 
>> list_for_each_entry() just fall through?  Presumably this only applies 
>> to boot, since pgd_list won't be empty on a running system with usermode 
>> processes.  Is there a correctness issue here, or is it just a 
>> micro-optimisation?
>>     
>
> No, it isn't. Note the setting to NULL of page, which after the loop gets
> tested for. list_for_each_entry() would never yield a NULL page, even
> if the list is empty.

Does that matter?  If pgd_list is empty, then it's in sync by 
definition.  Why does it need special-casing?


>  And
>
>   
>>>  			list_for_each_entry(page, &pgd_list, lru) {
>>>  				if (!vmalloc_sync_one(page_address(page),
>>> -						      address))
>>> +						      address)) {
>>> +					BUG_ON(list_first_entry(&pgd_list,
>>> +								struct page,
>>> +								lru) != page);
>>>   
>>>       
>> What condition is this testing for?
>>     
>
> This is a replacement of the BUG_ON() that an earlier patch from you
> removed: Failure of vmalloc_sync_one() must happen on the first
> entry or never, and this is what is being checked for here.
>   

Could you add a comment?

> No, just like on 32-bit it's because modules loaded may access
> vmalloc()-ed memory from notifiers that are called in contexts (NMI)
> where taking even simple (propagation) page faults cannot be
> tolerated (since the final IRET would result in finishing the NMI
> handling from a CPU (or hypervisor) perspective.
>   

Well, 32-bit PAE avoids any syncing by having all pagetables share the 
same pmd containing the vmalloc mappings (ignoring the complications Xen 
adds here).  Couldn't 64-bit do the same thing at the pud level 
(preallocate as many puds needed to fill out the vmalloc area size).

Uh, I guess that's not practical with 64TB of vmalloc address space 
reserved...

    J

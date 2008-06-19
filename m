Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbYFSSRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbYFSSRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 14:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758709AbYFSSRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 14:17:38 -0400
Received: from gw.goop.org ([64.81.55.164]:46100 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758563AbYFSSRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 14:17:37 -0400
Message-ID: <485AA296.6070008@goop.org>
Date: Thu, 19 Jun 2008 11:16:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH] i386: fix vmalloc_sync_all() for Xen
References: <48591049.76E4.0078.0@novell.com> <485969A4.6090406@goop.org> <485A465D.76E4.0078.0@novell.com> <485A7122.8090200@goop.org> <485A9EF5.76E4.0078.0@novell.com>
In-Reply-To: <485A9EF5.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Since start is a static variable, it must be updated this way. The intention
> here is to shorten the loop in later runs - since kernel page table entries
> never go away, this is possible. Possibly just using the insync array would
> be sufficient, but when I first coded this I wanted to avoid as much
> overhead as was possible.
>   

Yes, I see.  How often does this get called?  alloc_vm_area() and 
register_notify_die().  alloc_vm_area is only called by the grant-table 
code, and register_notify_die() is boot-time init.  Is this worth 
optimising at all?


>>>>>  			spin_lock_irqsave(&pgd_lock, flags);
>>>>> +			if (unlikely(list_empty(&pgd_list))) {
>>>>> +				spin_unlock_irqrestore(&pgd_lock, flags);
>>>>> +				return;
>>>>> +			}
>>>>>   
>>>>>       
>>>>>           
>>>> This seems a bit warty.  If the list is empty, then won't the 
>>>> list_for_each_entry() just fall through?  Presumably this only applies 
>>>> to boot, since pgd_list won't be empty on a running system with usermode 
>>>> processes.  Is there a correctness issue here, or is it just a 
>>>> micro-optimisation?
>>>>     
>>>>         
>>> No, it isn't. Note the setting to NULL of page, which after the loop gets
>>> tested for. list_for_each_entry() would never yield a NULL page, even
>>> if the list is empty.
>>>       
>> Does that matter?  If pgd_list is empty, then it's in sync by 
>> definition.  Why does it need special-casing?
>>     
>
> Yes, certainly. But it would result in all insync bits set, which would be
> wrong - only non-empty page directory entries can be in sync.
>   

I think it would be better to separately test whether the vmalloc 
mapping is present in the init_mm and skip the syncing loop in that 
case, rather than this somewhat convoluted logic to overload the test in 
vmalloc_sync_one.

>>>>>  			list_for_each_entry(page, &pgd_list, lru) {
>>>>>  				if (!vmalloc_sync_one(page_address(page),
>>>>> -						      address))
>>>>> +						      address)) {
>>>>> +					BUG_ON(list_first_entry(&pgd_list,
>>>>> +								struct page,
>>>>> +								lru) != page);
>>>>>   
>>>>>       
>>>>>           
>>>> What condition is this testing for?
>>>>     
>>>>         
>>> This is a replacement of the BUG_ON() that an earlier patch from you
>>> removed: Failure of vmalloc_sync_one() must happen on the first
>>> entry or never, and this is what is being checked for here.
>>>   
>>>       
>> Could you add a comment?
>>     
>
> Sure, though there was none originally, and the intention seemed
> quite clear to me.

Well, looks to me like vmalloc_sync_one can only return NULL iff the 
vmalloc mapping is absent in init_mm, so that's going to be invariant 
with respect to any other pgd you pass in.  So I don't think the BUG_ON 
will ever fire, and it's unclear what actual logical property it's 
testing for.

I think all this can be cleaned up quite a bit, but this patch is an 
improvement over what's currently there.

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J


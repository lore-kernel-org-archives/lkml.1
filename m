Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbYFSQBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbYFSQBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 12:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYFSQBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 12:01:05 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:35058 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbYFSQBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 12:01:04 -0400
Message-Id: <485A9EF5.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 19 Jun 2008 17:01:25 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] i386: fix vmalloc_sync_all() for Xen
References: <48591049.76E4.0078.0@novell.com> <485969A4.6090406@goop.org>
 <485A465D.76E4.0078.0@novell.com> <485A7122.8090200@goop.org>
In-Reply-To: <485A7122.8090200@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> +		if (!test_bit(sync_index(address), insync)) {
>>>>   
>>>>       
>>> It's probably worth reversing this test and removing a layer of indentation.
>>>     
>>
>> How? There's a second if() following this one, so we can't just 'continue;'
>> here.
>>   
>
>That second if() block seems completely redundant:
>
>		if (address == start && test_bit(pgd_index(address), insync))
>			start = address + PGDIR_SIZE;
>
>All it does it update "start", but start isn't used anywhere else in the 
>loop.

Since start is a static variable, it must be updated this way. The intention
here is to shorten the loop in later runs - since kernel page table entries
never go away, this is possible. Possibly just using the insync array would
be sufficient, but when I first coded this I wanted to avoid as much
overhead as was possible.

>>>>  			spin_lock_irqsave(&pgd_lock, flags);
>>>> +			if (unlikely(list_empty(&pgd_list))) {
>>>> +				spin_unlock_irqrestore(&pgd_lock, flags);
>>>> +				return;
>>>> +			}
>>>>   
>>>>       
>>> This seems a bit warty.  If the list is empty, then won't the 
>>> list_for_each_entry() just fall through?  Presumably this only applies 
>>> to boot, since pgd_list won't be empty on a running system with usermode 
>>> processes.  Is there a correctness issue here, or is it just a 
>>> micro-optimisation?
>>>     
>>
>> No, it isn't. Note the setting to NULL of page, which after the loop gets
>> tested for. list_for_each_entry() would never yield a NULL page, even
>> if the list is empty.
>
>Does that matter?  If pgd_list is empty, then it's in sync by 
>definition.  Why does it need special-casing?

Yes, certainly. But it would result in all insync bits set, which would be
wrong - only non-empty page directory entries can be in sync.

>>>>  			list_for_each_entry(page, &pgd_list, lru) {
>>>>  				if (!vmalloc_sync_one(page_address(page),
>>>> -						      address))
>>>> +						      address)) {
>>>> +					BUG_ON(list_first_entry(&pgd_list,
>>>> +								struct page,
>>>> +								lru) != page);
>>>>   
>>>>       
>>> What condition is this testing for?
>>>     
>>
>> This is a replacement of the BUG_ON() that an earlier patch from you
>> removed: Failure of vmalloc_sync_one() must happen on the first
>> entry or never, and this is what is being checked for here.
>>   
>
>Could you add a comment?

Sure, though there was none originally, and the intention seemed
quite clear to me.

Jan


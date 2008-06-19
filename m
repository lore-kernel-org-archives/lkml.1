Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbYFSJnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbYFSJnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYFSJnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:43:09 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:17743 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYFSJnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:43:07 -0400
Message-Id: <485A465D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 19 Jun 2008 10:43:25 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] i386: fix vmalloc_sync_all() for Xen
References: <48591049.76E4.0078.0@novell.com> <485969A4.6090406@goop.org>
In-Reply-To: <485969A4.6090406@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Given that the usermode PGDs will never need syncing, I think it would 
>be better to use KERNEL_PGD_PTRS, and define
>
>#define sync_index(a) (((a) >> PMD_SHIFT) - KERNEL_PGD_BOUNDARY)
>
>for a massive 192 byte saving in bss.

I was considering that, too, but didn't do so for simplicity's sake. If I'll
have to re-spin the patch, I may as well do it.

>> +	for (address = start; address >= TASK_SIZE; address += PMD_SIZE) {
>>   
>
>Would it be better - especially for the Xen case - to only iterate from 
>TASK_SIZE to FIXADDR_TOP rather than wrapping around?  What will 
>vmalloc_sync_one do on Xen mappings?

Could be done, but since there will never be any out-of-sync Xen entries,
it doesn't hurt doing the full pass. I agree it would possibly be more
correct,though.

>> +		if (!test_bit(sync_index(address), insync)) {
>>   
>It's probably worth reversing this test and removing a layer of indentation.

How? There's a second if() following this one, so we can't just 'continue;'
here.

>>  			spin_lock_irqsave(&pgd_lock, flags);
>> +			if (unlikely(list_empty(&pgd_list))) {
>> +				spin_unlock_irqrestore(&pgd_lock, flags);
>> +				return;
>> +			}
>>   
>
>This seems a bit warty.  If the list is empty, then won't the 
>list_for_each_entry() just fall through?  Presumably this only applies 
>to boot, since pgd_list won't be empty on a running system with usermode 
>processes.  Is there a correctness issue here, or is it just a 
>micro-optimisation?

No, it isn't. Note the setting to NULL of page, which after the loop gets
tested for. list_for_each_entry() would never yield a NULL page, even
if the list is empty. And

>>  			list_for_each_entry(page, &pgd_list, lru) {
>>  				if (!vmalloc_sync_one(page_address(page),
>> -						      address))
>> +						      address)) {
>> +					BUG_ON(list_first_entry(&pgd_list,
>> +								struct page,
>> +								lru) != page);
>>   
>
>What condition is this testing for?

This is a replacement of the BUG_ON() that an earlier patch from you
removed: Failure of vmalloc_sync_one() must happen on the first
entry or never, and this is what is being checked for here.

>>  #else /* CONFIG_X86_64 */
>>  	/*
>>  	 * Note that races in the updates of insync and start aren't
>>   
>
>Any chance of unifying this with the very similar-looking loop below it?

Not at the same time I would say. As a subsequent thing, it might be
possible, though there are differences that make it desirable to keep
it distinct in my opinion.

>(I have to admit I don't understand why 64-bit needs to worry about 
>syncing stuff.  Doesn't it have enough pgds to go around?  Is it because 
>it wants to put modules within the same 2G chunk as the kernel?)

No, just like on 32-bit it's because modules loaded may access
vmalloc()-ed memory from notifiers that are called in contexts (NMI)
where taking even simple (propagation) page faults cannot be
tolerated (since the final IRET would result in finishing the NMI
handling from a CPU (or hypervisor) perspective.

Jan


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYFRUCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYFRUCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 16:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYFRUCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 16:02:24 -0400
Received: from gw.goop.org ([64.81.55.164]:53693 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbYFRUCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 16:02:23 -0400
Message-ID: <485969A4.6090406@goop.org>
Date: Wed, 18 Jun 2008 13:01:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: fix vmalloc_sync_all() for Xen
References: <48591049.76E4.0078.0@novell.com>
In-Reply-To: <48591049.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Since the fourth PDPT entry cannot be shared under Xen,
> vmalloc_sync_all() must iterate over pmd-s rather than pgd-s here.
> Luckily, the code isn't used for native PAE (SHARED_KERNEL_PMD is 1)
> and the change is benign to non-PAE.
>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
> ---
>  arch/x86/mm/fault.c |   29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
>
> --- linux-2.6.26-rc6/arch/x86/mm/fault.c	2008-06-18 09:56:16.000000000 +0200
> +++ 2.6.26-rc6-i386-xen-vmalloc_sync_all/arch/x86/mm/fault.c	2008-06-06 08:51:52.000000000 +0200
> @@ -921,32 +921,43 @@ void vmalloc_sync_all(void)
>  	 * start are only improving performance (without affecting correctness
>  	 * if undone).
>  	 */
> -	static DECLARE_BITMAP(insync, PTRS_PER_PGD);
> +#define sync_index(a) ((a) >> PMD_SHIFT)
> +	static DECLARE_BITMAP(insync, PTRS_PER_PGD*PTRS_PER_PMD);
>   

Given that the usermode PGDs will never need syncing, I think it would 
be better to use KERNEL_PGD_PTRS, and define

#define sync_index(a) (((a) >> PMD_SHIFT) - KERNEL_PGD_BOUNDARY)

for a massive 192 byte saving in bss.

>  	static unsigned long start = TASK_SIZE;
>  	unsigned long address;
>  
>  	if (SHARED_KERNEL_PMD)
>  		return;
>  
> -	BUILD_BUG_ON(TASK_SIZE & ~PGDIR_MASK);
> -	for (address = start; address >= TASK_SIZE; address += PGDIR_SIZE) {
> -		if (!test_bit(pgd_index(address), insync)) {
> +	BUILD_BUG_ON(TASK_SIZE & ~PMD_MASK);
> +	for (address = start; address >= TASK_SIZE; address += PMD_SIZE) {
>   

Would it be better - especially for the Xen case - to only iterate from 
TASK_SIZE to FIXADDR_TOP rather than wrapping around?  What will 
vmalloc_sync_one do on Xen mappings?

> +		if (!test_bit(sync_index(address), insync)) {
>   
It's probably worth reversing this test and removing a layer of indentation.
>  			unsigned long flags;
>  			struct page *page;
>  
>  			spin_lock_irqsave(&pgd_lock, flags);
> +			if (unlikely(list_empty(&pgd_list))) {
> +				spin_unlock_irqrestore(&pgd_lock, flags);
> +				return;
> +			}
>   

This seems a bit warty.  If the list is empty, then won't the 
list_for_each_entry() just fall through?  Presumably this only applies 
to boot, since pgd_list won't be empty on a running system with usermode 
processes.  Is there a correctness issue here, or is it just a 
micro-optimisation?

>  			list_for_each_entry(page, &pgd_list, lru) {
>  				if (!vmalloc_sync_one(page_address(page),
> -						      address))
> +						      address)) {
> +					BUG_ON(list_first_entry(&pgd_list,
> +								struct page,
> +								lru) != page);
>   

What condition is this testing for?

> +					page = NULL;
>  					break;
> +				}
>  			}
>  			spin_unlock_irqrestore(&pgd_lock, flags);
> -			if (!page)
> -				set_bit(pgd_index(address), insync);
> +			if (page)
> +				set_bit(sync_index(address), insync);
>  		}
> -		if (address == start && test_bit(pgd_index(address), insync))
> -			start = address + PGDIR_SIZE;
> +		if (address == start && test_bit(sync_index(address), insync))
> +			start = address + PMD_SIZE;
>  	}
> +#undef sync_index
>  #else /* CONFIG_X86_64 */
>  	/*
>  	 * Note that races in the updates of insync and start aren't
>   

Any chance of unifying this with the very similar-looking loop below it?

(I have to admit I don't understand why 64-bit needs to worry about 
syncing stuff.  Doesn't it have enough pgds to go around?  Is it because 
it wants to put modules within the same 2G chunk as the kernel?)

    J

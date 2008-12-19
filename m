Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYLSSPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYLSSPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 13:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYLSSNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 13:13:31 -0500
Received: from gate.crashing.org ([63.228.1.57]:58619 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbYLSSNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 13:13:30 -0500
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, jbeulich@novell.com, joerg.roedel@amd.com,
       benh@kernel.crashing.org
Message-Id: <58297658-C154-4C55-A696-5FC1D0D75C9A@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <494BDDF5.1090304@goop.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH 07/11] swiotlb: Add support for systems with highmem
Date: Fri, 19 Dec 2008 12:12:07 -0600
References: <20081218210231.GB24271@elte.hu> <1229663480-10757-8-git-send-email-beckyb@kernel.crashing.org> <494BDDF5.1090304@goop.org>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 19, 2008, at 11:46 AM, Jeremy Fitzhardinge wrote:

> Becky Bruce wrote:
>> On highmem systems, the original dma buffer might not
>> have a virtual mapping - we need to kmap it in to perform
>> the bounce.  Extract the code that does the actual
>> copy into a function that does the kmap if highmem
>> is enabled, and defaults to the normal swiotlb memcpy
>> if not.
>>
>> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
>> ---
>> lib/swiotlb.c |   53 ++++++++++++++++++++++++++++++++++++++++++++ 
>> +--------
>> 1 files changed, 45 insertions(+), 8 deletions(-)
>>
>> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
>> index e9d5bf6..ab5d3d7 100644
>> --- a/lib/swiotlb.c
>> +++ b/lib/swiotlb.c
>> @@ -14,6 +14,7 @@
>>  * 04/07/.. ak		Better overflow handling. Assorted fixes.
>>  * 05/09/10 linville	Add support for syncing ranges, support  
>> syncing for
>>  *			DMA_BIDIRECTIONAL mappings, miscellaneous cleanup.
>> + * 08/12/11 beckyb	Add highmem support
>>  */
>>  #include <linux/cache.h>
>> @@ -24,6 +25,7 @@
>> #include <linux/string.h>
>> #include <linux/types.h>
>> #include <linux/ctype.h>
>> +#include <linux/highmem.h>
>>  #include <asm/io.h>
>> #include <asm/dma.h>
>> @@ -306,6 +308,45 @@ static int is_swiotlb_buffer(char *addr)
>> }
>>  /*
>> + * Bounce: copy the swiotlb buffer back to the original dma location
>> + */
>> +void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
>> +		  enum dma_data_direction dir)
>> +{
>> +#ifdef CONFIG_HIGHMEM
>>
>
> Rather than using #ifdef CONFIG_HIGHMEM, I think it would be better  
> to use something like:
>
> 	if (PageHighMem(phys_to_page(phys))) {
> 		/* handle high page */
> 	} else {
> 		/* simple path */
> 	}
>
> This will still exclude all the highmem code on non-highmem systems,  
> and will use the fast-path for lowmem pages too.

Right - in the ppc case, I don't ever need to bounce a lowmem page, so  
I wasn't taking that into account.  But what you suggest makes sense.

>
>
>> +	/* The buffer may not have a mapping.  Map it in and copy */
>> +	unsigned int offset = ((unsigned long)phys &
>> +			       ((1 << PAGE_SHIFT) - 1));
>> +	char *buffer;
>> +	unsigned int sz = 0;
>> +	unsigned long flags;
>> +
>> +	while (size) {
>> +		sz = ((PAGE_SIZE - offset) > size) ? size :
>> +			PAGE_SIZE - offset;
>>
> sz = min(size, PAGE_SIZE - offset)?
>> +		local_irq_save(flags);
>> +		buffer = kmap_atomic(pfn_to_page(phys >> PAGE_SHIFT),
>>
> phys_to_page() does this for you.

Yeah, it still needs a bit of clean-up.... I need to scrub for stuff  
like this. That loop changed a few times and I hacked it into working  
and haven't cleaned it up yet.

Thanks for taking a look!  Given how similar the two patches are, it's  
pretty clear that we're either both insane, or both headed in the  
right direction :)

Anyway, I'm about to turn into a pumpkin - I'll probably be online for  
another hour or so sometime this afternoon, and then that's it for me  
until after I get back from vacation.  My apologies again for  
disappearing in the middle of the fun.

Cheers,
-B


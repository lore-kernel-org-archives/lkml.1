Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYIQNTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYIQNTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 09:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYIQNTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 09:19:44 -0400
Received: from esentire.com ([64.7.150.32]:57340 "EHLO eSentire.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbYIQNTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 09:19:42 -0400
Message-ID: <48D103AB.6050004@esentire.com>
Date: Wed, 17 Sep 2008 09:18:35 -0400
From: Jonathan Steel <jon.steel@esentire.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080609)
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec, kernel 2.6.26.5, segmentation fault in	kimage_add_entry
References: <48D0067F.3020007@esentire.com> <20080917005542.GD15750@verge.net.au>
In-Reply-To: <20080917005542.GD15750@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman wrote:
> On Tue, Sep 16, 2008 at 03:18:23PM -0400, Jonathan Steel wrote:
>   
>> A segmentation fault can occur in kimage_add_entry in kexec.c when 
>> loading a kernel image into memory. The fault occurs because a page is 
>> requested by calling kimage_alloc_page with gfp_mask GFP_KERNEL and the 
>> function may actually return a page with gfp_mask GFP_HIGHUSER. The high 
>> mem page is returned because it was swapped with the kernel page due to 
>> the kernel page being a page that will shortly be copied to.
>>
>> This patch ensures that kimage_alloc_page returns a page that was 
>> created with the correct gfp flags.
>>     
>
> I wonder if this problem might also affect other users of
> kimage_alloc_pages(), and if so, perhaps it should guard
> against this?
>   
kimage_alloc_page is used on only two separate occasions. The first is 
when a page is allocated with the GFP_HIGHUSER to get a new source page 
for the kernel image. That case will not be affected by this change 
because the if will always evaluate to false. The second case is the 
case that this patch is intended to fix, when allocating a kernel page 
for the page list. If anybody else ever uses the function they just want 
it to return a new alloced page, so there can't be any harm in making 
sure they get back a page of the type they asked for. If anything, not 
doing so could cause more problems in the future.
>   
>> --- linux-2.6.26.5.orig/kernel/kexec.c    2008-09-16 13:17:56.000000000 
>> -0400
>> +++ linux-2.6.26.5/kernel/kexec.c    2008-09-16 13:26:35.000000000 -0400
>> @@ -743,8 +743,15 @@ static struct page *kimage_alloc_page(st
>>              *old = addr | (*old & ~PAGE_MASK);
>>  
>>              /* The old page I have found cannot be a
>> -             * destination page, so return it.
>> -             */
>> +             * destination page, so return it if its
>> +             * gfp_flags honor the ones passed in.
>> +            */
>> +            if (!(gfp_mask & __GFP_HIGHMEM) &&
>> +                    PageHighMem(old_page)) {
>> +                kimage_free_pages(old_page);
>> +                continue;
>> +            }
>> +
>>              addr = old_addr;
>>              page = old_page;
>>              break;
>>
>> Signed-off-by: Jonathan Steel <jon.steel@esentire.com>
>>
>> Jonathan Steel
>>     
>
>   


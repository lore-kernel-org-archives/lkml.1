Return-Path: <linux-kernel-owner+w=401wt.eu-S933132AbXBWQ2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbXBWQ2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 11:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933133AbXBWQ2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 11:28:35 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:11805 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132AbXBWQ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 11:28:34 -0500
Message-ID: <45DF15D4.6040403@mvista.com>
Date: Fri, 23 Feb 2007 08:27:00 -0800
From: akuster <akuster@mvista.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [patch 1/1] MM:  detach_vmas_to_be_unmapped fix
References: <20070221180742.A05F31C49A@hermes.mvista.com> <200702212159.07295.ioe-lkml@rameria.de>
In-Reply-To: <200702212159.07295.ioe-lkml@rameria.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Oeser wrote:
> Hi,
> 
> On Wednesday, 21. February 2007, akuster@mvista.com wrote:
>> ---
>>
>>  mm/mmap.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff -puN mm/mmap.c~Avoiding-mmap-fragmentation_fixup mm/mmap.c
>> --- linux-2.6_clean/mm/mmap.c~Avoiding-mmap-fragmentation_fixup	2007-02-21 09:49:32.000000000 -0800
>> +++ linux-2.6_clean-akuster/mm/mmap.c	2007-02-21 09:51:26.000000000 -0800
>> @@ -1720,9 +1720,9 @@ detach_vmas_to_be_unmapped(struct mm_str
>>  	*insertion_point = vma;
>>  	tail_vma->vm_next = NULL;
>>  	if (mm->unmap_area == arch_unmap_area)
>> -		addr = prev ? prev->vm_end : mm->mmap_base;
>> +		addr = prev ? prev->vm_start : mm->mmap_base;
>>  	else
>> -		addr = vma ?  vma->vm_start : mm->mmap_base;
>> +		addr = vma ?  vma->vm_end : mm->mmap_base;
>>  	mm->unmap_area(mm, addr);
>>  	mm->mmap_cache = NULL;		/* Kill the cache. */
>>  }
> 
> Please comment, why you think this is necessary.

Yes that would help.

On Feb. 16th I asked a question and got no response. Here is what should 
have been included with the above patch.

Wolfgang Wander submitted a fix to address a mmap fragmentation issue. 
The git patch ( 1363c3cd8603a913a27e2995dccbd70d5312d8e6 ) is somewhat 
different and yields different results when running Wolfgang's test case 
leakme.c.

IMHO, the vm start and end address are swapped in arch_unmap_area and 
arch_unmap_area_topdown functions.

Prior to this patch arch_unmap_area() used area->vm_start and 
arch_unmap_area_topdown used area->vm_end in the git patch the following 
change showed up.

if (mm->unmap_area == arch_unmap_area)
     addr = prev ? prev->vm_start : mm->mmap_base;
else
     addr = vma ?  vma->vm_end : mm->mmap_base;

Using Wolfgang Wander's leakme.c test, I get the same results seen with 
his original "Avoiding mmap fragmentation" patch as I do after swapping 
  the start & end address in the above code segment. The patch I 
submitted  addresses this typo issue.

TIA,
Armin

> 
> 
> Thanks & Regards
> 
> Ingo Oeser

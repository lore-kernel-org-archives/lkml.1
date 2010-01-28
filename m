Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382Ab0A1RZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab0A1RZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 12:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368Ab0A1RZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 12:25:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366Ab0A1RZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 12:25:37 -0500
Message-ID: <4B61C83A.20301@redhat.com>
Date: Thu, 28 Jan 2010 12:24:10 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       aarcange@redhat.com
Subject: Re: [PATCH -mm] change anon_vma linking to fix multi-process server
 scalability issue
References: <20100128002000.2bf5e365@annuminas.surriel.com> <1264696641.17063.32.camel@barrios-desktop>
In-Reply-To: <1264696641.17063.32.camel@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2010 11:37 AM, Minchan Kim wrote:
> On Thu, 2010-01-28 at 00:20 -0500, Rik van Riel wrote:

>> This patch changes the way anon_vmas and VMAs are linked, which
>> allows us to associate multiple anon_vmas with a VMA.  At fork
>> time, each child process gets its own anon_vmas, in which its
>> COWed pages will be instantiated.  The parents' anon_vma is also
>> linked to the VMA, because non-COWed pages could be present in
>> any of the children.
>
> any of the children?
>
> IMHO, "parent" is right. :)
> Do I miss something? Could you elaborate it?

I am talking about an anonymous page that is shared by parent
and children processes and has not been COW copied yet.

>> -void vma_adjust(struct vm_area_struct *vma, unsigned long start,
>> +int vma_adjust(struct vm_area_struct *vma, unsigned long start,
>>   	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert)
>>   {
>>   	struct mm_struct *mm = vma->vm_mm;
>> @@ -542,6 +541,29 @@ again:			remove_next = 1 + (end>  next->vm_end);
>>   		}
>>   	}
>>
>> +	/*
>> +	 * When changing only vma->vm_end, we don't really need
>> +	 * anon_vma lock.
>> +	 */
>> +	if (vma->anon_vma&&  (insert || importer || start != vma->vm_start))
>> +		anon_vma = vma->anon_vma;
>> +	if (anon_vma) {
>> +		/*
>> +		 * Easily overlooked: when mprotect shifts the boundary,
>> +		 * make sure the expanding vma has anon_vma set if the
>> +		 * shrinking vma had, to cover any anon pages imported.
>> +		 */
>> +		if (importer&&  !importer->anon_vma) {
>> +			/* Block reverse map lookups until things are set up. */
>> +			importer->vm_flags |= VM_LOCK_RMAP;
>> +			if (anon_vma_clone(importer, vma)) {
>> +				importer->vm_flags&= ~VM_LOCK_RMAP;
>> +				return -ENOMEM;
>
> If we fail in here during progressing on next vmas in case of mprotect case 6,
> the previous vmas would become inconsistent state.

I've re-read the code, but I don't see what you are referring
to.  If vma_adjust bails out early, no VMAs will be adjusted
and all the VMAs will stay the way they were before mprotect
was called.

What am I overlooking?

>> @@ -2260,6 +2306,12 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
>>   		}
>>   	}
>>   	return new_vma;
>> +
>> + out_free_mempol:
>> +	mpol_put(pol);
>> + out_free_vma:
>> +	kmem_cache_free(vm_area_cachep, new_vma);
>> +	return NULL;
>>   }
>
>
> As I said previously, I have a concern about memory footprint.
> It adds anon_vma_chain and increases anon_vma's size for KSM.
>
> I think it will increase 3 times more than only anon_vma.
>
> Although you think it's not big in normal machine,
> it's not good in embedded system which is no anon_vma scalability issue
> and even no-swap. so I wanted you to make it configurable.

That is a fair point.  With CONFIG_SWAP=n we do not need the
anon_vma structs or anon_vma_chain structs at all.

I would be happy to integrate a patch into my series that
stubs out all of that code for CONFIG_SWAP=n, but I am going
to work on something else myself right now :)

-- 
All rights reversed.

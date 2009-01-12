Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbZALXUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbZALXUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZALXUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:20:25 -0500
Received: from smtp-out.google.com ([216.239.33.17]:35414 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbZALXUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:20:24 -0500
X-Greylist: delayed 891 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 18:20:24 EST
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=jJ+5u689jY1fEqbuVdmh22NvPjrrP1xh39R2QcJMJ/CvN9xz7GNvH81XPAJlURl9i
	muFBnbIhPJIIEKB7JNLrg==
Message-ID: <496BCCCF.70202@google.com>
Date: Mon, 12 Jan 2009 15:05:51 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ying Han <yinghan@google.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rohitseth@google.com
Subject: Re: [PATCH]Fix: 32bit binary has 64bit address of stack vma
References: <604427e00901051539x52ab85bcua94cd8036e5b619a@mail.gmail.com> <20090112145939.5ae28ada.akpm@linux-foundation.org>
In-Reply-To: <20090112145939.5ae28ada.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.85
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 5 Jan 2009 15:39:07 -0800
> Ying Han <yinghan@google.com> wrote:
> 
>> From: Ying Han <yinghan@google.com>
>>
>> Fix 32bit binary get 64bit stack vma offset.
>>
>> 32bit binary running on 64bit system, the /proc/pid/maps shows for the
>> vma represents stack get a 64bit adress:
>> ff96c000-ff981000 rwxp 7ffffffea000 00:00 0 [stack]
>>
>> Signed-off-by:	Ying Han <yinghan@google.com>
>>
>> fs/exec.c                     |    5 +-
>>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 4e834f1..8c3eff4 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -517,6 +517,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, uns
>>  	unsigned long length = old_end - old_start;
>>  	unsigned long new_start = old_start - shift;
>>  	unsigned long new_end = old_end - shift;
>> +	unsigned long new_pgoff = new_start >> PAGE_SHIFT;
>>  	struct mmu_gather *tlb;
>>
>>  	BUG_ON(new_start > new_end);
>> @@ -531,7 +532,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, uns
>>  	/*
>>  	 * cover the whole range: [new_start, old_end)
>>  	 */
>> -	vma_adjust(vma, new_start, old_end, vma->vm_pgoff, NULL);
>> +	vma_adjust(vma, new_start, old_end, new_pgoff, NULL);
>>
>>  	/*
>>  	 * move the page tables downwards, on failure we rely on
>> @@ -564,7 +565,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, uns
>>  	/*
>>  	 * shrink the vma to just the new range.
>>  	 */
>> -	vma_adjust(vma, new_start, new_end, vma->vm_pgoff, NULL);
>> +	vma_adjust(vma, new_start, new_end, new_pgoff, NULL);
>>
>>  	return 0;
> 
> I rewrote the chagnelog as below.  Please confirm that it makes sense?
> 
> 
> Subject: fs/exec.c: fix value of vma->vm_pgoff for the stack VMA of 32-bit processes
> From: Ying Han <yinghan@google.com>
> 
> With a 32 bit binary running on a 64 bit system, the /proc/pid/maps for
> the [stack] VMA displays a 64-bit address:
> 
> ff96c000-ff981000 rwxp 7ffffffea000 00:00 0 [stack]
> 
> This is because vma->vm_pgoff for that VMA is incorrectly being stored in
> units of offset-in-bytes.  It should be stored in units of offset-in-pages.
> 

The problem is that the offset was stored without taking into account 
the shift.

> Signed-off-by: Ying Han <yinghan@google.com>
> Cc: Mike Waychison <mikew@google.com>
> Cc: Hugh Dickins <hugh@veritas.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/exec.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff -puN fs/exec.c~fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes fs/exec.c
> --- a/fs/exec.c~fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes
> +++ a/fs/exec.c
> @@ -509,6 +509,7 @@ static int shift_arg_pages(struct vm_are
>  	unsigned long length = old_end - old_start;
>  	unsigned long new_start = old_start - shift;
>  	unsigned long new_end = old_end - shift;
> +	unsigned long new_pgoff = new_start >> PAGE_SHIFT;
>  	struct mmu_gather *tlb;
>  
>  	BUG_ON(new_start > new_end);
> @@ -523,7 +524,7 @@ static int shift_arg_pages(struct vm_are
>  	/*
>  	 * cover the whole range: [new_start, old_end)
>  	 */
> -	vma_adjust(vma, new_start, old_end, vma->vm_pgoff, NULL);
> +	vma_adjust(vma, new_start, old_end, new_pgoff, NULL);
>  
>  	/*
>  	 * move the page tables downwards, on failure we rely on
> @@ -556,7 +557,7 @@ static int shift_arg_pages(struct vm_are
>  	/*
>  	 * shrink the vma to just the new range.
>  	 */
> -	vma_adjust(vma, new_start, new_end, vma->vm_pgoff, NULL);
> +	vma_adjust(vma, new_start, new_end, new_pgoff, NULL);
>  
>  	return 0;
>  }
> _
> 


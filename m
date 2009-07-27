Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZG0WTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZG0WTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZG0WTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:19:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:1048 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZG0WTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:19:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hkUdbgQHhZfQj58ZuK07BgAmkTmhnNfVkJD3FKTPhY3x8flvHVwAMZIAGPQgWVJ2yr
         u2mB8P+HyDvA8DOcDi0zqB0lW+c6RxPGKn5eAyzsKrmsdS4QyQDmhrHdqVHUl698DO7O
         l3U/51s1NEIqk76W/N3uelNz9kvRoT288oT2M=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0907271339070.17425@chino.kir.corp.google.com>
References: <4A693122.6060503@gmail.com>
	 <20090724083926.GA6372@cr0.nay.redhat.com> <4A6E0BD6.50102@gmail.com>
	 <alpine.DEB.2.00.0907271339070.17425@chino.kir.corp.google.com>
Date: Mon, 27 Jul 2009 15:14:30 -0700
Message-ID: <7928e7bd0907271514y699d1de4j54f9c562b94ef0cc@mail.gmail.com>
Subject: Re: [PATCH 1/1] pagemap clear_refs: modify to specify anon or mapped 
	vma clearing
From: Moussa Ba <moussa.a.ba@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Matt Mackall <mpm@selenic.com>,
       Mel Gorman <mel@csn.ul.ie>, Ying Han <yinghan@google.com>,
       Nick Piggin <npiggin@suse.de>, jaredeh@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 1:57 PM, David Rientjes<rientjes@google.com> wrote:
> On Mon, 27 Jul 2009, Moussa A. Ba wrote:
>
>> This patch makes the clear_refs proc interface a bit more versatile.
>> It adds support  for clearing anonymous pages, file mapped pages or both.
>>
>
> It already has support for clearing both, so you're only adding anonymous
> and file-backed filters.
>
>> The clear_refs entry is used to reset the Referenced bits on virtual and
>> physical pages associated with a process.
>> echo 1 > /proc/PID/clear_refs clears all pages associated with the process
>> echo 2 > /proc/PID/clear_refs clears anonymous pages only
>> echo 3 > /proc/PID/clear_refs clears file mapped pages only
>> Any other value written to the proc entry will clear all pages.
>>
>
> clear_refs currently accepts any non-zero value, so it's possible that
> this will break user scripts that, for whatever reason, write '2' or '3'.
> I think that's acceptable, but it would be helpful to make all other
> values a no-op similar to drop_caches at this point to avoid the potential
> for breakage if this is ever extended any further.
>
>> Selective clearing the pages has a measurable impact on performance as it
>> limits the number of page walks.  We have been using this interface and  this
>> adds flexibility to the user user space application implementing the reference
>> clearing.
>>
>> Signed-off-by: Jared Hulbert (jaredeh@gmail.com)
>> Signed-off-by: Moussa A. Ba (moussa.a.ba@gmail.com)
>
> Email addresses in < > braces, please.
>
> The first sign-off line normally indicates who wrote the patch, but your
> submission lacks a From: line, so git would indicate you wrote it.  If
> that's incorrect, please add a From: line as described in
> Documentation/SubmittingPatches.  If it's correct, please reorder your
> sign-off lines.
>
I will reorder the sign-off lines
>> -------
>> Documentation/filesystems/proc.txt |    7 +++++++
>> fs/proc/task_mmu.c                 |   29 +++++++++++++++++++++++++----
>> 2 files changed, 32 insertions(+), 4 deletions(-)
>>
>> --- a/fs/proc/task_mmu.c      2009-07-21 14:30:01.000000000 -0700
>> +++ b/fs/proc/task_mmu.c      2009-07-27 11:46:05.000000000 -0700
>> @@ -462,6 +462,27 @@
>>       return 0;
>>  }
>>
>> +static void walk_vma_area(struct mm_walk *this_walk,
>> +                       struct vm_area_struct *vma, int type)
>> +{
>
> This is a very generic name for something that is only applicable to
> clear_refs, so please name it accordingly.  This will also avoid having to
> pass the struct mm_walk * in since its only user is clear_refs_walk.
>
Done.
>> +
>> +     /* Writing 2 to /proc/pid/clear_refs will clear all Anonymous
>> +      * pages.
>> +      *
>> +      * Writing 3 to /proc/pid/clear_refs will clear all file mapped
>> +      * pages.
>> +      *
>> +      * Writing any other value including 1 will clear all pages
>> +      */
>
> Documentation/CodingStyle would suggest this format:
>
>        /*
>         * Multi-line kernel comments always start ..
>         * with an empty first line.
>         */
>
Done.
>> +     if (is_vm_hugetlb_page(vma))
>> +             return;
>> +     if (type == 2 && vma->vm_file)
>> +             return;
>> +     if (type == 3 && !vma->vm_file)
>> +             return;
>> +     walk_page_range(vma->vm_start, vma->vm_end, this_walk);
>> +}
>
> K&R would suggest #define's (or enums) for those hard-coded values.  I
> think that's already been suggested for this patch, actually.
>

Would this be acceptable?

enum clear_refs_walk_type {
	CLEAR_REFS_ALL 	= 1,
	CLEAR_REFS_ANON = 2,
	CLEAR_REFS_MAPPED = 3
};

static void clear_refs_walk_vma_area(struct mm_walk *this_walk,
			  struct vm_area_struct *vma, enum clear_refs_walk_type type)
{

	/*
	 * Writing 1 to /proc/pid/clear_refs clears all pages.
	 * Writing 2 to /proc/pid/clear_refs clears Anonymous pages.
	 * Writing 3 to /proc/pid/clear_refs clears file mapped pages.
	 */
	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
		return;
	if (is_vm_hugetlb_page(vma))
		return;
	if (type == CLEAR_REFS_ANON && vma->vm_file)
		return;
	if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
		return;
	walk_page_range(vma->vm_start, vma->vm_end, this_walk);
}


>> +
>>  static ssize_t clear_refs_write(struct file *file, const char __user * buf,
>>                               size_t count, loff_t * ppos)
>>  {
>> @@ -469,13 +490,15 @@
>>       char buffer[PROC_NUMBUF], *end;
>>       struct mm_struct *mm;
>>       struct vm_area_struct *vma;
>> +     int type;
>>
>>       memset(buffer, 0, sizeof(buffer));
>>       if (count > sizeof(buffer) - 1)
>>               count = sizeof(buffer) - 1;
>>       if (copy_from_user(buffer, buf, count))
>>               return -EFAULT;
>> -     if (!simple_strtol(buffer, &end, 0))
>> +     type = strict_strtol(buffer, &end, 0);
>> +     if (!type)
>>               return -EINVAL;
>>       if (*end == '\n')
>>               end++;
>> @@ -491,9 +514,7 @@
>>               down_read(&mm->mmap_sem);
>>               for (vma = mm->mmap; vma; vma = vma->vm_next) {
>>                       clear_refs_walk.private = vma;
>> -                     if (!is_vm_hugetlb_page(vma))
>> -                             walk_page_range(vma->vm_start, vma->vm_end,
>> -                                             &clear_refs_walk);
>> +                     walk_vma_area(&clear_refs_walk, vma, type);
>>               }
>>               flush_tlb_mm(mm);
>>               up_read(&mm->mmap_sem);
>> --- a/Documentation/filesystems/proc.txt      2009-07-20 17:29:11.000000000
>> -0700
>> +++ b/Documentation/filesystems/proc.txt      2009-07-27 12:08:34.000000000
>> -0700
>> @@ -375,6 +375,13 @@
>>  This file is only present if the CONFIG_MMU kernel configuration option is
>>  enabled.
>>
>> +The clear_refs entry is used to reset the Referenced bits on virtual and physical
>> +pages associated with a process.
>> +echo 1 > /proc/PID/clear_refs clears all pages associated with the process
>> +echo 2 > /proc/PID/clear_refs clears anonymous pages only
>> +echo 3 > /proc/PID/clear_refs clears file mapped pages only
>> +Any other value written to the proc entry will clear all pages.
>> +
>
> Please follow the format in this document for how other /proc/PID/*
> entries are described.
>
> That format could really be improved here, perhaps you could clean
> proc.txt up a little bit while you're here?
>
>

I am not sure what you mean by "clean" proc.txt, I did not detect much
formatting in the PID proc enries description, beyond what I rewrote
below:


The /proc/PID/clear_refs is used to reset the Referenced bits on virtual and
physical pages associated with a process.
To clear all pages associated with the process
    > echo 1 > /proc/PID/clear_refs

To clear all anonymous pages associated with the process
    > echo 2 > /proc/PID/clear_refs

To clear all file mapped pages associated with the process
    > echo 3 > /proc/PID/clear_refs
Any other value written to /proc/PID/clear_refs will have no effect.


> Also, as the author of clear_refs, please cc me on future revisions of
> this patch.
>

I shall.

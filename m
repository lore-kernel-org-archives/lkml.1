Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbXJEDy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbXJEDy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 23:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbXJEDyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 23:54:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38665 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbXJEDys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 23:54:48 -0400
Message-ID: <4705B568.6020502@oracle.com>
Date: Fri, 05 Oct 2007 09:24:16 +0530
From: gurudas pai <gurudas.pai@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel BUG at arch/i386/mm/highmem.c:15!  on 2.6.23-rc8/rc9
References: <47048A0C.4020608@oracle.com> <200710040053.19570.nickpiggin@yahoo.com.au> <200710040139.04201.nickpiggin@yahoo.com.au> <4704BA1F.4070408@oracle.com> <Pine.LNX.4.64.0710041647090.17987@blonde.wat.veritas.com> <4705A63A.1090103@oracle.com>
In-Reply-To: <4705A63A.1090103@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

gurudas pai wrote:
> Hugh Dickins wrote:
>> On Thu, 4 Oct 2007, gurudas pai wrote:
>>> Nick Piggin wrote:
>>>>>> While running Oracle database test on x86/6GB RAM machine panics with
>>>>>> following messages.
>>>>> Hmm, seems like something in sys_remap_file_pages might have broken.
>>>>> It's a bit hard to work out from the backtrace, though.
>>>>>
>>>>> Is it possible you can strace to find the arguments for the
>>>>> remap_file_pages that goes wrong?
>>>> Ahh, I think it's just underflowing the preempt count somewhere, which
>>>> is leading highmem.c:15 to just *think* it is in an interrupt.
>>>>
>>>> But you aren't running a preemptible kernel, which makes it unusual...
>>>> it would have to be coming from interrupt code (or just random 
>>>> corruption).
>>>> Still, preempt debugging should catch those cases as well.
>>>>
>>>> So, can you disregard my last message, and instead compile a kernel
>>>> with CONFIG_PREEMPT and CONFIG_DEBUG_PREEMPT, and see what
>>>> messages come up?
>>> With CONFIG_PREEMPT and CONFIG_DEBUG_PREEMPT set I got following 
>>> messages on
>>> rc9.
>>>
>>> BUG: using smp_processor_id() in preemptible [00000001] code: 
>>> oracle/3631
>>> caller is kunmap_atomic+0xb/0x82
>>>  [<c04ec241>] debug_smp_processor_id+0xa1/0xb4
>>>  [<c0420dd0>] kunmap_atomic+0xb/0x82
>>>  [<c045fae3>] __do_fault+0x55/0x35b
>>>  [<c04623e8>] handle_mm_fault+0x4d0/0x909
>>>  [<c0460624>] follow_page+0x1d9/0x228
>>>  [<c0462a71>] get_user_pages+0x250/0x332
>>>  [<c0462bce>] make_pages_present+0x7b/0x90
>>>  [<c045f06a>] sys_remap_file_pages+0x2de/0x330
>>>  [<c0404f0e>] syscall_call+0x7/0xb
>>>  [<c0620000>] ioctl_standard_call+0x209/0x2ce
>>
>> Very helpful, thanks.  Guru, please try the appended patch, I think
>> you'll find it fixes it for you (it did for me, once I'd puzzled out
>> why I was failing to reproduce the problem - tests on ext3 don't work).
>> Thank you so much for reporting this just in time!
>>
>>
>> [PATCH] fix sys_remap_file_pages BUG at highmem.c:15!
>>
>> Gurudas Pai reports kernel BUG at arch/i386/mm/highmem.c:15! below
>> sys_remap_file_pages, while running Oracle database test on x86 in 6GB 
>> RAM:
>> kunmap thinks we're in_interrupt because the preempt count has wrapped.
>>
>> That's because __do_fault expected to unmap page_table, but one of its 
>> two
>> callers do_nonlinear_fault already unmapped it: let do_linear_fault unmap
>> it first too, and then there's no need to pass the page_table arg down.
>>
>> Why have we been so slow to notice this?  Probably through forgetting
>> that the mapping_cap_account_dirty test means that sys_remap_file_pages
>> nowadays only goes the full nonlinear vma route on a few memory-backed
>> filesystems like ramfs, tmpfs and hugetlbfs.
>>
>> Signed-off-by: Hugh Dickins <hugh@veritas.com>
>>
>> --- 2.6.23-rc9/mm/memory.c    2007-07-26 19:49:58.000000000 +0100
>> +++ linux/mm/memory.c    2007-10-04 15:42:20.000000000 +0100
>> @@ -2307,13 +2307,14 @@ oom:
>>   * do not need to flush old virtual caches or the TLB.
>>   *
>>   * We enter with non-exclusive mmap_sem (to exclude vma changes,
>> - * but allow concurrent faults), and pte mapped but not yet locked.
>> + * but allow concurrent faults), and pte neither mapped nor locked.
>>   * We return with mmap_sem still held, but pte unmapped and unlocked.
>>   */
>>  static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>> -        unsigned long address, pte_t *page_table, pmd_t *pmd,
>> +        unsigned long address, pmd_t *pmd,
>>          pgoff_t pgoff, unsigned int flags, pte_t orig_pte)
>>  {
>> +    pte_t *page_table;
>>      spinlock_t *ptl;
>>      struct page *page;
>>      pte_t entry;
>> @@ -2327,7 +2328,6 @@ static int __do_fault(struct mm_struct *
>>      vmf.flags = flags;
>>      vmf.page = NULL;
>>  
>> -    pte_unmap(page_table);
>>      BUG_ON(vma->vm_flags & VM_PFNMAP);
>>  
>>      if (likely(vma->vm_ops->fault)) {
>> @@ -2468,8 +2468,8 @@ static int do_linear_fault(struct mm_str
>>              - vma->vm_start) >> PAGE_CACHE_SHIFT) + vma->vm_pgoff;
>>      unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);
>>  
>> -    return __do_fault(mm, vma, address, page_table, pmd, pgoff,
>> -                            flags, orig_pte);
>> +    pte_unmap(page_table);
>> +    return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
>>  }
>>  
>>  
>> @@ -2552,9 +2552,7 @@ static int do_nonlinear_fault(struct mm_
>>      }
>>  
>>      pgoff = pte_to_pgoff(orig_pte);
>> -
>> -    return __do_fault(mm, vma, address, page_table, pmd, pgoff,
>> -                            flags, orig_pte);
>> +    return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
>>  }
>>  
>>  /*
> 
> Yes, indeed this patch worked for me , test completed successfully!! (on 
> preempt kernel). Will continue testing with non-preempt kernel and 
> update you if I hit any issue.

Completed testing on non-preempt successfully without any issue.

Thanks,
-Guru

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030Ab0AEE3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0AEE3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 23:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837Ab0AEE3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 23:29:42 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:36031 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab0AEE3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 23:29:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fSibsRqGeq2evnZcDWqQzo5nuD68vJ1X6pxX4wUG8MTtWH7BpKmpfErHvKgV3k4RRJ
         Hm/2+jNcSrMliU0S7AHyKHcJdGcp1bCNQOBePX+Q+YVCYsvAi7TEzth7WNnG3B0b3TXf
         NlgIG7vzq4s2QICtNFh9QP8Di0kjKwOj9+4TI=
MIME-Version: 1.0
In-Reply-To: <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100104182429.833180340@chello.nl>
	 <20100104182813.753545361@chello.nl>
	 <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 5 Jan 2010 13:29:40 +0900
Message-ID: <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kame.

On Tue, Jan 5, 2010 at 9:25 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Mon, 04 Jan 2010 19:24:35 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>> Generic speculative fault handler, tries to service a pagefault
>> without holding mmap_sem.
>>
>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
>
> I'm sorry if I miss something...how does this patch series avoid
> that vma is removed while __do_fault()->vma->vm_ops->fault() is called ?
> ("vma is removed" means all other things as freeing file struct etc..)

Isn't it protected by get_file and iget?
Am I miss something?

>
> Thanks,
> -Kame
>
>
>
>
>> ---
>>  include/linux/mm.h |    2 +
>>  mm/memory.c        |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 60 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6/mm/memory.c
>> ===================================================================
>> --- linux-2.6.orig/mm/memory.c
>> +++ linux-2.6/mm/memory.c
>> @@ -1998,7 +1998,7 @@ again:
>>       if (!*ptep)
>>               goto out;
>>
>> -     if (vma_is_dead(vma, seq))
>> +     if (vma && vma_is_dead(vma, seq))
>>               goto unlock;
>>
>>       unpin_page_tables();
>> @@ -3112,6 +3112,63 @@ int handle_mm_fault(struct mm_struct *mm
>>       return handle_pte_fault(mm, vma, address, entry, pmd, flags, 0);
>>  }
>>
>> +int handle_speculative_fault(struct mm_struct *mm, unsigned long address,
>> +             unsigned int flags)
>> +{
>> +     pmd_t *pmd = NULL;
>> +     pte_t *pte, entry;
>> +     spinlock_t *ptl;
>> +     struct vm_area_struct *vma;
>> +     unsigned int seq;
>> +     int ret = VM_FAULT_RETRY;
>> +     int dead;
>> +
>> +     __set_current_state(TASK_RUNNING);
>> +     flags |= FAULT_FLAG_SPECULATIVE;
>> +
>> +     count_vm_event(PGFAULT);
>> +
>> +     rcu_read_lock();
>> +     if (!pte_map_lock(mm, NULL, address, pmd, flags, 0, &pte, &ptl))
>> +             goto out_unlock;
>> +
>> +     vma = find_vma(mm, address);
>> +
>> +     if (!vma)
>> +             goto out_unmap;
>> +
>> +     dead = RB_EMPTY_NODE(&vma->vm_rb);
>> +     seq = vma->vm_sequence.sequence;
>> +     /*
>> +      * Matches both the wmb in write_seqcount_begin/end() and
>> +      * the wmb in detach_vmas_to_be_unmapped()/__unlink_vma().
>> +      */
>> +     smp_rmb();
>> +     if (dead || seq & 1)
>> +             goto out_unmap;
>> +
>> +     if (!(vma->vm_end > address && vma->vm_start <= address))
>> +             goto out_unmap;
>> +
>> +     if (read_seqcount_retry(&vma->vm_sequence, seq))
>> +             goto out_unmap;
>> +
>> +     entry = *pte;
>> +
>> +     pte_unmap_unlock(pte, ptl);
>> +
>> +     ret = handle_pte_fault(mm, vma, address, entry, pmd, flags, seq);
>> +
>> +out_unlock:
>> +     rcu_read_unlock();
>> +     return ret;
>> +
>> +out_unmap:
>> +     pte_unmap_unlock(pte, ptl);
>> +     goto out_unlock;
>> +}
>> +
>> +
>>  #ifndef __PAGETABLE_PUD_FOLDED
>>  /*
>>   * Allocate page upper directory.
>> Index: linux-2.6/include/linux/mm.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/mm.h
>> +++ linux-2.6/include/linux/mm.h
>> @@ -829,6 +829,8 @@ int invalidate_inode_page(struct page *p
>>  #ifdef CONFIG_MMU
>>  extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>>                       unsigned long address, unsigned int flags);
>> +extern int handle_speculative_fault(struct mm_struct *mm,
>> +                     unsigned long address, unsigned int flags);
>>  #else
>>  static inline int handle_mm_fault(struct mm_struct *mm,
>>                       struct vm_area_struct *vma, unsigned long address,
>>
>> --
>>
>>
>
>



-- 
Kind regards,
Minchan Kim

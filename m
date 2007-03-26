Return-Path: <linux-kernel-owner+w=401wt.eu-S933613AbXCZGH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613AbXCZGH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 02:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933617AbXCZGH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 02:07:58 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:51929 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933613AbXCZGH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 02:07:57 -0400
Message-ID: <4607713F.6010900@vmware.com>
Date: Sun, 25 Mar 2007 23:07:43 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 1/2] i386: add ptep_test_and_clear_{dirty,young}
References: <Pine.LNX.4.64.0703251731040.19025@chino.kir.corp.google.com> <Pine.LNX.4.64.0703260631150.15998@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0703260631150.15998@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Sun, 25 Mar 2007, David Rientjes wrote:
>   
>> Add ptep_test_and_clear_{dirty,young} to i386.  They advertise that they
>> have it and there is at least one place where it needs to be called
>> without the page table lock: to clear the accessed bit on write to
>>     
>
> Without the page table lock??
>
>   
>> /proc/pid/clear_refs.
>>
>> ptep_clear_flush_{dirty,young} are updated to use the new functions.  The
>> overall net effect to current users of ptep_clear_flush_{dirty,young} is
>> that we introduce an additional branch.
>>     
>
> We need to Cc Zach on this: git blame indicates it was he who replaced
> i386's ptep_test_and_clear_{dirty,young} by that "We don't actually
> have these" comment - it looks a bit as if what you want to do might
> violate the assumptions he wants to make, but I don't grasp it.
>
> Hugh
>
>   
>> Cc: Hugh Dickins <hugh@veritas.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Signed-off-by: David Rientjes <rientjes@google.com>
>> ---
>>  include/asm-i386/pgtable.h |   25 +++++++++++++++++--------
>>  1 files changed, 17 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/asm-i386/pgtable.h b/include/asm-i386/pgtable.h
>> --- a/include/asm-i386/pgtable.h
>> +++ b/include/asm-i386/pgtable.h
>> @@ -283,12 +283,23 @@ do {									\
>>  	}								\
>>  } while (0)
>>  
>> -/*
>> - * We don't actually have these, but we want to advertise them so that
>> - * we can encompass the flush here.
>> - */
>>  #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
>> +static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma,
>> +					    unsigned long addr, pte_t *ptep)
>> +{
>> +	if (!pte_dirty(*ptep))
>> +		return 0;
>>     
>> +	return test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low);
>> +}
>> +
>>     

If you actually clear the bit, you need to:

+         pte_update_defer(vma->vm_mm, addr, ptep);

The reason is, when updating PTEs, the hypervisor must be notified.  
Using atomic operations to do this is fine for all hypervisors I am 
aware of.  However, for hypervisors which shadow page tables, if these 
PTE modifications are not trapped, you need a post-modification call to 
fulfill the update of the shadow page table.

>>  #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
>> +static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>> +					    unsigned long addr, pte_t *ptep)
>> +{
>> +	if (!pte_young(*ptep))
>> +		return 0;
>> +	return test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low);
>> +}
>>     

Same here.

Hugh, thanks for the cc.

Zach

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYGKHFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYGKHFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 03:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYGKHFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 03:05:30 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:18597 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbYGKHF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 03:05:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QK0ZH9h+DRD02gIf8iZKbJJSP114KUt3+sl/u0LZRWLNEwdlyquNxqKg2u7xqDq6pz
         BVNv0Ue8eDjXBet0MXalaHpYeikA2+b0uc4KSXpfdaRpiXeuO55jj8rpyEQKH8HmK5XL
         Ii2pVSupT9CF0FCZQGefbq4o5CdX9G0PfLFuc=
Message-ID: <a8e1da0807110005h25ceeeabybeb2ad96e1abbb8e@mail.gmail.com>
Date: Fri, 11 Jul 2008 15:05:27 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] kernel parameter vmalloc size fix
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hpa@zytor.com,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <a8e1da0806261855l172a1e55k8bad10aa62e92521@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080616042528.GA3003@darkstar.te-china.tietoenator.com>
	 <20080616080131.GC25632@elte.hu>
	 <a8e1da0806232249s36eb90c7la517a40ccfe839ea@mail.gmail.com>
	 <20080626121430.GK29619@elte.hu>
	 <a8e1da0806261855l172a1e55k8bad10aa62e92521@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 9:55 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Thu, Jun 26, 2008 at 8:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Dave Young <hidave.darkstar@gmail.com> wrote:
>>
>>> I do some test about this last weekend, there's some questions, could
>>> you help to fix it?
>>>
>>> 1. MAXMEM :
>>>  (-__PAGE_OFFSET - __VMALLOC_RESERVE).
>>> The space after VMALLOC_END is included as well, seting it to
>>> (VMALLOC_END - PAGE_OFFSET - __VMALLOC_RESERVE), is it right?
>>>
>>> 2. VMALLOC_OFFSET is not considered in __VMALLOC_RESERVE
>>> Should fixed by adding VMALLOC_OFFSET to it.
>>>
>>> 3. VMALLOC_START :
>>>  (((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) & ~(VMALLOC_OFFSET - 1))
>>> So it's not always 8M, bigger than 8M possible.
>>> Set it to ((unsigned long)high_memory + VMALLOC_OFFSET), is it right?
>>>
>>> Attached the proposed patch. please give some advice.
>>
>> i've ported it to tip/master, see the patch below. Yinghai, what do you
>> think about this change?

What's the status of this? It's indeed a bug which can be easily reproduced.
Anyone care about it?

Is it necessary for me to send it again for review?

(Add andrew in cc, maybe it could be put into mm to test)
>
> Thanks. If there's no objections please add my signed-off line
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
>>
>>        Ingo
>>
>> ---
>>  arch/x86/mm/pgtable_32.c     |    3 ++-
>>  include/asm-x86/page_32.h    |    1 -
>>  include/asm-x86/pgtable_32.h |    5 +++--
>>  3 files changed, 5 insertions(+), 4 deletions(-)
>>
>> Index: tip/arch/x86/mm/pgtable_32.c
>> ===================================================================
>> --- tip.orig/arch/x86/mm/pgtable_32.c
>> +++ tip/arch/x86/mm/pgtable_32.c
>> @@ -171,7 +171,8 @@ static int __init parse_vmalloc(char *ar
>>        if (!arg)
>>                return -EINVAL;
>>
>> -       __VMALLOC_RESERVE = memparse(arg, &arg);
>> +       /* Add VMALLOC_OFFSET to the parsed value due to vm area guard hole*/
>> +       __VMALLOC_RESERVE = memparse(arg, &arg) + VMALLOC_OFFSET;
>>        return 0;
>>  }
>>  early_param("vmalloc", parse_vmalloc);
>> Index: tip/include/asm-x86/page_32.h
>> ===================================================================
>> --- tip.orig/include/asm-x86/page_32.h
>> +++ tip/include/asm-x86/page_32.h
>> @@ -95,7 +95,6 @@ extern unsigned int __VMALLOC_RESERVE;
>>  extern int sysctl_legacy_va_layout;
>>
>>  #define VMALLOC_RESERVE                ((unsigned long)__VMALLOC_RESERVE)
>> -#define MAXMEM                 (-__PAGE_OFFSET - __VMALLOC_RESERVE)
>>
>>  extern void find_low_pfn_range(void);
>>  extern unsigned long init_memory_mapping(unsigned long start,
>> Index: tip/include/asm-x86/pgtable_32.h
>> ===================================================================
>> --- tip.orig/include/asm-x86/pgtable_32.h
>> +++ tip/include/asm-x86/pgtable_32.h
>> @@ -56,8 +56,7 @@ void paging_init(void);
>>  * area for the same reason. ;)
>>  */
>>  #define VMALLOC_OFFSET (8 * 1024 * 1024)
>> -#define VMALLOC_START  (((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) \
>> -                        & ~(VMALLOC_OFFSET - 1))
>> +#define VMALLOC_START  ((unsigned long)high_memory + VMALLOC_OFFSET)
>>  #ifdef CONFIG_X86_PAE
>>  #define LAST_PKMAP 512
>>  #else
>> @@ -73,6 +72,8 @@ void paging_init(void);
>>  # define VMALLOC_END   (FIXADDR_START - 2 * PAGE_SIZE)
>>  #endif
>>
>> +#define MAXMEM (VMALLOC_END - PAGE_OFFSET - __VMALLOC_RESERVE)
>> +
>>  /*
>>  * Define this if things work differently on an i386 and an i486:
>>  * it will (on an i486) warn about kernel memory accesses that are
>>
>>
>
>
>
> --
> Regards
> dave
>

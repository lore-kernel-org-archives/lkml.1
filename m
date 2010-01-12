Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467Ab0ALAA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0ALAA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365Ab0ALAA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:00:59 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:65490 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab0ALAA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:00:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wD9K88hCnU3g4VPG+lhhS4EUfM+0pklqHsmmGLT0bdz9yA2aYBgRZSp78s7w8xT5Rb
         obBvysUzYZaXnwOi8hEBZxDVf4BpACNGsX+9ADWYc+pUpRtyOyY3LBnmsuyMgpROPgIR
         w3tK7GX/Q66QPg12JdEGq6cgUPM3Y9pwqF5fc=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1001112334250.7893@sister.anvils>
References: <20100111114607.1d8cd1e0.minchan.kim@barrios-desktop>
	 <alpine.LSU.2.00.1001112334250.7893@sister.anvils>
Date: Tue, 12 Jan 2010 09:00:57 +0900
Message-ID: <28c262361001111600k7cc377dchcfa0814410103b21@mail.gmail.com>
Subject: Re: [PATCH -mmotm-2010-01-06-14-34] Count minor fault in break_ksm
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Hugh.

On Tue, Jan 12, 2010 at 8:40 AM, Hugh Dickins
<hugh.dickins@tiscali.co.uk> wrote:
> On Mon, 11 Jan 2010, Minchan Kim wrote:
>
>> We have counted task's maj/min fault after handle_mm_fault.
>> break_ksm misses that.
>>
>> I wanted to check by VM_FAULT_ERROR.
>> But now break_ksm doesn't handle HWPOISON error.
>
> Sorry, no, I just don't see a good reason to add this.
> Imagine it this way: these aren't really faults, KSM simply
> happens to be using "handle_mm_fault" to achieve what it needs.

Why I suggest is handle_mm_fault counts PGFAULT in system.
If we want to get minor fault count in system, we have to calculate
(PGFAULT - PGMAJFAULT).

But we don't count it as either major or minor in this case and GUP case
I doubt it, then I see GUP already handled it tsk->[maj|min]flt.
Although it isn't my point, I thought break_ksm also have to count it
like GUP at least.

Okay. It's not real problem. I found just while I review the code.
I have no objection in your opinion.
But I think it would be better to have a consistency PGFAULT and PGMAJFAULT.


>
> (And, of course, if we did add something like this, I'd be
> disagreeing with you about which tsk's min_flt to increment.)
>
> Hugh
>
>>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
>> CC: Izik Eidus <ieidus@redhat.com>
>> ---
>>  mm/ksm.c |    6 +++++-
>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 56a0da1..3a1fda4 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -367,9 +367,13 @@ static int break_ksm(struct vm_area_struct *vma, unsigned long addr)
>>               page = follow_page(vma, addr, FOLL_GET);
>>               if (!page)
>>                       break;
>> -             if (PageKsm(page))
>> +             if (PageKsm(page)) {
>>                       ret = handle_mm_fault(vma->vm_mm, vma, addr,
>>                                                       FAULT_FLAG_WRITE);
>> +                     if (!(ret & (VM_FAULT_SIGBUS | VM_FAULT_OOM)
>> +                                     || current->flags & PF_KTHREAD))
>> +                             current->min_flt++;
>> +             }
>>               else
>>                       ret = VM_FAULT_WRITE;
>>               put_page(page);
>> --
>> 1.5.6.3
>>
>>
>>
>> --
>> Kind regards,
>> Minchan Kim
>



-- 
Kind regards,
Minchan Kim

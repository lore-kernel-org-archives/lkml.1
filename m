Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021Ab0A2AzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0A2AzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 19:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033Ab0A2AzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 19:55:15 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35046 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab0A2AzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 19:55:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aRWHkA62SwzRSSNgvczRwcz8vCYXpeg2yp7BXaWJ3E4/jNWpm7aSZPsfuuXd6cj8xe
         IxyjeqAUGs3BsMSO13LahKzYY1rmObtBXBmf42lCv+7VPFWB8y1ghzoRdvqYGfn80+uS
         t9aIKSplsB/O4IJ/DYpgSD+9blAVjft64XEkQ=
MIME-Version: 1.0
In-Reply-To: <4B61C83A.20301@redhat.com>
References: <20100128002000.2bf5e365@annuminas.surriel.com>
	 <1264696641.17063.32.camel@barrios-desktop>
	 <4B61C83A.20301@redhat.com>
Date: Fri, 29 Jan 2010 09:55:04 +0900
Message-ID: <28c262361001281655x70e5f77awf4d890d20f57ca83@mail.gmail.com>
Subject: Re: [PATCH -mm] change anon_vma linking to fix multi-process server 
	scalability issue
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       aarcange@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 2:24 AM, Rik van Riel <riel@redhat.com> wrote:
>>> -void vma_adjust(struct vm_area_struct *vma, unsigned long start,
>>> +int vma_adjust(struct vm_area_struct *vma, unsigned long start,
>>>        unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert)
>>>  {
>>>        struct mm_struct *mm = vma->vm_mm;
>>> @@ -542,6 +541,29 @@ again:                     remove_next = 1 + (end>
>>>  next->vm_end);
>>>                }
>>>        }
>>>
>>> +       /*
>>> +        * When changing only vma->vm_end, we don't really need
>>> +        * anon_vma lock.
>>> +        */
>>> +       if (vma->anon_vma&&  (insert || importer || start !=
>>> vma->vm_start))
>>> +               anon_vma = vma->anon_vma;
>>> +       if (anon_vma) {
>>> +               /*
>>> +                * Easily overlooked: when mprotect shifts the boundary,
>>> +                * make sure the expanding vma has anon_vma set if the
>>> +                * shrinking vma had, to cover any anon pages imported.
>>> +                */
>>> +               if (importer&&  !importer->anon_vma) {
>>> +                       /* Block reverse map lookups until things are set
>>> up. */
>>> +                       importer->vm_flags |= VM_LOCK_RMAP;
>>> +                       if (anon_vma_clone(importer, vma)) {
>>> +                               importer->vm_flags&= ~VM_LOCK_RMAP;
>>> +                               return -ENOMEM;
>>
>> If we fail in here during progressing on next vmas in case of mprotect
>> case 6,
>> the previous vmas would become inconsistent state.
>
> I've re-read the code, but I don't see what you are referring
> to.  If vma_adjust bails out early, no VMAs will be adjusted
> and all the VMAs will stay the way they were before mprotect
> was called.
>
> What am I overlooking?

I also look at the code more detail and found me wrong.
In mprotect case 6,  the importer is fixed as head of vmas while next
is marched
on forward. So anon_vma_clone is just called once at first time.
So as what you said, It's no problem.
Totally, my mistake. Sorry for that, Rik.

-- 
Kind regards,
Minchan Kim

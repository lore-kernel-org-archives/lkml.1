Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbZGNQsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbZGNQsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbZGNQsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:48:18 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:39185 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbZGNQsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:48:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ihvmPw0PRhzEA1vDLBC93IekKhQc9Yz+viBJDgmEzBEKk/vMMsUfXHCvUUyY3Qd+Tv
         jh2/wyU6KBssw9YOKPA78Sw8IiyfvcQiEQzwZUkrwMkDBZpxp7x3Xui1Glutru1MdOgw
         HjviPD675au30jvlFbi+yFT585P7jSibNn3OA=
MIME-Version: 1.0
In-Reply-To: <20090714161416.GA19147@cmpxchg.org>
References: <1247581340-20031-1-git-send-email-vapier@gentoo.org> 
	<20090714161416.GA19147@cmpxchg.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 14 Jul 2009 12:19:04 -0400
Message-ID: <8bd0f97a0907140919j645d03c3nac348d2106b63bef@mail.gmail.com>
Subject: Re: [PATCH] NOMMU: add support for Memory Protection Units (MPU)
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Bernd Schmidt <bernds_cb1@t-online.de>, Bryan Wu <cooloney@kernel.org>,
       David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 12:14, Johannes Weiner wrote:
> On Tue, Jul 14, 2009 at 10:22:20AM -0400, Mike Frysinger wrote:
>> --- a/mm/nommu.c
>> +++ b/mm/nommu.c
>> @@ -640,11 +641,23 @@ static void add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
>>       struct vm_area_struct *pvma, **pp;
>>       struct address_space *mapping;
>>       struct rb_node **p, *parent;
>> +#ifdef CONFIG_MPU
>> +     long start;
>> +#endif
>>
>>       kenter(",%p", vma);
>>
>>       BUG_ON(!vma->vm_region);
>>
>> +#ifdef CONFIG_MPU
>> +     start = vma->vm_start & PAGE_MASK;
>> +     while (start < vma->vm_end) {
>> +             protect_page(mm, start, vma->vm_flags);
>> +             start += PAGE_SIZE;
>> +     }
>> +     update_protections(mm);
>> +#endif
>> +
>>       mm->map_count++;
>>       vma->vm_mm = mm;
>>
>> @@ -707,9 +720,21 @@ static void delete_vma_from_mm(struct vm_area_struct *vma)
>>       struct vm_area_struct **pp;
>>       struct address_space *mapping;
>>       struct mm_struct *mm = vma->vm_mm;
>> +#ifdef CONFIG_MPU
>> +     long start;
>> +#endif
>>
>>       kenter("%p", vma);
>>
>> +#ifdef CONFIG_MPU
>> +     start = vma->vm_start & PAGE_MASK;
>> +     while (start < vma->vm_end) {
>> +             protect_page(mm, start, 0);
>> +             start += PAGE_SIZE;
>> +     }
>> +     update_protections(mm);
>> +#endif
>
> How about refactoring that into one function?  Saves all but one
> #ifdef.

makes sense to me, thanks
-mike

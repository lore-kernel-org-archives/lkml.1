Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYIOIfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYIOIfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 04:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbYIOIev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 04:34:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:20432 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbYIOIeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 04:34:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Pg5Je35s205eimwEi1ZjJbbZsTCH4EwsoVYkC08UXVmUtHKdz0NEW9FLtVlQ80sGin
         dbXX70nsSrx+1uygig8ukj5b0G8qhV4WVld/ipmIMXIn1+F577526kek+XwHamaeEk1y
         97bmdNOd7LRffs+VNeJoSpS50O4pKMwqCVoX0=
Message-ID: <86802c440809150134w3cd3f5baq2e99d2bb61b31a16@mail.gmail.com>
Date: Mon, 15 Sep 2008 01:34:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86-64: fix combining of regions in init_memory_mapping()
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com
In-Reply-To: <48CE3633.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48CA9C18.76E4.0078.0@novell.com>
	 <86802c440809141120v5f468775n81de6a29bbb89019@mail.gmail.com>
	 <48CE3633.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 1:17 AM, Jan Beulich <jbeulich@novell.com> wrote:
>>>> "Yinghai Lu" <yhlu.kernel@gmail.com> 14.09.08 20:20 >>>
>>On Fri, Sep 12, 2008 at 7:43 AM, Jan Beulich <jbeulich@novell.com> wrote:
>>> When nr_range gets decremented, the same slot must be considered for
>>> coalescing with its new successor again.
>>>
>>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>>>
>>> ---
>>>  arch/x86/mm/init_64.c |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> --- linux-2.6.27-rc6/arch/x86/mm/init_64.c      2008-08-29 10:53:00.000000000 +0200
>>> +++ 2.6.27-rc6-x86_64-mr-coalesce/arch/x86/mm/init_64.c 2008-09-12 11:58:45.000000000 +0200
>>> @@ -636,7 +636,7 @@ unsigned long __init_refok init_memory_m
>>>                old_start = mr[i].start;
>>>                memmove(&mr[i], &mr[i+1],
>>>                         (nr_range - 1 - i) * sizeof (struct map_range));
>>> -               mr[i].start = old_start;
>>> +               mr[i--].start = old_start;
>>>                nr_range--;
>>>        }
>>>
>>
>>this patch seems not right.
>>Ingo, please don't apply it.
>>
>>original code:
>>        /* try to merge same page size and continuous */
>>        for (i = 0; nr_range > 1 && i < nr_range - 1; i++) {
>>                unsigned long old_start;
>>                if (mr[i].end != mr[i+1].start ||
>>                    mr[i].page_size_mask != mr[i+1].page_size_mask)
>>                        continue;
>>                /* move it */
>>                old_start = mr[i].start;
>>                memmove(&mr[i], &mr[i+1],
>>                         (nr_range - 1 - i) * sizeof (struct map_range));
>>                mr[i].start = old_start;
>>                nr_range--;
>>        }
>>
>>so it save old_start and first, and move entries forward (so old one
>>is overwriten), and put back old_start ...
>
> Old and new code are not different in any way in this respect - both
> overwrite the old entry at index i with the entry at index i+1 and then
> set the start of the i-th entry back to what it was before the overwrite,
> effectively combining them. The patch just makes sure that the index
> isn't being updated at the same time as nr_range (because if you update
> both you effectively skip one).
>
> The issue is apparently pretty benign to native code, but surfaces as a
> boot time crash in our forward ported Xen tree (where the page table
> setup overall works differently than in native). Since the underlying
> issue was present in native (and since I assume if there is an attempt
> to merge subsequent regions, then it should work right), I nevertheless
> submitted the patch for native inclusion.

yes. your patch fixed the skip...

Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>

YH

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYIOIRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYIOIRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 04:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbYIOIQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 04:16:53 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16122 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYIOIQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 04:16:51 -0400
Message-Id: <48CE3633.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Mon, 15 Sep 2008 09:17:23 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: fix combining of regions in
	 init_memory_mapping()
References: <48CA9C18.76E4.0078.0@novell.com>
 <86802c440809141120v5f468775n81de6a29bbb89019@mail.gmail.com>
In-Reply-To: <86802c440809141120v5f468775n81de6a29bbb89019@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Yinghai Lu" <yhlu.kernel@gmail.com> 14.09.08 20:20 >>>
>On Fri, Sep 12, 2008 at 7:43 AM, Jan Beulich <jbeulich@novell.com> wrote:
>> When nr_range gets decremented, the same slot must be considered for
>> coalescing with its new successor again.
>>
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>>
>> ---
>>  arch/x86/mm/init_64.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- linux-2.6.27-rc6/arch/x86/mm/init_64.c      2008-08-29 10:53:00.000000000 +0200
>> +++ 2.6.27-rc6-x86_64-mr-coalesce/arch/x86/mm/init_64.c 2008-09-12 11:58:45.000000000 +0200
>> @@ -636,7 +636,7 @@ unsigned long __init_refok init_memory_m
>>                old_start = mr[i].start;
>>                memmove(&mr[i], &mr[i+1],
>>                         (nr_range - 1 - i) * sizeof (struct map_range));
>> -               mr[i].start = old_start;
>> +               mr[i--].start = old_start;
>>                nr_range--;
>>        }
>>
>
>this patch seems not right.
>Ingo, please don't apply it.
>
>original code:
>        /* try to merge same page size and continuous */
>        for (i = 0; nr_range > 1 && i < nr_range - 1; i++) {
>                unsigned long old_start;
>                if (mr[i].end != mr[i+1].start ||
>                    mr[i].page_size_mask != mr[i+1].page_size_mask)
>                        continue;
>                /* move it */
>                old_start = mr[i].start;
>                memmove(&mr[i], &mr[i+1],
>                         (nr_range - 1 - i) * sizeof (struct map_range));
>                mr[i].start = old_start;
>                nr_range--;
>        }
>
>so it save old_start and first, and move entries forward (so old one
>is overwriten), and put back old_start ...

Old and new code are not different in any way in this respect - both
overwrite the old entry at index i with the entry at index i+1 and then
set the start of the i-th entry back to what it was before the overwrite,
effectively combining them. The patch just makes sure that the index
isn't being updated at the same time as nr_range (because if you update
both you effectively skip one).

The issue is apparently pretty benign to native code, but surfaces as a
boot time crash in our forward ported Xen tree (where the page table
setup overall works differently than in native). Since the underlying
issue was present in native (and since I assume if there is an attempt
to merge subsequent regions, then it should work right), I nevertheless
submitted the patch for native inclusion.

Jan


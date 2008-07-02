Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbYGBAyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbYGBAyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 20:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYGBAyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 20:54:24 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:47113 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbYGBAyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 20:54:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q6+MXT2KULty/xxigB5E0/HuTxKUeoMAEaP6nbyznT4oFv8INUhZUk/B9yrQwCDa+L
         +oTr0evMQoUaNK8mBRCjjXmbhdMjpgqal6Mv19x/amk8v3amcOjAc7iSf1lAlzn8bf/U
         wjZ8TM+aSnyysf7Cv4tv+brbkjYFqCEaGpric=
Message-ID: <28c262360807011754l2300a5efr2701b446f1e17872@mail.gmail.com>
Date: Wed, 2 Jul 2008 09:54:22 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Rik van Riel" <riel@redhat.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [resend][PATCH -mm] split_lru: fix pagevec_move_tail() doesn't treat unevictable page
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <28c262360807011749i10a77640l4a1d33d5e627c866@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701155749.37F8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080701172223.3801.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080701093840.07b48ced@bree.surriel.com>
	 <28c262360807011739w5668920buf7880de6ed30f912@mail.gmail.com>
	 <28c262360807011749i10a77640l4a1d33d5e627c866@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So sorry to make a noisy . :-<

Gmail is mangling my mail.
I hope this is last.

 CPU1                                                           CPU2

 shm_unlock
 scan_mapping_unevictable_pages
 check_move_unevictable_page
 ClearPageUnevictable
                                                      rotate_reclaimable_page
							PageUnevictable(page) return 0

 SetPageUnevictable
 list_move(LRU_UNEVICTABLE)

                                                      local_irq_save
                                                      pagevec_move_tail



On Wed, Jul 2, 2008 at 9:49 AM, MinChan Kim <minchan.kim@gmail.com> wrote:
> Sorry, it seems mail sender problem.
> Resend
>
>  CPU1                                                           CPU2
>
>  shm_unlock
>  scan_mapping_unevictable_pages
>  check_move_unevictable_page
>  ClearPageUnevictable
>                                                      rotate_reclaimable_page
>
> PageUnevictable(page) return 0
>  SetPageUnevictable
>  list_move(LRU_UNEVICTABLE)
>
>                                                      local_irq_save
>                                                      pagevec_move_tail
>
>
> On Wed, Jul 2, 2008 at 9:39 AM, MinChan Kim <minchan.kim@gmail.com> wrote:
>> Hi, Rik and Kosaki-san
>>
>> I want to know exact race situation for remaining git log.
>> As you know, git log is important for me who is newbie to understand source
>>
>> There are many possibility in this race problem.
>>
>> Did you use hugepage in this test ?
>> I think that If you used hugepage, it seems to happen following race.
>>
>> --------------
>>
>> CPU1                                                           CPU2
>>
>> shm_unlock
>> scan_mapping_unevictable_pages
>> check_move_unevictable_page
>> ClearPageUnevictable                                 rotate_reclaimable_page
>>
>> PageUnevictable(page) return 0
>> SetPageUnevictable
>> list_move(LRU_UNEVICTABLE)
>>
>> local_irq_save
>>
>> pagevec_move_tail
>>
>> Do you think it is possible ?
>>
>> On Tue, Jul 1, 2008 at 10:38 PM, Rik van Riel <riel@redhat.com> wrote:
>>> On Tue, 01 Jul 2008 17:26:51 +0900
>>> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>>
>>>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>>
>>> Acked-by: Rik van Riel <riel@redhat.com>
>>>
>>> Good catch!
>>>
>>>> @@ -116,7 +116,7 @@ static void pagevec_move_tail(struct pag
>>>>                       zone = pagezone;
>>>>                       spin_lock(&zone->lru_lock);
>>>>               }
>>>> -             if (PageLRU(page) && !PageActive(page)) {
>>>> +             if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
>>>>                       int lru = page_is_file_cache(page);
>>>>                       list_move_tail(&page->lru, &zone->lru[lru].list);
>>>>                       pgmoved++;
>>>
>>> --
>>> All rights reversed.
>>>
>>
>>
>>
>> --
>> Kinds regards,
>> MinChan Kim
>>
>
>
>
> --
> Kinds regards,
> MinChan Kim
>



-- 
Kinds regards,
MinChan Kim

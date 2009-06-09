Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbZFILaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbZFILaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbZFIL37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:29:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:22357 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbZFIL36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZhLuKEsIfU4XB5+ia1DClL2aC7ZdjVpu8FsTzk0I16U3iBWbRoTsupMtzsM6MQ66zW
         U3SpZkg+UEL8zVrUJUUmSOoaAqayQoYyaMjgqlzl+lRkCOWsFlMH8jmXxkToVWTsPFh4
         8nOg3L2ZiIhCoSG3y7iz04XPv16INFt4DLJTY=
MIME-Version: 1.0
In-Reply-To: <e8f208a7c6bec1818947c24658dc1561.squirrel@webmail-b.css.fujitsu.com>
References: <20090609181505.4083a213.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262360906090300s13f4ee09mcc9622c1e477eaad@mail.gmail.com>
	 <e8f208a7c6bec1818947c24658dc1561.squirrel@webmail-b.css.fujitsu.com>
Date: Tue, 9 Jun 2009 20:30:00 +0900
Message-ID: <28c262360906090430p21125c51g10cfdc377a78d07b@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] fix wrong lru rotate back at lumpty reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/9 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
>
> Minchan Kim wrote:
>> On Tue, Jun 9, 2009 at 6:15 PM, KAMEZAWA
>> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>>
>>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>>
>>> In lumpty reclaim, "cursor_page" is found just by pfn. Then, we don't
>>> know
>>> from which LRU "cursor" page came from. Then, putback it to "src" list
>>> is BUG.
>>> Just leave it as it is.
>>> (And I think rotate here is overkilling even if "src" is correct.)
>>>
>>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>> ---
>>> mm/vmscan.c | 5 ++---
>>> 1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> Index: mmotm-2.6.30-Jun4/mm/vmscan.c
>>> ===================================================================
>>> --- mmotm-2.6.30-Jun4.orig/mm/vmscan.c
>>> +++ mmotm-2.6.30-Jun4/mm/vmscan.c
>>> @@ -940,10 +940,9 @@ static unsigned long isolate_lru_pages(u
>>> nr_taken++;
>>> scan++;
>>> break;
>>> -
>>>case -EBUSY:
>>
>> We can remove case -EBUSY itself, too.
>> It is meaningless.
>>
> Sure, will post v2 and remove EBUSY case.
> (I'm sorry my webmail system converts a space to a multibyte char...
>  then I cut some.)
>
>>> - /* else it is being freed
>>> elsewhere */
>>> -
>>> list_move(&cursor_page->lru, src);
>>> +  /* Do nothing because we
>>> don't know where
>>> + cusrsor_page comes
>>> from */
>>>default:
>>> break; /* ! on LRU or
>>> wrong list */
>>
>> Hmm.. what meaning of this break ?
>> We are in switch case.
>> This "break" can't go out of loop.
> yes.
>
>> But comment said "abort this block scan".
>>
> Where ? the comment says the cursor_page is not on lru (PG_lru is unset)

I mean follow as
 908         /*
 909          * Attempt to take all pages in the order aligned region
 910          * surrounding the tag page.  Only take those pages of
 911          * the same active state as that tag page.  We may safely
 912          * round the target page pfn down to the requested order
 913          * as the mem_map is guarenteed valid out to MAX_ORDER,
 914          * where that page is in a different zone we will detect
 915          * it from its zone id and abort this block scan.
 916          */
 917         zone_id = page_zone_id(page);


>> If I understand it properly , don't we add goto phrase ?
>>
> No.

If it is so, the break also is meaningless.

> Just try next page on list.
>
> Thank you for review, I'll post updated one tomorrow.
> -Kame
>
>



-- 
Kinds regards,
Minchan Kim

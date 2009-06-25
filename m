Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbZFYOoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbZFYOoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZFYOoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:44:08 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:28571 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbZFYOoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=emhi8PtGg0eD1rENAI5hB0MG7sdMm6RUpaeeKQ+qQA7ApMR9gCv3li2wu0i/7+YZZD
         5fUk0VpwibvHS6VI5k9ApHCVA/ig6V9kxeP+66fX+X/dGsG7i78H+VkEGgG2QPMarD4J
         pJpD8fmoDQiYsIiT/k5g9gnDc6tMdtFWb/IVc=
MIME-Version: 1.0
In-Reply-To: <2f11576a0906250714o5d77db11wd32c1c7139753cb5@mail.gmail.com>
References: <20090625183616.23b55b24.minchan.kim@barrios-desktop>
	 <2f11576a0906250714o5d77db11wd32c1c7139753cb5@mail.gmail.com>
Date: Thu, 25 Jun 2009 23:44:09 +0900
Message-ID: <28c262360906250744h5bf9f0a0w265d8c35e7d69335@mail.gmail.com>
Subject: Re: [PATCH] prevent to reclaim anon page of lumpy reclaim for no swap 
	space
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 11:14 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
>> This patch prevent to reclaim anon page in case of no swap space.
>> VM already prevent to reclaim anon page in various place.
>> But it doesnt't prevent it for lumpy reclaim.
>>
>> It shuffles lru list unnecessary so that it is pointless.
>
> NAK.
>
> 1. if system have no swap, add_to_swap() never get swap entry.
>   eary check don't improve performance so much.

Hmm. I mean no swap space but not no swap device.
add_to_swap ? You mean Rik pointed me out ?
If system have swap device, Rik's pointing is right.
I will update his suggestion.

> 2. __isolate_lru_page() is not only called lumpy reclaim case, but
> also be called
>    normal reclaim.

You mean about performance degradation ?
I think most case have enough swap space and then one condition
variable(nr_swap_page) check is trivial. I think.
We can also use [un]likely but I am not sure it help us.


> 3. if system have no swap, anon pages shuffuling doesn't cause any matter.

Again, I mean no swap space but no swap device system.
And I have a plan to remove anon_vma in no swap device system.

As you point me out, it's pointless in no swap device system.
I don't like unnecessary structure memory footprint and locking overhead.
I think no swap device system is problem in server environment as well
as embedded. but I am not sure when I will do. :)


> Then, I don't think this patch's benefit is bigger than side effect.
>
>
>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>  mm/vmscan.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 026f452..fb401fe 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -830,7 +830,13 @@ int __isolate_lru_page(struct page *page, int mode, int file)
>>         * When this function is being called for lumpy reclaim, we
>>         * initially look into all LRU pages, active, inactive and
>>         * unevictable; only give shrink_page_list evictable pages.
>> +
>> +        * If we don't have enough swap space, reclaiming of anon page
>> +        * is pointless.
>>         */
>> +       if (nr_swap_pages <= 0 && PageAnon(page))
>> +               return ret;
>> +
>>        if (PageUnevictable(page))
>>                return ret;
>>
>> --
>> 1.5.4.3
>>
>>
>>
>>
>> --
>> Kinds Regards
>> Minchan Kim
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
>



--
Kinds regards,
Minchan Kim

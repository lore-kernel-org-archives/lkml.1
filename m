Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbZDNMDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbZDNMDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZDNMCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:02:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:1980 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZDNMCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TU2ZkWAgM5WQ6SwAmUy/CvBu+aQVDOUcxzcSQIGjilKt3/ouORB2Sxp7QAZ2Ku6KxJ
         apLjJR+amd7AYr6RoUctYygMtjHc4Ur92aeC0WNJR5KEPzgpzWiduq9OEodbBTwTArhK
         jAjzbkgVil2/vG/4aIFQiEEfjn0YMMzSmQKng=
MIME-Version: 1.0
In-Reply-To: <200904141925.46012.nickpiggin@yahoo.com.au>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com>
	 <20090414151554.C64A.A69D9226@jp.fujitsu.com>
	 <200904141925.46012.nickpiggin@yahoo.com.au>
Date: Tue, 14 Apr 2009 21:02:47 +0900
X-Google-Sender-Auth: a061f372a1c222b6
Message-ID: <2f11576a0904140502h295faf33qcea9a39ff7f230a5@mail.gmail.com>
Subject: Re: [RFC][PATCH v3 1/6] mm: Don't unmap gup()ed page
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andrea Arcangeli <aarcange@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tuesday 14 April 2009 16:16:52 KOSAKI Motohiro wrote:
>
>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Sugessted-by: Linus Torvalds <torvalds@osdl.org>
>
> "Suggested-by:" ;)

Agghh, thanks.


>> @@ -547,7 +549,13 @@ int reuse_swap_page(struct page *page)
>>                       SetPageDirty(page);
>>               }
>>       }
>> -     return count == 1;
>> +
>> +     /*
>> +      * If we can re-use the swap page _and_ the end
>> +      * result has only one user (the mapping), then
>> +      * we reuse the whole page
>> +      */
>> +     return count + page_count(page) == 2;
>>  }
>
> I guess this patch does work to close the read-side race, but I slightly don't
> like using page_count for things like this. page_count can be temporarily
> raised for reasons other than access through their user mapping. Swapcache,
> page reclaim, LRU pagevecs, concurrent do_wp_page, etc.

Yes, that's trade-off.
your early decow also can misjudge and make unnecessary copy.



>>       /*
>> +      * Don't pull an anonymous page out from under get_user_pages.
>> +      * GUP carefully breaks COW and raises page count (while holding
>> +      * pte_lock, as we have here) to make sure that the page
>> +      * cannot be freed.  If we unmap that page here, a user write
>> +      * access to the virtual address will bring back the page, but
>> +      * its raised count will (ironically) be taken to mean it's not
>> +      * an exclusive swap page, do_wp_page will replace it by a copy
>> +      * page, and the user never get to see the data GUP was holding
>> +      * the original page for.
>> +      *
>> +      * This test is also useful for when swapoff (unuse_process) has
>> +      * to drop page lock: its reference to the page stops existing
>> +      * ptes from being unmapped, so swapoff can make progress.
>> +      */
>> +     if (PageSwapCache(page) &&
>> +         page_count(page) != page_mapcount(page) + 2) {
>> +             ret = SWAP_FAIL;
>> +             goto out_unmap;
>> +     }
>
> I guess it does add another constraint to the VM, ie. not allowed to
> unmap an anonymous page with elevated refcount. Maybe not a big deal
> now, but I think it is enough that it should be noted. If you squint,
> this could actually be more complex/intrusive to the wider VM than my
> copy on fork (which is basically exactly like a manual do_wp_page at
> fork time).

I agree this code effect widely kernel activity.
but actually, in past days, the kernel did the same behavior. then
almost core code is
page_count checking safe.

but Yes, we need to afraid newer code don't works with this code...


> And.... I don't think this is safe against a concurrent gup_fast()
> (which helps my point).

Could you please explain more detail ?

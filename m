Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZDNNkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZDNNkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZDNNj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:39:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:32912 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZDNNjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=F5bm4q8BO2zuFyF8XmEg5gTqqDd/SDHLWE+MPigsx0lveO2EjJUTXGdMpIBuXI8OiU
         lJ/xuaM9DHFk1CRIg+nQQHmobwmOXR8K8TAj+9Mm96srXYkJpNiHl3T4tUankbknV1bv
         67A0BFylbIOfaChPSfROlhod34oUVmMhdHZns=
MIME-Version: 1.0
In-Reply-To: <200904142225.10788.nickpiggin@yahoo.com.au>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com>
	 <200904141925.46012.nickpiggin@yahoo.com.au>
	 <2f11576a0904140502h295faf33qcea9a39ff7f230a5@mail.gmail.com>
	 <200904142225.10788.nickpiggin@yahoo.com.au>
Date: Tue, 14 Apr 2009 22:39:54 +0900
X-Google-Sender-Auth: ae0a55b4fab9f09f
Message-ID: <2f11576a0904140639l426e137ewdc46296cdb377dd@mail.gmail.com>
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

>> >> @@ -547,7 +549,13 @@ int reuse_swap_page(struct page *page)
>> >>                       SetPageDirty(page);
>> >>               }
>> >>       }
>> >> -     return count == 1;
>> >> +
>> >> +     /*
>> >> +      * If we can re-use the swap page _and_ the end
>> >> +      * result has only one user (the mapping), then
>> >> +      * we reuse the whole page
>> >> +      */
>> >> +     return count + page_count(page) == 2;
>> >>  }
>> >
>> > I guess this patch does work to close the read-side race, but I slightly don't
>> > like using page_count for things like this. page_count can be temporarily
>> > raised for reasons other than access through their user mapping. Swapcache,
>> > page reclaim, LRU pagevecs, concurrent do_wp_page, etc.
>>
>> Yes, that's trade-off.
>> your early decow also can misjudge and make unnecessary copy.
>
> Yes indeed it can. Although it would only ever do so in case of pages
> that have had get_user_pages run against them previously, and not from
> random interactions from any other parts of the kernel.

Agreed.

> I would be interested, using an anon vma field as you say for keeping
> a gup count... it could potentially be used to avoid the extra copy.
> But hmm, I don't have much time to go down that path so long as the
> basic concept of my proposal is in question.

ok, I try to make it. thanks.

> +     if (PageSwapCache(page) &&
> +         page_count(page) != page_mapcount(page) + 2) {
> +             ret = SWAP_FAIL;
> +             goto out_unmap;
> +     }
>
> Now if another thread does a get_user_pages_fast after it passes this
> check, it can take a gup reference to the page which is now about to
> be unmapped. Then after it is unmapped, if a wp fault is caused on the
> page, then it will not be reused and thus you lose data as explained
> in your big comment.

Grrr, I lose. I've misunderstood get_user_pages_fast() also grab pte_lock.
I must think it again.

I guess you dislike get_user_page_fast() grab pte_lock too, right?

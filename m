Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbZJCN4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbZJCN4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932171AbZJCN4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:56:53 -0400
Received: from mail-iw0-f190.google.com ([209.85.223.190]:49776 "EHLO
	mail-iw0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbZJCN4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=v4Te36z4e0rA4VYV4KLyst3mqk6v0scSqMM/uIeaPtw5UJyts7828EAGD5v41tKZ1+
         Z3aLgoD8yObE/iiCzykR3W/W/o/Mt59FuyTHRtIyCe91LCPxfiycbLQaOHHaoc5cd6Ze
         SZ7KO6SxK6xSZSgiChW1+7o+yHmd68vvSiFVU=
MIME-Version: 1.0
In-Reply-To: <20091002233837.GA3638@cmpxchg.org>
References: <1254344964-8124-1-git-send-email-hannes@cmpxchg.org>
	 <1254344964-8124-3-git-send-email-hannes@cmpxchg.org>
	 <20091002100838.5F5A.A69D9226@jp.fujitsu.com>
	 <20091002233837.GA3638@cmpxchg.org>
Date: Sat, 3 Oct 2009 22:56:55 +0900
X-Google-Sender-Auth: b003227a757a9889
Message-ID: <2f11576a0910030656l73c9811w18e0f224fb3d98af@mail.gmail.com>
Subject: Re: [rfc patch 3/3] mm: munlock COW pages on truncation unmap
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Umm..
>> I haven't understand this.
>>
>> (1) unmap_mapping_range() is called twice.
>>
>>       unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
>>       truncate_inode_pages(mapping, new);
>>       unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
>>
>> (2) PG_mlock is turned on from mlock() and vmscan.
>> (3) vmscan grab anon_vma, but mlock don't grab anon_vma.
>
> You are right, I was so focused on the LRU side that I missed an
> obvious window here: an _explicit_ mlock can still happen between the
> PG_mlocked clearing section and releasing the page.
>
> If we race with it, the put_page() in __mlock_vma_pages_range() might
> free the freshly mlocked page.
>
>> (4) after truncate_inode_pages(), we don't need to think vs-COW, because
>>     find_get_page() never success. but first unmap_mapping_range()
>>     have vs-COW racing.
>
> Yes, we can race with COW breaking, but I can not see a problem there.
> It clears the old page's mlock, but also with an atomic
> TestClearPageMlocked().  And the new page is mapped and mlocked under
> pte lock and only if we didn't clear the pte in the meantime.

Ah, You are right.


>> So, Is anon_vma grabbing really sufficient?
>
> No, the explicit mlocking race exists, I think.
>
>> Or, you intent to the following?
>>
>>       unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 0);
>>       truncate_inode_pages(mapping, new);
>>       unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
>
> As mentioned above, I don't see how it would make a difference.

Yes, sorry. please forget this.


>> > @@ -544,6 +544,13 @@ redo:
>> >              */
>> >             lru = LRU_UNEVICTABLE;
>> >             add_page_to_unevictable_list(page);
>> > +           /*
>> > +            * See the TestClearPageMlocked() in zap_pte_range():
>> > +            * if a racing unmapper did not see the above setting
>> > +            * of PG_lru, we must see its clearing of PG_locked
>> > +            * and move the page back to the evictable list.
>> > +            */
>> > +           smp_mb();
>> >     }
>>
>> add_page_to_unevictable() have a spin lock. Why do we need additionl
>> explicit memory barrier?
>
> It sets PG_lru under spinlock and tests PG_mlocked after the unlock.
> The following sections from memory-barriers.txt made me nervous:
>
>  (5) LOCK operations.
>
>     This acts as a one-way permeable barrier.  It guarantees that all memory
>     operations after the LOCK operation will appear to happen after the LOCK
>     operation with respect to the other components of the system.
>
>  (6) UNLOCK operations.
>
>     This also acts as a one-way permeable barrier.  It guarantees that all
>     memory operations before the UNLOCK operation will appear to happen before
>     the UNLOCK operation with respect to the other components of the system.
>
>     Memory operations that occur after an UNLOCK operation may appear to
>     happen before it completes.
>
> So the only garuantee this gives us is that both PG_lru setting and
> PG_mlocked testing happen after LOCK and PG_lru setting finishes
> before UNLOCK, no?  I wanted to make sure this does not happen:
>
>        LOCK, test PG_mlocked, set PG_lru, UNLOCK
>
> I don't know whether there is a data dependency between those two
> operations.  They go to the same word, but I could also imagine
> setting one bit is independent of reading another one.  Humm.  Help.

Ahh, Yes! you are right.
We really need this barrier.

However, I think this issue doesn't depend on zap_pte_range patch.
Other TestClearPageMlocked(page) caller have the same problem, because
putback_lru_page() doesn't have any exclusion, right?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790Ab0COHLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 03:11:34 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:59074 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363Ab0COHLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 03:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bc3UKwRnTbm+NAruvogCF8NsQlPKHD+vua4iZSA1fALFqVH9uHSMhQtw46aOXK46eC
         Lf1aRewxYEgO5c7ecC1xnPl8vnDCouEFhbegYCCVBirxReCDAomnxCo3FMId0ZfcshMX
         wc0cIdxteH7mFXBu4jKIcuZuxq1N45gi41fzM=
MIME-Version: 1.0
In-Reply-To: <20100315154459.c665f68d.kamezawa.hiroyu@jp.fujitsu.com>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
	 <1268412087-13536-3-git-send-email-mel@csn.ul.ie>
	 <28c262361003141728g4aa40901hb040144c5a4aeeed@mail.gmail.com>
	 <20100315143420.6ec3bdf9.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262361003142328w610f0478sbc17880ffa454fe8@mail.gmail.com>
	 <20100315154459.c665f68d.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 15 Mar 2010 16:11:31 +0900
Message-ID: <28c262361003150011u4525f6aas9c47760bf9c8faef@mail.gmail.com>
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped 
	anonymous pages
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 3:44 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com>
>> Thanks for detail explanation, Kame.
>> But it can't understand me enough, Sorry.
>>
>> Mel said he met "use-after-free errors in anon_vma".
>> So added the check in unmap_and_move.
>>
>> if (PageAnon(page)) {
>>  ....
>>  if (!page_mapcount(page))
>>    goto uncharge;
>>  rcu_read_lock();
>>
>> My concern what protects racy mapcount of the page?
>> For example,
>>
>> CPU A                                 CPU B
>> unmap_and_move
>> page_mapcount check pass    zap_pte_range
>> <-- some stall -->                   pte_lock
>> <-- some stall -->                   page_remove_rmap(map_count is zero!)
>> <-- some stall -->                   pte_unlock
>> <-- some stall -->                   anon_vma_unlink
>> <-- some stall -->                   anon_vma free !!!!
>> rcu_read_lock
>> anon_vma has gone!!
>>
>> I think above scenario make error "use-after-free", again.
>> What prevent above scenario?
>>
> I think this patch is not complete.
> I guess this patch in [1/11] is trigger for the race.
> ==
> +
> +       /* Drop an anon_vma reference if we took one */
> +       if (anon_vma && atomic_dec_and_lock(&anon_vma->migrate_refcount, &anon_vma->lock)) {
> +               int empty = list_empty(&anon_vma->head);
> +               spin_unlock(&anon_vma->lock);
> +               if (empty)
> +                       anon_vma_free(anon_vma);
> +       }
> ==
> If my understainding in above is correct, this "modify" freed anon_vma.
> Then, use-after-free happens. (In old implementation, there are no refcnt,
> so, there is no use-after-free ops.)
>

I agree.
Let's wait Mel's response.

>
> So, what I can think of now is a patch like following is necessary.
>
> ==
> static inline struct anon_vma *anon_vma_alloc(void)
> {
>        struct anon_vma *anon_vma;
>        anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
>        atomic_set(&anon_vma->refcnt, 1);
> }
>
> void anon_vma_free(struct anon_vma *anon_vma)
> {
>        /*
>         * This called when anon_vma is..
>         * - anon_vma->vma_list becomes empty.
>         * - incremetned refcnt while migration, ksm etc.. is dropped.
>         * - allocated but unused.
>         */
>        if (atomic_dec_and_test(&anon_vma->refcnt))
>                kmem_cache_free(anon_vma_cachep, anon_vma);
> }
> ==
> Then all things will go simple.
> Overhead is concern but list_empty() helps us much.

When they made things complicated without atomic_op,
there was reasonable reason, I think. :)

My opinion depends on you and server guys(Hugh, Rik, Andrea Arcangeli and so on)


>
> Thanks,
> -Kame
>
>
>
>
>



-- 
Kind regards,
Minchan Kim

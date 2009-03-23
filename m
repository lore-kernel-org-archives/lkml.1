Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbZCWAo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbZCWAo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 20:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbZCWAop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 20:44:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:1145 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZCWAoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 20:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K0ZEF5jGQuXzIyihTpXUoOJvpAL2y1rLVPSkvlHJuYIqPXFNFZUU7PhJlxY4IM6SSv
         CjGPTb3ynk5bqE8rxhhYMHuCpHetCe3hG76WAv9dWu46TJKAAT1y5seD/hSDqtKmgY2V
         /o9XayJ5omguQ+qqsZNSXNs2sd2oLtvr0akMg=
MIME-Version: 1.0
In-Reply-To: <1237752784-1989-3-git-send-email-hannes@cmpxchg.org>
References: <20090321102044.GA3427@cmpxchg.org>
	 <1237752784-1989-3-git-send-email-hannes@cmpxchg.org>
Date: Mon, 23 Mar 2009 09:44:42 +0900
Message-ID: <28c262360903221744r6d275294gdc8ad3a12b8c5361@mail.gmail.com>
Subject: Re: [patch 3/3] mm: keep pages from unevictable mappings off the LRU 
	lists
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Howells <dhowells@redhat.com>,
       Nick Piggin <npiggin@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm,,

This patch is another thing unlike previous series patches.
Firstly, It looked good to me.

I think add_to_page_cache_lru have to become a fast path.
But, how often would ramfs and shmem function be called ?

I have a concern for this patch to add another burden.
so, we need any numbers for getting pros and cons.

Any thoughts ?

On Mon, Mar 23, 2009 at 5:13 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Check if the mapping is evictable when initially adding page cache
> pages to the LRU lists.  If that is not the case, add them to the
> unevictable list immediately instead of leaving it up to the reclaim
> code to move them there.
>
> This is useful for ramfs and locked shmem which mark whole mappings as
> unevictable and we know at fault time already that it is useless to
> try reclaiming these pages.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.com>
> Cc: MinChan Kim <minchan.kim@gmail.com>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> ---
>  mm/filemap.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 23acefe..8574530 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -506,7 +506,9 @@ int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
>
>        ret = add_to_page_cache(page, mapping, offset, gfp_mask);
>        if (ret == 0) {
> -               if (page_is_file_cache(page))
> +               if (mapping_unevictable(mapping))
> +                       add_page_to_unevictable_list(page);
> +               else if (page_is_file_cache(page))
>                        lru_cache_add_file(page);
>                else
>                        lru_cache_add_active_anon(page);
> --
> 1.6.2.1.135.gde769
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kinds regards,
Minchan Kim

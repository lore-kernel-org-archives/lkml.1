Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYHMOPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYHMOPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbYHMOOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:14:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:5123 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbYHMOOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:14:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=q4KX6Uo1LwNYbw2Uw7TKxyhDENOf0GEkCpekKutAJ+u65gN5C/S3G1q8Y865xJEna2
         CEtHJl3VAyGQLQ1ZxpVGnVFu+hqk50YhgcfdRmiY1dfo/Ta11+CD69gsTDM1lKDe+NWf
         JmHlwPYagaaV+qXVBbRBIuAJYxB35vEGFR9qs=
Message-ID: <2f11576a0808130714k2cd031c4nd6eea3506831cac9@mail.gmail.com>
Date: Wed, 13 Aug 2008 23:14:30 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: No, really, stop trying to delete slab until you've finished making slub perform as well
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Mel Gorman" <mel@skynet.ie>,
       andi@firstfloor.org, "Rik van Riel" <riel@redhat.com>
In-Reply-To: <48A2DD2C.3090602@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48986AC6.5030406@linux-foundation.org>
	 <20080813194222.E77F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48A2DD2C.3090602@linux-foundation.org>
X-Google-Sender-Auth: 30ae8c6dae6363e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> :t-0000128               28739     128     1.3G  20984/20984/8  512 0  99   0 *
>
> Argh. Most slabs contain a single object. Probably due to the conflict resolution.

agreed with the issue exist in lock contention code.


> The obvious fix is to avoid allocating another slab on conflict but how will
> this impact performance?
>
>
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c    2008-08-13 08:06:00.000000000 -0500
> +++ linux-2.6/mm/slub.c 2008-08-13 08:07:59.000000000 -0500
> @@ -1253,13 +1253,11 @@
>  static inline int lock_and_freeze_slab(struct kmem_cache_node *n,
>                                                        struct page *page)
>  {
> -       if (slab_trylock(page)) {
> -               list_del(&page->lru);
> -               n->nr_partial--;
> -               __SetPageSlubFrozen(page);
> -               return 1;
> -       }
> -       return 0;
> +       slab_lock(page);
> +       list_del(&page->lru);
> +       n->nr_partial--;
> +       __SetPageSlubFrozen(page);
> +       return 1;
>  }

I don't mesure it yet. I don't like this patch.
maybe, it decrease other typical benchmark.

So, I think better way is

1. slab_trylock(), if success goto 10.
2. check fragmentation ratio, if low goto 10
3. slab_lock()
10. return func

I think this way doesn't cause performance regression.
because high fragmentation cause defrag and compaction lately.
So, prevent fragmentation often increase performance.

Thought?

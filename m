Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbYHNHTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbYHNHTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 03:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYHNHTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 03:19:00 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36674 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYHNHS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 03:18:59 -0400
Message-ID: <48A3DBAC.6010109@cs.helsinki.fi>
Date: Thu, 14 Aug 2008 10:15:56 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48986AC6.5030406@linux-foundation.org> <20080813194222.E77F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48A2DD2C.3090602@linux-foundation.org>
In-Reply-To: <48A2DD2C.3090602@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Lameter wrote:
> The obvious fix is to avoid allocating another slab on conflict but how will
> this impact performance?
> 
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2008-08-13 08:06:00.000000000 -0500
> +++ linux-2.6/mm/slub.c	2008-08-13 08:07:59.000000000 -0500
> @@ -1253,13 +1253,11 @@
>  static inline int lock_and_freeze_slab(struct kmem_cache_node *n,
>  							struct page *page)
>  {
> -	if (slab_trylock(page)) {
> -		list_del(&page->lru);
> -		n->nr_partial--;
> -		__SetPageSlubFrozen(page);
> -		return 1;
> -	}
> -	return 0;
> +	slab_lock(page);
> +	list_del(&page->lru);
> +	n->nr_partial--;
> +	__SetPageSlubFrozen(page);
> +	return 1;
>  }

This patch hard locks  on my 2-way 64-bit x86 machine (sysrq doesn't 
respond) when I run hackbench.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYHMNLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYHMNLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYHMNLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:11:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338AbYHMNLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:11:00 -0400
Message-ID: <48A2DD2C.3090602@linux-foundation.org>
Date: Wed, 13 Aug 2008 08:10:04 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48986AC6.5030406@linux-foundation.org> <20080813194222.E77F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080813194222.E77F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:


> <SLUB>
> 
> % cat /proc/meminfo
>
> Slab:            1591680 kB
> SReclaimable:      12608 kB
> SUnreclaim:      1579072 kB

Unreclaimable grew very big.


> :t-0000128               28739     128     1.3G  20984/20984/8  512 0  99   0 *

Argh. Most slabs contain a single object. Probably due to the conflict resolution.


> kmalloc-192               4609     192    85.9M    1303/1303/8  341 0  99   1

And a similar but not so severe issue here.

The obvious fix is to avoid allocating another slab on conflict but how will
this impact performance?


Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-08-13 08:06:00.000000000 -0500
+++ linux-2.6/mm/slub.c	2008-08-13 08:07:59.000000000 -0500
@@ -1253,13 +1253,11 @@
 static inline int lock_and_freeze_slab(struct kmem_cache_node *n,
 							struct page *page)
 {
-	if (slab_trylock(page)) {
-		list_del(&page->lru);
-		n->nr_partial--;
-		__SetPageSlubFrozen(page);
-		return 1;
-	}
-	return 0;
+	slab_lock(page);
+	list_del(&page->lru);
+	n->nr_partial--;
+	__SetPageSlubFrozen(page);
+	return 1;
 }


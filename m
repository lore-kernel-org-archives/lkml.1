Return-Path: <linux-kernel-owner+w=401wt.eu-S1031492AbXFHTjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031492AbXFHTjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbXFHTiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:38:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59250 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752170AbXFHTix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:38:53 -0400
Date: Fri, 8 Jun 2007 12:38:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 00/12] Slab defragmentation V3
In-Reply-To: <4669AED3.8020204@googlemail.com>
Message-ID: <Pine.LNX.4.64.0706081238001.2420@schroedinger.engr.sgi.com>
References: <20070607215529.147027769@sgi.com>  <466999A2.8020608@googlemail.com>
  <Pine.LNX.4.64.0706081110580.1464@schroedinger.engr.sgi.com>
 <6bffcb0e0706081156u4ad0cc9dkf6d55ebcbd79def2@mail.gmail.com>
 <Pine.LNX.4.64.0706081207400.2082@schroedinger.engr.sgi.com>
 <4669AED3.8020204@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Michal Piotrowski wrote:

> 0xc1081630 is in list_locations (mm/slub.c:3388).
> 3383                    struct page *page;
> 3384
> 3385                    if (!atomic_read(&n->nr_slabs))
> 3386                            continue;
> 3387
> 3388                    spin_lock_irqsave(&n->list_lock, flags);
> 3389                    list_for_each_entry(page, &n->partial, lru)
> 3390                            process_slab(&t, s, page, alloc);
> 3391                    list_for_each_entry(page, &n->full, lru)
> 3392                            process_slab(&t, s, page, alloc);


Yes process slab needs some temporary data to generate the lists of 
functions calling etc and that is a GFP_TEMPORARY alloc.

Does this fix it?

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-06-08 12:35:56.000000000 -0700
+++ slub/mm/slub.c	2007-06-08 12:37:32.000000000 -0700
@@ -2930,7 +2930,7 @@ static int alloc_loc_track(struct loc_tr
 
 	order = get_order(sizeof(struct location) * max);
 
-	l = (void *)__get_free_pages(GFP_TEMPORARY, order);
+	l = (void *)__get_free_pages(GFP_ATOMIC, order);
 
 	if (!l)
 		return 0;

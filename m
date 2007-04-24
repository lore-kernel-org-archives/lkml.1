Return-Path: <linux-kernel-owner+w=401wt.eu-S1161721AbXDXLux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161721AbXDXLux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 07:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161723AbXDXLux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 07:50:53 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:40365 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161721AbXDXLux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 07:50:53 -0400
Date: Tue, 24 Apr 2007 12:50:50 +0100
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, tony.luck@intel.com,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix parsing kernelcore boot option for ia64
Message-ID: <20070424115050.GA9372@skynet.ie>
References: <20070423183246.GA11841@skynet.ie> <20070423183637.GA11982@skynet.ie> <20070424183847.FD98.Y-GOTO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070424183847.FD98.Y-GOTO@jp.fujitsu.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (24/04/07 18:58), Yasunori Goto didst pronounce:
> 
> 
> > Subject: Check zone boundaries when freeing bootmem
> > Zone boundaries do not have to be aligned to MAX_ORDER_NR_PAGES. 
> 
> Hmm. I don't understand here yet... Could you explain more? 
> 
> This issue occurs only when ZONE_MOVABLE is specified.
> If its boundary is aligned to MAX_ORDER automatically,
> I guess user will not mind it.
> 
> From memory hotplug view, I prefer section size alignment to make
> simple code. :-P
 
How does this look to you?


======
The two potential users of ZONE_MOVABLE would prefer if the zone was aligned
to a boundary. This patch aligns the zone to a MAX_ORDER_NR_PAGES boundary.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc6-mm1-002_commonparse/mm/page_alloc.c linux-2.6.21-rc6-mm1-003_alignmovable/mm/page_alloc.c
--- linux-2.6.21-rc6-mm1-002_commonparse/mm/page_alloc.c	2007-04-24 09:38:30.000000000 +0100
+++ linux-2.6.21-rc6-mm1-003_alignmovable/mm/page_alloc.c	2007-04-24 11:15:40.000000000 +0100
@@ -3642,6 +3642,11 @@ restart:
 	usable_nodes--;
 	if (usable_nodes && required_kernelcore > usable_nodes)
 		goto restart;
+	
+	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
+	for (nid = 0; nid < MAX_NUMNODES; nid++)
+		zone_movable_pfn[nid] =
+			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
 }
 
 /**
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

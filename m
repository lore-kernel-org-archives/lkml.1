Return-Path: <linux-kernel-owner+w=401wt.eu-S1760038AbYFKSub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbYFKSub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758073AbYFKSre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:47:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758038AbYFKSr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:47:29 -0400
Message-Id: <20080611184339.290398067@redhat.com>
References: <20080611184214.605110868@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 14:42:22 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Martin Bligh <mbligh@mbligh.org>
Subject: [PATCH -mm 08/24] vmscan: fix pagecache reclaim referenced bit check
Content-Disposition: inline; filename=vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

The -mm tree contains the patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
which gives referenced pagecache pages another trip around
the active list.  This seems to help keep frequently accessed
pagecache pages in memory.

However, it means that pagecache pages that get moved to the
inactive list do not have their referenced bit set, and the
next access to the page will not get it moved back to the active
list.  This patch sets the referenced bit on pagecache pages
that get deactivated, so the next access to the page will promote
it back to the active list.

This works because shrink_page_list() will reclaim unmapped
pages with the referenced bit set.

Signed-off-by: Rik van Riel <riel@redhat.com>

---
 mm/vmscan.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc5-mm2/mm/vmscan.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/vmscan.c	2008-06-10 13:35:58.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/vmscan.c	2008-06-10 13:40:19.000000000 -0400
@@ -1070,8 +1070,16 @@ static void shrink_active_list(unsigned 
 				/* Anonymous pages always get deactivated. */
 				list_add(&page->lru, &l_inactive);
 			}
-		} else
+		} else {
 			list_add(&page->lru, &l_inactive);
+			if (!page_mapping_inuse(page))
+				/*
+				 * Bypass use-once, make the next access
+				 * count. See mark_page_accessed and
+				 * shrink_page_list.
+				 */
+				SetPageReferenced(page);
+		}
 	}
 
 	/*

-- 
All Rights Reversed


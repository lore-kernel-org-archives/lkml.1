Return-Path: <linux-kernel-owner+w=401wt.eu-S1760149AbYE2U1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149AbYE2U1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758793AbYE2UZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:25:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbYE2UZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:25:09 -0400
Message-Id: <20080529202312.617352663@redhat.com>
References: <20080529202246.322317334@redhat.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 16:22:55 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Martin Bligh <mbligh@mbligh.org>
Subject: [PATCH -mm 09/12] fix pagecache reclaim referenced bit check
Content-Disposition: inline; filename=rvr-05-linux-2.6-fix-pagecache-reclaim.patch
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
inactive list do not have their referenced bit set, and a
reference to the page will not get it moved back to the active
list.  This patch sets the referenced bit on pagecache pages
that get deactivated, so the next access to the page will promote
it back to the active list.

---
 mm/vmscan.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.26-rc2-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/vmscan.c	2008-05-28 12:11:51.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/vmscan.c	2008-05-28 12:14:34.000000000 -0400
@@ -1062,8 +1062,13 @@ static void shrink_active_list(unsigned 
 				list_add(&page->lru, &l_inactive);
 				pgmoved++;
 			}
-		} else
+		} else {
 			list_add(&page->lru, &l_inactive);
+			if (file && !page_mapped(page))
+				/* Bypass use-once, make the next access count.
+				 * See mark_page_accessed. */
+				SetPageReferenced(page);
+		}
 	}
 
 	/*

-- 
All Rights Reversed


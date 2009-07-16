Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbZGPIhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbZGPIhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZGPIhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:37:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57929 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbZGPIhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:37:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/5]  move ClearPageActive from move_active_pages() to shrink_active_list()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090716173449.9D4B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 17:37:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series are several vmscan cleanups.

===================
Subject: [PATCH] move ClearPageActive from move_active_pages() to shrink_active_list()

The mvoe_active_pages_to_lru() function is called under irq disabled and
ClearPageActive() doesn't need irq disabling.

Then, this patch move it into shrink_active_list().


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1230,10 +1230,6 @@ static void move_active_pages_to_lru(str
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 
-		VM_BUG_ON(!PageActive(page));
-		if (!is_active_lru(lru))
-			ClearPageActive(page);	/* we are de-activating */
-
 		list_move(&page->lru, &zone->lru[lru].list);
 		mem_cgroup_add_lru_list(page, lru);
 		pgmoved++;
@@ -1315,6 +1311,7 @@ static void shrink_active_list(unsigned 
 			}
 		}
 
+		ClearPageActive(page);	/* we are de-activating */
 		list_add(&page->lru, &l_inactive);
 	}
 



Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbZH1Tjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbZH1Tjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZH1Tjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:39:51 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:22406 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694AbZH1Tju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:39:50 -0400
X-Trace: 250848851/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.31.14/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.31.14
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjUGAH3Pl0pQKR8O/2dsb2JhbACBU45MAcpWhBkF
X-IronPort-AV: E=Sophos;i="4.44,292,1249254000"; 
   d="scan'208";a="250848851"
Date: Fri, 28 Aug 2009 20:39:15 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH mmotm] vmscan move pgdeactivate modification to shrink_active_list
 fix
Message-ID: <Pine.LNX.4.64.0908282034240.19475@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmotm 2009-08-27-16-51 lets the OOM killer loose on my loads even
quicker than last time: one bug fixed but another bug introduced.
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
forgot to add NR_LRU_BASE to lru index to make zone_page_state index.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/vmscan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- mmotm/mm/vmscan.c	2009-08-28 10:07:57.000000000 +0100
+++ linux/mm/vmscan.c	2009-08-28 18:30:33.000000000 +0100
@@ -1381,8 +1381,10 @@ static void shrink_active_list(unsigned
 	reclaim_stat->recent_rotated[file] += nr_rotated;
 	__count_vm_events(PGDEACTIVATE, nr_deactivated);
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
-	__mod_zone_page_state(zone, LRU_ACTIVE + file * LRU_FILE, nr_rotated);
-	__mod_zone_page_state(zone, LRU_BASE + file * LRU_FILE, nr_deactivated);
+	__mod_zone_page_state(zone, NR_ACTIVE_ANON + file * LRU_FILE,
+							nr_rotated);
+	__mod_zone_page_state(zone, NR_INACTIVE_ANON + file * LRU_FILE,
+							nr_deactivated);
 	spin_unlock_irq(&zone->lru_lock);
 }
 

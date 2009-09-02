Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZIBA6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZIBA6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 20:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbZIBA6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 20:58:00 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:45281 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755372AbZIBA6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 20:58:00 -0400
X-Trace: 252173677/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.106.44/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.106.44
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAG5gnUpPRWos/2dsb2JhbACBU9ldhBsFgVc
X-IronPort-AV: E=Sophos;i="4.44,315,1249254000"; 
   d="scan'208";a="252173677"
Date: Wed, 2 Sep 2009 01:57:21 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH mmotm] vmscan move pgdeactivate modification to shrink_active_list
 fix2
In-Reply-To: <Pine.LNX.4.64.0908282034240.19475@sister.anvils>
Message-ID: <Pine.LNX.4.64.0909020154060.31130@sister.anvils>
References: <Pine.LNX.4.64.0908282034240.19475@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A second fix to the ill-starred
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
which, once corrected to update the right counters by the first fix,
builds up absurdly large Active counts in /proc/meminfo.

nr_rotated is not the number of pages added back to the active list
(maybe it once was, maybe it should be again: but if so that's not
any business for a code rearrangement patch).  shrink_active_list()
needs to keep a separate nr_reactivated count of those.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
Or... revert the offending patch and its first fix.

 mm/vmscan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- mmotm/mm/vmscan.c	2009-08-28 18:30:33.000000000 +0100
+++ linux/mm/vmscan.c	2009-09-02 01:28:34.000000000 +0100
@@ -1306,6 +1306,7 @@ static void shrink_active_list(unsigned
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	unsigned long nr_rotated = 0;
 	unsigned long nr_deactivated = 0;
+	unsigned long nr_reactivated = 0;
 
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
@@ -1354,6 +1355,7 @@ static void shrink_active_list(unsigned
 			 */
 			if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
 				list_add(&page->lru, &l_active);
+				nr_reactivated++;
 				continue;
 			}
 		}
@@ -1382,7 +1384,7 @@ static void shrink_active_list(unsigned
 	__count_vm_events(PGDEACTIVATE, nr_deactivated);
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 	__mod_zone_page_state(zone, NR_ACTIVE_ANON + file * LRU_FILE,
-							nr_rotated);
+							nr_reactivated);
 	__mod_zone_page_state(zone, NR_INACTIVE_ANON + file * LRU_FILE,
 							nr_deactivated);
 	spin_unlock_irq(&zone->lru_lock);

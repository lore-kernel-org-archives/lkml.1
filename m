Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZKLTaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZKLTaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 14:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZKLTao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 14:30:44 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43883 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbZKLTah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 14:30:37 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>
Cc: linux-kernel@vger.kernel.org, "linux-mm@kvack.org\"" <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 5/5] vmscan: Take order into consideration when deciding if kswapd is in trouble
Date: Thu, 12 Nov 2009 19:30:35 +0000
Message-Id: <1258054235-3208-6-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258054235-3208-1-git-send-email-mel@csn.ul.ie>
References: <1258054235-3208-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If reclaim fails to make sufficient progress, the priority is raised.
Once the priority is higher, kswapd starts waiting on congestion.
However, on systems with large numbers of high-order atomics due to
crappy network cards, it's important that kswapd keep working in
parallel to save their sorry ass.

This patch takes into account the order kswapd is reclaiming at before
waiting on congestion. The higher the order, the longer it is before
kswapd considers itself to be in trouble. The impact is that kswapd
works harder in parallel rather than depending on direct reclaimers or
atomic allocations to fail.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ffa1766..5e200f1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1946,7 +1946,7 @@ static int sleeping_prematurely(int order, long remaining)
 static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
 {
 	int all_zones_ok;
-	int priority;
+	int priority, congestion_priority;
 	int i;
 	unsigned long total_scanned;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
@@ -1967,6 +1967,16 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
 	 */
 	int temp_priority[MAX_NR_ZONES];
 
+	/*
+	 * When priority reaches congestion_priority, kswapd will sleep
+	 * for a short time while congestion clears. The higher the
+	 * order being reclaimed, the less likely kswapd will go to
+	 * sleep as high-order allocations are harder to reclaim and
+	 * stall direct reclaimers longer
+	 */
+	congestion_priority = DEF_PRIORITY - 2;
+	congestion_priority -= min(congestion_priority, sc.order);
+
 loop_again:
 	total_scanned = 0;
 	sc.nr_reclaimed = 0;
@@ -2092,7 +2102,7 @@ loop_again:
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
 		 */
-		if (total_scanned && priority < DEF_PRIORITY - 2)
+		if (total_scanned && priority < congestion_priority)
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/*
-- 
1.6.5


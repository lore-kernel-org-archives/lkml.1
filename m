Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZFIHOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZFIHOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbZFIHOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:14:41 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38129 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbZFIHOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:14:41 -0400
Date: Tue, 9 Jun 2009 16:13:30 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH mmotm] vmscan: handle may_swap more strictly (Re: [PATCH
 mmotm] vmscan: fix may_swap handling for memcg)
Message-Id: <20090609161330.fcd5facb.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090608165457.fa8d17e6.nishimura@mxp.nes.nec.co.jp>
References: <20090608121848.4370.A69D9226@jp.fujitsu.com>
	<20090608153916.3ccaeb9a.nishimura@mxp.nes.nec.co.jp>
	<20090608154634.437F.A69D9226@jp.fujitsu.com>
	<20090608165457.fa8d17e6.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > and, too many recliaming pages is not only memcg issue. I don't think this
> > patch provide generic solution.
> > 
> Ah, you're right. It's not only memcg issue.
> 
How about this one ?

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Commit 2e2e425989080cc534fc0fca154cae515f971cf5 ("vmscan,memcg: reintroduce
sc->may_swap) add may_swap flag and handle it at get_scan_ratio().

But the result of get_scan_ratio() is ignored when priority == 0,
so anon lru is scanned even if may_swap == 0 or nr_swap_pages == 0.
IMHO, this is not an expected behavior.

As for memcg especially, because of this behavior many and many pages are
swapped-out just in vain when oom is invoked by mem+swap limit.

This patch is for handling may_swap flag more strictly.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/vmscan.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2ddcfc8..bacb092 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1407,13 +1407,6 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
 	unsigned long ap, fp;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
-	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (nr_swap_pages <= 0)) {
-		percent[0] = 0;
-		percent[1] = 100;
-		return;
-	}
-
 	anon  = zone_nr_pages(zone, sc, LRU_ACTIVE_ANON) +
 		zone_nr_pages(zone, sc, LRU_INACTIVE_ANON);
 	file  = zone_nr_pages(zone, sc, LRU_ACTIVE_FILE) +
@@ -1511,15 +1504,22 @@ static void shrink_zone(int priority, struct zone *zone,
 	enum lru_list l;
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
 	unsigned long swap_cluster_max = sc->swap_cluster_max;
+	int noswap = 0;
 
-	get_scan_ratio(zone, sc, percent);
+	/* If we have no swap space, do not bother scanning anon pages. */
+	if (!sc->may_swap || (nr_swap_pages <= 0)) {
+		noswap = 1;
+		percent[0] = 0;
+		percent[1] = 100;
+	} else
+		get_scan_ratio(zone, sc, percent);
 
 	for_each_evictable_lru(l) {
 		int file = is_file_lru(l);
 		unsigned long scan;
 
 		scan = zone_nr_pages(zone, sc, l);
-		if (priority) {
+		if (priority || noswap) {
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
 		}

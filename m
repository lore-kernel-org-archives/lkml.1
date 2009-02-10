Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbZBJM6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbZBJM6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZBJM6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:58:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56527 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbZBJM6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:58:07 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] vmscan: initialize sc->nr_reclaimed properly take2
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       William Lee Irwin III <wli@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <28c262360902100440v765d3f7bnd56cc4b5510349c0@mail.gmail.com>
References: <20090210213502.7007.KOSAKI.MOTOHIRO@jp.fujitsu.com> <28c262360902100440v765d3f7bnd56cc4b5510349c0@mail.gmail.com>
Message-Id: <20090210215718.700D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 21:58:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How about this?

===
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] vmscan: initialize sc->nr_reclaimed properly

Commit a79311c14eae4bb946a97af25f3e1b17d625985d "vmscan: bail out of
direct reclaim after swap_cluster_max pages" moved the nr_reclaimed
counter into the scan control to accumulate the number of all
reclaimed pages in one direct reclaim invocation.

The commit missed to actually adjust try_to_free_pages() and __zone_reclaim()
which now does not initialize sc.nr_reclaimed and makes shrink_zone() make
assumptions on whether to bail out of the reclaim cycle based on an
uninitialized value.

Fix it up. 

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1665,6 +1665,7 @@ unsigned long try_to_free_pages(struct z
 								gfp_t gfp_mask)
 {
 	struct scan_control sc = {
+		.nr_reclaimed = 0,
 		.gfp_mask = gfp_mask,
 		.may_writepage = !laptop_mode,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
@@ -1686,6 +1687,7 @@ unsigned long try_to_free_mem_cgroup_pag
 					   unsigned int swappiness)
 {
 	struct scan_control sc = {
+		.nr_reclaimed = 0,
 		.may_writepage = !laptop_mode,
 		.may_swap = 1,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
@@ -2245,6 +2247,7 @@ static int __zone_reclaim(struct zone *z
 	struct reclaim_state reclaim_state;
 	int priority;
 	struct scan_control sc = {
+		.nr_reclaimed = 0,
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
 		.may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
 		.swap_cluster_max = max_t(unsigned long, nr_pages,



Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZDTU0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZDTU0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbZDTU0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:26:11 -0400
Received: from cmpxchg.org ([85.214.51.133]:47561 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbZDTU0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:26:08 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>, Rik van Riel <riel@redhat.com>
Subject: [patch 2/3][rfc] swap: try to reuse freed slots in the allocation area
Date: Mon, 20 Apr 2009 22:24:44 +0200
Message-Id: <1240259085-25872-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.2.1.135.gde769
In-Reply-To: <1240259085-25872-1-git-send-email-hannes@cmpxchg.org>
References: <1240259085-25872-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A swap slot for an anonymous memory page might get freed again just
after allocating it when further steps in the eviction process fail.

But the clustered slot allocation will go ahead allocating after this
now unused slot, leaving a hole at this position.  Holes waste space
and act as a boundary for optimistic swap-in.

To avoid this, check if the next page to be swapped out can sensibly
be placed at this just freed position.  And if so, point the next
cluster offset to it.

The acceptable 'look-back' distance is the number of slots swap-in
clustering uses as well so that the latter continues to get related
context when reading surrounding swap slots optimistically.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/swapfile.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 312fafe..fc88278 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -484,6 +484,15 @@ static int swap_entry_free(struct swap_info_struct *p, swp_entry_t ent)
 				p->lowest_bit = offset;
 			if (offset > p->highest_bit)
 				p->highest_bit = offset;
+			/*
+			 * If the next allocation is only some slots
+			 * ahead, reuse this now free slot instead of
+			 * leaving a hole.
+			 */
+			if (p->cluster_next - offset <= 1 << page_cluster) {
+				p->cluster_next = offset;
+				p->cluster_nr++;
+			}
 			if (p->prio > swap_info[swap_list.next].prio)
 				swap_list.next = p - swap_info;
 			nr_swap_pages++;
-- 
1.6.2.1.135.gde769


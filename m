Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZENFKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZENFKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 01:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZENFKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 01:10:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:2544 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZENFKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 01:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=SEdPt+1qEmw82y3eiHFzA6RkSMo5SS28210OUgu1y09JfR+THrR1tb3g9JOTpBf/g7
         2e6rsOpXeaHmTL35hq+Fp+QqLTEqjWbdIbyieDIwnb83pd1nU092LHcnMldmW2/nnhLO
         FaQwm2Iv26OIHohC9D03dUM+DLNQGOebwgeb4=
Date: Thu, 14 May 2009 14:10:25 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
Subject: [PATCH] Prevent shrinking of active anon lru list in case of no
 swap space
Message-Id: <20090514141025.239cafe5.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now shrink_active_list is called several places.
But if we don't have a swap space, we can't reclaim anon pages.
So, we don't need deactivating anon pages in anon lru list.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2f9d555..e4d71f4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1238,6 +1238,12 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 	enum lru_list lru;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
+	/* 
+	 * we can't shrink anon list in case of no swap space.
+	 */
+	if (file == 0 && nr_swap_pages <= 0)
+		return;
+
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
 	pgmoved = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
-- 
1.5.4.3


-- 
Kinds Regards
Minchan Kim

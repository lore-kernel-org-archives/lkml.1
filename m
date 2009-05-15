Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbZEOB7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbZEOB7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 21:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbZEOB7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 21:59:37 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:64885 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbZEOB7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 21:59:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=cTcdA/0S3/BJ1tdHysEpVz95X4wdStvJjerLcD/WRK4pnh6lM6jTcvV+FMSUizkU2V
         7E6CixLNqrFMQCn9zmNgfAjt816yvpFYC6oDmJl/RFbxuyWRdTPZJ+OYMfVXtM3kSMNN
         jGIWAzFdRyP3QmW2aevZU9CsukdlPzfm2jKVs=
Date: Fri, 15 May 2009 10:59:33 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
Subject: [PATCH] mmtom: Prevent shrinking of active anon lru list in case of
 no swap space V4
Message-Id: <20090515105933.1e7eb768.minchan.kim@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I repost this version with Rik and Kosaki's Reviewed-by sign and correcting my Signed-off-by.  

--

Hi, Adnrew. 

Please, drop my previous version and merge this. 
This versoin can enhance code size and performance by GCC code optimization.
If you wnat to know it detail, please, reference to Johannes Weiner's saying in V3 thread.

Changelog since V4
 o Make to check nr_swap_pages at first. - by Hannes's advise
  o It can reduce text size and increase performance a litte bit by GCC code optimization.

Changelog since V3
 o Remove can_reclaim_anon.
 o Add nr_swap_page > 0 in only shrink_zone - By Rik's advise.
 o Change patch description.

Changelog since V2
 o Add new function - can_reclaim_anon : it tests anon_list can be reclaim.

Changelog since V1
 o Use nr_swap_pages <= 0 in shrink_active_list to prevent scanning  of active anon list.

Now shrink_zone can deactivate active anon pages even if we don't have a swap device.
Many embedded products don't have a swap device. So the deactivation of anon pages is unnecessary.

This patch prevents unnecessary deactivation of anon lru pages.
But, it doesn't prevent aging of anon pages to swap out.

Thanks for good review. Rik,Kosaki and Hannes.

Signed-off-by: Minchan kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>

---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2f9d555..1b4ee95 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1577,7 +1577,7 @@ static void shrink_zone(int priority, struct zone *zone,
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (inactive_anon_is_low(zone, sc))
+	if (nr_swap_pages > 0 && inactive_anon_is_low(zone, sc))
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
 	throttle_vm_writeout(sc->gfp_mask);
-- 
1.5.4.3


-- 
Kinds Regards,
Minchan Kim 

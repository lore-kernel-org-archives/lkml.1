Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbZJVOXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbZJVOXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331AbZJVOXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:23:53 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50116 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989AbZJVOWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:22:39 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 3/5] vmscan: Force kswapd to take notice faster when high-order watermarks are being hit
Date: Thu, 22 Oct 2009 15:22:34 +0100
Message-Id: <1256221356-26049-4-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a high-order allocation fails, kswapd is kicked so that it reclaims
at a higher-order to avoid direct reclaimers stall and to help GFP_ATOMIC
allocations. Something has changed in recent kernels that affect the timing
where high-order GFP_ATOMIC allocations are now failing with more frequency,
particularly under pressure. This patch forces kswapd to notice sooner that
high-order allocations are occuring.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 64e4388..cd68109 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2016,6 +2016,15 @@ loop_again:
 					priority != DEF_PRIORITY)
 				continue;
 
+			/*
+			 * Exit quickly to restart if it has been indicated
+			 * that higher orders are required
+			 */
+			if (pgdat->kswapd_max_order > order) {
+				all_zones_ok = 1;
+				goto out;
+			}
+
 			if (!zone_watermark_ok(zone, order,
 					high_wmark_pages(zone), end_zone, 0))
 				all_zones_ok = 0;
-- 
1.6.3.3


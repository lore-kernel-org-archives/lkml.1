Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbZJ0Nkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbZJ0Nkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbZJ0Nkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:40:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54840 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbZJ0Nkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:40:37 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Cc: linux-kernel@vger.kernel.org, "linux-mm@kvack.org\"" <linux-mm@kvack.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 3/3] vmscan: Force kswapd to take notice faster when high-order watermarks are being hit
Date: Tue, 27 Oct 2009 13:40:33 +0000
Message-Id: <1256650833-15516-4-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1256650833-15516-1-git-send-email-mel@csn.ul.ie>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie>
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
index 64e4388..7eceb02 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2016,6 +2016,15 @@ loop_again:
 					priority != DEF_PRIORITY)
 				continue;
 
+			/*
+			 * Exit the function now and have kswapd start over
+			 * if it is known that higher orders are required
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


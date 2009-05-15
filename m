Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbZEOBDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbZEOBDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 21:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZEOBCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 21:02:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50775 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbZEOBCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 21:02:50 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Cc: kosaki.motohiro@jp.fujitsu.com, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0905141602010.1381@qirst.com>
References: <20090513152256.GM7601@sgi.com> <alpine.DEB.1.10.0905141602010.1381@qirst.com>
Message-Id: <20090515082836.F5B9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 15 May 2009 10:02:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not having zone reclaim on a NUMA system often means that per node
> allocations will fall back. Optimized node local allocations become very
> difficult for the page allocator. If the latency penalties are not
> significant then this may not matter. The larger the system, the larger
> the NUMA latencies become.
> 
> One possibility would be to disable zone reclaim for low node numbers.
> Eanble it only if more than 4 nodes exist?

I think this idea works good every machine and doesn't cause confusion
to HPC user.

How about this?

==============================
Subject: [PATCH] zone_reclaim is always 0 by default on small machine

Current linux policy is, zone_reclaim_mode is enabled by default if the machine
has large remote node distance. it's because we could assume that large distance 
mean large server until recently.

Unfortunately, recent modern x86 CPU (e.g. Core i7, Opeteron) have P2P transport
memory controller. IOW it's seen as NUMA from software view.

Some Core i7 machine has large remote node distance, but zone_reclaim don't
fit desktop and small file server. it cause performance degression.

Thus, zone_reclaim == 0 is better by default if the machine is small.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Robin Holt <holt@sgi.com>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2497,7 +2497,7 @@ static void build_zonelists(pg_data_t *p
 		 * If another node is sufficiently far away then it is better
 		 * to reclaim pages in a zone before going off node.
 		 */
-		if (distance > RECLAIM_DISTANCE)
+		if (nr_online_nodes >= 4 && distance > RECLAIM_DISTANCE)
 			zone_reclaim_mode = 1;
 
 		/*



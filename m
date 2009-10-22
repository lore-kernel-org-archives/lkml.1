Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZJVOWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZJVOWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbZJVOWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:22:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50094 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899AbZJVOWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:22:38 -0400
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
Subject: [PATCH 2/5] page allocator: Do not allow interrupts to use ALLOC_HARDER
Date: Thu, 22 Oct 2009 15:22:33 +0100
Message-Id: <1256221356-26049-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 341ce06f69abfafa31b9468410a13dbd60e2b237 altered watermark logic
slightly by allowing rt_tasks that are handling an interrupt to set
ALLOC_HARDER. This patch brings the watermark logic more in line with
2.6.30.

[rientjes@google.com: Spotted the problem]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dfa4362..7f2aa3e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1769,7 +1769,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
-	} else if (unlikely(rt_task(p)))
+	} else if (unlikely(rt_task(p)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
 	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
-- 
1.6.3.3


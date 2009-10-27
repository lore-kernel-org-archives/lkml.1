Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbZJ0Nkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbZJ0Nkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbZJ0Nki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:40:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54826 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbZJ0Nkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:40:36 -0400
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
Subject: [PATCH 2/3] page allocator: Do not allow interrupts to use ALLOC_HARDER
Date: Tue, 27 Oct 2009 13:40:32 +0000
Message-Id: <1256650833-15516-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1256650833-15516-1-git-send-email-mel@csn.ul.ie>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie>
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
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
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


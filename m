Return-Path: <linux-kernel-owner+w=401wt.eu-S1759141AbZJMIBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141AbZJMIBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759129AbZJMIBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:01:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:53480 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759128AbZJMIBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:01:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,550,1249282800"; 
   d="scan'208";a="198262647"
Date: Tue, 13 Oct 2009 16:00:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Cc: Rik van Riel <riel@redhat.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Elladan <elladan@eskimo.com>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH][BUGFIX] vmscan: limit VM_EXEC protection to file pages
Message-ID: <20091013080054.GA20395@localhost>
References: <200910122244.19666.borntraeger@de.ibm.com> <20091013022650.GB7345@localhost> <4AD3E6C4.805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD3E6C4.805@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to have !Anon but SwapBacked pages, and some apps could
create huge number of such pages with MAP_SHARED|MAP_ANONYMOUS. These
pages go into the ANON lru list, and hence shall not be protected: we
only care mapped executable files. Failing to do so may trigger OOM.

Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/mm/vmscan.c	2009-10-13 09:49:05.000000000 +0800
+++ linux/mm/vmscan.c	2009-10-13 09:49:37.000000000 +0800
@@ -1356,7 +1356,7 @@ static void shrink_active_list(unsigned 
 			 * IO, plus JVM can create lots of anon VM_EXEC pages,
 			 * so we ignore them here.
 			 */
-			if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
+			if ((vm_flags & VM_EXEC) && page_is_file_cache(page)) {
 				list_add(&page->lru, &l_active);
 				continue;
 			}

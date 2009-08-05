Return-Path: <linux-kernel-owner+w=401wt.eu-S1751488AbZHEEMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbZHEEMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 00:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbZHEEMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 00:12:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:21793 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZHEEMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 00:12:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,324,1246863600"; 
   d="scan'208";a="172384500"
Date: Wed, 5 Aug 2009 10:40:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090805024058.GA8886@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Jeff Dike found that many KVM pages are being refaulted in 2.6.29:

"Lots of pages between discarded due to memory pressure only to be
faulted back in soon after. These pages are nearly all stack pages.
This is not consistent - sometimes there are relatively few such pages
and they are spread out between processes."

The refaults can be drastically reduced by the following patch, which
respects the referenced bit of all anonymous pages (including the KVM
pages).

However it risks reintroducing the problem addressed by commit 7e9cd4842
(fix reclaim scalability problem by ignoring the referenced bit,
mainly the pte young bit). I wonder if there are better solutions?

Thanks,
Fengguang

---
 mm/vmscan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux.orig/mm/vmscan.c
+++ linux/mm/vmscan.c
@@ -1288,12 +1288,12 @@ static void shrink_active_list(unsigned 
 			 * Identify referenced, file-backed active pages and
 			 * give them one more trip around the active list. So
 			 * that executable code get better chances to stay in
-			 * memory under moderate memory pressure.  Anon pages
-			 * are not likely to be evicted by use-once streaming
-			 * IO, plus JVM can create lots of anon VM_EXEC pages,
-			 * so we ignore them here.
+			 * memory under moderate memory pressure.
+			 *
+			 * Also protect anon pages: swapping could be costly,
+			 * and KVM guest's referenced bit is helpful.
 			 */
-			if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
+			if ((vm_flags & VM_EXEC) || PageAnon(page)) {
 				list_add(&page->lru, &l_active);
 				continue;
 			}

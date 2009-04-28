Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbZD1Bwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbZD1Bwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbZD1BvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:51:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:9251 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757809AbZD1BvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:51:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,257,1239001200"; 
   d="scan'208";a="136585607"
Message-Id: <20090428014920.630861760@intel.com>
References: <20090428010907.912554629@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Apr 2009 09:09:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andi Kleen <andi@firstfloor.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 4/5] proc: kpagecount/kpageflags code cleanup
Content-Disposition: inline; filename=kpageflags-fix-out.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move increments of pfn/out to bottom of the loop.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/proc/page.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- mm.orig/fs/proc/page.c
+++ mm/fs/proc/page.c
@@ -32,20 +32,22 @@ static ssize_t kpagecount_read(struct fi
 		return -EINVAL;
 
 	while (count > 0) {
-		ppage = NULL;
 		if (pfn_valid(pfn))
 			ppage = pfn_to_page(pfn);
-		pfn++;
+		else
+			ppage = NULL;
 		if (!ppage)
 			pcount = 0;
 		else
 			pcount = page_mapcount(ppage);
 
-		if (put_user(pcount, out++)) {
+		if (put_user(pcount, out)) {
 			ret = -EFAULT;
 			break;
 		}
 
+		pfn++;
+		out++;
 		count -= KPMSIZE;
 	}
 
@@ -98,10 +100,10 @@ static ssize_t kpageflags_read(struct fi
 		return -EINVAL;
 
 	while (count > 0) {
-		ppage = NULL;
 		if (pfn_valid(pfn))
 			ppage = pfn_to_page(pfn);
-		pfn++;
+		else
+			ppage = NULL;
 		if (!ppage)
 			kflags = 0;
 		else
@@ -119,11 +121,13 @@ static ssize_t kpageflags_read(struct fi
 			kpf_copy_bit(kflags, KPF_RECLAIM, PG_reclaim) |
 			kpf_copy_bit(kflags, KPF_BUDDY, PG_buddy);
 
-		if (put_user(uflags, out++)) {
+		if (put_user(uflags, out)) {
 			ret = -EFAULT;
 			break;
 		}
 
+		pfn++;
+		out++;
 		count -= KPMSIZE;
 	}
 

-- 


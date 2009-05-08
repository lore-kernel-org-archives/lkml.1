Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbZEHLNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbZEHLNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757913AbZEHLMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:12:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:48712 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbZEHLMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:12:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,316,1239001200"; 
   d="scan'208";a="140664179"
Message-Id: <20090508111030.776795553@intel.com>
References: <20090508105320.316173813@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 18:53:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andi Kleen <andi@firstfloor.org>, <linux-mm@kvack.org>
Subject: [PATCH 3/8] proc: kpagecount/kpageflags code cleanup
Content-Disposition: inline; filename=kpageflags-fix-out.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move increments of pfn/out to bottom of the loop.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/proc/page.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- linux.orig/fs/proc/page.c
+++ linux/fs/proc/page.c
@@ -11,6 +11,7 @@
 
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
+
 /* /proc/kpagecount - an array exposing page counts
  *
  * Each entry is a u64 representing the corresponding
@@ -32,20 +33,22 @@ static ssize_t kpagecount_read(struct fi
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
 
@@ -98,10 +101,10 @@ static ssize_t kpageflags_read(struct fi
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
@@ -119,11 +122,13 @@ static ssize_t kpageflags_read(struct fi
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


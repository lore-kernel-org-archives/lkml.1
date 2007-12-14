Return-Path: <linux-kernel-owner+w=401wt.eu-S1763066AbXLNJJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763066AbXLNJJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbXLNJJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:09:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:6520 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757108AbXLNJJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:09:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,166,1196668800"; 
   d="scan'208";a="238023968"
Subject: [RFC]handle error of rmqueue_bulk
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mel <mel@csn.ul.ie>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 17:08:57 +0800
Message-Id: <1197623337.3732.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if rmqueue_bulk fails, we might get page with wrong migratetype,
shouldn't we consider the case? 

Thanks,
Shaohua

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c	2007-12-14 16:44:35.000000000 +0800
+++ linux/mm/page_alloc.c	2007-12-14 16:45:42.000000000 +0800
@@ -1067,8 +1067,12 @@ again:
 
 		/* Allocate more to the pcp list if necessary */
 		if (unlikely(&page->lru == &pcp->list)) {
-			pcp->count += rmqueue_bulk(zone, 0,
+			int cn;
+			cn = rmqueue_bulk(zone, 0,
 					pcp->batch, &pcp->list, migratetype);
+			if (unlikely(!cn))
+				goto failed;
+			pcp->count += cn;
 			page = list_entry(pcp->list.next, struct page, lru);
 		}
 



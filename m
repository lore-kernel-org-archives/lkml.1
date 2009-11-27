Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZK0Lg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZK0Lg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbZK0Lg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:36:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:47034 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbZK0Lgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:36:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,300,1257148800"; 
   d="scan'208";a="216271334"
Message-Id: <20091127110407.360489157@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 27 Nov 2009 18:59:10 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 2/6] writeback: remove unused nonblocking and congestion checks (write_cache_pages)
References: <20091127105908.944744141@intel.com>
Content-Disposition: inline; filename=writeback-remove-congested-checks-linux_mm_page-writeback.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one is calling wb_writeback and write_cache_pages with
wbc.nonblocking=1 any more. And lumpy pageout will want to do
nonblocking writeback without the congestion wait.

CC: Chris Mason <chris.mason@oracle.com>
CC: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   12 ------------
 1 file changed, 12 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-11-27 16:35:00.000000000 +0800
+++ linux/mm/page-writeback.c	2009-11-27 18:55:00.000000000 +0800
@@ -821,7 +821,6 @@ int write_cache_pages(struct address_spa
 		      struct writeback_control *wbc, writepage_t writepage,
 		      void *data)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int ret = 0;
 	int done = 0;
 	struct pagevec pvec;
@@ -834,11 +833,6 @@ int write_cache_pages(struct address_spa
 	int range_whole = 0;
 	long nr_to_write = wbc->nr_to_write;
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		return 0;
-	}
-
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		writeback_index = mapping->writeback_index; /* prev offset */
@@ -957,12 +951,6 @@ continue_unlock:
 					break;
 				}
 			}
-
-			if (wbc->nonblocking && bdi_write_congested(bdi)) {
-				wbc->encountered_congestion = 1;
-				done = 1;
-				break;
-			}
 		}
 		pagevec_release(&pvec);
 		cond_resched();



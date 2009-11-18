Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbZKRIcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbZKRIcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZKRIb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:31:57 -0500
Received: from mga14.intel.com ([143.182.124.37]:27526 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbZKRIbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:31:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212830412"
Message-Id: <20091118082845.683715467@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 18 Nov 2009 16:26:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/12] writeback: remove unused nonblocking and congestion checks (write_cache_pages)
References: <20091118082648.140755818@intel.com>
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

--- linux.orig/mm/page-writeback.c	2009-11-18 16:25:49.000000000 +0800
+++ linux/mm/page-writeback.c	2009-11-18 16:25:53.000000000 +0800
@@ -828,7 +828,6 @@ int write_cache_pages(struct address_spa
 		      struct writeback_control *wbc, writepage_t writepage,
 		      void *data)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int ret = 0;
 	int done = 0;
 	struct pagevec pvec;
@@ -841,11 +840,6 @@ int write_cache_pages(struct address_spa
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
@@ -964,12 +958,6 @@ continue_unlock:
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



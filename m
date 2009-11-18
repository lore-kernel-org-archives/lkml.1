Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZKRIdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZKRIdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZKRIby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:31:54 -0500
Received: from mga14.intel.com ([143.182.124.37]:15558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbZKRIbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:31:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,764,1249282800"; 
   d="scan'208";a="212830408"
Message-Id: <20091118082845.936295466@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 18 Nov 2009 16:26:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: <linux-fsdevel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/12] writeback: remove unused nonblocking and congestion checks (afs)
References: <20091118082648.140755818@intel.com>
Content-Disposition: inline; filename=writeback-remove-congested-checks-linux_fs_afs_write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one is calling wb_writeback and write_cache_pages with
wbc.nonblocking=1 any more. And lumpy pageout will want to do
nonblocking writeback without the congestion wait.

CC: David Howells <dhowells@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/afs/write.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- linux.orig/fs/afs/write.c	2009-11-06 09:36:28.000000000 +0800
+++ linux/fs/afs/write.c	2009-11-06 09:52:13.000000000 +0800
@@ -455,8 +455,6 @@ int afs_writepage(struct page *page, str
 	}
 
 	wbc->nr_to_write -= ret;
-	if (wbc->nonblocking && bdi_write_congested(bdi))
-		wbc->encountered_congestion = 1;
 
 	_leave(" = 0");
 	return 0;
@@ -529,11 +527,6 @@ static int afs_writepages_region(struct 
 
 		wbc->nr_to_write -= ret;
 
-		if (wbc->nonblocking && bdi_write_congested(bdi)) {
-			wbc->encountered_congestion = 1;
-			break;
-		}
-
 		cond_resched();
 	} while (index < end && wbc->nr_to_write > 0);
 
@@ -554,18 +547,11 @@ int afs_writepages(struct address_space 
 
 	_enter("");
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		_leave(" = 0 [congest]");
-		return 0;
-	}
-
 	if (wbc->range_cyclic) {
 		start = mapping->writeback_index;
 		end = -1;
 		ret = afs_writepages_region(mapping, wbc, start, end, &next);
-		if (start > 0 && wbc->nr_to_write > 0 && ret == 0 &&
-		    !(wbc->nonblocking && wbc->encountered_congestion))
+		if (start > 0 && wbc->nr_to_write > 0 && ret == 0)
 			ret = afs_writepages_region(mapping, wbc, 0, start,
 						    &next);
 		mapping->writeback_index = next;



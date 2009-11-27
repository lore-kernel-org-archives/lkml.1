Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbZK0LgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbZK0LgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbZK0LgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:36:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:25175 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbZK0LgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:36:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,300,1257148800"; 
   d="scan'208";a="216271170"
Message-Id: <20091127110407.530393220@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 27 Nov 2009 18:59:11 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Evgeniy Polyakov <zbr@ioremap.net>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 3/6] writeback: remove unused nonblocking and congestion checks (pohmelfs)
References: <20091127105908.944744141@intel.com>
Content-Disposition: inline; filename=writeback-remove-congested-checks-linux_drivers_staging_pohmelfs_inode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one is calling wb_writeback and write_cache_pages with
wbc.nonblocking=1 any more. And lumpy pageout will want to do
nonblocking writeback without the congestion wait.

CC: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/staging/pohmelfs/inode.c |   10 ----------
 1 file changed, 10 deletions(-)

--- linux.orig/drivers/staging/pohmelfs/inode.c	2009-11-27 16:34:51.000000000 +0800
+++ linux/drivers/staging/pohmelfs/inode.c	2009-11-27 18:55:03.000000000 +0800
@@ -143,7 +143,6 @@ static int pohmelfs_writepages(struct ad
 	struct inode *inode = mapping->host;
 	struct pohmelfs_inode *pi = POHMELFS_I(inode);
 	struct pohmelfs_sb *psb = POHMELFS_SB(inode->i_sb);
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int err = 0;
 	int done = 0;
 	int nr_pages;
@@ -152,11 +151,6 @@ static int pohmelfs_writepages(struct ad
 	int scanned = 0;
 	int range_whole = 0;
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		return 0;
-	}
-
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
@@ -248,10 +242,6 @@ retry:
 
 			if (wbc->nr_to_write <= 0)
 				done = 1;
-			if (wbc->nonblocking && bdi_write_congested(bdi)) {
-				wbc->encountered_congestion = 1;
-				done = 1;
-			}
 
 			continue;
 out_continue:



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbZKSILw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbZKSILw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 03:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZKSILv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 03:11:51 -0500
Received: from mga14.intel.com ([143.182.124.37]:45290 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbZKSILv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 03:11:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,770,1249282800"; 
   d="scan'208";a="213296697"
Date: Thu, 19 Nov 2009 16:11:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/12] writeback: remove unused nonblocking and
	congestion checks (pohmelfs)
Message-ID: <20091119081154.GE5922@localhost>
References: <20091118082648.140755818@intel.com> <20091118082845.828021716@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118082845.828021716@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

Will you pick up this updated patch? It also removes the unused bdi.

Thanks,
Fengguang
---
writeback: remove unused nonblocking and congestion checks (pohmelfs)

No one is calling wb_writeback and write_cache_pages with
wbc.nonblocking=1 any more. And lumpy pageout will want to do
nonblocking writeback without the congestion wait.

CC: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/staging/pohmelfs/inode.c |   10 ----------
 1 file changed, 10 deletions(-)

--- linux.orig/drivers/staging/pohmelfs/inode.c	2009-11-18 16:39:36.000000000 +0800
+++ linux/drivers/staging/pohmelfs/inode.c	2009-11-19 16:10:29.000000000 +0800
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

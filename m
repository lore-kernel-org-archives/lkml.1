Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZKSIJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZKSIJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 03:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbZKSIJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 03:09:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:15529 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbZKSIJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 03:09:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,770,1249282800"; 
   d="scan'208";a="213296104"
Date: Thu, 19 Nov 2009 16:09:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/12] writeback: remove unused nonblocking and
	congestion checks (afs)
Message-ID: <20091119080947.GD5922@localhost>
References: <20091118082648.140755818@intel.com> <20091118082845.936295466@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118082845.936295466@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Will you pick up this updated patch? It also removes the unused bdi.

Thanks,
Fengguang
---
writeback: remove unused nonblocking and congestion checks (afs)

No one is calling wb_writeback and write_cache_pages with
wbc.nonblocking=1 any more. And lumpy pageout will want to do
nonblocking writeback without the congestion wait.

CC: David Howells <dhowells@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/afs/write.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- linux.orig/fs/afs/write.c	2009-11-18 16:39:33.000000000 +0800
+++ linux/fs/afs/write.c	2009-11-19 16:07:31.000000000 +0800
@@ -438,7 +438,6 @@ no_more:
  */
 int afs_writepage(struct page *page, struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = page->mapping->backing_dev_info;
 	struct afs_writeback *wb;
 	int ret;
 
@@ -455,8 +454,6 @@ int afs_writepage(struct page *page, str
 	}
 
 	wbc->nr_to_write -= ret;
-	if (wbc->nonblocking && bdi_write_congested(bdi))
-		wbc->encountered_congestion = 1;
 
 	_leave(" = 0");
 	return 0;
@@ -469,7 +466,6 @@ static int afs_writepages_region(struct 
 				 struct writeback_control *wbc,
 				 pgoff_t index, pgoff_t end, pgoff_t *_next)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	struct afs_writeback *wb;
 	struct page *page;
 	int ret, n;
@@ -529,11 +525,6 @@ static int afs_writepages_region(struct 
 
 		wbc->nr_to_write -= ret;
 
-		if (wbc->nonblocking && bdi_write_congested(bdi)) {
-			wbc->encountered_congestion = 1;
-			break;
-		}
-
 		cond_resched();
 	} while (index < end && wbc->nr_to_write > 0);
 
@@ -548,24 +539,16 @@ static int afs_writepages_region(struct 
 int afs_writepages(struct address_space *mapping,
 		   struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	pgoff_t start, end, next;
 	int ret;
 
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

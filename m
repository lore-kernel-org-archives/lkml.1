Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbZKSIFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbZKSIFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 03:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZKSIFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 03:05:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:12263 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbZKSIFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 03:05:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,770,1249282800"; 
   d="scan'208";a="213294898"
Date: Thu, 19 Nov 2009 16:05:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/12] writeback: remove unused nonblocking and
	congestion checks (xfs)
Message-ID: <20091119080522.GC5922@localhost>
References: <20091118082648.140755818@intel.com> <20091118082846.279046849@intel.com> <20091118212755.GM9467@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118212755.GM9467@discord.disaster>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 05:27:55AM +0800, Dave Chinner wrote:
> On Wed, Nov 18, 2009 at 04:26:55PM +0800, Wu Fengguang wrote:
> > No one is calling wb_writeback and write_cache_pages with
> > wbc.nonblocking=1 any more. And lumpy pageout will want to do
> > nonblocking writeback without the congestion wait.
> 
> ....
> 
> > --- linux.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-11-06 09:22:35.000000000 +0800
> > +++ linux/fs/xfs/linux-2.6/xfs_aops.c	2009-11-06 09:52:21.000000000 +0800
> > @@ -908,12 +908,8 @@ xfs_convert_page(
> >  
> >  			bdi = inode->i_mapping->backing_dev_info;
> >  			wbc->nr_to_write--;
> > -			if (bdi_write_congested(bdi)) {
> > -				wbc->encountered_congestion = 1;
> 
> bdi is unused now, so can be removed as well. Otherwise looks fine.

Thanks, here is the updated patch.

---
writeback: remove unused nonblocking and congestion checks (xfs)

No one is calling wb_writeback and write_cache_pages with
wbc.nonblocking=1 any more. And lumpy pageout will want to do
nonblocking writeback without the congestion wait.

CC: Dave Chinner <david@fromorbit.com> 
CC: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- linux.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-11-19 16:00:51.000000000 +0800
+++ linux/fs/xfs/linux-2.6/xfs_aops.c	2009-11-19 16:04:33.000000000 +0800
@@ -904,16 +904,9 @@ xfs_convert_page(
 
 	if (startio) {
 		if (count) {
-			struct backing_dev_info *bdi;
-
-			bdi = inode->i_mapping->backing_dev_info;
 			wbc->nr_to_write--;
-			if (bdi_write_congested(bdi)) {
-				wbc->encountered_congestion = 1;
-				done = 1;
-			} else if (wbc->nr_to_write <= 0) {
+			if (wbc->nr_to_write <= 0)
 				done = 1;
-			}
 		}
 		xfs_start_page_writeback(page, !page_dirty, count);
 	}

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZK0MFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZK0MFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 07:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZK0MFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 07:05:55 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:45456 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbZK0MFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 07:05:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T/3N9POqi3xWEA0wU+oXc65WG9Zo0Nqme1J64nEuwam1EODoCeQDFDBUQ+VULpWf3N
         Bt2GqKFPcSyiMWk2KKmDjQo9wYqrtMS2aQhHBYf1T96CjSIIm/mRwjEFKbFyXIAHHC4t
         jx6CApX3+b95RXNKo8JQDJVHxjSK6ptkm5rz4=
Date: Fri, 27 Nov 2009 19:50:29 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/6] writeback: remove unused nonblocking and
	congestion checks (xfs)
Message-ID: <20091127115029.GA20166@localhost>
References: <20091127105908.944744141@intel.com> <20091127110407.781077241@intel.com> <20091127114014.GA5132@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127114014.GA5132@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 06:40:14AM -0500, Christoph Hellwig wrote:
> On Fri, Nov 27, 2009 at 06:59:12PM +0800, Wu Fengguang wrote:
> > No one is calling wb_writeback and write_cache_pages with
> > wbc.nonblocking=1 any more. And lumpy pageout will want to do
> > nonblocking writeback without the congestion wait.
> 
> Please, just fold this into one big patch removing the flag.  Splitting
> this into multiple patches is just a real pain in the neck.

Sure. This is the folded version for the first 4 patches.

Thanks,
Fengguang
---
writeback: remove unused nonblocking and congestion checks

- no one is calling wb_writeback and write_cache_pages with
  wbc.nonblocking=1 any more
- lumpy pageout will want to do nonblocking writeback without the
  congestion wait

So remove the congestion checks as suggested by Chris.

CC: Chris Mason <chris.mason@oracle.com>
CC: Jens Axboe <jens.axboe@oracle.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>
CC: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/staging/pohmelfs/inode.c |   10 ----------
 fs/fs-writeback.c                |    9 ---------
 fs/xfs/linux-2.6/xfs_aops.c      |    9 +--------
 mm/page-writeback.c              |   12 ------------
 4 files changed, 1 insertion(+), 39 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-11-27 19:46:05.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-11-27 19:46:10.000000000 +0800
@@ -657,14 +657,6 @@ static void writeback_inodes_wb(struct b
 			continue;
 		}
 
-		if (wbc->nonblocking && bdi_write_congested(wb->bdi)) {
-			wbc->encountered_congestion = 1;
-			if (!is_blkdev_sb)
-				break;		/* Skip a congested fs */
-			requeue_io(inode);
-			continue;		/* Skip a congested blockdev */
-		}
-
 		/*
 		 * Was this inode dirtied after sync_sb_inodes was called?
 		 * This keeps sync from extra jobs and livelock.
@@ -787,7 +779,6 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		wbc.more_io = 0;
-		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
 		writeback_inodes_wb(wb, &wbc);
--- linux.orig/drivers/staging/pohmelfs/inode.c	2009-11-27 19:06:00.000000000 +0800
+++ linux/drivers/staging/pohmelfs/inode.c	2009-11-27 19:46:31.000000000 +0800
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
--- linux.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-11-27 19:06:00.000000000 +0800
+++ linux/fs/xfs/linux-2.6/xfs_aops.c	2009-11-27 19:46:40.000000000 +0800
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
--- linux.orig/mm/page-writeback.c	2009-11-27 19:46:06.000000000 +0800
+++ linux/mm/page-writeback.c	2009-11-27 19:46:20.000000000 +0800
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

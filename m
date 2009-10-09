Return-Path: <linux-kernel-owner+w=401wt.eu-S933510AbZJIP1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510AbZJIP1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932458AbZJIP1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:27:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:46523 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319AbZJIP1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:27:09 -0400
Date: Fri, 9 Oct 2009 17:26:29 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Li Shaohua <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/45] writeback: remove unused nonblocking and
	congestion checks
Message-ID: <20091009152629.GH7654@duck.suse.cz>
References: <20091007073818.318088777@intel.com> <20091007074901.625522882@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007074901.625522882@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-10-09 15:38:22, Wu Fengguang wrote:
> - no one is calling wb_writeback and write_cache_pages with
>   wbc.nonblocking=1 any more
> - lumpy pageout will want to do nonblocking writeback without the
>   congestion wait
> 
> So remove the congestion checks as suggested by Chris.
  Looks good. Since encountered_congestion isn't used, you can delete it as
well... BTW, you might need to split this patch to per-fs chunks for the
sake of merging.

									Honza

> 
> CC: Chris Mason <chris.mason@oracle.com>
> CC: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  drivers/staging/pohmelfs/inode.c |    9 ---------
>  fs/afs/write.c                   |   16 +---------------
>  fs/cifs/file.c                   |   10 ----------
>  fs/fs-writeback.c                |    8 --------
>  fs/gfs2/aops.c                   |   10 ----------
>  fs/xfs/linux-2.6/xfs_aops.c      |    6 +-----
>  mm/page-writeback.c              |   12 ------------
>  7 files changed, 2 insertions(+), 69 deletions(-)
> 
> --- linux.orig/fs/fs-writeback.c	2009-10-06 23:31:54.000000000 +0800
> +++ linux/fs/fs-writeback.c	2009-10-06 23:31:59.000000000 +0800
> @@ -660,14 +660,6 @@ static void writeback_inodes_wb(struct b
>  			continue;
>  		}
>  
> -		if (wbc->nonblocking && bdi_write_congested(wb->bdi)) {
> -			wbc->encountered_congestion = 1;
> -			if (!is_blkdev_sb)
> -				break;		/* Skip a congested fs */
> -			requeue_io(inode);
> -			continue;		/* Skip a congested blockdev */
> -		}
> -
>  		/*
>  		 * Was this inode dirtied after sync_sb_inodes was called?
>  		 * This keeps sync from extra jobs and livelock.
> --- linux.orig/mm/page-writeback.c	2009-10-06 23:31:54.000000000 +0800
> +++ linux/mm/page-writeback.c	2009-10-06 23:31:59.000000000 +0800
> @@ -787,7 +787,6 @@ int write_cache_pages(struct address_spa
>  		      struct writeback_control *wbc, writepage_t writepage,
>  		      void *data)
>  {
> -	struct backing_dev_info *bdi = mapping->backing_dev_info;
>  	int ret = 0;
>  	int done = 0;
>  	struct pagevec pvec;
> @@ -800,11 +799,6 @@ int write_cache_pages(struct address_spa
>  	int range_whole = 0;
>  	long nr_to_write = wbc->nr_to_write;
>  
> -	if (wbc->nonblocking && bdi_write_congested(bdi)) {
> -		wbc->encountered_congestion = 1;
> -		return 0;
> -	}
> -
>  	pagevec_init(&pvec, 0);
>  	if (wbc->range_cyclic) {
>  		writeback_index = mapping->writeback_index; /* prev offset */
> @@ -923,12 +917,6 @@ continue_unlock:
>  					break;
>  				}
>  			}
> -
> -			if (wbc->nonblocking && bdi_write_congested(bdi)) {
> -				wbc->encountered_congestion = 1;
> -				done = 1;
> -				break;
> -			}
>  		}
>  		pagevec_release(&pvec);
>  		cond_resched();
> --- linux.orig/drivers/staging/pohmelfs/inode.c	2009-10-06 23:31:41.000000000 +0800
> +++ linux/drivers/staging/pohmelfs/inode.c	2009-10-06 23:31:59.000000000 +0800
> @@ -152,11 +152,6 @@ static int pohmelfs_writepages(struct ad
>  	int scanned = 0;
>  	int range_whole = 0;
>  
> -	if (wbc->nonblocking && bdi_write_congested(bdi)) {
> -		wbc->encountered_congestion = 1;
> -		return 0;
> -	}
> -
>  	if (wbc->range_cyclic) {
>  		index = mapping->writeback_index; /* Start from prev offset */
>  		end = -1;
> @@ -248,10 +243,6 @@ retry:
>  
>  			if (wbc->nr_to_write <= 0)
>  				done = 1;
> -			if (wbc->nonblocking && bdi_write_congested(bdi)) {
> -				wbc->encountered_congestion = 1;
> -				done = 1;
> -			}
>  
>  			continue;
>  out_continue:
> --- linux.orig/fs/afs/write.c	2009-10-06 23:31:41.000000000 +0800
> +++ linux/fs/afs/write.c	2009-10-06 23:31:59.000000000 +0800
> @@ -455,8 +455,6 @@ int afs_writepage(struct page *page, str
>  	}
>  
>  	wbc->nr_to_write -= ret;
> -	if (wbc->nonblocking && bdi_write_congested(bdi))
> -		wbc->encountered_congestion = 1;
>  
>  	_leave(" = 0");
>  	return 0;
> @@ -529,11 +527,6 @@ static int afs_writepages_region(struct 
>  
>  		wbc->nr_to_write -= ret;
>  
> -		if (wbc->nonblocking && bdi_write_congested(bdi)) {
> -			wbc->encountered_congestion = 1;
> -			break;
> -		}
> -
>  		cond_resched();
>  	} while (index < end && wbc->nr_to_write > 0);
>  
> @@ -554,18 +547,11 @@ int afs_writepages(struct address_space 
>  
>  	_enter("");
>  
> -	if (wbc->nonblocking && bdi_write_congested(bdi)) {
> -		wbc->encountered_congestion = 1;
> -		_leave(" = 0 [congest]");
> -		return 0;
> -	}
> -
>  	if (wbc->range_cyclic) {
>  		start = mapping->writeback_index;
>  		end = -1;
>  		ret = afs_writepages_region(mapping, wbc, start, end, &next);
> -		if (start > 0 && wbc->nr_to_write > 0 && ret == 0 &&
> -		    !(wbc->nonblocking && wbc->encountered_congestion))
> +		if (start > 0 && wbc->nr_to_write > 0 && ret == 0)
>  			ret = afs_writepages_region(mapping, wbc, 0, start,
>  						    &next);
>  		mapping->writeback_index = next;
> --- linux.orig/fs/cifs/file.c	2009-10-06 23:31:41.000000000 +0800
> +++ linux/fs/cifs/file.c	2009-10-06 23:31:59.000000000 +0800
> @@ -1379,16 +1379,6 @@ static int cifs_writepages(struct addres
>  		return generic_writepages(mapping, wbc);
>  
>  
> -	/*
> -	 * BB: Is this meaningful for a non-block-device file system?
> -	 * If it is, we should test it again after we do I/O
> -	 */
> -	if (wbc->nonblocking && bdi_write_congested(bdi)) {
> -		wbc->encountered_congestion = 1;
> -		kfree(iov);
> -		return 0;
> -	}
> -
>  	xid = GetXid();
>  
>  	pagevec_init(&pvec, 0);
> --- linux.orig/fs/gfs2/aops.c	2009-10-06 23:31:41.000000000 +0800
> +++ linux/fs/gfs2/aops.c	2009-10-06 23:31:59.000000000 +0800
> @@ -313,11 +313,6 @@ static int gfs2_write_jdata_pagevec(stru
>  
>  		if (ret || (--(wbc->nr_to_write) <= 0))
>  			ret = 1;
> -		if (wbc->nonblocking && bdi_write_congested(bdi)) {
> -			wbc->encountered_congestion = 1;
> -			ret = 1;
> -		}
> -
>  	}
>  	gfs2_trans_end(sdp);
>  	return ret;
> @@ -348,11 +343,6 @@ static int gfs2_write_cache_jdata(struct
>  	int scanned = 0;
>  	int range_whole = 0;
>  
> -	if (wbc->nonblocking && bdi_write_congested(bdi)) {
> -		wbc->encountered_congestion = 1;
> -		return 0;
> -	}
> -
>  	pagevec_init(&pvec, 0);
>  	if (wbc->range_cyclic) {
>  		index = mapping->writeback_index; /* Start from prev offset */
> --- linux.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-10-06 23:31:41.000000000 +0800
> +++ linux/fs/xfs/linux-2.6/xfs_aops.c	2009-10-06 23:31:59.000000000 +0800
> @@ -890,12 +890,8 @@ xfs_convert_page(
>  
>  			bdi = inode->i_mapping->backing_dev_info;
>  			wbc->nr_to_write--;
> -			if (bdi_write_congested(bdi)) {
> -				wbc->encountered_congestion = 1;
> +			if (wbc->nr_to_write <= 0)
>  				done = 1;
> -			} else if (wbc->nr_to_write <= 0) {
> -				done = 1;
> -			}
>  		}
>  		xfs_start_page_writeback(page, !page_dirty, count);
>  	}
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbZIWH45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbZIWH45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbZIWH44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:56:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:53326 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193AbZIWH4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:56:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,437,1249282800"; 
   d="scan'208";a="190661556"
Date: Wed, 23 Sep 2009 15:56:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: Fix busyloop in wb_writeback()
Message-ID: <20090923075648.GA5976@localhost>
References: <1253121768-20673-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253121768-20673-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 01:22:48AM +0800, Jan Kara wrote:
> If all inodes are under writeback (e.g. in case when there's only one inode
> with dirty pages), wb_writeback() with WB_SYNC_NONE work basically degrades
> to busylooping until I_SYNC flags of the inode is cleared. Fix the problem by
> waiting on I_SYNC flags of an inode on b_more_io list in case we failed to
> write anything.

Hi Jan,

I reconfirmed that this patch fixed the busy loop in wb_writeback()
path. I also noticed that balance_dirty_pages() looped a lot.  Given
that balance_dirty_pages() schedules in between, it cannot be called
busy loop. But the loop interval is about 0.01s, which is shorter than
the expected 0.1s. This is a 2-core CPU, so I guess the cp process got
re-scheduled immediately, long before it timed out.

[  491.440702] requeue_io() +457: inode=39381
[  491.442360] mm/page-writeback.c +540 balance_dirty_pages(): comm=cp pid=3302 n=0
[  491.444257] global dirty=51770 writeback=18201 nfs=0 flags=_M towrite=1536 skipped=0
[  491.445856] requeue_io() +457: inode=39381
[  491.446543] mm/page-writeback.c +540 balance_dirty_pages(): comm=cp pid=3302 n=0
[  491.448346] global dirty=51770 writeback=18201 nfs=0 flags=_M towrite=1536 skipped=0
[  491.460535] requeue_io() +457: inode=39381
[  491.462206] mm/page-writeback.c +540 balance_dirty_pages(): comm=cp pid=3302 n=0
[  491.463574] global dirty=51894 writeback=18077 nfs=0 flags=_M towrite=1536 skipped=0
[  491.474072] requeue_io() +457: inode=39381
[  491.475416] mm/page-writeback.c +540 balance_dirty_pages(): comm=cp pid=3302 n=0
[  491.477220] global dirty=52049 writeback=17922 nfs=0 flags=_M towrite=1536 skipped=0
[  491.481859] requeue_io() +457: inode=39381
[  491.482618] mm/page-writeback.c +540 balance_dirty_pages(): comm=cp pid=3302 n=0
[  491.485026] global dirty=52049 writeback=17798 nfs=0 flags=_M towrite=1536 skipped=0
[  491.496843] requeue_io() +457: inode=39381
[  491.499001] mm/page-writeback.c +540 balance_dirty_pages(): comm=cp pid=3302 n=0
[  491.500658] global dirty=52173 writeback=17674 nfs=0 flags=_M towrite=1536 skipped=0
[  491.508540] requeue_io() +457: inode=39381
[  491.509490] mm/page-writeback.c +540 balance_dirty_pages(): comm=cp pid=3302 n=0
[  491.511300] global dirty=52297 writeback=17674 nfs=0 flags=_M towrite=1536 skipped=0
[  491.517728] requeue_io() +457: inode=39381
[  491.518752] mm/page-writeback.c +540 balance_dirty_pages(): comm=cp pid=3302 n=0
[  491.521498] global dirty=52421 writeback=17550 nfs=0 flags=_M towrite=1536 skipped=0
[  491.525881] requeue_io() +457: inode=39381
[  491.527339] mm/page-writeback.c +540 balance_dirty_pages(): comm=cp pid=3302 n=0
[  491.528730] global dirty=52421 writeback=17550 nfs=0 flags=_M towrite=1536 skipped=0

Thanks,
Fengguang


> CC: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/fs-writeback.c |   19 ++++++++++++++++++-
>  1 files changed, 18 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 8e1e5e1..c59d673 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -706,6 +706,7 @@ static long wb_writeback(struct bdi_writeback *wb,
>  	};
>  	unsigned long oldest_jif;
>  	long wrote = 0;
> +	struct inode *inode;
>  
>  	if (wbc.for_kupdate) {
>  		wbc.older_than_this = &oldest_jif;
> @@ -747,8 +748,24 @@ static long wb_writeback(struct bdi_writeback *wb,
>  		 * If we ran out of stuff to write, bail unless more_io got set
>  		 */
>  		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> -			if (wbc.more_io && !wbc.for_kupdate)
> +			if (wbc.more_io && !wbc.for_kupdate) {
> +				if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
> +					continue;
> +				/*
> +				 * Nothing written. Wait for some inode to
> +				 * become available for writeback. Otherwise
> +				 * we'll just busyloop.
> +				 */
> +				spin_lock(&inode_lock);
> +				if (!list_empty(&wb->b_more_io))  {
> +					inode = list_entry(
> +							wb->b_more_io.prev,
> +							struct inode, i_list);
> +					inode_wait_for_writeback(inode);
> +				}
> +				spin_unlock(&inode_lock);
>  				continue;
> +			}
>  			break;
>  		}
>  	}
> -- 
> 1.6.0.2

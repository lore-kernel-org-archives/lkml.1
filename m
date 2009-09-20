Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbZITCfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbZITCfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 22:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZITCfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 22:35:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:21746 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbZITCfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 22:35:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,417,1249282800"; 
   d="scan'208";a="189539175"
Date: Sun, 20 Sep 2009 10:35:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>
Subject: Re: [PATCH] fs: Fix busyloop in wb_writeback()
Message-ID: <20090920023528.GA13114@localhost>
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

Sorry, I realized that inode_wait_for_writeback() waits for I_SYNC.
But inodes in b_more_io are not expected to have I_SYNC set. So your
patch looks like a big no-op?

The busy loop does exists, when bdi is congested.
In this case, write_cache_pages() will refuse to write anything,
we used to be calling congestion_wait() to take a breath, but now
wb_writeback() purged that call and thus created a busy loop.

So the solution (at least for this merge window)
should be to restore the congestion_wait() call.

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

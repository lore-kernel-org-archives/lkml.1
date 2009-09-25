Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZIYAwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZIYAwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZIYAwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:52:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:9231 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZIYAwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:52:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,448,1249282800"; 
   d="scan'208";a="191452640"
Date: Fri, 25 Sep 2009 08:52:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "jack@suse.cz" <jack@suse.cz>
Subject: Re: [PATCH 06/10] writeback: improve readability of the
	wb_writeback() continue/break logic
Message-ID: <20090925005241.GC6190@localhost>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com> <1253803236-20760-7-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253803236-20760-7-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 10:40:32PM +0800, Jens Axboe wrote:
> And throw some comments in there, too.

Nice cleanup!

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  fs/fs-writeback.c |   43 +++++++++++++++++++++++--------------------
>  1 files changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 916e834..15e375b 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -750,29 +750,32 @@ static long wb_writeback(struct bdi_writeback *wb,
>  		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
>  
>  		/*
> -		 * If we ran out of stuff to write, bail unless more_io got set
> +		 * If we consumed everything, see if we have more
>  		 */
> -		if (wbc.nr_to_write > 0) {
> -			if (wbc.more_io) {
> -				if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
> -					continue;
> -				/*
> -				 * Nothing written. Wait for some inode to
> -				 * become available for writeback. Otherwise
> -				 * we'll just busyloop.
> -				 */
> -				spin_lock(&inode_lock);
> -				if (!list_empty(&wb->b_more_io))  {
> -					inode = list_entry(
> -							wb->b_more_io.prev,
> -							struct inode, i_list);
> -					inode_wait_for_writeback(inode);
> -				}
> -				spin_unlock(&inode_lock);
> -				continue;
> -			}
> +		if (wbc.nr_to_write <= 0)
> +			continue;
> +		/*
> +		 * Didn't write everything and we don't have more IO, bail
> +		 */
> +		if (!wbc.more_io)
>  			break;
> +		/*
> +		 * Did we write something? Try for more
> +		 */
> +		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
> +			continue;
> +		/*
> +		 * Nothing written. Wait for some inode to
> +		 * become available for writeback. Otherwise
> +		 * we'll just busyloop.
> +		 */
> +		spin_lock(&inode_lock);
> +		if (!list_empty(&wb->b_more_io))  {
> +			inode = list_entry(wb->b_more_io.prev,
> +						struct inode, i_list);
> +			inode_wait_for_writeback(inode);
>  		}
> +		spin_unlock(&inode_lock);
>  	}
>  
>  	return wrote;
> -- 
> 1.6.4.1.207.g68ea

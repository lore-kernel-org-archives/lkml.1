Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbZEYImj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbZEYImj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZEYIm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:42:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbZEYIm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:42:27 -0400
Date: Mon, 25 May 2009 10:42:25 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 03/12] writeback: move dirty inodes from super_block to
	backing_dev_info
Message-ID: <20090525084225.GB23546@duck.suse.cz>
References: <1243236887-3931-1-git-send-email-jens.axboe@oracle.com> <1243236887-3931-4-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243236887-3931-4-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 25-05-09 09:34:38, Jens Axboe wrote:
> This is a first step at introducing per-bdi flusher threads. We should
> have no change in behaviour, although sb_has_dirty_inodes() is now
> ridiculously expensive, as there's no easy way to answer that question.
> Not a huge problem, since it'll be deleted in subsequent patches.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  fs/fs-writeback.c           |  196 +++++++++++++++++++++++++++---------------
>  fs/super.c                  |    3 -
>  include/linux/backing-dev.h |    9 ++
>  include/linux/fs.h          |    5 +-
>  mm/backing-dev.c            |   30 +++++++
>  mm/page-writeback.c         |   11 +--
>  6 files changed, 170 insertions(+), 84 deletions(-)
...
> @@ -225,9 +231,23 @@ int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
>  }
>  EXPORT_SYMBOL(bdi_register_dev);
>  
> +static void bdi_remove_from_list(struct backing_dev_info *bdi)
> +{
> +	mutex_lock(&bdi_lock);
> +	list_del_rcu(&bdi->bdi_list);
> +	mutex_unlock(&bdi_lock);
> +
> +	/*
> +	 * In case the bdi is freed right after unregister, we need to
> +	 * make sure any RCU sections have exited
> +	 */
> +	synchronize_rcu();
> +}
> +
  Is this RCU thing still valid? And in bdi_register_dev() as well...

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

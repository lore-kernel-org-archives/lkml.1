Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbZIPNnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbZIPNnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZIPNnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:43:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbZIPNno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:43:44 -0400
Date: Wed, 16 Sep 2009 15:43:46 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 10/16] writeback: splice dirty inode entries to default
	bdi on bdi_destroy()
Message-ID: <20090916134346.GM26030@duck.suse.cz>
References: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com> <1253107494-20160-11-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253107494-20160-11-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-09-09 15:24:48, Jens Axboe wrote:
> We cannot safely ensure that the inodes are all gone at this point
> in time, and we must not destroy this bdi with inodes having off it.
> So just splice our entries to the default bdi since that one will
> always persist.
  I'd at least add a comment like
"XXX: This is probably a bug but let's workaround it for now."
  And either remove the code or update the comment when this gets resolved.

								Honza 
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  mm/backing-dev.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index fd93566..3d3accb 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -668,7 +668,19 @@ void bdi_destroy(struct backing_dev_info *bdi)
>  {
>  	int i;
>  
> -	WARN_ON(bdi_has_dirty_io(bdi));
> +	/*
> +	 * Splice our entries to the default_backing_dev_info, if this
> +	 * bdi disappears
> +	 */
> +	if (bdi_has_dirty_io(bdi)) {
> +		struct bdi_writeback *dst = &default_backing_dev_info.wb;
> +
> +		spin_lock(&inode_lock);
> +		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
> +		list_splice(&bdi->wb.b_io, &dst->b_io);
> +		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
> +		spin_unlock(&inode_lock);
> +	}
>  
>  	bdi_unregister(bdi);
>  
> -- 
> 1.6.4.1.207.g68ea
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

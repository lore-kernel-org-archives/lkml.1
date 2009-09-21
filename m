Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZIUNLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZIUNLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbZIUNLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:11:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:56399 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbZIUNLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:11:36 -0400
Date: Mon, 21 Sep 2009 15:11:38 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jack@suse.cz,
       fengguang.wu@intel.com
Subject: Re: [GIT PULL] a few writeback fixes
Message-ID: <20090921131138.GE1099@duck.suse.cz>
References: <20090921125620.GV23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921125620.GV23126@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-09-09 14:56:20, Jens Axboe wrote:
  Hi Jens,

> Jan, since we're not really sure on the inode wait yet, I dropped that
> patch. It's definitely something to look into, as are the congestion
> bits.
  OK.

								Honza

> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 1eea4fa..6bb510b 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -485,6 +485,7 @@ static void balance_dirty_pages(struct address_space *mapping)
>  	unsigned long bdi_thresh;
>  	unsigned long pages_written = 0;
>  	unsigned long write_chunk = sync_writeback_pages();
> +	unsigned long pause = 1;
>  
>  	struct backing_dev_info *bdi = mapping->backing_dev_info;
>  
> @@ -561,7 +562,15 @@ static void balance_dirty_pages(struct address_space *mapping)
>  		if (pages_written >= write_chunk)
>  			break;		/* We've done our duty */
>  
> -		schedule_timeout(1);
> +		schedule_timeout_interruptible(pause);
> +
> +		/*
> +		 * Increase the delay for each loop, up to our previous
> +		 * default of taking a 100ms nap.
> +		 */
> +		pause <<= 1;
> +		if (pause < HZ / 10)
> +			pause = HZ / 10;
  Isn't this check the other way around?

>  	}
>  
>  	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

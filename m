Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbZIIPoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbZIIPoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbZIIPoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:44:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:57244 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbZIIPoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:44:17 -0400
Date: Wed, 9 Sep 2009 17:44:13 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>, jack@suse.cz,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH 7/7] writeback: balance_dirty_pages() shall write
	more than dirtied pages
Message-ID: <20090909154413.GC7949@duck.suse.cz>
References: <20090909145141.293229693@intel.com> <20090909150601.159061863@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909150601.159061863@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 09-09-09 22:51:48, Wu Fengguang wrote:
> Some filesystem may choose to write much more than ratelimit_pages
> before calling balance_dirty_pages_ratelimited_nr(). So it is safer to
> determine number to write based on real number of dirtied pages.
> 
> The increased write_chunk may make the dirtier more bumpy.  This is
> filesystem writers' duty not to dirty too much at a time without
> checking the ratelimit.
  I don't get this. balance_dirty_pages_ratelimited_nr() is called when we
dirty the page, not when we write it out. So a problem would only happen if
filesystem dirties pages by set_page_dirty() and won't call
balance_dirty_pages_ratelimited_nr(). But e.g. generic_perform_write()
and do_wp_page() takes care of that. So where's the problem?

								Honza
> ---
>  mm/page-writeback.c |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> --- linux.orig/mm/page-writeback.c	2009-09-09 21:19:21.000000000 +0800
> +++ linux/mm/page-writeback.c	2009-09-09 21:25:45.000000000 +0800
> @@ -44,12 +44,12 @@ static long ratelimit_pages = 32;
>  /*
>   * When balance_dirty_pages decides that the caller needs to perform some
>   * non-background writeback, this is how many pages it will attempt to write.
> - * It should be somewhat larger than RATELIMIT_PAGES to ensure that reasonably
> + * It should be somewhat larger than dirtied pages to ensure that reasonably
>   * large amounts of I/O are submitted.
>   */
> -static inline long sync_writeback_pages(void)
> +static inline long sync_writeback_pages(unsigned long dirtied)
>  {
> -	return ratelimit_pages + ratelimit_pages / 2;
> +	return dirtied + dirtied / 2;
>  }
>  
>  /* The following parameters are exported via /proc/sys/vm */
> @@ -476,7 +476,8 @@ get_dirty_limits(unsigned long *pbackgro
>   * If we're over `background_thresh' then pdflush is woken to perform some
>   * writeout.
>   */
> -static void balance_dirty_pages(struct address_space *mapping)
> +static void balance_dirty_pages(struct address_space *mapping,
> +				unsigned long write_chunk)
>  {
>  	long nr_reclaimable, bdi_nr_reclaimable;
>  	long nr_writeback, bdi_nr_writeback;
> @@ -484,7 +485,6 @@ static void balance_dirty_pages(struct a
>  	unsigned long dirty_thresh;
>  	unsigned long bdi_thresh;
>  	unsigned long pages_written = 0;
> -	unsigned long write_chunk = sync_writeback_pages();
>  
>  	struct backing_dev_info *bdi = mapping->backing_dev_info;
>  
> @@ -638,9 +638,10 @@ void balance_dirty_pages_ratelimited_nr(
>  	p =  &__get_cpu_var(bdp_ratelimits);
>  	*p += nr_pages_dirtied;
>  	if (unlikely(*p >= ratelimit)) {
> +		ratelimit = sync_writeback_pages(*p);
>  		*p = 0;
>  		preempt_enable();
> -		balance_dirty_pages(mapping);
> +		balance_dirty_pages(mapping, ratelimit);
>  		return;
>  	}
>  	preempt_enable();
> 
> -- 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

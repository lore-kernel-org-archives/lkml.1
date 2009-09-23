Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbZIWMpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbZIWMpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZIWMpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:45:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38732 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZIWMpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:45:53 -0400
Date: Wed, 23 Sep 2009 08:45:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jan Kara <jack@suse.cz>,
       "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] writeback: balance_dirty_pages() shall write more
	than dirtied pages
Message-ID: <20090923124529.GA26263@infradead.org>
References: <20090923123337.990689487@intel.com> <20090923124027.456325340@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923124027.456325340@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 08:33:39PM +0800, Wu Fengguang wrote:
> Some filesystem may choose to write much more than ratelimit_pages
> before calling balance_dirty_pages_ratelimited_nr(). So it is safer to
> determine number to write based on real number of dirtied pages.
> 
> The increased write_chunk may make the dirtier more bumpy.  This is
> filesystem writers' duty not to dirty too much at a time without
> checking the ratelimit.

For some reason the filesystems tricking around
balance_dirty_pages_ratelimited's semantics seem to get much better
buffered write performance.  Are you sure this is not going to destroy
that benefit?  (But yes, we should make sure it behaves the same for all
filesystems)

> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/page-writeback.c |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> --- linux.orig/mm/page-writeback.c	2009-09-23 16:31:46.000000000 +0800
> +++ linux/mm/page-writeback.c	2009-09-23 16:33:19.000000000 +0800
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
>  	unsigned long pause = 1;
>  
>  	struct backing_dev_info *bdi = mapping->backing_dev_info;
> @@ -640,9 +640,10 @@ void balance_dirty_pages_ratelimited_nr(
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
> 
---end quoted text---

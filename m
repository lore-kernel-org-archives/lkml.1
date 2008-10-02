Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbYJBFzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbYJBFzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 01:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYJBFzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 01:55:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552AbYJBFzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 01:55:35 -0400
Date: Wed, 1 Oct 2008 22:54:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org, agk@redhat.com,
       mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH 2/3] Memory management livelock
Message-Id: <20081001225404.4e973465.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
	<Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
	<20080923154905.50d4b0fa.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
	<20080923164623.ce82c1c2.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH 2/3] Memory management livelock

Please don't send multiple patches with identical titles - think up a
good, unique, meaningful title for each patch.

On Wed, 24 Sep 2008 14:52:18 -0400 (EDT) Mikulas Patocka <mpatocka@redhat.com> wrote:

> Avoid starvation when walking address space.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 

Please include a full changelog with each iteration of each patch.

That changelog should explain the reason for playing games with
bitlocks so Linus doesn't have kittens when he sees it.

>  include/linux/pagemap.h |    1 +
>  mm/filemap.c            |   20 ++++++++++++++++++++
>  mm/page-writeback.c     |   37 ++++++++++++++++++++++++++++++++++++-
>  mm/truncate.c           |   24 +++++++++++++++++++++++-
>  4 files changed, 80 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.27-rc7-devel/include/linux/pagemap.h
> ===================================================================
> --- linux-2.6.27-rc7-devel.orig/include/linux/pagemap.h	2008-09-24 02:57:37.000000000 +0200
> +++ linux-2.6.27-rc7-devel/include/linux/pagemap.h	2008-09-24 02:59:04.000000000 +0200
> @@ -21,6 +21,7 @@
>  #define	AS_EIO		(__GFP_BITS_SHIFT + 0)	/* IO error on async write */
>  #define AS_ENOSPC	(__GFP_BITS_SHIFT + 1)	/* ENOSPC on async write */
>  #define AS_MM_ALL_LOCKS	(__GFP_BITS_SHIFT + 2)	/* under mm_take_all_locks() */
> +#define AS_STARVATION	(__GFP_BITS_SHIFT + 3)	/* an anti-starvation barrier */
>  
>  static inline void mapping_set_error(struct address_space *mapping, int error)
>  {
> Index: linux-2.6.27-rc7-devel/mm/filemap.c
> ===================================================================
> --- linux-2.6.27-rc7-devel.orig/mm/filemap.c	2008-09-24 02:59:33.000000000 +0200
> +++ linux-2.6.27-rc7-devel/mm/filemap.c	2008-09-24 03:13:47.000000000 +0200
> @@ -269,10 +269,19 @@ int wait_on_page_writeback_range(struct 
>  	int nr_pages;
>  	int ret = 0;
>  	pgoff_t index;
> +	long pages_to_process;
>  
>  	if (end < start)
>  		return 0;
>  
> +	/*
> +	 * Estimate the number of pages to process. If we process significantly
> +	 * more than this, someone is making writeback pages under us.
> +	 * We must pull the anti-starvation plug.
> +	 */
> +	pages_to_process = bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
> +	pages_to_process += (pages_to_process >> 3) + 16;

This sequence appears twice and it would probably be clearer to
implement it in a well-commented function.

>  	pagevec_init(&pvec, 0);
>  	index = start;
>  	while ((index <= end) &&
> @@ -288,6 +297,10 @@ int wait_on_page_writeback_range(struct 
>  			if (page->index > end)
>  				continue;
>  
> +			if (pages_to_process >= 0)
> +				if (!pages_to_process--)
> +					wait_on_bit_lock(&mapping->flags, AS_STARVATION, wait_action_schedule, TASK_UNINTERRUPTIBLE);

This is copied three times and perhaps also should be factored out.

Please note that an effort has been made to make mm/filemap.c look
presentable in an 80-col display.

>  			wait_on_page_writeback(page);
>  			if (PageError(page))
>  				ret = -EIO;
> @@ -296,6 +309,13 @@ int wait_on_page_writeback_range(struct 
>  		cond_resched();
>  	}
>  
> +	if (pages_to_process < 0) {
> +		smp_mb__before_clear_bit();
> +		clear_bit(AS_STARVATION, &mapping->flags);
> +		smp_mb__after_clear_bit();
> +		wake_up_bit(&mapping->flags, AS_STARVATION);
> +	}

This sequence is repeated three or four times and should be pulled out
into a well-commented function.  That comment should explain the logic
behind the use of these barriers, please.



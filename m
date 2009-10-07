Return-Path: <linux-kernel-owner+w=401wt.eu-S932822AbZJGL5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822AbZJGL5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932653AbZJGL5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:57:53 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:15306 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932612AbZJGL5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:57:52 -0400
X-Trace: 267881560/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.16.54/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.16.54
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAH4ezEpQKRA2/2dsb2JhbACBUdNcgjOBdwQ
X-IronPort-AV: E=Sophos;i="4.44,519,1249254000"; 
   d="scan'208";a="267881560"
Date: Wed, 7 Oct 2009 12:57:00 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Li Shaohua <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 29/45] writeback: fix the shmem AOP_WRITEPAGE_ACTIVATE
 case
In-Reply-To: <20091007074904.870825579@intel.com>
Message-ID: <Pine.LNX.4.64.0910071246180.28844@sister.anvils>
References: <20091007073818.318088777@intel.com> <20091007074904.870825579@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Wu Fengguang wrote:

> When shmem returns AOP_WRITEPAGE_ACTIVATE, the inode pages cannot be
> synced in the near future. So write_cache_pages shall stop writting this
> inode, and shmem shall increase pages_skipped to instruct VFS not to
> busy retry.
> 
> CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Okay, it embarrasses me to see AOP_WRITEPAGE_ACTIVATE (and its horrid
"in this one case the page is still locked" semantic) still around -
my patch to remove it vanished from mmotm (probably caused a temporary
conflict) and I've never chased it up (partly out of guilt that I'd not
yet kept my promise to contact the openAFS people about their use of it).

But that's orthogonal to your concern here: for so long as there has
been a wbc->pages_skipped, I guess shmem_writepage() should have been
incrementing it there - thanks.  But I don't believe the VFS will ever
have any interest in pages_skipped from shmem_writepage(): do you have
evidence that it does?  If so, I need to investigate.

And the accompanying change to write_cache_pages() seems irrelevant
and misguided.  Irrelevant because write_cache_pages() should never be
dealing with shmem_writepage() (its bdi should keep it well away), and
should never be dealing with reclaim, which is the only case in which
shmem_writepage() returns AOP_WRITEPAGE_ACTIVATE - or have your other
changes, or the bdi work, changed that?

And misguided because in your change to write_cache_pages() you're
taking AOP_WRITEPAGE_ACTIVATE to say that it should now give up, not
process more pages.  We just don't know that.  All it means is that
this one page couldn't be written and should be reactivated (if it
were under reclaim): it might be the case that every other page tried
after would get treated in the same way, or it might be the case that
the next page would get written successfully.  That info is just not
provided.

Hugh

> ---
>  mm/page-writeback.c |   23 +++++++++++------------
>  mm/shmem.c          |    1 +
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> --- linux.orig/mm/page-writeback.c	2009-10-06 23:39:28.000000000 +0800
> +++ linux/mm/page-writeback.c	2009-10-06 23:39:29.000000000 +0800
> @@ -851,19 +851,18 @@ continue_unlock:
>  				if (ret == AOP_WRITEPAGE_ACTIVATE) {
>  					unlock_page(page);
>  					ret = 0;
> -				} else {
> -					/*
> -					 * done_index is set past this page,
> -					 * so media errors will not choke
> -					 * background writeout for the entire
> -					 * file. This has consequences for
> -					 * range_cyclic semantics (ie. it may
> -					 * not be suitable for data integrity
> -					 * writeout).
> -					 */
> -					done = 1;
> -					break;
>  				}
> +				/*
> +				 * done_index is set past this page,
> +				 * so media errors will not choke
> +				 * background writeout for the entire
> +				 * file. This has consequences for
> +				 * range_cyclic semantics (ie. it may
> +				 * not be suitable for data integrity
> +				 * writeout).
> +				 */
> +				done = 1;
> +				break;
>   			}
>  
>  			if (nr_to_write > 0) {
> --- linux.orig/mm/shmem.c	2009-10-06 23:37:40.000000000 +0800
> +++ linux/mm/shmem.c	2009-10-06 23:39:29.000000000 +0800
> @@ -1103,6 +1103,7 @@ unlock:
>  	 */
>  	swapcache_free(swap, NULL);
>  redirty:
> +	wbc->pages_skipped++;
>  	set_page_dirty(page);
>  	if (wbc->for_reclaim)
>  		return AOP_WRITEPAGE_ACTIVATE;	/* Return with page locked */

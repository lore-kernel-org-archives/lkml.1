Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbYFYNMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbYFYNMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 09:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYFYNML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 09:12:11 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:42680 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbYFYNMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 09:12:10 -0400
Date: Wed, 25 Jun 2008 17:11:17 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hugh@veritas.com, nickpiggin@yahoo.com.au
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in invalidate_complete_page2()
Message-ID: <20080625131117.GA28136@2ka.mipt.ru>
References: <20080625124038.103406301@szeredi.hu> <20080625124121.839734708@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625124121.839734708@szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 02:40:39PM +0200, Miklos Szeredi (miklos@szeredi.hu) wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Clearing the uptodate page flag will cause page_cache_pipe_buf_confirm()
> to return -ENODATA if that page was in the buffer.  This in turn will cause
> splice() to return a short or zero count.
> 
> This manifested itself in rare I/O errors seen on nfs exported fuse
> filesystems.  This is because nfsd uses splice_direct_to_actor() to
> read files, and fuse uses invalidate_inode_pages2() to invalidate
> stale data on open.
> 
> Fix this by not clearing PG_uptodate on page invalidation.  This will
> result in the old, invalid page contents being copied.  But that's OK,
> the contents were valid at splice-in time (which is when the the
> "copy" was conceptually done).
> 
> I haven't done an audit of all code that checks the PG_uptodate flags,
> but I suspect, that this change won't have any harmful effects.  Most
> code checks page->mapping to see if the page was truncated or
> invalidated, before using it, and retries the find/read on the page if
> it wasn't.  The page_cache_pipe_buf_confirm() code is an exception in
> this regard.

What about writing path, when page is written after some previous write?
Like __block_prepare_write()?

> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  mm/truncate.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: linux-2.6/mm/truncate.c
> ===================================================================
> --- linux-2.6.orig/mm/truncate.c	2008-06-24 20:49:25.000000000 +0200
> +++ linux-2.6/mm/truncate.c	2008-06-24 23:28:32.000000000 +0200
> @@ -356,7 +356,6 @@ invalidate_complete_page2(struct address
>  	BUG_ON(PagePrivate(page));
>  	__remove_from_page_cache(page);
>  	write_unlock_irq(&mapping->tree_lock);
> -	ClearPageUptodate(page);
>  	page_cache_release(page);	/* pagecache ref */
>  	return 1;
>  failed:

Don't do that, add new function instead which will do exactly that, if
you do need exactly this behaviour.

Also why isn't invalidate_complete_page() enough, if you want to have
that page to be half invalidated?

-- 
	Evgeniy Polyakov

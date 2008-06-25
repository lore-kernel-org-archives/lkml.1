Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbYFYOSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbYFYOSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbYFYORs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:17:48 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:45179 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688AbYFYORr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:17:47 -0400
Date: Wed, 25 Jun 2008 18:16:55 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hugh@veritas.com, nickpiggin@yahoo.com.au
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in invalidate_complete_page2()
Message-ID: <20080625141654.GA4803@2ka.mipt.ru>
References: <20080625124038.103406301@szeredi.hu> <20080625124121.839734708@szeredi.hu> <20080625131117.GA28136@2ka.mipt.ru> <E1KBV7H-0005nv-Gl@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KBV7H-0005nv-Gl@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 03:32:55PM +0200, Miklos Szeredi (miklos@szeredi.hu) wrote:
> > What about writing path, when page is written after some previous write?
> 
> page->mapping should be checked in the write paths as well.

All we need from mapping here is where to put this page and inode
pointer.

> > Like __block_prepare_write()?
> 
> That's called with the page locked and page->mapping verified.

Only when called via standard codepath. If page was grabbed and page
unlocked and subsequently 'invalidated' via invalidate_complete_page2(),
it still relies on uptodate bit to be set to correctly work.

After all we do not need page mapping to write into given page, that's
why __block_prepare_write() does not check it.

> > > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > > ---
> > >  mm/truncate.c |    1 -
> > >  1 file changed, 1 deletion(-)
> > > 
> > > Index: linux-2.6/mm/truncate.c
> > > ===================================================================
> > > --- linux-2.6.orig/mm/truncate.c	2008-06-24 20:49:25.000000000 +0200
> > > +++ linux-2.6/mm/truncate.c	2008-06-24 23:28:32.000000000 +0200
> > > @@ -356,7 +356,6 @@ invalidate_complete_page2(struct address
> > >  	BUG_ON(PagePrivate(page));
> > >  	__remove_from_page_cache(page);
> > >  	write_unlock_irq(&mapping->tree_lock);
> > > -	ClearPageUptodate(page);
> > >  	page_cache_release(page);	/* pagecache ref */
> > >  	return 1;
> > >  failed:
> > 
> > Don't do that, add new function instead which will do exactly that, if
> > you do need exactly this behaviour.
> 
> I don't see any point in doing that.
> 
> > Also why isn't invalidate_complete_page() enough, if you want to have
> > that page to be half invalidated?
> 
> I want the page fully invalidated, and I also want splice and nfs
> exporting to work as for other filesystems.

Fully invalidated page can not be uptodate, doesnt' it? :)

You destroy existing functionality just because there are some obscure
places, where it is used, so instead of fixing that places, you treat
the symptom. After writing previous mail I found a way to workaround it
even with your changes, but the whole approach of changing
invalidate_complete_page2() is not correct imho.

Your note:
>Let's start with page_cache_pipe_buf_confirm().  How should we deal
>with finding an invalidated page (!PageUptodate(page) &&
>!page->mapping)?

>We could return zero to use the contents even though it was
>invalidated, not good, but if the page was originally uptodate, then
>it should be OK to use the stale data.  But it could have been
>invalidated before becoming uptodate, so the contents could be total
>crap, and that's not good.  So now we have to tweak page invalidation
>to differentiate between was-uptodate and was-never-uptodate pages.

Is this nfs/fuse problem you described:
http://marc.info/?l=linux-fsdevel&m=121396920822693&w=2

Instead of returning error when reading from invalid page, now you
return old content of it? From description on above link it is not the
case, when user reads data into splice pipe and suddenly it becomes
invalidated, which you try to fix with this patch, but it may be
completely different problem though.

-- 
	Evgeniy Polyakov

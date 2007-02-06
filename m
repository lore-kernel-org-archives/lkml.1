Return-Path: <linux-kernel-owner+w=401wt.eu-S1751614AbXBFIbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbXBFIbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbXBFIbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:31:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:56432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbXBFIbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:31:14 -0500
Date: Tue, 6 Feb 2007 09:31:03 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>
Subject: Re: [patch 2/3] fs: buffer don't PageUptodate without page locked
Message-ID: <20070206083103.GB16965@wotan.suse.de>
References: <20070206054925.21042.50546.sendpatchset@linux.site> <20070206054947.21042.32493.sendpatchset@linux.site> <20070206002140.4030a11f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206002140.4030a11f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 12:21:40AM -0800, Andrew Morton wrote:
> On Tue,  6 Feb 2007 09:02:23 +0100 (CET) Nick Piggin <npiggin@suse.de> wrote:
> 
> > __block_write_full_page is calling SetPageUptodate without the page locked.
> > This is unusual, but not incorrect, as PG_writeback is still set.
> > 
> > However with the previous patch, this is now a problem: so don't bother
> > setting the page uptodate in this case (it is weird that the write path
> > does such a thing anyway). Instead just leave it to the read side to bring
> > the page uptodate when it notices that all buffers are uptodate.
> > 
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > 
> > Index: linux-2.6/fs/buffer.c
> > ===================================================================
> > --- linux-2.6.orig/fs/buffer.c
> > +++ linux-2.6/fs/buffer.c
> > @@ -1679,6 +1679,7 @@ static int __block_write_full_page(struc
> >  	 */
> >  	BUG_ON(PageWriteback(page));
> >  	set_page_writeback(page);
> > +	unlock_page(page);
> >  
> >  	do {
> >  		struct buffer_head *next = bh->b_this_page;
> > @@ -1688,7 +1689,6 @@ static int __block_write_full_page(struc
> >  		}
> >  		bh = next;
> >  	} while (bh != head);
> > -	unlock_page(page);
> >  
> >  	err = 0;
> >  done:
> 
> Why this change?  Without looking at it too hard, it seems that if
> submit_bh() completes synchronously, this thread can end up playing with
> the buffers on a non-locked, non-PageWriteback page.  Someone else could
> whip the buffers away and oops?

Hmm, it definitely shouldn't be there, it leaked in from another patch
to bring partiy with the error handling...

Here is an updated patch.

--

__block_write_full_page is calling SetPageUptodate without the page locked.
This is unusual, but not incorrect, as PG_writeback is still set.

However with the previous patch, this is now a problem: so don't bother
setting the page uptodate in this case (it is weird that the write path
does such a thing anyway). Instead just leave it to the read side to bring
the page uptodate when it notices that all buffers are uptodate.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -1698,17 +1698,8 @@ done:
 		 * clean.  Someone wrote them back by hand with
 		 * ll_rw_block/submit_bh.  A rare case.
 		 */
-		int uptodate = 1;
-		do {
-			if (!buffer_uptodate(bh)) {
-				uptodate = 0;
-				break;
-			}
-			bh = bh->b_this_page;
-		} while (bh != head);
-		if (uptodate)
-			SetPageUptodate(page);
 		end_page_writeback(page);
+
 		/*
 		 * The page and buffer_heads can be released at any time from
 		 * here on.

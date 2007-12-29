Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbXL2EvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbXL2EvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 23:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbXL2EvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 23:51:05 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51487 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbXL2EvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 23:51:04 -0500
Subject: Re: [PATCH] jfs: clear PAGECACHE_TAG_DIRTY for no-write pages
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <E1J8RJw-0001ge-DP@localhost>
References: <E1J8AC5-0002BE-RP@localhost> <1198841626.6821.92.camel@twins>
	 <1198859101.13075.10.camel@norville.austin.ibm.com>
	 <1198860794.13075.15.camel@norville.austin.ibm.com>
	 <E1J8RJw-0001ge-DP@localhost>
Content-Type: text/plain
Date: Fri, 28 Dec 2007 22:50:59 -0600
Message-Id: <1198903859.6353.7.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-29 at 10:21 +0800, Fengguang Wu wrote:
> On Fri, Dec 28, 2007 at 10:53:14AM -0600, Dave Kleikamp wrote:
> 
> 
> > ---
> > 
> > diff -Nurp linux-2.6.24-rc6-git5/fs/jfs/jfs_metapage.c linux/fs/jfs/jfs_metapage.c
> > --- linux-2.6.24-rc6-git5/fs/jfs/jfs_metapage.c	2007-12-28 10:28:33.000000000 -0600
> > +++ linux/fs/jfs/jfs_metapage.c	2007-12-28 10:37:30.000000000 -0600
> > @@ -360,6 +360,7 @@ static int metapage_writepage(struct pag
> >  	struct metapage *mp;
> >  	int redirty = 0;
> >  	sector_t lblock;
> > +	int nr_underway = 0;
> >  	sector_t pblock;
> >  	sector_t next_block = 0;
> >  	sector_t page_start;
> > @@ -371,6 +372,7 @@ static int metapage_writepage(struct pag
> >  		     (PAGE_CACHE_SHIFT - inode->i_blkbits);
> >  	BUG_ON(!PageLocked(page));
> >  	BUG_ON(PageWriteback(page));
> 
> This line should be moved below:
> > +	set_page_writeback(page);

No.  set_page_writeback() needs to be called before submit_bio() is
called.

I don't think there is any harm in calling set_page_writeback(),
redirty_page_for_writeback() and end_page_writeback() in the case where
there is no I/O to submit, and some dirty data cannot be written.  It is
consistent with what happens in __block_write_full_page().

It's also possible that some part of the page was written, and another
part cannot be, causing the page to be redirtied.

> >  
> >  	for (offset = 0; offset < PAGE_CACHE_SIZE; offset += PSIZE) {
> >  		mp = page_to_mp(page, offset);
> > @@ -413,11 +415,10 @@ static int metapage_writepage(struct pag
> >  			if (!bio->bi_size)
> >  				goto dump_bio;
> >  			submit_bio(WRITE, bio);
> > +			nr_underway++;
> >  			bio = NULL;
> > -		} else {
> > -			set_page_writeback(page);
> > +		} else
> >  			inc_io(page);
> > -		}
> >  		xlen = (PAGE_CACHE_SIZE - offset) >> inode->i_blkbits;
> >  		pblock = metapage_get_blocks(inode, lblock, &xlen);
> >  		if (!pblock) {
> > @@ -449,12 +450,16 @@ static int metapage_writepage(struct pag
> >  			goto dump_bio;
> >  
> >  		submit_bio(WRITE, bio);
> > +		nr_underway++;
> >  	}
> >  	if (redirty)
> >  		redirty_page_for_writepage(wbc, page);
> +       else
> +               set_page_writeback(page);
> >  
> >  	unlock_page(page);
> >  
> > +	if (nr_underway == 0)
>   +     if (nr_underway == 0 && redirty == 0)
> 
> > +		end_page_writeback(page);
> > +
> >  	return 0;
> >  add_failed:
> >  	/* We should never reach here, since we're only adding one vec */
> 
> Otherwise looks pretty good.
> 
> Reviewed-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> 
-- 
David Kleikamp
IBM Linux Technology Center


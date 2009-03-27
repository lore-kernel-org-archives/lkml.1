Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZC0V1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZC0V1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZC0V0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:26:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:40627 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZC0V0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:26:51 -0400
Date: Fri, 27 Mar 2009 22:26:45 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090327212645.GF31071@duck.suse.cz>
References: <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326181106.GC17159@duck.suse.cz> <20090326113529.d1e906f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326113529.d1e906f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 26-03-09 11:35:29, Andrew Morton wrote:
> 
> The patch looks OK to me.
> 
> On Thu, 26 Mar 2009 19:11:06 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > @@ -1490,6 +1494,16 @@ static int ext3_ordered_writepage(struct page *page,
> >  	if (ext3_journal_current_handle())
> >  		goto out_fail;
> >  
> > +	if (!page_has_buffers(page)) {
> > +		create_empty_buffers(page, inode->i_sb->s_blocksize,
> > +				(1 << BH_Dirty)|(1 << BH_Uptodate));
> 
> This will attach dirty buffers to a clean page, which is an invalid
> state (but OK if we immediately fix it up).
  Yes - actually the page has been dirty just the moment before when we run
clear_page_dirty_for_io() - and at this function could have also created
the clean page with dirty buffers...

> > +	} else if (!walk_page_buffers(NULL, page_buffers(page), 0, PAGE_CACHE_SIZE, NULL, buffer_unmapped)) {
> > +		/* Provide NULL instead of get_block so that we catch bugs if buffers weren't really mapped */
> > +		return block_write_full_page(page, NULL, wbc);
> > +	}
> > +	page_bufs = page_buffers(page);
> > +
> > +
> >  	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
> >  
> >  	if (IS_ERR(handle)) {
> 
> And if this error happens we'll go on to run
> redirty_page_for_writepage() which will do the right thing.
> 
> However if PageMappedToDisk() is working right, we should be able to
> avoid that newly-added buffer walk.  Possibly SetPageMappedToDisk()
> isn't being run in all the right places though, dunno.
  Yes, SetPageMappedToDisk is set only by block_read_full_page(),
mpage_readpage() and nobh_write_begin(). Obviously not enough... It would
be nice to improve that but that's another story...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

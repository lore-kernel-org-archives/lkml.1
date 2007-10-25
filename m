Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbXJYWtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbXJYWtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbXJYWtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:49:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXJYWtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:49:45 -0400
Date: Fri, 26 Oct 2007 00:49:41 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] fs: restore nobh
Message-ID: <20071025224941.GB6453@wotan.suse.de>
References: <20071008065227.GB14949@wotan.suse.de> <20071025190736.GB12883@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025190736.GB12883@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 09:07:36PM +0200, Jan Kara wrote:
>   Hi,
> 
> > This is overdue, sorry. Got a little complicated, and I've been away from
> > my filesystem test setup so I didn't want ot send it (lucky, coz I found
> > a bug after more substantial testing).
> > 
> > Anyway, RFC?
>   Hmm, maybe one comment/question:
> 
> > Index: linux-2.6/fs/buffer.c
> > ===================================================================
> > --- linux-2.6.orig/fs/buffer.c	2007-10-08 14:09:35.000000000 +1000
> > +++ linux-2.6/fs/buffer.c	2007-10-08 16:45:28.000000000 +1000
> ...
> 
> > -/*
> > - * Make sure any changes to nobh_commit_write() are reflected in
> > - * nobh_truncate_page(), since it doesn't call commit_write().
> > - */
> > -int nobh_commit_write(struct file *file, struct page *page,
> > -		unsigned from, unsigned to)
> > +int nobh_write_end(struct file *file, struct address_space *mapping,
> > +			loff_t pos, unsigned len, unsigned copied,
> > +			struct page *page, void *fsdata)
> >  {
> >  	struct inode *inode = page->mapping->host;
> > -	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
> > +	struct buffer_head *head = NULL;
> > +	struct buffer_head *bh;
> >  
> > -	if (page_has_buffers(page))
> > -		return generic_commit_write(file, page, from, to);
> > +	if (!PageMappedToDisk(page)) {
> > +		if (unlikely(copied < len) && !page_has_buffers(page))
> > +			attach_nobh_buffers(page, head);
> > +		if (page_has_buffers(page))
> > +			return generic_write_end(file, mapping, pos, len, copied, page, fsdata);
> > +	}
>   So we can have a page with attached buffers but we decide to not call
> generic_write_end()...
> 
> >  	SetPageUptodate(page);
> >  	set_page_dirty(page);
>   And we just set the page dirty but we leave buffers clean. So cannot
> subsequent try_to_free_buffers() come, mark page as clean (as buffers
> are clean) and discard the data?

Hmm, we might just be OK here because set_page_dirty should dirty the
buffers. However, I think you have spotted a mistake here and it would be
better if the generic_write_end test was outside the PageMapedToDisk
check.

Thanks!


Return-Path: <linux-kernel-owner+w=401wt.eu-S1946205AbXBCBdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946205AbXBCBdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 20:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946204AbXBCBdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 20:33:18 -0500
Received: from ns2.suse.de ([195.135.220.15]:58239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946182AbXBCBdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 20:33:17 -0500
Date: Sat, 3 Feb 2007 02:33:16 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 1/9] fs: libfs buffered write leak fix
Message-ID: <20070203013316.GB27300@wotan.suse.de>
References: <20070129081905.23584.97878.sendpatchset@linux.site> <20070129081914.23584.23886.sendpatchset@linux.site> <20070202155236.dae54aa2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202155236.dae54aa2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 03:52:36PM -0800, Andrew Morton wrote:
> On Mon, 29 Jan 2007 11:31:46 +0100 (CET)
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > simple_prepare_write and nobh_prepare_write leak uninitialised kernel data.
> 
> They do?  Under what situation?

Yes, I have at least reproduced the libfs leak.

The situation is when you write into a !uptodate page, the prepare_write
function runs SetPageUptodate *before* we have copied data in. Thus you
can read uninitialised data out of there.

SetPageUptodate must not be used (or at least used carefully) in
prepare_write. commit_write is the correct place to do this.

> > Fix the former,
> 
> How?

If doing a partial-write, simply clear the whole page and set it uptodate
(don't need to get too tricky). If doing a full-write, only set it uptodate
in the commit_write.

> > make a note of the latter. Several other filesystems seem
> > to be iffy here, too.
> 
> Please, tell us what the bug is so that others have a chance of reviewing
> and, if needed, fixing those other filesystems.
> 
> > --- linux-2.6.orig/fs/libfs.c
> > +++ linux-2.6/fs/libfs.c
> > @@ -327,32 +327,35 @@ int simple_readpage(struct file *file, s
> >  int simple_prepare_write(struct file *file, struct page *page,
> >  			unsigned from, unsigned to)
> >  {
> > -	if (!PageUptodate(page)) {
> > -		if (to - from != PAGE_CACHE_SIZE) {
> > -			void *kaddr = kmap_atomic(page, KM_USER0);
> > -			memset(kaddr, 0, from);
> > -			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
> > -			flush_dcache_page(page);
> > -			kunmap_atomic(kaddr, KM_USER0);
> > -		}
> > +	if (PageUptodate(page))
> > +		return 0;
> > +
> > +	if (to - from != PAGE_CACHE_SIZE) {
> > +		clear_highpage(page);
> > +		flush_dcache_page(page);
> >  		SetPageUptodate(page);
> >  	}
> 
> memclear_highpage_flush() is fashionable.

Good one.

> > ===================================================================
> > --- linux-2.6.orig/fs/buffer.c
> > +++ linux-2.6/fs/buffer.c
> > @@ -2344,6 +2344,8 @@ int nobh_prepare_write(struct page *page
> >  
> >  	if (is_mapped_to_disk)
> >  		SetPageMappedToDisk(page);
> > +
> > +	/* XXX: information leak vs read(2) */
> >  	SetPageUptodate(page);
> >  
> >  	/*
> 
> That comment is too terse to be useful.

OK, similar problem here - we have brought all the buffers uptodate
that we are *not* going to write over, or partially write over, but
we can have an uninitialised hole over the region we want to write.

I think just setting page uptodate in commit_write might do the
trick? (and getting rid of the set_page_dirty there).

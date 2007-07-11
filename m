Return-Path: <linux-kernel-owner+w=401wt.eu-S1764332AbXGKQeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764332AbXGKQeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbXGKQeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:34:14 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42208 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbXGKQeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:34:14 -0400
Date: Wed, 11 Jul 2007 17:33:29 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: shmem: convert to using splice instead of sendfile()
In-Reply-To: <20070711062021.GF4587@kernel.dk>
Message-ID: <Pine.LNX.4.64.0707111710110.22786@blonde.wat.veritas.com>
References: <200707102300.l6AN0xM4026841@hera.kernel.org>
 <20070710184347.037b6b3e.akpm@linux-foundation.org> <20070711062021.GF4587@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAA2luYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAamVucy5heGJvZUBvcmFjbGUuY29tAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Jens Axboe wrote:
> On Tue, Jul 10 2007, Andrew Morton wrote:
> > On Tue, 10 Jul 2007 23:00:59 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> > 
> > > +static int shmem_readpage(struct file *file, struct page *page)
> > > +{
> > > +	struct inode *inode = page->mapping->host;
> > > +	int error = shmem_getpage(inode, page->index, &page, SGP_CACHE, NULL);
> > > +	unlock_page(page);
> > > +	return error;
> > > +}
> > 
> > Worried.  shmem_getpage() does
> > 
> > done:
> > 	if (*pagep != filepage) {
> > 		unlock_page(filepage);
> > 		*pagep = filepage;
> > 	}
> > 	return 0;
> > 
> > so we end up unlocking an unlocked page?
> 
> It certainly looks like it - Hugh?

No, it's fine.  The relevant comment is up at the entry to shmem_getpage:
	struct page *filepage = *pagep;  /* (moved down, I'm cheating!) */
	/*
	 * Normally, filepage is NULL on entry, and either found
	 * uptodate immediately, or allocated and zeroed, or read
	 * in under swappage, which is then assigned to filepage.
	 * But shmem_readpage and shmem_prepare_write pass in a locked
	 * filepage, which may be found not uptodate by other callers
	 * too, and may need to be copied from the swappage read in.
	 */
So down at the exit from shmem_getpage, in the shmem_readpage case,
filepage _is_ *pagep, and so it skips that unlock_page - the caller
passed in a locked page, it's up to the caller to unlock it; but
the general ->readpage interface then demands that shmem_readpage
unlock the page which was passed in to it with lock held.  

(The *pagep != filepage test is also trying to skip the unlock_page
in the case when shmem_getpage needed to allocate the page itself,
but couldn't: both *pagep and filepage NULL.)

Ironically, the need for shmem_getpage to handle the case of a page
passed into it almost vanished - Nick's upcoming aops ->write_begin
abolishes the shmem_prepare_write case - but now it is needed for
readpage for splice: but I'm hoping perhaps we'll devise a readpage
replacement more like write_begin/write_end, then can eliminate it.

Hugh

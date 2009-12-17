Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZLQRv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZLQRv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZLQRvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:51:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50464 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZLQRvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:51:21 -0500
Date: Thu, 17 Dec 2009 12:51:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, tytso@mit.edu,
       Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James.Bottomley@suse.de, linux-arch@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
Message-ID: <20091217175120.GA5741@infradead.org>
References: <20091216043618.GB9104@hera.kernel.org> <20091217132256.GO28962@bombadil.infradead.org> <alpine.LFD.2.00.0912170811130.15740@localhost.localdomain> <20091217163036.GE2123@thunk.org> <alpine.LFD.2.00.0912170839550.15740@localhost.localdomain> <20091217170743.GA10431@infradead.org> <alpine.LFD.2.00.0912170928310.15740@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912170928310.15740@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 09:42:15AM -0800, Linus Torvalds wrote:
> > Which is exactly what the XFS code does.  Pages are allocated manually
> > and we store pointers to the page struct that later get added to the
> > bio.
> 
> Hmm. The BIO interface that the patch-series changes (bio_map_kern) 
> doesn't work that way. It takes a "buf, len" kind of thing. That's what 
> I'm complaining about.

Indeed, the "block: permit I/O to vmalloc/vmap kernel pages" does what
you complain about.  But the series doesn't actually add a user for
that.  What it does in XFS is quite a bit of black magic, too - but only
with the new cache coherence calls that are noops on architectures with
physically indexed caches.

> Well, they clearly are _after_ this series, since that's what all those 
> changes to __bio_map_kernel() and bio_map_kern_endio() are all about.
>
> So I believe you when you say that XFS perhaps does everything right - I 
> just think that the patch series in question actually makes things worse, 
> exactly because it is starting to use virtual addresses.

I'm not entirely sure why James added those, but XFS doesn't actually
use bio_map_kern.

> And I really think that would be all much more properly done at the 
> _caller_ level, not by the BIO layer.
>
> You must have some locking and allocation etc logic at the caller anyway, 
> why doesn't _that_ level just do the flushing or invalidation?

http://git.kernel.org/?p=linux/kernel/git/kyle/parisc-2.6.git;a=commitdiff;h=56c8214b842324e94aa88012010b0f1f9847daec

does it in the caller level.  Not exactly in a beautiful way, but who
am I complain as I'm already lost in our mess of cache coherency APIs.

> IOW, I'm perfectly happy with the patch to fs/xfs/linux-2.6/xfs_buf.c. 
> That one still seems to use 'bio_add_page()' with a regular 'struct page'. 
> 
> But the fs/bio.c patch looks like just total and utter crap to me, and is 
> the reason I refuse to pull this series.

Kyle/James, can you regenerate the tree without that patch included?


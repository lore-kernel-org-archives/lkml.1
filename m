Return-Path: <linux-kernel-owner+w=401wt.eu-S934464AbZLQRnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbZLQRnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765120AbZLQRnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:43:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759436AbZLQRnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:43:09 -0500
Date: Thu, 17 Dec 2009 09:42:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Hellwig <hch@infradead.org>
cc: tytso@mit.edu, Kyle McMartin <kyle@mcmartin.ca>,
       linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James.Bottomley@suse.de, linux-arch@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
In-Reply-To: <20091217170743.GA10431@infradead.org>
Message-ID: <alpine.LFD.2.00.0912170928310.15740@localhost.localdomain>
References: <20091216043618.GB9104@hera.kernel.org> <20091217132256.GO28962@bombadil.infradead.org> <alpine.LFD.2.00.0912170811130.15740@localhost.localdomain> <20091217163036.GE2123@thunk.org> <alpine.LFD.2.00.0912170839550.15740@localhost.localdomain>
 <20091217170743.GA10431@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, Christoph Hellwig wrote:
>
> On Thu, Dec 17, 2009 at 08:46:33AM -0800, Linus Torvalds wrote:
> > The whole "vmalloc is special" has always been true. If you want to 
> > treat vmalloc as normal memory, you need to look up the pages yourself. We 
> > have helpers for that (including helpers that populate vmalloc space from 
> > a page array to begin with - so you can _start_ from some array of pages 
> > and then lay them out virtually if you want to have a convenient CPU 
> > access to the array).
> 
> Which is exactly what the XFS code does.  Pages are allocated manually
> and we store pointers to the page struct that later get added to the
> bio.

Hmm. The BIO interface that the patch-series changes (bio_map_kern) 
doesn't work that way. It takes a "buf, len" kind of thing. That's what 
I'm complaining about.

> But we access them through vmap (which I added exactly for this
> reason back in 2002) for kernel accesses.  On all architectures with
> sane caches things just work, but for parisc, arm and friends that have
> virtually indexed caches we need to make sure to flush caches for this
> different access.  The vmalloc linear address is not used for I/O
> everywhere.

Well, they clearly are _after_ this series, since that's what all those 
changes to __bio_map_kernel() and bio_map_kern_endio() are all about.

So I believe you when you say that XFS perhaps does everything right - I 
just think that the patch series in question actually makes things worse, 
exactly because it is starting to use virtual addresses.

I also think that the changes to bio_map_kernel() and bio_map_kern_endio() 
are not just "fundamentally ugly", I think they are made worse by the fact 
that it's not even done "right". You both flush the virtual caches before 
the IO and invalidate after - when the real pattern should be that you 
flush it before a write, and invalidate it after a read.

And I really think that would be all much more properly done at the 
_caller_ level, not by the BIO layer.

You must have some locking and allocation etc logic at the caller anyway, 
why doesn't _that_ level just do the flushing or invalidation?

I get the feeling that somebody decided that the whole "do DMA to/from 
vmalloc space" was somehow a common generic pattern that should be 
supported in general, and I violently disagree. Maybe XFS has good reasons 
for doing it, but that does emphatically _not_ make it a good idea in 
general, and that does _not_ mean that the BIO layer should make it easy 
to do for other users and have a general interface for that kind of 
crazyness.

IOW, I'm perfectly happy with the patch to fs/xfs/linux-2.6/xfs_buf.c. 
That one still seems to use 'bio_add_page()' with a regular 'struct page'. 

But the fs/bio.c patch looks like just total and utter crap to me, and is 
the reason I refuse to pull this series.

				Linus

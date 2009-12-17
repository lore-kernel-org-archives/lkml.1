Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbZLQQbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbZLQQbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757823AbZLQQaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:30:55 -0500
Received: from THUNK.ORG ([69.25.196.29]:41056 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515AbZLQQax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:30:53 -0500
Date: Thu, 17 Dec 2009 11:30:36 -0500
From: tytso@mit.edu
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James.Bottomley@suse.de, hch@infradead.org, linux-arch@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
Message-ID: <20091217163036.GE2123@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	James.Bottomley@suse.de, hch@infradead.org,
	linux-arch@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
References: <20091216043618.GB9104@hera.kernel.org>
 <20091217132256.GO28962@bombadil.infradead.org>
 <alpine.LFD.2.00.0912170811130.15740@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912170811130.15740@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 08:16:12AM -0800, Linus Torvalds wrote:
> 
> I hate them.
> 
> I don't see what the point of allowing kernel virtual addresses in bio's 
> is. It's wrong. The fact that XFS does that sh*t is an XFS issue. Handle 
> it there.
> 
> Fix XFS. Or convince me with some really good arguments, and make sure 
> that Jens signs off on the cr*p too.

I have a somewhat similar issue that comes up for ext4; at the moment
occasionaly we need to clone a buffer head buffer; either because the
first four bytes match the magic JBD "escape sequence", and we need to
modify the block and escape it before writing it to the journal, or
because we need to make a copy of a allocation bitmap block so we can
write a fixed copy to disk while we modify the "real" block during a
commit.  At the moment we allocate a full page, even if that means
allocating a 16k PPC page when the file system block size is 4k, or
allocating a 4k x86 page when the file system block size is 1k.

That's because apparently the iSCSI and DMA blocks assume that they
have Real Pages (tm) passed to block I/O requests, and apparently XFS
ran into problems when sending vmalloc'ed pages.  I don't know if this
is a problem if we pass the bio layer addresses coming from the SLAB
allocator, but oral tradition seems to indicate this is problematic,
although no one has given me the full chapter and verse explanation
about why this is so.

Now that I see Linus's complaint, I'm wondering if the issue is really
about kernel virtual addresses (i.e., coming from vmalloc), and not a
requirement for Real Pages (i.e., coming from the SLAB allocator as
opposed to get_free_page).  And can this be documented someplace?  I
tried looking at the bio documentation, and couldn't find anything
definitive on the subject.

Thanks,

						- Ted

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbXIQJat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbXIQJat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXIQJag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:30:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59298 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbXIQJae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:30:34 -0400
Date: Mon, 17 Sep 2007 10:30:31 +0100
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Andrea Arcangeli <andrea@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070917093031.GB25706@skynet.ie>
References: <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random> <87tzpvy9cb.fsf@informatik.uni-tuebingen.de> <20070915223032.GA6708@v2.random> <87d4wi3ebz.fsf@informatik.uni-tuebingen.de> <20070916150831.GD6708@v2.random> <20070916210813.GD16406@skynet.ie> <87veaa446e.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <87veaa446e.fsf@informatik.uni-tuebingen.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (17/09/07 00:48), Goswin von Brederlow didst pronounce:
> mel@skynet.ie (Mel Gorman) writes:
> 
> > On (16/09/07 17:08), Andrea Arcangeli didst pronounce:
> >> zooming in I see red pixels all over the squares mized with green
> >> pixels in the same square. This is exactly what happens with the
> >> variable order page cache and that's why it provides zero guarantees
> >> in terms of how much ram is really "free" (free as in "available").
> >> 
> >
> > This picture is not grouping pages by mobility so that is hardly a
> > suprise. This picture is not running grouping pages by mobility. This is
> > what the normal kernel looks like. Look at the videos in
> > http://www.skynet.ie/~mel/anti-frag/2007-02-28 and see how list-based
> > compares to vanilla. These are from February when there was less control
> > over mixing blocks than there is today.
> >
> > In the current version mixing occurs in the lower blocks as much as possible
> > not the upper ones. So there are a number of mixed blocks but the number is
> > kept to a minimum.
> >
> > The number of mixed blocks could have been enforced as 0, but I felt it was
> > better in the general case to fragment rather than regress performance.
> > That may be different for large blocks where you will want to take the
> > enforcement steps.
> 
> I agree that 0 is a bad value. But so is infinity. There should be
> some mixing but not a lot. You say "kept to a minimum". Is that
> actively done or already happens by itself. Hopefully the later which
> would be just splendid.
> 

Happens by itself due to biasing mixing blocks at lower PFNs. The exact
number is unknown. We used to track it a long time ago but not any more.

> >> With config-page-shift mmap works on 4k chunks but it's always backed
> >> by 64k or any other largesize that you choosed at compile time. And if
> 
> But would mapping a random 4K page out of a file then consume 64k?
> That sounds like an awfull lot of internal fragmentation. I hope the
> unaligned bits and pices get put into a slab or something as you
> suggested previously.
> 

This is a possibility but Andrea seems confident he can handle it.

> >> the virtual alignment of mmap matches the physical alignment of the
> >> physical largepage and is >= PAGE_SIZE (software PAGE_SIZE I mean) we
> >> could use the 62nd bit of the pte to use a 64k tlb (if future cpus
> >> will allow that). Nick also suggested to still set all ptes equal to
> >> make life easier for the tlb miss microcode.
> 
> It is too bad that existing amd64 CPUs only allow such large physical
> pages. But it kind of makes sense to cut away a full level or page
> tables for the next bigger size each.
> 

Yep on both counts.

> >> > big you can make it. I don't think my system with 1GB ram would work
> >> > so well with 2MB order 0 pages. But I wasn't refering to that but to
> >> > the picture.
> >> 
> >> Sure! 2M is sure way excessive for a 1G system, 64k most certainly
> >> too, of course unless you're running a db or a multimedia streaming
> >> service, in which case it should be ideal.
> 
> rtorrent, Xemacs/gnus, bash, xterm, zsh, make, gcc, galeon and the
> ocasional mplayer.
> 
> I would mostly be concerned how rtorrents totaly random access of
> mmapped files negatively impacts such a 64k page system.
> 

For what it's worth, the last allocation failure that occured with
grouping pages by mobility was order-1 atomic failures for a wireless
network card when bittorrent was running. You're likely right in that
torrents will be an interesting workload in terms of fragmentation.

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

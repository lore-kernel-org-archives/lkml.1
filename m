Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbXIPPIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbXIPPIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 11:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbXIPPIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 11:08:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:33024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbXIPPIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 11:08:35 -0400
Date: Sun, 16 Sep 2007 17:08:32 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joern Engel <joern@logfs.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070916150831.GD6708@v2.random>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random> <87tzpvy9cb.fsf@informatik.uni-tuebingen.de> <20070915223032.GA6708@v2.random> <87d4wi3ebz.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d4wi3ebz.fsf@informatik.uni-tuebingen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 03:54:56PM +0200, Goswin von Brederlow wrote:
> Andrea Arcangeli <andrea@suse.de> writes:
> 
> > On Sat, Sep 15, 2007 at 10:14:44PM +0200, Goswin von Brederlow wrote:
> >> - Userspace allocates a lot of memory in those slabs.
> >
> > If with slabs you mean slab/slub, I can't follow, there has never been
> > a single byte of userland memory allocated there since ever the slab
> > existed in linux.
> 
> This and other comments in your reply show me that you completly
> misunderstood what I was talking about.
> 
> Look at
> http://www.skynet.ie/~mel/anti-frag/2007-02-28/page_type_distribution.jpg

What does the large square represent here? A "largepage"? If yes,
which order? There seem to be quite some pixels in each square...

> The red dots (pinned) are dentries, page tables, kernel stacks,
> whatever kernel stuff, right?
> 
> The green dots (movable) are mostly userspace pages being mapped
> there, right?

If the largepage is the square, there can't be red pixels mixed with
green pixels with the config-page-shift design, this is the whole
difference...

zooming in I see red pixels all over the squares mized with green
pixels in the same square. This is exactly what happens with the
variable order page cache and that's why it provides zero guarantees
in terms of how much ram is really "free" (free as in "available").

> What I was refering too is that because movable objects (green dots)
> aren't moved out of a mixed group (the boxes) when some unmovable
> object needs space all the groups become mixed over time. That means
> the unmovable objects are spread out over all the ram and the buddy
> system can't recombine regions when unmovable objects free them. There
> will nearly always be some movable objects in the other buddy. The
> system of having unmovable and movable groups breaks down and becomes
> useless.

If I understood correctly, here you agree that mixing movable and
unmovable objects in the same largepage is a bad thing, and that's
incidentally what config-page-shift prevents. It avoids it instead of
undoing the mixture later with defrag when it's far too late for
anything but updatedb.

> I'm assuming here that we want the possibility of larger order pages
> for unmovable objects (large continiuos regions for DMA for example)
> than the smallest order user space gets (or any movable object). If
> mmap() still works on 4k page bounaries then those will fragment all
> regions into 4k chunks in the worst case.

With config-page-shift mmap works on 4k chunks but it's always backed
by 64k or any other largesize that you choosed at compile time. And if
the virtual alignment of mmap matches the physical alignment of the
physical largepage and is >= PAGE_SIZE (software PAGE_SIZE I mean) we
could use the 62nd bit of the pte to use a 64k tlb (if future cpus
will allow that). Nick also suggested to still set all ptes equal to
make life easier for the tlb miss microcode.

> Obviously if userspace has a minimum order of 64k chunks then it will
> never break any region smaller than 64k chunks and will never cause a
> fragmentation catastroph. I know that is verry roughly your aproach
> (make order 0 bigger), and I like it, but it has some limits as to how

Yep, exactly this is what happens, it avoids that trouble. But as far
as fragmentation guarantees goes, it's really about keeping the
unmovable out of our way (instead of spreading the unmovable all over
the buddy randomly, or with ugly
boot-time-fixed-numbers-memory-reservations) than to map largepages in
userland. Infact as I said we could map kmalloced 4k entries in
userland to save memory if we would really want to hurt the fast paths
to make a generic kernel to use on smaller systems, but that would be
very complex. Since those 4k entries would be 100% movable (not like
the rest of the slab, like dentries and inodes etc..) that wouldn't
make the design less reliable, it'd still be 100% reliable and
performance would be ok because that memory is userland memory, we've
to set the pte anyway, regardless if it's a 4k page or a largepage.

> big you can make it. I don't think my system with 1GB ram would work
> so well with 2MB order 0 pages. But I wasn't refering to that but to
> the picture.

Sure! 2M is sure way excessive for a 1G system, 64k most certainly
too, of course unless you're running a db or a multimedia streaming
service, in which case it should be ideal.

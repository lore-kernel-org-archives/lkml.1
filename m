Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbXIPVI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbXIPVI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 17:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXIPVIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 17:08:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38267 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbXIPVIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 17:08:16 -0400
Date: Sun, 16 Sep 2007 22:08:13 +0100
To: Andrea Arcangeli <andrea@suse.de>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
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
Message-ID: <20070916210813.GD16406@skynet.ie>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random> <87tzpvy9cb.fsf@informatik.uni-tuebingen.de> <20070915223032.GA6708@v2.random> <87d4wi3ebz.fsf@informatik.uni-tuebingen.de> <20070916150831.GD6708@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070916150831.GD6708@v2.random>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (16/09/07 17:08), Andrea Arcangeli didst pronounce:
> On Sun, Sep 16, 2007 at 03:54:56PM +0200, Goswin von Brederlow wrote:
> > Andrea Arcangeli <andrea@suse.de> writes:
> > 
> > > On Sat, Sep 15, 2007 at 10:14:44PM +0200, Goswin von Brederlow wrote:
> > >> - Userspace allocates a lot of memory in those slabs.
> > >
> > > If with slabs you mean slab/slub, I can't follow, there has never been
> > > a single byte of userland memory allocated there since ever the slab
> > > existed in linux.
> > 
> > This and other comments in your reply show me that you completly
> > misunderstood what I was talking about.
> > 
> > Look at
> > http://www.skynet.ie/~mel/anti-frag/2007-02-28/page_type_distribution.jpg
> 
> What does the large square represent here? A "largepage"? If yes,
> which order? There seem to be quite some pixels in each square...
> 

hmm, it was a long time ago. This one looks like 4MB large pages so
order-10

> > The red dots (pinned) are dentries, page tables, kernel stacks,
> > whatever kernel stuff, right?
> > 
> > The green dots (movable) are mostly userspace pages being mapped
> > there, right?
> 
> If the largepage is the square, there can't be red pixels mixed with
> green pixels with the config-page-shift design, this is the whole
> difference...

Yes. I can enforce a similar situation but didn't because the evacuation
costs could not be justified for hugepage allocations. Patches to do such
a thing were prototyped a long time ago and abandoned based on cost. For
large blocks, there may be a justification.

> zooming in I see red pixels all over the squares mized with green
> pixels in the same square. This is exactly what happens with the
> variable order page cache and that's why it provides zero guarantees
> in terms of how much ram is really "free" (free as in "available").
> 

This picture is not grouping pages by mobility so that is hardly a
suprise. This picture is not running grouping pages by mobility. This is
what the normal kernel looks like. Look at the videos in
http://www.skynet.ie/~mel/anti-frag/2007-02-28 and see how list-based
compares to vanilla. These are from February when there was less control
over mixing blocks than there is today.

In the current version mixing occurs in the lower blocks as much as possible
not the upper ones. So there are a number of mixed blocks but the number is
kept to a minimum.

The number of mixed blocks could have been enforced as 0, but I felt it was
better in the general case to fragment rather than regress performance.
That may be different for large blocks where you will want to take the
enforcement steps.

> > What I was refering too is that because movable objects (green dots)
> > aren't moved out of a mixed group (the boxes) when some unmovable
> > object needs space all the groups become mixed over time. That means
> > the unmovable objects are spread out over all the ram and the buddy
> > system can't recombine regions when unmovable objects free them. There
> > will nearly always be some movable objects in the other buddy. The
> > system of having unmovable and movable groups breaks down and becomes
> > useless.
> 
> If I understood correctly, here you agree that mixing movable and
> unmovable objects in the same largepage is a bad thing, and that's
> incidentally what config-page-shift prevents. It avoids it instead of
> undoing the mixture later with defrag when it's far too late for
> anything but updatedb.
> 

We don't take defrag steps at the moment at all. There are memory
compaction patches but I'm not pushing them until we can prove they are
necessary.

> > I'm assuming here that we want the possibility of larger order pages
> > for unmovable objects (large continiuos regions for DMA for example)
> > than the smallest order user space gets (or any movable object). If
> > mmap() still works on 4k page bounaries then those will fragment all
> > regions into 4k chunks in the worst case.
> 
> With config-page-shift mmap works on 4k chunks but it's always backed
> by 64k or any other largesize that you choosed at compile time. And if
> the virtual alignment of mmap matches the physical alignment of the
> physical largepage and is >= PAGE_SIZE (software PAGE_SIZE I mean) we
> could use the 62nd bit of the pte to use a 64k tlb (if future cpus
> will allow that). Nick also suggested to still set all ptes equal to
> make life easier for the tlb miss microcode.
> 

As I said elsewhere, you can try this easily on top of grouping pages by
mobility. They are not mutually exclusive and you'll have a comparison
point.

> > Obviously if userspace has a minimum order of 64k chunks then it will
> > never break any region smaller than 64k chunks and will never cause a
> > fragmentation catastroph. I know that is verry roughly your aproach
> > (make order 0 bigger), and I like it, but it has some limits as to how
> 
> Yep, exactly this is what happens, it avoids that trouble. But as far
> as fragmentation guarantees goes, it's really about keeping the
> unmovable out of our way (instead of spreading the unmovable all over
> the buddy randomly, or with ugly
> boot-time-fixed-numbers-memory-reservations) than to map largepages in
> userland. Infact as I said we could map kmalloced 4k entries in
> userland to save memory if we would really want to hurt the fast paths
> to make a generic kernel to use on smaller systems, but that would be
> very complex. Since those 4k entries would be 100% movable (not like
> the rest of the slab, like dentries and inodes etc..) that wouldn't
> make the design less reliable, it'd still be 100% reliable and
> performance would be ok because that memory is userland memory, we've
> to set the pte anyway, regardless if it's a 4k page or a largepage.
> 

Ok, get it implemented so and we'll try it out because we're just hand-waving
here and not actually producing anything to compare. It'll be interesting
to see how it works out for large blocks and hugepages (although I expect
the latter to fail unless grouping pages by mobility is in place).  Ideally,
they'll complement each other nicely but only ever having mixing take place
at the 64KB boundary. I have the testing setup necessary for checking
out hugepages at least and I hope to put together something that tests
large blocks as well. Minimally, running the hugepage allocation tests
on a filesystem using large blocks would be a decent starting point.

> > big you can make it. I don't think my system with 1GB ram would work
> > so well with 2MB order 0 pages. But I wasn't refering to that but to
> > the picture.
> 
> Sure! 2M is sure way excessive for a 1G system, 64k most certainly
> too, of course unless you're running a db or a multimedia streaming
> service, in which case it should be ideal.
> 

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbXIQKEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbXIQKEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 06:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbXIQKDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 06:03:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48759 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbXIQKDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 06:03:53 -0400
Date: Mon, 17 Sep 2007 11:03:50 +0100
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joern Engel <joern@logfs.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070917100350.GC25706@skynet.ie>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070916181313.GA16406@skynet.ie> <87k5qq5l36.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k5qq5l36.fsf@informatik.uni-tuebingen.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (16/09/07 23:58), Goswin von Brederlow didst pronounce:
> mel@skynet.ie (Mel Gorman) writes:
> 
> > On (15/09/07 14:14), Goswin von Brederlow didst pronounce:
> >> Andrew Morton <akpm@linux-foundation.org> writes:
> >> 
> >> > On Tue, 11 Sep 2007 14:12:26 +0200 Jörn Engel <joern@logfs.org> wrote:
> >> >
> >> >> While I agree with your concern, those numbers are quite silly.  The
> >> >> chances of 99.8% of pages being free and the remaining 0.2% being
> >> >> perfectly spread across all 2MB large_pages are lower than those of SHA1
> >> >> creating a collision.
> >> >
> >> > Actually it'd be pretty easy to craft an application which allocates seven
> >> > pages for pagecache, then one for <something>, then seven for pagecache, then
> >> > one for <something>, etc.
> >> >
> >> > I've had test apps which do that sort of thing accidentally.  The result
> >> > wasn't pretty.
> >> 
> >> Except that the applications 7 pages are movable and the <something>
> >> would have to be unmovable. And then they should not share the same
> >> memory region. At least they should never be allowed to interleave in
> >> such a pattern on a larger scale.
> >> 
> >
> > It is actually really easy to force regions to never share. At the
> > moment, there is a fallback list that determines a preference for what
> > block to mix.
> >
> > The reason why this isn't enforced is the cost of moving. On x86 and
> > x86_64, a block of interest is usually 2MB or 4MB. Clearing out one of
> > those pages to prevent any mixing would be bad enough. On PowerPC, it's
> > potentially 16MB. On IA64, it's 1GB.
> >
> > As this was fragmentation avoidance, not guarantees, the decision was
> > made to not strictly enforce the types of pages within a block as the
> > cost cannot be made back unless the system was making agressive use of
> > large pages. This is not the case with Linux.
> 
> I don't say the group should never be mixed. The movable objects could
> be moved out on demand. If 64k get allocated then up to 64k get
> moved.

This type of action makes sense in the context of Andrea's approach and
large blocks. I don't think it makes sense today to do it in the general
case, at least not yet.

> That would reduce the impact as the kernel does not hang while
> it moves 2MB or even 1GB. It also allows objects to be freed and the
> space reused in the unmovable and mixed groups. There could also be a
> certain number or percentage of mixed groupd be allowed to further
> increase the chance of movable objects freeing themself from mixed
> groups.
> 
> But when you already have say 10% of the ram in mixed groups then it
> is a sign the external fragmentation happens and some time should be
> spend on moving movable objects.
> 

I'll play around with it on the side and see what sort of results I get.
I won't be pushing anything any time soon in relation to this though.
For now, I don't intend to fiddle more with grouping pages by mobility
for something that may or may not be of benefit to a feature that hasn't
been widely tested with what exists today.

> >> The only way a fragmentation catastroph can be (proovable) avoided is
> >> by having so few unmovable objects that size + max waste << ram
> >> size. The smaller the better. Allowing movable and unmovable objects
> >> to mix means that max waste goes way up. In your example waste would
> >> be 7*size. With 2MB uper order limit it would be 511*size.
> >> 
> >> I keep coming back to the fact that movable objects should be moved
> >> out of the way for unmovable ones. Anything else just allows
> >> fragmentation to build up.
> >> 
> >
> > This is easily achieved, just really really expensive because of the
> > amount of copying that would have to take place. It would also compel
> > that min_free_kbytes be at least one free PAGEBLOCK_NR_PAGES and likely
> > MIGRATE_TYPES * PAGEBLOCK_NR_PAGES to reduce excessive copying. That is
> > a lot of free memory to keep around which is why fragmentation avoidance
> > doesn't do it.
> 
> In your sample graphics you had 1152 groups. Reserving a few of those
> doesnt sound too bad.

No, which on those systems, I would suggest setting min_free_kbytes to a
higher value. Doesn't work as well on IA-64.

> And how many migrate types do we talk about.
> So
> far we only had movable and unmovable.

Movable, unmovable, reclaimable and reserve in the current incarnation
of grouping pages by mobility.

> I would split unmovable into
> short term (caches, I/O pages) and long term (task structures,
> dentries).

Mostly done as you suggest already. Dentry are considered reclaimable, not
long-lived though and are grouped with things like inode caches for example.

> Reserving 6 groups for schort term unmovable and long term
> unmovable would be 1% of ram in your situation.
> 

More groups = more cost although very easy to add them. A mixed type
used to exist but was removed again because it couldn't be proved to be
useful at the time.

> Maybe instead of reserving one could say that you can have up to 6
> groups of space

And if the groups are 1GB in size? I tried something like this already.
It didn't work out well at the time although I could revisit.

> not used by unmovable objects before aggressive moving
> starts. I don't quite see why you NEED reserving as long as there is
> enough space free alltogether in case something needs moving.

hence, increase min_free_kbytes.

> 1 group
> worth of space free might be plenty to move stuff too. Note that all
> the virtual pages can be stuffed in every little free space there is
> and reassembled by the MMU. There is no space lost there.
> 

What you suggest sounds similar to having a type MIGRATE_MIXED where you
allocate from when the preferred lists are full. It became a sizing
problem that never really worked out. As I said, I can try again.

> But until one tries one can't say.
> 
> MfG
>         Goswin
> 
> PS: How do allocations pick groups?

Using GFP flags to identify the type.

> Could one use the oldest group
> dedicated to each MIGRATE_TYPE?

Age is difficult to determine so probably not.

> Or lowest address for unmovable and
> highest address for movable? Something to better keep the two out of
> each other way.

We bias the location of unmovable and reclaimable allocations already. It's
not done for movable because it wasn't necessary (as they are easily
reclaimed or moved anyway).

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

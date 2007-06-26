Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbXFZDz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbXFZDz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 23:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbXFZDzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 23:55:21 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:45682 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753111AbXFZDzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 23:55:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=K7NS+m5wGmZ2+iuoiABgDynVoxPyqxhkwiHixVxyk0nGxC98mB9QIii37EwaKydqwxkfynRe04PHDgOxC7AX+CQ2jOd+5EulDQ6NrHsTVzptgoDv83hRUtyYoq/cXnwAcSYC9mH3QUwCBGzYaiEvB0FzvB6TlkGt+muNu+t10WM=  ;
X-YMail-OSG: X5QARBYVM1kupbFLKyrGK8_SrVGvr7uYFBmKaeb8dtS3sgvshjHuTInkhpl9V3kkV41JmxFc1w--
Message-ID: <46808E1F.1000509@yahoo.com.au>
Date: Tue, 26 Jun 2007 13:55:11 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] fsblock
References: <20070624014528.GA17609@wotan.suse.de> <20070626030640.GM989688@sgi.com>
In-Reply-To: <20070626030640.GM989688@sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Sun, Jun 24, 2007 at 03:45:28AM +0200, Nick Piggin wrote:
> 
>>I'm announcing "fsblock" now because it is quite intrusive and so I'd
>>like to get some thoughts about significantly changing this core part
>>of the kernel.
> 
> 
> Can you rename it to something other than shorthand for
> "filesystem block"? e.g. When you say:
> 
> 
>>- In line with the above item, filesystem block allocation is performed
> 
> 
> What are we actually talking aout here? filesystem block allocation
> is something a filesystem does to allocate blocks on disk, not
> allocate a mapping structure in memory.
> 
> Realistically, this is not about "filesystem blocks", this is
> about file offset to disk blocks. i.e. it's a mapping.

Yeah, fsblock ~= the layer between the fs and the block layers.
But don't take the name too literally, like a struct page isn't
actually a page of memory ;)


>>  Probably better would be to
>>  move towards offset,length rather than page based fs APIs where everything
>>  can be batched up nicely and this sort of non-trivial locking can be more
>>  optimal.
> 
> 
> If we are going to turn over the API completely like this, can
> we seriously look at moving to this sort of interface at the same
> time?

Yeah we can move to anything. But note that fsblock is perfectly
happy with <= PAGE_CACHE_SIZE blocks today, and isn't _terrible_
at >.


> With a offset/len interface, we can start to track contiguous
> ranges of blocks rather than persisting with a structure per
> filesystem block. If you want to save memory, thet's where
> we need to go.
> 
> XFS uses "iomaps" for this purpose - it's basically:
> 
> 	- start offset into file
> 	- start block on disk
> 	- length of mapping
> 	- state 
> 
> With special "disk blocks" for indicating delayed allocation
> blocks (-1) and unwritten extents (-2). Worst case we end up
> with is an iomap per filesystem block.

I was thinking about doing an extent based scheme, but it has
some issues as well. Block based is light weight and simple, it
aligns nicely with the pagecache structures.


> If we allow iomaps to be split and combined along with range
> locking, we can parallelise read and write access to each
> file on an iomap basis, etc. There's plenty of goodness that
> comes from indexing by range....

Some operations AFAIKS will always need to be per-page (eg. in
the core VM it wants to lock a single page to fault it in, or
wait for a single page to writeout etc). So I didn't see a huge
gain in a one-lock-per-extent type arrangement.

If you're worried about parallelisability, then I don't see what
iomaps give you that buffer heads or fsblocks do not? In fact
they would be worse because there are fewer of them? :)

But remember that once the filesystems have accessor APIs and
can handle multiple pages per fsblock, that would already be
most of the work done for the fs and the mm to go to an extent
based representation.


> FWIW, I really see little point in making all the filesystems
> work with fsblocks if the plan is to change the API again in
> a major way a year down the track. Let's get all the changes
> we think are necessary in one basket first, and then work out
> a coherent plan to implement them ;)

The aops API changes and the fsblock layer are kind of two
seperate things. I'm slowly implementing things as I go (eg.
see perform_write aop, which is exactly the offset,length
based API that I'm talking about).

fsblocks can be implemented on the old or the new APIs. New
APIs won't invalidate work to convert a filesystem to fsblocks.


>>- Large block support. I can mount and run an 8K block size minix3 fs on
>>  my 4K page system and it didn't require anything special in the fs. We
>>  can go up to about 32MB blocks now, and gigabyte+ blocks would only
>>  require  one more bit in the fsblock flags. fsblock_superpage blocks
>>  are > PAGE_CACHE_SIZE, midpage ==, and subpage <.
> 
> 
> My 2c worth - this is a damn complex way of introducing large block
> size support. It has all the problems I pointed out that it would
> have (locking issues, vmap overhead, every filesystem needs needs
> major changes and it's not very efficient) and it's going to take
> quite some time to stabilise.

What locking issues? It locks pages in pagecache offset ascending
order, which already has precedent and is really the only sane way
to do it so it's not like it precludes other possible sane lock
orderings.

vmap overhead is an issue, however I did it mainly for easy of
conversion. I guess things like superblocks and such would make
use of it happily. Most other things should be able to be
implemented with page based helpers (just a couple of bitops
helpers would pretty much cover minix). If it is still a problem,
then I can implement a proper vmap cache.

But the major changes in the filesystem are not for vmaps, but for
page accessors. As I said, this allows blkdev to move out of
lowmem and also closes CPU cache coherency problems. (as well as
not having to carry around a vmem pointer of course).


> If this is the only real feature that fsblocks are going to give us,
> then I think this is a waste of time. If we are going to replace
> buffer heads, lets do it with something that is completely
> independent of filesystem block size and not introduce something
> that is just a bufferhead on steroids.

Well if you ignore all my other points, then yes it is the only thing
that fsblocks gives us :) But it would be very easy to overengineer
this. I don't really see a good case for extents here because we have
to manage these discrete pages anyway. The large block support in
fsblock is probably 500 lines when you take out the debugging stuff.

And I don't see how you think an extent representation would solve
the page locking, complexity, intrusiveness, or vmap problems at all?
Solve them for one and it should be a good solution for the other,
right?

Anyway, let's suppose that we move to a virtually mapped kernel
with defragmentation support and did higher order pagecache for
large block support and decided the remaining advantages of fsblock
were not worth keeping around support for that. Well that could be
taken out and fsblock still wouldn't be a bad thing to have IMO.
fsblock is actually supposed to be a simplified and slimmed down
buffer_head, rather than a steorid filled one.

-- 
SUSE Labs, Novell Inc.

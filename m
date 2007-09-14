Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbXINSJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbXINSJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbXINSIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:08:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59817 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753932AbXINSIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:08:53 -0400
Date: Fri, 14 Sep 2007 11:08:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@skynet.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <200709140720.06537.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709141053110.15813@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709121246.08833.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709121607140.4204@schroedinger.engr.sgi.com>
 <200709140720.06537.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007, Nick Piggin wrote:

> However fsblock can do everything that higher order pagecache can
> do in terms of avoiding vmap and giving contiguous memory to block
> devices by opportunistically allocating higher orders of pages, and falling
> back to vmap if they cannot be satisfied.

fsblock is restricted to the page cache and cannot be used in other 
contexts where subsystems can benefit from larger linear memory.

> So if you argue that vmap is a downside, then please tell me how you
> consider the -ENOMEM of your approach to be better?

That is again pretty undifferentiated. Are we talking about low page 
orders? There we will reclaim the all of reclaimable memory before getting 
an -ENOMEM. Given the quantities of pages on todays machine--a 1 G machine 
has 256 milllion 4k pages--and the unmovable ratios we see today it 
would require a very strange setup to get an allocation failure while 
still be able to allocate order 0 pages.

With the ZONE_MOVABLE you can remove the unmovable objects into a defined 
pool then higher order success rates become reasonable.

> If, by special software layer, you mean the vmap/vunmap support in
> fsblock, let's see... that's probably all of a hundred or two lines.
> Contrast that with anti-fragmentation, lumpy reclaim, higher order
> pagecache and its new special mmap layer... Hmm, seems like a no
> brainer to me. You really still want to persue the "extra layer"
> argument as a point against fsblock here?

Yes sure. You code could not live without these approaches. Without the 
antifragmentation measures your fsblock code would not be very successful 
in getting the larger contiguous segments you need to improve performance.

(There is no new mmap layer, the higher order pagecache is simply the old 
API with set_blocksize expanded).
 

> Of course I wouldn't state that. On the contrary, I categorically state that
> I have already solved it :)

Well then I guess that you have not read the requirements...

> > Because it has already been rejected in another form and adds more
> 
> You have rejected it. But they are bogus reasons, as I showed above.

Thats not me. I am working on this because many of the filesystem people 
have repeatedly asked me to do this. I am no expert on filesystems.

> You also describe some other real (if lesser) issues like number of page
> structs to manage in the pagecache. But this is hardly enough to reject
> my patch now... for every downside you can point out in my approach, I
> can point out one in yours.
> 
> - fsblock doesn't require changes to virtual memory layer

Therefore it is not a generic change but special to the block layer. So 
other subsystems still have to deal with the single page issues on 
their own.

> > Maybe we coud get to something like a hybrid that avoids some of these
> > issues? Add support so something like a virtual compound page can be
> > handled transparently in the filesystem layer with special casing if
> > such a beast reaches the block layer?
> 
> That's conceptually much worse, IMO.

Why: It is the same approach that you use. If it is barely ever used and 
satisfies your concern then I am fine with it.

> And practically worse as well: vmap space is limited on 32-bit; fsblock
> approach can avoid vmap completely in many cases; for two reasons.
> 
> The fsblock data accessor APIs aren't _that_ bad changes. They change
> zero conceptually in the filesystem, are arguably cleaner, and can be
> essentially nooped if we wanted to stay with a b_data type approach
> (but they give you that flexibility to replace it with any implementation).

The largeblock changes are generic. They improve general handling of 
compound pages, they make the existing APIs work for large units of 
memory, they are not adding additional new API layers.
 

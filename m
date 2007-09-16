Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbXIQNBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbXIQNBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbXIQNBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:01:08 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:39576 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753517AbXIQNBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:01:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ToMNOw3aINJjvb/X1ZAMeLduQJt9rFo29aYffmaXsar/X5xkkUN17B8QsRWTllUa3J6ddcS7lEzGiKfdYlZBoZnPVfkZ8DbC4JQxulPlxe+M6ooO78Hko/u0FYjpALB+sLjZldb53ecSpgDQH2lJdUqJmVtLRCkBYCLo9OuU0Us=  ;
X-YMail-OSG: PRtBtykVM1knWkv.bebgk7FrsWpV8Qn3DVQGYvpCn_3Wwt0q1IxZEqDBgmN_tG6WKqruFLn98w--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Sun, 16 Sep 2007 18:53:10 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@skynet.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709140720.06537.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709141053110.15813@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709141053110.15813@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709161853.12050.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 September 2007 04:08, Christoph Lameter wrote:
> On Fri, 14 Sep 2007, Nick Piggin wrote:
> > However fsblock can do everything that higher order pagecache can
> > do in terms of avoiding vmap and giving contiguous memory to block
> > devices by opportunistically allocating higher orders of pages, and
> > falling back to vmap if they cannot be satisfied.
>
> fsblock is restricted to the page cache and cannot be used in other
> contexts where subsystems can benefit from larger linear memory.

Unless you believe higher order pagecache is not restricted to the
pagecache, can we please just stick on topic of fsblock vs higher
order pagecache?


> > So if you argue that vmap is a downside, then please tell me how you
> > consider the -ENOMEM of your approach to be better?
>
> That is again pretty undifferentiated. Are we talking about low page

In general.


> orders? There we will reclaim the all of reclaimable memory before getting
> an -ENOMEM. Given the quantities of pages on todays machine--a 1 G machine
> has 256 milllion 4k pages--and the unmovable ratios we see today it
> would require a very strange setup to get an allocation failure while
> still be able to allocate order 0 pages.

So much handwaving. 1TB machines without "very strange setups"
(where very strange is something arbitrarily defined by you) I guess make
up 0.0000001% of Linux installations.


> With the ZONE_MOVABLE you can remove the unmovable objects into a defined
> pool then higher order success rates become reasonable.

OK, if you rely on reserve pools, then it is not 1st class support and hence
it is a non-solution to VM and IO scalability problems.


> > If, by special software layer, you mean the vmap/vunmap support in
> > fsblock, let's see... that's probably all of a hundred or two lines.
> > Contrast that with anti-fragmentation, lumpy reclaim, higher order
> > pagecache and its new special mmap layer... Hmm, seems like a no
> > brainer to me. You really still want to persue the "extra layer"
> > argument as a point against fsblock here?
>
> Yes sure. You code could not live without these approaches. Without the

Actually: your code is the one that relies on higher order allocations. Now
you're trying to turn that into an argument against fsblock?


> antifragmentation measures your fsblock code would not be very successful
> in getting the larger contiguous segments you need to improve performance.

Complely wrong. *I* don't need to do any of that to improve performance.
Actually the VM is well tuned for order-0 pages, and so seeing as I have
sane hardware, 4K pagecache works beautifully for me.

My point was this: fsblock does not preclude your using such measures to
fix the performance of your hardware that's broken with 4K pages. And it
would allow higher order allocations to fail gracefully.


> (There is no new mmap layer, the higher order pagecache is simply the old
> API with set_blocksize expanded).

Yes you add another layer in the userspace mapping code to handle higher
order pagecache.


> > Of course I wouldn't state that. On the contrary, I categorically state
> > that I have already solved it :)
>
> Well then I guess that you have not read the requirements...

I'm not talking about solving your problem of poor hardware. I'm talking
about supporting higher order block sizes in the kernel.


> > > Because it has already been rejected in another form and adds more
> >
> > You have rejected it. But they are bogus reasons, as I showed above.
>
> Thats not me. I am working on this because many of the filesystem people
> have repeatedly asked me to do this. I am no expert on filesystems.

Yes it is you. You brought up reasons in this thread and I said why I thought
they were bogus. If you think you can now forget about my shooting them
down by saying you aren't an expert in filesystems, then you shouldn't have
brought them up in the first place. Either stand by your arguments or don't.


> > You also describe some other real (if lesser) issues like number of page
> > structs to manage in the pagecache. But this is hardly enough to reject
> > my patch now... for every downside you can point out in my approach, I
> > can point out one in yours.
> >
> > - fsblock doesn't require changes to virtual memory layer
>
> Therefore it is not a generic change but special to the block layer. So
> other subsystems still have to deal with the single page issues on
> their own.

Rubbish. fsblock doesn't touch a single line in the block layer.


> > > Maybe we coud get to something like a hybrid that avoids some of these
> > > issues? Add support so something like a virtual compound page can be
> > > handled transparently in the filesystem layer with special casing if
> > > such a beast reaches the block layer?
> >
> > That's conceptually much worse, IMO.
>
> Why: It is the same approach that you use.

Again, rubbish.

> If it is barely ever used and 
> satisfies your concern then I am fine with it.

Right below this line is where I told you I am _not_ fine with it.


> > And practically worse as well: vmap space is limited on 32-bit; fsblock
> > approach can avoid vmap completely in many cases; for two reasons.
> >
> > The fsblock data accessor APIs aren't _that_ bad changes. They change
> > zero conceptually in the filesystem, are arguably cleaner, and can be
> > essentially nooped if we wanted to stay with a b_data type approach
> > (but they give you that flexibility to replace it with any
> > implementation).
>
> The largeblock changes are generic.

Is that supposed to imply fsblock isn't generic? Or that the fsblock
API isn't a good one?


> They improve general handling of 
> compound pages, they make the existing APIs work for large units of
> memory, they are not adding additional new API layers.

Neither does fsblock.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763680AbXINNNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763680AbXINNNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 09:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbXINNNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 09:13:07 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:48228 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754219AbXINNNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 09:13:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DuoBjM8GI38sp75p3Ut62FhyYrWlBRprIMI2pdQoOzWDMTlTd9cxNR0+ckHO4BHeGPEKKu3euz/qTuE6KE9K5XHAJ7Z9Uyp1gYKR+tZ6uPpqldtBZO+40LVMqZBu62Nl9dylcRzUqQSxriacgxoRaJuo9v7lQSAtCa77BywAA/A=  ;
X-YMail-OSG: liZdtmMVM1l7XPhma4jkupQzeyo6dP5YNvUq5kb4Qrrbbb9SaLIXjR1z.Na0kuJAr1SufEQ0xg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Fri, 14 Sep 2007 07:20:05 +1000
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
References: <20070911060349.993975297@sgi.com> <200709121246.08833.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709121607140.4204@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709121607140.4204@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709140720.06537.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2007 09:17, Christoph Lameter wrote:
> On Wed, 12 Sep 2007, Nick Piggin wrote:
> > I will still argue that my approach is the better technical solution for
> > large block support than yours, I don't think we made progress on that.
> > And I'm quite sure we agreed at the VM summit not to rely on your patches
> > for VM or IO scalability.
>
> The approach has already been tried (see the XFS layer) and found lacking.

It is lacking because our vmap algorithms are simplistic to the point
of being utterly inadequate for the new requirements. There has not
been any fundamental problem revealed (like the fragmentation 
approach has).

However fsblock can do everything that higher order pagecache can
do in terms of avoiding vmap and giving contiguous memory to block
devices by opportunistically allocating higher orders of pages, and falling
back to vmap if they cannot be satisfied.

So if you argue that vmap is a downside, then please tell me how you
consider the -ENOMEM of your approach to be better?


> Having a fake linear block through vmalloc means that a special software
> layer must be introduced and we may face special casing in the block / fs
> layer to check if we have one of these strange vmalloc blocks.

I guess you're a little confused. There is nothing fake about the linear
address. Filesystems of course need changes (the block layer needs
none -- why would it?). But changing APIs to accommodate a better
solution is what Linux is about.

If, by special software layer, you mean the vmap/vunmap support in
fsblock, let's see... that's probably all of a hundred or two lines.
Contrast that with anti-fragmentation, lumpy reclaim, higher order
pagecache and its new special mmap layer... Hmm, seems like a no
brainer to me. You really still want to persue the "extra layer"
argument as a point against fsblock here?


> > But you just showed in two emails that you don't understand what the
> > problem is. To reiterate: lumpy reclaim does *not* invalidate my
> > formulae; and antifrag does *not* isolate the issue.
>
> I do understand what the problem is. I just do not get what your problem
> with this is and why you have this drive to demand perfection. We are

Oh. I don't think I could explain that if you still don't understand by now.
But that's not the main issue: all that I ask is you consider fsblock on
technical grounds. 


> working a variety of approaches on the (potential) issue but you
> categorically state that it cannot be solved.

Of course I wouldn't state that. On the contrary, I categorically state that
I have already solved it :)


> > But what do you say about viable alternatives that do not have to
> > worry about these "unlikely scenarios", full stop? So, why should we
> > not use fs block for higher order page support?
>
> Because it has already been rejected in another form and adds more

You have rejected it. But they are bogus reasons, as I showed above.

You also describe some other real (if lesser) issues like number of page
structs to manage in the pagecache. But this is hardly enough to reject
my patch now... for every downside you can point out in my approach, I
can point out one in yours.

- fsblock doesn't require changes to virtual memory layer
- fsblock can retain cache of just 4K in a > 4K block size file

How about those? I know very well how Linus feels about both of them.


> Maybe we coud get to something like a hybrid that avoids some of these
> issues? Add support so something like a virtual compound page can be
> handled transparently in the filesystem layer with special casing if
> such a beast reaches the block layer?

That's conceptually much worse, IMO.

And practically worse as well: vmap space is limited on 32-bit; fsblock
approach can avoid vmap completely in many cases; for two reasons.

The fsblock data accessor APIs aren't _that_ bad changes. They change
zero conceptually in the filesystem, are arguably cleaner, and can be
essentially nooped if we wanted to stay with a b_data type approach
(but they give you that flexibility to replace it with any implementation).

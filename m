Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbXIRRat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbXIRRat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932086AbXIRR3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:29:54 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:23414 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760082AbXIRR3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:29:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=Bdc0qa4hqmJ2giwVB4QOFaLoWx2uliiPFhC7U6swLrWpZuUjWSSHr9TY60Dd3Zlbh57MIv7Ng5w96iSwtYtMJGbdu4fpcinPc1uDYOWv+KLMeSWAiOPqB7qGAhDVujT6upoCBeqKIS2vOTDnKPBA6vM3eCWtHnDE0z++YPW7flo=  ;
X-YMail-OSG: cdPNCbQVM1mfzmr1pqtoirSr59_fE7ASxX5V3.H33wozepgnNj55NYqBLqcd47zmHTvwSWA7QQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 18 Sep 2007 11:16:21 +1000
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
References: <20070911060349.993975297@sgi.com> <200709161853.12050.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709181116.22573.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2007 08:21, Christoph Lameter wrote:
> On Sun, 16 Sep 2007, Nick Piggin wrote:
> > > > So if you argue that vmap is a downside, then please tell me how you
> > > > consider the -ENOMEM of your approach to be better?
> > >
> > > That is again pretty undifferentiated. Are we talking about low page
> >
> > In general.
>
> There is no -ENOMEM approach. Lower order page allocation (<
> PAGE_ALLOC_COSTLY_ORDER) will reclaim and in the worst case the OOM killer
> will be activated.

ROFL! Yeah of course, how could I have forgotten about our trusty OOM killer
as the solution to the fragmentation problem? It would only have been funnier
if you had said to reboot every so often when memory gets fragmented :)


> That is the nature of the failures that we saw early in 
> the year when this was first merged into mm.
>
> > > With the ZONE_MOVABLE you can remove the unmovable objects into a
> > > defined pool then higher order success rates become reasonable.
> >
> > OK, if you rely on reserve pools, then it is not 1st class support and
> > hence it is a non-solution to VM and IO scalability problems.
>
> ZONE_MOVABLE creates two memory pools in a machine. One of them is for
> movable and one for unmovable. That is in 2.6.23. So 2.6.23 has no first
> call support for order 0 pages?

What?


> > > > If, by special software layer, you mean the vmap/vunmap support in
> > > > fsblock, let's see... that's probably all of a hundred or two lines.
> > > > Contrast that with anti-fragmentation, lumpy reclaim, higher order
> > > > pagecache and its new special mmap layer... Hmm, seems like a no
> > > > brainer to me. You really still want to persue the "extra layer"
> > > > argument as a point against fsblock here?
> > >
> > > Yes sure. You code could not live without these approaches. Without the
> >
> > Actually: your code is the one that relies on higher order allocations.
> > Now you're trying to turn that into an argument against fsblock?
>
> fsblock also needs contiguous pages in order to have a beneficial
> effect that we seem to be looking for.

Keyword: relies.


> > > antifragmentation measures your fsblock code would not be very
> > > successful in getting the larger contiguous segments you need to
> > > improve performance.
> >
> > Complely wrong. *I* don't need to do any of that to improve performance.
> > Actually the VM is well tuned for order-0 pages, and so seeing as I have
> > sane hardware, 4K pagecache works beautifully for me.
>
> Sure the system works fine as is. Not sure why we would need fsblock then.

Large block filesystem.


> > > (There is no new mmap layer, the higher order pagecache is simply the
> > > old API with set_blocksize expanded).
> >
> > Yes you add another layer in the userspace mapping code to handle higher
> > order pagecache.
>
> That would imply a new API or something? I do not see it.

I was not implying a new API.


> > > Why: It is the same approach that you use.
> >
> > Again, rubbish.
>
> Ok the logical conclusion from the above is that you think your approach
> is rubbish.... 

The logical conclusion is that _they are not the same approach_!


> Is there some way you could cool down a bit? 

I'm not upset, but what you were saying was rubbish, plain and simple. The
amount of times we've gone in circles, I most likely have already explained
this, serveral times, in a more polite manner.

And I know you're more than capable to understand at least the concept
behind fsblock, even without time to work through the exact details. What
are you expecting me to say, after all this back and forth, when you come
up with things like "[fsblock] is not a generic change but special to the
block layer", and then claim that fsblock is the same as allocating "virtual
compound pages" with vmalloc as a fallback for higher order allocs.

What I will say is that fsblock has still a relatively longer way to go, so
maybe that's your reason for not looking at it. And yes, when fsblock is
in a better state to actually perform useful comparisons with it, will be a
much better time to have these debates. But in that case, just say so :)
then I can go away and do more constructive work on it instead of filling
people's inboxes.

I believe the fsblock approach is the best one, but it's not without problems
and complexities, so I'm quite ready for it to be proven incorrect, not
performant, or otherwise rejected.

I'm going on holiday for 2 weeks. I'll try to stay away from email, and
particularly this thread.

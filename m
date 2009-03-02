Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZCBVRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZCBVRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbZCBVRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:17:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362AbZCBVRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:17:31 -0500
Date: Mon, 2 Mar 2009 13:16:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: "H. Peter Anvin" <hpa@zytor.com>, Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       mingo@elte.hu, sqazi@google.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [patch] x86, mm: pass in 'total' to
 __copy_from_user_*nocache()
In-Reply-To: <200903020106.51865.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.2.00.0903021255020.3111@localhost.localdomain>
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <20090228173813.6d86c0ef@infradead.org> <49A9E7A3.4050102@zytor.com> <200903020106.51865.nickpiggin@yahoo.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Mar 2009, Nick Piggin wrote:
> 
> I would expect any high performance CPU these days to combine entries
> in the store queue, even for normal store instructions (especially for
> linear memcpy patterns). Isn't this likely to be the case?

None of this really matters.

The big issue is that before you can do any write to any cacheline, if the 
memory is cacheable, it needs the cache coherency protocol to synchronize 
with any other CPU's that may have that line in the cache.

The _only_ time a write is "free" is when you already have that cacheline 
in your own cache, and in an "exclusive" state. If that is the case, then 
you know that you don't need to do anything else.

In _any_ other case, before you do the write, you need to make sure that 
no other CPU in the system has that line in its cache. Whether you do that 
with a "write and invalidate" model (which would be how a store buffer 
would do it or a write-through cache would work), or whether you do it 
with a "acquire exclusive cacheline" (which is how the cache coherency 
protocol would do it), it's going to end up using cache coherency 
bandwidth.

Of course, what will be the limiting factor is unclear. On a single-socket 
thing, you don't have any cache coherency issues, an the only bandwidth 
you'd end up using is the actual memory write at the memory controller 
(which may be on-die, and entirely separate from the cache coherency 
protocol). It may be idle and the write queue may be deep enough that you 
reach memory speeds and the write buffer is the optimal approach.

On many sockets, the limiting factor will almost certainly be the cache 
coherency overhead (since the cache coherency traffic needs to go to _all_ 
sockets, rather than just one stream to memory), at least unless you have 
a good cache coherency filter that can filter out part of the traffic 
based on whether it could be cached or not on some socket(s).

IOW, it's almost impossible to tell what is the best approach. It will 
depend on number of sockets, it will depend on size of cache, and it will 
depend on the capabilities and performance of the memory controllers vs 
the cache coherency protocol.

On a "single shared bus" model, the "write with invalidate" is fine, and 
it basically ends up working a lot like a single socket even if you 
actually have multiple sockets - it just won't scale much beyond two 
sockets. With HT or QPI, things are different, and the presense or absense 
of a snoop filter could make a big difference for 4+ socket situations.

There simply is no single answer. 

And we really should keep that in mind. There is no right answer, and the 
right answer will depend on hardware. Playing cache games in software is 
almost always futile. It can be a huge improvement, but it can be a huge 
deprovement too, and it really tends to be only worth it if you (a) know 
your hardware really quite well and (b) know your _load_ pretty well too.

We can play games in the kernel. We do know how many sockets there are. We 
do know the cache size. We _could_ try to make an educated guess at 
whether the next user of the data will be DMA or not. So there are 
unquestionably heuristics we could apply, but I also do suspect that 
they'd inevitably be pretty arbitrary.

I suspect that we could make some boot-time (or maybe CPU hotplug time) 
decision that simply just sets a threshold value for when it is worth 
using non-temporal stores. With smaller caches, and with a single socket 
(or a single bus), it likely makes sense to use non-temporal stores 
earlier. 

But even with some rough heuristic, it will be wrong part of the time. So 
I think "simple and predictable" in the end tends to be better than 
"complex and still known to be broken".

Btw, the "simple and predictable" could literally look at _where_ in the 
file the IO is. Because I know there are papers on the likelihood of 
re-use of data depending on where in the file it is written. Data written 
to low offsets is more likely to be accessed again (think temp-files), 
while data written to big offsets are much more likely to be random or to 
be written out (think databases or simply just large streaming files).

So I suspect a "simple and predictable" algorithm could literally be 
something like

 - use nontemporal stores only if you are writing a whole page, and the 
   byte offset of the page is larger than 'x', where 'x' may optionally 
   even depend on size of cache.

But removing it entirely may be fine too.

What I _don't_ think is fine is to think that you've "solved" it, or that 
you should even try!

			Linus

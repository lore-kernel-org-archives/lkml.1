Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbYFRQXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbYFRQXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYFRQXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:23:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbYFRQXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:23:23 -0400
Date: Wed, 18 Jun 2008 09:22:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Ken Murchison <murch@andrew.cmu.edu>
Subject: Re: Cyrus mmap vs lseek/write usage - (WAS: BUG: mmapfile/writev
 spurious zero bytes (x86_64/not i386, bisected, reproducable))
In-Reply-To: <20080618051119.GA10754@brong.net>
Message-ID: <alpine.LFD.1.10.0806180858250.2907@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171415060.2907@woody.linux-foundation.org>
 <20080618031406.GA4326@brong.net> <alpine.LFD.1.10.0806172057450.2907@woody.linux-foundation.org> <20080618051119.GA10754@brong.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jun 2008, Bron Gondwana wrote:
> On Tue, Jun 17, 2008 at 09:03:17PM -0700, Linus Torvalds wrote:
> >
> > Is there any reason it doesn't use mmap(MAP_SHARED) and make the 
> > modifications that way too?
> 
> Portability[tm].

Hmm.. I'm pretty sure that using MAP_SHARED for writing is _more_ portable 
than mixing mmap() and "write()" - or at least more _consistent_.

That said, it's probably six one way, and half a dozen the other. The 
shared writable mmap() doesn't work well on unix-lookalikes (ie "not real 
unix"). That does include really really old Linux versions (ie 1.x 
series), but more relevantly probably includes things like QNX etc.

On the other hand, the mmap()+write(), as mentioned, doesn't work well on 
various hardware platforms where theer can be cache aliases, and that 
includes HP-UX (as you apparently have noticed), but I'm pretty certain 
there are other cases too.

The cache alias issue can actually be really thorny, because it's going to 
be very hard to see and essentially random: if your working set is big 
enough (or the cache is small enough) that the cache basically gets 
flushed between the write and the access through the mmap (and vice 
versa), you'll never see any problems.

But then, _occasionally_, you'll have really hard-to-replicate corruption 
due to cache aliases (ie you read something from the mmap() after the 
write, but you don't actually see the newly written data, because it's 
cached at a different virtual address).

Linux tries really hard to be coherent between mmap and read/write even on 
those kinds of platforms, but I would definitely not call it "portable". 
It really is a fundamentally nasty thing, and depends deeply on the CPU 
architecture, not just the OS.

> It actually does use MAP_SHARED already, but only for reading.
> Writing is all done with seeks and writes, followed by a map
> "refresh", which is really just an unmmap/mmap if the file has
> extended past the "SLOP" (between 8 and 16 k after the end of
> the file length at last mapping).

Yeah, I can certainly see that working. That said, I can also see it 
failing, partly because of the CPU virtual indexing cache issues, but 
partly because it's such an unusual thing to do (partly because it simply 
is known not to work on some systems, ie HP-UX). And that will mean that 
it is probably not a well-tested path.. As you found out.

(Side note: I mention HP-UX just because it is known to historically have 
totally and utterly brain-damaged and useless mmap support. It _may_ be 
that they've fixed it in more modern versions. It literally used to be a 
mix of horrible hardware problems - the virtual cache issue - _and_ a VM 
system that was based on some really old BSD code).

So the more traditional way would be to do an all-mmap thing, and extend 
the file with ftruncate(), not write. That's somethign that programs like 
nntpd have been doing for decades, so it's a very "traditional" model and 
thus much more likely to be safe. It also avoids all the aliasing issues, 
if all accesses are done the same way.

That said, you _would_ need to have alternate strategies to access things, 
but apparently Cyrus already has such strategies at least for HP-UX.

> Ahh - I found the explaination in doc/internal/hacking in
> the Cyrus source tree.  While 'ack' is a nice tool, it
> doesn't check files with no extention by default.  Ho hum:
> 
> - map_refresh and map_free
> 
>   - In many cases, it is far more effective to read a file via the operating
>     system's mmap facility than it is to via the traditional read() and
>     lseek system calls.  To this end, Cyrus provides an operating system
>     independent wrapper around the mmap() services (or lack thereof) of the
>     operating system.

One of the issues here is that in order to give coherency for mmap + 
read/write access, the OS may need to map the area uncached or at least 
flush caches when writing. So from a pure performance standpoint, it can 
also cause problems.

Of course, even a uncached mmap() _can_ certainly be faster than using 
just read()/write(), depending on the access patterns. So maybe Cyrus is 
doing the rigth thing, it just sounds rather fragile and prone to 
unexpected and hard-to-debug problems.

			Linus

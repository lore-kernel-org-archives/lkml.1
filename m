Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbYFRFLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbYFRFLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 01:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYFRFLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 01:11:31 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54870 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbYFRFLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 01:11:30 -0400
Date: Wed, 18 Jun 2008 15:11:19 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Ken Murchison <murch@andrew.cmu.edu>
Subject: Cyrus mmap vs lseek/write usage - (WAS: BUG: mmapfile/writev
	spurious zero bytes (x86_64/not i386, bisected, reproducable))
Message-ID: <20080618051119.GA10754@brong.net>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171415060.2907@woody.linux-foundation.org> <20080618031406.GA4326@brong.net> <alpine.LFD.1.10.0806172057450.2907@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806172057450.2907@woody.linux-foundation.org>
Organization: brong.net
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 09:03:17PM -0700, Linus Torvalds wrote:
> On Wed, 18 Jun 2008, Bron Gondwana wrote:
> > 
> > For my sins, I appear to be becoming the world expert on 
> > that particular file.
> 
> Heh. Congrats ;)
> 
> > I've debugged skiplist bugs many times over, and completely rewritten 
> > the locking code.  It really does some pretty evil things - the memory 
> > accesses look something like this:
> > 
> > [file...................]
> > [mmap^....^.^........^^..................................]
> > [file...................++++++++++++]
> > [mmap^....^.^........^^.^^ ^      ^^.....................]
> > 
> > Where (^) is the bits that get accessed.  All reads are via
> > the mmap, all writes are done with retry_write or 
> > retry_writev (Cyrus library functions that keep hammering
> > until all the bytes are written)
> 
> Is there any reason it doesn't use mmap(MAP_SHARED) and make the 
> modifications that way too?

Portability[tm].

It actually does use MAP_SHARED already, but only for reading.
Writing is all done with seeks and writes, followed by a map
"refresh", which is really just an unmmap/mmap if the file has
extended past the "SLOP" (between 8 and 16 k after the end of
the file length at last mapping).

I can't just right now find the place where the reasoning behind
this was explained to me.  The theory I think was that mmap write
support is unreliable across systems, but read support is pretty 
good (except HPUX for which there is map_stupidshared.c)

> Because quite frankly, the mixture of doing mmap() and write() system 
> calls is quite fragile - and I'm not saying that just because of this 
> particular bug, but because there are all kinds of nasty cache aliasing 
> issues with virtually indexed caches etc that just fundamentally mean that 
> it's often a mistake to mix mmap with read/write at the same time.

I'm not actually a maintainer for Cyrus, I just write patches to
keep our mail servers working.  I'll pass this on.

> (For the same reason it's not a good idea to mix writing through an mmap() 
> and then using read() to read it - again, you can have some nasty aliasing 
> going on there).
>
> So this particular issue was definitely a kernel bug (and big thanks for 
> making such a good test-case), but in general, it does sound like Cyrus is 
> actively trying to dig itself into a nasty hole there.

Yeah, indeed.

I suspect the response from the Cyrus side might include a
small dose of "POSIX says it's valid to do this, and making
it work is the kernel programmers' lookout".

Ahh - I found the explaination in doc/internal/hacking in
the Cyrus source tree.  While 'ack' is a nice tool, it
doesn't check files with no extention by default.  Ho hum:

- map_refresh and map_free

  - In many cases, it is far more effective to read a file via the operating
    system's mmap facility than it is to via the traditional read() and
    lseek system calls.  To this end, Cyrus provides an operating system
    independent wrapper around the mmap() services (or lack thereof) of the
    operating system.

  - Cyrus currently only supports read-only memory maps, all writes back
    to a file need to be done via the more traditional facilities.  This is
    to enable very low-performance support for operating systems which do not
    provide an mmap() facility via a fake userspace mmap.

  - To create a map, simply call map_refresh on the map (details are in
    lib/map.h).  To free it, call map_free on the same map.

  - Despite the fact that the maps are read-only, it is often useful to open
    the file descriptors O_RDWR, especially if the file decriptors could
    possibly be used for writing elsewhere in the code. Some operating
    systems REQUIRE file descriptors that are mmap()ed to be opened
    O_RDWR, so just do it.

If I was God in the Cyrus world (woot) I suspect I'd 
provide some sort of OS independent wrapper around the 
various write functions, using mmap where appropriate,
while still working via lseek/write for those systems 
without mmap support.

(Added CC: Ken Murchison, on the grounds that he actually 
is God in the Cyrus world)

Thanks for the good explaination.  I'll have a look at the
Cyrus code and see just how tricky that would actually be
(even just doing the skiplist, index and cache code would
hit 99% of the cases where files are both mmaped and
written concurrently)

Bron.


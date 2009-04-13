Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZDMPRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZDMPRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 11:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbZDMPQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 11:16:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731AbZDMPQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 11:16:57 -0400
Date: Mon, 13 Apr 2009 08:10:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Avi Kivity <avi@redhat.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
In-Reply-To: <49E2DC96.6090407@redhat.com>
Message-ID: <alpine.LFD.2.00.0904130747440.4583@localhost.localdomain>
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <20090412162018.6c1507b4@lxorguk.ukuu.org.uk> <49E213AE.4060506@redhat.com> <alpine.LFD.2.00.0904120950050.4583@localhost.localdomain>
 <49E2DC96.6090407@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Apr 2009, Avi Kivity wrote:
> > 
> >  - create a big file,
> 
> Just creating a 5GB file in a 64KB filesystem was interesting - Windows 
> was throwing out 256KB I/Os even though I was generating 1MB writes (and 
> cached too).  Looks like a paranoid IDE driver (qemu exposes a PIIX4).

Heh, ok. So the "big file" really only needed to be big enough to not be 
cached, and 5GB was probably overkill. In fact, if there's some way to 
blow the cache, you could have made it much smaller. But 5G certainly 
works ;)

And yeah, I'm not surprised it limits the size of the IO. Linux will 
generally do the same. I forget what our default maximum bio size is, but 
I suspect it is in that same kind of range.

There are often problems with bigger IO's (latency being one, actual 
controller bugs being another), and even if the hardware has no bugs and 
its limits are higher, you usually don't want to have excessively large 
DMA mapping tables _and_ the advantage of bigger IO is usually not that 
big once you pass the "reasonably sized" limit (which is 64kB+). Plus they 
happen seldom enough in practice anyway that it's often not worth 
optimizing for.

> > then rewrite just a few bytes in it, and look at the IO pattern of the 
> > result. Does it actually do the rewrite IO as one 16kB IO, or does it 
> > do sub-blocking?
> 
> It generates 4KB writes (I was generating aligned 512 byte overwrites). 
> What's more interesting, it was also issuing 32KB reads to fill the 
> cache, not 64KB.  Since the number of reads and writes per second is 
> almost equal, it's not splitting a 64KB read into two.

Ok, that sounds pretty much _exactly_ like the Linux IO patterns would 
likely be.

The 32kB read has likely nothing to do with any filesystem layout issues 
(especially as you used a 64kB cluster size), but is simply because 

 (a) Windows caches things with a 4kB granularity, so the 512-byte write 
     turned into a read-modify-write
 (b) the read was really for just 4kB, but once you start reading you want 
     to do read-ahead anyway since it hardly gets any more expensive to 
     read a few pages than to read just one.

So once it had to do the read anyway, windows just read 8 pages instead of 
one - very reasonable. 

> >    If the latter, then the 16kB thing is just a filesystem layout 
> > issue, not an internal block-size issue, and WNT would likely have 
> > exactly the same issues as Linux.
> 
> A 1 byte write on an ordinary file generates a RMW, same as a 4KB write on a
> 16KB block.  So long as the filesystem is just a layer behind the pagecache
> (which I think is the case on Windows), I don't see what issues it can have.

Right. It's all very straightforward from a filesystem layout issue. The 
problem is all about managing memory.

You absolutely do _not_ want to manage memory in 16kB chunks (or 64kB for 
your example!). It's a total disaster. Imagine what would happen to user 
application performance if kmalloc() always returned 16kB-aligned chunks 
of memory, all sized as integer multiples of 16kB? It would absolutely 
_suck_. Sure, it would be fine for your large allocations, but any time 
you handle strings, you'd allocate 16kB of memory for any small 5-byte 
string. You'd have horrible cache behavior, and you'd run out of memory 
much too quickly.

The same is true in the kernel. The single biggest memory user under 
almost all normal loads is the disk cache. That _is_ the normal allocator 
for any OS kernel. Everything else is almost details (ok, so Linux in 
particular does cache metadata very aggressively, so the dcache and inode 
cache are seldom "just details", but the page cache is still generally the 
most important part).

So having a 16kB or 64kB granularity is a _disaster_. Which is why no sane 
system does that. It's only useful if you absolutely _only_ work with 
large files - ie you're a database server. For just about any other 
workload, that kind of granularity is totally unnacceptable.

So doing a read-modify-write on a 1-byte (or 512-byte) write, when the 
block size is 4kB is easy - we just have to do it anyway. 

Doing a read-modify-write on a 4kB write and a 16kB (or 64kB) blocksize is 
also _doable_, and from the IO pattern standpoint it is no different. But 
from a memory allocation pattern standpoint it's a disaster - because now 
you're always working with chunks that are just 'too big' to be good 
building blocks of a reasonable allocator.

If you always allocate 64kB for file caches, and you work with lots of 
small files (like a source tree), you will literally waste all your 
memory.

And if you have some "dynamic" scheme, you'll have tons and tons of really 
nasty cases when you have to grow a 4kB allocation to a 64kB one when the 
file grows. Imagine doing "realloc()", but doing it in a _threaded_ 
environment, where any number of threads may be using the old allocation 
at the same time. And that's a kernel - it has to be _the_ most 
threaded program on the whole machine, because otherwise the kernel 
would be the scaling bottleneck.

And THAT is why 64kB blocks is such a disaster.

> >  - can you tell how many small files it will cache in RAM without doing
> > IO? If it always uses 16kB blocks for caching, it will be able to cache    a
> > _lot_ fewer files in the same amount of RAM than with a smaller block
> > size.
> 
> I'll do this later, but given the 32KB reads for the test above, I'm guessing
> it will cache pages, not blocks.

Yeah, you don't need to.

I can already guarantee that Windows does caching on a page granularity.

I can also pretty much guarantee that that is also why Windows stops 
compressing files once the blocksize is bigger than 4kB: because at that 
point, the block compressions would need to handle _multiple_ cache 
entities, and that's really painful for all the same reasons that bigger 
sectors would be really painful - you'd always need to make sure that you 
always have all of those cache entries in memory together, and you could 
never treat your cache entries as individual entities.

> > Of course, the _really_ conclusive thing (in a virtualized environment) is
> > to just make the virtual disk only able to do 16kB IO accesses (and with
> > 16kB alignment). IOW, actually emulate a disk with a 16kB hard sector size,
> > and reporting a 16kB sector size to the READ CAPACITY command. If it works
> > then, then clearly WNT has no issues with bigger sectors.
> 
> I don't think IDE supports this?  And Windows 2008 doesn't like the LSI
> emulated device we expose.

Yeah, you'd have to have the OS use the SCSI commands for disk discovery, 
so at least a SATA interface. With IDE disks, the sector size always has 
to be 512 bytes, I think.

		Linus

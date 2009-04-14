Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZDNKBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZDNKBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZDNKB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:01:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33973 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbZDNKBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:01:25 -0400
Message-ID: <49E45E9C.1020105@redhat.com>
Date: Tue, 14 Apr 2009 12:59:56 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <20090412162018.6c1507b4@lxorguk.ukuu.org.uk> <49E213AE.4060506@redhat.com> <alpine.LFD.2.00.0904120950050.4583@localhost.localdomain> <49E2DC96.6090407@redhat.com> <alpine.LFD.2.00.0904130747440.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904130747440.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 13 Apr 2009, Avi Kivity wrote:
>   
>>>  - create a big file,
>>>       
>> Just creating a 5GB file in a 64KB filesystem was interesting - Windows 
>> was throwing out 256KB I/Os even though I was generating 1MB writes (and 
>> cached too).  Looks like a paranoid IDE driver (qemu exposes a PIIX4).
>>     
>
> Heh, ok. So the "big file" really only needed to be big enough to not be 
> cached, and 5GB was probably overkill. In fact, if there's some way to 
> blow the cache, you could have made it much smaller. But 5G certainly 
> works ;)
>   

I wanted to make sure my random writes later don't get coalesced.  A 1GB 
file, half of which is cached (I used a 1GB guest), offers lots of 
chances for coalescing if Windows delays the writes sufficiently.  At 
5GB, Windows can only cache 10% of the file, so it will be continuously 
flushing.


>
>  (a) Windows caches things with a 4kB granularity, so the 512-byte write 
>      turned into a read-modify-write
>   
>   
[...]

> You absolutely do _not_ want to manage memory in 16kB chunks (or 64kB for 
> your example!). It's a total disaster. Imagine what would happen to user 
> application performance if kmalloc() always returned 16kB-aligned chunks 
> of memory, all sized as integer multiples of 16kB? It would absolutely 
> _suck_. Sure, it would be fine for your large allocations, but any time 
> you handle strings, you'd allocate 16kB of memory for any small 5-byte 
> string. You'd have horrible cache behavior, and you'd run out of memory 
> much too quickly.
>
> The same is true in the kernel. The single biggest memory user under 
> almost all normal loads is the disk cache. That _is_ the normal allocator 
> for any OS kernel. Everything else is almost details (ok, so Linux in 
> particular does cache metadata very aggressively, so the dcache and inode 
> cache are seldom "just details", but the page cache is still generally the 
> most important part).
>
> So having a 16kB or 64kB granularity is a _disaster_. Which is why no sane 
> system does that. It's only useful if you absolutely _only_ work with 
> large files - ie you're a database server. For just about any other 
> workload, that kind of granularity is totally unnacceptable.
>
> So doing a read-modify-write on a 1-byte (or 512-byte) write, when the 
> block size is 4kB is easy - we just have to do it anyway. 
>
> Doing a read-modify-write on a 4kB write and a 16kB (or 64kB) blocksize is 
> also _doable_, and from the IO pattern standpoint it is no different. But 
> from a memory allocation pattern standpoint it's a disaster - because now 
> you're always working with chunks that are just 'too big' to be good 
> building blocks of a reasonable allocator.
>
> If you always allocate 64kB for file caches, and you work with lots of 
> small files (like a source tree), you will literally waste all your 
> memory.
>
>   

Well, no one is talking about 64KB granularity for in-core files.  Like 
you noticed, Windows uses the mmu page size.  We could keep doing that, 
and still have 16KB+ sector sizes.  It just means a RMW if you don't 
happen to have the adjoining clean pages in cache.

Sure, on a rotating disk that's a disaster, but we're talking SSD here, 
so while you're doubling your access time, you're doubling a fairly 
small quantity.  The controller would do the same if it exposed smaller 
sectors, so there's no huge loss.

We still lose on disk storage efficiency, but I'm guessing that a modern 
tree with some object files with debug information and a .git directory 
it won't be such a great hit.  For more mainstream uses, it would be 
negligible.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


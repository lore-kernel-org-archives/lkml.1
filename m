Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbZDMGdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbZDMGdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 02:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZDMGd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 02:33:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50980 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbZDMGdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 02:33:25 -0400
Message-ID: <49E2DC96.6090407@redhat.com>
Date: Mon, 13 Apr 2009 09:32:54 +0300
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
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <20090412162018.6c1507b4@lxorguk.ukuu.org.uk> <49E213AE.4060506@redhat.com> <alpine.LFD.2.00.0904120950050.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904120950050.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Sun, 12 Apr 2009, Avi Kivity wrote:
>   
>> A quick test shows that it can.  I didn't try mmap(), but copying files around
>> worked.
>>     
>
> You being who you are, I'm assuming you're doing this in a virtual 
> environment, so you might be able to see the IO patterns..
>
>   

Yes.  I just used the Windows performance counters rather than mess with 
qemu for the test below.

> Can you tell if it does the IO in chunks of 16kB or smaller? That can be 
> hard to see with trivial tests (since any filesystem will try to chunk up 
> writes regardless of how small the cache entry is, and on file creation it 
> will have to write the full 16kB anyway just to initialize the newly 
> allocated blocks on disk), but there's a couple of things that should be 
> reasonably good litmus tests of what WNT does internally:
>
>  - create a big file, 

Just creating a 5GB file in a 64KB filesystem was interesting - Windows 
was throwing out 256KB I/Os even though I was generating 1MB writes  
(and cached too).  Looks like a paranoid IDE driver (qemu exposes a PIIX4).

> then rewrite just a few bytes in it, and look at the 
>    IO pattern of the result. Does it actually do the rewrite IO as one 
>    16kB IO, or does it do sub-blocking?
>   

It generates 4KB writes (I was generating aligned 512 byte overwrites).  
What's more interesting, it was also issuing 32KB reads to fill the 
cache, not 64KB.  Since the number of reads and writes per second is 
almost equal, it's not splitting a 64KB read into two.

>    If the latter, then the 16kB thing is just a filesystem layout issue, 
>    not an internal block-size issue, and WNT would likely have exactly the 
>    same issues as Linux.
>   

A 1 byte write on an ordinary file generates a RMW, same as a 4KB write 
on a 16KB block.  So long as the filesystem is just a layer behind the 
pagecache (which I think is the case on Windows), I don't see what 
issues it can have.

>  - can you tell how many small files it will cache in RAM without doing 
>    IO? If it always uses 16kB blocks for caching, it will be able to cache 
>    a _lot_ fewer files in the same amount of RAM than with a smaller block 
>    size.
>   

I'll do this later, but given the 32KB reads for the test above, I'm 
guessing it will cache pages, not blocks.

> Of course, the _really_ conclusive thing (in a virtualized environment) is 
> to just make the virtual disk only able to do 16kB IO accesses (and with 
> 16kB alignment). IOW, actually emulate a disk with a 16kB hard sector 
> size, and reporting a 16kB sector size to the READ CAPACITY command. If it 
> works then, then clearly WNT has no issues with bigger sectors.
>   

I don't think IDE supports this?  And Windows 2008 doesn't like the LSI 
emulated device we expose.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


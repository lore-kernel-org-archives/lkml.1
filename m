Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbZDLPqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbZDLPqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 11:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZDLPqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 11:46:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbZDLPqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 11:46:20 -0400
Date: Sun, 12 Apr 2009 08:41:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Szabolcs Szakacsits <szaka@ntfs-3g.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
In-Reply-To: <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net>
Message-ID: <alpine.LFD.2.00.0904120820410.4583@localhost.localdomain>
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 12 Apr 2009, Szabolcs Szakacsits wrote:
> 
> I did not hear about NTFS using >4kB sectors yet but technically 
> it should work.
> 
> The atomic building units (sector size, block size, etc) of NTFS are 
> entirely parametric. The maximum values could be bigger than the 
> currently "configured" maximum limits. 

It's probably trivial to make ext3 support 16kB blocksizes (if it doesn't 
already).

That's not the problem. The "filesystem layout" part is just a parameter.

The problem is then trying to actually access such a filesystem, in 
particular trying to write to it, or trying to mmap() small chunks of it. 
The FS layout is the trivial part.

> At present the limits are set in the BIOS Parameter Block in the NTFS
> Boot Sector. This is 2 bytes for the "Bytes Per Sector" and 1 byte for 
> "Sectors Per Block". So >4kB sector size should work since 1993.
> 
> 64kB+ sector size could be possible by bootstrapping NTFS drivers 
> in a different way. 

Try it. And I don't mean "try to create that kind of filesystem". Try to 
_use_ it. Does Window actually support using it it, or is it just a matter 
of "the filesystem layout is _specified_ for up to 64kB block sizes"?

And I really don't know. Maybe Windows does support it. I'm just very 
suspicious. I think there's a damn good reason why NTFS supports larger 
block sizes in theory, BUT EVERYBODY USES A 4kB BLOCKSIZE DESPITE THAT!

Because it really is a hard problem. It's really pretty nasty to have your 
cache blocking be smaller than the actual filesystem blocksize (the other 
way is much easier, although it's certainly not pleasant either - Linux 
supports it because we _have_ to, but sector-size of hardware had 
traditionally been 4kB, I'd certainly also argue against adding complexity 
just to make it smaller, the same way I argue against making it much 
larger).

And don't get me wrong - we could (fairly) trivially make the 
PAGE_CACHE_SIZE be bigger - even eventually go so far as to make it a 
per-mapping thing, so that you could have some filesystems with that 
bigger sector size and some with smaller ones. I think Andrea had patches 
that did a fair chunk of it, and that _almost_ worked.

But it ABSOLUTELY SUCKS. If we did a 16kB page-cache-size, it would 
absolutely blow chunks. It would be disgustingly horrible. Putting the 
kernel source tree on such a filesystem would waste about 75% of all 
memory (the median size of a source file is just about 4kB), so your page 
cache would be effectively cut in a quarter for a lot of real loads.

And to fix up _that_, you'd need to now do things like sub-page 
allocations, and now your page-cache size isn't even fixed per filesystem, 
it would be per-file, and the filesystem (and the drievrs!) would hav to 
handle the cases of getting those 4kB partial pages (and do r-m-w IO after 
all if your hardware sector size is >4kB).

IOW, there are simple things we can do - but they would SUCK. And there 
are really complicated things we could do - and they would _still_ SUCK, 
plus now I pretty much guarantee that your system would also be a lot less 
stable. 

It really isn't worth it. It's much better for everybody to just be aware 
of the incredible level of pure suckage of a general-purpose disk that has 
hardware sectors >4kB. Just educate people that it's not good. Avoid the 
whole insane suckage early, rather than be disappointed in hardware that 
is total and utter CRAP and just causes untold problems.

Now, for specialty uses, things are different. CD-ROM's have had 2kB 
sector sizes for a long time, and the reason it was never as big of a 
problem isn't that they are still smaller than 4kB - it's that they are 
read-only, and use special filesystems. And people _know_ they are 
special. Yes, even when you write to them, it's a very special op. You'd 
never try to put NTFS on a CD-ROM, and everybody knows it's not a disk 
replacement.

In _those_ kinds of situations, a 64kB block isn't much of a problem. We 
can do read-only media (where "read-only" doesn't have to be absolute: the 
important part is that writing is special), and never have problems. 
That's easy. Almost all the problems with block-size go away if you think 
reading is 99.9% of the load. 

But if you want to see it as a _disk_ (ie replacing SSD's or rotational 
media), 4kB blocksize is the maximum sane one for Linux/x86 (or, indeed, 
any "Linux/not-just-database-server" - it really isn't so much about x86, 
as it is about large cache granularity causing huge memory fragmentation 
issues).

			Linus

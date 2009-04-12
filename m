Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbZDLRYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbZDLRYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZDLRX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:23:57 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39359 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbZDLRXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:23:55 -0400
Subject: Re: Implementing NVMHCI...
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0904120820410.4583@localhost.localdomain>
References: <20090412091228.GA29937@elte.hu>
	 <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net>
	 <alpine.LFD.2.00.0904120820410.4583@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 12 Apr 2009 17:23:54 +0000
Message-Id: <1239557034.3461.14.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-12 at 08:41 -0700, Linus Torvalds wrote:
> 
> On Sun, 12 Apr 2009, Szabolcs Szakacsits wrote:
> > 
> > I did not hear about NTFS using >4kB sectors yet but technically 
> > it should work.
> > 
> > The atomic building units (sector size, block size, etc) of NTFS are 
> > entirely parametric. The maximum values could be bigger than the 
> > currently "configured" maximum limits. 
> 
> It's probably trivial to make ext3 support 16kB blocksizes (if it doesn't 
> already).
> 
> That's not the problem. The "filesystem layout" part is just a parameter.
> 
> The problem is then trying to actually access such a filesystem, in 
> particular trying to write to it, or trying to mmap() small chunks of it. 
> The FS layout is the trivial part.
> 
> > At present the limits are set in the BIOS Parameter Block in the NTFS
> > Boot Sector. This is 2 bytes for the "Bytes Per Sector" and 1 byte for 
> > "Sectors Per Block". So >4kB sector size should work since 1993.
> > 
> > 64kB+ sector size could be possible by bootstrapping NTFS drivers 
> > in a different way. 
> 
> Try it. And I don't mean "try to create that kind of filesystem". Try to 
> _use_ it. Does Window actually support using it it, or is it just a matter 
> of "the filesystem layout is _specified_ for up to 64kB block sizes"?
> 
> And I really don't know. Maybe Windows does support it. I'm just very 
> suspicious. I think there's a damn good reason why NTFS supports larger 
> block sizes in theory, BUT EVERYBODY USES A 4kB BLOCKSIZE DESPITE THAT!
> 
> Because it really is a hard problem. It's really pretty nasty to have your 
> cache blocking be smaller than the actual filesystem blocksize (the other 
> way is much easier, although it's certainly not pleasant either - Linux 
> supports it because we _have_ to, but sector-size of hardware had 
> traditionally been 4kB, I'd certainly also argue against adding complexity 
> just to make it smaller, the same way I argue against making it much 
> larger).
> 
> And don't get me wrong - we could (fairly) trivially make the 
> PAGE_CACHE_SIZE be bigger - even eventually go so far as to make it a 
> per-mapping thing, so that you could have some filesystems with that 
> bigger sector size and some with smaller ones. I think Andrea had patches 
> that did a fair chunk of it, and that _almost_ worked.
> 
> But it ABSOLUTELY SUCKS. If we did a 16kB page-cache-size, it would 
> absolutely blow chunks. It would be disgustingly horrible. Putting the 
> kernel source tree on such a filesystem would waste about 75% of all 
> memory (the median size of a source file is just about 4kB), so your page 
> cache would be effectively cut in a quarter for a lot of real loads.
> 
> And to fix up _that_, you'd need to now do things like sub-page 
> allocations, and now your page-cache size isn't even fixed per filesystem, 
> it would be per-file, and the filesystem (and the drievrs!) would hav to 
> handle the cases of getting those 4kB partial pages (and do r-m-w IO after 
> all if your hardware sector size is >4kB).

We might not have to go that far for a device with these special
characteristics.  It should be possible to build a block size remapping
Read Modify Write type device to present a 4k block size to the OS while
operating in n*4k blocks for the device.  We could implement the read
operations as readahead in the page cache, so if we're lucky we mostly
end up operating on full n*4k blocks anyway.  For the cases where we've
lost pieces of the n*4k native block and we have to do a write, we'd
just suck it up and do a read modify write on a separate memory area, a
bit like the new 4k sector devices do emulating 512 byte blocks.  The
suck factor of this double I/O plus memory copy overhead should be
mitigated partially by the fact that the underlying device is very fast.

James



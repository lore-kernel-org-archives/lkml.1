Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbZDKWj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbZDKWj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 18:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758738AbZDKWjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 18:39:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756888AbZDKWjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 18:39:10 -0400
Date: Sat, 11 Apr 2009 15:33:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Grant Grundler <grundler@google.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
In-Reply-To: <da824cf30904111449y5cb7c178ldf5291506ad6b393@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904111524000.4583@localhost.localdomain>
References: <49E0D47B.9070205@garzik.org>  <20090411203246.513a0892@lxorguk.ukuu.org.uk>  <alpine.LFD.2.00.0904111250370.4583@localhost.localdomain> <da824cf30904111449y5cb7c178ldf5291506ad6b393@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 11 Apr 2009, Grant Grundler wrote:
> 
> Why does it matter what the sector size is?
> I'm failing to see what the fuss is about.
> 
> We've abstract the DMA mapping/SG list handling enough that the
> block size should make no more difference than it does for the
> MTU size of a network.

The VM is not ready or willing to do more than 4kB pages for any normal 
cacheing scheme.

> And the linux VM does handle bigger than 4k pages (several architectures
> have implemented it) - even if x86 only supports 4k as base page size.

4k is not just the "supported" base page size, it's the only sane one. 
Bigger pages waste memory like mad on any normal load due to 
fragmentation. Only basically single-purpose servers are worth doing 
bigger pages for.

> Block size just defines the granularity of the device's address space in
> the same way the VM base page size defines the Virtual address space.

.. and the point is, if you have granularity that is bigger than 4kB, you 
lose binary compatibility on x86, for example. The 4kB thing is encoded in 
mmap() semantics.

In other words, if you have sector size >4kB, your hardware is CRAP. It's 
unusable sh*t. No ifs, buts or maybe's about it.

Sure, we can work around it. We can work around it by doing things like 
read-modify-write cycles with bounce buffers (and where DMA remapping can 
be used to avoid the copy). Or we can work around it by saying that if you 
mmap files on such a a filesystem, your mmap's will have to have 8kB 
alignment semantics, and the hardware is only useful for servers.

Or we can just tell people what a total piece of shit the hardware is.

So if you're involved with any such hardware or know people who are, you 
might give people strong hints that sector sizes >4kB will not be taken 
seriously by a huge number of people. Maybe it's not too late to head the 
crap off at the pass.

Btw, this is not a new issue. Sandisk and some other totally clueless SSD 
manufacturers tried to convince people that 64kB access sizes were the 
RightThing(tm) to do. The reason? Their SSD's were crap, and couldn't do 
anything better, so they tried to blame software.

Then Intel came out with their controller, and now the same people who 
tried to sell their sh*t-for-brain SSD's are finally admittign that 
it was crap hardware.

Do you really want to go through that one more time?

			Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbYEEXMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbYEEXMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYEEXMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:12:09 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:39548 "EHLO
	outbound5-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240AbYEEXMH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:12:07 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Microblaze: implement dma-coherent API and refactorcache flush code.
Date: Mon, 5 May 2008 16:12:08 -0700
In-reply-to: <1210028237.5798.121.camel@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Microblaze: implement dma-coherent API and refactorcache flush code.
Thread-Index: AcivA4PGUWGHhnjGSS+qi/gjoKoJIwAADUTw
References: <20080505223706.1236C1C8004E@mail131-sin.bigfish.com> <1210028237.5798.121.camel@localhost>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: "John Williams" <john.williams@petalogix.com>
Cc: <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
       "John Linn" <linnj@xilinx.com>, <matthew@wil.cx>,
       <will.newton@gmail.com>, <drepper@redhat.com>,
       <microblaze-uclinux@itee.uq.edu.au>, <grant.likely@secretlab.ca>,
       "Michal Simek" <monstr@monstr.eu>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 May 2008 23:12:06.0156 (UTC) FILETIME=[6F9174C0:01C8AF05]
Message-Id: <20080505231206.922A61C780C0@mail19-wa4.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: John Williams [mailto:john.williams@petalogix.com]
> Sent: Monday, May 05, 2008 3:57 PM
> To: Stephen Neuendorffer
> Cc: arnd@arndb.de; linux-arch@vger.kernel.org; John Linn;
matthew@wil.cx; will.newton@gmail.com;
> drepper@redhat.com; microblaze-uclinux@itee.uq.edu.au;
grant.likely@secretlab.ca; Michal Simek;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Microblaze: implement dma-coherent API and
refactorcache flush code.
> 
> Hi Steve,
> 
> On Mon, 2008-05-05 at 15:37 -0700, Stephen Neuendorffer wrote:
> 
> > In particular, the dcache in the microblaze is write through, so the
> > existing code is more easily thought of as 'invalidation' than
> > 'flushing'.  In addition, some of the flush_* methods were old, and
> > some shouldn't need to be implemented (since currently no mmu is
> > supported).
> 
> I agree - this renaming is a long time coming.
> 
> [snip]
> 
> Does the DMA API insist upon the dma_cache_sync call to guarantee
> sensible results?  If so, your implementation looks fine.  If not,
then
> the results will clearly be bogus as there's nothing magical about the
> memory being allocated in dma_alloc.

Yes, in fact this is one of the keys to getting the lltemac driver to
work right.  see Documentation/DMA-API.txt

> To that end, can it just call kmalloc(), and similarly kfree() for
> dma_free?

My understanding is that on other architectures (x86, for instance)
'dma' memory ensures other things, like it's accessible in PCI memory
space.  On microblaze, there's nothing really special about dma memory,
but you get the API as a chunk.
 
> I'd still like to see the uncached shadow stuff make a return one day,
> it is an effective way of solving the problem, we'll just need to find
a
> cleaner way to implement it.  A linear walk through the cache to
> invalidate is so slow, it destroys any benefit gained from DMA in the
> first place.

I think it's definitely a simple way of solving the problem (in fact,
the version of the code that's currently at git.xilinx.com includes it).
Would it be better dealt with at the page level, rather than at the
address level, then one of the architecture-reserved flags could be used
for it?
If it really does have value, then I want to make sure it goes in, along
with bits in EDK that make it straightforward to use.  For me, the
biggest barrier to using it is understanding exactly what assumptions it
is making on the hardware, and making those assumptions bulletproof.

Steve



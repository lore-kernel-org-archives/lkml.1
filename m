Return-Path: <linux-kernel-owner+w=401wt.eu-S1763699AbYEFAQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763699AbYEFAQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbYEFAPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:15:45 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:51413 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817AbYEFAPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:15:42 -0400
X-ClientAddr: 220.233.82.121
Subject: RE: [PATCH] Microblaze: implement dma-coherent API and
	refactorcache flush code.
From: John Williams <john.williams@petalogix.com>
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, John Linn <linnj@xilinx.com>,
       matthew@wil.cx, will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080505231206.922A61C780C0@mail19-wa4.bigfish.com>
References: <20080505223706.1236C1C8004E@mail131-sin.bigfish.com>
	 <1210028237.5798.121.camel@localhost>
	 <20080505231206.922A61C780C0@mail19-wa4.bigfish.com>
Content-Type: text/plain
Organization: PetaLogix
Date: Tue, 06 May 2008 10:14:59 +1000
Message-Id: <1210032899.5798.179.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Does the DMA API insist upon the dma_cache_sync call to guarantee
> > sensible results?  If so, your implementation looks fine.  If not,
> then
> > the results will clearly be bogus as there's nothing magical about the
> > memory being allocated in dma_alloc.
> 
> Yes, in fact this is one of the keys to getting the lltemac driver to
> work right.  see Documentation/DMA-API.txt
> 
> > To that end, can it just call kmalloc(), and similarly kfree() for
> > dma_free?
> 
> My understanding is that on other architectures (x86, for instance)
> 'dma' memory ensures other things, like it's accessible in PCI memory
> space.  On microblaze, there's nothing really special about dma memory,
> but you get the API as a chunk.

Sure - what I meant is can dma_alloc just call kmalloc to do it's work?
 
> > I'd still like to see the uncached shadow stuff make a return one day,
> > it is an effective way of solving the problem, we'll just need to find
> a
> > cleaner way to implement it.  A linear walk through the cache to
> > invalidate is so slow, it destroys any benefit gained from DMA in the
> > first place.
> 
> I think it's definitely a simple way of solving the problem (in fact,
> the version of the code that's currently at git.xilinx.com includes it).
> Would it be better dealt with at the page level, rather than at the
> address level, then one of the architecture-reserved flags could be used
> for it?
> If it really does have value, then I want to make sure it goes in, along
> with bits in EDK that make it straightforward to use.  For me, the
> biggest barrier to using it is understanding exactly what assumptions it
> is making on the hardware, and making those assumptions bulletproof.

I agree.  Michal did some work on that when he did the initial DTS stuff
with us over the (southern) summer this year.  We looked at ways to
validate the HW design and Kconfig params to make sure that
uncached_shadow worked as expected.

If forget now the outcome, there's plenty of ways to get it wrong.

It would be easy at runtime to do some validation tests - write to a
pointer, cache flush (noop..), read back from the twiddled pointer, make
sure it matches.  Repeat a few times until you're happy it wasn't a
fluke, that sort of thing.

John

> 
> Steve
> 
> 
-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663



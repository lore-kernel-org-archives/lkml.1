Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbZAKSoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbZAKSoe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZAKSoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:44:23 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:44073 "EHLO mail.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751816AbZAKSoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:44:22 -0500
Date: Sun, 11 Jan 2009 18:44:02 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       linux-arch@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com
Subject: Re: [PATCH] dmatest: flush and invalidate destination buffer
	before DMA
Message-ID: <20090111184402.GA3810@linux-mips.org>
References: <20081227111037.3bd13adc@hskinnemoen-d830> <20081229.025352.01917409.anemo@mba.ocn.ne.jp> <e9c3a7c20901051031y528d0d31r18d44c5096c59e0@mail.gmail.com> <20090108.134336.127659765.nemoto@toshiba-tops.co.jp> <20090108093603.691c1200@hskinnemoen-d830> <20090109111936.GB17948@linux-mips.org> <20090109222721.GA3618@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109222721.GA3618@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 10:27:21PM +0000, Russell King wrote:

> On Fri, Jan 09, 2009 at 11:19:36AM +0000, Ralf Baechle wrote:
> > On Thu, Jan 08, 2009 at 09:36:03AM +0100, Haavard Skinnemoen wrote:
> > > In the general case, however, I think MIPS has a bug: I've seen drivers
> > > DMA to/from tiny buffers stored inside another struct. This is legal
> > > because the driver can guarantee that the other fields in the struct
> > > aren't accessed in the mean time, but any fields sharing a cacheline
> > > with the buffer must be written back before the lines are invalidated.
> > 
> > Depending on the implementation details, the use of such a struct might be
> > relying on implementation-specific behaviour.  This is what
> > Documentation/DMA-API.txt has to say:
> > 
> > [...]
> > int
> > dma_get_cache_alignment(void)
> > 
> > Returns the processor cache alignment.  This is the absolute minimum
> > alignment *and* width that you must observe when either mapping
> > memory or doing partial flushes.
> > 
> > Notes: This API may return a number *larger* than the actual cache
> > line, but it will guarantee that one or more cache lines fit exactly
> > into the width returned by this call.  It will also always be a power
> > of two for easy alignment.
> > [...]
> > 
> > Since dma_get_cache_alignment() is a function not a constant its result
> > can't be used in the definition of a struct unless possibly excessive
> > padding is used.
> > 
> > The debate has shown that we problably need BUG_ON() assertions in the
> > DMA API implementations to catch this sort of dangerous use.
> 
> I really don't think that's a realistic option.  You're asking for
> every call to the DMA API to ensure that the buffer and length are
> a multiple of the cache line size.
> 
> So, what happens if, eg, SPI wants to send a 16 byte buffer, and your
> cache lines are 64 bytes?  Does the SPI driver have to kmalloc a new
> chunk of memory 64 bytes long and copy the data into that before
> passing it into the DMA API?
> 
> If you start enforcing that kind of thing, I think the cache coherent
> people will take violent exception and refuse to play such games - and
> quite rightly so.

I only want to force people to be aware of what they're doing.  So far I've
seen cache lines of up to 256 bytes in size on non-coherent systems.  Be
paranoid, very paranoid ...

Below patch should solve Dan William's concerns.  It will peform a writeback
and invalidation operation on the first and last cacheline worth of data.
The instruction costs around a dozen cycles so I won't even try to optimize
possible double cache operations away; that'd probably be more expensive.

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 6e99665..56290a7 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -618,8 +618,11 @@ static void r4k_dma_cache_inv(unsigned long addr, unsigned long size)
 	if (cpu_has_inclusive_pcaches) {
 		if (size >= scache_size)
 			r4k_blast_scache();
-		else
+		else {
+			cache_op(Hit_Writeback_Inv_SD, addr);
+			cache_op(Hit_Writeback_Inv_SD, addr + size - 1);
 			blast_inv_scache_range(addr, addr + size);
+		}
 		return;
 	}
 
@@ -627,6 +630,8 @@ static void r4k_dma_cache_inv(unsigned long addr, unsigned long size)
 		r4k_blast_dcache();
 	} else {
 		R4600_HIT_CACHEOP_WAR_IMPL;
+		cache_op(Hit_Writeback_Inv_D, addr);
+		cache_op(Hit_Writeback_Inv_D, addr + size - 1);
 		blast_inv_dcache_range(addr, addr + size);
 	}
 

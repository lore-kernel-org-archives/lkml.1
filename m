Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZFDOiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZFDOiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZFDOiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:38:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41313 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZFDOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:38:15 -0400
Date: Thu, 4 Jun 2009 15:38:03 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Message-ID: <20090604143803.GD24491@flint.arm.linux.org.uk>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <200905282104.55818.arnd@arndb.de> <200906041235.34686.arnd@arndb.de> <20090604125119.GB24491@flint.arm.linux.org.uk> <200906041442.53170.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041442.53170.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 02:42:52PM +0100, Arnd Bergmann wrote:
> On Thursday 04 June 2009, Russell King wrote:
> > And here we go promoting dma-mask-is-not-a-mask-but-a-limit (which I
> > brought up in the KS thread on linux-arch.)
> > 
> > It's fine if your DMA-able memory starts at physical address 0 and ends
> > somewhere else, but this is no longer the case with embedded platforms.
> > As pointed out in the other thread, there are platforms which have two
> > separate banks of memory, the one at the lower physical address is not
> > DMA capable.
> 
> The dma-mapping-linear.h only cares about the platforms that have a
> linear contigous mapping between DMA and phys addresses. Other
> platforms will have to do something more fancy in their dma mapping
> implementation.

I'm not talking about anything fancy here.  There's still a 1:1
relationship between DMA and phys addresses.

> The device sets a mask (really a limit) of the address ranges it can
> handle. Basically every user in the kernel currently passes DMA_BIT_MASK()
> limit into {dma,pci}_set_mask,  and I am not aware of any driver
> that needs something more fancy. If you know one, please tell us.

Hmm, this opens yet another one of my bugbears.  The range of addressible
memory has doesn't really have much to do with drivers, yet in Linux we
_do_ tie it closely to the driver.

The range of addressible memory does have something to do with the device,
and we do carry that information in the driver.  However, there's another
element to it which is the hardware path from the device through to the
system memory.

There are cases on ARM (eg) where there's a restriction of 64MB.

There's also the case which I mentioned where we have two banks of memory,
and only the _second_ bank is DMA-capable.  Currently, in Linux, the only
way to use such a setup is basically to say "sorry, Linux can't use the
first bank, sorry vendor, Linux sucks."

> The DMA-capable addresses of the platform are a completely different
> issue and these should not be confused. Some architecture solve this
> by bus-specific mapping operations, which sounds like what you would
> need here as well. The bus is the only instance in the system that knows
> how the device-visible DMA space maps into the physical memory space,
> and it needs to be the instance checking the mask.

Yes, and then you end up triggering the OOM killer (see open unresolved
bug in the kernel bugzilla for IXP4xx)...

I hardly call that a solution.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

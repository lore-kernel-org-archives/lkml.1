Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbXGXWIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbXGXWIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbXGXWHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:07:55 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:37005 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbXGXWHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:07:54 -0400
Date: Tue, 24 Jul 2007 23:07:38 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2.6.23-rc1] dma_free_coherent() needs irqs enabled (sigh)
Message-ID: <20070724220738.GD22165@flint.arm.linux.org.uk>
References: <200707241429.05615.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707241429.05615.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 02:29:05PM -0700, David Brownell wrote:
> On at least ARM (and I'm told MIPS too) dma_free_coherent() has a newish
> call context requirement:  unlike its dma_alloc_coherent() sibling, it
> may not be called with IRQs disabled.  (This was new behavior on ARM as
> of late 2006, caused by ARM SMP updates.)

I think you got the year wrong:

5edf71ae (Russell King      2005-11-25 15:52:51 +0000 364)      WARN_ON(irqs_disabled());

which is due to this commit:

[ARM] Do not call flush_tlb_kernel_range() with IRQs disabled.

We must not call TLB maintainence operations with interrupts disabled,
otherwise we risk a lockup in the SMP IPI code.

This means that consistent_free() can not be called from a context with
IRQs disabled.  In addition, we must not hold the lock in consistent_free
when we call flush_tlb_kernel_range().  However, we must continue to
prevent consistent_alloc() from re-using the memory region until we've
finished tearing down the mapping and dealing with the TLB.

Therefore, leave the vm_region entry in the list, but mark it inactive
before dropping the lock and starting the tear-down process.  After the
mapping has been torn down, re-acquire the lock and remove the entry
from the list.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

> Since it looks like that restriction won't be removed, this patch changes
> the definition of the API to include that requirement.

The PCI DMA-mapping API had this restriction.  For some reason, this
restriction was not carried forward into the DMA-API.  Unfortunately
the restriction can not be removed without causing the problems
described in the commit which introduced it.

Or alternatively we scrap ARM SMP entirely, which isn't going to happen.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

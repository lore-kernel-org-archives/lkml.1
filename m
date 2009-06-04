Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbZFDOt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbZFDOt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZFDOtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:49:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43895 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZFDOtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:49:18 -0400
Date: Thu, 4 Jun 2009 15:49:09 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Message-ID: <20090604144909.GE24491@flint.arm.linux.org.uk>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <200905282104.55818.arnd@arndb.de> <200906041235.34686.arnd@arndb.de> <20090604125119.GB24491@flint.arm.linux.org.uk> <200906041442.53170.arnd@arndb.de> <20090604143803.GD24491@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604143803.GD24491@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 03:38:03PM +0100, Russell King wrote:
> On Thu, Jun 04, 2009 at 02:42:52PM +0100, Arnd Bergmann wrote:
> > The device sets a mask (really a limit) of the address ranges it can
> > handle. Basically every user in the kernel currently passes DMA_BIT_MASK()
> > limit into {dma,pci}_set_mask,  and I am not aware of any driver
> > that needs something more fancy. If you know one, please tell us.

BTW, I don't think you really got my point about DMA mask being a mask
or being a limit.

The following assumption has been made by the kernel:

	maximum_physical_address = dma_mask

Yes, that's _physical_ address, not bus specific DMA address:

void blk_queue_bounce_limit(struct request_queue *q, u64 dma_mask)
{
        unsigned long b_pfn = dma_mask >> PAGE_SHIFT;
...
        q->bounce_pfn = b_pfn;
}

static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
                                             struct bio *bio)
{
...
                        high = page_to_pfn(bv->bv_page) > q->bounce_pfn;
}

It's not "is this page DMA-able according to the DMA mask" it's effectively
"is this page's physical address greater than the maximum physical address
that can be DMA'd from".

As I've already pointed out, there are ARM platforms where this is just
a total nonsense.

As I say, what is the DMA mask?  Is it really a limit?  Is it really
supposed to be a mask?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

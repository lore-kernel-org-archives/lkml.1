Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZFAKO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZFAKO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbZFAKOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:14:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43769 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbZFAKOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:14:14 -0400
Date: Mon, 1 Jun 2009 11:14:05 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Message-ID: <20090601101405.GA19806@flint.arm.linux.org.uk>
Mail-Followup-To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	arnd@arndb.de, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <20090601082943.GA5550@flint.arm.linux.org.uk> <20090601181723U.fujita.tomonori@lab.ntt.co.jp> <20090601092259.GB5550@flint.arm.linux.org.uk> <20090601183323V.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601183323V.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 06:32:44PM +0900, FUJITA Tomonori wrote:
> Can ARM replace the dmabounce with swiotlb?

We could, if there was some effort with swiotlb to make it safe on
non-cache coherent architectures.  As it stands, it sources its
memory from __get_free_pages() which is non-coherent on ARM.

There's nothing wrong with that per-se, provided we use the streaming
DMA mapping API on those pages and obey the buffer ownership rules.


Also, it needs cache flushing - one thing davem said to me a while
back is that the effects of DMA should be the same as far as the
cache is concerned no matter how it is performed.

In other words, from the external perspective:

	dma_map_single()
	hardware DMA happens
	dma_unmap_single()

should result in exactly the same situation on an architecture as
far as the buffer is concerned no matter what the underlying
implementation is.

So, on a non-DMA coherent cache architecture, when DMA is normally
performed the data ends up in RAM with the cache flushed for that
region.  If, instead dma_map_single uses a bounce buffer to do that
DMA, then the same needs to be true of the original buffer - the
data needs to be in RAM with the cache flushed.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

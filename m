Return-Path: <linux-kernel-owner+w=401wt.eu-S1765310AbZLQSIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765310AbZLQSIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765300AbZLQSIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:08:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60679 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765298AbZLQSIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:08:36 -0500
Date: Thu, 17 Dec 2009 18:08:03 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, tytso@mit.edu,
       Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James.Bottomley@suse.de, linux-arch@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
Message-ID: <20091217180802.GA1546@flint.arm.linux.org.uk>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>, tytso@mit.edu,
	Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	James.Bottomley@suse.de, linux-arch@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>
References: <20091216043618.GB9104@hera.kernel.org> <20091217132256.GO28962@bombadil.infradead.org> <alpine.LFD.2.00.0912170811130.15740@localhost.localdomain> <20091217163036.GE2123@thunk.org> <alpine.LFD.2.00.0912170839550.15740@localhost.localdomain> <20091217170743.GA10431@infradead.org> <alpine.LFD.2.00.0912170928310.15740@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912170928310.15740@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 09:42:15AM -0800, Linus Torvalds wrote:
> You both flush the virtual caches before 
> the IO and invalidate after - when the real pattern should be that you 
> flush it before a write, and invalidate it after a read.

That's not entirely true.  If you have write back caches which are not DMA
coherent, you need to as a minimum:

- on write, clean the cache to ensure that the page is up to date with data
  held in cache.

- on read, you must ensure that there are no potential write-backs before
  the read commenses and invalidate at some point.

The point at which you invalidate depends on whether the CPU speculatively
prefetches:

- If it doesn't, you can invalidate the cache before the read, thereby
  destroying any potential writebacks, and the cache will remain
  unallocated for that address range until explicitly accessed.

- If you do have a CPU which does prefetch speculatively, then you do
  need to clean the cache before DMA starts, and then you must invalidate
  after the DMA completes.

Invalidating after DMA completes for the non-speculative prefetch just
wastes performance, especially if you have to do so line by line over
a region.

With ARM architecture version 7, we now have ARM CPUs which fall into
both categories.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbZHGJo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbZHGJo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbZHGJo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:44:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38643 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZHGJo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:44:26 -0400
Date: Fri, 7 Aug 2009 10:44:04 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: JiSheng Zhang <jszhang3@gmail.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: [UBI UBIFS] replace vmalloc with kmalloc
Message-ID: <20090807094404.GA10603@flint.arm.linux.org.uk>
References: <2df346410908070202i6c16008ckc145559a474129c6@mail.gmail.com> <4A7BF1C3.4050602@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7BF1C3.4050602@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 12:20:03PM +0300, Adrian Hunter wrote:
> vmalloc allows large (> 128KiB) buffers, but kmalloc doesn't.
> So we presently have no choice but to use vmalloc.
>
> I do not know what hardware you have or exactly what driver you
> are using, but we have UBIFS on OneNAND using DMA.
> See drivers/mtd/onenand/omap2.c

Hmm.  Looking at that code, it's unsafe:

        if (buf >= high_memory) {
                struct page *p1;

                if (((size_t)buf & PAGE_MASK) !=
                    ((size_t)(buf + count - 1) & PAGE_MASK))
                        goto out_copy;
                p1 = vmalloc_to_page(buf);
                if (!p1)
                        goto out_copy;
                buf = page_address(p1) + ((size_t)buf & ~PAGE_MASK);
        }
...
        dma_dst = dma_map_single(&c->pdev->dev, buf, count, DMA_FROM_DEVICE);

If you consider a VIVT cache, and with vmalloc'd pages you're passing
a *different* virtual address to the DMA functions, it's not going to
touch the cachelines associated with the vmalloc mapping.

The above *may* work for VIPT caches provided both the vmalloc and
kernel direct mappings are of the same colour.  If not, this really
isn't going to be reliable for the same reason.

Basically, what's going in there is *totally* unsafe.  I hope you
don't place important data on this NAND device.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

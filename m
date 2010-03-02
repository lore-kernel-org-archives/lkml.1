Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab0CBDdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 22:33:55 -0500
Received: from sh.osrg.net ([192.16.179.4]:58853 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab0CBDdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 22:33:53 -0500
Date: Tue, 2 Mar 2010 12:33:42 +0900
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201003011229.51399.arnd@arndb.de>
References: <20100226.043536.63730567.davem@davemloft.net>
	<20100301150532R.fujita.tomonori@lab.ntt.co.jp>
	<201003011229.51399.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100302123326H.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 02 Mar 2010 12:33:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Mar 2010 12:29:51 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 01 March 2010, FUJITA Tomonori wrote:
> > On Fri, 26 Feb 2010 04:35:36 -0800 (PST)
> > David Miller <davem@davemloft.net> wrote:
> >
> > You are referring to the following code (I guess that this hack came
> > from x86)?
> > 
> > #if __BITS_PER_LONG == 64
> > #define sg_dma_len(sg)          ((sg)->dma_length)
> > #else
> > #define sg_dma_len(sg)          ((sg)->length)
> > #endif /* 64 bit */
> > 
> > if so, seems that you are right. we could simply have:
> > 
> > #define sg_dma_len(sg)          ((sg)->dma_length)
> 
> I did it the above way so it would work for any architecture that
> wants it. IIRC, similar constructs were used in multiple architectures
> before, using the __BITS_PER_LONG macro made this portable.

Yeah, but the following assumption are not true for sparc, parisc, and
even x86_32 so this ccp trick is not so useful:

/*
 * Normally, you have an iommu on 64 bit machines, but not on 32 bit
 * machines. Architectures that are differnt should override this.
*/

> > The current users of asm-generic/scatterlist.h are microblaze, s390,
> > score, sh, and x86.
> > 
> > The first three users don't support DMA so sg_dma_len doesn't matter
> > for them.
> > 
> > sh and x86_32 use sg->length, x86_64 uses sg->dma_length. However, sh
> > and x86_32 sets dma_length in dma_map_sg() so they can use
> > sg->dma_length.
> > 
> > I'll clean up this in the next merge window.
> 
> Ok, great. I think a good way to clean this up would be to convert
> all architectures to use asm-generic/scatterlist.h first, and then
> move it to linux/scatterlist once it is architecture intedepent.

If we go with such approach, then we could use something like the
following. There are only two kinds of scatterlist definitions (use
dma_length or not) so we can cover all the architectures.

diff --git a/include/asm-generic/scatterlist.h b/include/asm-generic/scatterlist.h
index 8b94544..1bf620d 100644
--- a/include/asm-generic/scatterlist.h
+++ b/include/asm-generic/scatterlist.h
@@ -11,7 +11,9 @@ struct scatterlist {
 	unsigned int	offset;
 	unsigned int	length;
 	dma_addr_t	dma_address;
+#ifdef CONFIG_NEED_SG_DMA_LENGTH
 	unsigned int	dma_length;
+#endif
 };
 
 /*
@@ -22,17 +24,11 @@ struct scatterlist {
  * is 0.
  */
 #define sg_dma_address(sg)	((sg)->dma_address)
-#ifndef sg_dma_len
-/*
- * Normally, you have an iommu on 64 bit machines, but not on 32 bit
- * machines. Architectures that are differnt should override this.
- */
-#if __BITS_PER_LONG == 64
+#ifdef CONFIG_NEED_SG_DMA_LENGTH
 #define sg_dma_len(sg)		((sg)->dma_length)
 #else
 #define sg_dma_len(sg)		((sg)->length)
-#endif /* 64 bit */
-#endif /* sg_dma_len */
+#endif
 
 #ifndef ISA_DMA_THRESHOLD
 #define ISA_DMA_THRESHOLD	(~0UL)

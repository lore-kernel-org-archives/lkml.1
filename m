Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZKHSta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZKHSta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 13:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbZKHSta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 13:49:30 -0500
Received: from khc.piap.pl ([195.187.100.11]:49743 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbZKHSt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 13:49:29 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: IXP4xx repetitive 16-bit/32-bit I/O macros/inlines.
Date: Sun, 08 Nov 2009 19:49:33 +0100
Message-ID: <m3iqdkc0n6.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anybody using 32-bit PATA/SATA transfers on IXP4xx? :-)

Long story, mostly with PCI in mind:
- readb/readw/readl, writeb/writew/writel macros are value-preserving
- __raw_* are order-preserving (i.e., strings are preserved)
but the repetitive versions (outs[wl], ins[wl], ioread*_rep,
iowrite*_rep) are supposed to preserve order as well (while lacking the
__raw_ prefix).

Comments?

Is it worth it to change the names to __raw_*, or maybe to some other
variant like native_*, to avoid confusion? It's really confusing.
There aren't many users in the tree (I'd also change readl() and friends
to something like read_le32, but it would be massive, comments welcome).

Or perhaps we should have *_le32, *_be32, _order32? It should be
something the compiler can optimize out if used with le32_to_cpu etc.


--- a/arch/arm/mach-ixp4xx/include/mach/io.h
+++ b/arch/arm/mach-ixp4xx/include/mach/io.h
@@ -311,7 +311,7 @@ static inline void
 __ixp4xx_outsl(u32 io_addr, const u32 *vaddr, u32 count)
 {
 	while (count--)
-		outl(*vaddr++, io_addr);
+		outl(cpu_to_le32(*vaddr++), io_addr);
 }
 
 static inline u8 
@@ -366,7 +366,7 @@ static inline void
 __ixp4xx_insl(u32 io_addr, u32 *vaddr, u32 count)
 {
 	while (count--)
-		*vaddr++ = inl(io_addr);
+		*vaddr++ = le32_to_cpu(inl(io_addr));
 }
 
 #define PIO_OFFSET      0x10000UL
-- 
Krzysztof Halasa

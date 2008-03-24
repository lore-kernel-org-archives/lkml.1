Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYCXUuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYCXUuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYCXUuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:50:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbYCXUuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:50:06 -0400
Date: Mon, 24 Mar 2008 13:47:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Meyer <thomas@m3y3r.de>
cc: Ingo Molnar <mingo@elte.hu>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
In-Reply-To: <47E80C64.7020907@m3y3r.de>
Message-ID: <alpine.LFD.1.00.0803241343350.2775@woody.linux-foundation.org>
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
 <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E59B39.90306@s5r6.in-berlin.de> <20080323063524.GA13018@elte.hu> <47E80247.8090702@m3y3r.de> <20080324194706.GA1391@elte.hu> <47E80C64.7020907@m3y3r.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 24 Mar 2008, Thomas Meyer wrote:
> Ingo Molnar schrieb:
> > 
> > the bootlog should have such entries:
> > 
> >   ioremap: 0x12340000(0x00001000) => 0x12340000
> > 
> > near the ohci1394 initialization messages.
>
> Second try. See attached file.

Hmm. This isn't with my suggested patch, is it?

You are still losing the high 32 bits, and we see:

	[  162.485695] ioremap: 00000000(00000800) => f8978000
		<3>ohci1394: fw-host0: Get PHY Reg timeout [0x00008400/0x00000000/100]

because it's trying to ioremap the resource that is at 0x100000000, and it 
gets truncated to 0x00000000.

I already committed my patch as "obviously correct", so if you're a git 
user, you can just update to current git, but here it is again if you 
missed it and aren't a git person.

		Linus

---
commit b9e76a00749521f2b080fa8a4fb15f66538ab756
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Mar 24 11:22:39 2008 -0700

    x86-32: Pass the full resource data to ioremap()
    
    It appears that 64-bit PCI resources cannot possibly ever have worked on
    x86-32 even when the RESOURCES_64BIT config option was set, because any
    driver that tried to [pci_]ioremap() the resource would have been unable
    to do so because the high 32 bits would have been silently dropped on
    the floor by the ioremap() routines that only used "unsigned long".
    
    Change them to use "resource_size_t" instead, which properly encodes the
    whole 64-bit resource data if RESOURCES_64BIT is enabled.
    
    Acked-by: H. Peter Anvin <hpa@kernel.org>
    Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/mm/ioremap.c   |    6 +++---
 include/asm-x86/io_32.h |    6 +++---
 include/asm-x86/io_64.h |    6 +++---
 lib/iomap.c             |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 8fe576b..4afaba0 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -106,7 +106,7 @@ static int ioremap_change_attr(unsigned long vaddr, unsigned long size,
  * have to convert them into an offset in a page-aligned mapping, but the
  * caller shouldn't need to know that small detail.
  */
-static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
+static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
 			       enum ioremap_mode mode)
 {
 	unsigned long pfn, offset, last_addr, vaddr;
@@ -193,13 +193,13 @@ static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
  *
  * Must be freed with iounmap.
  */
-void __iomem *ioremap_nocache(unsigned long phys_addr, unsigned long size)
+void __iomem *ioremap_nocache(resource_size_t phys_addr, unsigned long size)
 {
 	return __ioremap(phys_addr, size, IOR_MODE_UNCACHED);
 }
 EXPORT_SYMBOL(ioremap_nocache);
 
-void __iomem *ioremap_cache(unsigned long phys_addr, unsigned long size)
+void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
 {
 	return __ioremap(phys_addr, size, IOR_MODE_CACHED);
 }
diff --git a/include/asm-x86/io_32.h b/include/asm-x86/io_32.h
index 58d2c45..d4d8fbd 100644
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -114,13 +114,13 @@ static inline void * phys_to_virt(unsigned long address)
  * If the area you are trying to map is a PCI BAR you should have a
  * look at pci_iomap().
  */
-extern void __iomem *ioremap_nocache(unsigned long offset, unsigned long size);
-extern void __iomem *ioremap_cache(unsigned long offset, unsigned long size);
+extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
+extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
 
 /*
  * The default ioremap() behavior is non-cached:
  */
-static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
+static inline void __iomem *ioremap(resource_size_t offset, unsigned long size)
 {
 	return ioremap_nocache(offset, size);
 }
diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index f64a59c..db0be20 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -158,13 +158,13 @@ extern void early_iounmap(void *addr, unsigned long size);
  * it's useful if some control registers are in such an area and write combining
  * or read caching is not desirable:
  */
-extern void __iomem *ioremap_nocache(unsigned long offset, unsigned long size);
-extern void __iomem *ioremap_cache(unsigned long offset, unsigned long size);
+extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
+extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
 
 /*
  * The default ioremap() behavior is non-cached:
  */
-static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
+static inline void __iomem *ioremap(resource_size_t offset, unsigned long size)
 {
 	return ioremap_nocache(offset, size);
 }
diff --git a/lib/iomap.c b/lib/iomap.c
index db004a9..dd6ca48 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -256,7 +256,7 @@ EXPORT_SYMBOL(ioport_unmap);
  * */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
 	unsigned long len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 

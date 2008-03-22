Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbYCVXCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbYCVXCV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 19:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYCVXCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 19:02:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbYCVXCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 19:02:12 -0400
Date: Sat, 22 Mar 2008 16:01:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
cc: Thomas Meyer <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
In-Reply-To: <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org>
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Mar 2008, Linus Torvalds wrote:
> 
> AND no, I don't think our x86-32 ioremap() actually works for this case, 
> because while the resource data may have the full 64 bits, when the 
> ioremap() happens it gets truncated to 32 bits.

Does this patch make any difference?

(ENTIRELY untested, I checked that it compiles on x86-64, but didn't even 
test a 32-bit build, I'm hoping whoever sees this issue can also fix up 
the inevitable small missed pieces)

		Linus

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
 

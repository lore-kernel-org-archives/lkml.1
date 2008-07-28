Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbYG1RkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbYG1RkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759606AbYG1RjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:39:13 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:49428 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759528AbYG1RjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:39:11 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, eric@anholt.net,
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/3] Rewrite PCI BAR reading code
Date: Mon, 28 Jul 2008 13:38:59 -0400
Message-Id: <1217266741-26519-2-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1217266741-26519-1-git-send-email-matthew@wil.cx>
References: <1217266741-26519-1-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the code to read one BAR from the loop in pci_read_bases into
a new function, __pci_read_base.  The new code is slightly more
readable, better commented and removes the ifdef.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/pci/probe.c |  242 ++++++++++++++++++++++++++-------------------------
 1 files changed, 123 insertions(+), 119 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b1724cf..3b690c3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -163,12 +163,9 @@ static inline unsigned int pci_calc_resource_flags(unsigned int flags)
 	return IORESOURCE_MEM;
 }
 
-/*
- * Find the extent of a PCI decode..
- */
-static u32 pci_size(u32 base, u32 maxbase, u32 mask)
+static u64 pci_size(u64 base, u64 maxbase, u64 mask)
 {
-	u32 size = mask & maxbase;	/* Find the significant bits */
+	u64 size = mask & maxbase;	/* Find the significant bits */
 	if (!size)
 		return 0;
 
@@ -184,135 +181,142 @@ static u32 pci_size(u32 base, u32 maxbase, u32 mask)
 	return size;
 }
 
-static u64 pci_size64(u64 base, u64 maxbase, u64 mask)
-{
-	u64 size = mask & maxbase;	/* Find the significant bits */
-	if (!size)
-		return 0;
+enum pci_bar_type {
+	pci_bar_unknown,	/* Standard PCI BAR probe */
+	pci_bar_io,		/* An io port BAR */
+	pci_bar_mem32,		/* A 32-bit memory BAR */
+	pci_bar_mem64,		/* A 64-bit memory BAR */
+};
 
-	/* Get the lowest of them to find the decode size, and
-	   from that the extent.  */
-	size = (size & ~(size-1)) - 1;
+static inline enum pci_bar_type decode_bar(struct resource *res, u32 bar)
+{
+	if ((bar & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
+		res->flags = bar & ~PCI_BASE_ADDRESS_IO_MASK;
+		return pci_bar_io;
+	}
 
-	/* base == maxbase can be valid only if the BAR has
-	   already been programmed with all 1s.  */
-	if (base == maxbase && ((base | size) & mask) != mask)
-		return 0;
+	res->flags = bar & ~PCI_BASE_ADDRESS_MEM_MASK;
 
-	return size;
+	if (res->flags == PCI_BASE_ADDRESS_MEM_TYPE_64)
+		return pci_bar_mem64;
+	return pci_bar_mem32;
 }
 
-static inline int is_64bit_memory(u32 mask)
+/*
+ * If the type is not unknown, we assume that the lowest bit is 'enable'.
+ * Returns 1 if the BAR was 64-bit and 0 if it was 32-bit.
+ */
+static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
+			struct resource *res, unsigned int pos)
 {
-	if ((mask & (PCI_BASE_ADDRESS_SPACE|PCI_BASE_ADDRESS_MEM_TYPE_MASK)) ==
-	    (PCI_BASE_ADDRESS_SPACE_MEMORY|PCI_BASE_ADDRESS_MEM_TYPE_64))
-		return 1;
-	return 0;
-}
+	u32 l, sz, mask;
 
-static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
-{
-	unsigned int pos, reg, next;
-	u32 l, sz;
-	struct resource *res;
+	mask = type ? ~PCI_ROM_ADDRESS_ENABLE : ~0;
 
-	for(pos=0; pos<howmany; pos = next) {
-		u64 l64;
-		u64 sz64;
-		u32 raw_sz;
+	res->name = pci_name(dev);
 
-		next = pos+1;
-		res = &dev->resource[pos];
-		res->name = pci_name(dev);
-		reg = PCI_BASE_ADDRESS_0 + (pos << 2);
-		pci_read_config_dword(dev, reg, &l);
-		pci_write_config_dword(dev, reg, ~0);
-		pci_read_config_dword(dev, reg, &sz);
-		pci_write_config_dword(dev, reg, l);
-		if (!sz || sz == 0xffffffff)
-			continue;
-		if (l == 0xffffffff)
-			l = 0;
-		raw_sz = sz;
-		if ((l & PCI_BASE_ADDRESS_SPACE) ==
-				PCI_BASE_ADDRESS_SPACE_MEMORY) {
-			sz = pci_size(l, sz, (u32)PCI_BASE_ADDRESS_MEM_MASK);
-			/*
-			 * For 64bit prefetchable memory sz could be 0, if the
-			 * real size is bigger than 4G, so we need to check
-			 * szhi for that.
-			 */
-			if (!is_64bit_memory(l) && !sz)
-				continue;
-			res->start = l & PCI_BASE_ADDRESS_MEM_MASK;
-			res->flags |= l & ~PCI_BASE_ADDRESS_MEM_MASK;
+	pci_read_config_dword(dev, pos, &l);
+	pci_write_config_dword(dev, pos, mask);
+	pci_read_config_dword(dev, pos, &sz);
+	pci_write_config_dword(dev, pos, l);
+
+	/*
+	 * All bits set in sz means the device isn't working properly.
+	 * If the BAR isn't implemented, all bits must be 0.  If it's a
+	 * memory BAR or a ROM, bit 0 must be clear; if it's an io BAR, bit
+	 * 1 must be clear.
+	 */
+	if (!sz || sz == 0xffffffff)
+		goto fail;
+
+	/*
+	 * I don't know how l can have all bits set.  Copied from old code.
+	 * Maybe it fixes a bug on some ancient platform.
+	 */
+	if (l == 0xffffffff)
+		l = 0;
+
+	if (type == pci_bar_unknown) {
+		type = decode_bar(res, l);
+		res->flags |= pci_calc_resource_flags(l) | IORESOURCE_SIZEALIGN;
+		if (type == pci_bar_io) {
+			l &= PCI_BASE_ADDRESS_IO_MASK;
+			mask = PCI_BASE_ADDRESS_IO_MASK & 0xffff;
 		} else {
-			sz = pci_size(l, sz, PCI_BASE_ADDRESS_IO_MASK & 0xffff);
-			if (!sz)
-				continue;
-			res->start = l & PCI_BASE_ADDRESS_IO_MASK;
-			res->flags |= l & ~PCI_BASE_ADDRESS_IO_MASK;
+			l &= PCI_BASE_ADDRESS_MEM_MASK;
+			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
 		}
-		res->end = res->start + (unsigned long) sz;
-		res->flags |= pci_calc_resource_flags(l) | IORESOURCE_SIZEALIGN;
-		if (is_64bit_memory(l)) {
-			u32 szhi, lhi;
-
-			pci_read_config_dword(dev, reg+4, &lhi);
-			pci_write_config_dword(dev, reg+4, ~0);
-			pci_read_config_dword(dev, reg+4, &szhi);
-			pci_write_config_dword(dev, reg+4, lhi);
-			sz64 = ((u64)szhi << 32) | raw_sz;
-			l64 = ((u64)lhi << 32) | l;
-			sz64 = pci_size64(l64, sz64, PCI_BASE_ADDRESS_MEM_MASK);
-			next++;
-#if BITS_PER_LONG == 64
-			if (!sz64) {
-				res->start = 0;
-				res->end = 0;
-				res->flags = 0;
-				continue;
-			}
-			res->start = l64 & PCI_BASE_ADDRESS_MEM_MASK;
-			res->end = res->start + sz64;
-#else
-			if (sz64 > 0x100000000ULL) {
-				dev_err(&dev->dev, "BAR %d: can't handle 64-bit"
-					" BAR\n", pos);
-				res->start = 0;
-				res->flags = 0;
-			} else if (lhi) {
-				/* 64-bit wide address, treat as disabled */
-				pci_write_config_dword(dev, reg,
-					l & ~(u32)PCI_BASE_ADDRESS_MEM_MASK);
-				pci_write_config_dword(dev, reg+4, 0);
-				res->start = 0;
-				res->end = sz;
-			}
-#endif
+	} else {
+		res->flags |= (l & IORESOURCE_ROM_ENABLE);
+		l &= PCI_ROM_ADDRESS_MASK;
+		mask = (u32)PCI_ROM_ADDRESS_MASK;
+	}
+
+	if (type == pci_bar_mem64) {
+		u64 l64 = l;
+		u64 sz64 = sz;
+		u64 mask64 = mask | (u64)~0 << 32;
+
+		pci_read_config_dword(dev, pos + 4, &l);
+		pci_write_config_dword(dev, pos + 4, ~0);
+		pci_read_config_dword(dev, pos + 4, &sz);
+		pci_write_config_dword(dev, pos + 4, l);
+
+		l64 |= ((u64)l << 32);
+		sz64 |= ((u64)sz << 32);
+
+		sz64 = pci_size(l64, sz64, mask64);
+
+		if (!sz64)
+			goto fail;
+
+		if ((BITS_PER_LONG < 64) && (sz64 > 0x100000000ULL)) {
+			dev_err(&dev->dev, "can't handle 64-bit BAR\n");
+			goto fail;
+		} else if ((BITS_PER_LONG < 64) && l) {
+			/* Address above 32-bit boundary; disable the BAR */
+			pci_write_config_dword(dev, pos, 0);
+			pci_write_config_dword(dev, pos + 4, 0);
+			res->start = 0;
+			res->end = sz64;
+		} else {
+			res->start = l64;
+			res->end = l64 + sz64;
 		}
+	} else {
+		sz = pci_size(l, sz, mask);
+
+		if (!sz)
+			goto fail;
+
+		res->start = l;
+		res->end = l + sz;
 	}
+
+ out:
+	return (type == pci_bar_mem64) ? 1 : 0;
+ fail:
+	res->flags = 0;
+	goto out;
+}
+
+static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
+{
+	unsigned int pos, reg;
+
+	for (pos = 0; pos < howmany; pos++) {
+		struct resource *res = &dev->resource[pos];
+		reg = PCI_BASE_ADDRESS_0 + (pos << 2);
+		pos += __pci_read_base(dev, pci_bar_unknown, res, reg);
+	}
+
 	if (rom) {
+		struct resource *res = &dev->resource[PCI_ROM_RESOURCE];
 		dev->rom_base_reg = rom;
-		res = &dev->resource[PCI_ROM_RESOURCE];
-		res->name = pci_name(dev);
-		pci_read_config_dword(dev, rom, &l);
-		pci_write_config_dword(dev, rom, ~PCI_ROM_ADDRESS_ENABLE);
-		pci_read_config_dword(dev, rom, &sz);
-		pci_write_config_dword(dev, rom, l);
-		if (l == 0xffffffff)
-			l = 0;
-		if (sz && sz != 0xffffffff) {
-			sz = pci_size(l, sz, (u32)PCI_ROM_ADDRESS_MASK);
-			if (sz) {
-				res->flags = (l & IORESOURCE_ROM_ENABLE) |
-				  IORESOURCE_MEM | IORESOURCE_PREFETCH |
-				  IORESOURCE_READONLY | IORESOURCE_CACHEABLE |
-				  IORESOURCE_SIZEALIGN;
-				res->start = l & PCI_ROM_ADDRESS_MASK;
-				res->end = res->start + (unsigned long) sz;
-			}
-		}
+		res->flags = IORESOURCE_MEM | IORESOURCE_PREFETCH |
+				IORESOURCE_READONLY | IORESOURCE_CACHEABLE |
+				IORESOURCE_SIZEALIGN;
+		__pci_read_base(dev, pci_bar_mem32, res, rom);
 	}
 }
 
-- 
1.5.5.4


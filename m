Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbZCWN5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbZCWN5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZCWN5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:57:43 -0400
Received: from mx1.emlix.com ([193.175.82.87]:46538 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbZCWN5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:57:43 -0400
From: Oskar Schirmer <os@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
       Oskar Schirmer <os@emlix.com>
Subject: [patch 1/2] xtensa: cache inquiry and unaligned cache handling functions
Date: Mon, 23 Mar 2009 14:58:42 +0100
Message-Id: <1237816723-29041-1-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing xtensa cache handling functions work on page-aligned
memory regions.

These functions are needed for the s6000 dma engine which can work on
a byte-granularity.

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 arch/xtensa/include/asm/cacheflush.h |   95 ++++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/include/asm/cacheflush.h b/arch/xtensa/include/asm/cacheflush.h
index 8fc1c0c..b7b8fbe 100644
--- a/arch/xtensa/include/asm/cacheflush.h
+++ b/arch/xtensa/include/asm/cacheflush.h
@@ -155,5 +155,100 @@ extern void copy_from_user_page(struct vm_area_struct*, struct page*,
 
 #endif
 
+#define XTENSA_CACHEBLK_LOG2	29
+#define XTENSA_CACHEBLK_SIZE	(1 << XTENSA_CACHEBLK_LOG2)
+#define XTENSA_CACHEBLK_MASK	(7 << XTENSA_CACHEBLK_LOG2)
+
+#if XCHAL_HAVE_CACHEATTR
+static inline u32 xtensa_get_cacheattr(void)
+{
+	u32 r;
+	asm volatile("	rsr %0, CACHEATTR" : "=a"(r));
+	return r;
+}
+
+static inline u32 xtensa_get_dtlb1(u32 addr)
+{
+	u32 r = addr & XTENSA_CACHEBLK_MASK;
+	return r | ((xtensa_get_cacheattr() >> (r >> (XTENSA_CACHEBLK_LOG2-2)))
+			& 0xF);
+}
+#else
+static inline u32 xtensa_get_dtlb1(u32 addr)
+{
+	u32 r;
+	asm volatile("	rdtlb1 %0, %1" : "=a"(r) : "a"(addr));
+	asm volatile("	dsync");
+	return r;
+}
+
+static inline u32 xtensa_get_cacheattr(void)
+{
+	u32 r = 0;
+	u32 a = 0;
+	do {
+		a -= XTENSA_CACHEBLK_SIZE;
+		r = (r << 4) | (xtensa_get_dtlb1(a) & 0xF);
+	} while (a);
+	return r;
+}
+#endif
+
+static inline int xtensa_need_flush_dma_source(u32 addr)
+{
+	return (xtensa_get_dtlb1(addr) & ((1 << XCHAL_CA_BITS) - 1)) >= 4;
+}
+
+static inline int xtensa_need_invalidate_dma_destination(u32 addr)
+{
+	return (xtensa_get_dtlb1(addr) & ((1 << XCHAL_CA_BITS) - 1)) != 2;
+}
+
+static inline void flush_dcache_unaligned(u32 addr, u32 size)
+{
+	u32 cnt;
+	if (size) {
+		cnt = (size + ((XCHAL_DCACHE_LINESIZE - 1) & addr)
+			+ XCHAL_DCACHE_LINESIZE - 1) / XCHAL_DCACHE_LINESIZE;
+		while (cnt--) {
+			asm volatile("	dhwb %0, 0" : : "a"(addr));
+			addr += XCHAL_DCACHE_LINESIZE;
+		}
+		asm volatile("	dsync");
+	}
+}
+
+static inline void invalidate_dcache_unaligned(u32 addr, u32 size)
+{
+	int cnt;
+	if (size) {
+		asm volatile("	dhwbi %0, 0 ;" : : "a"(addr));
+		cnt = (size + ((XCHAL_DCACHE_LINESIZE - 1) & addr)
+			- XCHAL_DCACHE_LINESIZE - 1) / XCHAL_DCACHE_LINESIZE;
+		while (cnt-- > 0) {
+			asm volatile("	dhi %0, %1" : : "a"(addr),
+						"n"(XCHAL_DCACHE_LINESIZE));
+			addr += XCHAL_DCACHE_LINESIZE;
+		}
+		asm volatile("	dhwbi %0, %1" : : "a"(addr),
+						"n"(XCHAL_DCACHE_LINESIZE));
+		asm volatile("	dsync");
+	}
+}
+
+static inline void flush_invalidate_dcache_unaligned(u32 addr, u32 size)
+{
+	u32 cnt;
+	if (size) {
+		cnt = (size + ((XCHAL_DCACHE_LINESIZE - 1) & addr)
+			+ XCHAL_DCACHE_LINESIZE - 1) / XCHAL_DCACHE_LINESIZE;
+		while (cnt--) {
+			asm volatile("	dhwbi %0, 0" : : "a"(addr));
+			addr += XCHAL_DCACHE_LINESIZE;
+		}
+		asm volatile("	dsync");
+	}
+}
+
 #endif /* __KERNEL__ */
 #endif /* _XTENSA_CACHEFLUSH_H */
-- 
1.6.2.107.ge47ee


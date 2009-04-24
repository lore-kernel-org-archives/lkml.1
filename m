Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbZDXBt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbZDXBt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 21:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbZDXBtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 21:49:18 -0400
Received: from [65.98.92.6] ([65.98.92.6]:2135 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbZDXBtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 21:49:18 -0400
Message-Id: <5d2b9b9e6bb054c2d09fa362a4570156ea8ceca1.1240533480.git@localhost>
In-Reply-To: <0483452db22e72f57289e63fcf097120d94c2a37.1240533480.git@localhost>
References: <0483452db22e72f57289e63fcf097120d94c2a37.1240533480.git@localhost>
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Thu, 23 Apr 2009 17:36:53 -0700
Subject: [PATCH 3/3] MIPS: Support 64-byte D-cache line size
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/include/asm/r4kcache.h |    1 +
 arch/mips/mm/c-r4k.c             |   12 ++++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/r4kcache.h b/arch/mips/include/asm/r4kcache.h
index 4c140db..387bf59 100644
--- a/arch/mips/include/asm/r4kcache.h
+++ b/arch/mips/include/asm/r4kcache.h
@@ -399,6 +399,7 @@ __BUILD_BLAST_CACHE(s, scache, Index_Writeback_Inv_SD, Hit_Writeback_Inv_SD, 16)
 __BUILD_BLAST_CACHE(d, dcache, Index_Writeback_Inv_D, Hit_Writeback_Inv_D, 32)
 __BUILD_BLAST_CACHE(i, icache, Index_Invalidate_I, Hit_Invalidate_I, 32)
 __BUILD_BLAST_CACHE(s, scache, Index_Writeback_Inv_SD, Hit_Writeback_Inv_SD, 32)
+__BUILD_BLAST_CACHE(d, dcache, Index_Writeback_Inv_D, Hit_Writeback_Inv_D, 64)
 __BUILD_BLAST_CACHE(i, icache, Index_Invalidate_I, Hit_Invalidate_I, 64)
 __BUILD_BLAST_CACHE(s, scache, Index_Writeback_Inv_SD, Hit_Writeback_Inv_SD, 64)
 __BUILD_BLAST_CACHE(s, scache, Index_Writeback_Inv_SD, Hit_Writeback_Inv_SD, 128)
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 171951d..71fe4cb 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -100,6 +100,12 @@ static inline void r4k_blast_dcache_page_dc32(unsigned long addr)
 	blast_dcache32_page(addr);
 }
 
+static inline void r4k_blast_dcache_page_dc64(unsigned long addr)
+{
+	R4600_HIT_CACHEOP_WAR_IMPL;
+	blast_dcache64_page(addr);
+}
+
 static void __cpuinit r4k_blast_dcache_page_setup(void)
 {
 	unsigned long  dc_lsize = cpu_dcache_line_size();
@@ -110,6 +116,8 @@ static void __cpuinit r4k_blast_dcache_page_setup(void)
 		r4k_blast_dcache_page = blast_dcache16_page;
 	else if (dc_lsize == 32)
 		r4k_blast_dcache_page = r4k_blast_dcache_page_dc32;
+	else if (dc_lsize == 64)
+		r4k_blast_dcache_page = r4k_blast_dcache_page_dc64;
 }
 
 static void (* r4k_blast_dcache_page_indexed)(unsigned long addr);
@@ -124,6 +132,8 @@ static void __cpuinit r4k_blast_dcache_page_indexed_setup(void)
 		r4k_blast_dcache_page_indexed = blast_dcache16_page_indexed;
 	else if (dc_lsize == 32)
 		r4k_blast_dcache_page_indexed = blast_dcache32_page_indexed;
+	else if (dc_lsize == 64)
+		r4k_blast_dcache_page_indexed = blast_dcache64_page_indexed;
 }
 
 static void (* r4k_blast_dcache)(void);
@@ -138,6 +148,8 @@ static void __cpuinit r4k_blast_dcache_setup(void)
 		r4k_blast_dcache = blast_dcache16;
 	else if (dc_lsize == 32)
 		r4k_blast_dcache = blast_dcache32;
+	else if (dc_lsize == 64)
+		r4k_blast_dcache = blast_dcache64;
 }
 
 /* force code alignment (used for TX49XX_ICACHE_INDEX_INV_WAR) */
-- 
1.5.3.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbZETS3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbZETS3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbZETSZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:27 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59094 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243AbZETSZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:22 -0400
Subject: [RFC v2][PATCH 23/35] factor x86 pte mapping code
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:21 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182521.8F55793E@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86 contains three separate pte_offset_map() implementations:
1. 32-bit highpte
2. 32-bit direct mapped
3. 64-bit direct mapped

This patch consolidates the 32-bit direct map and 64-bit
implementations.  You can look back at the 00 patch in this
series to see a bit of proof about why

#define pte_offset_map(dir, address)                                   \
	((pte_t *)page_address(pmd_page(*(dir))) + pte_index((address)))

and

#define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))

are actually interchangable.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/include/asm/ptemap.h |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -puN arch/x86/include/asm/ptemap.h~factor-x86 arch/x86/include/asm/ptemap.h
--- linux-2.6.git/arch/x86/include/asm/ptemap.h~factor-x86	2009-04-30 15:11:06.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/include/asm/ptemap.h	2009-04-30 15:11:06.000000000 -0700
@@ -1,10 +1,7 @@
 #ifndef _X86_ASM_PTEMAP_H
 #define _X86_ASM_PTEMAP_H
 
-#ifdef CONFIG_X86_32
-
 #if defined(CONFIG_HIGHPTE)
-
 #define pte_offset_map(dir, address)					\
 	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), KM_PTE0) +		\
 	 pte_index((address)))
@@ -13,21 +10,13 @@
 	 pte_index((address)))
 #define pte_unmap(pte) kunmap_atomic((pte), KM_PTE0)
 #define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
-#else
-#define pte_offset_map(dir, address)					\
-	((pte_t *)page_address(pmd_page(*(dir))) + pte_index((address)))
-#define pte_offset_map_nested(dir, address) pte_offset_map((dir), (address))
-#define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
-#endif
 
-#else /* x86-64 */
+#else /* !CONFIG_HIGHPTE */
 
-/* x86-64 always has all page tables mapped. */
 #define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
 #define pte_offset_map_nested(dir, address) pte_offset_kernel((dir), (address))
-#define pte_unmap(pte) /* NOP */
-#define pte_unmap_nested(pte) /* NOP */
+#define pte_unmap(pte) do { } while (0)
+#define pte_unmap_nested(pte) do { } while (0)
 
 #endif
 
_

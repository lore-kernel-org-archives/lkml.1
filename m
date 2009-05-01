Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbZEAO5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbZEAO5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763339AbZEAOnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:43:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37306 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761465AbZEAOmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:44 -0400
Subject: [RFC][PATCH 26/35] frv: use pte_offset_kernel() as base for pte_offset_map*()
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:41 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144241.11789BD9@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some architectures use pte_offset_map() as a basis for
pte_offset_kernel().  Others do the inverse.

Although arbitrary, Using pte_offset_kernel() as the base
seems a wee bit more popular and it also fits in well
with the way I'm breaking out the headers.

Instead of coding the same implementation twice, this
makes pte_offset_map{,_nested}() call pte_offset_kernel()
directly.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/frv/include/asm/highmem.h |    5 +++++
 linux-2.6.git-dave/arch/frv/include/asm/ptemap.h  |    5 ++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN arch/frv/include/asm/highmem.h~frv-pte_offset_kernel arch/frv/include/asm/highmem.h
--- linux-2.6.git/arch/frv/include/asm/highmem.h~frv-pte_offset_kernel	2009-04-30 15:11:08.000000000 -0700
+++ linux-2.6.git-dave/arch/frv/include/asm/highmem.h	2009-04-30 15:11:08.000000000 -0700
@@ -42,6 +42,11 @@ extern unsigned long highstart_pfn, high
 
 #define kmap_prot PAGE_KERNEL
 #define kmap_pte ______kmap_pte_in_TLB
+/*
+ * This lets us share the highpte pte_offset_map()
+ * with x86
+ */
+#define kmap_atomic_pte(page, type)     kmap_atomic(page, type)
 extern pte_t *pkmap_page_table;
 
 #define flush_cache_kmaps()  do { } while (0)
diff -puN arch/frv/include/asm/ptemap.h~frv-pte_offset_kernel arch/frv/include/asm/ptemap.h
--- linux-2.6.git/arch/frv/include/asm/ptemap.h~frv-pte_offset_kernel	2009-04-30 15:11:08.000000000 -0700
+++ linux-2.6.git-dave/arch/frv/include/asm/ptemap.h	2009-04-30 15:11:08.000000000 -0700
@@ -9,9 +9,8 @@
 #define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
 #define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
 #else
-#define pte_offset_map(dir, address) \
-	((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
-#define pte_offset_map_nested(dir, address) pte_offset_map((dir), (address))
+#define pte_offset_map(dir, address)	pte_offset_kernel(dir, address)
+#define pte_offset_map_nested(dir, address)	pte_offset_kernel(dir, address)
 #define pte_unmap(pte) do { } while (0)
 #define pte_unmap_nested(pte) do { } while (0)
 #endif
_

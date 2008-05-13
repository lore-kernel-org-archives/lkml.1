Return-Path: <linux-kernel-owner+w=401wt.eu-S1761394AbYEMRWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761394AbYEMRWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbYEMRWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:22:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48106 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbYEMRWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:22:11 -0400
Message-ID: <4829CE43.8060604@us.ibm.com>
Date: Tue, 13 May 2008 12:22:11 -0500
From: Jon Tollefson <kniht@us.ibm.com>
Reply-To: kniht@linux.vnet.ibm.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
CC: Paul Mackerras <paulus@samba.org>, Nick Piggin <npiggin@suse.de>,
       Nishanth Aravamudan <nacc@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Adam Litke <agl@us.ibm.com>
Subject: [PATCH 3/6 v2] powerpc: scan device tree and save gigantic page locations
References: <4829CAC3.30900@us.ibm.com>
In-Reply-To: <4829CAC3.30900@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 16G huge pages have to be reserved in the HMC prior to boot. The
location of the pages are placed in the device tree.   This patch adds
code to scan the device tree during very early boot and save these page
locations until hugetlbfs is ready for them.



Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
---

 arch/powerpc/mm/hash_utils_64.c  |   44 ++++++++++++++++++++++++++++++++++++++-
 arch/powerpc/mm/hugetlbpage.c    |   16 ++++++++++++++
 include/asm-powerpc/mmu-hash64.h |    2 +
 3 files changed, 61 insertions(+), 1 deletion(-)



diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index a83dfa3..133d6e2 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -67,6 +67,7 @@
 
 #define KB (1024)
 #define MB (1024*KB)
+#define GB (1024L*MB)
 
 /*
  * Note:  pte   --> Linux PTE
@@ -302,6 +303,44 @@ static int __init htab_dt_scan_page_sizes(unsigned long node,
 	return 0;
 }
 
+/* Scan for 16G memory blocks that have been set aside for huge pages
+ * and reserve those blocks for 16G huge pages.
+ */
+static int __init htab_dt_scan_hugepage_blocks(unsigned long node,
+					const char *uname, int depth,
+					void *data) {
+	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+	unsigned long *addr_prop;
+	u32 *page_count_prop;
+	unsigned int expected_pages;
+	long unsigned int phys_addr;
+	long unsigned int block_size;
+
+	/* We are scanning "memory" nodes only */
+	if (type == NULL || strcmp(type, "memory") != 0)
+		return 0;
+
+	/* This property is the log base 2 of the number of virtual pages that
+	 * will represent this memory block. */
+	page_count_prop = of_get_flat_dt_prop(node, "ibm,expected#pages", NULL);
+	if (page_count_prop == NULL)
+		return 0;
+	expected_pages = (1 << page_count_prop[0]);
+	addr_prop = of_get_flat_dt_prop(node, "reg", NULL);
+	if (addr_prop == NULL)
+		return 0;
+	phys_addr = addr_prop[0];
+	block_size = addr_prop[1];
+	if (block_size != (16 * GB))
+		return 0;
+	printk(KERN_INFO "Huge page(16GB) memory: "
+			"addr = 0x%lX size = 0x%lX pages = %d\n",
+			phys_addr, block_size, expected_pages);
+	lmb_reserve(phys_addr, block_size * expected_pages);
+	add_gpage(phys_addr, block_size, expected_pages);
+	return 0;
+}
+
 static void __init htab_init_page_sizes(void)
 {
 	int rc;
@@ -370,7 +409,10 @@ static void __init htab_init_page_sizes(void)
 	       mmu_psize_defs[mmu_io_psize].shift);
 
 #ifdef CONFIG_HUGETLB_PAGE
-	/* Init large page size. Currently, we pick 16M or 1M depending
+	/* Reserve 16G huge page memory sections for huge pages */
+	of_scan_flat_dt(htab_dt_scan_hugepage_blocks, NULL);
+
+/* Init large page size. Currently, we pick 16M or 1M depending
 	 * on what is available
 	 */
 	if (mmu_psize_defs[MMU_PAGE_16M].shift)
diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 383b3b2..a27b80c 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -110,6 +110,22 @@ pmd_t *hpmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long addr)
 }
 #endif
 
+/* Build list of addresses of gigantic pages.  This function is used in early
+ * boot before the buddy or bootmem allocator is setup.
+ */
+void add_gpage(unsigned long addr, unsigned long page_size,
+	unsigned long number_of_pages)
+{
+	if (!addr)
+		return;
+	while (number_of_pages > 0) {
+		gpage_freearray[nr_gpages] = addr;
+		nr_gpages++;
+		number_of_pages--;
+		addr += page_size;
+	}
+}
+
 /* Moves the gigantic page addresses from the temporary list to the
   * huge_boot_pages list.
  */
diff --git a/include/asm-powerpc/mmu-hash64.h b/include/asm-powerpc/mmu-hash64.h
index 2864fa3..db1276a 100644
--- a/include/asm-powerpc/mmu-hash64.h
+++ b/include/asm-powerpc/mmu-hash64.h
@@ -279,6 +279,8 @@ extern int htab_bolt_mapping(unsigned long vstart, unsigned long vend,
 			     unsigned long pstart, unsigned long mode,
 			     int psize, int ssize);
 extern void set_huge_psize(int psize);
+extern void add_gpage(unsigned long addr, unsigned long page_size,
+			  unsigned long number_of_pages);
 extern void demote_segment_4k(struct mm_struct *mm, unsigned long addr);
 
 extern void htab_initialize(void);



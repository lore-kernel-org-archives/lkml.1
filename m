Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZBTHQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZBTHQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 02:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZBTHQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 02:16:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:59265 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbZBTHQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 02:16:05 -0500
Message-ID: <499E589B.6060707@kernel.org>
Date: Fri, 20 Feb 2009 16:15:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Subject: [PATCH 08/10 UPDATED] vmalloc: add un/map_kernel_range_noflush()
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-9-git-send-email-tj@kernel.org>
In-Reply-To: <1234958676-27618-9-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Feb 2009 07:15:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: two more public map/unmap functions

Implement map_kernel_range_noflush() and unmap_kernel_range_noflush().
These functions respectively map and unmap address range in kernel VM
area but doesn't do any vcache or tlb flushing.  These will be used by
new percpu allocator.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
---
NOTE: about cache flush requirements added as per Nick's suggestion.

Thanks.

 include/linux/vmalloc.h |    3 ++
 mm/vmalloc.c            |   67 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index bbc0513..599ba79 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -91,6 +91,9 @@ extern struct vm_struct *remove_vm_area(const void *addr);
 
 extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
 			struct page ***pages);
+extern int map_kernel_range_noflush(unsigned long start, unsigned long size,
+				    pgprot_t prot, struct page **pages);
+extern void unmap_kernel_range_noflush(unsigned long addr, unsigned long size);
 extern void unmap_kernel_range(unsigned long addr, unsigned long size);
 
 /* Allocate/destroy a 'vmalloc' VM area. */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d206261..224eca9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -153,8 +153,8 @@ static int vmap_pud_range(pgd_t *pgd, unsigned long addr,
  *
  * Ie. pte at addr+N*PAGE_SIZE shall point to pfn corresponding to pages[N]
  */
-static int vmap_page_range(unsigned long start, unsigned long end,
-				pgprot_t prot, struct page **pages)
+static int vmap_page_range_noflush(unsigned long start, unsigned long end,
+				   pgprot_t prot, struct page **pages)
 {
 	pgd_t *pgd;
 	unsigned long next;
@@ -170,13 +170,22 @@ static int vmap_page_range(unsigned long start, unsigned long end,
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
-	flush_cache_vmap(start, end);
 
 	if (unlikely(err))
 		return err;
 	return nr;
 }
 
+static int vmap_page_range(unsigned long start, unsigned long end,
+			   pgprot_t prot, struct page **pages)
+{
+	int ret;
+
+	ret = vmap_page_range_noflush(start, end, prot, pages);
+	flush_cache_vmap(start, end);
+	return ret;
+}
+
 static inline int is_vmalloc_or_module_addr(const void *x)
 {
 	/*
@@ -1033,6 +1042,58 @@ void __init vmalloc_init(void)
 	vmap_initialized = true;
 }
 
+/**
+ * map_kernel_range_noflush - map kernel VM area with the specified pages
+ * @addr: start of the VM area to map
+ * @size: size of the VM area to map
+ * @prot: page protection flags to use
+ * @pages: pages to map
+ *
+ * Map PFN_UP(@size) pages at @addr.  The VM area @addr and @size
+ * specify should have been allocated using get_vm_area() and its
+ * friends.
+ *
+ * NOTE:
+ * This function does NOT do any cache flushing.  The caller is
+ * responsible for calling flush_cache_vmap() on to-be-mapped areas
+ * before calling this function.
+ *
+ * RETURNS:
+ * The number of pages mapped on success, -errno on failure.
+ */
+int map_kernel_range_noflush(unsigned long addr, unsigned long size,
+			     pgprot_t prot, struct page **pages)
+{
+	return vmap_page_range_noflush(addr, addr + size, prot, pages);
+}
+
+/**
+ * unmap_kernel_range_noflush - unmap kernel VM area
+ * @addr: start of the VM area to unmap
+ * @size: size of the VM area to unmap
+ *
+ * Unmap PFN_UP(@size) pages at @addr.  The VM area @addr and @size
+ * specify should have been allocated using get_vm_area() and its
+ * friends.
+ *
+ * NOTE:
+ * This function does NOT do any cache flushing.  The caller is
+ * responsible for calling flush_cache_vunmap() on to-be-mapped areas
+ * before calling this function and flush_tlb_kernel_range() after.
+ */
+void unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
+{
+	vunmap_page_range(addr, addr + size);
+}
+
+/**
+ * unmap_kernel_range - unmap kernel VM area and flush cache and TLB
+ * @addr: start of the VM area to unmap
+ * @size: size of the VM area to unmap
+ *
+ * Similar to unmap_kernel_range_noflush() but flushes vcache before
+ * the unmapping and tlb after.
+ */
 void unmap_kernel_range(unsigned long addr, unsigned long size)
 {
 	unsigned long end = addr + size;
-- 
1.6.0.2


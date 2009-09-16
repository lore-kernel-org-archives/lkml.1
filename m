Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbZIPDIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbZIPDIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 23:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZIPDHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 23:07:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:7197 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbZIPDHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 23:07:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,394,1249282800"; 
   d="scan'208";a="188105373"
Message-Id: <20090916030604.442255475@intel.com>
References: <20090916030009.585103525@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 11:00:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <greg@kroah.com>, Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 4/4] HWPOISON: stop /dev/mem users from accessing hwpoison pages
Content-Disposition: inline; filename=kmem-dev-mem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return EIO when user space tries to read/write/mmap hwpoison pages
via the /dev/mem interface.

The approach: rename range_is_allowed() to devmem_check_pfn_range(), and
add PageHWPoison() test into it. So as to fail the whole request if it
contains any hwpoison page. Partial write into physical memory seems
don't make much sense, and user space can avoid this limit by doing
1-page read/writes.

CC: Greg KH <greg@kroah.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2009-09-16 09:57:36.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2009-09-16 09:59:37.000000000 +0800
@@ -90,31 +90,28 @@ static inline int valid_mmap_phys_addr_r
 }
 #endif
 
-#ifdef CONFIG_STRICT_DEVMEM
-static inline int range_is_allowed(unsigned long pfn, unsigned long size)
+static int devmem_check_pfn_range(unsigned long pfn, unsigned long size)
 {
 	u64 from = ((u64)pfn) << PAGE_SHIFT;
 	u64 to = from + size;
 	u64 cursor = from;
 
 	while (cursor < to) {
+#ifdef CONFIG_STRICT_DEVMEM
 		if (!devmem_is_allowed(pfn)) {
 			printk(KERN_INFO
 		"Program %s tried to access /dev/mem between %Lx->%Lx.\n",
 				current->comm, from, to);
-			return 0;
+			return -EPERM;
 		}
+#endif
+		if (pfn_valid(pfn) && PageHWPoison(pfn_to_page(pfn)))
+			return -EIO;
 		cursor += PAGE_SIZE;
 		pfn++;
 	}
-	return 1;
-}
-#else
-static inline int range_is_allowed(unsigned long pfn, unsigned long size)
-{
-	return 1;
+	return 0;
 }
-#endif
 
 void __attribute__((weak)) unxlate_dev_mem_ptr(unsigned long phys, void *addr)
 {
@@ -151,11 +148,13 @@ static ssize_t read_mem(struct file * fi
 
 	while (count > 0) {
 		unsigned long remaining;
+		int err;
 
 		sz = size_inside_page(p, count);
 
-		if (!range_is_allowed(p >> PAGE_SHIFT, count))
-			return -EPERM;
+		err = devmem_check_pfn_range(p >> PAGE_SHIFT, count);
+		if (err)
+			return err;
 
 		/*
 		 * On ia64 if a page has been mapped somewhere as
@@ -185,9 +184,10 @@ static ssize_t write_mem(struct file * f
 			 size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
-	ssize_t written, sz;
 	unsigned long copied;
+	ssize_t written, sz;
 	void *ptr;
+	int err;
 
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
@@ -209,8 +209,9 @@ static ssize_t write_mem(struct file * f
 	while (count > 0) {
 		sz = size_inside_page(p, count);
 
-		if (!range_is_allowed(p >> PAGE_SHIFT, sz))
-			return -EPERM;
+		err = devmem_check_pfn_range(p >> PAGE_SHIFT, sz);
+		if (err)
+			return err;
 
 		/*
 		 * On ia64 if a page has been mapped somewhere as
@@ -298,6 +299,7 @@ static struct vm_operations_struct mmap_
 static int mmap_mem(struct file * file, struct vm_area_struct * vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
+	int err;
 
 	if (!valid_mmap_phys_addr_range(vma->vm_pgoff, size))
 		return -EINVAL;
@@ -305,8 +307,9 @@ static int mmap_mem(struct file * file, 
 	if (!private_mapping_ok(vma))
 		return -ENOSYS;
 
-	if (!range_is_allowed(vma->vm_pgoff, size))
-		return -EPERM;
+	err = devmem_check_pfn_range(vma->vm_pgoff, size);
+	if (err)
+		return err;
 
 	if (!phys_mem_access_prot_allowed(file, vma->vm_pgoff, size,
 						&vma->vm_page_prot))

-- 


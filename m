Return-Path: <linux-kernel-owner+w=401wt.eu-S932073Ab0AMOCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0AMOCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384Ab0AMOAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:00:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:2955 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab0AMOAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:00:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,264,1262592000"; 
   d="scan'208";a="530908914"
Message-Id: <20100113135958.144557405@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 13 Jan 2010 21:53:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Kelly Bowa <kmb@tuxedu.org>, Greg KH <greg@kroah.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Nick Piggin <npiggin@suse.de>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 7/8] hwpoison: prevent /dev/mem from accessing hwpoison pages
References: <20100113135305.013124116@intel.com>
Content-Disposition: inline; filename=hwpoison-dev-mem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return EIO when user space tries to read/write/mmap hwpoison pages
via the /dev/mem interface.

The approach: rename range_is_allowed() to devmem_check_pfn_range(), and
add PageHWPoison() test in it. This function will be called for the whole
mmap() range, or page by page for read()/write(). So it would fail the
mmap() request as a whole, and return partial results for read()/write().

CC: Kelly Bowa <kmb@tuxedu.org>
CC: Greg KH <greg@kroah.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2009-12-29 10:47:00.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2009-12-29 10:54:07.000000000 +0800
@@ -89,31 +89,28 @@ static inline int valid_mmap_phys_addr_r
 }
 #endif
 
-#ifdef CONFIG_STRICT_DEVMEM
-static inline int range_is_allowed(unsigned long pfn, unsigned long size)
+static int devmem_check_pfn_range(unsigned long pfn, unsigned long bytes)
 {
 	u64 from = ((u64)pfn) << PAGE_SHIFT;
-	u64 to = from + size;
+	u64 to = from + bytes;
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
@@ -150,11 +147,13 @@ static ssize_t read_mem(struct file * fi
 
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
@@ -184,9 +183,10 @@ static ssize_t write_mem(struct file * f
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
@@ -208,8 +208,9 @@ static ssize_t write_mem(struct file * f
 	while (count > 0) {
 		sz = size_inside_page(p, count);
 
-		if (!range_is_allowed(p >> PAGE_SHIFT, sz))
-			return -EPERM;
+		err = devmem_check_pfn_range(p >> PAGE_SHIFT, sz);
+		if (err)
+			return err;
 
 		/*
 		 * On ia64 if a page has been mapped somewhere as
@@ -297,6 +298,7 @@ static const struct vm_operations_struct
 static int mmap_mem(struct file * file, struct vm_area_struct * vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
+	int err;
 
 	if (!valid_mmap_phys_addr_range(vma->vm_pgoff, size))
 		return -EINVAL;
@@ -304,8 +306,9 @@ static int mmap_mem(struct file * file, 
 	if (!private_mapping_ok(vma))
 		return -ENOSYS;
 
-	if (!range_is_allowed(vma->vm_pgoff, size))
-		return -EPERM;
+	err = devmem_check_pfn_range(vma->vm_pgoff, size);
+	if (err)
+		return err;
 
 	if (!phys_mem_access_prot_allowed(file, vma->vm_pgoff, size,
 						&vma->vm_page_prot))



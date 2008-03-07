Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbYCGHDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbYCGHDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbYCGHDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:03:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:14920 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933AbYCGHDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:03:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,460,1199692800"; 
   d="scan'208";a="261265113"
Date: Thu, 6 Mar 2008 23:01:47 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: arjan@linux.intel.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add range_is_allowed() check to mmap of /dev/mem
Message-ID: <20080307070147.GA9888@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Earlier patch that introduced CONFIG_NONPROMISC_DEVMEM, did the
range_is_allowed() check only for read and write. Add range_is_allowed()
check to mmap of /dev/mem as well.

Changes the paramaters of range_is_allowed() to pfn and size to handle
more than 32 bits of physical address on 32 bit arch cleanly.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.git/drivers/char/mem.c
===================================================================
--- linux-2.6.git.orig/drivers/char/mem.c	2008-03-03 15:29:50.000000000 -0800
+++ linux-2.6.git/drivers/char/mem.c	2008-03-03 15:55:46.000000000 -0800
@@ -109,24 +109,26 @@
 #endif
 
 #ifdef CONFIG_NONPROMISC_DEVMEM
-static inline int range_is_allowed(unsigned long from, unsigned long to)
+static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
-	unsigned long cursor;
-
-	cursor = from >> PAGE_SHIFT;
-	while ((cursor << PAGE_SHIFT) < to) {
-		if (!devmem_is_allowed(cursor)) {
-			printk(KERN_INFO "Program %s tried to read /dev/mem "
-				"between %lx->%lx.\n",
+	u64 from = ((u64)pfn) << PAGE_SHIFT;
+	u64 to = from + size;
+	u64 cursor = from;
+
+	while (cursor < to) {
+		if (!devmem_is_allowed(pfn)) {
+			printk(KERN_INFO
+		"Program %s tried to access /dev/mem between %Lx->%Lx.\n",
 				current->comm, from, to);
 			return 0;
 		}
-		cursor++;
+		cursor += PAGE_SIZE;
+		pfn++;
 	}
 	return 1;
 }
 #else
-static inline int range_is_allowed(unsigned long from, unsigned long to)
+static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
 	return 1;
 }
@@ -181,7 +183,7 @@
 		 */
 		ptr = xlate_dev_mem_ptr(p);
 
-		if (!range_is_allowed(p, p+count))
+		if (!range_is_allowed(p >> PAGE_SHIFT, count))
 			return -EPERM;
 		if (copy_to_user(buf, ptr, sz))
 			return -EFAULT;
@@ -240,7 +242,7 @@
 		 */
 		ptr = xlate_dev_mem_ptr(p);
 
-		if (!range_is_allowed(p, p+sz))
+		if (!range_is_allowed(p >> PAGE_SHIFT, sz))
 			return -EPERM;
 		copied = copy_from_user(ptr, buf, sz);
 		if (copied) {
@@ -309,6 +311,9 @@
 	if (!private_mapping_ok(vma))
 		return -ENOSYS;
 
+	if (!range_is_allowed(vma->vm_pgoff, size))
+		return -EPERM;
+
 	vma->vm_page_prot = phys_mem_access_prot(file, vma->vm_pgoff,
 						 size,
 						 vma->vm_page_prot);

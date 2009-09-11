Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZIKSs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZIKSs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZIKSsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:48:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54044 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbZIKSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:48:45 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090911848.933193846@firstfloor.org>
In-Reply-To: <20090911848.933193846@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [19/21] HWPOISON: Add madvise() based injector for hardware poisoned pages v4
Message-Id: <20090911184848.40D9DB1757@basil.firstfloor.org>
Date: Fri, 11 Sep 2009 20:48:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: optional, useful for debugging

Add a new madvice sub command to inject poison for some
pages in a process' address space.  This is useful for
testing the poison page handling.

This patch can allow root to tie up large amounts of memory.
I got feedback from container developers and they didn't see any 
problem.

v2: Use write flag for get_user_pages to make sure to always get
a fresh page
v3: Don't request write mapping (Fengguang Wu)
v4: Move MADV_* number to avoid conflict with KSM (Hugh Dickins)

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/asm-generic/mman-common.h |    1 +
 mm/madvise.c                      |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

Index: linux/mm/madvise.c
===================================================================
--- linux.orig/mm/madvise.c
+++ linux/mm/madvise.c
@@ -207,6 +207,32 @@ static long madvise_remove(struct vm_are
 	return error;
 }
 
+#ifdef CONFIG_MEMORY_FAILURE
+/*
+ * Error injection support for memory error handling.
+ */
+static int madvise_hwpoison(unsigned long start, unsigned long end)
+{
+	int ret = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	for (; start < end; start += PAGE_SIZE) {
+		struct page *p;
+		int ret = get_user_pages(current, current->mm, start, 1,
+						0, 0, &p, NULL);
+		if (ret != 1)
+			return ret;
+		printk(KERN_INFO "Injecting memory failure for page %lx at %lx\n",
+		       page_to_pfn(p), start);
+		/* Ignore return value for now */
+		__memory_failure(page_to_pfn(p), 0, 1);
+		put_page(p);
+	}
+	return ret;
+}
+#endif
+
 static long
 madvise_vma(struct vm_area_struct *vma, struct vm_area_struct **prev,
 		unsigned long start, unsigned long end, int behavior)
@@ -307,6 +333,10 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 	int write;
 	size_t len;
 
+#ifdef CONFIG_MEMORY_FAILURE
+	if (behavior == MADV_HWPOISON)
+		return madvise_hwpoison(start, start+len_in);
+#endif
 	if (!madvise_behavior_valid(behavior))
 		return error;
 
Index: linux/include/asm-generic/mman-common.h
===================================================================
--- linux.orig/include/asm-generic/mman-common.h
+++ linux/include/asm-generic/mman-common.h
@@ -34,6 +34,7 @@
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
+#define MADV_HWPOISON	100		/* poison a page for testing */
 
 /* compatibility flags */
 #define MAP_FILE	0

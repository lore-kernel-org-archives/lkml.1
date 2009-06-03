Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZFCStk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZFCStk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbZFCSrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:47:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37873 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbZFCSrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:47:13 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090603846.816684333@firstfloor.org>
In-Reply-To: <20090603846.816684333@firstfloor.org>
To: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: [PATCH] [15/16] HWPOISON: Add madvise() based injector for hardware poisoned pages v3
Message-Id: <20090603184650.CE7521D0290@basil.firstfloor.org>
Date: Wed,  3 Jun 2009 20:46:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: optional, useful for debugging

Add a new madvice sub command to inject poison for some
pages in a process' address space.  This is useful for
testing the poison page handling.

Open issues:

- This patch allows root to tie up arbitary amounts of memory.
Should this be disabled inside containers?
- There's a small race window between getting the page and injecting.
The patch drops the ref count because otherwise memory_failure
complains about dangling references. In theory with a multi threaded
injector one could inject poison for a process foreign page this way.
Not a serious issue right now.

v2: Use write flag for get_user_pages to make sure to always get
a fresh page
v3: Don't request write mapping (Fengguang Wu)

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/asm-generic/mman-common.h |    1 +
 mm/madvise.c                      |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

Index: linux/mm/madvise.c
===================================================================
--- linux.orig/mm/madvise.c	2009-06-03 20:30:31.000000000 +0200
+++ linux/mm/madvise.c	2009-06-03 20:30:47.000000000 +0200
@@ -207,6 +207,38 @@
 	return error;
 }
 
+#ifdef CONFIG_MEMORY_FAILURE
+/*
+ * Error injection support for memory error handling.
+ */
+static int madvise_hwpoison(unsigned long start, unsigned long end)
+{
+	/*
+	 * RED-PEN
+	 * This allows to tie up arbitary amounts of memory.
+	 * Might be a good idea to disable it inside containers even for root.
+	 */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	for (; start < end; start += PAGE_SIZE) {
+		struct page *p;
+		int ret = get_user_pages(current, current->mm, start, 1,
+						0, 0, &p, NULL);
+		if (ret != 1)
+			return ret;
+		put_page(p);
+		/*
+		 * RED-PEN page can be reused in a short window, but otherwise
+		 * we'll have to fight with the reference count.
+		 */
+		printk(KERN_INFO "Injecting memory failure for page %lx at %lx\n",
+		       page_to_pfn(p), start);
+		memory_failure(page_to_pfn(p), 0);
+	}
+	return 0;
+}
+#endif
+
 static long
 madvise_vma(struct vm_area_struct *vma, struct vm_area_struct **prev,
 		unsigned long start, unsigned long end, int behavior)
@@ -307,6 +339,10 @@
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
--- linux.orig/include/asm-generic/mman-common.h	2009-06-03 20:30:31.000000000 +0200
+++ linux/include/asm-generic/mman-common.h	2009-06-03 20:30:47.000000000 +0200
@@ -34,6 +34,7 @@
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
+#define MADV_HWPOISON	12		/* poison a page for testing */
 
 /* compatibility flags */
 #define MAP_FILE	0

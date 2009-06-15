Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbZFODRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbZFODRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZFODO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:14:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:4375 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbZFODOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:14:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,220,1243839600"; 
   d="scan'208";a="154267321"
Message-Id: <20090615031254.168416512@intel.com>
References: <20090615024520.786814520@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Jun 2009 10:45:33 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
cc: Ingo Molnar <mingo@elte.hu>
cc: Mel Gorman <mel@csn.ul.ie>
cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 13/22] HWPOISON: Add madvise() based injector for hardware poisoned pages v3
Content-Disposition: inline; filename=mf-inject-madvise
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/asm-generic/mman-common.h |    1 
 mm/madvise.c                      |   36 ++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

--- sound-2.6.orig/mm/madvise.c
+++ sound-2.6/mm/madvise.c
@@ -207,6 +207,38 @@ static long madvise_remove(struct vm_are
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
@@ -307,6 +339,10 @@ SYSCALL_DEFINE3(madvise, unsigned long, 
 	int write;
 	size_t len;
 
+#ifdef CONFIG_MEMORY_FAILURE
+	if (behavior == MADV_HWPOISON)
+		return madvise_hwpoison(start, start+len_in);
+#endif
 	if (!madvise_behavior_valid(behavior))
 		return error;
 
--- sound-2.6.orig/include/asm-generic/mman-common.h
+++ sound-2.6/include/asm-generic/mman-common.h
@@ -34,6 +34,7 @@
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
+#define MADV_HWPOISON	12		/* poison a page for testing */
 
 /* compatibility flags */
 #define MAP_FILE	0

-- 


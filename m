Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbZLBEmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbZLBEmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZLBEhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:37:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:3797 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbZLBEhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764927"
Message-Id: <20091202043045.852342473@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <npiggin@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/24] mm: export stable page flags
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=kpageflags-export-page_uflags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename get_uflags() to stable_page_flags() and make it a global function
for use in the hwpoison page flags filter, which need to compare user
page flags with the value provided by user space.

Also move KPF_* to kernel-page-flags.h for use by user space tools.

CC: Matt Mackall <mpm@selenic.com>
CC: Nick Piggin <npiggin@suse.de>
CC: Christoph Lameter <clameter@sgi.com>
CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/proc/page.c                    |   45 +--------------------------
 include/linux/kernel-page-flags.h |   46 ++++++++++++++++++++++++++++
 include/linux/page-flags.h        |    2 +
 3 files changed, 51 insertions(+), 42 deletions(-)

--- linux-mm.orig/fs/proc/page.c	2009-11-07 20:23:59.000000000 +0800
+++ linux-mm/fs/proc/page.c	2009-11-07 20:37:31.000000000 +0800
@@ -8,6 +8,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/hugetlb.h>
+#include <linux/kernel-page-flags.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -71,52 +72,12 @@ static const struct file_operations proc
  * physical page flags.
  */
 
-/* These macros are used to decouple internal flags from exported ones */
-
-#define KPF_LOCKED		0
-#define KPF_ERROR		1
-#define KPF_REFERENCED		2
-#define KPF_UPTODATE		3
-#define KPF_DIRTY		4
-#define KPF_LRU			5
-#define KPF_ACTIVE		6
-#define KPF_SLAB		7
-#define KPF_WRITEBACK		8
-#define KPF_RECLAIM		9
-#define KPF_BUDDY		10
-
-/* 11-20: new additions in 2.6.31 */
-#define KPF_MMAP		11
-#define KPF_ANON		12
-#define KPF_SWAPCACHE		13
-#define KPF_SWAPBACKED		14
-#define KPF_COMPOUND_HEAD	15
-#define KPF_COMPOUND_TAIL	16
-#define KPF_HUGE		17
-#define KPF_UNEVICTABLE		18
-#define KPF_HWPOISON		19
-#define KPF_NOPAGE		20
-
-#define KPF_KSM			21
-
-/* kernel hacking assistances
- * WARNING: subject to change, never rely on them!
- */
-#define KPF_RESERVED		32
-#define KPF_MLOCKED		33
-#define KPF_MAPPEDTODISK	34
-#define KPF_PRIVATE		35
-#define KPF_PRIVATE_2		36
-#define KPF_OWNER_PRIVATE	37
-#define KPF_ARCH		38
-#define KPF_UNCACHED		39
-
 static inline u64 kpf_copy_bit(u64 kflags, int ubit, int kbit)
 {
 	return ((kflags >> kbit) & 1) << ubit;
 }
 
-static u64 get_uflags(struct page *page)
+u64 stable_page_flags(struct page *page)
 {
 	u64 k;
 	u64 u;
@@ -219,7 +180,7 @@ static ssize_t kpageflags_read(struct fi
 		else
 			ppage = NULL;
 
-		if (put_user(get_uflags(ppage), out)) {
+		if (put_user(stable_page_flags(ppage), out)) {
 			ret = -EFAULT;
 			break;
 		}
--- linux-mm.orig/include/linux/page-flags.h	2009-11-07 20:37:27.000000000 +0800
+++ linux-mm/include/linux/page-flags.h	2009-11-07 20:37:31.000000000 +0800
@@ -284,6 +284,8 @@ PAGEFLAG_FALSE(HWPoison)
 #define __PG_HWPOISON 0
 #endif
 
+u64 stable_page_flags(struct page *page);
+
 static inline int PageUptodate(struct page *page)
 {
 	int ret = test_bit(PG_uptodate, &(page)->flags);
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-mm/include/linux/kernel-page-flags.h	2009-11-07 20:37:31.000000000 +0800
@@ -0,0 +1,46 @@
+#ifndef LINUX_KERNEL_PAGE_FLAGS_H
+#define  LINUX_KERNEL_PAGE_FLAGS_H
+
+/*
+ * Stable page flag bits exported to user space
+ */
+
+#define KPF_LOCKED		0
+#define KPF_ERROR		1
+#define KPF_REFERENCED		2
+#define KPF_UPTODATE		3
+#define KPF_DIRTY		4
+#define KPF_LRU			5
+#define KPF_ACTIVE		6
+#define KPF_SLAB		7
+#define KPF_WRITEBACK		8
+#define KPF_RECLAIM		9
+#define KPF_BUDDY		10
+
+/* 11-20: new additions in 2.6.31 */
+#define KPF_MMAP		11
+#define KPF_ANON		12
+#define KPF_SWAPCACHE		13
+#define KPF_SWAPBACKED		14
+#define KPF_COMPOUND_HEAD	15
+#define KPF_COMPOUND_TAIL	16
+#define KPF_HUGE		17
+#define KPF_UNEVICTABLE		18
+#define KPF_HWPOISON		19
+#define KPF_NOPAGE		20
+
+#define KPF_KSM			21
+
+/* kernel hacking assistances
+ * WARNING: subject to change, never rely on them!
+ */
+#define KPF_RESERVED		32
+#define KPF_MLOCKED		33
+#define KPF_MAPPEDTODISK	34
+#define KPF_PRIVATE		35
+#define KPF_PRIVATE_2		36
+#define KPF_OWNER_PRIVATE	37
+#define KPF_ARCH		38
+#define KPF_UNCACHED		39
+
+#endif /* LINUX_KERNEL_PAGE_FLAGS_H */



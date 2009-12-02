Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZLBEhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZLBEhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZLBEhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:37:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:3797 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300AbZLBEha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764906"
Message-Id: <20091202043045.150526892@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/24] HWPOISON: make it possible to unpoison pages
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=hwpoison-free-poisoned-memory.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unpoisoning interface can be useful for
- stress testing tools to reclaim poisoned pages (to prevent OOM)
- system admin to instruct kernel to forget temporal memory errors

Note that it may leak pages silently - those who have been removed from
LRU cache, but not isolated from page cache/swap cache at hwpoison time.
Especially the stress test of dirty swap cache pages shall reboot system
before exhausting memory.

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/mm.h         |    1 
 include/linux/page-flags.h |    2 -
 mm/hwpoison-inject.c       |   31 ++++++++++++++++----
 mm/memory-failure.c        |   52 +++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+), 7 deletions(-)

--- linux-mm.orig/mm/hwpoison-inject.c	2009-11-30 11:08:34.000000000 +0800
+++ linux-mm/mm/hwpoison-inject.c	2009-11-30 20:30:55.000000000 +0800
@@ -4,7 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 
-static struct dentry *hwpoison_dir, *corrupt_pfn;
+static struct dentry *hwpoison_dir;
 
 static int hwpoison_inject(void *data, u64 val)
 {
@@ -14,7 +14,16 @@ static int hwpoison_inject(void *data, u
 	return __memory_failure(val, 18, 0);
 }
 
+static int hwpoison_forget(void *data, u64 val)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return forget_memory_failure(val);
+}
+
 DEFINE_SIMPLE_ATTRIBUTE(hwpoison_fops, NULL, hwpoison_inject, "%lli\n");
+DEFINE_SIMPLE_ATTRIBUTE(unpoison_fops, NULL, hwpoison_forget, "%lli\n");
 
 static void pfn_inject_exit(void)
 {
@@ -24,16 +33,26 @@ static void pfn_inject_exit(void)
 
 static int pfn_inject_init(void)
 {
+	struct dentry *dentry;
+
 	hwpoison_dir = debugfs_create_dir("hwpoison", NULL);
 	if (hwpoison_dir == NULL)
 		return -ENOMEM;
-	corrupt_pfn = debugfs_create_file("corrupt-pfn", 0600, hwpoison_dir,
+
+	dentry = debugfs_create_file("corrupt-pfn", 0600, hwpoison_dir,
 					  NULL, &hwpoison_fops);
-	if (corrupt_pfn == NULL) {
-		pfn_inject_exit();
-		return -ENOMEM;
-	}
+	if (!dentry)
+		goto fail;
+
+	dentry = debugfs_create_file("renew-pfn", 0600, hwpoison_dir,
+				     NULL, &unpoison_fops);
+	if (!dentry)
+		goto fail;
+
 	return 0;
+fail:
+	pfn_inject_exit();
+	return -ENOMEM;
 }
 
 module_init(pfn_inject_init);
--- linux-mm.orig/include/linux/mm.h	2009-11-30 11:08:34.000000000 +0800
+++ linux-mm/include/linux/mm.h	2009-11-30 20:08:10.000000000 +0800
@@ -1318,6 +1318,7 @@ extern void refund_locked_memory(struct 
 
 extern void memory_failure(unsigned long pfn, int trapno);
 extern int __memory_failure(unsigned long pfn, int trapno, int ref);
+extern int forget_memory_failure(unsigned long pfn);
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
 extern atomic_long_t mce_bad_pages;
--- linux-mm.orig/mm/memory-failure.c	2009-11-30 20:06:00.000000000 +0800
+++ linux-mm/mm/memory-failure.c	2009-11-30 20:33:58.000000000 +0800
@@ -814,6 +814,16 @@ int __memory_failure(unsigned long pfn, 
 	 * and in many cases impossible, so we just avoid it here.
 	 */
 	lock_page_nosync(p);
+
+	/*
+	 * unpoison always clear PG_hwpoison inside page lock
+	 */
+	if (!PageHWPoison(p)) {
+		action_result(pfn, "unpoisoned", IGNORED);
+		res = 0;
+		goto out;
+	}
+
 	wait_on_page_writeback(p);
 
 	/*
@@ -868,3 +878,45 @@ void memory_failure(unsigned long pfn, i
 {
 	__memory_failure(pfn, trapno, 0);
 }
+
+int forget_memory_failure(unsigned long pfn)
+{
+	struct page *page;
+	struct page *p;
+	int freeit = 0;
+
+	if (!pfn_valid(pfn))
+		return -ENXIO;
+
+	p = pfn_to_page(pfn);
+	page = compound_head(p);
+
+	if (!PageHWPoison(p))
+		return 0;
+
+	if (!get_page_unless_zero(page)) {
+		if (TestClearPageHWPoison(p))
+			atomic_long_dec(&mce_bad_pages);
+		return 0;
+	}
+
+	lock_page_nosync(page);
+	/*
+	 * This test is racy because PG_hwpoison is set outside of page lock.
+	 * That's acceptable because that won't trigger kernel panic. Instead,
+	 * the PG_hwpoison page will be caught and isolated on the entrance to
+	 * the free buddy page pool.
+	 */
+	if (TestClearPageHWPoison(p)) {
+		atomic_long_dec(&mce_bad_pages);
+		freeit = 1;
+	}
+	unlock_page(page);
+
+	put_page(page);
+	if (freeit)
+		put_page(page);
+
+	return 0;
+}
+EXPORT_SYMBOL(forget_memory_failure);
--- linux-mm.orig/include/linux/page-flags.h	2009-11-30 11:08:34.000000000 +0800
+++ linux-mm/include/linux/page-flags.h	2009-11-30 20:08:10.000000000 +0800
@@ -277,7 +277,7 @@ PAGEFLAG_FALSE(Uncached)
 
 #ifdef CONFIG_MEMORY_FAILURE
 PAGEFLAG(HWPoison, hwpoison)
-TESTSETFLAG(HWPoison, hwpoison)
+TESTSCFLAG(HWPoison, hwpoison)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
 #else
 PAGEFLAG_FALSE(HWPoison)



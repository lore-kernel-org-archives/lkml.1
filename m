Return-Path: <linux-kernel-owner+w=401wt.eu-S966246AbZLHVQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966246AbZLHVQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966266AbZLHVQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:16:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49517 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966242AbZLHVQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:17 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [7/31] HWPOISON: Turn ref argument into flags argument
Message-Id: <20091208211623.55D1FB151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that "ref" is just a boolean turn it into
a flags argument. First step is only a single flag
that makes the code's intention more clear, but more
may follow.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/mm.h  |    5 ++++-
 mm/madvise.c        |    2 +-
 mm/memory-failure.c |    5 +++--
 3 files changed, 8 insertions(+), 4 deletions(-)

Index: linux/include/linux/mm.h
===================================================================
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
@@ -1316,8 +1316,11 @@ extern int account_locked_memory(struct
 				 size_t size);
 extern void refund_locked_memory(struct mm_struct *mm, size_t size);
 
+enum mf_flags {
+	MF_COUNT_INCREASED = 1 << 0,
+};
 extern void memory_failure(unsigned long pfn, int trapno);
-extern int __memory_failure(unsigned long pfn, int trapno, int ref);
+extern int __memory_failure(unsigned long pfn, int trapno, int flags);
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p);
Index: linux/mm/memory-failure.c
===================================================================
--- linux.orig/mm/memory-failure.c
+++ linux/mm/memory-failure.c
@@ -739,7 +739,7 @@ static void hwpoison_user_mappings(struc
 		      ret != SWAP_SUCCESS, pfn);
 }
 
-int __memory_failure(unsigned long pfn, int trapno, int ref)
+int __memory_failure(unsigned long pfn, int trapno, int flags)
 {
 	unsigned long lru_flag;
 	struct page_state *ps;
@@ -775,7 +775,8 @@ int __memory_failure(unsigned long pfn,
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_freeze_refs()/page_unfreeze_refs() mismatch.
 	 */
-	if (!ref && !get_page_unless_zero(compound_head(p))) {
+	if (!(flags & MF_COUNT_INCREASED) &&
+		!get_page_unless_zero(compound_head(p))) {
 		action_result(pfn, "free or high order kernel", IGNORED);
 		return PageBuddy(compound_head(p)) ? 0 : -EBUSY;
 	}
Index: linux/mm/madvise.c
===================================================================
--- linux.orig/mm/madvise.c
+++ linux/mm/madvise.c
@@ -237,7 +237,7 @@ static int madvise_hwpoison(unsigned lon
 		printk(KERN_INFO "Injecting memory failure for page %lx at %lx\n",
 		       page_to_pfn(p), start);
 		/* Ignore return value for now */
-		__memory_failure(page_to_pfn(p), 0, 1);
+		__memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
 	}
 	return ret;
 }

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbZIGVbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbZIGVbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbZIGVbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:31:52 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:31766 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbZIGVbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:31:52 -0400
X-Trace: 259186587/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.94.54/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.94.54
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAPcYpUpPRV42/2dsb2JhbACBU9c1hBgF
X-IronPort-AV: E=Sophos;i="4.44,348,1249254000"; 
   d="scan'208";a="259186587"
Date: Mon, 7 Sep 2009 22:31:09 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 2/8] mm: remove unused GUP flags
In-Reply-To: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
Message-ID: <Pine.LNX.4.64.0909072230010.15430@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GUP_FLAGS_IGNORE_VMA_PERMISSIONS and GUP_FLAGS_IGNORE_SIGKILL were
flags added solely to prevent __get_user_pages() from doing some of
what it usually does, in the munlock case: we can now remove them.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/internal.h |    6 ++----
 mm/memory.c   |   14 ++++----------
 mm/nommu.c    |    6 ++----
 3 files changed, 8 insertions(+), 18 deletions(-)

--- mm1/mm/internal.h	2009-06-25 05:18:10.000000000 +0100
+++ mm2/mm/internal.h	2009-09-07 13:16:22.000000000 +0100
@@ -250,10 +250,8 @@ static inline void mminit_validate_memmo
 }
 #endif /* CONFIG_SPARSEMEM */
 
-#define GUP_FLAGS_WRITE                  0x1
-#define GUP_FLAGS_FORCE                  0x2
-#define GUP_FLAGS_IGNORE_VMA_PERMISSIONS 0x4
-#define GUP_FLAGS_IGNORE_SIGKILL         0x8
+#define GUP_FLAGS_WRITE		0x01
+#define GUP_FLAGS_FORCE		0x02
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long start, int len, int flags,
--- mm1/mm/memory.c	2009-09-05 14:40:16.000000000 +0100
+++ mm2/mm/memory.c	2009-09-07 13:16:22.000000000 +0100
@@ -1217,8 +1217,6 @@ int __get_user_pages(struct task_struct
 	unsigned int vm_flags = 0;
 	int write = !!(flags & GUP_FLAGS_WRITE);
 	int force = !!(flags & GUP_FLAGS_FORCE);
-	int ignore = !!(flags & GUP_FLAGS_IGNORE_VMA_PERMISSIONS);
-	int ignore_sigkill = !!(flags & GUP_FLAGS_IGNORE_SIGKILL);
 
 	if (nr_pages <= 0)
 		return 0;
@@ -1244,7 +1242,7 @@ int __get_user_pages(struct task_struct
 			pte_t *pte;
 
 			/* user gate pages are read-only */
-			if (!ignore && write)
+			if (write)
 				return i ? : -EFAULT;
 			if (pg > TASK_SIZE)
 				pgd = pgd_offset_k(pg);
@@ -1278,7 +1276,7 @@ int __get_user_pages(struct task_struct
 
 		if (!vma ||
 		    (vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
-		    (!ignore && !(vm_flags & vma->vm_flags)))
+		    !(vm_flags & vma->vm_flags))
 			return i ? : -EFAULT;
 
 		if (is_vm_hugetlb_page(vma)) {
@@ -1298,13 +1296,9 @@ int __get_user_pages(struct task_struct
 
 			/*
 			 * If we have a pending SIGKILL, don't keep faulting
-			 * pages and potentially allocating memory, unless
-			 * current is handling munlock--e.g., on exit. In
-			 * that case, we are not allocating memory.  Rather,
-			 * we're only unlocking already resident/mapped pages.
+			 * pages and potentially allocating memory.
 			 */
-			if (unlikely(!ignore_sigkill &&
-					fatal_signal_pending(current)))
+			if (unlikely(fatal_signal_pending(current)))
 				return i ? i : -ERESTARTSYS;
 
 			if (write)
--- mm1/mm/nommu.c	2009-09-05 14:40:16.000000000 +0100
+++ mm2/mm/nommu.c	2009-09-07 13:16:22.000000000 +0100
@@ -136,7 +136,6 @@ int __get_user_pages(struct task_struct
 	int i;
 	int write = !!(flags & GUP_FLAGS_WRITE);
 	int force = !!(flags & GUP_FLAGS_FORCE);
-	int ignore = !!(flags & GUP_FLAGS_IGNORE_VMA_PERMISSIONS);
 
 	/* calculate required read or write permissions.
 	 * - if 'force' is set, we only require the "MAY" flags.
@@ -150,8 +149,8 @@ int __get_user_pages(struct task_struct
 			goto finish_or_fault;
 
 		/* protect what we can, including chardevs */
-		if (vma->vm_flags & (VM_IO | VM_PFNMAP) ||
-		    (!ignore && !(vm_flags & vma->vm_flags)))
+		if ((vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
+		    !(vm_flags & vma->vm_flags))
 			goto finish_or_fault;
 
 		if (pages) {
@@ -170,7 +169,6 @@ finish_or_fault:
 	return i ? : -EFAULT;
 }
 
-
 /*
  * get a list of pages in an address range belonging to the specified process
  * and indicate the VMA that covers each page

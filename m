Return-Path: <linux-kernel-owner+w=401wt.eu-S964907AbZGQR1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907AbZGQR1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 13:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934508AbZGQR1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 13:27:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49176 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934324AbZGQR1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 13:27:42 -0400
From: Izik Eidus <ieidus@redhat.com>
To: akpm@linux-foundation.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, chrisw@redhat.com,
       avi@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au, ieidus@redhat.com
Subject: [PATCH 08/10] ksm: prevent mremap move poisoning
Date: Fri, 17 Jul 2009 20:30:48 +0300
Message-Id: <1247851850-4298-9-git-send-email-ieidus@redhat.com>
In-Reply-To: <1247851850-4298-8-git-send-email-ieidus@redhat.com>
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com>
 <1247851850-4298-2-git-send-email-ieidus@redhat.com>
 <1247851850-4298-3-git-send-email-ieidus@redhat.com>
 <1247851850-4298-4-git-send-email-ieidus@redhat.com>
 <1247851850-4298-5-git-send-email-ieidus@redhat.com>
 <1247851850-4298-6-git-send-email-ieidus@redhat.com>
 <1247851850-4298-7-git-send-email-ieidus@redhat.com>
 <1247851850-4298-8-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

KSM's scan allows for user pages to be COWed or unmapped at any time,
without requiring any notification.  But its stable tree does assume
that when it finds a KSM page where it placed a KSM page, then it is
the same KSM page that it placed there.

mremap move could break that assumption: if an area containing a KSM
page was unmapped, then an area containing a different KSM page was
moved with mremap into the place of the original, before KSM's scan
came around to notice.  That could then poison a node of the stable
tree, so that memcmps would "lie" and upset the ordering of the tree.

Probably noone will ever need mremap move on a VM_MERGEABLE area;
except that prohibiting it would make trouble for schemes in which we
try making everything VM_MERGEABLE e.g. for testing: an mremap which
normally works would then fail mysteriously.

There's no need to go to any trouble, such as re-sorting KSM's list of
rmap_items to match the new layout: simply unmerge the area to COW all
its KSM pages before moving, but leave VM_MERGEABLE on so that they're
remerged later.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Chris Wright <chrisw@redhat.com>
Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 mm/mremap.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index a39b7b9..93addde 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -11,6 +11,7 @@
 #include <linux/hugetlb.h>
 #include <linux/slab.h>
 #include <linux/shm.h>
+#include <linux/ksm.h>
 #include <linux/mman.h>
 #include <linux/swap.h>
 #include <linux/capability.h>
@@ -182,6 +183,17 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	if (mm->map_count >= sysctl_max_map_count - 3)
 		return -ENOMEM;
 
+	/*
+	 * Advise KSM to break any KSM pages in the area to be moved:
+	 * it would be confusing if they were to turn up at the new
+	 * location, where they happen to coincide with different KSM
+	 * pages recently unmapped.  But leave vma->vm_flags as it was,
+	 * so KSM can come around to merge on vma and new_vma afterwards.
+	 */
+	if (ksm_madvise(vma, old_addr, old_addr + old_len,
+						MADV_UNMERGEABLE, &vm_flags))
+		return -ENOMEM;
+
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff);
 	if (!new_vma)
-- 
1.5.6.5


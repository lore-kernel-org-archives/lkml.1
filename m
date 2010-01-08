Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246Ab0AHWFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0AHWFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 17:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236Ab0AHWFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 17:05:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229Ab0AHWFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 17:05:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/6] NOMMU: Fix race between ramfs truncation and shared mmap
To: viro@ZenIV.linux.org.uk, vapier@gentoo.org, lethal@linux-sh.org
Cc: dhowells@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Jan 2010 22:05:38 +0000
Message-ID: <20100108220538.23489.15477.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100108220516.23489.11319.stgit@warthog.procyon.org.uk>
References: <20100108220516.23489.11319.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the race between the truncation of a ramfs file and an attempt to make a
shared mmap of region of that file.

The problem is that do_mmap_pgoff() calls f_op->get_unmapped_area() to verify
that the file region is made of contiguous pages and to find its base address -
but there isn't any locking to guarantee this region until
vma_prio_tree_insert() is called by add_vma_to_mm().

Note that moving the functionality into f_op->mmap() doesn't help as that is
also called before vma_prio_tree_insert().

Instead make ramfs_nommu_check_mappings() grab nommu_region_sem whilst it does
its checks.  This means that this function will wait whilst mmaps take place.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ramfs/file-nommu.c |    7 ++++++-
 include/linux/sched.h |    2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)


diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 2efc571..2665313 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -131,6 +131,8 @@ static int ramfs_nommu_check_mappings(struct inode *inode,
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 
+	down_write(&nommu_region_sem);
+
 	/* search for VMAs that fall within the dead zone */
 	vma_prio_tree_foreach(vma, &iter, &inode->i_mapping->i_mmap,
 			      newsize >> PAGE_SHIFT,
@@ -138,10 +140,13 @@ static int ramfs_nommu_check_mappings(struct inode *inode,
 			      ) {
 		/* found one - only interested if it's shared out of the page
 		 * cache */
-		if (vma->vm_flags & VM_SHARED)
+		if (vma->vm_flags & VM_SHARED) {
+			up_write(&nommu_region_sem);
 			return -ETXTBSY; /* not quite true, but near enough */
+		}
 	}
 
+	up_write(&nommu_region_sem);
 	return 0;
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 08a2523..6f7bba9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -389,7 +389,7 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 extern void arch_unmap_area(struct mm_struct *, unsigned long);
 extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
 #else
-extern void arch_pick_mmap_layout(struct mm_struct *mm) {}
+static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
 #endif
 
 #if USE_SPLIT_PTLOCKS


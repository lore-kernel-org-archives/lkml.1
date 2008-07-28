Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbYG1TTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbYG1TTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbYG1TRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:17:38 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41631 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936AbYG1TRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:17:35 -0400
From: Eric Munson <ebmunson@us.ibm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net,
       Eric Munson <ebmunson@us.ibm.com>
Subject: [PATCH 3/5] Split boundary checking from body of do_munmap
Date: Mon, 28 Jul 2008 12:17:13 -0700
Message-Id: <46e1300bead6e4bf02451f139b6a2ecfae5b67b5.1216928613.git.ebmunson@us.ibm.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <cover.1216928613.git.ebmunson@us.ibm.com>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
In-Reply-To: <cover.1216928613.git.ebmunson@us.ibm.com>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently do_unmap pre-checks the unmapped address range against the
valid address range for the process size.  However during initial setup
the stack may actually be outside this range, particularly it may be
initially placed at the 64 bit stack address and later moved to the
normal 32 bit stack location.  In a later patch we will want to unmap
the stack as part of relocating it into huge pages.

This patch moves the bulk of do_munmap into __do_munmap which will not
be protected by the boundary checking.  When an area that would normally
fail at these checks needs to be unmapped (e.g. unmapping a stack that
was setup at 64 bit TASK_SIZE for a 32 bit process) __do_munmap should
be called directly.  do_munmap will continue to do the boundary checking
and will call __do_munmap as appropriate.

Signed-off-by: Eric Munson <ebmunson@us.ibm.com>

---
Based on 2.6.26-rc8-mm1

 include/linux/mm.h |    1 +
 mm/mmap.c          |   11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a4eeb3c..59c6f89 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1152,6 +1152,7 @@ out:
 	return ret;
 }
 
+extern int __do_munmap(struct mm_struct *, unsigned long, size_t);
 extern int do_munmap(struct mm_struct *, unsigned long, size_t);
 
 extern unsigned long do_brk(unsigned long, unsigned long);
diff --git a/mm/mmap.c b/mm/mmap.c
index 5b62e5d..4e56369 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1881,17 +1881,24 @@ int split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 	return 0;
 }
 
+int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
+{
+	if (start > TASK_SIZE || len > TASK_SIZE-start)
+		return -EINVAL;
+	return __do_munmap(mm, start, len);
+}
+
 /* Munmap is split into 2 main parts -- this part which finds
  * what needs doing, and the areas themselves, which do the
  * work.  This now handles partial unmappings.
  * Jeremy Fitzhardinge <jeremy@goop.org>
  */
-int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
+int __do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 {
 	unsigned long end;
 	struct vm_area_struct *vma, *prev, *last;
 
-	if ((start & ~PAGE_MASK) || start > TASK_SIZE || len > TASK_SIZE-start)
+	if (start & ~PAGE_MASK)
 		return -EINVAL;
 
 	if ((len = PAGE_ALIGN(len)) == 0)
-- 
1.5.6.1


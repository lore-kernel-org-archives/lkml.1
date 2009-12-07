Return-Path: <linux-kernel-owner+w=401wt.eu-S933497AbZLGDwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497AbZLGDwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933282AbZLGDw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:52:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51469 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933453AbZLGDwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:52:24 -0500
Date: Mon, 07 Dec 2009 03:52:30 +0000
To: linux-arch@vger.kernel.org
Subject: [PATCH 4/19] fix checks for expand-in-place mremap
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NHUeE-0007vP-Ov@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/mremap.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 90e422c..9d07539 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -27,6 +27,10 @@
 
 #include "internal.h"
 
+#ifndef arch_mmap_check
+#define arch_mmap_check(addr, len, flags)	(0)
+#endif
+
 static pmd_t *get_old_pmd(struct mm_struct *mm, unsigned long addr)
 {
 	pgd_t *pgd;
@@ -368,12 +372,17 @@ out:
 
 static int vma_expandable(struct vm_area_struct *vma, unsigned long delta)
 {
+	unsigned long end = vma->vm_end + delta;
 	unsigned long max_addr = TASK_SIZE;
 	if (vma->vm_next)
 		max_addr = vma->vm_next->vm_start;
-	if (max_addr - vma->vm_end < delta)
+	if (max_addr < end || end < vma->vm_end)
+		return 0;
+	if (arch_mmap_check(vma->vm_start, end - vma->vm_start, MAP_FIXED))
+		return 0;
+	if (get_unmapped_area(NULL, vma->vm_start, end - vma->vm_start,
+			      0, MAP_FIXED) & ~PAGE_MASK)
 		return 0;
-	/* we need to do arch-specific checks here */
 	return 1;
 }
 
-- 
1.5.6.5



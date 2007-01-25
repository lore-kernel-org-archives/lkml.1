Return-Path: <linux-kernel-owner+w=401wt.eu-S1030603AbXAYVnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030603AbXAYVnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030604AbXAYVnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:43:01 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45077 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030603AbXAYVnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:43:00 -0500
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH] Don't allow the stack to grow into hugetlb reserved regions
Date: Thu, 25 Jan 2007 13:40:52 -0800
To: linux-mm@kvack.org
Cc: david@gibson.dropbear.id.au, linux-kernel@vger.kernel.org, agl@us.ibm.com
Message-Id: <20070125214052.22841.33449.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When expanding the stack, we don't currently check if the VMA will cross into
an area of the address space that is reserved for hugetlb pages.  Subsequent
faults on the expanded portion of such a VMA will confuse the low-level MMU
code, resulting in an OOPS.  Check for this.

Signed-off-by: Adam Litke <agl@us.ibm.com>
---

 mm/mmap.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 9717337..2c6b163 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1477,6 +1477,7 @@ static int acct_stack_growth(struct vm_area_struct * vma, unsigned long size, un
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct rlimit *rlim = current->signal->rlim;
+	unsigned long new_start;
 
 	/* address space limit tests */
 	if (!may_expand_vm(mm, grow))
@@ -1496,6 +1497,12 @@ static int acct_stack_growth(struct vm_area_struct * vma, unsigned long size, un
 			return -ENOMEM;
 	}
 
+	/* Check to make the stack will not grow into a hugetlb-only region. */
+	new_start = (vma->vm_flags & VM_GROWSUP) ? vma->vm_start :
+			vma->vm_end - size;
+	if (is_hugepage_only_range(vma->vm_mm, new_start, size))
+		return -EFAULT;
+
 	/*
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.

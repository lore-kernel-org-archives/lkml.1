Return-Path: <linux-kernel-owner+w=401wt.eu-S932558AbZLQBkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbZLQBkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317AbZLQBib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:38:31 -0500
Received: from kroah.org ([198.145.64.141]:47959 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763621AbZLQBUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:25 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:03 2009
Message-Id: <20091217011603.095665584@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
       Andi Kleen <ak@linux.intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Andy Whitcroft <apw@canonical.com>,
       David Rientjes <rientjes@google.com>
Subject: [40/90] mm: hugetlb: fix hugepage memory leak in walk_page_range()
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

commit d33b9f45bd24a6391bc05e2b5a13c1b5787ca9c2 upstream.

Most callers of pmd_none_or_clear_bad() check whether the target page is
in a hugepage or not, but walk_page_range() do not check it.  So if we
read /proc/pid/pagemap for the hugepage on x86 machine, the hugepage
memory is leaked as shown below.  This patch fixes it.

Details
=======
My test program (leak_pagemap) works as follows:
 - creat() and mmap() a file on hugetlbfs (file size is 200MB == 100 hugepages,)
 - read()/write() something on it,
 - call page-types with option -p (walk around the page tables),
 - munmap() and unlink() the file on hugetlbfs

Without my patches
------------------
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ./leak_pagemap
[snip output]
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:      900
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ls /hugetlbfs/
$

100 hugepages are accounted as used while there is no file on hugetlbfs.

With my patches
---------------
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ./leak_pagemap
[snip output]
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ls /hugetlbfs
$

No memory leaks.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/pagewalk.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -1,6 +1,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/sched.h>
+#include <linux/hugetlb.h>
 
 static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			  struct mm_walk *walk)
@@ -107,6 +108,7 @@ int walk_page_range(unsigned long addr, 
 	pgd_t *pgd;
 	unsigned long next;
 	int err = 0;
+	struct vm_area_struct *vma;
 
 	if (addr >= end)
 		return err;
@@ -117,11 +119,22 @@ int walk_page_range(unsigned long addr, 
 	pgd = pgd_offset(walk->mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
+
+		/* skip hugetlb vma to avoid hugepage PMD being cleared
+		 * in pmd_none_or_clear_bad(). */
+		vma = find_vma(walk->mm, addr);
+		if (vma && is_vm_hugetlb_page(vma)) {
+			if (vma->vm_end < next)
+				next = vma->vm_end;
+			continue;
+		}
+
 		if (pgd_none_or_clear_bad(pgd)) {
 			if (walk->pte_hole)
 				err = walk->pte_hole(addr, next, walk);
 			if (err)
 				break;
+			pgd++;
 			continue;
 		}
 		if (walk->pgd_entry)
@@ -131,7 +144,8 @@ int walk_page_range(unsigned long addr, 
 			err = walk_pud_range(pgd, addr, next, walk);
 		if (err)
 			break;
-	} while (pgd++, addr = next, addr != end);
+		pgd++;
+	} while (addr = next, addr != end);
 
 	return err;
 }



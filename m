Return-Path: <linux-kernel-owner+w=401wt.eu-S936608AbZLQEdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936608AbZLQEdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935645AbZLQEdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:33:07 -0500
Received: from kroah.org ([198.145.64.141]:55614 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935649AbZLQEEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:34 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:52 2009
Message-Id: <20091217035652.076973985@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:08 -0800
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
Subject: [071/151] mm: hugetlb: fix hugepage memory leak in mincore()
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

commit 4f16fc107d9c9b8a72aa19b189a9216e90a7aaef upstream.

Most callers of pmd_none_or_clear_bad() check whether the target page is
in a hugepage or not, but mincore() and walk_page_range() do not check it.
 So if we use mincore() on a hugepage on x86 machine, the hugepage memory
is leaked as shown below.  This patch fixes it by extending mincore()
system call to support hugepages.

Details
=======
My test program (leak_mincore) works as follows:
 - creat() and mmap() a file on hugetlbfs (file size is 200MB == 100 hugepages,)
 - read()/write() something on it,
 - call mincore() for first ten pages and printf() the values of *vec
 - munmap() and unlink() the file on hugetlbfs

Without my patch
----------------
$ cat /proc/meminfo| grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ./leak_mincore
vec[0] 0
vec[1] 0
vec[2] 0
vec[3] 0
vec[4] 0
vec[5] 0
vec[6] 0
vec[7] 0
vec[8] 0
vec[9] 0
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:      999
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ls /hugetlbfs/
$

Return values in *vec from mincore() are set to 0, while the hugepage
should be in memory, and 1 hugepage is still accounted as used while
there is no file on hugetlbfs.

With my patch
-------------
$ cat /proc/meminfo| grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ./leak_mincore
vec[0] 1
vec[1] 1
vec[2] 1
vec[3] 1
vec[4] 1
vec[5] 1
vec[6] 1
vec[7] 1
vec[8] 1
vec[9] 1
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ls /hugetlbfs/
$

Return value in *vec set to 1 and no memory leaks.

[akpm@linux-foundation.org: cleanup]
[akpm@linux-foundation.org: build fix]
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

--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -14,6 +14,7 @@
 #include <linux/syscalls.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/hugetlb.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -72,6 +73,42 @@ static long do_mincore(unsigned long addr, unsigned char *vec, unsigned long pag
 	if (!vma || addr < vma->vm_start)
 		return -ENOMEM;
 
+#ifdef CONFIG_HUGETLB_PAGE
+	if (is_vm_hugetlb_page(vma)) {
+		struct hstate *h;
+		unsigned long nr_huge;
+		unsigned char present;
+
+		i = 0;
+		nr = min(pages, (vma->vm_end - addr) >> PAGE_SHIFT);
+		h = hstate_vma(vma);
+		nr_huge = ((addr + pages * PAGE_SIZE - 1) >> huge_page_shift(h))
+			  - (addr >> huge_page_shift(h)) + 1;
+		nr_huge = min(nr_huge,
+			      (vma->vm_end - addr) >> huge_page_shift(h));
+		while (1) {
+			/* hugepage always in RAM for now,
+			 * but generally it needs to be check */
+			ptep = huge_pte_offset(current->mm,
+					       addr & huge_page_mask(h));
+			present = !!(ptep &&
+				     !huge_pte_none(huge_ptep_get(ptep)));
+			while (1) {
+				vec[i++] = present;
+				addr += PAGE_SIZE;
+				/* reach buffer limit */
+				if (i == nr)
+					return nr;
+				/* check hugepage border */
+				if (!((addr & ~huge_page_mask(h))
+				      >> PAGE_SHIFT))
+					break;
+			}
+		}
+		return nr;
+	}
+#endif
+
 	/*
 	 * Calculate how many pages there are left in the last level of the
 	 * PTE array for our address.



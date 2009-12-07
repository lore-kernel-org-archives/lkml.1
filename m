Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbZLGIBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbZLGIBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758984AbZLGIBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:01:44 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49091 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964AbZLGIB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:01:27 -0500
Message-ID: <4B1CB5D6.9080007@ah.jp.nec.com>
Date: Mon, 07 Dec 2009 16:59:18 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reply-To: n-horiguchi@ah.jp.nec.com
Organization: NEC Corporation
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: linux-mm <linux-mm@kvack.org>, hugh.dickins@tiscali.co.uk,
       ak@linux.intel.com, Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 0/2] mm hugetlb x86: add hugepage support to pagemap
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Most callers of pmd_none_or_clear_bad() check whether the target
page is in a hugepage or not, but mincore() and walk_page_range() do
not check it. So if we read /proc/pid/pagemap for the hugepage
on x86 machine, the hugepage memory is leaked as shown below.
This patch fixes it by extending pagemap interface to support hugepages.

I split this fix into two patches.  The first patch just adds the check
for hugepages, and the second patch adds a new member to struct mm_walk
to handle the hugepages.

 fs/proc/task_mmu.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h |    3 +++
 mm/pagewalk.c      |   29 ++++++++++++++++++++++++++++-
 3 files changed, 74 insertions(+), 1 deletions(-)

Details
=======
My test program (leak_pagemap) works as follows:
 - creat() and mmap() a file on hugetlbfs (file size is 200MB == 100 hugepages,)
 - read()/write() something on it,
 - call page-types with option -p,
 - munmap() and unlink() the file on hugetlbfs
    
Without my patches
------------------
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ./leak_pagemap
             flags page-count       MB  symbolic-flags                     long-symbolic-flags
0x0000000000000000          1        0  __________________________________ 
0x0000000000000804          1        0  __R________M______________________ referenced,mmap
0x000000000000086c         81        0  __RU_lA____M______________________ referenced,uptodate,lru,active,mmap
0x0000000000005808          5        0  ___U_______Ma_b___________________ uptodate,mmap,anonymous,swapbacked
0x0000000000005868         12        0  ___U_lA____Ma_b___________________ uptodate,lru,active,mmap,anonymous,swapbacked
0x000000000000586c          1        0  __RU_lA____Ma_b___________________ referenced,uptodate,lru,active,mmap,anonymous,swapbacked
             total        101        0
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:      900
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ls /hugetlbfs/
$ 

The output of page-types don't show any hugepage, and 100 hugepages are
accounted as used while there is no file on hugetlbfs


With my patches
---------------
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ./leak_pagemap 
             flags page-count       MB  symbolic-flags                     long-symbolic-flags
0x0000000000000000          1        0  __________________________________ 
0x0000000000030000      51100      199  ________________TG________________ compound_tail,huge
0x0000000000028018        100        0  ___UD__________H_G________________ uptodate,dirty,compound_head,huge
0x0000000000000804          1        0  __R________M______________________ referenced,mmap
0x000000000000080c          1        0  __RU_______M______________________ referenced,uptodate,mmap
0x000000000000086c         80        0  __RU_lA____M______________________ referenced,uptodate,lru,active,mmap
0x0000000000005808          4        0  ___U_______Ma_b___________________ uptodate,mmap,anonymous,swapbacked
0x0000000000005868         12        0  ___U_lA____Ma_b___________________ uptodate,lru,active,mmap,anonymous,swapbacked
0x000000000000586c          1        0  __RU_lA____Ma_b___________________ referenced,uptodate,lru,active,mmap,anonymous,swapbacked
             total      51300      200
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ls /hugetlbfs
$ 

The output of page-types shows 51200 pages contributing to hugepages,
containing 100 head pages and 51100 tail pages as expected.
And no memory leaks.

Thanks,
Naoya Horiguchi


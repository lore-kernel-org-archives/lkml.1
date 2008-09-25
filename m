Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbYIYLxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbYIYLxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYIYLxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:53:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55066 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbYIYLw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:52:59 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       Hugh Dickins <hugh@veritas.com>, Adam Litke <agl@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 1/2] coredump_filter: add hugepage dumping v3
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080925204323.69E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 25 Sep 2008 20:52:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changelog
-----------------
v2 -> v3
  - separated /proc/[pid]/core_dump_filter bits into
    shared and private mapping pages.
  - updated document

v1 -> v2
  - updated document


============================================
Subject: [PATCH v3] coredump_filter: add hugepage core dumping

Now, hugepage's vma has VM_RESERVED flag in order not to being swapped.
But VM_RESERVED vma isn't core dumped because this flag is often used for
some kernel vmas (e.g. vmalloc, sound related).

Then hugepage is never dumped and it can't be debugged easily.
Many developers want hugepages to be included into core-dump.

However, We can't read VM_RESERVED area in almost case because this area is
often used for I/O mapping area.
then these area reading may change device state and it is definitly undesiable
side-effect.

So, To add hugepage specific bit of the coredump filter is better. 
it will be able to hugepage core dumping and doesn't cause any side-effect
to any I/O devices.

In additional, libhugetlb use hugetlb private mapping pages as anonymous page.
Then, hugepage private mapping pages should be core dumped by default.


Then, /proc/[pid]/core_dump_filter has two new bits.

 - bit 5 mean hugetlb private mapping pages are dumped or not. (default: yes)
 - bit 6 mean hugetlb shared mapping pages are dumped or not.  (default: no)


I tested by following method.

% ulimit -c unlimited
% ./crash_hugepage  50    
% ./crash_hugepage  50  -p
% ls -lh
% gdb ./crash_hugepage core
%
% echo 0x43 > /proc/self/coredump_filter
% ./crash_hugepage  50    
% ./crash_hugepage  50  -p
% ls -lh
% gdb ./crash_hugepage core

crash_hugepage.c
------------------------------------------------
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/mman.h>
#include <string.h>

#include "hugetlbfs.h"

int main(int argc, char** argv){
	char* p;
	int ch;
	int mmap_flags = MAP_SHARED;
	int fd;
	int nr_pages;

	while((ch = getopt(argc, argv, "p")) != -1) {
		switch (ch) {
		case 'p':
			mmap_flags &= ~MAP_SHARED;
			mmap_flags |= MAP_PRIVATE;
			break;
		default:
			/* nothing*/
			break;
		}
	}
	argc -= optind;
	argv += optind;

	if (argc == 0){
		printf("need # of pages\n");
		exit(1);
	}

	nr_pages = atoi(argv[0]);
	if (nr_pages < 2) {
		printf("nr_pages must >2\n");
		exit(1);
	}

	fd = hugetlbfs_unlinked_fd();
	p = mmap(NULL, nr_pages * gethugepagesize(),
		 PROT_READ|PROT_WRITE, mmap_flags, fd, 0);

	sleep(2);
	
	*(p + gethugepagesize()) = 1; /* COW */
	sleep(2);

	/* crash! */
	*(int*)0 = 1;

	return 0;
}

-----------------------------------------------------


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>
CC: Hugh Dickins <hugh@veritas.com>
CC: Adam Litke <agl@us.ibm.com>
CC: Mel Gorman <mel@csn.ul.ie>

---
 Documentation/filesystems/proc.txt |   15 ++++++++++-----
 fs/binfmt_elf.c                    |   12 ++++++++++--
 include/linux/sched.h              |    7 +++++--
 3 files changed, 25 insertions(+), 9 deletions(-)

Index: b/Documentation/filesystems/proc.txt
===================================================================
--- a/Documentation/filesystems/proc.txt	2008-09-25 21:19:13.000000000 +0900
+++ b/Documentation/filesystems/proc.txt	2008-09-25 21:21:05.000000000 +0900
@@ -2408,24 +2408,29 @@ will be dumped when the <pid> process is
 of memory types. If a bit of the bitmask is set, memory segments of the
 corresponding memory type are dumped, otherwise they are not dumped.
 
-The following 4 memory types are supported:
+The following 7 memory types are supported:
   - (bit 0) anonymous private memory
   - (bit 1) anonymous shared memory
   - (bit 2) file-backed private memory
   - (bit 3) file-backed shared memory
   - (bit 4) ELF header pages in file-backed private memory areas (it is
             effective only if the bit 2 is cleared)
+  - (bit 5) hugetlb private memory
+  - (bit 6) hugetlb shared memory
 
   Note that MMIO pages such as frame buffer are never dumped and vDSO pages
   are always dumped regardless of the bitmask status.
 
-Default value of coredump_filter is 0x3; this means all anonymous memory
-segments are dumped.
+  Note bit 0-4 doesn't effect any hugetlb memory. hugetlb memory are only
+  effected by bit 5-6.
+
+Default value of coredump_filter is 0x23; this means all anonymous memory
+segments and hugetlb private memory are dumped.
 
 If you don't want to dump all shared memory segments attached to pid 1234,
-write 1 to the process's proc file.
+write 21 to the process's proc file.
 
-  $ echo 0x1 > /proc/1234/coredump_filter
+  $ echo 0x21 > /proc/1234/coredump_filter
 
 When a new process is created, the process inherits the bitmask status from its
 parent. It is useful to set up coredump_filter before the program runs.
Index: b/fs/binfmt_elf.c
===================================================================
--- a/fs/binfmt_elf.c	2008-09-25 21:18:58.000000000 +0900
+++ b/fs/binfmt_elf.c	2008-09-25 21:19:16.000000000 +0900
@@ -1156,16 +1156,24 @@ static int dump_seek(struct file *file, 
 static unsigned long vma_dump_size(struct vm_area_struct *vma,
 				   unsigned long mm_flags)
 {
+#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
+
 	/* The vma can be set up to tell us the answer directly.  */
 	if (vma->vm_flags & VM_ALWAYSDUMP)
 		goto whole;
 
+	/* Hugetlb memory check */
+	if (vma->vm_flags & VM_HUGETLB) {
+		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
+			goto whole;
+		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
+			goto whole;
+	}
+
 	/* Do not dump I/O mapped devices or special mappings */
 	if (vma->vm_flags & (VM_IO | VM_RESERVED))
 		return 0;
 
-#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
-
 	/* By default, dump shared memory if mapped from an anonymous file. */
 	if (vma->vm_flags & VM_SHARED) {
 		if (vma->vm_file->f_path.dentry->d_inode->i_nlink == 0 ?
Index: b/include/linux/sched.h
===================================================================
--- a/include/linux/sched.h	2008-09-25 21:18:58.000000000 +0900
+++ b/include/linux/sched.h	2008-09-25 21:19:16.000000000 +0900
@@ -403,12 +403,15 @@ extern int get_dumpable(struct mm_struct
 #define MMF_DUMP_MAPPED_PRIVATE	4
 #define MMF_DUMP_MAPPED_SHARED	5
 #define MMF_DUMP_ELF_HEADERS	6
+#define MMF_DUMP_HUGETLB_PRIVATE 7
+#define MMF_DUMP_HUGETLB_SHARED  8
 #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
-#define MMF_DUMP_FILTER_BITS	5
+#define MMF_DUMP_FILTER_BITS	7
 #define MMF_DUMP_FILTER_MASK \
 	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
 #define MMF_DUMP_FILTER_DEFAULT \
-	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED))
+	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED) |\
+	 (1 << MMF_DUMP_HUGETLB_PRIVATE))
 
 struct sighand_struct {
 	atomic_t		count;



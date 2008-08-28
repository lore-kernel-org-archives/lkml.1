Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbYH1Faf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbYH1Faf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 01:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYH1Fa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 01:30:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34649 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYH1FaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 01:30:25 -0400
Date: Thu, 28 Aug 2008 14:24:16 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       Hugh Dickins <hugh@veritas.com>, William Irwin <wli@holomorphy.com>,
       Adam Litke <agl@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] coredump_filter: add hugepage core dumping
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, hugepage's vma has VM_RESERVED flag because it cannot be swapped.

and VM_RESERVED vma isn't core dumped because its flag often be used for
kernel internal vma (e.g. vmalloc, sound related).

So, hugepage is never dumped and it indicate hugepages's program can't be debugged easily.

In these days, demand on making use of hugepage is increasing.
IMO, native support for coredump of hugepage is useful.


I think VM_RESERVED default dumping bahavior is good,
then I'd like to add coredump_filter mask.

This patch doesn't change dafault behavior.


I tested by following method.

# ulimit -c unlimited
# echo 0x23 > /proc/self/coredump_filter
# ./hugepage_dump
# gdb ./hugepage_dump core


hugepage_dump.c
------------------------------------------------
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>

#define HUGEPAGE_SIZE (256*1024*1024)

int main(int argc, char** argv)
{
	int err;
	int shmid;
	int *pval;
	int shm_flags = 0666;

	if ((argc >= 2) && (strcmp(argv[1], "-h")==0))
		shm_flags |= SHM_HUGETLB;

	err = shmid = shmget(IPC_PRIVATE, HUGEPAGE_SIZE, shm_flags);
	if (err < 0) {
		perror("shmget");
		exit(1);
	}

	pval = shmat(shmid, 0, 0);
	if (pval == (void*)-1) {
		perror("shmat");
		exit(1);
	}

	*pval = 1;

	*(int*)0 = 1;

	exit(0);
}
-----------------------------------------------------


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Kawai, Hidehiro <hidehiro.kawai.ez@hitachi.com>
CC: Hugh Dickins <hugh@veritas.com>
CC: William Irwin <wli@holomorphy.com>
CC: Adam Litke <agl@us.ibm.com>

---
 Documentation/filesystems/proc.txt |    3 ++-
 fs/binfmt_elf.c                    |    7 ++++++-
 include/linux/sched.h              |    3 ++-
 3 files changed, 10 insertions(+), 3 deletions(-)

Index: b/Documentation/filesystems/proc.txt
===================================================================
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -2389,11 +2389,12 @@ will be dumped when the <pid> process is
 of memory types. If a bit of the bitmask is set, memory segments of the
 corresponding memory type are dumped, otherwise they are not dumped.
 
-The following 4 memory types are supported:
+The following 5 memory types are supported:
   - (bit 0) anonymous private memory
   - (bit 1) anonymous shared memory
   - (bit 2) file-backed private memory
   - (bit 3) file-backed shared memory
+  - (bit 5) hugetlb memory
 
   Note that MMIO pages such as frame buffer are never dumped and vDSO pages
   are always dumped regardless of the bitmask status.
Index: b/include/linux/sched.h
===================================================================
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -402,8 +402,9 @@ extern int get_dumpable(struct mm_struct
 #define MMF_DUMP_MAPPED_PRIVATE	4
 #define MMF_DUMP_MAPPED_SHARED	5
 #define MMF_DUMP_ELF_HEADERS	6
+#define MMF_DUMP_HUGETLB	7
 #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
-#define MMF_DUMP_FILTER_BITS	5
+#define MMF_DUMP_FILTER_BITS	(MMF_DUMP_HUGETLB - MMF_DUMP_ANON_PRIVATE + 1)
 #define MMF_DUMP_FILTER_MASK \
 	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
 #define MMF_DUMP_FILTER_DEFAULT \
Index: b/fs/binfmt_elf.c
===================================================================
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1160,11 +1160,16 @@ static unsigned long vma_dump_size(struc
 	if (vma->vm_flags & VM_ALWAYSDUMP)
 		goto whole;
 
+#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
+
+	if ((vma->vm_flags & VM_HUGETLB) && FILTER(HUGETLB))
+		goto whole;
+
 	/* Do not dump I/O mapped devices or special mappings */
 	if (vma->vm_flags & (VM_IO | VM_RESERVED))
 		return 0;
 
-#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
 
 	/* By default, dump shared memory if mapped from an anonymous file. */
 	if (vma->vm_flags & VM_SHARED) {



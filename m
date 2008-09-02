Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbYIBCUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbYIBCUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 22:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYIBCUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 22:20:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41544 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbYIBCUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 22:20:06 -0400
Date: Tue, 02 Sep 2008 11:18:33 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH] coredump_filter: add hugepage core dumping
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hugh@veritas.com>,
       William Irwin <wli@holomorphy.com>, Adam Litke <agl@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
In-Reply-To: <48BB8501.6070806@hitachi.com>
References: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48BB8501.6070806@hitachi.com>
Message-Id: <20080902111639.1AB7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Index: b/Documentation/filesystems/proc.txt
> > ===================================================================
> > --- a/Documentation/filesystems/proc.txt
> > +++ b/Documentation/filesystems/proc.txt
> > @@ -2389,11 +2389,12 @@ will be dumped when the <pid> process is
> >  of memory types. If a bit of the bitmask is set, memory segments of the
> >  corresponding memory type are dumped, otherwise they are not dumped.
> >  
> > -The following 4 memory types are supported:
> > +The following 5 memory types are supported:
> >    - (bit 0) anonymous private memory
> >    - (bit 1) anonymous shared memory
> >    - (bit 2) file-backed private memory
> >    - (bit 3) file-backed shared memory
> > +  - (bit 5) hugetlb memory
> 
> Hugetlb VMAs fall also into one of the lowest 4 bit case.
> If you introduce the hugetlb bit (bit 5), you'd better describe that
> the hugetlb bit takes precedence over the lowest 4 bits.

Thank you good review.
I updated that documentations.


=====================================================================
Subject: [PATCH v2] coredump_filter: add hugepage core dumping

Now, hugepage's vma has VM_RESERVED flag in order not to being swapped.
But VM_RESERVED vma isn't core dumped because this flag is often used for
some kernel vmas (e.g. vmalloc, sound related).

Then hugepage is never dumped and it can't be debugged easily.
Many developers want hugepages to be included into core-dump.

I think current VM_RESERVED default dumping bahavior is good,
then I'd like to add coredump_filter mask.


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
Tested-by: Adam Litke <agl@us.ibm.com>
Acked-by: Adam Litke <agl@us.ibm.com>

---
 Documentation/filesystems/proc.txt |    6 +++++-
 fs/binfmt_elf.c                    |    6 +++++-
 include/linux/sched.h              |    3 ++-
 3 files changed, 12 insertions(+), 3 deletions(-)

Index: b/Documentation/filesystems/proc.txt
===================================================================
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -2389,15 +2389,19 @@ will be dumped when the <pid> process is
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
 
+  Note hugetlb memory flag (bit 5) is prior to other bit. then 0x20 mean
+  that hugetlb memory can be dumped, but any other memory can't be dumped.
+
 Default value of coredump_filter is 0x3; this means all anonymous memory
 segments are dumped.
 
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
@@ -1160,11 +1160,15 @@ static unsigned long vma_dump_size(struc
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




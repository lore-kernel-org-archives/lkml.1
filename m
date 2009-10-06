Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbZJFTDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbZJFTDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758255AbZJFTDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:03:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757857AbZJFTDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:03:45 -0400
Date: Tue, 6 Oct 2009 21:03:16 +0200
From: Gleb Natapov <gleb@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH v3][RFC] add MAP_UNLOCKED mmap flag
Message-ID: <20091006190316.GB19692@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If application does mlockall(MCL_FUTURE) it is no longer possible to
mmap file bigger than main memory or allocate big area of anonymous
memory. Sometimes it is desirable to lock everything related to program
execution into memory, but still be able to mmap big file or allocate
huge amount of memory and allow OS to swap them on demand. MAP_UNLOCKED
allows to do that.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---

v1->v2
 - adding new flag to all archs
 - fixing typo
v2->v3
 - one more typo fix 

diff --git a/arch/alpha/include/asm/mman.h b/arch/alpha/include/asm/mman.h
index 99c56d4..cfc51ac 100644
--- a/arch/alpha/include/asm/mman.h
+++ b/arch/alpha/include/asm/mman.h
@@ -30,6 +30,7 @@
 #define MAP_NONBLOCK	0x40000		/* do not block on IO */
 #define MAP_STACK	0x80000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x100000	/* create a huge page mapping */
+#define MAP_UNLOCKED	0x200000	/* force page unlocking */
 
 #define MS_ASYNC	1		/* sync memory asynchronously */
 #define MS_SYNC		2		/* synchronous memory sync */
diff --git a/arch/mips/include/asm/mman.h b/arch/mips/include/asm/mman.h
index a2250f3..c161e27 100644
--- a/arch/mips/include/asm/mman.h
+++ b/arch/mips/include/asm/mman.h
@@ -48,6 +48,7 @@
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
 #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
+#define MAP_UNLOCKED	0x100000	/* force page unlocking */
 
 /*
  * Flags for msync
diff --git a/arch/parisc/include/asm/mman.h b/arch/parisc/include/asm/mman.h
index 9749c8a..4e8b9bf 100644
--- a/arch/parisc/include/asm/mman.h
+++ b/arch/parisc/include/asm/mman.h
@@ -24,6 +24,7 @@
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
 #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
+#define MAP_UNLOCKED	0x100000	/* force page unlocking */
 
 #define MS_SYNC		1		/* synchronous memory sync */
 #define MS_ASYNC	2		/* sync memory asynchronously */
diff --git a/arch/powerpc/include/asm/mman.h b/arch/powerpc/include/asm/mman.h
index d4a7f64..7d33f01 100644
--- a/arch/powerpc/include/asm/mman.h
+++ b/arch/powerpc/include/asm/mman.h
@@ -27,6 +27,7 @@
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
+#define MAP_UNLOCKED	0x80000		/* force page unlocking */
 
 #ifdef __KERNEL__
 #ifdef CONFIG_PPC64
diff --git a/arch/sparc/include/asm/mman.h b/arch/sparc/include/asm/mman.h
index c3029ad..f80d203 100644
--- a/arch/sparc/include/asm/mman.h
+++ b/arch/sparc/include/asm/mman.h
@@ -22,6 +22,7 @@
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
+#define MAP_UNLOCKED	0x80000		/* force page unlocking */
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
diff --git a/arch/xtensa/include/asm/mman.h b/arch/xtensa/include/asm/mman.h
index fca4db4..c62bcd8 100644
--- a/arch/xtensa/include/asm/mman.h
+++ b/arch/xtensa/include/asm/mman.h
@@ -55,6 +55,7 @@
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
 #define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x80000		/* create a huge page mapping */
+#define MAP_UNLOCKED	0x100000	/* force page unlocking */
 
 /*
  * Flags for msync
diff --git a/include/asm-generic/mman.h b/include/asm-generic/mman.h
index 32c8bd6..59e0f29 100644
--- a/include/asm-generic/mman.h
+++ b/include/asm-generic/mman.h
@@ -12,6 +12,7 @@
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
+#define MAP_UNLOCKED	0x80000         /* force page unlocking */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/mm/mmap.c b/mm/mmap.c
index 73f5e4b..ecc4471 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -985,6 +985,9 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 		if (!can_do_mlock())
 			return -EPERM;
 
+        if (flags & MAP_UNLOCKED)
+                vm_flags &= ~VM_LOCKED;
+
 	/* mlock MCL_FUTURE? */
 	if (vm_flags & VM_LOCKED) {
 		unsigned long locked, lock_limit;
--
			Gleb.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbZEFD2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbZEFD2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 23:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZEFD2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 23:28:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:55463 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbZEFD2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 23:28:22 -0400
Date: Wed, 6 May 2009 03:27:49 GMT
From: tip-bot for Rik van Riel <riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20090505172856.6820db22@cuia.bos.redhat.com>
References: <20090505172856.6820db22@cuia.bos.redhat.com>
Subject: [tip:x86/mm] x86: 46 bit physical address support on 64 bits
Message-ID: <tip-c898faf91b3ec6b0f6efa35831b3984fa3331db0@git.kernel.org>
Git-Commit-ID: c898faf91b3ec6b0f6efa35831b3984fa3331db0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 03:27:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c898faf91b3ec6b0f6efa35831b3984fa3331db0
Gitweb:     http://git.kernel.org/tip/c898faf91b3ec6b0f6efa35831b3984fa3331db0
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Tue, 5 May 2009 17:28:56 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 5 May 2009 19:10:18 -0700

x86: 46 bit physical address support on 64 bits

Extend the maximum addressable memory on x86-64 from 2^44 to
2^46 bytes. This requires some shuffling around of the vmalloc
and virtual memmap memory areas, to keep them away from the
direct mapping of up to 64TB of physical memory.

This patch also introduces a guard hole between the vmalloc
area and the virtual memory map space.  There's really no
good reason why we wouldn't have a guard hole there.

[ Impact: future hardware enablement ]

Signed-off-by: Rik van Riel <riel@redhat.com>
LKML-Reference: <20090505172856.6820db22@cuia.bos.redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 Documentation/x86/x86_64/mm.txt         |    9 +++++----
 arch/x86/include/asm/page_64_types.h    |    2 +-
 arch/x86/include/asm/pgtable_64_types.h |    8 ++++----
 arch/x86/include/asm/sparsemem.h        |    2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index 29b52b1..5394132 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -6,10 +6,11 @@ Virtual memory map with 4 level page tables:
 0000000000000000 - 00007fffffffffff (=47 bits) user space, different per mm
 hole caused by [48:63] sign extension
 ffff800000000000 - ffff80ffffffffff (=40 bits) guard hole
-ffff880000000000 - ffffc0ffffffffff (=57 TB) direct mapping of all phys. memory
-ffffc10000000000 - ffffc1ffffffffff (=40 bits) hole
-ffffc20000000000 - ffffe1ffffffffff (=45 bits) vmalloc/ioremap space
-ffffe20000000000 - ffffe2ffffffffff (=40 bits) virtual memory map (1TB)
+ffff880000000000 - ffffc8ffffffffff (=64 TB) direct mapping of all phys. memory
+ffffc80000000000 - ffffc8ffffffffff (=40 bits) hole
+ffffc90000000000 - ffffe8ffffffffff (=45 bits) vmalloc/ioremap space
+ffffe90000000000 - ffffe9ffffffffff (=40 bits) hole
+ffffea0000000000 - ffffeaffffffffff (=40 bits) virtual memory map (1TB)
 ... unused hole ...
 ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from phys 0
 ffffffffa0000000 - fffffffffff00000 (=1536 MB) module mapping space
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 3f58718..6fadb02 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -47,7 +47,7 @@
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
 
-/* See Documentation/x86_64/mm.txt for a description of the memory map. */
+/* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
 #define __PHYSICAL_MASK_SHIFT	46
 #define __VIRTUAL_MASK_SHIFT	48
 
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index fbf42b8..766ea16 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -51,11 +51,11 @@ typedef struct { pteval_t pte; } pte_t;
 #define PGDIR_SIZE	(_AC(1, UL) << PGDIR_SHIFT)
 #define PGDIR_MASK	(~(PGDIR_SIZE - 1))
 
-
+/* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
 #define MAXMEM		 _AC(__AC(1, UL) << MAX_PHYSMEM_BITS, UL)
-#define VMALLOC_START    _AC(0xffffc20000000000, UL)
-#define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
-#define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
+#define VMALLOC_START    _AC(0xffffc90000000000, UL)
+#define VMALLOC_END      _AC(0xffffe8ffffffffff, UL)
+#define VMEMMAP_START	 _AC(0xffffea0000000000, UL)
 #define MODULES_VADDR    _AC(0xffffffffa0000000, UL)
 #define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
diff --git a/arch/x86/include/asm/sparsemem.h b/arch/x86/include/asm/sparsemem.h
index e3cc3c0..4517d6b 100644
--- a/arch/x86/include/asm/sparsemem.h
+++ b/arch/x86/include/asm/sparsemem.h
@@ -27,7 +27,7 @@
 #else /* CONFIG_X86_32 */
 # define SECTION_SIZE_BITS	27 /* matt - 128 is convenient right now */
 # define MAX_PHYSADDR_BITS	44
-# define MAX_PHYSMEM_BITS	44 /* Can be max 45 bits */
+# define MAX_PHYSMEM_BITS	46
 #endif
 
 #endif /* CONFIG_SPARSEMEM */

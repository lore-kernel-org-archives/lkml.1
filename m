Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbXLDVzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbXLDVzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXLDVzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:55:09 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:11778 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbXLDVzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:55:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mZLx6h2jVhiBQ/H9rFdazt14klRoKZJqyZ1ypCrp448ieYhXkEf6p4rVdcAYQAeyPnxUWsYCrcvjrxUUjW/fE5R3TLymyGa3FBh6/IgrcAQhoZ2+EgtwSIMxPl7J+SxkqD4opvMa1IVJHvCPz751BwLpj7ik1do1eNa/dwQCsg4=
Subject: [RFC PATCHv2] Unify mmap_[32|64].c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071204213636.GB11216@elte.hu>
References: <1196801553.10408.24.camel@brick>
	 <20071204213636.GB11216@elte.hu>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 13:55:05 -0800
Message-Id: <1196805305.10408.30.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start from mmap_32.c and add X86_64 specific function as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Resent without git-specific patch rename.  Also, missed the <linux/personality.h>
include in the last version, still learning git over here and generated the wrong
patch.

 arch/x86/mm/Makefile_32 |    2 +-
 arch/x86/mm/Makefile_64 |    3 +-
 arch/x86/mm/mmap.c      |   87 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/mmap_32.c   |   81 -------------------------------------------
 arch/x86/mm/mmap_64.c   |   32 -----------------
 5 files changed, 89 insertions(+), 116 deletions(-)

diff --git a/arch/x86/mm/Makefile_32 b/arch/x86/mm/Makefile_32
index 362b4ad..a01aca7 100644
--- a/arch/x86/mm/Makefile_32
+++ b/arch/x86/mm/Makefile_32
@@ -2,7 +2,7 @@
 # Makefile for the linux i386-specific parts of the memory manager.
 #
 
-obj-y	:= init_32.o pgtable_32.o fault_32.o ioremap_32.o extable_32.o pageattr_32.o mmap_32.o
+obj-y	:= init_32.o pgtable_32.o fault_32.o ioremap_32.o extable_32.o pageattr_32.o mmap.o
 
 obj-$(CONFIG_NUMA) += discontig_32.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
diff --git a/arch/x86/mm/Makefile_64 b/arch/x86/mm/Makefile_64
index d18baed..b5a7448 100644
--- a/arch/x86/mm/Makefile_64
+++ b/arch/x86/mm/Makefile_64
@@ -2,9 +2,8 @@
 # Makefile for the linux x86_64-specific parts of the memory manager.
 #
 
-obj-y	 := init_64.o fault_64.o ioremap_64.o extable_64.o pageattr_64.o mmap_64.o
+obj-y	 := init_64.o fault_64.o ioremap_64.o extable_64.o pageattr_64.o mmap.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_NUMA) += numa_64.o
 obj-$(CONFIG_K8_NUMA) += k8topology_64.o
 obj-$(CONFIG_ACPI_NUMA) += srat_64.o
-obj-$(CONFIG_IA32_EMULATION) += mmap_32.o
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
new file mode 100644
index 0000000..b09bed8
--- /dev/null
+++ b/arch/x86/mm/mmap.c
@@ -0,0 +1,87 @@
+/*
+ * Combined x86 flexible mmap layout support
+ *
+ * Started by Ingo Molnar <mingo@elte.hu>
+ * Copyright 2003-2004 Red Hat Inc., Durham, North Carolina.
+ * Copyright 2005 Andi Kleen, SuSE Labs.
+ *
+ */
+
+#include <linux/personality.h>
+#include <linux/mm.h>
+#include <linux/random.h>
+#include <linux/sched.h>
+
+/*
+ * Top of mmap area (just below the process stack).
+ *
+ * Leave an at least ~128 MB hole.
+ */
+#define MIN_GAP (128*1024*1024)
+#define MAX_GAP (TASK_SIZE/6*5)
+
+static inline unsigned long mmap_base(struct mm_struct *mm)
+{
+	unsigned long gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
+	unsigned long random_factor = 0;
+
+	if (current->flags & PF_RANDOMIZE)
+		random_factor = get_random_int() % (1024*1024);
+
+	if (gap < MIN_GAP)
+		gap = MIN_GAP;
+	else if (gap > MAX_GAP)
+		gap = MAX_GAP;
+
+	return PAGE_ALIGN(TASK_SIZE - gap - random_factor);
+}
+
+/*
+ * This function, called very early during the creation of a new
+ * process VM image, sets up which VM layout function to use:
+ */
+static void ia32_pick_mmap_layout(struct mm_struct *mm)
+{
+	/*
+	 * Fall back to the standard layout if the personality
+	 * bit is set, or if the expected stack growth is unlimited:
+	 */
+	if (sysctl_legacy_va_layout ||
+	    (current->personality & ADDR_COMPAT_LAYOUT) ||
+	    current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY) {
+		mm->mmap_base = TASK_UNMAPPED_BASE;
+		mm->get_unmapped_area = arch_get_unmapped_area;
+		mm->unmap_area = arch_unmap_area;
+	} else {
+		mm->mmap_base = mmap_base(mm);
+		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		mm->unmap_area = arch_unmap_area_topdown;
+	}
+}
+
+/* TODO: move the mmap code from sys_x86_64.c over here. */
+void arch_pick_mmap_layout(struct mm_struct *mm)
+{
+#ifdef CONFIG_X86_32
+	return ia32_pick_mmap_layout(mm);
+#endif
+#ifdef CONFIG_IA32_EMULATION
+	if (current_thread_info()->flags & _TIF_IA32)
+		return ia32_pick_mmap_layout(mm);
+#endif
+	mm->mmap_base = TASK_UNMAPPED_BASE;
+	if (current->flags & PF_RANDOMIZE) {
+		/*
+		 * Add 28bit randomness which is about 40bits of
+		 * address space because mmap base has to be page
+		 * aligned.  or ~1/128 of the total user VM (total
+		 * user address space is 47bits)
+		 */
+		unsigned rnd = get_random_int() & 0xfffffff;
+
+		mm->mmap_base += ((unsigned long)rnd) << PAGE_SHIFT;
+	}
+	mm->get_unmapped_area = arch_get_unmapped_area;
+	mm->unmap_area = arch_unmap_area;
+}
+
diff --git a/arch/x86/mm/mmap_32.c b/arch/x86/mm/mmap_32.c
deleted file mode 100644
index d490662..0000000
--- a/arch/x86/mm/mmap_32.c
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- *  linux/arch/i386/mm/mmap.c
- *
- *  flexible mmap layout support
- *
- * Copyright 2003-2004 Red Hat Inc., Durham, North Carolina.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- *
- * Started by Ingo Molnar <mingo@elte.hu>
- */
-
-#include <linux/personality.h>
-#include <linux/mm.h>
-#include <linux/random.h>
-#include <linux/sched.h>
-
-/*
- * Top of mmap area (just below the process stack).
- *
- * Leave an at least ~128 MB hole.
- */
-#define MIN_GAP (128*1024*1024)
-#define MAX_GAP (TASK_SIZE/6*5)
-
-static inline unsigned long mmap_base(struct mm_struct *mm)
-{
-	unsigned long gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
-	unsigned long random_factor = 0;
-
-	if (current->flags & PF_RANDOMIZE)
-		random_factor = get_random_int() % (1024*1024);
-
-	if (gap < MIN_GAP)
-		gap = MIN_GAP;
-	else if (gap > MAX_GAP)
-		gap = MAX_GAP;
-
-	return PAGE_ALIGN(TASK_SIZE - gap - random_factor);
-}
-
-/*
- * This function, called very early during the creation of a new
- * process VM image, sets up which VM layout function to use:
- */
-#ifdef CONFIG_X86_32
-void arch_pick_mmap_layout(struct mm_struct *mm)
-#else
-void ia32_pick_mmap_layout(struct mm_struct *mm)
-#endif
-{
-	/*
-	 * Fall back to the standard layout if the personality
-	 * bit is set, or if the expected stack growth is unlimited:
-	 */
-	if (sysctl_legacy_va_layout ||
-	    (current->personality & ADDR_COMPAT_LAYOUT) ||
-	    current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY) {
-		mm->mmap_base = TASK_UNMAPPED_BASE;
-		mm->get_unmapped_area = arch_get_unmapped_area;
-		mm->unmap_area = arch_unmap_area;
-	} else {
-		mm->mmap_base = mmap_base(mm);
-		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
-		mm->unmap_area = arch_unmap_area_topdown;
-	}
-}
diff --git a/arch/x86/mm/mmap_64.c b/arch/x86/mm/mmap_64.c
deleted file mode 100644
index ffb71a3..0000000
--- a/arch/x86/mm/mmap_64.c
+++ /dev/null
@@ -1,32 +0,0 @@
-/* Copyright 2005 Andi Kleen, SuSE Labs.
- * Licensed under GPL, v.2
- */
-#include <linux/mm.h>
-#include <linux/sched.h>
-#include <linux/random.h>
-#include <asm/ia32.h>
-
-/* Notebook: move the mmap code from sys_x86_64.c over here. */
-
-void arch_pick_mmap_layout(struct mm_struct *mm)
-{
-#ifdef CONFIG_IA32_EMULATION
-	if (current_thread_info()->flags & _TIF_IA32)
-		return ia32_pick_mmap_layout(mm);
-#endif
-	mm->mmap_base = TASK_UNMAPPED_BASE;
-	if (current->flags & PF_RANDOMIZE) {
-		/*
-		 * Add 28bit randomness which is about 40bits of
-		 * address space because mmap base has to be page
-		 * aligned.  or ~1/128 of the total user VM (total
-		 * user address space is 47bits)
-		 */
-		unsigned rnd = get_random_int() & 0xfffffff;
-
-		mm->mmap_base += ((unsigned long)rnd) << PAGE_SHIFT;
-	}
-	mm->get_unmapped_area = arch_get_unmapped_area;
-	mm->unmap_area = arch_unmap_area;
-}
-
-- 
1.5.3.7.2094.gff6c




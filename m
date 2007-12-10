Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbXLJUxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbXLJUxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 15:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbXLJUwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 15:52:54 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:28778 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbXLJUwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 15:52:53 -0500
Date: Mon, 10 Dec 2007 07:50:55 -0800
From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] x86: Unify mmap_{32|64}.c
In-reply-to: <20071209081324.GB4509@elte.hu>
To: Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <1197301855.1799.1.camel@brick>
MIME-version: 1.0
X-Mailer: Evolution 2.12.1
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <1196889830.10408.50.camel@brick> <20071209081324.GB4509@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmap_is_ia32 always true for X86_32, or while emulating IA32 on X86_64

Randomization not supported on X86_32 in legacy layout.  Both layouts allow
randomization on X86_64.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Applies against the mm branch of the x86 tree which has Jiri's PIE rework included.

 arch/x86/mm/Makefile_32 |    2 +-
 arch/x86/mm/Makefile_64 |    3 +-
 arch/x86/mm/mmap.c      |  123 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/mmap_32.c   |   81 -------------------------------
 arch/x86/mm/mmap_64.c   |  116 --------------------------------------------
 5 files changed, 125 insertions(+), 200 deletions(-)

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
index 0000000..e3fddda
--- /dev/null
+++ b/arch/x86/mm/mmap.c
@@ -0,0 +1,123 @@
+/*
+ * Flexible mmap layout support
+ *
+ * Based on code by Ingo Molnar and Andi Kleen, copyrighted
+ * as follows:
+ *
+ * Copyright 2003-2004 Red Hat Inc., Durham, North Carolina.
+ * All Rights Reserved.
+ * Copyright 2005 Andi Kleen, SUSE Labs.
+ * Copyright 2007 Jiri Kosina, SUSE Labs.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/personality.h>
+#include <linux/mm.h>
+#include <linux/random.h>
+#include <linux/limits.h>
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
+/*
+ * True on X86_32 or when emulating IA32 on X86_64
+ */
+static int mmap_is_ia32(void)
+{
+#ifdef X86_32
+	return 1;
+#endif
+#ifdef CONFIG_IA32_EMULATION
+	if (test_thread_flag(TIF_IA32))
+		return 1;
+#endif
+	return 0;
+}
+
+static int mmap_is_legacy(void)
+{
+	if (current->personality & ADDR_COMPAT_LAYOUT)
+		return 1;
+
+	if (current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY)
+		return 1;
+
+	return sysctl_legacy_va_layout;
+}
+
+static unsigned long mmap_rnd(void)
+{
+	unsigned long rnd = 0;
+
+	/*
+	*  8 bits of randomness in 32bit mmaps, 20 address space bits
+	* 28 bits of randomness in 64bit mmaps, 40 address space bits
+	*/
+	if (current->flags & PF_RANDOMIZE) {
+		if (mmap_is_ia32())
+			rnd = (long)get_random_int() % (1<<8);
+		else
+			rnd = (long)(get_random_int() % (1<<28));
+	}
+	return rnd << PAGE_SHIFT;
+}
+
+static unsigned long mmap_base(void)
+{
+	unsigned long gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
+
+	if (gap < MIN_GAP)
+		gap = MIN_GAP;
+	else if (gap > MAX_GAP)
+		gap = MAX_GAP;
+
+	return PAGE_ALIGN(TASK_SIZE - gap - mmap_rnd());
+}
+
+/*
+ * Bottom-up (legacy) layout on X86_32 did not support randomization, X86_64
+ * does, but not when emulating X86_32
+ */
+static unsigned long mmap_legacy_base(void)
+{
+	if (mmap_is_ia32())
+		return TASK_UNMAPPED_BASE;
+	else
+		return TASK_UNMAPPED_BASE + mmap_rnd();
+}
+
+/*
+ * This function, called very early during the creation of a new
+ * process VM image, sets up which VM layout function to use:
+ */
+void arch_pick_mmap_layout(struct mm_struct *mm)
+{
+	if (mmap_is_legacy()) {
+		mm->mmap_base = mmap_legacy_base();
+		mm->get_unmapped_area = arch_get_unmapped_area;
+		mm->unmap_area = arch_unmap_area;
+	} else {
+		mm->mmap_base = mmap_base();
+		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		mm->unmap_area = arch_unmap_area_topdown;
+	}
+}
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
index 119bf34..0000000
--- a/arch/x86/mm/mmap_64.c
+++ /dev/null
@@ -1,116 +0,0 @@
-/*
- *  linux/arch/x86-64/mm/mmap.c
- *
- *  flexible mmap layout support
- *
- * Based on code by Ingo Molnar and Andi Kleen, copyrighted
- * as follows:
- *
- * Copyright 2003-2004 Red Hat Inc., Durham, North Carolina.
- * All Rights Reserved.
- * Copyright 2005 Andi Kleen, SUSE Labs.
- * Copyright 2007 Jiri Kosina, SUSE Labs.
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
- */
-
-#include <linux/personality.h>
-#include <linux/mm.h>
-#include <linux/random.h>
-#include <linux/limits.h>
-#include <linux/sched.h>
-#include <asm/ia32.h>
-
-/*
- * Top of mmap area (just below the process stack).
- *
- * Leave an at least ~128 MB hole.
- */
-#define MIN_GAP (128*1024*1024)
-#define MAX_GAP (TASK_SIZE/6*5)
-
-static unsigned long mmap_base(void)
-{
-	unsigned long gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
-
-	if (gap < MIN_GAP)
-		gap = MIN_GAP;
-	else if (gap > MAX_GAP)
-		gap = MAX_GAP;
-
-	return TASK_SIZE - (gap & PAGE_MASK);
-}
-
-static int mmap_is_32(void)
-{
-#ifdef CONFIG_IA32_EMULATION
-	if (test_thread_flag(TIF_IA32))
-		return 1;
-#endif
-	return 0;
-}
-
-static int mmap_is_legacy(void)
-{
-	if (current->personality & ADDR_COMPAT_LAYOUT)
-		return 1;
-
-	if (current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY)
-		return 1;
-
-	return sysctl_legacy_va_layout;
-}
-
-/*
- * This function, called very early during the creation of a new
- * process VM image, sets up which VM layout function to use:
- */
-void arch_pick_mmap_layout(struct mm_struct *mm)
-{
-	int rnd = 0;
-	if (current->flags & PF_RANDOMIZE) {
-		/*
-		 * Add 28bit randomness which is about 40bits of address space
-		 * because mmap base has to be page aligned.
-		 * or ~1/128 of the total user VM
-		 * (total user address space is 47bits)
-		 */
-		rnd = get_random_int() & 0xfffffff;
-	}
-
-	/*
-	 * Fall back to the standard layout if the personality
-	 * bit is set, or if the expected stack growth is unlimited:
-	 */
-	if (mmap_is_32()) {
-#ifdef CONFIG_IA32_EMULATION
-		/* ia32_pick_mmap_layout has its own. */
-		return ia32_pick_mmap_layout(mm);
-#endif
-	} else if (mmap_is_legacy()) {
-		mm->mmap_base = TASK_UNMAPPED_BASE;
-		mm->get_unmapped_area = arch_get_unmapped_area;
-		mm->unmap_area = arch_unmap_area;
-	} else {
-		mm->mmap_base = mmap_base();
-		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
-		mm->unmap_area = arch_unmap_area_topdown;
-		if (current->flags & PF_RANDOMIZE)
-			rnd = -rnd;
-	}
-	if (current->flags & PF_RANDOMIZE)
-		mm->mmap_base += ((long)rnd) << PAGE_SHIFT;
-}
-- 
1.5.3.7.2212.gd092




Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbXLDUxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbXLDUxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbXLDUwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:52:34 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:53172 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbXLDUwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:52:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bFQlvHvxBJl/nQvu3NvUEFsT75oBLdSkBDoc5KvFEw+8G4La3HmeiwllbzlIOOlCnxP4/Tvu9YD+fFMttT/cnqEHvCd7+o+GMFMv2GdaBeDOhPfJ/ayQy1BBNvgI4WEY3I76lKkFANdPwXbrhDr/sz+n5DFrv9J3BgNzdD8moxs=
Subject: [RFC PATCH] Unify mmap_[32|64].c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 12:52:33 -0800
Message-Id: <1196801553.10408.24.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Unify mmap_32.c mmap_64.c

Start from mmap_32.c and add X86_64 specific function as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Just a preliminary patch to see if this is an acceptable approach, tested
only on X86_32 at the moment.  Suggestions welcome.  Further iterations can
start to make it a bit cleaner.

 arch/x86/mm/Makefile_32           |    2 +-
 arch/x86/mm/Makefile_64           |    3 +-
 arch/x86/mm/{mmap_32.c => mmap.c} |   57 ++++++++++++++++++++-----------------
 arch/x86/mm/mmap_64.c             |   32 --------------------
 4 files changed, 33 insertions(+), 61 deletions(-)

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
diff --git a/arch/x86/mm/mmap_32.c b/arch/x86/mm/mmap.c
similarity index 62%
rename from arch/x86/mm/mmap_32.c
rename to arch/x86/mm/mmap.c
index d490662..0462f11 100644
--- a/arch/x86/mm/mmap_32.c
+++ b/arch/x86/mm/mmap.c
@@ -1,30 +1,12 @@
 /*
- *  linux/arch/i386/mm/mmap.c
- *
- *  flexible mmap layout support
+ * Combined x86 flexible mmap layout support
  *
+ * Started by Ingo Molnar <mingo@elte.hu>
  * Copyright 2003-2004 Red Hat Inc., Durham, North Carolina.
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
+ * Copyright 2005 Andi Kleen, SuSE Labs.
  *
- *
- * Started by Ingo Molnar <mingo@elte.hu>
  */
 
-#include <linux/personality.h>
 #include <linux/mm.h>
 #include <linux/random.h>
 #include <linux/sched.h>
@@ -57,11 +39,7 @@ static inline unsigned long mmap_base(struct mm_struct *mm)
  * This function, called very early during the creation of a new
  * process VM image, sets up which VM layout function to use:
  */
-#ifdef CONFIG_X86_32
-void arch_pick_mmap_layout(struct mm_struct *mm)
-#else
-void ia32_pick_mmap_layout(struct mm_struct *mm)
-#endif
+static void ia32_pick_mmap_layout(struct mm_struct *mm)
 {
 	/*
 	 * Fall back to the standard layout if the personality
@@ -79,3 +57,30 @@ void ia32_pick_mmap_layout(struct mm_struct *mm)
 		mm->unmap_area = arch_unmap_area_topdown;
 	}
 }
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



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYKBCYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYKBCYn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYKBCXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:23:45 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:34656 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYKBCXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:23:43 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: glommer@redhat.com, mingo@elte.hu
Subject: [PATCH 3/6] x86: define reserve_top_address for x86_64
Date: Sun,  2 Nov 2008 00:23:50 -0200
Message-Id: <1225592633-9948-4-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1225592633-9948-3-git-send-email-gustavo@las.ic.unicamp.br>
References: <1225592633-9948-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1225592633-9948-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1225592633-9948-3-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only for later x86 integration.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
Acked-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/include/asm/fixmap_64.h |    2 ++
 arch/x86/mm/pgtable.c            |   18 ++++++++++++++++++
 arch/x86/mm/pgtable_32.c         |   16 ----------------
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/fixmap_64.h b/arch/x86/include/asm/fixmap_64.h
index 678b9c5..773b657 100644
--- a/arch/x86/include/asm/fixmap_64.h
+++ b/arch/x86/include/asm/fixmap_64.h
@@ -72,6 +72,8 @@ enum fixed_addresses {
 	__end_of_fixed_addresses
 };
 
+extern void reserve_top_address(unsigned long reserve);
+
 #define FIXADDR_TOP	(VSYSCALL_END-PAGE_SIZE)
 
 #define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 86f2ffc..5b7c7c8 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -313,6 +313,24 @@ int ptep_clear_flush_young(struct vm_area_struct *vma,
 	return young;
 }
 
+/**
+ * reserve_top_address - reserves a hole in the top of kernel address space
+ * @reserve - size of hole to reserve
+ *
+ * Can be used to relocate the fixmap area and poke a hole in the top
+ * of kernel address space to make room for a hypervisor.
+ */
+void __init reserve_top_address(unsigned long reserve)
+{
+#ifdef CONFIG_X86_32
+	BUG_ON(fixmaps_set > 0);
+	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
+	       (int)-reserve);
+	__FIXADDR_TOP = -reserve - PAGE_SIZE;
+	__VMALLOC_RESERVE += reserve;
+#endif
+}
+
 int fixmaps_set;
 
 void __native_set_fixmap(enum fixed_addresses idx, pte_t pte)
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 0951db9..c3cf6e1 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -97,22 +97,6 @@ void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags)
 unsigned long __FIXADDR_TOP = 0xfffff000;
 EXPORT_SYMBOL(__FIXADDR_TOP);
 
-/**
- * reserve_top_address - reserves a hole in the top of kernel address space
- * @reserve - size of hole to reserve
- *
- * Can be used to relocate the fixmap area and poke a hole in the top
- * of kernel address space to make room for a hypervisor.
- */
-void __init reserve_top_address(unsigned long reserve)
-{
-	BUG_ON(fixmaps_set > 0);
-	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
-	       (int)-reserve);
-	__FIXADDR_TOP = -reserve - PAGE_SIZE;
-	__VMALLOC_RESERVE += reserve;
-}
-
 /*
  * vmalloc=size forces the vmalloc area to be exactly 'size'
  * bytes. This can be used to increase (or decrease) the
-- 
1.5.6.4


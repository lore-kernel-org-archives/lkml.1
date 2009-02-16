Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbZBPAvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbZBPAvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZBPAuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:50:25 -0500
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:41745 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbZBPAuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:50:24 -0500
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: mingo@elte.hu
Cc: glommer@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] x86: define reserve_top_address for x86_64
Date: Sun, 15 Feb 2009 21:48:54 -0300
Message-Id: <1234745339-18587-4-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1234745339-18587-3-git-send-email-gustavo@las.ic.unicamp.br>
References: <1234745339-18587-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1234745339-18587-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1234745339-18587-3-git-send-email-gustavo@las.ic.unicamp.br>
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
index d905de0..b6c06dd 100644
--- a/arch/x86/include/asm/fixmap_64.h
+++ b/arch/x86/include/asm/fixmap_64.h
@@ -68,6 +68,8 @@ enum fixed_addresses {
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
1.6.0.6


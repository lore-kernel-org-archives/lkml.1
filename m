Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbZHaKFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbZHaKFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZHaKFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:05:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53436 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbZHaKE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:04:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 Aug 2009 19:03:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       benh@kernel.crashing.org, ralf@linux-mips.org, xiyou.wangcong@gmail.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       jirislaby@gmail.com
Subject: [PATCH 2/8][mmotm] kcore add kclist types
Message-Id: <20090831190302.87be5322.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090831190024.fadc3b50.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090831190024.fadc3b50.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Presently, kclist_add() only eats start address and size as its arguments.
 Considering to make kclist dynamically reconfigulable, it's necessary to
know which kclists are for System RAM and which are not.

This patch add kclist types as
  KCORE_RAM
  KCORE_VMALLOC
  KCORE_TEXT
  KCORE_OTHER

This "type" is used in a patch following this for detecting KCORE_RAM.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c       |    7 ++++---
 arch/mips/mm/init.c       |    7 ++++---
 arch/powerpc/mm/init_32.c |    4 ++--
 arch/powerpc/mm/init_64.c |    5 +++--
 arch/sh/mm/init.c         |    4 ++--
 arch/x86/mm/init_32.c     |    4 ++--
 arch/x86/mm/init_64.c     |   11 ++++++-----
 fs/proc/kcore.c           |    3 ++-
 include/linux/proc_fs.h   |   13 +++++++++++--
 9 files changed, 36 insertions(+), 22 deletions(-)

Index: mmotm-2.6.31-Aug27/arch/ia64/mm/init.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/ia64/mm/init.c
+++ mmotm-2.6.31-Aug27/arch/ia64/mm/init.c
@@ -639,9 +639,10 @@ mem_init (void)
 
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE);
-	kclist_add(&kcore_vmem, (void *)VMALLOC_START, VMALLOC_END-VMALLOC_START);
-	kclist_add(&kcore_kernel, _stext, _end - _stext);
+	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE, KCORE_RAM);
+	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
+			VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
+	kclist_add(&kcore_kernel, _stext, _end - _stext, KCORE_TEXT);
 
 	for_each_online_pgdat(pgdat)
 		if (pgdat->bdata->node_bootmem_map)
Index: mmotm-2.6.31-Aug27/arch/mips/mm/init.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/mips/mm/init.c
+++ mmotm-2.6.31-Aug27/arch/mips/mm/init.c
@@ -409,11 +409,12 @@ void __init mem_init(void)
 	if ((unsigned long) &_text > (unsigned long) CKSEG0)
 		/* The -4 is a hack so that user tools don't have to handle
 		   the overflow.  */
-		kclist_add(&kcore_kseg0, (void *) CKSEG0, 0x80000000 - 4);
+		kclist_add(&kcore_kseg0, (void *) CKSEG0,
+				0x80000000 - 4, KCORE_TEXT);
 #endif
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
-		   VMALLOC_END-VMALLOC_START);
+		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
 	       "%ldk reserved, %ldk data, %ldk init, %ldk highmem)\n",
Index: mmotm-2.6.31-Aug27/arch/powerpc/mm/init_32.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/powerpc/mm/init_32.c
+++ mmotm-2.6.31-Aug27/arch/powerpc/mm/init_32.c
@@ -268,11 +268,11 @@ static int __init setup_kcore(void)
 						size);
 		}
 
-		kclist_add(kcore_mem, __va(base), size);
+		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
 	}
 
 	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
-		VMALLOC_END-VMALLOC_START);
+		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
 	return 0;
 }
Index: mmotm-2.6.31-Aug27/arch/powerpc/mm/init_64.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/powerpc/mm/init_64.c
+++ mmotm-2.6.31-Aug27/arch/powerpc/mm/init_64.c
@@ -128,10 +128,11 @@ static int __init setup_kcore(void)
 		if (!kcore_mem)
 			panic("%s: kmalloc failed\n", __func__);
 
-		kclist_add(kcore_mem, __va(base), size);
+		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
 	}
 
-	kclist_add(&kcore_vmem, (void *)VMALLOC_START, VMALLOC_END-VMALLOC_START);
+	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
+		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
 	return 0;
 }
Index: mmotm-2.6.31-Aug27/arch/sh/mm/init.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/sh/mm/init.c
+++ mmotm-2.6.31-Aug27/arch/sh/mm/init.c
@@ -218,9 +218,9 @@ void __init mem_init(void)
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
-		   VMALLOC_END - VMALLOC_START);
+		   VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 	       "%dk data, %dk init)\n",
Index: mmotm-2.6.31-Aug27/arch/x86/mm/init_32.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/x86/mm/init_32.c
+++ mmotm-2.6.31-Aug27/arch/x86/mm/init_32.c
@@ -886,9 +886,9 @@ void __init mem_init(void)
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
-		   VMALLOC_END-VMALLOC_START);
+		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 			"%dk reserved, %dk data, %dk init, %ldk highmem)\n",
Index: mmotm-2.6.31-Aug27/arch/x86/mm/init_64.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/x86/mm/init_64.c
+++ mmotm-2.6.31-Aug27/arch/x86/mm/init_64.c
@@ -677,13 +677,14 @@ void __init mem_init(void)
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	/* Register memory areas for /proc/kcore */
-	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
-		   VMALLOC_END-VMALLOC_START);
-	kclist_add(&kcore_kernel, &_stext, _end - _stext);
-	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN);
+		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
+	kclist_add(&kcore_kernel, &_stext, _end - _stext, KCORE_TEXT);
+	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN,
+			KCORE_OTHER);
 	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START,
-				 VSYSCALL_END - VSYSCALL_START);
+			 VSYSCALL_END - VSYSCALL_START, KCORE_OTHER);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
 			 "%ldk absent, %ldk reserved, %ldk data, %ldk init)\n",
Index: mmotm-2.6.31-Aug27/fs/proc/kcore.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/fs/proc/kcore.c
+++ mmotm-2.6.31-Aug27/fs/proc/kcore.c
@@ -62,10 +62,11 @@ static LIST_HEAD(kclist_head);
 static DEFINE_RWLOCK(kclist_lock);
 
 void
-kclist_add(struct kcore_list *new, void *addr, size_t size)
+kclist_add(struct kcore_list *new, void *addr, size_t size, int type)
 {
 	new->addr = (unsigned long)addr;
 	new->size = size;
+	new->type = type;
 
 	write_lock(&kclist_lock);
 	list_add_tail(&new->list, &kclist_head);
Index: mmotm-2.6.31-Aug27/include/linux/proc_fs.h
===================================================================
--- mmotm-2.6.31-Aug27.orig/include/linux/proc_fs.h
+++ mmotm-2.6.31-Aug27/include/linux/proc_fs.h
@@ -78,10 +78,18 @@ struct proc_dir_entry {
 	struct list_head pde_openers;	/* who did ->open, but not ->release */
 };
 
+enum kcore_type {
+	KCORE_TEXT,
+	KCORE_VMALLOC,
+	KCORE_RAM,
+	KCORE_OTHER,
+};
+
 struct kcore_list {
 	struct list_head list;
 	unsigned long addr;
 	size_t size;
+	int type;
 };
 
 struct vmcore {
@@ -233,11 +241,12 @@ static inline void dup_mm_exe_file(struc
 #endif /* CONFIG_PROC_FS */
 
 #if !defined(CONFIG_PROC_KCORE)
-static inline void kclist_add(struct kcore_list *new, void *addr, size_t size)
+static inline void
+kclist_add(struct kcore_list *new, void *addr, size_t size, int type)
 {
 }
 #else
-extern void kclist_add(struct kcore_list *, void *, size_t);
+extern void kclist_add(struct kcore_list *, void *, size_t, int type);
 #endif
 
 union proc_op {


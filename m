Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbZCCLPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbZCCLPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbZCCLPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:15:12 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37911 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZCCLPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:15:08 -0500
Subject: [PATCH 3/3] x86: unify free_init_pages() and free_initmem()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2009 13:15:06 +0200
Message-Id: <1236078906.2675.18.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: unification

This patch introduces a common arch/x86/mm/init.c and moves the identical
free_init_pages() and free_initmem() functions to the file.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/Makefile  |    2 +-
 arch/x86/mm/init.c    |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/init_32.c |   44 --------------------------------------------
 arch/x86/mm/init_64.c |   44 --------------------------------------------
 4 files changed, 50 insertions(+), 89 deletions(-)
 create mode 100644 arch/x86/mm/init.c

diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index d8cc96a..7acf85d 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,4 +1,4 @@
-obj-y	:=  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
+obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
 	    pat.o pgtable.o gup.o
 
 obj-$(CONFIG_X86_32)		+= pgtable_32.o iomap_32.o
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
new file mode 100644
index 0000000..ce6a722
--- /dev/null
+++ b/arch/x86/mm/init.c
@@ -0,0 +1,49 @@
+#include <linux/swap.h>
+#include <asm/cacheflush.h>
+#include <asm/page.h>
+#include <asm/sections.h>
+#include <asm/system.h>
+
+void free_init_pages(char *what, unsigned long begin, unsigned long end)
+{
+	unsigned long addr = begin;
+
+	if (addr >= end)
+		return;
+
+	/*
+	 * If debugging page accesses then do not free this memory but
+	 * mark them not present - any buggy init-section access will
+	 * create a kernel page fault:
+	 */
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	printk(KERN_INFO "debug: unmapping init memory %08lx..%08lx\n",
+		begin, PAGE_ALIGN(end));
+	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
+#else
+	/*
+	 * We just marked the kernel text read only above, now that
+	 * we are going to free part of that, we need to make that
+	 * writeable first.
+	 */
+	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
+
+	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
+
+	for (; addr < end; addr += PAGE_SIZE) {
+		ClearPageReserved(virt_to_page(addr));
+		init_page_count(virt_to_page(addr));
+		memset((void *)(addr & ~(PAGE_SIZE-1)),
+			POISON_FREE_INITMEM, PAGE_SIZE);
+		free_page(addr);
+		totalram_pages++;
+	}
+#endif
+}
+
+void free_initmem(void)
+{
+	free_init_pages("unused kernel memory",
+			(unsigned long)(&__init_begin),
+			(unsigned long)(&__init_end));
+}
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index ee4b032..6fbf39f 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1191,50 +1191,6 @@ void mark_rodata_ro(void)
 }
 #endif
 
-void free_init_pages(char *what, unsigned long begin, unsigned long end)
-{
-	unsigned long addr = begin;
-
-	if (addr >= end)
-		return;
-
-	/*
-	 * If debugging page accesses then do not free this memory but
-	 * mark them not present - any buggy init-section access will
-	 * create a kernel page fault:
-	 */
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk(KERN_INFO "debug: unmapping init memory %08lx..%08lx\n",
-		begin, PAGE_ALIGN(end));
-	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
-#else
-	/*
-	 * We just marked the kernel text read only above, now that
-	 * we are going to free part of that, we need to make that
-	 * writeable first.
-	 */
-	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
-
-	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
-
-	for (; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		memset((void *)(addr & ~(PAGE_SIZE-1)),
-			POISON_FREE_INITMEM, PAGE_SIZE);
-		free_page(addr);
-		totalram_pages++;
-	}
-#endif
-}
-
-void free_initmem(void)
-{
-	free_init_pages("unused kernel memory",
-			(unsigned long)(&__init_begin),
-			(unsigned long)(&__init_end));
-}
-
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 03da903..aae8745 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -945,50 +945,6 @@ void __init mem_init(void)
 		initsize >> 10);
 }
 
-void free_init_pages(char *what, unsigned long begin, unsigned long end)
-{
-	unsigned long addr = begin;
-
-	if (addr >= end)
-		return;
-
-	/*
-	 * If debugging page accesses then do not free this memory but
-	 * mark them not present - any buggy init-section access will
-	 * create a kernel page fault:
-	 */
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk(KERN_INFO "debug: unmapping init memory %08lx..%08lx\n",
-		begin, PAGE_ALIGN(end));
-	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
-#else
-	/*
-	 * We just marked the kernel text read only above, now that
-	 * we are going to free part of that, we need to make that
-	 * writeable first.
-	 */
-	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
-
-	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
-
-	for (; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		memset((void *)(addr & ~(PAGE_SIZE-1)),
-			POISON_FREE_INITMEM, PAGE_SIZE);
-		free_page(addr);
-		totalram_pages++;
-	}
-#endif
-}
-
-void free_initmem(void)
-{
-	free_init_pages("unused kernel memory",
-			(unsigned long)(&__init_begin),
-			(unsigned long)(&__init_end));
-}
-
 #ifdef CONFIG_DEBUG_RODATA
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
-- 
1.5.4.3




Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbYD3BbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbYD3BbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 21:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbYD3BbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 21:31:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:14602 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564AbYD3BbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 21:31:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,725,1199692800"; 
   d="scan'208";a="322824163"
Date: Tue, 29 Apr 2008 18:31:09 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] /dev/mem gcc weak function workaround
Message-ID: <20080430013108.GA18207@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some flavors of gcc 4.1.0 and 4.1.1 seems to have trouble understanding
weak function definitions. Calls to function from the same file where it is
defined as weak _may_ get inlined, even when there is a non-weak definition of
the function elsewhere. I tried using attribute 'noinline' which does not
seem to help either.

One workaround for this is to have weak functions defined in different
file as below. Other possible way is to not use weak functions and go back
to ifdef logic.

There are few other usages in kernel that seem to depend on weak (and noinline)
working correctly, which can also potentially break and needs such workarounds.
Example -
mach_reboot_fixups() in arch/x86/kernel/reboot.c is one such call which
is getting inlined with a flavor of gcc 4.1.1.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 drivers/char/Makefile     |    2 +-
 drivers/char/mem.c        |   23 +----------------------
 drivers/char/mem_weak.c   |   25 +++++++++++++++++++++++++
 include/asm-x86/io.h      |    1 -
 include/asm-x86/pgtable.h |    2 --
 include/linux/mmap.h      |   15 +++++++++++++++
 6 files changed, 42 insertions(+), 26 deletions(-)

Index: linux-2.6/drivers/char/mem_weak.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/char/mem_weak.c	2008-04-29 18:14:10.000000000 -0700
@@ -0,0 +1,25 @@
+
+#include <linux/mmap.h>
+
+void __attribute__((weak)) unxlate_dev_mem_ptr(unsigned long phys, void *addr)
+{
+}
+
+int __attribute__((weak)) phys_mem_access_prot_allowed(struct file *file,
+	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
+{
+	return 1;
+}
+
+void __attribute__((weak))
+map_devmem(unsigned long pfn, unsigned long len, pgprot_t prot)
+{
+	/* nothing. architectures can override. */
+}
+
+void __attribute__((weak))
+unmap_devmem(unsigned long pfn, unsigned long len, pgprot_t prot)
+{
+	/* nothing. architectures can override. */
+}
+
Index: linux-2.6/drivers/char/mem.c
===================================================================
--- linux-2.6.orig/drivers/char/mem.c	2008-04-29 18:12:14.000000000 -0700
+++ linux-2.6/drivers/char/mem.c	2008-04-29 18:14:43.000000000 -0700
@@ -26,6 +26,7 @@
 #include <linux/bootmem.h>
 #include <linux/splice.h>
 #include <linux/pfn.h>
+#include <linux/mmap.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -105,10 +106,6 @@ static inline int range_is_allowed(unsig
 }
 #endif
 
-void __attribute__((weak)) unxlate_dev_mem_ptr(unsigned long phys, void *addr)
-{
-}
-
 /*
  * This funcion reads the *physical* memory. The f_pos points directly to the 
  * memory location. 
@@ -254,12 +251,6 @@ static ssize_t write_mem(struct file * f
 	return written;
 }
 
-int __attribute__((weak)) phys_mem_access_prot_allowed(struct file *file,
-	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
-{
-	return 1;
-}
-
 #ifndef __HAVE_PHYS_MEM_ACCESS_PROT
 static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				     unsigned long size, pgprot_t vma_prot)
@@ -300,18 +291,6 @@ static inline int private_mapping_ok(str
 }
 #endif
 
-void __attribute__((weak))
-map_devmem(unsigned long pfn, unsigned long len, pgprot_t prot)
-{
-	/* nothing. architectures can override. */
-}
-
-void __attribute__((weak))
-unmap_devmem(unsigned long pfn, unsigned long len, pgprot_t prot)
-{
-	/* nothing. architectures can override. */
-}
-
 static void mmap_mem_open(struct vm_area_struct *vma)
 {
 	map_devmem(vma->vm_pgoff,  vma->vm_end - vma->vm_start,
Index: linux-2.6/include/linux/mmap.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/linux/mmap.h	2008-04-29 18:14:10.000000000 -0700
@@ -0,0 +1,15 @@
+#ifndef _LINUX_MMAP_H
+#define _LINUX_MMAP_H
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+extern void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
+
+extern int phys_mem_access_prot_allowed(struct file *file,
+	unsigned long pfn, unsigned long size, pgprot_t *vma_prot);
+
+extern void map_devmem(unsigned long pfn, unsigned long len, pgprot_t prot);
+extern void unmap_devmem(unsigned long pfn, unsigned long len, pgprot_t prot);
+
+#endif /* _LINUX_MMAP_H */
Index: linux-2.6/include/asm-x86/io.h
===================================================================
--- linux-2.6.orig/include/asm-x86/io.h	2008-04-29 17:27:43.000000000 -0700
+++ linux-2.6/include/asm-x86/io.h	2008-04-29 18:14:10.000000000 -0700
@@ -10,7 +10,6 @@
 #endif
 
 extern void *xlate_dev_mem_ptr(unsigned long phys);
-extern void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
 
 extern int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 				unsigned long prot_val);
Index: linux-2.6/include/asm-x86/pgtable.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pgtable.h	2008-04-29 17:27:43.000000000 -0700
+++ linux-2.6/include/asm-x86/pgtable.h	2008-04-29 18:14:10.000000000 -0700
@@ -303,8 +303,6 @@ static inline pte_t pte_modify(pte_t pte
 struct file;
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
                               unsigned long size, pgprot_t vma_prot);
-int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
-                              unsigned long size, pgprot_t *vma_prot);
 #endif
 
 #ifdef CONFIG_PARAVIRT
Index: linux-2.6/drivers/char/Makefile
===================================================================
--- linux-2.6.orig/drivers/char/Makefile	2008-04-29 18:12:14.000000000 -0700
+++ linux-2.6/drivers/char/Makefile	2008-04-29 18:14:43.000000000 -0700
@@ -7,7 +7,7 @@
 #
 FONTMAPFILE = cp437.uni
 
-obj-y	 += mem.o random.o tty_io.o n_tty.o tty_ioctl.o
+obj-y	 += mem.o mem_weak.o random.o tty_io.o n_tty.o tty_ioctl.o
 
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o

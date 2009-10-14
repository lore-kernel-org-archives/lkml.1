Return-Path: <linux-kernel-owner+w=401wt.eu-S932490AbZJNWGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbZJNWGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932324AbZJNWGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:06:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:48240 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbZJNWGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:06:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,561,1249282800"; 
   d="scan'208";a="457521986"
Message-Id: <20091014220254.190119924@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 14 Oct 2009 14:46:56 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, arjan@linux.jf.intel.com
Cc: linux-kernel@vger.kernel.org, chinang.ma@intel.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/2] x86_64: align RODATA kernel section to 2MB with CONFIG_DEBUG_RODATA
References: <20091014214654.423040927@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=align_rodata_hpage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_DEBUG_RODATA chops the large pages spanning boundaries of kernel
text/rodata/data to small 4KB pages as they are mapped with different
attributes (text as RO, RODATA as RO and NX etc).

On x86_64, preserve the large page mappings for kernel text/rodata/data
boundaries when CONFIG_DEBUG_RODATA is enabled. This is done by allowing the
RODATA section to be hugepage aligned and having same RWX attributes
for the 2MB page boundaries

Extra Memory pages padding the sections will be freed during the end of the boot
and the kernel identity mappings will have different RWX permissions compared to
the kernel text mappings.

Kernel identity mappings to these physical pages will be mapped with smaller
pages but large page mappings are still retained for kernel text,rodata,data
mappings.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/sections.h |    6 ++++++
 arch/x86/kernel/vmlinux.lds.S   |   17 +++++++++++++++++
 arch/x86/mm/init_64.c           |   14 +++++++++++++-
 arch/x86/mm/pageattr.c          |   14 ++++++++++++++
 4 files changed, 50 insertions(+), 1 deletion(-)

Index: tree/arch/x86/include/asm/sections.h
===================================================================
--- tree.orig/arch/x86/include/asm/sections.h
+++ tree/arch/x86/include/asm/sections.h
@@ -2,7 +2,13 @@
 #define _ASM_X86_SECTIONS_H
 
 #include <asm-generic/sections.h>
+#include <asm/uaccess.h>
 
 extern char __brk_base[], __brk_limit[];
+extern struct exception_table_entry __stop___ex_table[];
+
+#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
+extern char __end_rodata_hpage_align[];
+#endif
 
 #endif	/* _ASM_X86_SECTIONS_H */
Index: tree/arch/x86/kernel/vmlinux.lds.S
===================================================================
--- tree.orig/arch/x86/kernel/vmlinux.lds.S
+++ tree/arch/x86/kernel/vmlinux.lds.S
@@ -41,6 +41,21 @@ ENTRY(phys_startup_64)
 jiffies_64 = jiffies;
 #endif
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
+
+#define X64_ALIGN_DEBUG_RODATA_BEGIN	. = ALIGN(HPAGE_SIZE);
+
+#define X64_ALIGN_DEBUG_RODATA_END				\
+		. = ALIGN(HPAGE_SIZE);				\
+		__end_rodata_hpage_align = .;
+
+#else
+
+#define X64_ALIGN_DEBUG_RODATA_BEGIN
+#define X64_ALIGN_DEBUG_RODATA_END
+
+#endif
+
 PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
 	data PT_LOAD FLAGS(7);          /* RWE */
@@ -90,7 +105,9 @@ SECTIONS
 
 	EXCEPTION_TABLE(16) :text = 0x9090
 
+	X64_ALIGN_DEBUG_RODATA_BEGIN
 	RO_DATA(PAGE_SIZE)
+	X64_ALIGN_DEBUG_RODATA_END
 
 	/* Data */
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
Index: tree/arch/x86/mm/init_64.c
===================================================================
--- tree.orig/arch/x86/mm/init_64.c
+++ tree/arch/x86/mm/init_64.c
@@ -726,9 +726,13 @@ void set_kernel_text_ro(void)
 
 void mark_rodata_ro(void)
 {
-	unsigned long start = PFN_ALIGN(_text), end = PFN_ALIGN(__end_rodata);
+	unsigned long start = PFN_ALIGN(_text);
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
+	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
+	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
+	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
+	unsigned long data_start = (unsigned long) &_sdata;
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -751,6 +755,14 @@ void mark_rodata_ro(void)
 	printk(KERN_INFO "Testing CPA: again\n");
 	set_memory_ro(start, (end-start) >> PAGE_SHIFT);
 #endif
+
+	free_init_pages("unused kernel memory",
+			(unsigned long) page_address(virt_to_page(text_end)),
+			(unsigned long)
+				 page_address(virt_to_page(rodata_start)));
+	free_init_pages("unused kernel memory",
+			(unsigned long) page_address(virt_to_page(rodata_end)),
+			(unsigned long) page_address(virt_to_page(data_start)));
 }
 
 #endif
Index: tree/arch/x86/mm/pageattr.c
===================================================================
--- tree.orig/arch/x86/mm/pageattr.c
+++ tree/arch/x86/mm/pageattr.c
@@ -279,6 +279,20 @@ static inline pgprot_t static_protection
 		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_RW;
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
+	/*
+	 * Kernel text mappings for the large page aligned .rodata section
+	 * will be read-only. For the kernel identity mappings covering
+	 * the holes caused by this alignment can be anything.
+	 *
+	 * This will preserve the large page mappings for kernel text/data
+	 * at no extra cost.
+	 */
+	if (within(address, (unsigned long)_text,
+		   (unsigned long)__end_rodata_hpage_align))
+		pgprot_val(forbidden) |= _PAGE_RW;
+#endif
+
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
 
 	return prot;



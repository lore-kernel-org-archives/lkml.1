Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbZJXBEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbZJXBEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZJXBES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:04:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:51532 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZJXBD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:03:59 -0400
Date: Sat, 24 Oct 2009 01:03:41 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20091014220254.190119924@sbs-t61.sc.intel.com>
References: <20091014220254.190119924@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] x86-64: align RODATA kernel section to 2MB with CONFIG_DEBUG_RODATA
Message-ID: <tip-74e081797bd9d2a7d8005fe519e719df343a2ba8@git.kernel.org>
Git-Commit-ID: 74e081797bd9d2a7d8005fe519e719df343a2ba8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74e081797bd9d2a7d8005fe519e719df343a2ba8
Gitweb:     http://git.kernel.org/tip/74e081797bd9d2a7d8005fe519e719df343a2ba8
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 14 Oct 2009 14:46:56 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 20 Oct 2009 14:46:00 +0900

x86-64: align RODATA kernel section to 2MB with CONFIG_DEBUG_RODATA

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
LKML-Reference: <20091014220254.190119924@sbs-t61.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/sections.h |    6 ++++++
 arch/x86/kernel/vmlinux.lds.S   |   17 +++++++++++++++++
 arch/x86/mm/init_64.c           |   14 +++++++++++++-
 arch/x86/mm/pageattr.c          |   14 ++++++++++++++
 4 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/sections.h b/arch/x86/include/asm/sections.h
index 1b7ee5d..0a52424 100644
--- a/arch/x86/include/asm/sections.h
+++ b/arch/x86/include/asm/sections.h
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
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 92929fb..1476379 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
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
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 7dafd41..0ed09fa 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -727,9 +727,13 @@ void set_kernel_text_ro(void)
 
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
@@ -752,6 +756,14 @@ void mark_rodata_ro(void)
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
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index dd38bfb..b494fc4 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -279,6 +279,20 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
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

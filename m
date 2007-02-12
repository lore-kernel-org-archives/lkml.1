Return-Path: <linux-kernel-owner+w=401wt.eu-S933072AbXBLHht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbXBLHht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933074AbXBLHht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:37:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:38357 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933072AbXBLHhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:37:48 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20070212837.963446000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [1/39] i386: move startup_32() in text.head section
Date: Mon, 12 Feb 2007 08:37:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>

o Entry startup_32 was in .text section but it was accessing some init
  data too and it prompts MODPOST to generate compilation warnings.

WARNING: vmlinux - Section mismatch: reference to .init.data:boot_params from
.text between '_text' (at offset 0xc0100029) and 'startup_32_smp'
WARNING: vmlinux - Section mismatch: reference to .init.data:boot_params from
.text between '_text' (at offset 0xc0100037) and 'startup_32_smp'
WARNING: vmlinux - Section mismatch: reference to
.init.data:init_pg_tables_end from .text between '_text' (at offset
0xc0100099) and 'startup_32_smp'

o Can't move startup_32 to .init.text as this entry point has to be at the
  start of bzImage. Hence moved startup_32 to a new section .text.head and
  instructed MODPOST to not to generate warnings if init data is being
  accessed from .text.head section. This code has been audited.

o SMP boot up code (startup_32_smp) can go into .init.text if CPU hotplug
  is not supported. Otherwise it generates more warnings

WARNING: vmlinux - Section mismatch: reference to .init.data:new_cpu_data from
.text between 'checkCPUtype' (at offset 0xc0100126) and 'is486'
WARNING: vmlinux - Section mismatch: reference to .init.data:new_cpu_data from
.text between 'checkCPUtype' (at offset 0xc0100130) and 'is486'

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/head.S        |   17 ++++++++++++++---
 arch/i386/kernel/vmlinux.lds.S |    7 ++++++-
 scripts/mod/modpost.c          |   10 +++++++++-
 3 files changed, 29 insertions(+), 5 deletions(-)

Index: linux/arch/i386/kernel/head.S
===================================================================
--- linux.orig/arch/i386/kernel/head.S
+++ linux/arch/i386/kernel/head.S
@@ -53,6 +53,7 @@
  * any particular GDT layout, because we load our own as soon as we
  * can.
  */
+.section .text.head,"ax",@progbits
 ENTRY(startup_32)
 
 #ifdef CONFIG_PARAVIRT
@@ -141,16 +142,25 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	jb 10b
 	movl %edi,(init_pg_tables_end - __PAGE_OFFSET)
 
-#ifdef CONFIG_SMP
 	xorl %ebx,%ebx				/* This is the boot CPU (BSP) */
 	jmp 3f
-
 /*
  * Non-boot CPU entry point; entered from trampoline.S
  * We can't lgdt here, because lgdt itself uses a data segment, but
  * we know the trampoline has already loaded the boot_gdt_table GDT
  * for us.
+ *
+ * If cpu hotplug is not supported then this code can go in init section
+ * which will be freed later
  */
+
+#ifdef CONFIG_HOTPLUG_CPU
+.section .text,"ax",@progbits
+#else
+.section .init.text,"ax",@progbits
+#endif
+
+#ifdef CONFIG_SMP
 ENTRY(startup_32_smp)
 	cld
 	movl $(__BOOT_DS),%eax
@@ -208,8 +218,8 @@ ENTRY(startup_32_smp)
 	xorl %ebx,%ebx
 	incl %ebx
 
-3:
 #endif /* CONFIG_SMP */
+3:
 
 /*
  * Enable paging
@@ -492,6 +502,7 @@ ignore_int:
 #endif
 	iret
 
+.section .text
 #ifdef CONFIG_PARAVIRT
 startup_paravirt:
 	cld
Index: linux/arch/i386/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/i386/kernel/vmlinux.lds.S
+++ linux/arch/i386/kernel/vmlinux.lds.S
@@ -37,9 +37,14 @@ SECTIONS
 {
   . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
   phys_startup_32 = startup_32 - LOAD_OFFSET;
+
+  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
+  	_text = .;			/* Text and read-only data */
+	*(.text.head)
+  } :text = 0x9090
+
   /* read-only */
   .text : AT(ADDR(.text) - LOAD_OFFSET) {
-  	_text = .;			/* Text and read-only data */
 	*(.text)
 	SCHED_TEXT
 	LOCK_TEXT
Index: linux/scripts/mod/modpost.c
===================================================================
--- linux.orig/scripts/mod/modpost.c
+++ linux/scripts/mod/modpost.c
@@ -641,12 +641,20 @@ static int secref_whitelist(const char *
 	if (f1 && f2)
 		return 1;
 
-	/* Whitelist all references from .pci_fixup section if vmlinux */
+	/* Whitelist all references from .pci_fixup section if vmlinux
+	 * Whitelist all refereces from .text.head to .init.data if vmlinux
+	 * Whitelist all refereces from .text.head to .init.text if vmlinux
+	 */
 	if (is_vmlinux(modname)) {
 		if ((strcmp(fromsec, ".pci_fixup") == 0) &&
 		    (strcmp(tosec, ".init.text") == 0))
 		return 1;
 
+		if ((strcmp(fromsec, ".text.head") == 0) &&
+			((strcmp(tosec, ".init.data") == 0) ||
+			(strcmp(tosec, ".init.text") == 0)))
+		return 1;
+
 		/* Check for pattern 3 */
 		for (s = pat3refsym; *s; s++)
 			if (strcmp(refsymname, *s) == 0)

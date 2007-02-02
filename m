Return-Path: <linux-kernel-owner+w=401wt.eu-S1423185AbXBBOaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423185AbXBBOaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423156AbXBBOaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:30:09 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:51631 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423116AbXBBOaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:30:06 -0500
Date: Fri, 2 Feb 2007 15:30:05 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] Mark kernel text section read-only.
Message-ID: <20070202143005.GA4321@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Mark kernel text section read-only.

Set read-only flag in the page table entries for the kernel image text
section. This will catch all instruction caused corruptions withing the
text section.
Instruction replacement via kprobes still works, since it bypasses now
dynamic address translation.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/early.c       |    1 -
 arch/s390/kernel/kprobes.c     |   27 +++++++++++++++++++++++----
 arch/s390/kernel/vmlinux.lds.S |    3 ++-
 arch/s390/mm/init.c            |    9 ++++-----
 include/asm-s390/sections.h    |    2 ++
 5 files changed, 31 insertions(+), 11 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/early.c linux-2.6-patched/arch/s390/kernel/early.c
--- linux-2.6/arch/s390/kernel/early.c	2007-02-02 14:04:56.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/early.c	2007-02-02 14:04:56.000000000 +0100
@@ -27,7 +27,6 @@
 #define DEFSYS_CMD_SIZE		96
 #define SAVESYS_CMD_SIZE	32
 
-extern int _eshared;
 char kernel_nss_name[NSS_NAME_SIZE + 1];
 
 #ifdef CONFIG_SHARED_KERNEL
diff -urpN linux-2.6/arch/s390/kernel/kprobes.c linux-2.6-patched/arch/s390/kernel/kprobes.c
--- linux-2.6/arch/s390/kernel/kprobes.c	2007-02-02 14:04:39.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/kprobes.c	2007-02-02 14:04:56.000000000 +0100
@@ -155,15 +155,34 @@ void __kprobes get_instruction_type(stru
 static int __kprobes swap_instruction(void *aref)
 {
 	struct ins_replace_args *args = aref;
+	u32 *addr;
+	u32 instr;
 	int err = -EFAULT;
 
+	/*
+	 * Text segment is read-only, hence we use stura to bypass dynamic
+	 * address translation to exchange the instruction. Since stura
+	 * always operates on four bytes, but we only want to exchange two
+	 * bytes do some calculations to get things right. In addition we
+	 * shall not cross any page boundaries (vmalloc area!) when writing
+	 * the new instruction.
+	 */
+	addr = (u32 *)ALIGN((unsigned long)args->ptr, 4);
+	if ((unsigned long)args->ptr & 2)
+		instr = ((*addr) & 0xffff0000) | args->new;
+	else
+		instr = ((*addr) & 0x0000ffff) | args->new << 16;
+
 	asm volatile(
-		"0: mvc  0(2,%2),0(%3)\n"
-		"1: la   %0,0\n"
+		"	lra	%1,0(%1)\n"
+		"0:	stura	%2,%1\n"
+		"1:	la	%0,0\n"
 		"2:\n"
 		EX_TABLE(0b,2b)
-		: "+d" (err), "=m" (*args->ptr)
-		: "a" (args->ptr), "a" (&args->new), "m" (args->new));
+		: "+d" (err)
+		: "a" (addr), "d" (instr)
+		: "memory", "cc");
+
 	return err;
 }
 
diff -urpN linux-2.6/arch/s390/kernel/vmlinux.lds.S linux-2.6-patched/arch/s390/kernel/vmlinux.lds.S
--- linux-2.6/arch/s390/kernel/vmlinux.lds.S	2007-02-02 14:04:52.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/vmlinux.lds.S	2007-02-02 14:04:56.000000000 +0100
@@ -35,9 +35,10 @@ SECTIONS
 
 #ifdef CONFIG_SHARED_KERNEL
   . = ALIGN(1048576);		/* VM shared segments are 1MB aligned */
+#endif
 
+  . = ALIGN(4096);
   _eshared = .;			/* End of shareable data */
-#endif
 
   . = ALIGN(16);		/* Exception table */
   __start___ex_table = .;
diff -urpN linux-2.6/arch/s390/mm/init.c linux-2.6-patched/arch/s390/mm/init.c
--- linux-2.6/arch/s390/mm/init.c	2007-02-02 14:04:48.000000000 +0100
+++ linux-2.6-patched/arch/s390/mm/init.c	2007-02-02 14:04:56.000000000 +0100
@@ -26,7 +26,6 @@
 #include <linux/pfn.h>
 #include <linux/poison.h>
 #include <linux/initrd.h>
-
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -96,8 +95,8 @@ static void __init setup_ro_region(void)
 	pte_t new_pte;
 	unsigned long address, end;
 
-	address = ((unsigned long)&__start_rodata) & PAGE_MASK;
-	end = PFN_ALIGN((unsigned long)&__end_rodata);
+	address = ((unsigned long)&_stext) & PAGE_MASK;
+	end = PFN_ALIGN((unsigned long)&_eshared);
 
 	for (; address < end; address += PAGE_SIZE) {
 		pgd = pgd_offset_k(address);
@@ -173,8 +172,8 @@ void __init mem_init(void)
                 datasize >>10,
                 initsize >> 10);
 	printk("Write protected kernel read-only data: %#lx - %#lx\n",
-	       (unsigned long)&__start_rodata,
-	       PFN_ALIGN((unsigned long)&__end_rodata) - 1);
+	       (unsigned long)&_stext,
+	       PFN_ALIGN((unsigned long)&_eshared) - 1);
 }
 
 void free_initmem(void)
diff -urpN linux-2.6/include/asm-s390/sections.h linux-2.6-patched/include/asm-s390/sections.h
--- linux-2.6/include/asm-s390/sections.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/sections.h	2007-02-02 14:04:56.000000000 +0100
@@ -3,4 +3,6 @@
 
 #include <asm-generic/sections.h>
 
+extern char _eshared[];
+
 #endif

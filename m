Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbXJWIEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbXJWIEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 04:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXJWIDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 04:03:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:6453 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbXJWIDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 04:03:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,316,1188802800"; 
   d="scan'208";a="355636214"
Subject: [PATCH -v7 1/3] x86 boot: setup data
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Oct 2007 16:06:11 +0800
Message-Id: <1193126771.23935.79.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 23 Oct 2007 08:03:29.0065 (UTC) FILETIME=[324C4990:01C8154B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a field of 64-bit physical pointer to NULL terminated
single linked list of struct setup_data to real-mode kernel
header. This is used as a more extensible boot parameters passing
mechanism.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 arch/x86/boot/header.S      |    6 +++++-
 arch/x86/kernel/e820_64.c   |    6 +++---
 arch/x86/kernel/head64.c    |   26 ++++++++++++++++++++++++++
 arch/x86/kernel/head_32.S   |   37 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/setup_32.c  |   25 +++++++++++++++++++++++--
 arch/x86/kernel/setup_64.c  |   22 ++++++++++++++++++++--
 arch/x86/mm/discontig_32.c  |    3 ++-
 include/asm-x86/bootparam.h |   12 ++++++++++++
 include/asm-x86/e820_64.h   |    1 +
 include/asm-x86/setup_32.h  |    7 +++++++
 include/asm-x86/setup_64.h  |    2 ++
 11 files changed, 137 insertions(+), 10 deletions(-)

Index: linux-2.6/include/asm-x86/bootparam.h
===================================================================
--- linux-2.6.orig/include/asm-x86/bootparam.h	2007-10-23 10:01:35.000000000 +0800
+++ linux-2.6/include/asm-x86/bootparam.h	2007-10-23 10:48:48.000000000 +0800
@@ -9,6 +9,17 @@
 #include <asm/ist.h>
 #include <video/edid.h>
 
+/* setup data types */
+#define SETUP_NONE			0
+
+/* extensible setup data list node */
+struct setup_data {
+	u64 next;
+	u32 type;
+	u32 len;
+	u8 data[0];
+};
+
 struct setup_header {
 	u8	setup_sects;
 	u16	root_flags;
@@ -46,6 +57,7 @@
 	u32	cmdline_size;
 	u32	hardware_subarch;
 	u64	hardware_subarch_data;
+	u64	setup_data;
 } __attribute__((packed));
 
 struct sys_desc_table {
Index: linux-2.6/arch/x86/boot/header.S
===================================================================
--- linux-2.6.orig/arch/x86/boot/header.S	2007-10-23 10:01:35.000000000 +0800
+++ linux-2.6/arch/x86/boot/header.S	2007-10-23 13:51:29.000000000 +0800
@@ -119,7 +119,7 @@
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0207		# header version number (>= 0x0105)
+		.word	0x0208		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -219,6 +219,10 @@
 
 hardware_subarch_data:	.quad 0
 
+setup_data:		.quad 0			# 64-bit physical pointer to
+						# single linked list of
+						# struct setup_data
+
 # End of setup header #####################################################
 
 	.section ".inittext", "ax"
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c	2007-10-23 10:01:35.000000000 +0800
+++ linux-2.6/arch/x86/kernel/setup_64.c	2007-10-23 10:48:48.000000000 +0800
@@ -247,6 +247,22 @@
 		ebda_size = 64*1024;
 }
 
+static void __init parse_setup_data(void)
+{
+	struct setup_data *data;
+
+	if (boot_params.hdr.version < 0x0207)
+		return;
+	for (data = __va(boot_params.hdr.setup_data);
+	     data != __va(0);
+	     data = __va(data->next)) {
+		switch (data->type) {
+		default:
+			break;
+		}
+	}
+}
+
 void __init setup_arch(char **cmdline_p)
 {
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
@@ -282,6 +298,8 @@
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
+	parse_setup_data();
+
 	parse_early_param();
 
 	finish_e820_parsing();
@@ -340,9 +358,9 @@
 	reserve_bootmem_generic(table_start << PAGE_SHIFT, 
 				(table_end - table_start) << PAGE_SHIFT);
 
-	/* reserve kernel */
+	/* reserve kernel and setup data */
 	reserve_bootmem_generic(__pa_symbol(&_text),
-				__pa_symbol(&_end) - __pa_symbol(&_text));
+				setup_data_end - __pa_symbol(&_text));
 
 	/*
 	 * reserve physical page 0 - it's a special BIOS page on many boxes,
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c	2007-10-23 10:01:35.000000000 +0800
+++ linux-2.6/arch/x86/kernel/setup_32.c	2007-10-23 13:51:05.000000000 +0800
@@ -66,6 +66,8 @@
    address, and must not be in the .bss segment! */
 unsigned long init_pg_tables_end __initdata = ~0UL;
 
+unsigned long setup_data_len __initdata;
+
 int disable_pse __devinitdata = 0;
 
 /*
@@ -327,7 +329,7 @@
 	 * partially used pages are not usable - thus
 	 * we are rounding upwards:
 	 */
-	min_low_pfn = PFN_UP(init_pg_tables_end);
+	min_low_pfn = PFN_UP(init_pg_tables_end+setup_data_len);
 
 	find_max_pfn();
 
@@ -532,6 +534,22 @@
 	return machine_specific_memory_setup();
 }
 
+static void __init parse_setup_data(void)
+{
+	struct setup_data *data;
+
+	if (boot_params.hdr.version < 0x0207)
+		return;
+	for (data = __va(boot_params.hdr.setup_data);
+	     data != __va(0);
+	     data = __va(data->next)) {
+		switch (data->type) {
+		default:
+			break;
+		}
+	}
+}
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -579,6 +597,9 @@
 	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
 	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
 #endif
+
+	parse_setup_data();
+
 	ARCH_SETUP
 	if (efi_enabled)
 		efi_init();
@@ -594,7 +615,7 @@
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code = (unsigned long) _etext;
 	init_mm.end_data = (unsigned long) _edata;
-	init_mm.brk = init_pg_tables_end + PAGE_OFFSET;
+	init_mm.brk = init_pg_tables_end + setup_data_len + PAGE_OFFSET;
 
 	code_resource.start = virt_to_phys(_text);
 	code_resource.end = virt_to_phys(_etext)-1;
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c	2007-10-23 10:01:35.000000000 +0800
+++ linux-2.6/arch/x86/kernel/e820_64.c	2007-10-23 10:01:39.000000000 +0800
@@ -79,9 +79,9 @@
 		}
 	} 
 #endif
-	/* kernel code */
-	if (last >= __pa_symbol(&_text) && addr < __pa_symbol(&_end)) {
-		*addrp = PAGE_ALIGN(__pa_symbol(&_end));
+	/* kernel code and setup data */
+	if (last >= __pa_symbol(&_text) && addr < setup_data_end) {
+		*addrp = PAGE_ALIGN(setup_data_end);
 		return 1;
 	}
 
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c	2007-10-23 10:01:35.000000000 +0800
+++ linux-2.6/arch/x86/kernel/head64.c	2007-10-23 10:01:39.000000000 +0800
@@ -19,6 +19,9 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
+#include <asm/io.h>
+
+unsigned long __initdata setup_data_end;
 
 static void __init zap_identity_mappings(void)
 {
@@ -38,12 +41,35 @@
 static void __init copy_bootdata(char *real_mode_data)
 {
 	char * command_line;
+	void *sdata_dst;
+	struct setup_data *sdata;
+	u64 *ppa_next;
+	unsigned long sdata_len;
 
 	memcpy(&boot_params, real_mode_data, sizeof boot_params);
 	if (boot_params.hdr.cmd_line_ptr) {
 		command_line = __va(boot_params.hdr.cmd_line_ptr);
 		memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	}
+
+#define SETUP_DATA_ALIGN(addr) \
+	(((unsigned long)(addr)+(SETUP_DATA_ALIGN_SIZE-1))& \
+	 ~(SETUP_DATA_ALIGN_SIZE-1))
+
+	sdata_dst = __va(SETUP_DATA_ALIGN(__pa_symbol(&_end)));
+	ppa_next = &boot_params.hdr.setup_data;
+	while (*ppa_next) {
+		sdata = early_ioremap(*ppa_next, sizeof(*sdata));
+		sdata_len = sizeof(*sdata) + sdata->len;
+		early_iounmap(sdata, sizeof(*sdata));
+		sdata = early_ioremap(*ppa_next, sdata_len);
+		memcpy(sdata_dst, sdata, sdata_len);
+		early_iounmap(sdata, sdata_len);
+		*ppa_next = __pa(sdata_dst);
+		ppa_next = &((struct setup_data *)sdata_dst)->next;
+		sdata_dst = (void *)SETUP_DATA_ALIGN(sdata_dst+sdata_len);
+	}
+	setup_data_end = __pa(sdata_dst);
 }
 
 void __init x86_64_start_kernel(char * real_mode_data)
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h	2007-10-23 10:01:35.000000000 +0800
+++ linux-2.6/include/asm-x86/e820_64.h	2007-10-23 10:01:39.000000000 +0800
@@ -56,6 +56,7 @@
 
 extern unsigned ebda_addr, ebda_size;
 extern unsigned long nodemap_addr, nodemap_size;
+extern unsigned long setup_data_end;
 #endif/*!__ASSEMBLY__*/
 
 #endif/*__E820_HEADER*/
Index: linux-2.6/arch/x86/kernel/head_32.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head_32.S	2007-10-23 10:01:35.000000000 +0800
+++ linux-2.6/arch/x86/kernel/head_32.S	2007-10-23 10:01:39.000000000 +0800
@@ -135,6 +135,21 @@
 	rep
 	movsl
 1:
+	movl boot_params - __PAGE_OFFSET + SETUP_DATA_POINTER,%ebp
+	xorl %ecx,%ecx
+2:
+	andl %ebp,%ebp
+	jz 1f
+	movl $(SETUP_DATA_HEADER_LEN+SETUP_DATA_ALIGN_SIZE-1),%eax
+	addl (SETUP_DATA_LEN)(%ebp),%eax
+	andl $~(SETUP_DATA_ALIGN_SIZE-1),%eax
+	addl %eax, %ecx
+	movl SETUP_DATA_NEXT(%ebp),%ebp
+	jmp 2b
+1:
+	addl $(PAGE_SIZE_asm-1),%ecx
+	andl $~(PAGE_SIZE_asm-1),%ecx
+	movl %ecx,(setup_data_len - __PAGE_OFFSET)
 
 #ifdef CONFIG_PARAVIRT
 	cmpw $0x207, (boot_params + BP_version - __PAGE_OFFSET)
@@ -191,13 +206,33 @@
 	stosl
 	addl $0x1000,%eax
 	loop 11b
-	/* End condition: we must map up to and including INIT_MAP_BEYOND_END */
+	/* End condition: we must map up to and including INIT_MAP_BEYOND_END + setup_data_len */
 	/* bytes beyond the end of our own page tables; the +0x007 is the attribute bits */
 	leal (INIT_MAP_BEYOND_END+0x007)(%edi),%ebp
+	addl (setup_data_len - __PAGE_OFFSET),%ebp
 	cmpl %ebp,%eax
 	jb 10b
 	movl %edi,(init_pg_tables_end - __PAGE_OFFSET)
 
+	/* Copy setup data */
+	leal (boot_params - __PAGE_OFFSET + SETUP_DATA_POINTER),%ebx
+2:
+	movl (%ebx),%ebp
+	andl %ebp,%ebp
+	jz 1f
+	movl $SETUP_DATA_HEADER_LEN,%ecx
+	addl SETUP_DATA_LEN(%ebp),%ecx
+	addl $(SETUP_DATA_ALIGN_SIZE-1),%edi
+	andl $~(SETUP_DATA_ALIGN_SIZE-1),%edi
+	movl %edi,(%ebx)
+	movl %ebp,%esi
+	rep
+	movsb
+	movl (%ebx),%ebx
+	leal SETUP_DATA_NEXT(%ebx),%ebx
+	jmp 2b
+1:
+
 	xorl %ebx,%ebx				/* This is the boot CPU (BSP) */
 	jmp 3f
 /*
Index: linux-2.6/arch/x86/mm/discontig_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/discontig_32.c	2007-10-23 10:01:35.000000000 +0800
+++ linux-2.6/arch/x86/mm/discontig_32.c	2007-10-23 10:01:39.000000000 +0800
@@ -282,7 +282,8 @@
 	kva_pages = calculate_numa_remap_pages();
 
 	/* partially used pages are not usable - thus round upwards */
-	system_start_pfn = min_low_pfn = PFN_UP(init_pg_tables_end);
+	system_start_pfn = min_low_pfn = PFN_UP(init_pg_tables_end +
+						setup_data_len);
 
 	kva_start_pfn = find_max_low_pfn() - kva_pages;
 
Index: linux-2.6/include/asm-x86/setup_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup_32.h	2007-10-23 10:01:35.000000000 +0800
+++ linux-2.6/include/asm-x86/setup_32.h	2007-10-23 10:01:39.000000000 +0800
@@ -25,6 +25,13 @@
 #define OLD_CL_OFFSET		0x90022
 #define NEW_CL_POINTER		0x228	/* Relative to real mode data */
 
+#define SETUP_DATA_POINTER	0x248	/* Relative to real mode data */
+
+#define SETUP_DATA_NEXT		0x0
+#define SETUP_DATA_LEN		0xc
+#define SETUP_DATA_HEADER_LEN	0x10
+#define SETUP_DATA_ALIGN_SIZE	0x8
+
 #ifndef __ASSEMBLY__
 
 #include <asm/bootparam.h>
Index: linux-2.6/include/asm-x86/setup_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup_64.h	2007-10-23 10:01:35.000000000 +0800
+++ linux-2.6/include/asm-x86/setup_64.h	2007-10-23 10:03:25.000000000 +0800
@@ -4,7 +4,9 @@
 #define COMMAND_LINE_SIZE	2048
 
 #ifdef __KERNEL__
+#include <linux/const.h>
 
+#define SETUP_DATA_ALIGN_SIZE	__AC(0x8, UL)
 #ifndef __ASSEMBLY__
 #include <asm/bootparam.h>
 

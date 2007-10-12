Return-Path: <linux-kernel-owner+w=401wt.eu-S932422AbXJLFuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbXJLFuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 01:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758540AbXJLFub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 01:50:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:64821 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758501AbXJLFua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 01:50:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,264,1188802800"; 
   d="scan'208";a="297187867"
Subject: [PATCH -mm -v5 1/3] i386/x86_64 boot: setup data
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Oct 2007 13:52:28 +0800
Message-Id: <1192168348.17539.43.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 12 Oct 2007 05:50:14.0492 (UTC) FILETIME=[C29E01C0:01C80C93]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a field of 64-bit physical pointer to NULL terminated
single linked list of struct setup_data to real-mode kernel
header. This is used as a more extensible boot parameters passing
mechanism.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 arch/i386/Kconfig            |    3 -
 arch/i386/boot/header.S      |    8 +++
 arch/i386/kernel/setup.c     |   95 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86_64/kernel/setup.c   |   37 ++++++++++++++++
 include/asm-i386/bootparam.h |   15 ++++++
 include/asm-i386/io.h        |    7 +++
 6 files changed, 161 insertions(+), 4 deletions(-)

Index: linux-2.6.23-rc8/include/asm-i386/bootparam.h
===================================================================
--- linux-2.6.23-rc8.orig/include/asm-i386/bootparam.h	2007-10-09 11:26:06.000000000 +0800
+++ linux-2.6.23-rc8/include/asm-i386/bootparam.h	2007-10-12 11:20:28.000000000 +0800
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
+} __attribute__((packed));
+
 struct setup_header {
 	u8	setup_sects;
 	u16	root_flags;
@@ -41,6 +52,10 @@
 	u32	initrd_addr_max;
 	u32	kernel_alignment;
 	u8	relocatable_kernel;
+	u8	_pad2[3];
+	u32	cmdline_size;
+	u32	_pad3;
+	u64	setup_data;
 } __attribute__((packed));
 
 struct sys_desc_table {
Index: linux-2.6.23-rc8/arch/i386/boot/header.S
===================================================================
--- linux-2.6.23-rc8.orig/arch/i386/boot/header.S	2007-10-09 11:26:06.000000000 +0800
+++ linux-2.6.23-rc8/arch/i386/boot/header.S	2007-10-09 11:26:08.000000000 +0800
@@ -119,7 +119,7 @@
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0206		# header version number (>= 0x0105)
+		.word	0x0207		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -214,6 +214,12 @@
                                                 #added with boot protocol
                                                 #version 2.06
 
+pad4:			.long 0
+
+setup_data:		.quad 0			# 64-bit physical pointer to
+						# single linked list of
+						# struct setup_data
+
 # End of setup header #####################################################
 
 	.section ".inittext", "ax"
Index: linux-2.6.23-rc8/arch/x86_64/kernel/setup.c
===================================================================
--- linux-2.6.23-rc8.orig/arch/x86_64/kernel/setup.c	2007-10-09 11:26:06.000000000 +0800
+++ linux-2.6.23-rc8/arch/x86_64/kernel/setup.c	2007-10-12 11:20:28.000000000 +0800
@@ -250,6 +250,40 @@
 		ebda_size = 64*1024;
 }
 
+static void __init parse_setup_data(void)
+{
+	struct setup_data *data;
+	unsigned long pa_data;
+
+	if (boot_params.hdr.version < 0x0207)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, PAGE_SIZE);
+		switch (data->type) {
+		default:
+			break;
+		}
+		pa_data = data->next;
+		early_iounmap(data, PAGE_SIZE);
+	}
+}
+
+static void __init reserve_setup_data(void)
+{
+	struct setup_data *data;
+	unsigned long pa_data;
+
+	if (boot_params.hdr.version < 0x0207)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = __va(pa_data);
+		reserve_bootmem_generic(pa_data, sizeof(*data)+data->len);
+		pa_data = data->next;
+	}
+}
+
 void __init setup_arch(char **cmdline_p)
 {
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
@@ -285,6 +319,8 @@
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
+	parse_setup_data();
+
 	parse_early_param();
 
 	finish_e820_parsing();
@@ -373,6 +409,7 @@
         */
        acpi_reserve_bootmem();
 #endif
+	reserve_setup_data();
 	/*
 	 * Find and reserve possible boot-time SMP configuration:
 	 */
Index: linux-2.6.23-rc8/arch/i386/kernel/setup.c
===================================================================
--- linux-2.6.23-rc8.orig/arch/i386/kernel/setup.c	2007-10-09 11:26:06.000000000 +0800
+++ linux-2.6.23-rc8/arch/i386/kernel/setup.c	2007-10-12 11:20:29.000000000 +0800
@@ -424,6 +424,94 @@
 {}
 #endif
 
+static void __init reserve_setup_data(void)
+{
+	struct setup_data *data;
+	unsigned long max_low_addr = (max_low_pfn<<PAGE_SHIFT);
+	unsigned long pa_data, data_len;
+
+	if (boot_params.hdr.version < 0x0207)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = boot_ioremap(pa_data, sizeof(*data));
+		data_len = sizeof(*data)+data->len;
+		if (pa_data+data_len <= max_low_addr)
+			reserve_bootmem(pa_data, data_len);
+		else if (pa_data < max_low_addr)
+			reserve_bootmem(pa_data, max_low_addr - pa_data);
+		pa_data = data->next;
+	}
+}
+
+/*
+ * The setup data in high memory can not be reserved by bootmem
+ * allocator, so they are copied to low memory.
+ */
+static void __init copy_setup_data(void)
+{
+	struct setup_data *data, *ndata;
+	u64 *ppa_next;
+	unsigned long data_len;
+
+	if (boot_params.hdr.version < 0x0207)
+		return;
+	ppa_next = &boot_params.hdr.setup_data;
+	while (*ppa_next) {
+		data = bt_ioremap(*ppa_next, sizeof(*data));
+		data_len = sizeof(*data)+data->len;
+		bt_iounmap(data, sizeof(*data));
+		if (*ppa_next+data_len > (max_low_pfn<<PAGE_SHIFT)) {
+			ndata = alloc_bootmem_low(data_len);
+			data = bt_ioremap(*ppa_next, data_len);
+			memcpy(ndata, data, data_len);
+			*ppa_next = __pa(ndata);
+			bt_iounmap(data, data_len);
+		}
+		ppa_next = &((struct setup_data *)__va(*ppa_next))->next;
+	}
+}
+
+static void __init parse_setup_data(void)
+{
+	struct setup_data *data;
+	unsigned long pa_data, pa_next;
+
+	if (boot_params.hdr.version < 0x0207)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = boot_ioremap(pa_data, PAGE_SIZE);
+		pa_next = data->next;
+		switch (data->type) {
+		default:
+			break;
+		}
+		pa_data = pa_next;
+	}
+}
+
+/*
+ * The memory location of setup data may be changed after
+ * copy_setup_data, so late_parse_setup_data are provided for needed
+ * user.
+ */
+static void __init late_parse_setup_data(void)
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
 void __init setup_bootmem_allocator(void)
 {
 	unsigned long bootmap_size;
@@ -500,6 +588,7 @@
 	}
 #endif
 	reserve_crashkernel();
+	reserve_setup_data();
 }
 
 /*
@@ -583,6 +672,9 @@
 	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
 	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
 #endif
+
+	parse_setup_data();
+
 	ARCH_SETUP
 	if (efi_enabled)
 		efi_init();
@@ -657,6 +749,9 @@
 	if (efi_enabled)
 		efi_map_memmap();
 
+	copy_setup_data();
+	late_parse_setup_data();
+
 #ifdef CONFIG_ACPI
 	/*
 	 * Parse the ACPI tables for possible boot-time SMP configuration.
Index: linux-2.6.23-rc8/include/asm-i386/io.h
===================================================================
--- linux-2.6.23-rc8.orig/include/asm-i386/io.h	2007-10-09 11:26:06.000000000 +0800
+++ linux-2.6.23-rc8/include/asm-i386/io.h	2007-10-09 11:26:08.000000000 +0800
@@ -126,6 +126,13 @@
 extern void iounmap(volatile void __iomem *addr);
 
 /*
+ * boot_ioremap is for temporary early boot-time mappings, before
+ * paging_init(), when the boot-time page tables are still in use.
+ * The mapping is currently limited to at most 4 pages.
+ */
+extern void *boot_ioremap(unsigned long offset, unsigned long size);
+
+/*
  * bt_ioremap() and bt_iounmap() are for temporary early boot-time
  * mappings, before the real ioremap() is functional.
  * A boot-time mapping is currently limited to at most 16 pages.
Index: linux-2.6.23-rc8/arch/i386/Kconfig
===================================================================
--- linux-2.6.23-rc8.orig/arch/i386/Kconfig	2007-10-09 11:26:06.000000000 +0800
+++ linux-2.6.23-rc8/arch/i386/Kconfig	2007-10-09 11:26:08.000000000 +0800
@@ -784,11 +784,8 @@
  	  The default yes will allow the kernel to do irq load balancing.
 	  Saying no will keep the kernel from doing irq load balancing.
 
-# turning this on wastes a bunch of space.
-# Summit needs it only when NUMA is on
 config BOOT_IOREMAP
 	bool
-	depends on (((X86_SUMMIT || X86_GENERICARCH) && NUMA) || (X86 && EFI))
 	default y
 
 config SECCOMP

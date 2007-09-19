Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbXISI4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbXISI4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 04:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbXISI4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 04:56:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:17249 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbXISI4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 04:56:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,272,1186383600"; 
   d="scan'208";a="282031971"
Subject: [PATCH -mm -v3 1/2] i386/x86_64 boot: setup data
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Sep 2007 16:58:26 +0800
Message-Id: <1190192306.12429.76.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 19 Sep 2007 08:56:29.0347 (UTC) FILETIME=[F7D94F30:01C7FA9A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a field of 64-bit physical pointer to NULL terminated
single linked list of struct setup_data to real-mode kernel
header. This is used as a more extensible boot parameters passing
mechanism.

This patch has been tested against 2.6.23-rc6-mm1 kernel on x86_64. It
is based on the proposal of Peter Anvin.


Known Issues:

1. Where is safe to place the linked list of setup_data?
Because the length of the linked list of setup_data is variable, it
can not be copied into BSS segment of kernel as that of "zero
page". We must find a safe place for it, where it will not be
overwritten by kernel during booting up. The i386 kernel will
overwrite some pages after _end. The x86_64 kernel will overwrite some
pages from 0x1000 on.


ChangeLog:

-- v2 --

- Increase the boot protocol version number.
- Check version number before parsing setup_data.


Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 arch/i386/Kconfig            |    3 ---
 arch/i386/boot/header.S      |    8 +++++++-
 arch/i386/kernel/setup.c     |   22 ++++++++++++++++++++++
 arch/x86_64/kernel/setup.c   |   21 +++++++++++++++++++++
 include/asm-i386/bootparam.h |   15 +++++++++++++++
 include/asm-i386/io.h        |    7 +++++++
 6 files changed, 72 insertions(+), 4 deletions(-)

Index: linux-2.6.23-rc6/include/asm-i386/bootparam.h
===================================================================
--- linux-2.6.23-rc6.orig/include/asm-i386/bootparam.h	2007-09-19 10:22:02.000000000 +0800
+++ linux-2.6.23-rc6/include/asm-i386/bootparam.h	2007-09-19 16:41:57.000000000 +0800
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
Index: linux-2.6.23-rc6/arch/i386/boot/header.S
===================================================================
--- linux-2.6.23-rc6.orig/arch/i386/boot/header.S	2007-09-19 10:22:02.000000000 +0800
+++ linux-2.6.23-rc6/arch/i386/boot/header.S	2007-09-19 10:47:34.000000000 +0800
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
Index: linux-2.6.23-rc6/arch/x86_64/kernel/setup.c
===================================================================
--- linux-2.6.23-rc6.orig/arch/x86_64/kernel/setup.c	2007-09-19 10:22:02.000000000 +0800
+++ linux-2.6.23-rc6/arch/x86_64/kernel/setup.c	2007-09-19 16:41:57.000000000 +0800
@@ -221,6 +221,25 @@
 		ebda_size = 64*1024;
 }
 
+void __init parse_setup_data(void)
+{
+	struct setup_data *setup_data;
+	unsigned long pa_setup_data;
+
+	if (boot_params.hdr.version < 0x0207)
+		return;
+	pa_setup_data = boot_params.hdr.setup_data;
+	while (pa_setup_data) {
+		setup_data = early_ioremap(pa_setup_data, PAGE_SIZE);
+		switch (setup_data->type) {
+		default:
+			break;
+		}
+		pa_setup_data = setup_data->next;
+		early_iounmap(setup_data, PAGE_SIZE);
+	}
+}
+
 void __init setup_arch(char **cmdline_p)
 {
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
@@ -256,6 +275,8 @@
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
+	parse_setup_data();
+
 	parse_early_param();
 
 	finish_e820_parsing();
Index: linux-2.6.23-rc6/arch/i386/kernel/setup.c
===================================================================
--- linux-2.6.23-rc6.orig/arch/i386/kernel/setup.c	2007-09-19 10:22:02.000000000 +0800
+++ linux-2.6.23-rc6/arch/i386/kernel/setup.c	2007-09-19 10:47:34.000000000 +0800
@@ -496,6 +496,25 @@
 	return machine_specific_memory_setup();
 }
 
+void __init parse_setup_data(void)
+{
+	struct setup_data *setup_data;
+	unsigned long pa_setup_data, pa_next;
+
+	if (boot_params.hdr.version < 0x0207)
+		return;
+	pa_setup_data = boot_params.hdr.setup_data;
+	while (pa_setup_data) {
+		setup_data = boot_ioremap(pa_setup_data, PAGE_SIZE);
+		pa_next = setup_data->next;
+		switch (setup_data->type) {
+		default:
+			break;
+		}
+		pa_setup_data = pa_next;
+	}
+}
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -544,6 +563,9 @@
 	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
 	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
 #endif
+
+	parse_setup_data();
+
 	ARCH_SETUP
 	if (efi_enabled)
 		efi_init();
Index: linux-2.6.23-rc6/include/asm-i386/io.h
===================================================================
--- linux-2.6.23-rc6.orig/include/asm-i386/io.h	2007-09-19 10:22:02.000000000 +0800
+++ linux-2.6.23-rc6/include/asm-i386/io.h	2007-09-19 10:47:34.000000000 +0800
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
Index: linux-2.6.23-rc6/arch/i386/Kconfig
===================================================================
--- linux-2.6.23-rc6.orig/arch/i386/Kconfig	2007-09-19 10:22:02.000000000 +0800
+++ linux-2.6.23-rc6/arch/i386/Kconfig	2007-09-19 10:47:34.000000000 +0800
@@ -773,11 +773,8 @@
  	  The default yes will allow the kernel to do irq load balancing.
 	  Saying no will keep the kernel from doing irq load balancing.
 
-# turning this on wastes a bunch of space.
-# Summit needs it only when NUMA is on
 config BOOT_IOREMAP
 	bool
-	depends on (((X86_SUMMIT || X86_GENERICARCH) && NUMA) || (X86 && EFI))
 	default y
 
 config SECCOMP

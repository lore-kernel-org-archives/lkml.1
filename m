Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbYAZP5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbYAZP5j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 10:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYAZPyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:54:32 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752211AbYAZPya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:54:30 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 21/52] [microblaze] setup.c - system setting
Date: Thu, 24 Jan 2008 16:02:56 +0100
Message-Id: <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/setup.c |  170 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 170 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/setup.c

diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
new file mode 100644
index 0000000..1d05fac
--- /dev/null
+++ b/arch/microblaze/kernel/setup.c
@@ -0,0 +1,170 @@
+/*
+ * arch/microblaze/kernel/setup.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/seq_file.h>
+#include <linux/cpu.h>
+#include <linux/initrd.h>
+#include <linux/console.h>
+
+#include <asm/setup.h>
+#include <asm/sections.h>
+#include <asm/page.h>
+#include <asm/io.h>
+#include <asm/bug.h>
+#include <asm/param.h>
+#include <asm/cache.h>
+#include <asm/cacheflush.h>
+#include <asm/entry.h>
+#include <asm/cpuinfo.h>
+
+#include <asm/system.h>
+#include <asm/prom.h>
+#include <asm/pgtable.h>
+
+DEFINE_PER_CPU(unsigned int, KSP);	/* Saved kernel stack pointer */
+DEFINE_PER_CPU(unsigned int, KM);	/* Kernel/user mode */
+DEFINE_PER_CPU(unsigned int, ENTRY_SP);	/* Saved SP on kernel entry */
+DEFINE_PER_CPU(unsigned int, R11_SAVE);	/* Temp variable for entry */
+DEFINE_PER_CPU(unsigned int, CURRENT_SAVE);	/* Saved current pointer */
+
+char command_line[COMMAND_LINE_SIZE];
+static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
+
+void __init setup_arch(char **cmdline_p)
+{
+	console_verbose();
+
+	unflatten_device_tree();
+	/* NOTE I think that this function is not necessary to call */
+	/* irq_early_init(); */
+	setup_cpuinfo();
+
+	__flush_icache_all();
+	__enable_icache();
+
+	__flush_dcache_all();
+	__enable_dcache();
+
+	panic_timeout = 120;
+
+	setup_memory();
+	paging_init();
+
+#ifdef CONFIG_VT
+#if defined(CONFIG_XILINX_CONSOLE)
+	conswitchp = &xil_con;
+#elif defined(CONFIG_DUMMY_CONSOLE)
+	conswitchp = &dummy_con;
+#endif
+#endif
+}
+
+#ifdef CONFIG_MTD_UCLINUX_EBSS
+/* Handle both romfs and cramfs types, without generating unnecessary
+ code (ie no point checking for CRAMFS if it's not even enabled) */
+inline unsigned get_romfs_len(unsigned *addr)
+{
+#ifdef CONFIG_ROMFS_FS
+	if (memcmp(&addr[0], "-rom1fs-", 8) == 0) /* romfs */
+		return be32_to_cpu(addr[2]);
+#endif
+
+#ifdef CONFIG_CRAMFS
+	if (addr[0] == le32_to_cpu(0x28cd3d45)) /* cramfs */
+		return le32_to_cpu(addr[1]);
+#endif
+	return 0;
+}
+#endif	/* CONFIG_MTD_UCLINUX_EBSS */
+
+void __init machine_early_init(const char *cmdline, unsigned int ram,
+		unsigned int fdt)
+{
+	unsigned long *src, *dst = (unsigned long *)0x0;
+	early_printk("Ramdisk addr 0x%08x, FDT 0x%08x\n", ram, fdt);
+
+#ifdef CONFIG_MTD_UCLINUX_EBSS
+	{
+		int size;
+		unsigned int romfs_base;
+		romfs_base = (ram ? ram : (unsigned int)&__init_end);
+		/* if CONFIG_MTD_UCLINUX_EBSS is defined, assume ROMFS is at the
+		 * end of kernel, which is ROMFS_LOCATION defined above. */
+		size = PAGE_ALIGN(get_romfs_len((unsigned *)romfs_base));
+		early_printk("Found romfs @ 0x%08x (0x%08x)\n",
+				romfs_base, size);
+		early_printk("#### klimit %p ####\n", klimit);
+		BUG_ON(size < 0); /* What else can we do? */
+
+		/* Use memmove to handle likely case of memory overlap */
+		early_printk("Moving 0x%08x bytes from 0x%08x to 0x%08x\n",
+			size, romfs_base, &_ebss);
+		memmove(&_ebss, (int *)romfs_base, size);
+
+		/* update klimit */
+		klimit += PAGE_ALIGN(size);
+		early_printk("New klimit: 0x%08x\n", klimit);
+	}
+#endif
+
+	memset(__bss_start, 0, __bss_stop-__bss_start);
+	memset(_ssbss, 0, _esbss-_ssbss);
+
+	printk(KERN_NOTICE "Found FDT at 0x%08x\n", fdt);
+	early_init_devtree((void *)fdt);
+
+	/* Copy command line passed from bootloader, or use default
+	 if none provided, or forced */
+#ifndef CONFIG_CMDLINE_FORCE
+	if (cmdline && cmdline[0] != '\0')
+		strlcpy(command_line, cmdline, COMMAND_LINE_SIZE);
+	else
+#endif
+		strlcpy(command_line, default_command_line, COMMAND_LINE_SIZE);
+
+	for (src = __ivt_start; src < __ivt_end; src++, dst++)
+		*dst = *src;
+
+	/* Initialize global data */
+	per_cpu(KM, 0) = 0x1;	/* We start in kernel mode */
+	per_cpu(CURRENT_SAVE, 0) = (unsigned long)current;
+
+}
+
+void machine_restart(char *cmd)
+{
+	printk(KERN_NOTICE "Machine restart...\n");
+	dump_stack();
+	while (1)
+		;
+}
+
+void machine_shutdown(void)
+{
+	printk(KERN_NOTICE "Machine shutdown...\n");
+	while (1)
+		;
+}
+
+void machine_halt(void)
+{
+	printk(KERN_NOTICE "Machine halt...\n");
+	while (1)
+		;
+}
+
+void machine_power_off(void)
+{
+	printk(KERN_NOTICE "Machine power off...\n");
+	while (1)
+		;
+}
-- 
1.5.4.rc4.14.g6fc74


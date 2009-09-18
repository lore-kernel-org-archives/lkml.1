Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbZIRQ1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbZIRQ1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbZIRQ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:27:34 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:55193 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbZIRQ1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:27:33 -0400
Date: Fri, 18 Sep 2009 12:27:36 -0400
To: linux-kernel@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       Len Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: [PATCH] Add uboot commandline argument passing support to m68knommu
Message-ID: <20090918162736.GY23700@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds m68knommu support for getting the kernel command line
arguments from uboot, including the passing of an initrd image from uboot.

We use this on a 5270/5271 based board, and have used it on the 5271evb
development board.  It is based on a patch found in the linux-2.6-denx
git tree, although that tree seems to have had lots of other changes
since which are not in the main Linus kernel.  I believe this will work
on all coldfires, although other m68knommu might be missing the _init_sp
stuff in head.S as far as I can tell.  I only have the coldfire to
test on.

Signed-off-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index e2201b9..064f591 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -533,6 +533,13 @@ config AVNET
 	default y
 	depends on (AVNET5282)
 
+config UBOOT
+	bool "Support for U-Boot command line parameters"
+	help
+	  If you say Y here kernel will try to collect command
+	  line parameters from the initial u-boot stack.
+	default n
+
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	default y
diff --git a/arch/m68knommu/kernel/setup.c b/arch/m68knommu/kernel/setup.c
index 5c2bb3e..0e2114e 100644
--- a/arch/m68knommu/kernel/setup.c
+++ b/arch/m68knommu/kernel/setup.c
@@ -29,6 +29,8 @@
 #include <linux/bootmem.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
+#include <linux/initrd.h>
+#include <linux/root_dev.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -52,6 +54,9 @@ void (*mach_reset)(void);
 void (*mach_halt)(void);
 void (*mach_power_off)(void);
 
+#if defined(CONFIG_UBOOT)
+void parse_uboot_commandline(char *commandp, int size);
+#endif
 
 #ifdef CONFIG_M68000
 	#define CPU "MC68000"
@@ -128,7 +133,23 @@ void __init setup_arch(char **cmdline_p)
 #if defined(CONFIG_BOOTPARAM)
 	strncpy(&command_line[0], CONFIG_BOOTPARAM_STRING, sizeof(command_line));
 	command_line[sizeof(command_line) - 1] = 0;
-#endif
+#endif /* CONFIG_BOOTPARAM */
+
+#if defined(CONFIG_UBOOT)
+	/* CONFIG_UBOOT and CONFIG_BOOTPARAM defined, concatenate cmdline */
+	#if defined(CONFIG_BOOTPARAM)
+		/* Add the whitespace separator */
+		command_line[strlen(CONFIG_BOOTPARAM_STRING)] = ' ';
+		/* Parse uboot command line into the rest of the buffer */
+		parse_uboot_commandline(
+			&command_line[(strlen(CONFIG_BOOTPARAM_STRING)+1)],
+			(sizeof(command_line) - (strlen(CONFIG_BOOTPARAM_STRING)+1)));
+	/* Only CONFIG_UBOOT defined, create cmdline */
+	#else
+		parse_uboot_commandline(&command_line[0], sizeof(command_line));
+	#endif /* CONFIG_BOOTPARAM */
+	command_line[sizeof(command_line) - 1] = 0;
+#endif /* CONFIG_UBOOT */
 
 	printk(KERN_INFO "\x0F\r\n\nuClinux/" CPU "\n");
 
@@ -204,12 +225,82 @@ void __init setup_arch(char **cmdline_p)
 	free_bootmem(memory_start, memory_end - memory_start);
 	reserve_bootmem(memory_start, bootmap_size, BOOTMEM_DEFAULT);
 
+#if defined(CONFIG_UBOOT) && defined(CONFIG_BLK_DEV_INITRD)
+	if((initrd_start > 0) && (initrd_start < initrd_end) && (initrd_end < memory_end)) {
+		reserve_bootmem(initrd_start, initrd_end - initrd_start, BOOTMEM_DEFAULT);
+	}
+#endif /* if defined(CONFIG_BLK_DEV_INITRD) */
+
 	/*
 	 * Get kmalloc into gear.
 	 */
 	paging_init();
 }
 
+#if defined(CONFIG_UBOOT)
+/*
+ * parse_uboot_commandline
+ *
+ * Copies u-boot commandline arguments and store them in the proper linux
+ * variables.
+ *
+ * Assumes:
+ *	_init_sp global contains the address in the stack pointer when the
+ *	kernel starts (see head.S::_start)
+ *
+ *	U-Boot calling convention:
+ *	(*kernel) (kbd, initrd_start, initrd_end, cmd_start, cmd_end);
+ *
+ *	_init_sp can be parsed as such
+ *
+ *	_init_sp+00 = u-boot cmd after jsr into kernel (skip)
+ *	_init_sp+04 = &kernel board_info (residual data)
+ *	_init_sp+08 = &initrd_start
+ *	_init_sp+12 = &initrd_end
+ *	_init_sp+16 = &cmd_start
+ *	_init_sp+20 = &cmd_end
+ *
+ *	This also assumes that the memory locations pointed to are still
+ *	unmodified. U-boot places them near the end of external SDRAM.
+ *
+ * Argument(s):
+ *	commandp = the linux commandline arg container to fill.
+ *	size     = the sizeof commandp.
+ *
+ * Returns:
+ */
+void parse_uboot_commandline(char *commandp, int size)
+{
+	extern unsigned long _init_sp;
+	unsigned long *sp;
+	unsigned long uboot_kbd;
+	unsigned long uboot_initrd_start, uboot_initrd_end;
+	unsigned long uboot_cmd_start, uboot_cmd_end;
+
+
+	sp = (unsigned long *)_init_sp;
+	uboot_kbd = sp[1];
+	uboot_initrd_start = sp[2];
+	uboot_initrd_end = sp[3];
+	uboot_cmd_start = sp[4];
+	uboot_cmd_end = sp[5];
+
+	if (uboot_cmd_start && uboot_cmd_end) {
+		strncpy(commandp, (const char *)uboot_cmd_start, size);
+	}
+#if defined(CONFIG_BLK_DEV_INITRD)
+	if (uboot_initrd_start && uboot_initrd_end && 
+		(uboot_initrd_end > uboot_initrd_start)) {		
+		initrd_start = uboot_initrd_start;
+		initrd_end = uboot_initrd_end;
+		ROOT_DEV = Root_RAM0;
+		printk("initrd at 0x%lx:0x%lx\n", 
+			initrd_start, initrd_end);
+	}
+#endif /* if defined(CONFIG_BLK_DEV_INITRD) */
+}
+#endif /* #if defined(CONFIG_UBOOT) */
+
 /*
  *	Get CPU information for use by the procfs.
  */
diff --git a/arch/m68knommu/platform/coldfire/head.S b/arch/m68knommu/platform/coldfire/head.S
index 2b0d73c..4b91aa2 100644
--- a/arch/m68knommu/platform/coldfire/head.S
+++ b/arch/m68knommu/platform/coldfire/head.S
@@ -106,6 +106,9 @@
 .global _ramvec
 .global	_ramstart
 .global	_ramend
+#if defined(CONFIG_UBOOT)
+.global	_init_sp
+#endif
 
 /*****************************************************************************/
 
@@ -124,6 +127,10 @@ _ramstart:
 .long	0
 _ramend:
 .long	0
+#if defined(CONFIG_UBOOT)
+_init_sp:
+.long	0
+#endif
 
 /*****************************************************************************/
 
@@ -137,6 +144,9 @@ __HEAD
 _start:
 	nop					/* filler */
 	movew	#0x2700, %sr			/* no interrupts */
+#if defined(CONFIG_UBOOT)
+	movel	%sp,_init_sp			/* save initial stack pointer */
+#endif
 
 	/*
 	 *	Do any platform or board specific setup now. Most boards


-- 
Len Sorensen

Return-Path: <linux-kernel-owner+w=401wt.eu-S933569AbZINUIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbZINUIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933560AbZINUIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:41 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54063 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933540AbZINUIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:36 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 28/72] Blackfin: catch hardware errors earlier during booting
Date: Mon, 14 Sep 2009 16:07:32 -0400
Message-Id: <1252958896-25150-29-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Allow hardware errors to be caught during early portions of booting, and
leave something in the shadow console that people can use to debug their
system with (to be printed out by the bootloader on next reset).

This enables the hardare error interrupts in head.S, allowing us to find
hardware errors when they happen (well, as much as you can with a hardware
error) and prints out the trace if it is enabled.  This will catch errors
(like booting the wrong image on a 533) which previously resulted in a
infinite loop/hang, as well as random hardware errors before before
setup_arch().

To disable this debug only feature - turn off EARLY_PRINTK.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/early_printk.h |   22 +++++++++
 arch/blackfin/kernel/bfin_dma_5xx.c      |    6 ++
 arch/blackfin/kernel/early_printk.c      |   74 ++++++++++++++++++++++++++++--
 arch/blackfin/kernel/setup.c             |    3 +
 arch/blackfin/kernel/shadow_console.c    |   51 +++++++++++++++++---
 arch/blackfin/mach-common/head.S         |   11 ++++
 arch/blackfin/mm/init.c                  |    3 +
 7 files changed, 158 insertions(+), 12 deletions(-)

diff --git a/arch/blackfin/include/asm/early_printk.h b/arch/blackfin/include/asm/early_printk.h
index f5b6b7d..53a762b 100644
--- a/arch/blackfin/include/asm/early_printk.h
+++ b/arch/blackfin/include/asm/early_printk.h
@@ -21,10 +21,32 @@
  * GNU General Public License for more details.
  */
 
+
+#ifndef __ASM_EARLY_PRINTK_H__
+#define __ASM_EARLY_PRINTK_H__
+
 #ifdef CONFIG_EARLY_PRINTK
+/* For those that don't include it already */
+#include <linux/console.h>
+
 extern int setup_early_printk(char *);
 extern void enable_shadow_console(void);
+extern int shadow_console_enabled(void);
+extern void mark_shadow_error(void);
+extern void early_shadow_reg(unsigned long reg, unsigned int n);
+extern void early_shadow_write(struct console *con, const char *s,
+	unsigned int n) __attribute__((nonnull(2)));
+#define early_shadow_puts(str) early_shadow_write(NULL, str, strlen(str))
+#define early_shadow_stamp() \
+	do { \
+		early_shadow_puts(__FILE__ " : " __stringify(__LINE__) " ["); \
+		early_shadow_puts(__func__); \
+		early_shadow_puts("]\n"); \
+	} while (0)
 #else
 #define setup_early_printk(fmt) do { } while (0)
 #define enable_shadow_console(fmt)  do { } while (0)
+#define early_shadow_stamp() do { } while (0)
 #endif /* CONFIG_EARLY_PRINTK */
+
+#endif /* __ASM_EARLY_PRINTK_H__ */
diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 9f9b828..14dea1a 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -19,6 +19,7 @@
 #include <asm/cacheflush.h>
 #include <asm/dma.h>
 #include <asm/uaccess.h>
+#include <asm/early_printk.h>
 
 /*
  * To make sure we work around 05000119 - we always check DMA_DONE bit,
@@ -236,6 +237,7 @@ void blackfin_dma_resume(void)
  */
 void __init blackfin_dma_early_init(void)
 {
+	early_shadow_stamp();
 	bfin_write_MDMA_S0_CONFIG(0);
 	bfin_write_MDMA_S1_CONFIG(0);
 }
@@ -246,6 +248,8 @@ void __init early_dma_memcpy(void *pdst, const void *psrc, size_t size)
 	unsigned long src = (unsigned long)psrc;
 	struct dma_register *dst_ch, *src_ch;
 
+	early_shadow_stamp();
+
 	/* We assume that everything is 4 byte aligned, so include
 	 * a basic sanity check
 	 */
@@ -300,6 +304,8 @@ void __init early_dma_memcpy(void *pdst, const void *psrc, size_t size)
 
 void __init early_dma_memcpy_done(void)
 {
+	early_shadow_stamp();
+
 	while ((bfin_read_MDMA_S0_CONFIG() && !(bfin_read_MDMA_D0_IRQ_STATUS() & DMA_DONE)) ||
 	       (bfin_read_MDMA_S1_CONFIG() && !(bfin_read_MDMA_D1_IRQ_STATUS() & DMA_DONE)))
 		continue;
diff --git a/arch/blackfin/kernel/early_printk.c b/arch/blackfin/kernel/early_printk.c
index 2ab5681..931c78b 100644
--- a/arch/blackfin/kernel/early_printk.c
+++ b/arch/blackfin/kernel/early_printk.c
@@ -27,6 +27,7 @@
 #include <linux/serial_core.h>
 #include <linux/console.h>
 #include <linux/string.h>
+#include <linux/reboot.h>
 #include <asm/blackfin.h>
 #include <asm/irq_handler.h>
 #include <asm/early_printk.h>
@@ -181,6 +182,22 @@ asmlinkage void __init init_early_exception_vectors(void)
 	u32 evt;
 	SSYNC();
 
+	/*
+	 * This starts up the shadow buffer, incase anything crashes before
+	 * setup arch
+	 */
+	mark_shadow_error();
+	early_shadow_puts(linux_banner);
+	early_shadow_stamp();
+
+	if (CPUID != bfin_cpuid()) {
+		early_shadow_puts("Running on wrong machine type, expected");
+		early_shadow_reg(CPUID, 16);
+		early_shadow_puts(", but running on");
+		early_shadow_reg(bfin_cpuid(), 16);
+		early_shadow_puts("\n");
+	}
+
 	/* cannot program in software:
 	 * evt0 - emulation (jtag)
 	 * evt1 - reset
@@ -199,6 +216,7 @@ asmlinkage void __init init_early_exception_vectors(void)
 
 }
 
+__attribute__((__noreturn__))
 asmlinkage void __init early_trap_c(struct pt_regs *fp, void *retaddr)
 {
 	/* This can happen before the uart is initialized, so initialize
@@ -210,10 +228,58 @@ asmlinkage void __init early_trap_c(struct pt_regs *fp, void *retaddr)
 	if (likely(early_console == NULL) && CPUID == bfin_cpuid())
 		setup_early_printk(DEFAULT_EARLY_PORT);
 
-	printk(KERN_EMERG "Early panic\n");
-	dump_bfin_mem(fp);
-	show_regs(fp);
-	dump_bfin_trace_buffer();
+	if (!shadow_console_enabled()) {
+		/* crap - we crashed before setup_arch() */
+		early_shadow_puts("panic before setup_arch\n");
+		early_shadow_puts("IPEND:");
+		early_shadow_reg(fp->ipend, 16);
+		if (fp->seqstat & SEQSTAT_EXCAUSE) {
+			early_shadow_puts("\nEXCAUSE:");
+			early_shadow_reg(fp->seqstat & SEQSTAT_EXCAUSE, 8);
+		}
+		if (fp->seqstat & SEQSTAT_HWERRCAUSE) {
+			early_shadow_puts("\nHWERRCAUSE:");
+			early_shadow_reg(
+				(fp->seqstat & SEQSTAT_HWERRCAUSE) >> 14, 8);
+		}
+		early_shadow_puts("\nErr @");
+		if (fp->ipend & EVT_EVX)
+			early_shadow_reg(fp->retx, 32);
+		else
+			early_shadow_reg(fp->pc, 32);
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
+		early_shadow_puts("\nTrace:");
+		if (likely(bfin_read_TBUFSTAT() & TBUFCNT)) {
+			while (bfin_read_TBUFSTAT() & TBUFCNT) {
+				early_shadow_puts("\nT  :");
+				early_shadow_reg(bfin_read_TBUF(), 32);
+				early_shadow_puts("\n S :");
+				early_shadow_reg(bfin_read_TBUF(), 32);
+			}
+		}
+#endif
+		early_shadow_puts("\nUse bfin-elf-addr2line to determine "
+			"function names\n");
+		/*
+		 * We should panic(), but we can't - since panic calls printk,
+		 * and printk uses memcpy.
+		 * we want to reboot, but if the machine type is different,
+		 * can't due to machine specific reboot sequences
+		 */
+		if (CPUID == bfin_cpuid()) {
+			early_shadow_puts("Trying to restart\n");
+			machine_restart("");
+		}
+
+		early_shadow_puts("Halting, since it is not safe to restart\n");
+		while (1)
+			asm volatile ("EMUEXCPT; IDLE;\n");
+
+	} else {
+		printk(KERN_EMERG "Early panic\n");
+		show_regs(fp);
+		dump_bfin_trace_buffer();
+	}
 
 	panic("Died early");
 }
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 3974764..f92fffc 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -187,6 +187,8 @@ void __init bfin_relocate_l1_mem(void)
 	unsigned long l1_data_b_length;
 	unsigned long l2_length;
 
+	early_shadow_stamp();
+
 	/*
 	 * due to the ALIGN(4) in the arch/blackfin/kernel/vmlinux.lds.S
 	 * we know that everything about l1 text/data is nice and aligned,
@@ -1352,6 +1354,7 @@ const struct seq_operations cpuinfo_op = {
 
 void __init cmdline_init(const char *r0)
 {
+	early_shadow_stamp();
 	if (r0)
 		strncpy(command_line, r0, COMMAND_LINE_SIZE);
 }
diff --git a/arch/blackfin/kernel/shadow_console.c b/arch/blackfin/kernel/shadow_console.c
index 15819ff..8b8c710 100644
--- a/arch/blackfin/kernel/shadow_console.c
+++ b/arch/blackfin/kernel/shadow_console.c
@@ -24,15 +24,18 @@
 
 static __initdata char *shadow_console_buffer = (char *)SHADOW_CONSOLE_START;
 
-static __init void early_shadow_write(struct console *con, const char *s,
+__init void early_shadow_write(struct console *con, const char *s,
 				unsigned int n)
 {
+	unsigned int i;
 	/*
 	 * save 2 bytes for the double null at the end
 	 * once we fail on a long line, make sure we don't write a short line afterwards
 	 */
 	if ((shadow_console_buffer + n) <= (char *)(SHADOW_CONSOLE_END - 2)) {
-		memcpy(shadow_console_buffer, s, n);
+		/* can't use memcpy - it may not be relocated yet */
+		for (i = 0; i <= n; i++)
+			shadow_console_buffer[i] = s[i];
 		shadow_console_buffer += n;
 		shadow_console_buffer[0] = 0;
 		shadow_console_buffer[1] = 0;
@@ -48,16 +51,24 @@ static __initdata struct console early_shadow_console = {
 	.device = 0,
 };
 
-__init void enable_shadow_console(void)
+__init int shadow_console_enabled(void)
+{
+	return early_shadow_console.flags & CON_ENABLED;
+}
+
+__init void mark_shadow_error(void)
 {
 	int *loc = (int *)SHADOW_CONSOLE_MAGIC_LOC;
+	loc[0] = SHADOW_CONSOLE_MAGIC;
+	loc[1] = SHADOW_CONSOLE_START;
+}
 
-	if (!(early_shadow_console.flags & CON_ENABLED)) {
+__init void enable_shadow_console(void)
+{
+	if (!shadow_console_enabled()) {
 		register_console(&early_shadow_console);
 		/* for now, assume things are going to fail */
-		*loc = SHADOW_CONSOLE_MAGIC;
-		loc++;
-		*loc = SHADOW_CONSOLE_START;
+		mark_shadow_error();
 	}
 }
 
@@ -71,8 +82,32 @@ static __init int disable_shadow_console(void)
 	 */
 	int *loc = (int *)SHADOW_CONSOLE_MAGIC_LOC;
 
-	*loc = 0;
+	loc[0] = 0;
 
 	return 0;
 }
 pure_initcall(disable_shadow_console);
+
+/*
+ * since we can't use printk, dump numbers (as hex), n = # bits
+ */
+__init void early_shadow_reg(unsigned long reg, unsigned int n)
+{
+	/*
+	 * can't use any "normal" kernel features, since thay
+	 * may not be relocated to their execute address yet
+	 */
+	int i;
+	char ascii[11] = " 0x";
+
+	n = n / 4;
+	reg = reg << ((8 - n) * 4);
+	n += 3;
+
+	for (i = 3; i <= n ; i++) {
+		ascii[i] = hex_asc_lo(reg >> 28);
+		reg <<= 4;
+	}
+	early_shadow_write(NULL, ascii, n);
+
+}
diff --git a/arch/blackfin/mach-common/head.S b/arch/blackfin/mach-common/head.S
index f826f6b..6691012 100644
--- a/arch/blackfin/mach-common/head.S
+++ b/arch/blackfin/mach-common/head.S
@@ -153,6 +153,8 @@ ENTRY(__start)
 
 #ifdef CONFIG_EARLY_PRINTK
 	call _init_early_exception_vectors;
+	r0 = (EVT_IVHW | EVT_IRPTEN | EVT_EVX | EVT_NMI | EVT_RST | EVT_EMU);
+	sti r0;
 #endif
 
 	r0 = 0 (x);
@@ -212,12 +214,21 @@ ENTRY(__start)
 	[p0] = p1;
 	csync;
 
+#ifdef CONFIG_EARLY_PRINTK
+	r0 = (EVT_IVG15 | EVT_IVHW | EVT_IRPTEN | EVT_EVX | EVT_NMI | EVT_RST | EVT_EMU) (z);
+#else
 	r0 = EVT_IVG15 (z);
+#endif
 	sti r0;
 
 	raise 15;
+#ifdef CONFIG_EARLY_PRINTK
+	p0.l = _early_trap;
+	p0.h = _early_trap;
+#else
 	p0.l = .LWAIT_HERE;
 	p0.h = .LWAIT_HERE;
+#endif
 	reti = p0;
 #if ANOMALY_05000281
 	nop; nop; nop;
diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
index 68bd0bd..b88ce7f 100644
--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -33,6 +33,7 @@
 #include <asm/bfin-global.h>
 #include <asm/pda.h>
 #include <asm/cplbinit.h>
+#include <asm/early_printk.h>
 #include "blackfin_sram.h"
 
 /*
@@ -113,6 +114,8 @@ asmlinkage void __init init_pda(void)
 {
 	unsigned int cpu = raw_smp_processor_id();
 
+	early_shadow_stamp();
+
 	/* Initialize the PDA fields holding references to other parts
 	   of the memory. The content of such memory is still
 	   undefined at the time of the call, we are only setting up
-- 
1.6.4.2


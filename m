Return-Path: <linux-kernel-owner+w=401wt.eu-S934970AbXJOSrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934970AbXJOSrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934095AbXJOSh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:37:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:48424 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934186AbXJOSht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:37:49 -0400
Message-ID: <4713B281.8090702@windriver.com>
Date: Mon, 15 Oct 2007 13:33:37 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-arm-kernel@lists.arm.linux.org.uk
Subject: [PATCH 14/21] KGDB: KGDB arch support for ARM
Content-Type: multipart/mixed;
 boundary="------------060806070809080407060603"
X-OriginalArrivalTime: 15 Oct 2007 18:34:21.0094 (UTC) FILETIME=[008F8C60:01C80F5A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060806070809080407060603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------060806070809080407060603
Content-Type: text/x-patch;
 name="arm-lite.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="arm-lite.patch"

arm-lite.patch

From: Jason Wessel <jason.wessel@windriver.com>
CC: linux-arm-kernel@lists.arm.linux.org.uk
Subject: [PATCH] KGDB arch support for ARM

This adds a backend, written by Deepak Saxena <dsaxena@plexity.net>
and George Davis <gdavis@mvista.com> as well as support for the TI
OMAP boards, ADI Coyote, PXA2xx, ARM Versatile and PNX4008.  Geoff
Levand <geoffrey.levand@am.sony.com>, Nicolas Pitre, and Manish
Lachwani have contributed various fixups here as well.  This should
only require (on boards that don't have a custom uart) registering the
uart with KGDB to add any other boards, or using kgdboe it should Just
Work.

Signed-off-by: Milind Dumbare <milind@linsyssoft.com>
Signed-off-by: Dmitry Antipov <antipov@ru.mvista.com>
Signed-off-by: Tom Rini <trini@kernel.crashing.org>
Signed-off-by: Deepak Saxena <dsaxena@plexity.net>
Signed-off-by: Vitaly Wool <vwool@ru.mvista.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/arm/kernel/Makefile             |    1 
 arch/arm/kernel/kgdb-jmp.S           |   32 +++++
 arch/arm/kernel/kgdb.c               |  207 +++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c              |    5 
 arch/arm/kernel/traps.c              |   11 +
 arch/arm/mach-ixp2000/core.c         |    4 
 arch/arm/mach-ixp2000/ixdp2x01.c     |    6 +
 arch/arm/mach-ixp4xx/coyote-setup.c  |    4 
 arch/arm/mach-ixp4xx/ixdp425-setup.c |   21 ++-
 arch/arm/mach-omap1/serial.c         |    4 
 arch/arm/mach-pnx4008/core.c         |    4 
 arch/arm/mach-pxa/Makefile           |    1 
 arch/arm/mach-pxa/kgdb-serial.c      |   97 ++++++++++++++++
 arch/arm/mach-versatile/core.c       |    8 +
 arch/arm/mm/extable.c                |    7 +
 drivers/serial/Makefile              |    1 
 drivers/serial/amba-pl011.c          |    3 
 drivers/serial/pl011_kgdb.c          |  117 +++++++++++++++++++
 drivers/serial/pxa.c                 |    5 
 include/asm-arm/kgdb.h               |  103 +++++++++++++++++
 lib/Kconfig.kgdb                     |   55 ++++++++-
 21 files changed, 689 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm/kernel/kgdb-jmp.S
 create mode 100644 arch/arm/kernel/kgdb.c
 create mode 100644 arch/arm/mach-pxa/kgdb-serial.c
 create mode 100644 drivers/serial/pl011_kgdb.c
 create mode 100644 include/asm-arm/kgdb.h

--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_PCI)		+= bios32.o isa.o
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
+obj-$(CONFIG_KGDB)		+= kgdb.o kgdb-jmp.o
 
 obj-$(CONFIG_CRUNCH)		+= crunch.o crunch-bits.o
 AFLAGS_crunch-bits.o		:= -Wa,-mcpu=ep9312
--- /dev/null
+++ b/arch/arm/kernel/kgdb-jmp.S
@@ -0,0 +1,32 @@
+/*
+ * arch/arm/kernel/kgdb-jmp.S
+ *
+ * Trivial setjmp and longjmp procedures to support bus error recovery
+ * which may occur during kgdb memory read/write operations.
+ *
+ * Author: MontaVista Software, Inc. <source@mvista.com>
+ *         source@mvista.com
+ *
+ * 2002-2005 (c) MontaVista Software, Inc.  This file is licensed under the
+ * terms of the GNU General Public License version 2. This program as licensed
+ * "as is" without any warranty of any kind, whether express or implied.
+ */
+#include <linux/linkage.h>
+
+ENTRY (kgdb_fault_setjmp)
+	/* Save registers */
+	stmia	r0, {r0-r14}
+	str	lr,[r0, #60]
+	mrs	r1,cpsr
+	str	r1,[r0,#64]
+	ldr	r1,[r0,#4]
+	mov	r0, #0
+	mov	pc,lr
+
+ENTRY (kgdb_fault_longjmp)
+	/* Restore registers */
+	mov	r1,#1
+	str	r1,[r0]
+	ldr     r1,[r0, #64]
+	msr     spsr,r1
+	ldmia	r0,{r0-pc}^
--- /dev/null
+++ b/arch/arm/kernel/kgdb.c
@@ -0,0 +1,207 @@
+/*
+ * arch/arm/kernel/kgdb.c
+ *
+ * ARM KGDB support
+ *
+ * Copyright (c) 2002-2004 MontaVista Software, Inc
+ *
+ * Authors:  George Davis <davis_g@mvista.com>
+ *           Deepak Saxena <dsaxena@plexity.net>
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <linux/personality.h>
+#include <linux/ptrace.h>
+#include <linux/elf.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/kgdb.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/unistd.h>
+
+#include <asm/atomic.h>
+#include <asm/pgtable.h>
+#include <asm/system.h>
+#include <asm/traps.h>
+
+/* Make a local copy of the registers passed into the handler (bletch) */
+void regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *kernel_regs)
+{
+	int regno;
+
+	/* Initialize all to zero (??) */
+	for (regno = 0; regno < GDB_MAX_REGS; regno++)
+		gdb_regs[regno] = 0;
+
+	gdb_regs[_R0] = kernel_regs->ARM_r0;
+	gdb_regs[_R1] = kernel_regs->ARM_r1;
+	gdb_regs[_R2] = kernel_regs->ARM_r2;
+	gdb_regs[_R3] = kernel_regs->ARM_r3;
+	gdb_regs[_R4] = kernel_regs->ARM_r4;
+	gdb_regs[_R5] = kernel_regs->ARM_r5;
+	gdb_regs[_R6] = kernel_regs->ARM_r6;
+	gdb_regs[_R7] = kernel_regs->ARM_r7;
+	gdb_regs[_R8] = kernel_regs->ARM_r8;
+	gdb_regs[_R9] = kernel_regs->ARM_r9;
+	gdb_regs[_R10] = kernel_regs->ARM_r10;
+	gdb_regs[_FP] = kernel_regs->ARM_fp;
+	gdb_regs[_IP] = kernel_regs->ARM_ip;
+	gdb_regs[_SP] = kernel_regs->ARM_sp;
+	gdb_regs[_LR] = kernel_regs->ARM_lr;
+	gdb_regs[_PC] = kernel_regs->ARM_pc;
+	gdb_regs[_CPSR] = kernel_regs->ARM_cpsr;
+}
+
+/* Copy local gdb registers back to kgdb regs, for later copy to kernel */
+void gdb_regs_to_regs(unsigned long *gdb_regs, struct pt_regs *kernel_regs)
+{
+	kernel_regs->ARM_r0 = gdb_regs[_R0];
+	kernel_regs->ARM_r1 = gdb_regs[_R1];
+	kernel_regs->ARM_r2 = gdb_regs[_R2];
+	kernel_regs->ARM_r3 = gdb_regs[_R3];
+	kernel_regs->ARM_r4 = gdb_regs[_R4];
+	kernel_regs->ARM_r5 = gdb_regs[_R5];
+	kernel_regs->ARM_r6 = gdb_regs[_R6];
+	kernel_regs->ARM_r7 = gdb_regs[_R7];
+	kernel_regs->ARM_r8 = gdb_regs[_R8];
+	kernel_regs->ARM_r9 = gdb_regs[_R9];
+	kernel_regs->ARM_r10 = gdb_regs[_R10];
+	kernel_regs->ARM_fp = gdb_regs[_FP];
+	kernel_regs->ARM_ip = gdb_regs[_IP];
+	kernel_regs->ARM_sp = gdb_regs[_SP];
+	kernel_regs->ARM_lr = gdb_regs[_LR];
+	kernel_regs->ARM_pc = gdb_regs[_PC];
+	kernel_regs->ARM_cpsr = gdb_regs[_CPSR];
+}
+
+void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs,
+				 struct task_struct *task)
+{
+	int regno;
+	struct pt_regs *thread_regs;
+
+	/* Just making sure... */
+	if (task == NULL)
+		return;
+
+	/* Initialize to zero */
+	for (regno = 0; regno < GDB_MAX_REGS; regno++)
+		gdb_regs[regno] = 0;
+
+	/* Otherwise, we have only some registers from switch_to() */
+	thread_regs = task_pt_regs(task);
+	gdb_regs[_R0] = thread_regs->ARM_r0;	/* Not really valid? */
+	gdb_regs[_R1] = thread_regs->ARM_r1;	/* "               " */
+	gdb_regs[_R2] = thread_regs->ARM_r2;	/* "               " */
+	gdb_regs[_R3] = thread_regs->ARM_r3;	/* "               " */
+	gdb_regs[_R4] = thread_regs->ARM_r4;
+	gdb_regs[_R5] = thread_regs->ARM_r5;
+	gdb_regs[_R6] = thread_regs->ARM_r6;
+	gdb_regs[_R7] = thread_regs->ARM_r7;
+	gdb_regs[_R8] = thread_regs->ARM_r8;
+	gdb_regs[_R9] = thread_regs->ARM_r9;
+	gdb_regs[_R10] = thread_regs->ARM_r10;
+	gdb_regs[_FP] = thread_regs->ARM_fp;
+	gdb_regs[_IP] = thread_regs->ARM_ip;
+	gdb_regs[_SP] = thread_regs->ARM_sp;
+	gdb_regs[_LR] = thread_regs->ARM_lr;
+	gdb_regs[_PC] = thread_regs->ARM_pc;
+	gdb_regs[_CPSR] = thread_regs->ARM_cpsr;
+}
+
+static int compiled_break;
+
+int kgdb_arch_handle_exception(int exception_vector, int signo,
+			       int err_code, char *remcom_in_buffer,
+			       char *remcom_out_buffer,
+			       struct pt_regs *linux_regs)
+{
+	long addr;
+	char *ptr;
+
+	switch (remcom_in_buffer[0]) {
+	case 'D':
+	case 'k':
+	case 'c':
+		kgdb_contthread = NULL;
+
+		/*
+		 * Try to read optional parameter, pc unchanged if no parm.
+		 * If this was a compiled breakpoint, we need to move
+		 * to the next instruction or we will just breakpoint
+		 * over and over again.
+		 */
+		ptr = &remcom_in_buffer[1];
+		if (kgdb_hex2long(&ptr, &addr)) {
+			linux_regs->ARM_pc = addr;
+		} else if (compiled_break == 1) {
+			linux_regs->ARM_pc += 4;
+		}
+
+		compiled_break = 0;
+
+		return 0;
+	}
+
+	return -1;
+}
+
+static int kgdb_brk_fn(struct pt_regs *regs, unsigned int instr)
+{
+	if (!kgdb_io_ops.read_char)
+		return 1;
+
+	kgdb_handle_exception(1, SIGTRAP, 0, regs);
+
+	return 0;
+}
+
+static int kgdb_compiled_brk_fn(struct pt_regs *regs, unsigned int instr)
+{
+	if (!kgdb_io_ops.read_char)
+		return 1;
+
+	compiled_break = 1;
+	kgdb_handle_exception(1, SIGTRAP, 0, regs);
+
+	return 0;
+}
+
+static struct undef_hook kgdb_brkpt_hook = {
+	.instr_mask = 0xffffffff,
+	.instr_val = KGDB_BREAKINST,
+	.fn = kgdb_brk_fn
+};
+
+static struct undef_hook kgdb_compiled_brkpt_hook = {
+	.instr_mask = 0xffffffff,
+	.instr_val = KGDB_COMPILED_BREAK,
+	.fn = kgdb_compiled_brk_fn
+};
+
+/*
+ * Register our undef instruction hooks with ARM undef core.
+ * We regsiter a hook specifically looking for the KGB break inst
+ * and we handle the normal undef case within the do_undefinstr
+ * handler.
+ */
+int kgdb_arch_init(void)
+{
+	register_undef_hook(&kgdb_brkpt_hook);
+	register_undef_hook(&kgdb_compiled_brkpt_hook);
+
+	return 0;
+}
+
+struct kgdb_arch arch_kgdb_ops = {
+#ifndef __ARMEB__
+	.gdb_bpt_instr = {0xfe, 0xde, 0xff, 0xe7}
+#else /* ! __ARMEB__ */
+	.gdb_bpt_instr = {0xe7, 0xff, 0xde, 0xfe}
+#endif
+};
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -837,6 +837,11 @@ void __init setup_arch(char **cmdline_p)
 	conswitchp = &dummy_con;
 #endif
 #endif
+
+#if	defined(CONFIG_KGDB)
+	extern void __init early_trap_init(void);
+	early_trap_init();
+#endif
 }
 
 
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -302,6 +302,7 @@ asmlinkage void __exception do_undefinst
 	unsigned int instr;
 	struct undef_hook *hook;
 	siginfo_t info;
+	mm_segment_t fs;
 	void __user *pc;
 	unsigned long flags;
 
@@ -312,6 +313,8 @@ asmlinkage void __exception do_undefinst
 	 */
 	regs->ARM_pc -= correction;
 
+	fs = get_fs();
+	set_fs(KERNEL_DS);
 	pc = (void __user *)instruction_pointer(regs);
 
 	if (processor_mode(regs) == SVC_MODE) {
@@ -321,6 +324,7 @@ asmlinkage void __exception do_undefinst
 	} else {
 		get_user(instr, (u32 __user *)pc);
 	}
+	set_fs(fs);
 
 	spin_lock_irqsave(&undef_lock, flags);
 	list_for_each_entry(hook, &undef_hook, node) {
@@ -706,6 +710,13 @@ EXPORT_SYMBOL(abort);
 
 void __init trap_init(void)
 {
+#if   defined(CONFIG_KGDB)
+	return;
+}
+
+void __init early_trap_init(void)
+{
+#endif
 	unsigned long vectors = CONFIG_VECTORS_BASE;
 	extern char __stubs_start[], __stubs_end[];
 	extern char __vectors_start[], __vectors_end[];
--- a/arch/arm/mach-ixp2000/core.c
+++ b/arch/arm/mach-ixp2000/core.c
@@ -25,6 +25,7 @@
 #include <linux/bitops.h>
 #include <linux/serial_8250.h>
 #include <linux/mm.h>
+#include <linux/kgdb.h>
 
 #include <asm/types.h>
 #include <asm/setup.h>
@@ -184,6 +185,9 @@ static struct platform_device ixp2000_se
 void __init ixp2000_uart_init(void)
 {
 	platform_device_register(&ixp2000_serial_device);
+#ifdef CONFIG_KGDB_8250
+	kgdb8250_add_platform_port(0, &ixp2000_serial_port);
+#endif
 }
 
 
--- a/arch/arm/mach-ixp2000/ixdp2x01.c
+++ b/arch/arm/mach-ixp2000/ixdp2x01.c
@@ -30,6 +30,7 @@
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
+#include <linux/kgdb.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -413,6 +414,11 @@ static void __init ixdp2x01_init_machine
 	platform_add_devices(ixdp2x01_devices, ARRAY_SIZE(ixdp2x01_devices));
 	ixp2000_uart_init();
 	ixdp2x01_uart_init();
+
+#ifdef CONFIG_KGDB_8250
+	kgdb8250_add_platform_port(0, ixdp2x01_serial_port1);
+	kgdb8250_add_platform_port(1, ixdp2x01_serial_port1);
+#endif
 }
 
 
--- a/arch/arm/mach-ixp4xx/coyote-setup.c
+++ b/arch/arm/mach-ixp4xx/coyote-setup.c
@@ -96,6 +96,10 @@ static void __init coyote_init(void)
 	}
 
 	platform_add_devices(coyote_devices, ARRAY_SIZE(coyote_devices));
+
+#ifdef CONFIG_KGDB_8250
+	kgdb8250_add_platform_port(0, &coyote_uart_data);
+#endif
 }
 
 #ifdef CONFIG_ARCH_ADI_COYOTE
--- a/arch/arm/mach-ixp4xx/ixdp425-setup.c
+++ b/arch/arm/mach-ixp4xx/ixdp425-setup.c
@@ -14,6 +14,7 @@
 #include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/serial_8250.h>
+#include <linux/kgdb.h>
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/mtd/mtd.h>
@@ -152,7 +153,8 @@ static struct plat_serial8250_port ixdp4
 		.mapbase	= IXP4XX_UART1_BASE_PHYS,
 		.membase	= (char *)IXP4XX_UART1_BASE_VIRT + REG_OFFSET,
 		.irq		= IRQ_IXP4XX_UART1,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST |
+					UPF_SHARE_IRQ,
 		.iotype		= UPIO_MEM,
 		.regshift	= 2,
 		.uartclk	= IXP4XX_UART_XTAL,
@@ -161,7 +163,8 @@ static struct plat_serial8250_port ixdp4
 		.mapbase	= IXP4XX_UART2_BASE_PHYS,
 		.membase	= (char *)IXP4XX_UART2_BASE_VIRT + REG_OFFSET,
 		.irq		= IRQ_IXP4XX_UART2,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST |
+					UPF_SHARE_IRQ,
 		.iotype		= UPIO_MEM,
 		.regshift	= 2,
 		.uartclk	= IXP4XX_UART_XTAL,
@@ -219,12 +222,22 @@ static void __init ixdp425_init(void)
 	platform_add_devices(ixdp425_devices, ARRAY_SIZE(ixdp425_devices));
 }
 
+static void __init ixdp425_map_io(void)
+{
+	ixp4xx_map_io();
+
+#ifdef CONFIG_KGDB_8250
+	kgdb8250_add_platform_port(0, &ixdp425_uart_data[0]);
+	kgdb8250_add_platform_port(1, &ixdp425_uart_data[1]);
+#endif
+}
+
 #ifdef CONFIG_ARCH_IXDP425
 MACHINE_START(IXDP425, "Intel IXDP425 Development Platform")
 	/* Maintainer: MontaVista Software, Inc. */
 	.phys_io	= IXP4XX_PERIPHERAL_BASE_PHYS,
 	.io_pg_offst	= ((IXP4XX_PERIPHERAL_BASE_VIRT) >> 18) & 0xfffc,
-	.map_io		= ixp4xx_map_io,
+	.map_io		= ixdp425_map_io,
 	.init_irq	= ixp4xx_init_irq,
 	.timer		= &ixp4xx_timer,
 	.boot_params	= 0x0100,
@@ -237,7 +250,7 @@ MACHINE_START(IXDP465, "Intel IXDP465 De
 	/* Maintainer: MontaVista Software, Inc. */
 	.phys_io	= IXP4XX_PERIPHERAL_BASE_PHYS,
 	.io_pg_offst	= ((IXP4XX_PERIPHERAL_BASE_VIRT) >> 18) & 0xfffc,
-	.map_io		= ixp4xx_map_io,
+	.map_io		= ixdp425_map_io,
 	.init_irq	= ixp4xx_init_irq,
 	.timer		= &ixp4xx_timer,
 	.boot_params	= 0x0100,
--- a/arch/arm/mach-omap1/serial.c
+++ b/arch/arm/mach-omap1/serial.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/serial.h>
 #include <linux/tty.h>
+#include <linux/kgdb.h>
 #include <linux/serial_8250.h>
 #include <linux/serial_reg.h>
 #include <linux/clk.h>
@@ -199,6 +200,9 @@ void __init omap_serial_init(void)
 			break;
 		}
 		omap_serial_reset(&serial_platform_data[i]);
+#ifdef CONFIG_KGDB_8250
+		kgdb8250_add_platform_port(i, &serial_platform_data[i]);
+#endif
 	}
 }
 
--- a/arch/arm/mach-pnx4008/core.c
+++ b/arch/arm/mach-pnx4008/core.c
@@ -224,6 +224,10 @@ static void __init pnx4008_init(void)
 	spi_register_board_info(spi_board_info, ARRAY_SIZE(spi_board_info));
 	/* Switch on the UART clocks */
 	pnx4008_uart_init();
+#ifdef CONFIG_KGDB_8250
+	kgdb8250_add_platform_port(0, &platform_serial_ports[0]);
+	kgdb8250_add_platform_port(1, &platform_serial_ports[1]);
+#endif
 }
 
 static struct map_desc pnx4008_io_desc[] __initdata = {
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_LEDS) += $(led-y)
 # Misc features
 obj-$(CONFIG_PM) += pm.o sleep.o
 obj-$(CONFIG_PXA_SSP) += ssp.o
+obj-$(CONFIG_KGDB_PXA_SERIAL) += kgdb-serial.o
 
 ifeq ($(CONFIG_PXA27x),y)
 obj-$(CONFIG_PM) += standby.o
--- /dev/null
+++ b/arch/arm/mach-pxa/kgdb-serial.c
@@ -0,0 +1,97 @@
+/*
+ * linux/arch/arm/mach-pxa/kgdb-serial.c
+ *
+ * Provides low level kgdb serial support hooks for PXA2xx boards
+ *
+ * Author:	Nicolas Pitre
+ * Copyright:	(C) 2002-2005 MontaVista Software Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/serial_reg.h>
+#include <linux/kgdb.h>
+#include <asm/processor.h>
+#include <asm/hardware.h>
+#include <asm/arch/pxa-regs.h>
+
+#if   defined(CONFIG_KGDB_PXA_FFUART)
+
+#define UART		FFUART
+#define CKEN_UART	CKEN6_FFUART
+#define GPIO_RX_MD	GPIO34_FFRXD_MD
+#define GPIO_TX_MD	GPIO39_FFTXD_MD
+
+#elif defined(CONFIG_KGDB_PXA_BTUART)
+
+#define UART		BTUART
+#define CKEN_UART	CKEN7_BTUART
+#define GPIO_RX_MD	GPIO42_BTRXD_MD
+#define GPIO_TX_MD	GPIO43_BTTXD_MD
+
+#elif defined(CONFIG_KGDB_PXA_STUART)
+
+#define UART		STUART
+#define CKEN_UART	CKEN5_STUART
+#define GPIO_RX_MD	GPIO46_STRXD_MD
+#define GPIO_TX_MD	GPIO47_STTXD_MD
+
+#endif
+
+#define UART_BAUDRATE	(CONFIG_KGDB_BAUDRATE)
+
+static volatile unsigned long *port = (unsigned long *)&UART;
+
+static int kgdb_serial_init(void)
+{
+	pxa_set_cken(CKEN_UART, 1);
+	pxa_gpio_mode(GPIO_RX_MD);
+	pxa_gpio_mode(GPIO_TX_MD);
+
+	port[UART_IER] = 0;
+	port[UART_LCR] = LCR_DLAB;
+	port[UART_DLL] = ((921600 / UART_BAUDRATE) & 0xff);
+	port[UART_DLM] = ((921600 / UART_BAUDRATE) >> 8);
+	port[UART_LCR] = LCR_WLS1 | LCR_WLS0;
+	port[UART_MCR] = 0;
+	port[UART_IER] = IER_UUE;
+	port[UART_FCR] = FCR_ITL_16;
+
+	return 0;
+}
+
+static void kgdb_serial_putchar(u8 c)
+{
+	if (!(CKEN & CKEN_UART) || port[UART_IER] != IER_UUE)
+		kgdb_serial_init();
+	while (!(port[UART_LSR] & LSR_TDRQ))
+		cpu_relax();
+	port[UART_TX] = c;
+}
+
+static void kgdb_serial_flush(void)
+{
+	if ((CKEN & CKEN_UART) && (port[UART_IER] & IER_UUE))
+		while (!(port[UART_LSR] & LSR_TEMT))
+			cpu_relax();
+}
+
+static int kgdb_serial_getchar(void)
+{
+	unsigned char c;
+	if (!(CKEN & CKEN_UART) || port[UART_IER] != IER_UUE)
+		kgdb_serial_init();
+	while (!(port[UART_LSR] & UART_LSR_DR))
+		cpu_relax();
+	c = port[UART_RX];
+	return c;
+}
+
+struct kgdb_io kgdb_io_ops = {
+	.init = kgdb_serial_init,
+	.write_char = kgdb_serial_putchar,
+	.flush = kgdb_serial_flush,
+	.read_char = kgdb_serial_getchar,
+};
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -184,6 +184,14 @@ static struct map_desc versatile_io_desc
 		.type		= MT_DEVICE
 	},
 #endif
+#ifdef CONFIG_KGDB_AMBA_PL011
+	{
+		.virtual	=  IO_ADDRESS(CONFIG_KGDB_AMBA_BASE),
+		.pfn		= __phys_to_pfn(CONFIG_KGDB_AMBA_BASE),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE
+	},
+#endif
 #ifdef CONFIG_PCI
  	{
 		.virtual	=  IO_ADDRESS(VERSATILE_PCI_CORE_BASE),
--- a/arch/arm/mm/extable.c
+++ b/arch/arm/mm/extable.c
@@ -2,6 +2,7 @@
  *  linux/arch/arm/mm/extable.c
  */
 #include <linux/module.h>
+#include <linux/kgdb.h>
 #include <asm/uaccess.h>
 
 int fixup_exception(struct pt_regs *regs)
@@ -11,6 +12,12 @@ int fixup_exception(struct pt_regs *regs
 	fixup = search_exception_tables(instruction_pointer(regs));
 	if (fixup)
 		regs->ARM_pc = fixup->fixup;
+#ifdef CONFIG_KGDB
+	if (atomic_read(&debugger_active) && kgdb_may_fault)
+		/* Restore our previous state. */
+		kgdb_fault_longjmp(kgdb_fault_jmp_regs);
+		/* Not reached. */
+#endif
 
 	return fixup != NULL;
 }
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_SERIAL_8250_MCA) += 8250_mc
 obj-$(CONFIG_SERIAL_8250_AU1X00) += 8250_au1x00.o
 obj-$(CONFIG_SERIAL_AMBA_PL010) += amba-pl010.o
 obj-$(CONFIG_SERIAL_AMBA_PL011) += amba-pl011.o
+obj-$(CONFIG_KGDB_AMBA_PL011)	+= pl011_kgdb.o
 obj-$(CONFIG_SERIAL_CLPS711X) += clps711x.o
 obj-$(CONFIG_SERIAL_PXA) += pxa.o
 obj-$(CONFIG_SERIAL_PNX8XXX) += pnx8xxx_uart.o
--- a/drivers/serial/amba-pl011.c
+++ b/drivers/serial/amba-pl011.c
@@ -332,7 +332,8 @@ static int pl011_startup(struct uart_por
 	/*
 	 * Allocate the IRQ
 	 */
-	retval = request_irq(uap->port.irq, pl011_int, 0, "uart-pl011", uap);
+	retval = request_irq(uap->port.irq, pl011_int, IRQF_SHARED,
+			 "uart-pl011", uap);
 	if (retval)
 		goto clk_dis;
 
--- /dev/null
+++ b/drivers/serial/pl011_kgdb.c
@@ -0,0 +1,117 @@
+/*
+ * driver/serial/pl011_kgdb.c
+ *
+ * Support for KGDB on ARM AMBA PL011 UARTs
+ *
+ * Authors: Manish Lachwani <mlachwani@mvista.com>
+ *          Deepak Saxena <dsaxena@plexity.net>
+ *
+ * Copyright (c) 2005-2007 MontaVista Software, Inc.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether expressor implied.
+ *
+ */
+#include <linux/kgdb.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/serial.h>
+#include <linux/io.h>
+
+#include <asm/processor.h>
+#include <asm/hardware.h>
+
+static int kgdb_irq = CONFIG_KGDB_AMBA_IRQ;
+
+#define UART_DIVISOR	(CONFIG_KGDB_AMBA_UARTCLK * 4 / CONFIG_KGDB_BAUDRATE)
+/*
+ * Todo: IO_ADDRESS is not very generic across ARM...
+ */
+static volatile unsigned char *kgdb_port =
+	(unsigned char *)IO_ADDRESS(CONFIG_KGDB_AMBA_BASE);
+
+/*
+ * Init code taken from amba-pl011.c.
+ */
+static int kgdb_serial_init(void)
+{
+	writew(0, kgdb_port + UART010_CR);
+
+	/* Set baud rate */
+	writew(UART_DIVISOR & 0x3f, kgdb_port + UART011_FBRD);
+	writew(UART_DIVISOR >> 6, kgdb_port + UART011_IBRD);
+
+	writew(UART01x_LCRH_WLEN_8 | UART01x_LCRH_FEN, kgdb_port +
+		UART010_LCRH);
+	writew(UART01x_CR_UARTEN | UART011_CR_TXE | UART011_CR_RXE,
+	       kgdb_port + UART010_CR);
+
+	writew(UART011_RXIM, kgdb_port + UART011_IMSC);
+
+	return 0;
+}
+
+static void kgdb_serial_putchar(u8 ch)
+{
+	unsigned int status;
+
+	do {
+		status = readw(kgdb_port + UART01x_FR);
+	} while (status & UART01x_FR_TXFF);
+
+	writew(ch, kgdb_port + UART01x_DR);
+}
+
+static int kgdb_serial_getchar(void)
+{
+	unsigned int status;
+	int ch;
+
+#ifdef CONFIG_DEBUG_LL_OLD
+	printascii("Entering serial_getchar loop");
+#endif
+	do {
+		status = readw(kgdb_port + UART01x_FR);
+	} while (status & UART01x_FR_RXFE);
+	ch = readw(kgdb_port + UART01x_DR);
+#ifdef CONFIG_DEBUG_LL_OLD
+	printascii("Exited serial_getchar loop");
+	printascii("Read char: ");
+	printch(ch);
+	printascii("\n");
+#endif
+	return ch;
+}
+
+static irqreturn_t kgdb_interrupt(int irq, void *dev_id)
+{
+	int status = readw(kgdb_port + UART011_MIS);
+
+#ifdef CONFIG_DEBUG_LL_OLD
+	printascii("KGDB irq\n");
+#endif
+	if (irq != kgdb_irq)
+		return IRQ_NONE;
+
+	if (status & 0x40)
+		breakpoint();
+
+	return IRQ_HANDLED;
+}
+
+static void __init kgdb_hookup_irq(void)
+{
+	int retval;
+	retval = request_irq(kgdb_irq, kgdb_interrupt, IRQF_SHARED,
+		"KGDB-serial", (void *)kgdb_port);
+	if (retval) {
+		printk(KERN_ERR "pl011_kgdb: ERROR requesting irq\n");
+	}
+}
+
+struct kgdb_io kgdb_io_ops = {
+	.init = kgdb_serial_init,
+	.write_char = kgdb_serial_putchar,
+	.read_char  = kgdb_serial_getchar,
+	.late_init  = kgdb_hookup_irq,
+};
--- a/drivers/serial/pxa.c
+++ b/drivers/serial/pxa.c
@@ -42,6 +42,9 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial_core.h>
+#ifdef CONFIG_KGDB_CONSOLE
+#include <linux/kgdb.h>
+#endif
 
 #include <asm/io.h>
 #include <asm/hardware.h>
@@ -690,6 +693,8 @@ serial_pxa_console_init(void)
 console_initcall(serial_pxa_console_init);
 
 #define PXA_CONSOLE	&serial_pxa_console
+#elif defined(CONFIG_KGDB_CONSOLE)
+#define PXA_CONSOLE	&kgdbcons
 #else
 #define PXA_CONSOLE	NULL
 #endif
--- /dev/null
+++ b/include/asm-arm/kgdb.h
@@ -0,0 +1,103 @@
+/*
+ * include/asm-arm/kgdb.h
+ *
+ * ARM KGDB support
+ *
+ * Author: Deepak Saxena <dsaxena@mvista.com>
+ *
+ * Copyright (C) 2002 MontaVista Software Inc.
+ *
+ */
+
+#ifndef __ASM_KGDB_H__
+#define __ASM_KGDB_H__
+
+#include <linux/ptrace.h>
+#include <asm-generic/kgdb.h>
+
+
+/*
+ * GDB assumes that we're a user process being debugged, so
+ * it will send us an SWI command to write into memory as the
+ * debug trap. When an SWI occurs, the next instruction addr is
+ * placed into R14_svc before jumping to the vector trap.
+ * This doesn't work for kernel debugging as we are already in SVC
+ * we would loose the kernel's LR, which is a bad thing. This
+ * is  bad thing.
+ *
+ * By doing this as an undefined instruction trap, we force a mode
+ * switch from SVC to UND mode, allowing us to save full kernel state.
+ *
+ * We also define a KGDB_COMPILED_BREAK which can be used to compile
+ * in breakpoints. This is important for things like sysrq-G and for
+ * the initial breakpoint from trap_init().
+ *
+ * Note to ARM HW designers: Add real trap support like SH && PPC to
+ * make our lives much much simpler. :)
+ */
+#define	BREAK_INSTR_SIZE		4
+#define GDB_BREAKINST                   0xef9f0001
+#define KGDB_BREAKINST                  0xe7ffdefe
+#define KGDB_COMPILED_BREAK             0xe7ffdeff
+#define CACHE_FLUSH_IS_SAFE		1
+
+#ifndef	__ASSEMBLY__
+
+#define	BREAKPOINT()			asm(".word 	0xe7ffdeff")
+
+
+extern void kgdb_handle_bus_error(void);
+extern int kgdb_fault_expected;
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * From Kevin Hilman:
+ *
+ * gdb is expecting the following registers layout.
+ *
+ * r0-r15: 1 long word each
+ * f0-f7:  unused, 3 long words each !!
+ * fps:    unused, 1 long word
+ * cpsr:   1 long word
+ *
+ * Even though f0-f7 and fps are not used, they need to be
+ * present in the registers sent for correct processing in
+ * the host-side gdb.
+ *
+ * In particular, it is crucial that CPSR is in the right place,
+ * otherwise gdb will not be able to correctly interpret stepping over
+ * conditional branches.
+ */
+#define _GP_REGS 		16
+#define _FP_REGS 		8
+#define _EXTRA_REGS 		2
+#define	GDB_MAX_REGS		(_GP_REGS + (_FP_REGS * 3) + _EXTRA_REGS)
+
+#define	KGDB_MAX_NO_CPUS	1
+#define	BUFMAX			400
+#define	NUMREGBYTES		(GDB_MAX_REGS << 2)
+#define	NUMCRITREGBYTES		(32 << 2)
+
+#define	_R0		0
+#define	_R1		1
+#define	_R2		2
+#define	_R3		3
+#define	_R4		4
+#define	_R5		5
+#define	_R6		6
+#define	_R7		7
+#define	_R8		8
+#define	_R9		9
+#define	_R10		10
+#define	_FP		11
+#define	_IP		12
+#define	_SP		13
+#define	_LR		14
+#define	_PC		15
+#define	_CPSR		(GDB_MAX_REGS - 1)
+
+/* So that we can denote the end of a frame for tracing, in the simple
+ * case. */
+#define CFI_END_FRAME(func)	__CFI_END_FRAME(_PC, _SP, func)
+
+#endif /* __ASM_KGDB_H__ */
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -14,7 +14,7 @@ config KGDB
 	bool "KGDB: kernel debugging with remote gdb"
 	select WANT_EXTRA_DEBUG_INFORMATION
 	select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
-	depends on DEBUG_KERNEL && (X86 || MIPS || (SUPERH && !SUPERH64) || IA64 || PPC)
+	depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64 || PPC)
 	help
 	  If you say Y here, it will be possible to remotely debug the
 	  kernel using gdb.  Documentation of kernel debugger is available
@@ -45,6 +45,8 @@ choice
 	default KGDB_SIBYTE if SIBYTE_SB1xxx_SOC
  	default KGDB_TXX9 if CPU_TX49XX
 	default KGDB_SH_SCI if SERIAL_SH_SCI
+	default KGDB_PXA_SERIAL if ARCH_PXA
+	default KGDB_AMBA_PL011 if ARM_AMBA
 	default KGDB_8250_NOMODULE
 	help
 	  There are a number of different ways in which you can communicate
@@ -111,6 +113,34 @@ config KGDB_SH_SCI
 	depends on SUPERH && SERIAL_SH_SCI
 	help
 	  Uses the SH SCI(F) serial port to communicate with the host GDB.
+
+config KGDB_AMBA_PL011
+	bool "KGDB: On ARM AMBA PL011 Serial Port"
+	depends on ARM && ARCH_VERSATILE
+	help
+	  Enables the KGDB serial driver for the AMBA bus PL011 serial
+          devices from ARM.
+
+config KGDB_PXA_SERIAL
+	bool "KGDB: On the PXA2xx serial port"
+	depends on ARCH_PXA
+	help
+	  Enables the KGDB serial driver for Intel PXA SOC
+endchoice
+
+choice
+	prompt "PXA UART to use for KGDB"
+	depends on KGDB_PXA_SERIAL
+	default KGDB_PXA_FFUART
+
+config KGDB_PXA_FFUART
+	bool "FFUART"
+
+config KGDB_PXA_BTUART
+	bool "BTUART"
+
+config KGDB_PXA_STUART
+	bool "STUART"
 endchoice
 
 choice
@@ -179,7 +209,7 @@ config KGDB_BAUDRATE
 	int "Debug serial port baud rate"
 	depends on (KGDB_8250 && KGDB_SIMPLE_SERIAL) || \
 		KGDB_MPSC || KGDB_CPM_UART || \
-		KGDB_TXX9
+		KGDB_TXX9 || KGDB_PXA_SERIAL || KGDB_AMBA_PL011
 	default "115200"
 	help
 	  gdb and the kernel stub need to agree on the baud rate to be
@@ -195,6 +225,27 @@ config KGDB_PORT_NUM
 	help
 	  Pick the port number (0 based) for KGDB to use.
 
+config KGDB_AMBA_BASE
+	hex "AMBA PL011 Serial Port Base Address"
+	default 0x101f2000 if ARCH_VERSATILE
+	depends on KGDB_AMBA_PL011
+	help
+	  Base address of the AMBA port that KGDB will use.
+
+config KGDB_AMBA_UARTCLK
+	int "AMBAPL011 Serial UART Clock Frequency"
+	default 24000000 if ARCH_VERSATILE
+	depends on KGDB_AMBA_PL011
+	help
+	  Frequency (in HZ) of the ARM AMBA UART clock
+
+config KGDB_AMBA_IRQ
+	int "AMBA PL011 Serial Port IRQ"
+	default 13 if ARCH_VERSATILE
+	depends on KGDB_AMBA_PL011
+	help
+	  Pick the IRQ of the AMBA port that KGDB will use.
+
 config KGDB_8250_CONF_STRING
 	string "Configuration string for KGDB"
 	depends on KGDB_8250_NOMODULE && !KGDB_SIMPLE_SERIAL

--------------060806070809080407060603--

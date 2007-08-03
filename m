Return-Path: <linux-kernel-owner+w=401wt.eu-S1763395AbXHCT00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763395AbXHCT00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 15:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbXHCT0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 15:26:19 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:44654 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758704AbXHCT0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 15:26:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OtM26fvA8qyeQSHpz2AL3MccMWchBSphCxQp7ZDpcSbE/Iy9A4ceetuCOn3RkaaoatYuIKzGvts3lRGQkjPIzHZz5mCQHDLqPKPnzletzN3KCcdK6Ioe/2b7x1P4B4pPCp94GkfYNV6xQ6qpbv7KPg7DqzcH0sP2dF55tnswf+w=
Message-ID: <8b67d60708031226m747f142sd3ed4447fb896a94@mail.gmail.com>
Date: Fri, 3 Aug 2007 20:26:17 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, linuxsh-dev@lists.sourceforge.net
Subject: [PATCH] SH: add machine-ops and Dreamcast specific fix-up
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(This code is closely modelled on the i386 machine-ops, though
currently the only board specific fixup is for the Dreamcast and so
there is not a separate set of mach fixups.)

This needs to be tested against a wide range of SH boards and would be
good to go in -mm if Paul acks it.

Add machine-ops code to the SH code base, allowing board specific
reboot and halt code. Currently only Dreamcast specific warm reboot
fixup in code.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

diff --git a/arch/sh/boards/dreamcast/Makefile
b/arch/sh/boards/dreamcast/Makefile
index e6fcd3d..7b97546 100644
--- a/arch/sh/boards/dreamcast/Makefile
+++ b/arch/sh/boards/dreamcast/Makefile
@@ -2,5 +2,5 @@
 # Makefile for the Sega Dreamcast specific parts of the kernel
 #

-obj-y	 := setup.o irq.o rtc.o reboot.o
+obj-y	 := setup.o irq.o rtc.o

diff --git a/arch/sh/kernel/Makefile b/arch/sh/kernel/Makefile
index bdb30ba..7ab2359 100644
--- a/arch/sh/kernel/Makefile
+++ b/arch/sh/kernel/Makefile
@@ -5,15 +5,11 @@
 extra-y	:= head.o init_task.o vmlinux.lds

 obj-y	:= debugtraps.o io.o io_generic.o irq.o machvec.o process.o ptrace.o \
-	   semaphore.o setup.o signal.o sys_sh.o syscalls.o \
+	   reboot.o semaphore.o setup.o signal.o sys_sh.o syscalls.o \
 	   time.o topology.o traps.o

 obj-y				+= cpu/ timers/

-ifneq ($(CONFIG_SH_DREAMCAST),y)
-	obj-y			+= reboot.o
-endif
-
 obj-$(CONFIG_VSYSCALL)		+= vsyscall/

 obj-$(CONFIG_SMP)		+= smp.o
diff --git a/arch/sh/kernel/machine_kexec.c b/arch/sh/kernel/machine_kexec.c
index 790ed69..201b370 100644
--- a/arch/sh/kernel/machine_kexec.c
+++ b/arch/sh/kernel/machine_kexec.c
@@ -29,9 +29,6 @@ extern const unsigned char relocate_new_kernel[];
 extern const unsigned int relocate_new_kernel_size;
 extern void *gdb_vbr_vector;

-void machine_shutdown(void)
-{
-}

 void machine_crash_shutdown(struct pt_regs *regs)
 {
diff --git a/arch/sh/kernel/reboot.c b/arch/sh/kernel/reboot.c
new file mode 100644
index 0000000..c6247ae
--- /dev/null
+++ b/arch/sh/kernel/reboot.c
@@ -0,0 +1,107 @@
+/*
+ *  linux/arch/sh/kernel/reboot.c
+ *
+ *  Essentially copied from i386 code
+ *  and process.c
+ *
+ *  Copyright (C) 1995  Linus Torvalds
+ *
+ *  SuperH version:  Copyright (C) 1999, 2000  Niibe Yutaka & Kaz Kojima
+ *		     Copyright (C) 2006 Lineo Solutions Inc. support SH4A UBC
+ *		     Copyright (C) 2002 - 2007  Paul Mundt
+ *		     Copyright 2007 Adrian McMenamin
+ *
+ *  Licensed under the terms of version 2 of GNU GPL
+ */
+
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <asm/io.h>
+#include <asm/reboot.h>
+
+/*
+ * Power off function, if any
+ */
+void (*pm_power_off)(void);
+EXPORT_SYMBOL(pm_power_off);
+
+/* fixups for individual machines -
+ * in i386 this is in a file of its own
+ * but we only have the Dreamcast for now.
+ */
+
+static void mach_reboot_fixups(void)
+{
+	if (mach_is_dreamcast()) {
+		writel(0x00007611, 0xA05F6890);
+	}
+}
+
+static void native_machine_shutdown(void)
+{
+}
+
+static void native_machine_emergency_restart(void)
+{
+	mach_reboot_fixups();
+	/* SR.BL=1 and invoke address error to let CPU reset (manual reset) */
+	asm volatile("ldc %0, sr\n\t"
+		     "mov.l @%1, %0" : : "r" (0x10000000), "r" (0x80000001));
+}
+
+static void native_machine_restart(char * __unused)
+{
+	native_machine_shutdown();
+	native_machine_emergency_restart();
+}
+
+static void native_machine_halt(void)
+{
+	local_irq_disable();
+
+	while (1)
+		cpu_sleep();
+}
+
+static void native_machine_power_off(void)
+{
+	if (pm_power_off) {
+		native_machine_shutdown();
+		pm_power_off();
+	}
+}
+
+struct machine_ops machine_ops = {
+	.power_off = native_machine_power_off,
+	.shutdown = native_machine_shutdown,
+	.emergency_restart = native_machine_emergency_restart,
+	.restart = native_machine_restart,
+	.halt = native_machine_halt,
+};
+
+void machine_power_off(void)
+{
+	machine_ops.power_off();
+}
+
+void machine_shutdown(void)
+{
+	machine_ops.shutdown();
+}
+
+void machine_emergency_restart(void)
+{
+	machine_ops.emergency_restart();
+}
+
+void machine_restart(char *cmd)
+{
+	machine_ops.restart(cmd);
+}
+
+void machine_halt(void)
+{
+	machine_ops.halt();
+}
diff --git a/include/asm-sh/emergency-restart.h
b/include/asm-sh/emergency-restart.h
index 108d8c4..d6bec92 100644
--- a/include/asm-sh/emergency-restart.h
+++ b/include/asm-sh/emergency-restart.h
@@ -1,6 +1,6 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
+#ifndef _ASM_SH_EMERGENCY_RESTART_H
+#define _ASM_SH_EMERGENCY_RESTART_H

-#include <asm-generic/emergency-restart.h>
+extern void machine_emergency_restart(void);

-#endif /* _ASM_EMERGENCY_RESTART_H */
+#endif /* _ASM_SH_EMERGENCY_RESTART_H */

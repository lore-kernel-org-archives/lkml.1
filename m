Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbYDSRgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbYDSRgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 13:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbYDSRgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 13:36:47 -0400
Received: from mail.queued.net ([207.210.101.209]:2745 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856AbYDSRgp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 13:36:45 -0400
Date: Sat, 19 Apr 2008 13:39:09 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, jordan.crouse@amd.com,
       Mitch Bradley <wmb@firmworks.com>
Subject: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
Message-ID: <20080419133909.5aa6b63e@ephemeral>
In-Reply-To: <20080419092544.378664a8@ephemeral>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<20080419031024.GC3503@nineveh.local>
	<20080418202925.b18452c5.akpm@linux-foundation.org>
	<20080419092544.378664a8@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds 32-bit support for calling into OFW from the kernel.  It's useful
for querying the firmware for misc hardware information, fetching the device
tree, etc.

There's potentially no reason why other platforms couldn't use this, but
currently OLPC is the main user of it.

This work was originally done by Mitch Bradley.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 arch/x86/Kconfig          |    8 +++++
 arch/x86/kernel/Makefile  |    1 +
 arch/x86/kernel/head_32.S |   27 ++++++++++++++++
 arch/x86/kernel/ofw.c     |   75 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/ofw.h     |   50 ++++++++++++++++++++++++++++++
 include/asm-x86/setup.h   |    1 +
 6 files changed, 162 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/ofw.c
 create mode 100644 include/asm-x86/ofw.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3b9089b..ce56105 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -661,6 +661,14 @@ config I8K
 	  Say Y if you intend to run this kernel on a Dell Inspiron 8000.
 	  Say N otherwise.
 
+config OPEN_FIRMWARE
+	bool "Support for Open Firmware"
+	default y if OLPC
+	---help---
+	  This option adds support for the implementation of Open Firmware
+	  that is used on the OLPC XO laptop.
+	  If unsure, say N here.
+
 config X86_REBOOTFIXUPS
 	def_bool n
 	prompt "Enable X86 board specific fixups for reboot"
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9575754..d33600e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse_$(BITS).o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_$(BITS).o nmi_$(BITS).o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic_$(BITS).o
+obj-$(CONFIG_OPEN_FIRMWARE)	+= ofw.o
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 74d87ea..c9d2d00 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -132,6 +132,33 @@ ENTRY(startup_32)
 	movsl
 1:
 
+#ifdef CONFIG_OPEN_FIRMWARE
+/*
+ * If Open Firmware booted us, save the OFW client interface callback address
+ * and preserve the OFW page mappings by priming the kernel's new page
+ * directory area with a copy of the OFW page directory.  That lets OFW stay
+ * resident in high memory (high in both the virtual and physical spaces)
+ * for at least long enough to copy out the device tree.
+ */
+	movl $pa(boot_params + OFW_INFO_OFFSET), %ebp
+	cmpl $0x2057464F, (%ebp)		/* Magic number "OFW " */
+	jne 4f
+
+	mov 0x8(%ebp), %eax			/* Save callback address */
+	mov %eax, pa(call_firmware)
+
+	/* Copy the OFW pdir into swapper_pg_dir */
+	movl %esi, %edx		/* save %esi */
+	movl $pa(swapper_pg_dir), %edi
+	movl %cr3, %esi		/* Source is current pg_dir base address */
+	movl $1024, %ecx	/* Number of page directory entries */
+	rep
+	movsl
+	movl %edx, %esi		/* restore %esi */
+4:
+
+#endif
+
 #ifdef CONFIG_PARAVIRT
 	/* This is can only trip for a broken bootloader... */
 	cmpw $0x207, pa(boot_params + BP_version)
diff --git a/arch/x86/kernel/ofw.c b/arch/x86/kernel/ofw.c
new file mode 100644
index 0000000..14036aa
--- /dev/null
+++ b/arch/x86/kernel/ofw.c
@@ -0,0 +1,75 @@
+/*
+ * Open Firmware client interface for 32-bit systems.
+ *
+ * Copyright © 2007  Mitch Bradley <wmb@firmworks.com>
+ * Copyright © 2007-2008  Andres Salomon <dilinger@debian.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <asm/ofw.h>
+
+/*
+ * This code is intended to be portable to any 32-bit Open Firmware
+ * implementation with a standard client interface that can be
+ * called when Linux is running.
+ *
+ * The return value from ofw() in all cases is 0 if the attempt to call the
+ * function succeeded.  The return value is from the Linux function only; any
+ * results from OFW are returned via output argument pointers.
+ */
+
+#define MAXARGS 20
+
+int (*call_firmware)(int *);
+static DEFINE_SPINLOCK(prom_lock);
+
+int ofw(const char *name, int nr_args, int nr_results, ...)
+{
+	unsigned long flags;
+	va_list args;
+	int argarray[MAXARGS+3];
+	int retval;
+	int *intp;
+	int i;
+
+	if (!call_firmware)
+		return -ENODEV;
+
+	if ((nr_args + nr_results) > MAXARGS)
+		return -EIO;	/* spit out an error? */
+
+	/* Stuff the arguments into argarray */
+	argarray[0] = (int) name;
+	argarray[1] = nr_args;
+	argarray[2] = nr_results;
+
+	va_start(args, nr_results);
+	for (i = 3; nr_args; i++) {
+		argarray[i] = va_arg(args, int);
+		nr_args--;
+	}
+
+	/* Call into Open Firmware */
+	spin_lock_irqsave(&prom_lock, flags);
+	retval = call_firmware(argarray);
+	spin_unlock_irqrestore(&prom_lock, flags);
+
+	if (retval == 0) {
+		while (nr_results) {
+			intp = va_arg(args, int *);
+			*intp = argarray[i++];
+			nr_results--;
+		}
+	}
+
+	va_end(args);
+	return retval;
+}
+EXPORT_SYMBOL_GPL(ofw);
diff --git a/include/asm-x86/ofw.h b/include/asm-x86/ofw.h
new file mode 100644
index 0000000..7d064f8
--- /dev/null
+++ b/include/asm-x86/ofw.h
@@ -0,0 +1,50 @@
+/*
+ * Definitions for Open Firmware client interface on 32-bit system.
+ * OF Cell size is 4. Integer properties are encoded big endian,
+ * as with all OF implementations.
+ */
+#ifndef _OFW_H
+#define _OFW_H
+#ifdef __KERNEL__
+
+extern int ofw(const char *name, int nr_args, int nr_results, ...);
+
+typedef uint32_t ofw_phandle;
+typedef uint32_t ofw_ihandle;
+
+/*
+ * Here are call templates for standard OFW client services:
+ *
+ * ofw("test", 1, 1, namestr, &missing);
+ * ofw("peer", 1, 1, phandle, &sibling_phandle);
+ * ofw("child", 1, 1, phandle, &child_phandle);
+ * ofw("parent", 1, 1, phandle, &parent_phandle);
+ * ofw("instance_to_package", 1, 1, ihandle, &phandle);
+ * ofw("getproplen", 2, 1, phandle, namestr, &proplen);
+ * ofw("getprop", 4, 1, phandle, namestr, bufaddr, buflen, &size);
+ * ofw("nextprop", 3, 1, phandle, previousstr, bufaddr, &flag);
+ * ofw("setprop", 4, 1, phandle, namestr, bufaddr, len, &size);
+ * ofw("canon", 3, 1, devspecstr, bufaddr, buflen, &length);
+ * ofw("finddevice", 1, 1, devspecstr, &phandle);
+ * ofw("instance-to-path", 3, 1, ihandle, bufaddr, buflen, &length);
+ * ofw("package-to-path", 3, 1, phandle, bufaddr, buflen, &length);
+ * ofw("call_method", numin, numout, in0, in1, ..., &out0, &out1, ...);
+ * ofw("open", 1, 1, devspecstr, &ihandle);
+ * ofw("close", 1, 0, ihandle);
+ * ofw("read", 3, 1, ihandle, addr, len, &actual);
+ * ofw("write", 3, 1, ihandle, addr, len, &actual);
+ * ofw("seek", 3, 1, ihandle, pos_hi, pos_lo, &status);
+ * ofw("claim", 3, 1, virtaddr, size, align, &baseaddr);
+ * ofw("release", 2, 0, virtaddr, size);
+ * ofw("boot", 1, 0, bootspecstr);
+ * ofw("enter", 0, 0);
+ * ofw("exit", 0, 0);
+ * ofw("chain", 5, 0, virtaddr, size, entryaddr, argsaddr, len);
+ * ofw("interpret", numin+1, numout+1, cmdstr, in0, ..., &catchres, &out0, ...)
+ * ofw("set-callback", 1, 1, newfuncaddr, &oldfuncaddr);
+ * ofw("set-symbol-lookup", 2, 0, symtovaladdr, valtosymaddr);
+ * ofw("milliseconds", 0, 1, &ms);
+ */
+
+#endif
+#endif
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index 071e054..8e2b674 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -28,6 +28,7 @@ char *machine_specific_memory_setup(void);
 #define OLD_CL_MAGIC		0xA33F
 #define OLD_CL_ADDRESS		0x020	/* Relative to real mode data */
 #define NEW_CL_POINTER		0x228	/* Relative to real mode data */
+#define OFW_INFO_OFFSET		0xb0	/* Relative to real mode data */
 
 #ifndef __ASSEMBLY__
 #include <asm/bootparam.h>
-- 
1.5.4.4


-- 
Need a kernel or Debian developer?  Contact me, I'm looking for contracts.

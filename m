Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZIXOnC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZIXOnC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:43:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZIXOm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:42:59 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48091 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbZIXOm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:42:58 -0400
X-Greylist: delayed 2108 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 10:42:44 EDT
Message-Id: <20090924133400.200554799@polymtl.ca>
References: <20090924132626.485545323@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Sep 2009 09:26:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 08/12] sparc64: Optimized immediate value implementation.
Content-Disposition: inline; filename=sparc64-immedate-values.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 24 Sep 2009 14:07:33 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit f2b14974b823a9cd9b6f5c0d423945caa15de8a2
Author: David S. Miller <davem@davemloft.net>
Date:   Tue May 13 04:29:30 2008 -0700

We can only do byte sized values currently.

In order to support even 16-bit immediates we would need a 2
instruction sequence.

I believe that can be made to work with a suitable breakpoint or some
other kind of special patching sequence, but that isn't attempted
here.

[edit by Mathieu Desnoyers]
Use _ASM_PTR and _ASM_UAPTR 32/64 bits compatibility macros.

Use "unsigned long" type to encode pointers, with uaxword on sparc64 and uaword
on sparc32.

Disable immediate values on gcc < 4.0.0, because it seems to have problem with
passing pointers as "i" inline asm constraint.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/sparc/Kconfig                 |    1 
 arch/sparc/Makefile                |    4 +++
 arch/sparc/include/asm/immediate.h |   40 ++++++++++++++++++++++++++++++
 arch/sparc/kernel/Makefile         |    1 
 arch/sparc/kernel/immediate.c      |   48 +++++++++++++++++++++++++++++++++++++
 5 files changed, 94 insertions(+)

Index: linux.trees.git/arch/sparc/Kconfig
===================================================================
--- linux.trees.git.orig/arch/sparc/Kconfig	2009-09-24 08:52:41.000000000 -0400
+++ linux.trees.git/arch/sparc/Kconfig	2009-09-24 09:01:13.000000000 -0400
@@ -48,6 +48,7 @@ config SPARC64
 	select RTC_DRV_SUN4V
 	select RTC_DRV_STARFIRE
 	select HAVE_PERF_EVENTS
+	select HAVE_IMMEDIATE
 
 config ARCH_DEFCONFIG
 	string
Index: linux.trees.git/arch/sparc/kernel/Makefile
===================================================================
--- linux.trees.git.orig/arch/sparc/kernel/Makefile	2009-09-24 08:52:41.000000000 -0400
+++ linux.trees.git/arch/sparc/kernel/Makefile	2009-09-24 09:01:55.000000000 -0400
@@ -91,6 +91,7 @@ obj-$(CONFIG_SPARC64_PCI)    += pci_sun4
 obj-$(CONFIG_PCI_MSI)        += pci_msi.o
 
 obj-$(CONFIG_COMPAT)         += sys32.o sys_sparc32.o signal32.o
+obj-$(USE_IMMEDIATE)	     += immediate.o
 
 # sparc64 cpufreq
 obj-$(CONFIG_US3_FREQ)  += us3_cpufreq.o
Index: linux.trees.git/arch/sparc/kernel/immediate.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/arch/sparc/kernel/immediate.c	2009-09-24 09:00:57.000000000 -0400
@@ -0,0 +1,48 @@
+#include <linux/module.h>
+#include <linux/immediate.h>
+#include <linux/string.h>
+#include <linux/kprobes.h>
+
+#include <asm/system.h>
+
+int arch_imv_update(const struct __imv *imv, int early)
+{
+	unsigned long imv_vaddr = imv->imv;
+	unsigned long var_vaddr = imv->var;
+	u32 insn, *ip = (u32 *) imv_vaddr;
+
+	insn = *ip;
+
+#ifdef CONFIG_KPROBES
+	switch (imv->size) {
+	case 1:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (unlikely(!early &&
+		     (insn == BREAKPOINT_INSTRUCTION ||
+		      insn == BREAKPOINT_INSTRUCTION_2))) {
+		printk(KERN_WARNING "Immediate value in conflict with kprobe. "
+				    "Variable at %p, "
+				    "instruction at %p, size %u\n",
+				    ip, (void *)var_vaddr, imv->size);
+		return -EBUSY;
+	}
+#endif
+
+	switch (imv->size) {
+	case 1:
+		if ((insn & 0x1fff) == *(uint8_t *)var_vaddr)
+			return 0;
+		insn &= ~0x00001fff;
+		insn |= (u32) (*(uint8_t *)var_vaddr);
+		break;
+	default:
+		return -EINVAL;
+	}
+	*ip = insn;
+	flushi(ip);
+	return 0;
+}
Index: linux.trees.git/arch/sparc/include/asm/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/arch/sparc/include/asm/immediate.h	2009-09-24 09:00:57.000000000 -0400
@@ -0,0 +1,40 @@
+#ifndef _ASM_SPARC_IMMEDIATE_H
+#define _ASM_SPARC_IMMEDIATE_H
+
+#include <asm/asm.h>
+
+struct __imv {
+	unsigned long var;
+	unsigned long imv;
+	unsigned char size;
+} __attribute__ ((packed));
+
+#define imv_read(name)							\
+	({								\
+		__typeof__(name##__imv) value;				\
+		BUILD_BUG_ON(sizeof(value) > 8);			\
+		switch (sizeof(value)) {				\
+		case 1:							\
+			asm(".section __imv,\"aw\",@progbits\n\t"	\
+					_ASM_UAPTR " %c1, 1f\n\t"	\
+					".byte 1\n\t"			\
+					".previous\n\t"			\
+					"1: mov 0, %0\n\t"		\
+				: "=r" (value)				\
+				: "i" (&name##__imv));			\
+			break;						\
+		case 2:							\
+		case 4:							\
+		case 8:							\
+			value = name##__imv;				\
+			break;						\
+		};							\
+		value;							\
+	})
+
+#define imv_cond(name)	imv_read(name)
+#define imv_cond_end()
+
+extern int arch_imv_update(const struct __imv *imv, int early);
+
+#endif /* _ASM_SPARC_IMMEDIATE_H */
Index: linux.trees.git/arch/sparc/Makefile
===================================================================
--- linux.trees.git.orig/arch/sparc/Makefile	2009-09-24 08:52:41.000000000 -0400
+++ linux.trees.git/arch/sparc/Makefile	2009-09-24 09:00:57.000000000 -0400
@@ -57,6 +57,10 @@ KBUILD_CFLAGS += -m64 -pipe -mno-fpu -mc
 KBUILD_CFLAGS += $(call cc-option,-mtune=ultrasparc3)
 KBUILD_AFLAGS += -m64 -mcpu=ultrasparc -Wa,--undeclared-regs
 
+# gcc 3.x has problems with passing symbol+offset in
+# asm "i" constraint.
+export USE_IMMEDIATE := $(call cc-ifversion, -ge, 0400, $(CONFIG_IMMEDIATE))
+
 ifeq ($(CONFIG_MCOUNT),y)
   KBUILD_CFLAGS += -pg
 endif

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

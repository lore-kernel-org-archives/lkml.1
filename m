Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbXGKHcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbXGKHcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbXGKHbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:31:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:57862 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbXGKHbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:31:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,525,1175497200"; 
   d="scan'208";a="248994246"
Subject: [PATCH 2/2] Kexec jump: Kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Jul 2007 15:30:36 +0000
Message-Id: <1184167836.12556.15.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 11 Jul 2007 07:31:25.0554 (UTC) FILETIME=[7CD5CD20:01C7C38D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provide the kexec based implementation of hibernation image
operation. Now, only jumping between original kernel and kexeced
kernel is supported, real image write/read/check will be provided in
next patches.

Signed-off-by: Huang Ying <ying.huang@intel.com>

 arch/i386/kernel/Makefile        |    1 
 arch/i386/kernel/kexec_jump.S    |   73 ++++++++++++++++++++++++++
 arch/i386/kernel/machine_kexec.c |   58 +++++++++++++++++++++
 include/asm-i386/kexec.h         |    4 +
 include/linux/kexec.h            |    8 ++
 kernel/kexec.c                   |   25 +++++++++
 kernel/ksysfs.c                  |   12 ++++
 kernel/power/Kconfig             |    8 ++
 kernel/power/Makefile            |    1 
 kernel/power/kexec.c             |  106 +++++++++++++++++++++++++++++++++++++++
 10 files changed, 296 insertions(+)

Index: linux-2.6/arch/i386/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/i386/kernel/Makefile	2007-07-09 21:51:45.000000000 +0000
+++ linux-2.6/arch/i386/kernel/Makefile	2007-07-09 21:53:46.000000000 +0000
@@ -27,6 +27,7 @@
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
+obj-$(CONFIG_KEXEC_HIBERNATION)	+= kexec_jump.o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
Index: linux-2.6/arch/i386/kernel/machine_kexec.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/machine_kexec.c	2007-07-09 21:51:45.000000000 +0000
+++ linux-2.6/arch/i386/kernel/machine_kexec.c	2007-07-10 09:17:23.000000000 +0000
@@ -10,6 +10,7 @@
 #include <linux/kexec.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/highmem.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
@@ -169,3 +170,60 @@
 	return 0;
 }
 early_param("crashkernel", parse_crashkernel);
+
+#ifdef CONFIG_KEXEC_HIBERNATION
+int kexec_jump(int jump_type)
+{
+	asmlinkage int (*real_jump)(int jmp, void *buf);
+	unsigned long jump_buf_pfn;
+	void *jump_buf;
+
+	if (jump_type == KEXEC_JUMP_TYPE_EXEC && !kexec_crash_image)
+		return -EINVAL;
+	jump_buf_pfn = kexec_get_jump_buf_pfn(0);
+	if (!jump_buf_pfn)
+		return -EINVAL;
+	jump_buf = kmap_atomic_pfn(jump_buf_pfn, KM_PTE0);
+	memcpy(jump_buf + PAGE_SIZE/2, kexec_real_jump, PAGE_SIZE/2);
+	real_jump = jump_buf + PAGE_SIZE/2;
+
+	if (!real_jump(jump_type == KEXEC_JUMP_TYPE_EXEC, jump_buf))
+		machine_kexec(kexec_crash_image);
+	kunmap_atomic(jump_buf, KM_PTE0);
+	return 0;
+}
+
+static unsigned long kexec_backup_addr = ~0UL;
+
+/* kexec_backup= specifies the location of backuped 0~640k memory of
+ * crashed kernel.
+ */
+static int __init parse_kexec_backup(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	kexec_backup_addr = memparse(arg, &arg);
+	return 0;
+}
+early_param("kexec_backup", parse_kexec_backup);
+
+void kexec_restore_backup(void)
+{
+	void *vaddr;
+	void *vaddr_backup;
+	unsigned long paddr;
+
+	if (kexec_backup_addr == ~0UL)
+		return;
+
+	for (paddr = 0; paddr < 640 * 1024; paddr += PAGE_SIZE) {
+		vaddr = kmap_atomic_pfn(paddr >> PAGE_SHIFT, KM_PTE0);
+		vaddr_backup = kmap_atomic_pfn((paddr+kexec_backup_addr) >> PAGE_SHIFT,
+					       KM_PTE1);
+		memcpy(vaddr, vaddr_backup, PAGE_SIZE);
+		kunmap_atomic(vaddr, KM_PTE0);
+		kunmap_atomic(vaddr_backup, KM_PTE1);
+	}
+}
+#endif /* CONFIG_KEXEC_HIBERNATION */
Index: linux-2.6/include/asm-i386/kexec.h
===================================================================
--- linux-2.6.orig/include/asm-i386/kexec.h	2007-07-09 21:51:45.000000000 +0000
+++ linux-2.6/include/asm-i386/kexec.h	2007-07-09 21:53:46.000000000 +0000
@@ -94,6 +94,10 @@
 		unsigned long start_address,
 		unsigned int has_pae) ATTRIB_NORET;
 
+#ifdef CONFIG_KEXEC_HIBERNATION
+extern asmlinkage int kexec_real_jump(int save_only, void *buf);
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _I386_KEXEC_H */
Index: linux-2.6/include/linux/kexec.h
===================================================================
--- linux-2.6.orig/include/linux/kexec.h	2007-07-09 21:51:45.000000000 +0000
+++ linux-2.6/include/linux/kexec.h	2007-07-09 21:53:46.000000000 +0000
@@ -161,4 +161,12 @@
 static inline void crash_kexec(struct pt_regs *regs) { }
 static inline int kexec_should_crash(struct task_struct *p) { return 0; }
 #endif /* CONFIG_KEXEC */
+
+#ifdef CONFIG_KEXEC_HIBERNATION
+#define KEXEC_JUMP_TYPE_EXEC 0
+#define KEXEC_JUMP_TYPE_JUMP 1
+extern int kexec_jump(int jump_type);
+extern unsigned long kexec_get_jump_buf_pfn(int alloc);
+extern void kexec_restore_backup(void);
+#endif
 #endif /* LINUX_KEXEC_H */
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c	2007-07-09 21:51:45.000000000 +0000
+++ linux-2.6/kernel/kexec.c	2007-07-09 21:53:46.000000000 +0000
@@ -1135,3 +1135,28 @@
 	return 0;
 }
 module_init(crash_notes_memory_init)
+
+#ifdef CONFIG_KEXEC_HIBERNATION
+static unsigned long kexec_jump_buf_pfn;
+
+static int __init parse_kexec_jump_buf_pfn(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	kexec_jump_buf_pfn = memparse(arg, &arg);
+	return 0;
+}
+early_param("kexec_jump_buf_pfn", parse_kexec_jump_buf_pfn);
+
+unsigned long kexec_get_jump_buf_pfn(int alloc)
+{
+	struct page *jump_buf_page;
+
+	if (!kexec_jump_buf_pfn && alloc) {
+		jump_buf_page = alloc_page(GFP_KERNEL);
+		kexec_jump_buf_pfn = page_to_pfn(jump_buf_page);
+	}
+	return kexec_jump_buf_pfn;
+}
+#endif /* CONFIG_KEXEC_HIBERNATION */
Index: linux-2.6/kernel/ksysfs.c
===================================================================
--- linux-2.6.orig/kernel/ksysfs.c	2007-07-09 21:51:45.000000000 +0000
+++ linux-2.6/kernel/ksysfs.c	2007-07-09 21:53:46.000000000 +0000
@@ -60,6 +60,15 @@
 	return sprintf(page, "%d\n", !!kexec_crash_image);
 }
 KERNEL_ATTR_RO(kexec_crash_loaded);
+
+#ifdef CONFIG_KEXEC_HIBERNATION
+static ssize_t kexec_jump_buf_pfn_show(struct kset *kset, char *page)
+{
+	return sprintf(page, "0x%lx\n", kexec_get_jump_buf_pfn(1));
+}
+
+KERNEL_ATTR_RO(kexec_jump_buf_pfn);
+#endif
 #endif /* CONFIG_KEXEC */
 
 decl_subsys(kernel, NULL, NULL);
@@ -73,6 +82,9 @@
 #ifdef CONFIG_KEXEC
 	&kexec_loaded_attr.attr,
 	&kexec_crash_loaded_attr.attr,
+#ifdef CONFIG_KEXEC_HIBERNATION
+	&kexec_jump_buf_pfn_attr.attr,
+#endif
 #endif
 	NULL
 };
Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig	2007-07-09 21:51:45.000000000 +0000
+++ linux-2.6/kernel/power/Kconfig	2007-07-09 21:53:46.000000000 +0000
@@ -115,6 +115,14 @@
 
 	  For more information take a look at <file:Documentation/power/swsusp.txt>.
 
+config KEXEC_HIBERNATION
+	bool "Kexec based software suspend (hibernation) (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	depends on SOFTWARE_SUSPEND && X86_32 && KEXEC
+	---help---
+	  Writing the hibernation image through booting another kernel with
+	  kexec.
+
 config PM_STD_PARTITION
 	string "Default resume partition"
 	depends on SOFTWARE_SUSPEND
Index: linux-2.6/kernel/power/Makefile
===================================================================
--- linux-2.6.orig/kernel/power/Makefile	2007-07-09 21:51:45.000000000 +0000
+++ linux-2.6/kernel/power/Makefile	2007-07-09 21:53:46.000000000 +0000
@@ -6,5 +6,6 @@
 obj-y				:= main.o process.o console.o
 obj-$(CONFIG_PM_LEGACY)		+= pm.o
 obj-$(CONFIG_SOFTWARE_SUSPEND)	+= swsusp.o disk.o snapshot.o swap.o user.o
+obj-$(CONFIG_KEXEC_HIBERNATION)	+= kexec.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
Index: linux-2.6/arch/i386/kernel/kexec_jump.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/i386/kernel/kexec_jump.S	2007-07-09 22:13:35.000000000 +0000
@@ -0,0 +1,73 @@
+/*
+ * kexec_jump.S - Jump between normal kernel and hibernation kernel
+ * Copyright (C) 2007 Huang Ying <ying.huang@intel.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include <linux/linkage.h>
+#include <asm/page.h>
+#include <asm/kexec.h>
+
+/*
+ * Must be relocatable PIC code callable as a C function
+ */
+#define HALF_PAGE_ALIGNED (1 << (PAGE_SHIFT-1))
+
+#define EBX	0x0
+#define ESI	0x4
+#define EDI	0x8
+#define EBP	0xc
+#define ESP	0x10
+#define CR0	0x14
+#define CR3	0x18
+#define CR4	0x1c
+#define FLAG	0x20
+#define RET	0x24
+
+	.text
+	.align HALF_PAGE_ALIGNED
+	.globl kexec_real_jump
+kexec_real_jump:
+	movl	4(%esp), %ecx
+	movl	8(%esp), %edx
+	cmpl	$1, %ecx
+	jnz	1f
+	movl	%ebx, EBX(%edx)
+	movl	%esi, ESI(%edx)
+	movl	%edi, EDI(%edx)
+	movl	%ebp, EBP(%edx)
+	movl	%esp, ESP(%edx)
+	movl	%cr0, %eax
+	movl	%eax, CR0(%edx)
+	movl	%cr3, %eax
+	movl	%eax, CR3(%edx)
+	movl	%cr4, %eax
+	movl	%eax, CR4(%edx)
+	pushf
+	popl	%eax
+	movl	%eax, FLAG(%edx)
+	movl	(%esp), %eax
+	movl	%eax, RET(%edx)
+	mov	$0, %eax
+	ret
+1:
+	movl	EBX(%edx), %ebx
+	movl	ESI(%edx), %esi
+	movl	EDI(%edx), %edi
+	movl	EBP(%edx), %ebp
+	movl	FLAG(%edx), %eax
+	pushl	%eax
+	popf
+	movl	ESP(%edx), %esp
+	movl	CR4(%edx), %eax
+	movl	%eax, %cr4
+	movl	CR3(%edx), %eax
+	movl	%eax, %cr3
+	movl	CR0(%edx), %eax
+	movl	%eax, %cr0
+	movl	RET(%edx), %eax
+	movl	%eax, (%esp)
+	mov	$1, %eax
+	ret
Index: linux-2.6/kernel/power/kexec.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/kernel/power/kexec.c	2007-07-10 09:16:47.000000000 +0000
@@ -0,0 +1,106 @@
+/*
+ * kernel/power/kexec.c - Kexec based Suspend-to-disk support.
+ *
+ * Copyright (C) 2007 Huang Ying <ying.huang@intel.com>
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+#include <linux/suspend.h>
+#include <linux/pm.h>
+#include <linux/kexec.h>
+
+#include "power.h"
+
+
+static int kexec_suspend(void)
+{
+	int error;
+
+	local_irq_disable();
+	/* At this point, device_suspend() has been called, but *not*
+	 * device_power_down(). We *must* device_power_down() now.
+	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
+	 * become desynchronized with the actual state of the hardware
+	 * at resume time, and evil weirdness ensues.
+	 */
+	error = device_power_down(PMSG_FREEZE);
+	if (error) {
+		printk(KERN_ERR "Some devices failed to power down, aborting suspend\n");
+		goto Enable_irqs;
+	}
+
+	save_processor_state();
+	error = kexec_jump(KEXEC_JUMP_TYPE_EXEC);
+	restore_processor_state();
+
+	/* NOTE:  device_power_up() is just a resume() for devices
+	 * that suspended with irqs off ... no overall powerup.
+	 */
+	device_power_up();
+ Enable_irqs:
+	in_suspend = 0;
+	local_irq_enable();
+	return error;
+}
+
+static int kexec_write(void)
+{
+	return 0;
+}
+
+static int kexec_check(void)
+{
+	return 0;
+}
+
+static int kexec_read(void)
+{
+	return 0;
+}
+
+static void kexec_close(void)
+{
+}
+
+static int kexec_resume(void)
+{
+	int error = 0;
+
+	local_irq_disable();
+	/* NOTE:  device_power_down() is just a suspend() with irqs off;
+	 * it has no special "power things down" semantics
+	 */
+	if (device_power_down(PMSG_PRETHAW))
+		printk(KERN_ERR "Some devices failed to power down, very bad\n");
+	/* We'll ignore saved state, but this gets preempt count (etc) right */
+	save_processor_state();
+	kexec_restore_backup();
+	error = kexec_jump(KEXEC_JUMP_TYPE_JUMP);
+	swsusp_free();
+	restore_processor_state();
+	touch_softlockup_watchdog();
+	device_power_up();
+	local_irq_enable();
+	return error;
+}
+
+static struct hibernation_image_ops kexec_hibernation_image_ops =
+{
+	.name = "kexec",
+	.suspend = kexec_suspend,
+	.resume = kexec_resume,
+	.write = kexec_write,
+	.check = kexec_check,
+	.read = kexec_read,
+	.close = kexec_close,
+};
+
+static int __init kexec_hibernation_init(void)
+{
+	hibernation_add_image_ops(&kexec_hibernation_image_ops);
+	return 0;
+}
+
+subsys_initcall(kexec_hibernation_init);

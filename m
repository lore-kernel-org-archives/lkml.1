Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbXGOHPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbXGOHPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 03:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbXGOHO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 03:14:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:64252 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbXGOHO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 03:14:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,539,1175497200"; 
   d="scan'208";a="250603165"
Subject: [PATH 1/1] Kexec jump - v2 - kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 15 Jul 2007 15:13:59 +0800
Message-Id: <1184483639.1898.99.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 15 Jul 2007 07:14:53.0899 (UTC) FILETIME=[D76A41B0:01C7C6AF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the functionality of jumping from kexeced kernel
to original kernel.

A new reboot command named LINUX_REBOOT_CMD_KJUMP is defined to
trigger the jumping to (executing) the new kernel or jumping back to
the original kernel.

To support jumping back from kexeced kernel, before executing the new
kernel, the devices are put into quiescent state (to be fully
implemented), and the state of devices and CPU is saved. After jumping
back from kexeced kernel, the state of devices and CPU are restored
accordingly. The devices/CPU state save/restore code of software
suspend is called to implement corresponding function.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 arch/i386/Kconfig                |    7 +++
 arch/i386/kernel/Makefile        |    1 
 arch/i386/kernel/kexec_jump.S    |   74 +++++++++++++++++++++++++++++++++++++
 arch/i386/kernel/machine_kexec.c |   59 +++++++++++++++++++++++++++++
 include/asm-i386/kexec.h         |    4 ++
 include/linux/kexec.h            |   17 ++++++++
 include/linux/reboot.h           |    1 
 kernel/kexec.c                   |   78 +++++++++++++++++++++++++++++++++++++++
 kernel/ksysfs.c                  |   12 ++++++
 kernel/sys.c                     |    8 ++++
 10 files changed, 261 insertions(+)

Index: linux-2.6/arch/i386/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/i386/kernel/Makefile	2007-07-14 14:52:45.000000000 +0800
+++ linux-2.6/arch/i386/kernel/Makefile	2007-07-14 17:50:50.000000000 +0800
@@ -27,6 +27,7 @@
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
+obj-$(CONFIG_KEXEC_JUMP)	+= kexec_jump.o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
Index: linux-2.6/arch/i386/kernel/machine_kexec.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/machine_kexec.c	2007-07-14 14:52:45.000000000 +0800
+++ linux-2.6/arch/i386/kernel/machine_kexec.c	2007-07-15 11:22:23.000000000 +0800
@@ -10,6 +10,7 @@
 #include <linux/kexec.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/highmem.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
@@ -169,3 +170,61 @@
 	return 0;
 }
 early_param("crashkernel", parse_crashkernel);
+
+#ifdef CONFIG_KEXEC_JUMP
+int machine_kexec_jump(void)
+{
+	asmlinkage int (*real_jump)(void *buf);
+	unsigned long jump_buf_pfn;
+	void *jump_buf;
+
+	if (!(kexec_flags & KEXEC_FLAGS_IS_KEXECED_KERNEL) &&
+	    !kexec_crash_image)
+		return -EINVAL;
+	jump_buf_pfn = kexec_get_jump_buf_pfn(0);
+	if (!jump_buf_pfn)
+		return -EINVAL;
+	jump_buf = kmap_atomic_pfn(jump_buf_pfn, KM_PTE0);
+	memcpy(jump_buf + PAGE_SIZE/2, machine_kexec_real_jump, PAGE_SIZE/2);
+	real_jump = jump_buf + PAGE_SIZE/2;
+
+	if (!real_jump(jump_buf))
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
+#endif /* CONFIG_KEXEC_JUMP */
Index: linux-2.6/include/asm-i386/kexec.h
===================================================================
--- linux-2.6.orig/include/asm-i386/kexec.h	2007-07-14 14:52:45.000000000 +0800
+++ linux-2.6/include/asm-i386/kexec.h	2007-07-14 21:21:16.000000000 +0800
@@ -94,6 +94,10 @@
 		unsigned long start_address,
 		unsigned int has_pae) ATTRIB_NORET;
 
+#ifdef CONFIG_KEXEC_JUMP
+extern asmlinkage int machine_kexec_real_jump(void *buf);
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _I386_KEXEC_H */
Index: linux-2.6/include/linux/kexec.h
===================================================================
--- linux-2.6.orig/include/linux/kexec.h	2007-07-14 14:52:45.000000000 +0800
+++ linux-2.6/include/linux/kexec.h	2007-07-15 11:22:57.000000000 +0800
@@ -1,6 +1,11 @@
 #ifndef LINUX_KEXEC_H
 #define LINUX_KEXEC_H
 
+#ifdef CONFIG_KEXEC_JUMP
+#define KEXEC_FLAGS_IS_KEXECED_KERNEL     0x1
+#endif /* CONFIG_KEXEC_JUMP */
+
+#ifndef __ASSEMBLY__
 #ifdef CONFIG_KEXEC
 #include <linux/types.h>
 #include <linux/list.h>
@@ -161,4 +166,16 @@
 static inline void crash_kexec(struct pt_regs *regs) { }
 static inline int kexec_should_crash(struct task_struct *p) { return 0; }
 #endif /* CONFIG_KEXEC */
+
+#ifdef CONFIG_KEXEC_JUMP
+extern int kexec_flags;
+extern int machine_kexec_jump(void);
+extern int kexec_jump(void);
+extern unsigned long kexec_get_jump_buf_pfn(int alloc);
+extern void kexec_restore_backup(void);
+#else
+static inline int kexec_jump(void) { return 0; }
+#endif /* CONFIG_KEXEC_JUMP */
+#endif /* !__ASSEMBLY__ */
+
 #endif /* LINUX_KEXEC_H */
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c	2007-07-14 14:52:45.000000000 +0800
+++ linux-2.6/kernel/kexec.c	2007-07-15 12:57:25.000000000 +0800
@@ -22,6 +22,9 @@
 #include <linux/hardirq.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
+#include <linux/suspend.h>
+#include <linux/pm.h>
+#include <linux/cpu.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1135,3 +1138,78 @@
 	return 0;
 }
 module_init(crash_notes_memory_init)
+
+#ifdef CONFIG_KEXEC_JUMP
+int kexec_flags;
+
+static unsigned long kexec_jump_buf_pfn;
+
+static int __init parse_kexec_jump_buf_pfn(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	kexec_jump_buf_pfn = memparse(arg, &arg);
+	kexec_flags |= KEXEC_FLAGS_IS_KEXECED_KERNEL;
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
+
+int kexec_jump(void)
+{
+	int error;
+
+	if (!(kexec_flags & KEXEC_FLAGS_IS_KEXECED_KERNEL) &&
+	    !kexec_crash_image)
+		return -EINVAL;
+	error = device_suspend(PMSG_FREEZE);
+	if (error)
+		goto Resume_devices;
+	error = disable_nonboot_cpus();
+	if (error)
+		goto Enable_cpus;
+	local_irq_disable();
+	/* At this point, device_suspend() has been called, but *not*
+	 * device_power_down(). We *must* device_power_down() now.
+	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
+	 * become desynchronized with the actual state of the hardware
+	 * at resume time, and evil weirdness ensues.
+	 */
+	error = device_power_down(PMSG_FREEZE);
+	if (error)
+		goto Enable_irqs;
+
+	if (kexec_flags & KEXEC_FLAGS_IS_KEXECED_KERNEL)
+		kexec_restore_backup();
+	save_processor_state();
+	error = machine_kexec_jump();
+	restore_processor_state();
+
+	/* NOTE:  device_power_up() is just a resume() for devices
+	 * that suspended with irqs off ... no overall powerup.
+	 */
+	device_power_up();
+ Enable_irqs:
+	local_irq_enable();
+ Enable_cpus:
+	enable_nonboot_cpus();
+ Resume_devices:
+	device_resume();
+	if (!error) {
+		kimage_free(kexec_crash_image);
+		kexec_crash_image = NULL;
+	}
+	return error;
+}
+#endif /* CONFIG_KEXEC_JUMP */
Index: linux-2.6/kernel/ksysfs.c
===================================================================
--- linux-2.6.orig/kernel/ksysfs.c	2007-07-14 14:52:45.000000000 +0800
+++ linux-2.6/kernel/ksysfs.c	2007-07-14 17:55:46.000000000 +0800
@@ -60,6 +60,15 @@
 	return sprintf(page, "%d\n", !!kexec_crash_image);
 }
 KERNEL_ATTR_RO(kexec_crash_loaded);
+
+#ifdef CONFIG_KEXEC_JUMP
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
+#ifdef CONFIG_KEXEC_JUMP
+	&kexec_jump_buf_pfn_attr.attr,
+#endif
 #endif
 	NULL
 };
Index: linux-2.6/arch/i386/kernel/kexec_jump.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/i386/kernel/kexec_jump.S	2007-07-15 11:26:51.000000000 +0800
@@ -0,0 +1,74 @@
+/*
+ * kexec_jump.S - Jump between normal kernel and kexeced kernel
+ * Copyright (C) 2007 Huang Ying <ying.huang@intel.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include <linux/linkage.h>
+#include <linux/kexec.h>
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
+	.globl machine_kexec_real_jump
+machine_kexec_real_jump:
+	movl	4(%esp), %edx
+	movl	kexec_flags, %ecx
+	andl	$KEXEC_FLAGS_IS_KEXECED_KERNEL, %ecx
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
Index: linux-2.6/kernel/sys.c
===================================================================
--- linux-2.6.orig/kernel/sys.c	2007-07-14 16:45:21.000000000 +0800
+++ linux-2.6/kernel/sys.c	2007-07-14 17:39:47.000000000 +0800
@@ -940,6 +940,14 @@
 		unlock_kernel();
 		return -EINVAL;
 
+	case LINUX_REBOOT_CMD_KJUMP:
+		{
+			int ret;
+			ret = kexec_jump();
+			unlock_kernel();
+			return ret;
+		}
+
 #ifdef CONFIG_SOFTWARE_SUSPEND
 	case LINUX_REBOOT_CMD_SW_SUSPEND:
 		{
Index: linux-2.6/include/linux/reboot.h
===================================================================
--- linux-2.6.orig/include/linux/reboot.h	2007-07-14 17:29:58.000000000 +0800
+++ linux-2.6/include/linux/reboot.h	2007-07-14 20:43:04.000000000 +0800
@@ -33,6 +33,7 @@
 #define	LINUX_REBOOT_CMD_RESTART2	0xA1B2C3D4
 #define	LINUX_REBOOT_CMD_SW_SUSPEND	0xD000FCE2
 #define	LINUX_REBOOT_CMD_KEXEC		0x45584543
+#define	LINUX_REBOOT_CMD_KJUMP		0x3928A5FD
 
 
 #ifdef __KERNEL__
Index: linux-2.6/arch/i386/Kconfig
===================================================================
--- linux-2.6.orig/arch/i386/Kconfig	2007-07-14 17:52:02.000000000 +0800
+++ linux-2.6/arch/i386/Kconfig	2007-07-14 19:08:37.000000000 +0800
@@ -813,6 +813,13 @@
           PHYSICAL_START.
 	  For more details see Documentation/kdump/kdump.txt
 
+config KEXEC_JUMP
+	bool "kexec jump (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	depends on PM && X86_32 && KEXEC
+	---help---
+	  Jump back from kexeced kernel to orignal kernel.
+
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
 	default "0x100000"

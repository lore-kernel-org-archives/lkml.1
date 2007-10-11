Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbXJKCNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbXJKCNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 22:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbXJKCM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 22:12:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:52019 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbXJKCMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 22:12:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,256,1188802800"; 
   d="scan'208";a="169309934"
Subject: [PATCH 1/2 -mm] kexec based hibernation -v5: kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 11 Oct 2007 10:14:01 +0800
Message-Id: <1192068841.27482.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 11 Oct 2007 02:11:50.0823 (UTC) FILETIME=[15CF0B70:01C80BAC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the functionality of jumping between the kexeced
kernel and the original kernel.

A new flag for sys_kexec_load named KEXEC_JUMP_BACK is added to
indicate that the loaded kernel image is used for jumping back.

To support jumping between two kernels, before jumping to (executing)
the new kernel and jumping back to the original kernel, the devices
are put into quiescent state, and the state of devices and CPU is
saved. After jumping back from kexeced kernel and jumping to the new
kernel, the state of devices and CPU are restored accordingly. The
devices/CPU state save/restore code of software suspend is called to
implement corresponding function.

To support jumping without reserving memory. One shadow backup page
(source page) is allocated for each page used by new (kexeced) kernel
(destination page). When do kexec_load, the image of new kernel is
loaded into source pages, and before executing, the destination pages
and the source pages are swapped, so the contents of destination pages
are backupped. Before jumping to the new (kexeced) kernel and after
jumping back to the original kernel, the destination pages and the
source pages are swapped too.

A jump back protocol is defined and documented.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---

Index: linux-2.6.23-rc8/arch/i386/kernel/machine_kexec.c
===================================================================
--- linux-2.6.23-rc8.orig/arch/i386/kernel/machine_kexec.c	2007-10-10 10:10:22.000000000 +0800
+++ linux-2.6.23-rc8/arch/i386/kernel/machine_kexec.c	2007-10-10 10:10:27.000000000 +0800
@@ -20,6 +20,7 @@
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
 #include <asm/system.h>
+#include <asm/cacheflush.h>
 
 #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
 static u32 kexec_pgd[1024] PAGE_ALIGNED;
@@ -83,10 +84,14 @@
  * reboot code buffer to allow us to avoid allocations
  * later.
  *
- * Currently nothing.
+ * Turn off NX bit for control page.
  */
 int machine_kexec_prepare(struct kimage *image)
 {
+	if (nx_enabled) {
+		change_page_attr(image->control_code_page, 1, PAGE_KERNEL_EXEC);
+		global_flush_tlb();
+	}
 	return 0;
 }
 
@@ -96,25 +101,50 @@
  */
 void machine_kexec_cleanup(struct kimage *image)
 {
+	if (nx_enabled) {
+		change_page_attr(image->control_code_page, 1, PAGE_KERNEL);
+		global_flush_tlb();
+	}
 }
 
 /*
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
+	asmlinkage NORET_TYPE void
+		(*relocate_kernel_ptr)(unsigned long indirection_page,
+				       unsigned long control_page,
+				       unsigned long start_address,
+				       unsigned int has_pae) ATTRIB_NORET;
 
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
 
 	control_page = page_address(image->control_code_page);
-	memcpy(control_page, relocate_kernel, PAGE_SIZE);
+	memcpy(control_page, relocate_page, PAGE_SIZE/2);
 
+	if (image->jump_back) {
+		unsigned long pa_control_page;
+		pa_control_page = __pa(control_page);
+		memcpy(control_page + 1, &pa_control_page,
+		       sizeof(pa_control_page));
+		KJUMP_MAGIC(control_page) = KJUMP_MAGIC_NUMBER;
+		KJUMP_VERSION(control_page) = KJUMP_VERSION_NUMBER;
+
+		if (kexec_jump_save_cpu(control_page)) {
+			image->start = KJUMP_ENTRY(control_page);
+			return;
+		}
+	}
+
+	relocate_kernel_ptr = control_page +
+		((void *)relocate_kernel - (void *)relocate_page);
 	page_list[PA_CONTROL_PAGE] = __pa(control_page);
-	page_list[VA_CONTROL_PAGE] = (unsigned long)relocate_kernel;
+	page_list[VA_CONTROL_PAGE] = (unsigned long)control_page;
 	page_list[PA_PGD] = __pa(kexec_pgd);
 	page_list[VA_PGD] = (unsigned long)kexec_pgd;
 #ifdef CONFIG_X86_PAE
@@ -127,6 +157,7 @@
 	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
 	page_list[PA_PTE_1] = __pa(kexec_pte1);
 	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
+	page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page) << PAGE_SHIFT);
 
 	/* The segment registers are funny things, they have both a
 	 * visible and an invisible part.  Whenever the visible part is
@@ -145,8 +176,9 @@
 	set_idt(phys_to_virt(0),0);
 
 	/* now call it */
-	relocate_kernel((unsigned long)image->head, (unsigned long)page_list,
-			image->start, cpu_has_pae);
+	relocate_kernel_ptr((unsigned long)image->head,
+			    (unsigned long)page_list,
+			    image->start, cpu_has_pae);
 }
 
 void arch_crash_save_vmcoreinfo(void)
Index: linux-2.6.23-rc8/include/asm-i386/kexec.h
===================================================================
--- linux-2.6.23-rc8.orig/include/asm-i386/kexec.h	2007-10-10 10:10:22.000000000 +0800
+++ linux-2.6.23-rc8/include/asm-i386/kexec.h	2007-10-10 10:10:27.000000000 +0800
@@ -9,16 +9,42 @@
 #define VA_PTE_0         5
 #define PA_PTE_1         6
 #define VA_PTE_1         7
+#define PA_SWAP_PAGE     8
 #ifdef CONFIG_X86_PAE
-#define PA_PMD_0         8
-#define VA_PMD_0         9
-#define PA_PMD_1         10
-#define VA_PMD_1         11
-#define PAGES_NR         12
+#define PA_PMD_0         9
+#define VA_PMD_0         10
+#define PA_PMD_1         11
+#define VA_PMD_1         12
+#define PAGES_NR         13
 #else
-#define PAGES_NR         8
+#define PAGES_NR         9
 #endif
 
+#define KJUMP_DATA_BASE		0x800
+
+#define KJUMP_MAGIC_NUMBER	0x626a
+#define KJUMP_VERSION_NUMBER	0x0100
+
+#define KJUMP_DATA(buf)		((unsigned char *)(buf)+KJUMP_DATA_BASE)
+#define KJUMP_OFF(off)		(KJUMP_DATA_BASE+(off))
+
+#define KJUMP_MAGIC_OFF		KJUMP_OFF(0x0)
+#define KJUMP_MAGIC(buf)	(*(unsigned short *)(KJUMP_DATA(buf)+0x0))
+#define KJUMP_VERSION(buf)	(*(unsigned short *)(KJUMP_DATA(buf)+0x2))
+#define KJUMP_BACKUP_PAGES_MAP_OFF \
+				KJUMP_OFF(0x4)
+#define KJUMP_BACKUP_PAGES_MAP(buf) \
+				(*(unsigned long *)(KJUMP_DATA(buf)+0x4))
+
+/*
+ * The following are not a part of jump back protocol, for internal
+ * use only
+ */
+#define KJUMP_ENTRY_OFF		KJUMP_OFF(0x20)
+#define KJUMP_ENTRY(buf)	(*(unsigned long *)(KJUMP_DATA(buf)+0x20))
+/* Other internal data fields base */
+#define KJUMP_OTHER_OFF		KJUMP_OFF(0x24)
+
 #ifndef __ASSEMBLY__
 
 #include <asm/ptrace.h>
@@ -94,6 +120,9 @@
 		unsigned long start_address,
 		unsigned int has_pae) ATTRIB_NORET;
 
+extern char relocate_page[PAGE_SIZE];
+
+extern asmlinkage int kexec_jump_save_cpu(void *buf);
 #endif /* __ASSEMBLY__ */
 
 #endif /* _I386_KEXEC_H */
Index: linux-2.6.23-rc8/include/linux/kexec.h
===================================================================
--- linux-2.6.23-rc8.orig/include/linux/kexec.h	2007-10-10 10:10:22.000000000 +0800
+++ linux-2.6.23-rc8/include/linux/kexec.h	2007-10-10 10:32:57.000000000 +0800
@@ -83,6 +83,7 @@
 
 	unsigned long start;
 	struct page *control_code_page;
+	struct page *swap_page;
 
 	unsigned long nr_segments;
 	struct kexec_segment segment[KEXEC_SEGMENT_MAX];
@@ -98,18 +99,21 @@
 	unsigned int type : 1;
 #define KEXEC_TYPE_DEFAULT 0
 #define KEXEC_TYPE_CRASH   1
+	unsigned int jump_back : 1;
 };
 
 
 
 /* kexec interface functions */
-extern NORET_TYPE void machine_kexec(struct kimage *image) ATTRIB_NORET;
+extern void machine_kexec(struct kimage *image);
 extern int machine_kexec_prepare(struct kimage *image);
 extern void machine_kexec_cleanup(struct kimage *image);
 extern asmlinkage long sys_kexec_load(unsigned long entry,
 					unsigned long nr_segments,
 					struct kexec_segment __user *segments,
 					unsigned long flags);
+extern void kimage_free(struct kimage *image);
+extern int kexec_jump(struct kimage *image);
 #ifdef CONFIG_COMPAT
 extern asmlinkage long compat_sys_kexec_load(unsigned long entry,
 				unsigned long nr_segments,
@@ -153,6 +157,7 @@
 #endif
 
 #define KEXEC_ON_CRASH  0x00000001
+#define KEXEC_JUMP_BACK 0x00000002
 #define KEXEC_ARCH_MASK 0xffff0000
 
 /* These values match the ELF architecture values.
@@ -170,7 +175,8 @@
 #define KEXEC_ARCH_MIPS_LE (10 << 16)
 #define KEXEC_ARCH_MIPS    ( 8 << 16)
 
-#define KEXEC_FLAGS    (KEXEC_ON_CRASH)  /* List of defined/legal kexec flags */
+/* List of defined/legal kexec flags */
+#define KEXEC_FLAGS    (KEXEC_ON_CRASH|KEXEC_JUMP_BACK)
 
 #define VMCOREINFO_BYTES           (4096)
 #define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
Index: linux-2.6.23-rc8/kernel/kexec.c
===================================================================
--- linux-2.6.23-rc8.orig/kernel/kexec.c	2007-10-10 10:10:22.000000000 +0800
+++ linux-2.6.23-rc8/kernel/kexec.c	2007-10-10 10:33:52.000000000 +0800
@@ -24,6 +24,10 @@
 #include <linux/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/numa.h>
+#include <linux/suspend.h>
+#include <linux/pm.h>
+#include <linux/cpu.h>
+#include <linux/console.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -243,6 +247,12 @@
 		goto out;
 	}
 
+	image->swap_page = kimage_alloc_control_pages(image, 0);
+	if (!image->swap_page) {
+		printk(KERN_ERR "Could not allocate swap buffer\n");
+		goto out;
+	}
+
 	result = 0;
  out:
 	if (result == 0)
@@ -613,7 +623,7 @@
 	kimage_free_pages(page);
 }
 
-static void kimage_free(struct kimage *image)
+void kimage_free(struct kimage *image)
 {
 	kimage_entry_t *ptr, entry;
 	kimage_entry_t ind = 0;
@@ -989,6 +999,8 @@
 		if (result)
 			goto out;
 
+		if (flags & KEXEC_JUMP_BACK)
+			image->jump_back = 1;
 		result = machine_kexec_prepare(image);
 		if (result)
 			goto out;
@@ -1412,3 +1424,45 @@
 }
 
 module_init(crash_save_vmcoreinfo_init)
+
+int kexec_jump(struct kimage *image)
+{
+	int error;
+
+	pm_prepare_console();
+	suspend_console();
+	error = device_suspend(PMSG_FREEZE);
+	if (error)
+		goto Resume_console;
+	error = disable_nonboot_cpus();
+	if (error)
+		goto Resume_devices;
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
+	save_processor_state();
+	machine_kexec(image);
+	restore_processor_state();
+
+	/* NOTE:  device_power_up() is just a resume() for devices
+	 * that suspended with irqs off ... no overall powerup.
+	 */
+	device_power_up();
+ Enable_irqs:
+	local_irq_enable();
+	enable_nonboot_cpus();
+ Resume_devices:
+	device_resume();
+ Resume_console:
+	resume_console();
+	pm_restore_console();
+	return error;
+}
Index: linux-2.6.23-rc8/kernel/sys.c
===================================================================
--- linux-2.6.23-rc8.orig/kernel/sys.c	2007-10-10 10:10:22.000000000 +0800
+++ linux-2.6.23-rc8/kernel/sys.c	2007-10-10 10:35:42.000000000 +0800
@@ -300,17 +300,25 @@
  *	Move into place and start executing a preloaded standalone
  *	executable.  If nothing was preloaded return an error.
  */
-static void kernel_kexec(void)
+static int kernel_kexec(void)
 {
 #ifdef CONFIG_KEXEC
 	struct kimage *image;
+	int ret;
 	image = xchg(&kexec_image, NULL);
 	if (!image)
-		return;
+		return -EINVAL;
+	if (image->jump_back) {
+		ret = kexec_jump(image);
+		image = xchg(&kexec_image, image);
+		kimage_free(image);
+		return ret;
+	}
 	kernel_restart_prepare(NULL);
 	printk(KERN_EMERG "Starting new kernel\n");
 	machine_shutdown();
 	machine_kexec(image);
+	return -EINVAL;
 #endif
 }
 
@@ -418,9 +426,12 @@
 		break;
 
 	case LINUX_REBOOT_CMD_KEXEC:
-		kernel_kexec();
-		unlock_kernel();
-		return -EINVAL;
+		{
+			int ret;
+			ret = kernel_kexec();
+			unlock_kernel();
+			return ret;
+		}
 
 #ifdef CONFIG_HIBERNATION
 	case LINUX_REBOOT_CMD_SW_SUSPEND:
Index: linux-2.6.23-rc8/kernel/power/Kconfig
===================================================================
--- linux-2.6.23-rc8.orig/kernel/power/Kconfig	2007-10-10 10:10:22.000000000 +0800
+++ linux-2.6.23-rc8/kernel/power/Kconfig	2007-10-10 10:10:27.000000000 +0800
@@ -70,7 +70,7 @@
 
 config PM_SLEEP
 	bool
-	depends on SUSPEND || HIBERNATION
+	depends on SUSPEND || HIBERNATION || KEXEC
 	default y
 
 config SUSPEND_UP_POSSIBLE
Index: linux-2.6.23-rc8/arch/i386/kernel/relocate_kernel.S
===================================================================
--- linux-2.6.23-rc8.orig/arch/i386/kernel/relocate_kernel.S	2007-10-10 10:10:22.000000000 +0800
+++ linux-2.6.23-rc8/arch/i386/kernel/relocate_kernel.S	2007-10-10 10:10:27.000000000 +0800
@@ -19,8 +19,87 @@
 #define PAGE_ATTR 0x63 /* _PAGE_PRESENT|_PAGE_RW|_PAGE_ACCESSED|_PAGE_DIRTY */
 #define PAE_PGD_ATTR 0x01 /* _PAGE_PRESENT */
 
+#define STACK_TOP		0x1000
+
+#define DATA(offset)		(KJUMP_OTHER_OFF+(offset))
+
+/* Minimal CPU stat */
+#define EBX			DATA(0x0)
+#define ESI			DATA(0x4)
+#define EDI			DATA(0x8)
+#define EBP			DATA(0xc)
+#define ESP			DATA(0x10)
+#define CR0			DATA(0x14)
+#define CR3			DATA(0x18)
+#define CR4			DATA(0x1c)
+#define FLAG			DATA(0x20)
+#define RET			DATA(0x24)
+
+/* some information saved in control page (CP) for jumping back */
+#define CP_VA_CONTROL_PAGE	DATA(0x30)
+#define CP_PA_PGD		DATA(0x34)
+#define CP_PA_SWAP_PAGE		DATA(0x38)
+
 	.text
 	.align PAGE_ALIGNED
+	.globl relocate_page
+relocate_page:
+
+/*
+ * Entry point for jumping back from kexeced kernel, the paging is
+ * turned off, the information needed is at relocate_page +
+ * PAGE_SIZE/2
+ */
+kexec_jump_back_entry:
+	movl	$relocate_page, %ebx
+	movl	%edi, KJUMP_ENTRY_OFF(%ebx)
+	movl	CP_VA_CONTROL_PAGE(%ebx), %edi
+
+	lea	STACK_TOP(%ebx), %esp
+
+	movl	CP_PA_SWAP_PAGE(%ebx), %eax
+	movl	KJUMP_BACKUP_PAGES_MAP_OFF(%ebx), %edx
+	pushl	%eax
+	pushl	%edx
+	call	swap_pages
+	addl	$8, %esp
+
+	movl	CP_PA_PGD(%ebx), %eax
+	movl	%eax, %cr3
+
+	movl	%cr0, %eax
+	orl	$(1<<31), %eax
+	movl	%eax, %cr0
+
+	movl	%edi, %esp
+	addl	$STACK_TOP, %esp
+
+	movl	%edi, %eax
+	addl	$(virtual_mapped - relocate_page), %eax
+	pushl	%eax
+	ret
+
+virtual_mapped:
+	movl	%edi, %edx
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
+
 	.globl relocate_kernel
 relocate_kernel:
 	movl	8(%esp), %ebp /* list of pages */
@@ -146,6 +225,15 @@
 	pushl $0
 	popfl
 
+	/* save some information for jumping back */
+	movl	PTR(VA_CONTROL_PAGE)(%ebp), %edi
+	movl	%edi, CP_VA_CONTROL_PAGE(%edi)
+	movl	PTR(PA_PGD)(%ebp), %eax
+	movl	%eax, CP_PA_PGD(%edi)
+	movl	PTR(PA_SWAP_PAGE)(%ebp), %eax
+	movl	%eax, CP_PA_SWAP_PAGE(%edi)
+	movl	%ebx, KJUMP_BACKUP_PAGES_MAP_OFF(%edi)
+
 	/* get physical address of control page now */
 	/* this is impossible after page table switch */
 	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edi
@@ -155,11 +243,11 @@
 	movl	%eax, %cr3
 
 	/* setup a new stack at the end of the physical control page */
-	lea	4096(%edi), %esp
+	lea	STACK_TOP(%edi), %esp
 
 	/* jump to identity mapped page */
 	movl    %edi, %eax
-	addl    $(identity_mapped - relocate_kernel), %eax
+	addl    $(identity_mapped - relocate_page), %eax
 	pushl   %eax
 	ret
 
@@ -197,8 +285,44 @@
 	xorl	%eax, %eax
 	movl	%eax, %cr3
 
+	movl	CP_PA_SWAP_PAGE(%edi), %eax
+	pushl	%eax
+	pushl	%ebx
+	call	swap_pages
+	addl	$8, %esp
+
+	/* To be certain of avoiding problems with self-modifying code
+	 * I need to execute a serializing instruction here.
+	 * So I flush the TLB, it's handy, and not processor dependent.
+	 */
+	xorl	%eax, %eax
+	movl	%eax, %cr3
+
+	/* set all of the registers to known values */
+	/* leave %esp alone */
+
+	movw	KJUMP_MAGIC_OFF(%edi), %ax
+	cmpw	$KJUMP_MAGIC_NUMBER, %ax
+	jz 1f
+	xorl	%edi, %edi
+1:
+	xorl	%eax, %eax
+	xorl	%ebx, %ebx
+	xorl    %ecx, %ecx
+	xorl    %edx, %edx
+	xorl    %esi, %esi
+	xorl    %ebp, %ebp
+	ret
+
 	/* Do the copies */
-	movl	%ebx, %ecx
+swap_pages:
+	movl	8(%esp), %edx
+	movl	4(%esp), %ecx
+	pushl	%ebp
+	pushl	%ebx
+	pushl	%edi
+	pushl	%esi
+	movl	%ecx, %ebx
 	jmp	1f
 
 0:	/* top, read another word from the indirection page */
@@ -226,27 +350,50 @@
 	movl    %ecx,   %esi /* For every source page do a copy */
 	andl    $0xfffff000, %esi
 
+	movl	%edi, %eax
+	movl	%esi, %ebp
+
+	movl	%edx, %edi
 	movl    $1024, %ecx
 	rep ; movsl
-	jmp     0b
 
-3:
+	movl	%ebp, %edi
+	movl	%eax, %esi
+	movl	$1024, %ecx
+	rep ; movsl
 
-	/* To be certain of avoiding problems with self-modifying code
-	 * I need to execute a serializing instruction here.
-	 * So I flush the TLB, it's handy, and not processor dependent.
-	 */
-	xorl	%eax, %eax
-	movl	%eax, %cr3
+	movl	%eax, %edi
+	movl	%edx, %esi
+	movl	$1024, %ecx
+	rep ; movsl
 
-	/* set all of the registers to known values */
-	/* leave %esp alone */
+	lea	4096(%ebp), %esi
+	jmp     0b
+3:
+	popl	%esi
+	popl	%edi
+	popl	%ebx
+	popl	%ebp
+	ret
 
-	xorl	%eax, %eax
-	xorl	%ebx, %ebx
-	xorl    %ecx, %ecx
-	xorl    %edx, %edx
-	xorl    %esi, %esi
-	xorl    %edi, %edi
-	xorl    %ebp, %ebp
+	.globl kexec_jump_save_cpu
+kexec_jump_save_cpu:
+	movl	4(%esp), %edx
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
 	ret
Index: linux-2.6.23-rc8/Documentation/i386/jump_back_protocol.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23-rc8/Documentation/i386/jump_back_protocol.txt	2007-10-10 10:10:27.000000000 +0800
@@ -0,0 +1,81 @@
+		THE LINUX/I386 JUMP BACK PROTOCOL
+		---------------------------------
+
+		Huang Ying <ying.huang@intel.com>
+		    Last update 2007-09-19
+
+Currently, the following versions of the jump back protocol exist.
+
+Protocol 1.00:	Jumping between original kernel and kexeced kernel
+		support.
+
+
+**** LOAD THE JUMP BACK IMAGE
+
+Jump back image is an ordinary ELF 64 executable file, it can be
+loaded just as other ELF64 image. That is, the PT_LOAD segments should
+be loaded into their physical address.
+
+Before loading all segments of jump back image, the jump back header
+should be checked. Jump back header can be loaded from the 4K page at
+the jump back entry in jump back image.
+
+The header looks like:
+
+Offset	Proto	Name		Meaning
+/Size
+
+C00/2	1.00+	magic		Magic number: 0x626A
+C02/2	1.00+	version		Jump back protocol version
+C04/4	1.00+	backup_pages_map Map from target page to backup page
+
+Note: unlike ordinary ELF 64 file, the jump back image may occupy most
+memory pages, so it is important for loader to verify there is no
+conflict between pages of loaded image and pages used by loader
+itself.
+
+
+**** DETAILS OF JUMP BACK HEADER
+
+For each field, some are information from the jump back image to
+loader ("read"), some are expected to be filled out by the loader
+("write"), and some are expected to be read and modified by the loader
+("modify").
+
+All general purpose boot loaders should write the fields marked
+(obligatory).
+
+The byte order of all fields is little endian.
+
+Field name:	magic
+Type:		read
+Offset/size:	0xc00/2
+Protocol:	1.00+
+
+  Contains the magic number "jb" (0x626A)
+
+Field name:	version
+Type:		read
+Offset/size:	0xc02/2
+Protocol:	1.00+
+
+  Contains the version number, in (major << 8)+minor format,
+  e.g. 0x0100 for version 1.00.
+
+Field name:	backup_pages_map
+Type:		read
+Offset/size:	0xc04/4
+Protocol:	1.00+
+
+  The map from target address to backup address, it is kimage->head in
+  fact.
+  TODO: detailed description
+
+
+**** JUMP BACK TO THE JUMP BACK IMAGE
+
+To jump back to the jump back image, just jump to the jump back
+entry. At entry, the CPU must be in 32-bit protected mode with paging
+disabled; the CS, DS and SS must be 4G flat segments; if jumping back
+to loader is supported, %edi should be the jump back entry of loader,
+otherwise it should be zero.
Index: linux-2.6.23-rc8/arch/ppc/kernel/machine_kexec.c
===================================================================
--- linux-2.6.23-rc8.orig/arch/ppc/kernel/machine_kexec.c	2007-10-10 10:10:22.000000000 +0800
+++ linux-2.6.23-rc8/arch/ppc/kernel/machine_kexec.c	2007-10-10 10:10:27.000000000 +0800
@@ -66,7 +66,7 @@
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	if (ppc_md.machine_kexec)
 		ppc_md.machine_kexec(image);
Index: linux-2.6.23-rc8/arch/x86_64/kernel/machine_kexec.c
===================================================================
--- linux-2.6.23-rc8.orig/arch/x86_64/kernel/machine_kexec.c	2007-10-10 10:10:22.000000000 +0800
+++ linux-2.6.23-rc8/arch/x86_64/kernel/machine_kexec.c	2007-10-10 10:10:27.000000000 +0800
@@ -179,7 +179,7 @@
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
Index: linux-2.6.23-rc8/arch/sh/kernel/machine_kexec.c
===================================================================
--- linux-2.6.23-rc8.orig/arch/sh/kernel/machine_kexec.c	2007-10-10 10:10:22.000000000 +0800
+++ linux-2.6.23-rc8/arch/sh/kernel/machine_kexec.c	2007-10-10 10:10:27.000000000 +0800
@@ -70,7 +70,7 @@
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 
 	unsigned long page_list;
Index: linux-2.6.23-rc8/arch/powerpc/kernel/machine_kexec.c
===================================================================
--- linux-2.6.23-rc8.orig/arch/powerpc/kernel/machine_kexec.c	2007-10-10 10:10:22.000000000 +0800
+++ linux-2.6.23-rc8/arch/powerpc/kernel/machine_kexec.c	2007-10-10 10:10:27.000000000 +0800
@@ -47,7 +47,7 @@
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	if (ppc_md.machine_kexec)
 		ppc_md.machine_kexec(image);

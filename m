Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbXLUHnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbXLUHnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbXLUHnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:43:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:33968 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbXLUHnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:43:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,193,1196668800"; 
   d="scan'208";a="346767800"
Subject: [PATCH 1/3 -mm] kexec jump -v8 : kexec jump basic
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Dec 2007 15:33:36 +0800
Message-Id: <1198222416.1965.17.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 21 Dec 2007 07:38:18.0502 (UTC) FILETIME=[744DEA60:01C843A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the functionality of jumping between the kexeced
kernel and the original kernel.

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

A jump back protocol for kexec is defined and documented. It is an
extension to ordinary function calling protocol. So, the facility
provided by this patch can be used to call ordinary C function in
physical mode.

A flag named KEXEC_PRESERVE_CONTEXT for sys_kexec_load is added to
indicate that the loaded kernel image is used for jumping back.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 Documentation/i386/jump_back_protocol.txt |   66 ++++++++++
 arch/powerpc/kernel/machine_kexec.c       |    2 
 arch/ppc/kernel/machine_kexec.c           |    2 
 arch/sh/kernel/machine_kexec.c            |    2 
 arch/x86/kernel/machine_kexec_32.c        |   39 +++++-
 arch/x86/kernel/machine_kexec_64.c        |    2 
 arch/x86/kernel/relocate_kernel_32.S      |  194 ++++++++++++++++++++++++++----
 include/asm-x86/kexec_32.h                |   34 ++++-
 include/linux/kexec.h                     |   14 +-
 kernel/kexec.c                            |   65 +++++++++-
 kernel/power/Kconfig                      |    2 
 kernel/sys.c                              |   35 +++--
 12 files changed, 403 insertions(+), 54 deletions(-)

--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -20,6 +20,7 @@
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
 #include <asm/system.h>
+#include <asm/cacheflush.h>
 
 #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
 static u32 kexec_pgd[1024] PAGE_ALIGNED;
@@ -83,10 +84,14 @@ static void load_segments(void)
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
 
@@ -96,25 +101,45 @@ int machine_kexec_prepare(struct kimage 
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
+	KJUMP_MAGIC(control_page) = 0;
 
+	if (image->preserve_context) {
+		KJUMP_MAGIC(control_page) = KJUMP_MAGIC_NUMBER;
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
@@ -127,6 +152,7 @@ NORET_TYPE void machine_kexec(struct kim
 	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
 	page_list[PA_PTE_1] = __pa(kexec_pte1);
 	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
+	page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page) << PAGE_SHIFT);
 
 	/* The segment registers are funny things, they have both a
 	 * visible and an invisible part.  Whenever the visible part is
@@ -145,8 +171,9 @@ NORET_TYPE void machine_kexec(struct kim
 	set_idt(phys_to_virt(0),0);
 
 	/* now call it */
-	relocate_kernel((unsigned long)image->head, (unsigned long)page_list,
-			image->start, cpu_has_pae);
+	relocate_kernel_ptr((unsigned long)image->head,
+			    (unsigned long)page_list,
+			    image->start, cpu_has_pae);
 }
 
 void arch_crash_save_vmcoreinfo(void)
--- a/include/asm-x86/kexec_32.h
+++ b/include/asm-x86/kexec_32.h
@@ -9,16 +9,35 @@
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
+#define KJUMP_MAGIC_NUMBER	0xe1b6a57d
+
+#define KJUMP_DATA(buf)		((__u8 *)(buf)+KJUMP_DATA_BASE)
+#define KJUMP_OFF(off)		(KJUMP_DATA_BASE+(off))
+
+/*
+ * The following are not a part of jump back protocol, for internal
+ * use only
+ */
+#define KJUMP_MAGIC_OFF		KJUMP_OFF(0x0)
+#define KJUMP_MAGIC(buf)	(*(__u32 *)(KJUMP_DATA(buf)+0x0))
+#define KJUMP_ENTRY_OFF		KJUMP_OFF(0x4)
+#define KJUMP_ENTRY(buf)	(*(__u32 *)(KJUMP_DATA(buf)+0x4))
+/* Other internal data fields base */
+#define KJUMP_OTHER_OFF		KJUMP_OFF(0x8)
+
 #ifndef __ASSEMBLY__
 
 #include <asm/ptrace.h>
@@ -94,6 +113,9 @@ relocate_kernel(unsigned long indirectio
 		unsigned long start_address,
 		unsigned int has_pae) ATTRIB_NORET;
 
+extern char relocate_page[PAGE_SIZE];
+
+extern asmlinkage int kexec_jump_save_cpu(void *buf);
 #endif /* __ASSEMBLY__ */
 
 #endif /* _I386_KEXEC_H */
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -83,6 +83,7 @@ struct kimage {
 
 	unsigned long start;
 	struct page *control_code_page;
+	struct page *swap_page;
 
 	unsigned long nr_segments;
 	struct kexec_segment segment[KEXEC_SEGMENT_MAX];
@@ -98,18 +99,20 @@ struct kimage {
 	unsigned int type : 1;
 #define KEXEC_TYPE_DEFAULT 0
 #define KEXEC_TYPE_CRASH   1
+	unsigned int preserve_context : 1;
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
+extern int kexec_jump(struct kimage *image);
 #ifdef CONFIG_COMPAT
 extern asmlinkage long compat_sys_kexec_load(unsigned long entry,
 				unsigned long nr_segments,
@@ -151,13 +154,15 @@ unsigned long paddr_vmcoreinfo_note(void
 
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
+extern int kexec_lock;
 
 #ifndef kexec_flush_icache_page
 #define kexec_flush_icache_page(page)
 #endif
 
-#define KEXEC_ON_CRASH  0x00000001
-#define KEXEC_ARCH_MASK 0xffff0000
+#define KEXEC_ON_CRASH		0x00000001
+#define KEXEC_PRESERVE_CONTEXT	0x00000002
+#define KEXEC_ARCH_MASK		0xffff0000
 
 /* These values match the ELF architecture values.
  * Unless there is a good reason that should continue to be the case.
@@ -174,7 +179,8 @@ extern struct kimage *kexec_crash_image;
 #define KEXEC_ARCH_MIPS_LE (10 << 16)
 #define KEXEC_ARCH_MIPS    ( 8 << 16)
 
-#define KEXEC_FLAGS    (KEXEC_ON_CRASH)  /* List of defined/legal kexec flags */
+/* List of defined/legal kexec flags */
+#define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_PRESERVE_CONTEXT)
 
 #define VMCOREINFO_BYTES           (4096)
 #define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -24,6 +24,11 @@
 #include <linux/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/numa.h>
+#include <linux/suspend.h>
+#include <linux/freezer.h>
+#include <linux/pm.h>
+#include <linux/cpu.h>
+#include <linux/console.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -243,6 +248,12 @@ static int kimage_normal_alloc(struct ki
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
@@ -920,7 +931,7 @@ struct kimage *kexec_crash_image;
  * Nothing can wait so this mutex is safe to use
  * in interrupt context :)
  */
-static int kexec_lock;
+int kexec_lock;
 
 asmlinkage long sys_kexec_load(unsigned long entry, unsigned long nr_segments,
 				struct kexec_segment __user *segments,
@@ -989,6 +1000,8 @@ asmlinkage long sys_kexec_load(unsigned 
 		if (result)
 			goto out;
 
+		if (flags & KEXEC_PRESERVE_CONTEXT)
+			image->preserve_context = 1;
 		result = machine_kexec_prepare(image);
 		if (result)
 			goto out;
@@ -1413,3 +1426,53 @@ static int __init crash_save_vmcoreinfo_
 }
 
 module_init(crash_save_vmcoreinfo_init)
+
+int kexec_jump(struct kimage *image)
+{
+	int error = 0;
+
+	if (image->preserve_context) {
+		pm_prepare_console();
+		error = freeze_processes();
+		if (error) {
+			error = -EBUSY;
+			goto Exit;
+		}
+		suspend_console();
+		error = device_suspend(PMSG_FREEZE);
+		if (error)
+			goto Resume_console;
+		error = disable_nonboot_cpus();
+		if (error)
+			goto Resume_devices;
+		local_irq_disable();
+		/* At this point, device_suspend() has been called,
+		 * but *not* device_power_down(). We *must*
+		 * device_power_down() now.  Otherwise, drivers for
+		 * some devices (e.g. interrupt controllers) become
+		 * desynchronized with the actual state of the
+		 * hardware at resume time, and evil weirdness ensues.
+		 */
+		error = device_power_down(PMSG_FREEZE);
+		if (error)
+			goto Enable_irqs;
+		save_processor_state();
+	}
+	machine_kexec(image);
+
+	if (image->preserve_context) {
+		restore_processor_state();
+		device_power_up();
+ Enable_irqs:
+		local_irq_enable();
+		enable_nonboot_cpus();
+ Resume_devices:
+		device_resume();
+ Resume_console:
+		resume_console();
+		thaw_processes();
+ Exit:
+		pm_restore_console();
+	}
+	return error;
+}
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -301,18 +301,26 @@ EXPORT_SYMBOL_GPL(kernel_restart);
  *	Move into place and start executing a preloaded standalone
  *	executable.  If nothing was preloaded return an error.
  */
-static void kernel_kexec(void)
+static int kernel_kexec(void)
 {
+	int ret = -ENOSYS;
 #ifdef CONFIG_KEXEC
-	struct kimage *image;
-	image = xchg(&kexec_image, NULL);
-	if (!image)
-		return;
-	kernel_restart_prepare(NULL);
-	printk(KERN_EMERG "Starting new kernel\n");
-	machine_shutdown();
-	machine_kexec(image);
+	if (xchg(&kexec_lock, 1))
+		return -EBUSY;
+	if (!kexec_image) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+	if (!kexec_image->preserve_context) {
+		kernel_restart_prepare(NULL);
+		printk(KERN_EMERG "Starting new kernel\n");
+		machine_shutdown();
+	}
+	ret = kexec_jump(kexec_image);
+unlock:
+	xchg(&kexec_lock, 0);
 #endif
+	return ret;
 }
 
 static void kernel_shutdown_prepare(enum system_states state)
@@ -420,9 +428,12 @@ asmlinkage long sys_reboot(int magic1, i
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
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -92,7 +92,7 @@ config PM_SLEEP_SMP
 
 config PM_SLEEP
 	bool
-	depends on SUSPEND || HIBERNATION
+	depends on SUSPEND || HIBERNATION || KEXEC
 	default y
 
 config SUSPEND
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -9,6 +9,7 @@
 #include <linux/linkage.h>
 #include <asm/page.h>
 #include <asm/kexec.h>
+#include <asm/asm-offsets.h>
 
 /*
  * Must be relocatable PIC code callable as a C function
@@ -19,8 +20,83 @@
 #define PAGE_ATTR 0x63 /* _PAGE_PRESENT|_PAGE_RW|_PAGE_ACCESSED|_PAGE_DIRTY */
 #define PAE_PGD_ATTR 0x01 /* _PAGE_PRESENT */
 
+#define STACK_TOP		PAGE_SIZE_asm
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
+#define CP_PA_BACKUP_PAGES_MAP	DATA(0x3c)
+
 	.text
 	.align PAGE_ALIGNED
+	.globl relocate_page
+relocate_page:
+
+/*
+ * Entry point for jumping back from kexeced kernel, the paging is
+ * turned off.
+ */
+kexec_jump_back_entry:
+	call	1f
+1:
+	popl	%ebx
+	subl	$(1b - relocate_page), %ebx
+	movl	%edi, KJUMP_ENTRY_OFF(%ebx)
+	movl	CP_VA_CONTROL_PAGE(%ebx), %edi
+	lea	STACK_TOP(%ebx), %esp
+	movl	CP_PA_SWAP_PAGE(%ebx), %eax
+	movl	CP_PA_BACKUP_PAGES_MAP(%ebx), %edx
+	pushl	%eax
+	pushl	%edx
+	call	swap_pages
+	addl	$8, %esp
+	movl	CP_PA_PGD(%ebx), %eax
+	movl	%eax, %cr3
+	movl	%cr0, %eax
+	orl	$(1<<31), %eax
+	movl	%eax, %cr0
+	lea	STACK_TOP(%edi), %esp
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
@@ -146,6 +222,15 @@ relocate_new_kernel:
 	pushl $0
 	popfl
 
+	/* save some information for jumping back */
+	movl	PTR(VA_CONTROL_PAGE)(%ebp), %edi
+	movl	%edi, CP_VA_CONTROL_PAGE(%edi)
+	movl	PTR(PA_PGD)(%ebp), %eax
+	movl	%eax, CP_PA_PGD(%edi)
+	movl	PTR(PA_SWAP_PAGE)(%ebp), %eax
+	movl	%eax, CP_PA_SWAP_PAGE(%edi)
+	movl	%ebx, CP_PA_BACKUP_PAGES_MAP(%edi)
+
 	/* get physical address of control page now */
 	/* this is impossible after page table switch */
 	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edi
@@ -155,11 +240,11 @@ relocate_new_kernel:
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
 
@@ -197,8 +282,54 @@ identity_mapped:
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
+	movl	KJUMP_MAGIC_OFF(%edi), %eax
+	cmpl	$KJUMP_MAGIC_NUMBER, %eax
+	jz 1f
+	xorl	%edi, %edi
+	xorl	%eax, %eax
+	xorl	%ebx, %ebx
+	xorl    %ecx, %ecx
+	xorl    %edx, %edx
+	xorl    %esi, %esi
+	xorl    %ebp, %ebp
+	ret
+1:
+	popl	%edx
+	movl	CP_PA_SWAP_PAGE(%edi), %esp
+	addl	$PAGE_SIZE_asm, %esp
+	pushl	%edx
+2:
+	call	*%edx
+	movl	%edi, %edx
+	popl	%edi
+	pushl	%edx
+	jmp	2b
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
@@ -226,27 +357,50 @@ identity_mapped:
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
+	lea	PAGE_SIZE_asm(%ebp), %esi
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
--- /dev/null
+++ b/Documentation/i386/jump_back_protocol.txt
@@ -0,0 +1,66 @@
+		THE LINUX/I386 JUMP BACK PROTOCOL
+		---------------------------------
+
+		Huang Ying <ying.huang@intel.com>
+		    Last update 2007-12-19
+
+Currently, the following versions of the jump back protocol exist.
+
+Protocol 1.00:	Jumping between original kernel and kexeced kernel
+		support. Calling ordinary C function support.
+
+
+*** JUMP BACK ENTRY
+
+At jump back entry of callee, the CPU must be in 32-bit protected mode
+with paging disabled; the CS, DS, ES and SS must be 4G flat segments;
+CS must have execute/read permission, and DS, ES and SS must have
+read/write permission; interrupt must be disabled; the contents of
+registers and corresponding memory must be as follow:
+
+Offset/Size	Meaning
+
+%edi		Real jump back entry of caller if supported,
+		otherwise 0.
+%esp		Stack top pointer, the size of stack is about 4k bytes.
+(%esp)/4	Helper jump back entry of caller if %edi != 0,
+		otherwise undefined.
+
+If jumping back to caller is supported, %edi is the real jump back
+entry of caller, that is, the callee can jump back to %edi with the
+same protocol.
+
+If jumping back to caller is supported, (%esp) is the helper jump back
+entry of caller. At helper jump back entry, CPU state other than
+contents of registers must be same as ordinary jump back protocol; the
+contents of registers and corresponding memory must be as follow:
+
+Offset/Size	Meaning
+
+%edi,%esi,%ebp,%ebx Original value
+%esp		Original value - 4, that is, the return address is popped.
+
+This is same as function return ABI, and the jump back entry protocol
+conforms function calling ABI too. So, if the helper jump back entry
+is used, the jump back entry can be implemented as an ordinary C
+function, the function prototype is as follow:
+
+void jump_back_entry(void);
+
+The code at helper jump back entry of caller will jump to real jump
+back entry of caller, with contents of registers and corresponding
+memory as follow:
+
+Offset/Size	Meaning
+
+%edi		Real jump back entry of callee (start address of callee)
+%esp		Stack top pointer, the size of stack is about 4k bytes.
+(%esp)/4	Helper jump back entry of callee
+
+
+**** LOAD THE JUMP BACK IMAGE
+
+Jump back image is an ordinary ELF64 executable file, it can be loaded
+just as other ELF64 image. That is, the PT_LOAD segments should be
+loaded into their physical address. The entry point of jump back image
+is called the jump back entry of image.
--- a/arch/ppc/kernel/machine_kexec.c
+++ b/arch/ppc/kernel/machine_kexec.c
@@ -66,7 +66,7 @@ void machine_kexec_cleanup(struct kimage
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	if (ppc_md.machine_kexec)
 		ppc_md.machine_kexec(image);
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -179,7 +179,7 @@ void machine_kexec_cleanup(struct kimage
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
--- a/arch/sh/kernel/machine_kexec.c
+++ b/arch/sh/kernel/machine_kexec.c
@@ -70,7 +70,7 @@ static void kexec_info(struct kimage *im
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 
 	unsigned long page_list;
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -47,7 +47,7 @@ void machine_kexec_cleanup(struct kimage
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	if (ppc_md.machine_kexec)
 		ppc_md.machine_kexec(image);


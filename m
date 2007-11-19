Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbXKSG7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbXKSG7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 01:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbXKSG64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 01:58:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:10944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbXKSG6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 01:58:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,435,1188802800"; 
   d="scan'208";a="322047335"
Subject: [PATCH 1/3 -mm] kexec based hibernation -v6: kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Nov 2007 15:02:42 +0800
Message-Id: <1195455762.10291.24.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 19 Nov 2007 06:58:51.0150 (UTC) FILETIME=[A408AAE0:01C82A79]
Sender: linux-kernel-owner@vger.kernel.org
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
provided by this patch can be used to call ordinary C function in real
mode.

A set of flags for sys_kexec_load are added to control which state are
saved/restored before/after real mode code executing. Such as, you can
specify the device state and FPU state are saved/restored before/after
real mode code executing.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 Documentation/i386/jump_back_protocol.txt |  103 ++++++++++++++
 arch/powerpc/kernel/machine_kexec.c       |    2 
 arch/ppc/kernel/machine_kexec.c           |    2 
 arch/sh/kernel/machine_kexec.c            |    2 
 arch/x86/kernel/machine_kexec_32.c        |   88 +++++++++---
 arch/x86/kernel/machine_kexec_64.c        |    2 
 arch/x86/kernel/relocate_kernel_32.S      |  214 +++++++++++++++++++++++++++---
 include/asm-x86/kexec_32.h                |   39 ++++-
 include/linux/kexec.h                     |   39 ++++-
 kernel/kexec.c                            |  131 ++++++++++++++++++
 kernel/power/Kconfig                      |    2 
 kernel/sys.c                              |   27 ++-
 12 files changed, 585 insertions(+), 66 deletions(-)

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
 
@@ -96,25 +101,59 @@ int machine_kexec_prepare(struct kimage 
  */
 void machine_kexec_cleanup(struct kimage *image)
 {
+	if (nx_enabled) {
+		change_page_attr(image->control_code_page, 1, PAGE_KERNEL);
+		global_flush_tlb();
+	}
+}
+
+void machine_kexec(struct kimage *image)
+{
+	machine_kexec_call(image, NULL, 0);
 }
 
 /*
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+int machine_kexec_vcall(struct kimage *image, unsigned long *ret,
+			 unsigned int argc, va_list args)
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
+	KCALL_MAGIC(control_page) = 0;
 
+	if (image->preserve_cpu) {
+		unsigned int i;
+		KCALL_MAGIC(control_page) = KCALL_MAGIC_NUMBER;
+		KCALL_ARGC(control_page) = argc;
+		for (i = 0; i < argc; i++)
+			KCALL_ARGS(control_page)[i] = \
+				va_arg(args, unsigned long);
+
+		if (kexec_call_save_cpu(control_page)) {
+			image->start = KCALL_ENTRY(control_page);
+			if (ret)
+				*ret = KCALL_ARGS(control_page)[0];
+			return 0;
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
@@ -127,26 +166,33 @@ NORET_TYPE void machine_kexec(struct kim
 	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
 	page_list[PA_PTE_1] = __pa(kexec_pte1);
 	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
+	page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page) << PAGE_SHIFT);
 
-	/* The segment registers are funny things, they have both a
-	 * visible and an invisible part.  Whenever the visible part is
-	 * set to a specific selector, the invisible part is loaded
-	 * with from a table in memory.  At no other time is the
-	 * descriptor table in memory accessed.
-	 *
-	 * I take advantage of this here by force loading the
-	 * segments, before I zap the gdt with an invalid value.
-	 */
-	load_segments();
-	/* The gdt & idt are now invalid.
-	 * If you want to load them you must set up your own idt & gdt.
-	 */
-	set_gdt(phys_to_virt(0),0);
-	set_idt(phys_to_virt(0),0);
+	if (image->preserve_cpu_ext) {
+		/* The segment registers are funny things, they have
+		 * both a visible and an invisible part.  Whenever the
+		 * visible part is set to a specific selector, the
+		 * invisible part is loaded with from a table in
+		 * memory.  At no other time is the descriptor table
+		 * in memory accessed.
+		 *
+		 * I take advantage of this here by force loading the
+		 * segments, before I zap the gdt with an invalid
+		 * value.
+		 */
+		load_segments();
+		/* The gdt & idt are now invalid.  If you want to load
+		 * them you must set up your own idt & gdt.
+		 */
+		set_gdt(phys_to_virt(0), 0);
+		set_idt(phys_to_virt(0), 0);
+	}
 
 	/* now call it */
-	relocate_kernel((unsigned long)image->head, (unsigned long)page_list,
-			image->start, cpu_has_pae);
+	relocate_kernel_ptr((unsigned long)image->head,
+			    (unsigned long)page_list,
+			    image->start, cpu_has_pae);
+	return 0;
 }
 
 void arch_crash_save_vmcoreinfo(void)
--- a/include/asm-x86/kexec_32.h
+++ b/include/asm-x86/kexec_32.h
@@ -9,16 +9,40 @@
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
 
+#define KCALL_DATA_BASE		0x800
+
+#define KCALL_MAGIC_NUMBER	0xe1b6a57d
+
+#define KCALL_DATA(buf)		((__u8 *)(buf)+KCALL_DATA_BASE)
+#define KCALL_OFF(off)		(KCALL_DATA_BASE+(off))
+
+#define KCALL_MAGIC_OFF		KCALL_OFF(0x0)
+#define KCALL_MAGIC(buf)	(*(__u32 *)(KCALL_DATA(buf)+0x0))
+#define KCALL_ARGC_OFF		KCALL_OFF(0x4)
+#define KCALL_ARGC(buf)		(*(__u32 *)(KCALL_DATA(buf)+0x4))
+#define KCALL_ARGS_OFF		KCALL_OFF(0x8)
+#define KCALL_ARGS(buf)		((__u32 *)(KCALL_DATA(buf)+0x8))
+
+/*
+ * The following are not a part of jump back protocol, for internal
+ * use only
+ */
+#define KCALL_ENTRY_OFF		KCALL_OFF(0x200)
+#define KCALL_ENTRY(buf)	(*(__u32 *)(KCALL_DATA(buf)+0x200))
+/* Other internal data fields base */
+#define KCALL_OTHER_OFF		KCALL_OFF(0x204)
+
 #ifndef __ASSEMBLY__
 
 #include <asm/ptrace.h>
@@ -94,6 +118,9 @@ relocate_kernel(unsigned long indirectio
 		unsigned long start_address,
 		unsigned int has_pae) ATTRIB_NORET;
 
+extern char relocate_page[PAGE_SIZE];
+
+extern asmlinkage int kexec_call_save_cpu(void *buf);
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
@@ -98,18 +99,37 @@ struct kimage {
 	unsigned int type : 1;
 #define KEXEC_TYPE_DEFAULT 0
 #define KEXEC_TYPE_CRASH   1
+	unsigned int preserve_cpu : 1;
+	unsigned int preserve_cpu_ext : 1;
+	unsigned int single_cpu : 1;
+	unsigned int preserve_device : 1;
+	unsigned int preserve_console : 1;
 };
 
 
 
 /* kexec interface functions */
-extern NORET_TYPE void machine_kexec(struct kimage *image) ATTRIB_NORET;
+extern void machine_kexec(struct kimage *image);
+extern int machine_kexec_vcall(struct kimage *image, unsigned long *ret,
+			       unsigned int argc, va_list args);
+extern int machine_kexec_call(struct kimage *image, unsigned long *ret,
+			      unsigned int argc, ...);
 extern int machine_kexec_prepare(struct kimage *image);
 extern void machine_kexec_cleanup(struct kimage *image);
 extern asmlinkage long sys_kexec_load(unsigned long entry,
 					unsigned long nr_segments,
 					struct kexec_segment __user *segments,
 					unsigned long flags);
+extern void kimage_free(struct kimage *image);
+extern int kexec_call(struct kimage *image, unsigned long *ret,
+		      unsigned int argc, ...);
+extern int kexec_vcall(struct kimage *image, unsigned long *ret,
+		       unsigned int argc, va_list args);
+extern int machine_kexec_jump(struct kimage *image, unsigned long *cmd_ret,
+			      unsigned long cmd);
+extern int kexec_jump(struct kimage *image, unsigned long *cmd_ret,
+		      unsigned long cmd);
+#define KJUMP_CMD_NONE 0
 #ifdef CONFIG_COMPAT
 extern asmlinkage long compat_sys_kexec_load(unsigned long entry,
 				unsigned long nr_segments,
@@ -152,8 +172,13 @@ extern struct kimage *kexec_crash_image;
 #define kexec_flush_icache_page(page)
 #endif
 
-#define KEXEC_ON_CRASH  0x00000001
-#define KEXEC_ARCH_MASK 0xffff0000
+#define KEXEC_ON_CRASH		0x00000001
+#define KEXEC_PRESERVE_CPU	0x00000002
+#define KEXEC_PRESERVE_CPU_EXT	0x00000004
+#define KEXEC_SINGLE_CPU	0x00000008
+#define KEXEC_PRESERVE_DEVICE	0x00000010
+#define KEXEC_PRESERVE_CONSOLE	0x00000020
+#define KEXEC_ARCH_MASK		0xffff0000
 
 /* These values match the ELF architecture values.
  * Unless there is a good reason that should continue to be the case.
@@ -170,7 +195,13 @@ extern struct kimage *kexec_crash_image;
 #define KEXEC_ARCH_MIPS_LE (10 << 16)
 #define KEXEC_ARCH_MIPS    ( 8 << 16)
 
-#define KEXEC_FLAGS    (KEXEC_ON_CRASH)  /* List of defined/legal kexec flags */
+/* List of defined/legal kexec flags */
+#define KEXEC_FLAGS    (KEXEC_ON_CRASH |		\
+			KEXEC_PRESERVE_CPU |		\
+			KEXEC_PRESERVE_CPU_EXT |	\
+			KEXEC_SINGLE_CPU |		\
+			KEXEC_PRESERVE_DEVICE |		\
+			KEXEC_PRESERVE_CONSOLE)
 
 #define VMCOREINFO_BYTES           (4096)
 #define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
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
@@ -243,6 +247,12 @@ static int kimage_normal_alloc(struct ki
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
@@ -613,7 +623,7 @@ static void kimage_free_entry(kimage_ent
 	kimage_free_pages(page);
 }
 
-static void kimage_free(struct kimage *image)
+void kimage_free(struct kimage *image)
 {
 	kimage_entry_t *ptr, entry;
 	kimage_entry_t ind = 0;
@@ -989,6 +999,16 @@ asmlinkage long sys_kexec_load(unsigned 
 		if (result)
 			goto out;
 
+		if (flags & KEXEC_PRESERVE_CPU)
+			image->preserve_cpu = 1;
+		if (flags & KEXEC_PRESERVE_CPU_EXT)
+			image->preserve_cpu_ext = 1;
+		if (flags & KEXEC_SINGLE_CPU)
+			image->single_cpu = 1;
+		if (flags & KEXEC_PRESERVE_DEVICE)
+			image->preserve_device = 1;
+		if (flags & KEXEC_PRESERVE_CONSOLE)
+			image->preserve_console = 1;
 		result = machine_kexec_prepare(image);
 		if (result)
 			goto out;
@@ -1413,3 +1433,112 @@ static int __init crash_save_vmcoreinfo_
 }
 
 module_init(crash_save_vmcoreinfo_init)
+
+int machine_kexec_call(struct kimage *image, unsigned long *ret,
+			unsigned int argc, ...)
+{
+	va_list args;
+	int error;
+	va_start(args, argc);
+	error = machine_kexec_vcall(image, ret, argc, args);
+	va_end(args);
+	return error;
+}
+
+int __attribute__ ((weak)) machine_kexec_vcall(struct kimage *image,
+						unsigned long *ret,
+						unsigned int argc,
+						va_list args)
+{
+	machine_kexec(image);
+	if (ret)
+		*ret = 0;
+	return 0;
+}
+
+int kexec_call(struct kimage *image, unsigned long *ret,
+	       unsigned int argc, ...)
+{
+	int retval;
+	va_list args;
+	va_start(args, argc);
+	retval = kexec_vcall(image, ret, argc, args);
+	va_end(args);
+	return retval;
+}
+
+int kexec_vcall(struct kimage *image, unsigned long *ret,
+		unsigned int argc, va_list args)
+{
+	int error = 0;
+
+	if (image->preserve_console) {
+		pm_prepare_console();
+		suspend_console();
+	}
+	if (image->preserve_device) {
+		error = device_suspend(PMSG_FREEZE);
+		if (error)
+			goto Resume_console;
+	}
+	if (image->single_cpu) {
+		error = disable_nonboot_cpus();
+		if (error)
+			goto Resume_devices;
+	}
+	local_irq_disable();
+	if (image->preserve_device) {
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
+	}
+
+	if (image->preserve_cpu_ext)
+		save_processor_state();
+
+	machine_kexec_vcall(image, ret, argc, args);
+
+	if (image->preserve_cpu_ext)
+		restore_processor_state();
+
+	if (image->preserve_device) {
+		/* NOTE:  device_power_up() is just a resume() for devices
+		 * that suspended with irqs off ... no overall powerup.
+		 */
+		device_power_up();
+	}
+ Enable_irqs:
+	local_irq_enable();
+	if (image->single_cpu)
+		enable_nonboot_cpus();
+ Resume_devices:
+	if (image->preserve_device)
+		device_resume();
+ Resume_console:
+	if (image->preserve_console) {
+		resume_console();
+		pm_restore_console();
+	}
+	return error;
+}
+
+int machine_kexec_jump(struct kimage *image, unsigned long *cmd_ret,
+		       unsigned long cmd)
+{
+	return machine_kexec_call(image, cmd_ret, 4, cmd, image->head,
+				  __pa(vmcoreinfo_data), vmcoreinfo_size);
+}
+
+int kexec_jump(struct kimage *image, unsigned long *cmd_ret,
+	       unsigned long cmd)
+{
+	return kexec_call(image, cmd_ret, 4, cmd, image->head,
+			  __pa(vmcoreinfo_data), vmcoreinfo_size);
+}
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -301,18 +301,24 @@ EXPORT_SYMBOL_GPL(kernel_restart);
  *	Move into place and start executing a preloaded standalone
  *	executable.  If nothing was preloaded return an error.
  */
-static void kernel_kexec(void)
+static int kernel_kexec(unsigned long cmd)
 {
+	int ret = -ENOSYS;
 #ifdef CONFIG_KEXEC
 	struct kimage *image;
 	image = xchg(&kexec_image, NULL);
 	if (!image)
-		return;
-	kernel_restart_prepare(NULL);
-	printk(KERN_EMERG "Starting new kernel\n");
-	machine_shutdown();
-	machine_kexec(image);
+		return -EINVAL;
+	if (!image->preserve_cpu) {
+		kernel_restart_prepare(NULL);
+		printk(KERN_EMERG "Starting new kernel\n");
+		machine_shutdown();
+	}
+	ret = kexec_jump(image, NULL, cmd);
+	image = xchg(&kexec_image, image);
+	kimage_free(image);
 #endif
+	return ret;
 }
 
 static void kernel_shutdown_prepare(enum system_states state)
@@ -420,9 +426,12 @@ asmlinkage long sys_reboot(int magic1, i
 		break;
 
 	case LINUX_REBOOT_CMD_KEXEC:
-		kernel_kexec();
-		unlock_kernel();
-		return -EINVAL;
+		{
+			int ret;
+			ret = kernel_kexec((unsigned long)arg);
+			unlock_kernel();
+			return ret;
+		}
 
 #ifdef CONFIG_HIBERNATION
 	case LINUX_REBOOT_CMD_SW_SUSPEND:
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -70,7 +70,7 @@ config PM_SLEEP_SMP
 
 config PM_SLEEP
 	bool
-	depends on SUSPEND || HIBERNATION
+	depends on SUSPEND || HIBERNATION || KEXEC
 	default y
 
 config SUSPEND_UP_POSSIBLE
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -9,6 +9,7 @@
 #include <linux/linkage.h>
 #include <asm/page.h>
 #include <asm/kexec.h>
+#include <asm/asm-offsets.h>
 
 /*
  * Must be relocatable PIC code callable as a C function
@@ -19,8 +20,89 @@
 #define PAGE_ATTR 0x63 /* _PAGE_PRESENT|_PAGE_RW|_PAGE_ACCESSED|_PAGE_DIRTY */
 #define PAE_PGD_ATTR 0x01 /* _PAGE_PRESENT */
 
+#define STACK_TOP		PAGE_SIZE_asm
+
+#define DATA(offset)		(KCALL_OTHER_OFF+(offset))
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
+	movl	%edi, KCALL_ENTRY_OFF(%ebx)
+	movl	$0, %eax
+	andl	%esi, %esi
+	jz	2f
+	movl	4(%esp), %eax
+2:
+	movl	%eax, KCALL_ARGS_OFF(%ebx)
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
@@ -146,6 +228,15 @@ relocate_new_kernel:
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
@@ -155,11 +246,11 @@ relocate_new_kernel:
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
 
@@ -197,8 +288,68 @@ identity_mapped:
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
+	movl	KCALL_MAGIC_OFF(%edi), %eax
+	cmpl	$KCALL_MAGIC_NUMBER, %eax
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
+	movl	%edi, %ebp
+	movl	KCALL_ARGC_OFF(%edi), %ecx
+	shll	$2, %ecx
+	movl	%edi, %esi
+	addl	$KCALL_ARGS_OFF, %esi
+	subl	%ecx, %esp
+	movl	%esp, %edi
+	rep ; movsb
+	movl	%ebp, %edi
+	movl	KCALL_ARGC_OFF(%edi), %esi
+2:
+	call	*%edx
+	shll	$2, %esi
+	addl	%esi, %esp
+	movl	%edi, %edx
+	popl	%edi
+	pushl	%edx
+	pushl	%eax
+	movl	$1, %esi
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
@@ -226,27 +377,50 @@ identity_mapped:
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
+	.globl kexec_call_save_cpu
+kexec_call_save_cpu:
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
@@ -0,0 +1,103 @@
+		THE LINUX/I386 JUMP BACK PROTOCOL
+		---------------------------------
+
+		Huang Ying <ying.huang@intel.com>
+		    Last update 2007-11-17
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
+%esi		Number of parameters, that is, N.
+%esp		Stack top pointer, the size of stack is about 4k.
+(%esp)/4	Helper jump back entry of caller if %edi != 0,
+		otherwise undefined.
+4*n(%esp)/4	nth parameter
+2048(%edi)/4	Optional, if %edi != 0, magic number: 0xe1b6a57d
+2052(%edi)/4	Optional, if %edi != 0 and 2048(%edi) == 0xe1b6a57d,
+		number of parameters, that is, N
+(2056+4*n)(%edi)/4 Optional, if %edi != 0 and 2048(%edi) == 0xe1b6a57d,
+		   nth parameter
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
+%eax		Return value.
+
+This is same as function return ABI, and the jump back entry protocol
+conforms function calling ABI too. So, if the helper jump back entry
+is used, the jump back entry can be implemented as an ordinary C
+function without register parameters, the function protocol is as
+follow:
+
+unsigned long jump_back_entry(...)
+
+or
+
+unsigned long jump_back_entry(unsigned long arg1,
+			      unsigned long arg2,
+			      unsigned long arg3,
+			      ...
+			      unsigned long argN);
+
+The code at helper jump back entry of caller will jump to real jump
+back entry of caller, with contents of registers and corresponding
+memory as follow:
+
+Offset/Size	Meaning
+
+%edi		Real jump back entry of callee (start address of callee)
+%esi		1, number of parameters
+%esp		Stack top pointer, the size of stack is about 4k.
+(%esp)/4	Helper jump back entry of callee
+4(%esp)/4	%eax at helper jump back entry, first parameter
+
+That is, the return value of jump back entry of callee is used as the
+only parameter to call the jump back entry of caller.
+
+If jumping back to caller is supported, and 2048(%edi) == 0xe1b6a57d,
+the parameters information is stored at memory from 2048(%edi) on as
+well. This is used to check the parameters information of jump back
+image.
+
+
+**** LOAD THE JUMP BACK IMAGE
+
+Jump back image is an ordinary ELF64 executable file, it can be loaded
+just as other ELF64 image. That is, the PT_LOAD segments should be
+loaded into their physical address. The entry point of jump back image
+is called the jump back entry of image.
+
+Before loading all segments of jump back image, the jump back header
+can be checked. The contents of jump back header is the optional part
+from 2048(%edi) on in jump back entry protocol, details as follow:
+
+Offset/Size	Meaning
+
+2048/4		Magic number: 0xe1b6a57d
+2052/4		Number of parameters, that is, N
+2056+4*n/4	nth parameter
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

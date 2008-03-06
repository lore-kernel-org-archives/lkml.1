Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbYCFDMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbYCFDMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 22:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760086AbYCFDMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 22:12:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:3232 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760997AbYCFDMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 22:12:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,454,1199692800"; 
   d="scan'208";a="261050933"
Subject: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Mar 2008 11:13:08 +0800
Message-Id: <1204773188.4707.109.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 06 Mar 2008 03:11:08.0786 (UTC) FILETIME=[B93E5D20:01C87F37]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a minimal patch with only the essential features. All
additional features are split out and can be discussed later. I think
it may be easier to get consensus on this minimal patch.

Best Regards,
Huang Ying

------------------------------------>

This patch provides an enhancement to kexec/kdump. It implements
the following features:

- Jumping between the original kernel and the kexeced kernel.

- Backup/restore memory used by both the original kernel and the
  kexeced kernel.

- Save/restore CPU and devices state before after kexec.


The features of this patch can be used for as follow:

- A simple hibernation implementation without ACPI support. You can
  kexec a hibernating kernel, save the memory image of original system
  and shutdown the system. When resuming, you restore the memory image
  of original system via ordinary kexec load then jump back.

- Kernel/system debug through making system snapshot. You can make
  system snapshot, jump back, do some thing and make another system
  snapshot.

- Cooperative multi-kernel/system. With kexec jump, you can switch
  between several kernels/systems quickly without boot process except
  the first time. This appears like swap a whole kernel/system out/in.

- A general method to call program in physical mode (paging turning
  off). This can be used to invoke BIOS code under Linux.


The following user-space tools can be used with kexec jump:

- kexec-tools needs to be patched to support kexec jump. The patches
  and the precompiled kexec can be download from the following URL:
       source: http://khibernation.sourceforge.net/download/release_v9/kexec-tools/kexec-tools-src_git_kh9.tar.bz2
       patches: http://khibernation.sourceforge.net/download/release_v9/kexec-tools/kexec-tools-patches_git_kh9.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v9/kexec-tools/kexec_git_kh9

- makedumpfile with patches are used as memory image saving tool, it
  can exclude free pages from original kernel memory image file. The
  patches and the precompiled makedumpfile can be download from the
  following URL:
       source: http://khibernation.sourceforge.net/download/release_v9/makedumpfile/makedumpfile-src_cvs_kh9.tar.bz2
       patches: http://khibernation.sourceforge.net/download/release_v9/makedumpfile/makedumpfile-patches_cvs_kh9.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v9/makedumpfile/makedumpfile_cvs_kh9

- An initramfs image can be used as the root file system of kexeced
  kernel. An initramfs image built with "BuildRoot" can be downloaded
  from the following URL:
       initramfs image: http://khibernation.sourceforge.net/download/release_v9/initramfs/rootfs_cvs_kh9.gz
  All user space tools above are included in the initramfs image.


Usage example of simple hibernation:

1. Compile and install patched kernel with following options selected:

CONFIG_X86_32=y
CONFIG_RELOCATABLE=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PM=y

2. Build an initramfs image contains kexec-tool and makedumpfile, or
   download the pre-built initramfs image, called rootfs.gz in
   following text.

3. Prepare a partition to save memory image of original kernel, called
   hibernating partition in following text.

3. Boot kernel compiled in step 1 (kernel A).

4. In the kernel A, load kernel compiled in step 1 (kernel B) with
   /sbin/kexec. The shell command line can be as follow:

   /sbin/kexec --load-preserve-context /boot/bzImage --mem-min=0x100000
     --mem-max=0xffffff --initrd=rootfs.gz

5. Boot the kernel B with following shell command line:

   /sbin/kexec -e

6. The kernel B will boot as normal kexec. In kernel B the memory
   image of kernel A can be saved into hibernating partition as
   follow:

   jump_back_entry=`cat /proc/cmdline | tr ' ' '\n' | grep kexec_jump_back_entry | cut -d '='`
   echo $jump_back_entry > kexec_jump_back_entry
   cp /proc/vmcore dump.elf

   Then you can shutdown the machine as normal.

7. Boot kernel compiled in step 1 (kernel C). Use the rootfs.gz as
   root file system.

8. In kernel C, load the memory image of kernel A as follow:

   /sbin/kexec -l --args-none --entry=`cat kexec_jump_back_entry` dump.elf

9. Jump back to the kernel A as follow:

   /sbin/kexec -e

   Then, kernel A is resumed.


Implementation point:

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


Known issues:

- The suspend/resume callback of device drivers are used to put
  devices into quiescent state. This will unnecessarily (possibly
  harmfully) put devices into low power state. This is intended to be
  solved by separating device quiesce/unquiesce callback from the
  device suspend/resume callback.

- Because the segment number supported by sys_kexec_load is limited,
  hibernation image with many segments may not be load. This is
  planned to be eliminated by adding a new flag to sys_kexec_load to
  make a image can be loaded with multiple sys_kexec_load invoking.


ChangeLog:

v9:

- pm_mutex is locked during kexec jump to avoid potential conflict
  between kexec jump and suspend/resume/hibernation.

- Split /dev/oldmem writing and kimagecore patch out, keep only the
  core function.

v8:

- Split kexec jump patchset from kexec based hibernation patchset.

- Merge various KEXEC_PRESERVE_* flags into one KEXEC_PRESERVE_CONTEXT
  because there is no need for such subtle control.

- Delete variable argument based "kernel to kernel" communication
  mechanism from basic kexec jump patchset.

v7:

- Refactor kexec jump to be a command driven programming model.

- Use kexec_lock to do synchronization.

v6:

- Refactor kexec jump to be a general facility to call real mode code.

v5:

- A flag (KEXEC_JUMP_BACK) is added to indicate the loaded kernel
  image is used for jumping back. The reboot command for jumping back
  is removed. This interface is more stable (proposed by Eric
  Biederman).

- NX bit handling support for kexec is added.

- Merge machine_kexec and machine_kexec_jump, remove NO_RET attribute
  from machine_kexec.

- Passing jump back entry to kexeced kernel via kernel command line
  (parsed by user space tool via /proc/cmdline instead of
  kernel). Original corresponding boot parameter and sysfs code is
  removed.

v4:

- Two reboot command are merged back to one because the underlying
  implementation is same.

- Jumping without reserving memory is implemented. As a side effect,
  two direction jumping is implemented.

- A jump back protocol is defined and documented. The original kernel
  and kexeced kernel are more independent from each other.

- The CPU state save/restore code are merged into relocate_kernel.S.

v3:

- The reboot command LINUX_REBOOT_CMD_KJUMP is split into to two
  reboot command to reflect the different function.

- Document is added for added kernel parameters.

- /sys/kernel/kexec_jump_buf_pfn is made writable, it is used for
  memory image restoring.

- Console restoring after jumping back is implemented.

v2:

- The kexec jump implementation is put into the kexec/kdump framework
  instead of software suspend framework. The device and CPU state
  save/restore code of software suspend is called when needed.

- The same code path is used for both kexec a new kernel and jump back
  to original kernel.


Now, only the i386 architecture is supported. The patchset is based on
Linux kernel 2.6.25-rc3-mm1, and has been tested on IBM T42 with ACPI
on and off.


Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 Documentation/i386/jump_back_protocol.txt |   66 ++++++++++
 arch/powerpc/kernel/machine_kexec.c       |    2 
 arch/ppc/kernel/machine_kexec.c           |    2 
 arch/sh/kernel/machine_kexec.c            |    2 
 arch/x86/kernel/machine_kexec_32.c        |   35 ++++-
 arch/x86/kernel/machine_kexec_64.c        |    2 
 arch/x86/kernel/relocate_kernel_32.S      |  194 ++++++++++++++++++++++++++----
 include/asm-x86/kexec.h                   |   35 ++++-
 include/linux/kexec.h                     |   14 +-
 include/linux/suspend.h                   |    2 
 kernel/kexec.c                            |   67 ++++++++++
 kernel/power/Kconfig                      |    2 
 kernel/power/power.h                      |    2 
 kernel/sys.c                              |   35 +++--
 14 files changed, 404 insertions(+), 56 deletions(-)

--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -20,6 +20,7 @@
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
 #include <asm/system.h>
+#include <asm/cacheflush.h>
 
 #define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
 static u32 kexec_pgd[1024] PAGE_ALIGNED;
@@ -83,10 +84,12 @@ static void load_segments(void)
  * reboot code buffer to allow us to avoid allocations
  * later.
  *
- * Currently nothing.
+ * Make control page executable.
  */
 int machine_kexec_prepare(struct kimage *image)
 {
+	if (nx_enabled)
+		set_pages_x(image->control_code_page, 1);
 	return 0;
 }
 
@@ -96,25 +99,43 @@ int machine_kexec_prepare(struct kimage 
  */
 void machine_kexec_cleanup(struct kimage *image)
 {
+	if (nx_enabled)
+		set_pages_nx(image->control_code_page, 1);
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
+	memcpy(control_page, kexec_relocate_page, PAGE_SIZE/2);
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
+		((void *)relocate_kernel - (void *)kexec_relocate_page);
 	page_list[PA_CONTROL_PAGE] = __pa(control_page);
-	page_list[VA_CONTROL_PAGE] = (unsigned long)relocate_kernel;
+	page_list[VA_CONTROL_PAGE] = (unsigned long)control_page;
 	page_list[PA_PGD] = __pa(kexec_pgd);
 	page_list[VA_PGD] = (unsigned long)kexec_pgd;
 #ifdef CONFIG_X86_PAE
@@ -127,6 +148,7 @@ NORET_TYPE void machine_kexec(struct kim
 	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
 	page_list[PA_PTE_1] = __pa(kexec_pte1);
 	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
+	page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page) << PAGE_SHIFT);
 
 	/* The segment registers are funny things, they have both a
 	 * visible and an invisible part.  Whenever the visible part is
@@ -145,8 +167,9 @@ NORET_TYPE void machine_kexec(struct kim
 	set_idt(phys_to_virt(0),0);
 
 	/* now call it */
-	relocate_kernel((unsigned long)image->head, (unsigned long)page_list,
-			image->start, cpu_has_pae);
+	relocate_kernel_ptr((unsigned long)image->head,
+			    (unsigned long)page_list,
+			    image->start, cpu_has_pae);
 }
 
 void arch_crash_save_vmcoreinfo(void)
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
@@ -242,6 +247,12 @@ static int kimage_normal_alloc(struct ki
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
@@ -919,7 +930,7 @@ struct kimage *kexec_crash_image;
  * Nothing can wait so this mutex is safe to use
  * in interrupt context :)
  */
-static int kexec_lock;
+int kexec_lock;
 
 asmlinkage long sys_kexec_load(unsigned long entry, unsigned long nr_segments,
 				struct kexec_segment __user *segments,
@@ -988,6 +999,8 @@ asmlinkage long sys_kexec_load(unsigned 
 		if (result)
 			goto out;
 
+		if (flags & KEXEC_PRESERVE_CONTEXT)
+			image->preserve_context = 1;
 		result = machine_kexec_prepare(image);
 		if (result)
 			goto out;
@@ -1412,3 +1425,55 @@ static int __init crash_save_vmcoreinfo_
 }
 
 module_init(crash_save_vmcoreinfo_init)
+
+int kexec_jump(struct kimage *image)
+{
+	int error = 0;
+
+	mutex_lock(&pm_mutex);
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
+	mutex_unlock(&pm_mutex);
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
+	.global kexec_relocate_page
+kexec_relocate_page:
+
+/*
+ * Entry point for jumping back from kexeced kernel, the paging is
+ * turned off.
+ */
+kexec_jump_back_entry:
+	call	1f
+1:
+	popl	%ebx
+	subl	$(1b - kexec_relocate_page), %ebx
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
+	addl	$(virtual_mapped - kexec_relocate_page), %eax
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
+	addl    $(identity_mapped - kexec_relocate_page), %eax
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
@@ -48,7 +48,7 @@ void machine_kexec_cleanup(struct kimage
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	if (ppc_md.machine_kexec)
 		ppc_md.machine_kexec(image);
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -53,8 +53,6 @@ extern int hibernation_platform_enter(vo
 
 extern int pfn_is_nosave(unsigned long);
 
-extern struct mutex pm_mutex;
-
 #define power_attr(_name) \
 static struct kobj_attribute _name##_attr = {	\
 	.attr	= {				\
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -255,4 +255,6 @@ static inline void register_nosave_regio
 }
 #endif
 
+extern struct mutex pm_mutex;
+
 #endif /* _LINUX_SUSPEND_H */
--- a/include/asm-x86/kexec.h
+++ b/include/asm-x86/kexec.h
@@ -10,14 +10,15 @@
 # define VA_PTE_0		5
 # define PA_PTE_1		6
 # define VA_PTE_1		7
+# define PA_SWAP_PAGE		8
 # ifdef CONFIG_X86_PAE
-#  define PA_PMD_0		8
-#  define VA_PMD_0		9
-#  define PA_PMD_1		10
-#  define VA_PMD_1		11
-#  define PAGES_NR		12
+#  define PA_PMD_0		9
+#  define VA_PMD_0		10
+#  define PA_PMD_1		11
+#  define VA_PMD_1		12
+#  define PAGES_NR		13
 # else
-#  define PAGES_NR		8
+#  define PAGES_NR		9
 # endif
 #else
 # define PA_CONTROL_PAGE	0
@@ -40,6 +41,26 @@
 # define PAGES_NR		17
 #endif
 
+#ifdef CONFIG_X86_32
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
+#endif
+
 #ifndef __ASSEMBLY__
 
 #include <linux/string.h>
@@ -158,6 +179,8 @@ relocate_kernel(unsigned long indirectio
 		unsigned long control_page,
 		unsigned long start_address,
 		unsigned int has_pae) ATTRIB_NORET;
+asmlinkage int kexec_jump_save_cpu(void *buf);
+extern u8 kexec_relocate_page[PAGE_SIZE];
 #else
 NORET_TYPE void
 relocate_kernel(unsigned long indirection_page,


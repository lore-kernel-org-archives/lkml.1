Return-Path: <linux-kernel-owner+w=401wt.eu-S1751265AbXGSKBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbXGSKBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbXGSJzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:35344 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbXGSJy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:54:58 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [12/58] x86_64: Add vDSO for x86-64 with gettimeofday/clock_gettime/getcpu
Message-Id: <20070719095456.B996214E03@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This implements new vDSO for x86-64.  The concept is similar
to the existing vDSOs on i386 and PPC.  x86-64 has had static
vsyscalls before,  but these are not flexible enough anymore.

A vDSO is a ELF shared library supplied by the kernel that is mapped into 
user address space.  The vDSO mapping is randomized for each process
for security reasons.

Doing this was needed for clock_gettime, because clock_gettime
always needs a syscall fallback and having one at a fixed
address would have made buffer overflow exploits too easy to write.

The vdso can be disabled with vdso=0

It currently includes a new gettimeofday implemention and optimized
clock_gettime(). The gettimeofday implementation is slightly faster
than the one in the old vsyscall.  clock_gettime is significantly faster 
than the syscall for CLOCK_MONOTONIC and CLOCK_REALTIME.

The new calls are generally faster than the old vsyscall. 

Advantages over the old x86-64 vsyscalls:
- Extensible
- Randomized
- Cleaner
- Easier to virtualize (the old static address range previously causes
overhead e.g. for Xen because it has to create special page tables for it) 

Weak points: 
- glibc support still to be written

The VM interface is partly based on Ingo Molnar's i386 version.

Includes compile fix from Joachim Deguara

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/kernel-parameters.txt |    2 
 arch/x86_64/Makefile                |    3 
 arch/x86_64/ia32/ia32_binfmt.c      |    1 
 arch/x86_64/kernel/time.c           |    1 
 arch/x86_64/kernel/vmlinux.lds.S    |    9 ++
 arch/x86_64/kernel/vsyscall.c       |   22 +----
 arch/x86_64/mm/init.c               |    9 ++
 arch/x86_64/vdso/Makefile           |   49 ++++++++++++
 arch/x86_64/vdso/vclock_gettime.c   |  120 +++++++++++++++++++++++++++++++
 arch/x86_64/vdso/vdso-note.S        |   12 +++
 arch/x86_64/vdso/vdso-start.S       |    2 
 arch/x86_64/vdso/vdso.S             |    2 
 arch/x86_64/vdso/vdso.lds.S         |   77 +++++++++++++++++++
 arch/x86_64/vdso/vextern.h          |   16 ++++
 arch/x86_64/vdso/vgetcpu.c          |   50 ++++++++++++
 arch/x86_64/vdso/vma.c              |  139 ++++++++++++++++++++++++++++++++++++
 arch/x86_64/vdso/voffset.h          |    1 
 arch/x86_64/vdso/vvar.c             |   12 +++
 include/asm-x86_64/auxvec.h         |    2 
 include/asm-x86_64/elf.h            |   13 +++
 include/asm-x86_64/mmu.h            |    1 
 include/asm-x86_64/vgtod.h          |   29 +++++++
 include/asm-x86_64/vsyscall.h       |    3 
 23 files changed, 554 insertions(+), 21 deletions(-)

Index: linux/arch/x86_64/ia32/ia32_binfmt.c
===================================================================
--- linux.orig/arch/x86_64/ia32/ia32_binfmt.c
+++ linux/arch/x86_64/ia32/ia32_binfmt.c
@@ -38,6 +38,7 @@
 
 int sysctl_vsyscall32 = 1;
 
+#undef ARCH_DLINFO
 #define ARCH_DLINFO do {  \
 	if (sysctl_vsyscall32) { \
 	NEW_AUX_ENT(AT_SYSINFO, (u32)(u64)VSYSCALL32_VSYSCALL); \
Index: linux/arch/x86_64/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/x86_64/kernel/vmlinux.lds.S
+++ linux/arch/x86_64/kernel/vmlinux.lds.S
@@ -91,6 +91,9 @@ SECTIONS
   .vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data))
 		{ *(.vsyscall_gtod_data) }
   vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
+  .vsyscall_clock : AT(VLOAD(.vsyscall_clock))
+		{ *(.vsyscall_clock) }
+  vsyscall_clock = VVIRT(.vsyscall_clock);
 
 
   .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1))
@@ -187,6 +190,12 @@ SECTIONS
   .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) { *(.exit.text) }
   .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) { *(.exit.data) }
 
+/* vdso blob that is mapped into user space */
+  vdso_start = . ;
+  .vdso  : AT(ADDR(.vdso) - LOAD_OFFSET) { *(.vdso) }
+  . = ALIGN(4096);
+  vdso_end = .;
+
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
   __initramfs_start = .;
Index: linux/arch/x86_64/mm/init.c
===================================================================
--- linux.orig/arch/x86_64/mm/init.c
+++ linux/arch/x86_64/mm/init.c
@@ -774,3 +774,12 @@ void *alloc_bootmem_high_node(pg_data_t 
 	return __alloc_bootmem_core(pgdat->bdata, size,
 			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
 }
+
+const char *arch_vma_name(struct vm_area_struct *vma)
+{
+	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
+		return "[vdso]";
+	if (vma == &gate_vma)
+		return "[vsyscall]";
+	return NULL;
+}
Index: linux/arch/x86_64/vdso/vdso-note.S
===================================================================
--- /dev/null
+++ linux/arch/x86_64/vdso/vdso-note.S
@@ -0,0 +1,12 @@
+/*
+ * This supplies .note.* sections to go into the PT_NOTE inside the vDSO text.
+ * Here we can supply some information useful to userland.
+ */
+
+#include <linux/uts.h>
+#include <linux/version.h>
+#include <linux/elfnote.h>
+
+ELFNOTE_START(Linux, 0, "a")
+	.long LINUX_VERSION_CODE
+ELFNOTE_END
Index: linux/arch/x86_64/vdso/vdso.lds.S
===================================================================
--- /dev/null
+++ linux/arch/x86_64/vdso/vdso.lds.S
@@ -0,0 +1,77 @@
+/*
+ * Linker script for vsyscall DSO.  The vsyscall page is an ELF shared
+ * object prelinked to its virtual address, and with only one read-only
+ * segment (that fits in one page).  This script controls its layout.
+ */
+#include <asm/asm-offsets.h>
+#include "voffset.h"
+
+#define VDSO_PRELINK 0xffffffffff700000
+
+SECTIONS
+{
+  . = VDSO_PRELINK + SIZEOF_HEADERS;
+
+  .hash           : { *(.hash) }		:text
+  .gnu.hash       : { *(.gnu.hash) }
+  .dynsym         : { *(.dynsym) }
+  .dynstr         : { *(.dynstr) }
+  .gnu.version    : { *(.gnu.version) }
+  .gnu.version_d  : { *(.gnu.version_d) }
+  .gnu.version_r  : { *(.gnu.version_r) }
+
+  /* This linker script is used both with -r and with -shared.
+     For the layouts to match, we need to skip more than enough
+     space for the dynamic symbol table et al.  If this amount
+     is insufficient, ld -shared will barf.  Just increase it here.  */
+  . = VDSO_PRELINK + VDSO_TEXT_OFFSET;
+
+  .text           : { *(.text) }		:text
+  .text.ptr       : { *(.text.ptr) }		:text
+  . = VDSO_PRELINK + 0x900;
+  .data           : { *(.data) }		:text
+  .bss            : { *(.bss) }			:text
+
+  .altinstructions : { *(.altinstructions) }			:text
+  .altinstr_replacement  : { *(.altinstr_replacement) }	:text
+
+  .note		  : { *(.note.*) }		:text :note
+  .eh_frame_hdr   : { *(.eh_frame_hdr) }	:text :eh_frame_hdr
+  .eh_frame       : { KEEP (*(.eh_frame)) }	:text
+  .dynamic        : { *(.dynamic) }		:text :dynamic
+  .useless        : {
+  	*(.got.plt) *(.got)
+	*(.gnu.linkonce.d.*)
+	*(.dynbss)
+	*(.gnu.linkonce.b.*)
+  }						:text
+}
+
+/*
+ * We must supply the ELF program headers explicitly to get just one
+ * PT_LOAD segment, and set the flags explicitly to make segments read-only.
+ */
+PHDRS
+{
+  text PT_LOAD FILEHDR PHDRS FLAGS(5); /* PF_R|PF_X */
+  dynamic PT_DYNAMIC FLAGS(4); /* PF_R */
+  note PT_NOTE FLAGS(4); /* PF_R */
+  eh_frame_hdr 0x6474e550; /* PT_GNU_EH_FRAME, but ld doesn't match the name */
+}
+
+/*
+ * This controls what symbols we export from the DSO.
+ */
+VERSION
+{
+  LINUX_2.6 {
+    global:
+	clock_gettime;
+	__vdso_clock_gettime;
+	gettimeofday;
+	__vdso_gettimeofday;
+	getcpu;
+	__vdso_getcpu;
+    local: *;
+  };
+}
Index: linux/arch/x86_64/vdso/Makefile
===================================================================
--- /dev/null
+++ linux/arch/x86_64/vdso/Makefile
@@ -0,0 +1,49 @@
+#
+# x86-64 vDSO.
+#
+
+# files to link into the vdso
+# vdso-start.o has to be first
+vobjs-y := vdso-start.o vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
+
+# files to link into kernel
+obj-y := vma.o vdso.o vdso-syms.o
+
+vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
+
+$(obj)/vdso.o: $(obj)/vdso.so
+
+targets += vdso.so vdso.lds $(vobjs-y) vdso-syms.o
+
+# The DSO images are built using a special linker script.
+quiet_cmd_syscall = SYSCALL $@
+      cmd_syscall = $(CC) -m elf_x86_64 -nostdlib $(SYSCFLAGS_$(@F)) \
+		          -Wl,-T,$(filter-out FORCE,$^) -o $@
+
+export CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
+
+vdso-flags = -fPIC -shared -Wl,-soname=linux-vdso.so.1 \
+		 $(call ld-option, -Wl$(comma)--hash-style=sysv) \
+		-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096
+SYSCFLAGS_vdso.so = $(vdso-flags)
+
+$(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
+
+$(obj)/vdso.so: $(src)/vdso.lds $(vobjs) FORCE
+	$(call if_changed,syscall)
+
+CF := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64
+
+$(obj)/vclock_gettime.o: CFLAGS = $(CF)
+$(obj)/vgetcpu.o: CFLAGS = $(CF)
+
+# We also create a special relocatable object that should mirror the symbol
+# table and layout of the linked DSO.  With ld -R we can then refer to
+# these symbols in the kernel code rather than hand-coded addresses.
+extra-y += vdso-syms.o
+$(obj)/built-in.o: $(obj)/vdso-syms.o
+$(obj)/built-in.o: ld_flags += -R $(obj)/vdso-syms.o
+
+SYSCFLAGS_vdso-syms.o = -r -d
+$(obj)/vdso-syms.o: $(src)/vdso.lds $(vobjs) FORCE
+	$(call if_changed,syscall)
Index: linux/arch/x86_64/vdso/vclock_gettime.c
===================================================================
--- /dev/null
+++ linux/arch/x86_64/vdso/vclock_gettime.c
@@ -0,0 +1,120 @@
+/*
+ * Copyright 2006 Andi Kleen, SUSE Labs.
+ * Subject to the GNU Public License, v.2
+ *
+ * Fast user context implementation of clock_gettime and gettimeofday.
+ *
+ * The code should have no internal unresolved relocations.
+ * Check with readelf after changing.
+ * Also alternative() doesn't work.
+ */
+
+#include <linux/kernel.h>
+#include <linux/posix-timers.h>
+#include <linux/time.h>
+#include <linux/string.h>
+#include <asm/vsyscall.h>
+#include <asm/vgtod.h>
+#include <asm/timex.h>
+#include <asm/hpet.h>
+#include <asm/unistd.h>
+#include <asm/io.h>
+#include <asm/vgtod.h>
+#include "vextern.h"
+
+#define gtod vdso_vsyscall_gtod_data
+
+static long vdso_fallback_gettime(long clock, struct timespec *ts)
+{
+	long ret;
+	asm("syscall" : "=a" (ret) :
+	    "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
+	return ret;
+}
+
+static inline long vgetns(void)
+{
+	cycles_t (*vread)(void);
+	vread = gtod->clock.vread;
+	return ((vread() - gtod->clock.cycle_last) * gtod->clock.mult) >>
+		gtod->clock.shift;
+}
+
+static noinline int do_realtime(struct timespec *ts)
+{
+	unsigned long seq, ns;
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		ts->tv_sec = gtod->wall_time_sec;
+		ts->tv_nsec = gtod->wall_time_nsec;
+		ns = vgetns();
+	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	timespec_add_ns(ts, ns);
+	return 0;
+}
+
+/* Copy of the version in kernel/time.c which we cannot directly access */
+static void vset_normalized_timespec(struct timespec *ts, long sec, long nsec)
+{
+	while (nsec >= NSEC_PER_SEC) {
+		nsec -= NSEC_PER_SEC;
+		++sec;
+	}
+	while (nsec < 0) {
+		nsec += NSEC_PER_SEC;
+		--sec;
+	}
+	ts->tv_sec = sec;
+	ts->tv_nsec = nsec;
+}
+
+static noinline int do_monotonic(struct timespec *ts)
+{
+	unsigned long seq, ns, secs;
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		secs = gtod->wall_time_sec;
+		ns = gtod->wall_time_nsec + vgetns();
+		secs += gtod->wall_to_monotonic.tv_sec;
+		ns += gtod->wall_to_monotonic.tv_nsec;
+	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	vset_normalized_timespec(ts, secs, ns);
+	return 0;
+}
+
+int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
+{
+	if (likely(gtod->sysctl_enabled && gtod->clock.vread))
+		switch (clock) {
+		case CLOCK_REALTIME:
+			return do_realtime(ts);
+		case CLOCK_MONOTONIC:
+			return do_monotonic(ts);
+		}
+	return vdso_fallback_gettime(clock, ts);
+}
+int clock_gettime(clockid_t, struct timespec *)
+	__attribute__((weak, alias("__vdso_clock_gettime")));
+
+int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
+{
+	long ret;
+	if (likely(gtod->sysctl_enabled && gtod->clock.vread)) {
+		BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
+			     offsetof(struct timespec, tv_nsec) ||
+			     sizeof(*tv) != sizeof(struct timespec));
+		do_realtime((struct timespec *)tv);
+		tv->tv_usec /= 1000;
+		if (unlikely(tz != NULL)) {
+			/* This relies on gcc inlining the memcpy. We'll notice
+			   if it ever fails to do so. */
+			memcpy(tz, &gtod->sys_tz, sizeof(struct timezone));
+		}
+		return 0;
+	}
+	asm("syscall" : "=a" (ret) :
+	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+	return ret;
+}
+int gettimeofday(struct timeval *, struct timezone *)
+	__attribute__((weak, alias("__vdso_gettimeofday")));
Index: linux/arch/x86_64/vdso/vma.c
===================================================================
--- /dev/null
+++ linux/arch/x86_64/vdso/vma.c
@@ -0,0 +1,139 @@
+/*
+ * Set up the VMAs to tell the VM about the vDSO.
+ * Copyright 2007 Andi Kleen, SUSE Labs.
+ * Subject to the GPL, v.2
+ */
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/random.h>
+#include <asm/vsyscall.h>
+#include <asm/vgtod.h>
+#include <asm/proto.h>
+#include "voffset.h"
+
+int vdso_enabled = 1;
+
+#define VEXTERN(x) extern typeof(__ ## x) *vdso_ ## x;
+#include "vextern.h"
+#undef VEXTERN
+
+extern char vdso_kernel_start[], vdso_start[], vdso_end[];
+extern unsigned short vdso_sync_cpuid;
+
+struct page **vdso_pages;
+
+static inline void *var_ref(void *vbase, char *var, char *name)
+{
+	unsigned offset = var - &vdso_kernel_start[0] + VDSO_TEXT_OFFSET;
+	void *p = vbase + offset;
+	if (*(void **)p != (void *)VMAGIC) {
+		printk("VDSO: variable %s broken\n", name);
+		vdso_enabled = 0;
+	}
+	return p;
+}
+
+static int __init init_vdso_vars(void)
+{
+	int npages = (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE;
+	int i;
+	char *vbase;
+
+	vdso_pages = kmalloc(sizeof(struct page *) * npages, GFP_KERNEL);
+	if (!vdso_pages)
+		goto oom;
+	for (i = 0; i < npages; i++) {
+		struct page *p;
+		p = alloc_page(GFP_KERNEL);
+		if (!p)
+			goto oom;
+		vdso_pages[i] = p;
+		copy_page(page_address(p), vdso_start + i*PAGE_SIZE);
+	}
+
+	vbase = vmap(vdso_pages, npages, 0, PAGE_KERNEL);
+	if (!vbase)
+		goto oom;
+
+	if (memcmp(vbase, "\177ELF", 4)) {
+		printk("VDSO: I'm broken; not ELF\n");
+		vdso_enabled = 0;
+	}
+
+#define V(x) *(typeof(x) *) var_ref(vbase, (char *)RELOC_HIDE(&x, 0), #x)
+#define VEXTERN(x) \
+	V(vdso_ ## x) = &__ ## x;
+#include "vextern.h"
+#undef VEXTERN
+	return 0;
+
+ oom:
+	printk("Cannot allocate vdso\n");
+	vdso_enabled = 0;
+	return -ENOMEM;
+}
+__initcall(init_vdso_vars);
+
+struct linux_binprm;
+
+/* Put the vdso above the (randomized) stack with another randomized offset.
+   This way there is no hole in the middle of address space.
+   To save memory make sure it is still in the same PTE as the stack top.
+   This doesn't give that many random bits */
+static unsigned long vdso_addr(unsigned long start, unsigned len)
+{
+	unsigned long addr, end;
+	unsigned offset;
+	end = (start + PMD_SIZE - 1) & PMD_MASK;
+	if (end >= TASK_SIZE64)
+		end = TASK_SIZE64;
+	end -= len;
+	/* This loses some more bits than a modulo, but is cheaper */
+	offset = get_random_int() & (PTRS_PER_PTE - 1);
+	addr = start + (offset << PAGE_SHIFT);
+	if (addr >= end)
+		addr = end;
+	return addr;
+}
+
+/* Setup a VMA at program startup for the vsyscall page.
+   Not called for compat tasks */
+int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long addr;
+	int ret;
+	unsigned len = round_up(vdso_end - vdso_start, PAGE_SIZE);
+
+	if (!vdso_enabled)
+		return 0;
+
+	down_write(&mm->mmap_sem);
+	addr = vdso_addr(mm->start_stack, len);
+	addr = get_unmapped_area(NULL, addr, len, 0, 0);
+	if (IS_ERR_VALUE(addr)) {
+		ret = addr;
+		goto up_fail;
+	}
+
+	ret = install_special_mapping(mm, addr, len,
+				      VM_READ|VM_EXEC|
+				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
+				      VM_ALWAYSDUMP,
+				      vdso_pages);
+	if (ret)
+		goto up_fail;
+
+	current->mm->context.vdso = (void *)addr;
+up_fail:
+	up_write(&mm->mmap_sem);
+	return ret;
+}
+
+static __init int vdso_setup(char *s)
+{
+	vdso_enabled = simple_strtoul(s, NULL, 0);
+	return 0;
+}
+__setup("vdso=", vdso_setup);
Index: linux/arch/x86_64/vdso/vdso.S
===================================================================
--- /dev/null
+++ linux/arch/x86_64/vdso/vdso.S
@@ -0,0 +1,2 @@
+	.section ".vdso","a"
+	.incbin "arch/x86_64/vdso/vdso.so"
Index: linux/arch/x86_64/vdso/vdso-start.S
===================================================================
--- /dev/null
+++ linux/arch/x86_64/vdso/vdso-start.S
@@ -0,0 +1,2 @@
+	.globl vdso_kernel_start
+vdso_kernel_start:
Index: linux/arch/x86_64/Makefile
===================================================================
--- linux.orig/arch/x86_64/Makefile
+++ linux/arch/x86_64/Makefile
@@ -79,7 +79,8 @@ head-y := arch/x86_64/kernel/head.o arch
 libs-y 					+= arch/x86_64/lib/
 core-y					+= arch/x86_64/kernel/ \
 					   arch/x86_64/mm/ \
-					   arch/x86_64/crypto/
+					   arch/x86_64/crypto/ \
+					   arch/x86_64/vdso/
 core-$(CONFIG_IA32_EMULATION)		+= arch/x86_64/ia32/
 drivers-$(CONFIG_PCI)			+= arch/x86_64/pci/
 drivers-$(CONFIG_OPROFILE)		+= arch/x86_64/oprofile/
Index: linux/include/asm-x86_64/mmu.h
===================================================================
--- linux.orig/include/asm-x86_64/mmu.h
+++ linux/include/asm-x86_64/mmu.h
@@ -15,6 +15,7 @@ typedef struct { 
 	rwlock_t ldtlock; 
 	int size;
 	struct semaphore sem; 
+	void *vdso;
 } mm_context_t;
 
 #endif
Index: linux/include/asm-x86_64/vsyscall.h
===================================================================
--- linux.orig/include/asm-x86_64/vsyscall.h
+++ linux/include/asm-x86_64/vsyscall.h
@@ -22,6 +22,8 @@ enum vsyscall_num {
 /* Definitions for CONFIG_GENERIC_TIME definitions */
 #define __section_vsyscall_gtod_data __attribute__ \
 	((unused, __section__ (".vsyscall_gtod_data"),aligned(16)))
+#define __section_vsyscall_clock __attribute__ \
+	((unused, __section__ (".vsyscall_clock"),aligned(16)))
 #define __vsyscall_fn __attribute__ ((unused,__section__(".vsyscall_fn")))
 
 #define VGETCPU_RDTSCP	1
@@ -36,7 +38,6 @@ extern volatile unsigned long __jiffies;
 /* kernel space (writeable) */
 extern int vgetcpu_mode;
 extern struct timezone sys_tz;
-extern struct vsyscall_gtod_data_t vsyscall_gtod_data;
 
 #endif /* __KERNEL__ */
 
Index: linux/include/asm-x86_64/auxvec.h
===================================================================
--- linux.orig/include/asm-x86_64/auxvec.h
+++ linux/include/asm-x86_64/auxvec.h
@@ -1,4 +1,6 @@
 #ifndef __ASM_X86_64_AUXVEC_H
 #define __ASM_X86_64_AUXVEC_H
 
+#define AT_SYSINFO_EHDR		33
+
 #endif
Index: linux/include/asm-x86_64/elf.h
===================================================================
--- linux.orig/include/asm-x86_64/elf.h
+++ linux/include/asm-x86_64/elf.h
@@ -162,6 +162,19 @@ extern int dump_task_fpu (struct task_st
 /* 1GB for 64bit, 8MB for 32bit */
 #define STACK_RND_MASK (test_thread_flag(TIF_IA32) ? 0x7ff : 0x3fffff)
 
+
+#define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
+struct linux_binprm;
+extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+                                       int executable_stack);
+
+extern int vdso_enabled;
+
+#define ARCH_DLINFO						\
+do if (vdso_enabled) {						\
+	NEW_AUX_ENT(AT_SYSINFO_EHDR,(unsigned long)current->mm->context.vdso);\
+} while (0)
+
 #endif
 
 #endif
Index: linux/arch/x86_64/vdso/vextern.h
===================================================================
--- /dev/null
+++ linux/arch/x86_64/vdso/vextern.h
@@ -0,0 +1,16 @@
+#ifndef VEXTERN
+#include <asm/vsyscall.h>
+#define VEXTERN(x) \
+	extern typeof(x) *vdso_ ## x __attribute__((visibility("hidden")));
+#endif
+
+#define VMAGIC 0xfeedbabeabcdefabUL
+
+/* Any kernel variables used in the vDSO must be exported in the main
+   kernel's vmlinux.lds.S/vsyscall.h/proper __section and
+   put into vextern.h and be referenced as a pointer with vdso prefix.
+   The main kernel later fills in the values.   */
+
+VEXTERN(jiffies)
+VEXTERN(vgetcpu_mode)
+VEXTERN(vsyscall_gtod_data)
Index: linux/arch/x86_64/vdso/vgetcpu.c
===================================================================
--- /dev/null
+++ linux/arch/x86_64/vdso/vgetcpu.c
@@ -0,0 +1,50 @@
+/*
+ * Copyright 2006 Andi Kleen, SUSE Labs.
+ * Subject to the GNU Public License, v.2
+ *
+ * Fast user context implementation of getcpu()
+ */
+
+#include <linux/kernel.h>
+#include <linux/getcpu.h>
+#include <linux/jiffies.h>
+#include <linux/time.h>
+#include <asm/vsyscall.h>
+#include <asm/vgtod.h>
+#include "vextern.h"
+
+long __vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
+{
+	unsigned int dummy, p;
+	unsigned long j = 0;
+
+	/* Fast cache - only recompute value once per jiffies and avoid
+	   relatively costly rdtscp/cpuid otherwise.
+	   This works because the scheduler usually keeps the process
+	   on the same CPU and this syscall doesn't guarantee its
+	   results anyways.
+	   We do this here because otherwise user space would do it on
+	   its own in a likely inferior way (no access to jiffies).
+	   If you don't like it pass NULL. */
+	if (tcache && tcache->blob[0] == (j = *vdso_jiffies)) {
+		p = tcache->blob[1];
+	} else if (*vdso_vgetcpu_mode == VGETCPU_RDTSCP) {
+		/* Load per CPU data from RDTSCP */
+		rdtscp(dummy, dummy, p);
+	} else {
+		/* Load per CPU data from GDT */
+		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
+	}
+	if (tcache) {
+		tcache->blob[0] = j;
+		tcache->blob[1] = p;
+	}
+	if (cpu)
+		*cpu = p & 0xfff;
+	if (node)
+		*node = p >> 12;
+	return 0;
+}
+
+long getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
+	__attribute__((weak, alias("__vdso_getcpu")));
Index: linux/arch/x86_64/vdso/vvar.c
===================================================================
--- /dev/null
+++ linux/arch/x86_64/vdso/vvar.c
@@ -0,0 +1,12 @@
+/* Define pointer to external vDSO variables.
+   These are part of the vDSO. The kernel fills in the real addresses
+   at boot time. This is done because when the vdso is linked the
+   kernel isn't yet and we don't know the final addresses. */
+#include <linux/kernel.h>
+#include <linux/time.h>
+#include <asm/vsyscall.h>
+#include <asm/timex.h>
+#include <asm/vgtod.h>
+
+#define VEXTERN(x) typeof (__ ## x) *vdso_ ## x = (void *)VMAGIC;
+#include "vextern.h"
Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -1880,7 +1880,7 @@ and is between 256 and 4096 characters. 
 	usbhid.mousepoll=
 			[USBHID] The interval which mice are to be polled at.
 
-	vdso=		[IA-32,SH]
+	vdso=		[IA-32,SH,x86-64]
 			vdso=2: enable compat VDSO (default with COMPAT_VDSO)
 			vdso=1: enable VDSO (default)
 			vdso=0: disable VDSO mapping
Index: linux/arch/x86_64/kernel/vsyscall.c
===================================================================
--- linux.orig/arch/x86_64/kernel/vsyscall.c
+++ linux/arch/x86_64/kernel/vsyscall.c
@@ -42,6 +42,7 @@
 #include <asm/segment.h>
 #include <asm/desc.h>
 #include <asm/topology.h>
+#include <asm/vgtod.h>
 
 #define __vsyscall(nr) __attribute__ ((unused,__section__(".vsyscall_" #nr)))
 #define __syscall_clobber "r11","rcx","memory"
@@ -57,26 +58,9 @@
  * - writen by timer interrupt or systcl (/proc/sys/kernel/vsyscall64)
  * Try to keep this structure as small as possible to avoid cache line ping pongs
  */
-struct vsyscall_gtod_data_t {
-	seqlock_t	lock;
-
-	/* open coded 'struct timespec' */
-	time_t		wall_time_sec;
-	u32		wall_time_nsec;
-
-	int		sysctl_enabled;
-	struct timezone sys_tz;
-	struct { /* extract of a clocksource struct */
-		cycle_t (*vread)(void);
-		cycle_t	cycle_last;
-		cycle_t	mask;
-		u32	mult;
-		u32	shift;
-	} clock;
-};
 int __vgetcpu_mode __section_vgetcpu_mode;
 
-struct vsyscall_gtod_data_t __vsyscall_gtod_data __section_vsyscall_gtod_data =
+struct vsyscall_gtod_data __vsyscall_gtod_data __section_vsyscall_gtod_data =
 {
 	.lock = SEQLOCK_UNLOCKED,
 	.sysctl_enabled = 1,
@@ -96,6 +80,8 @@ void update_vsyscall(struct timespec *wa
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.sys_tz = sys_tz;
+	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
+	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
Index: linux/arch/x86_64/kernel/time.c
===================================================================
--- linux.orig/arch/x86_64/kernel/time.c
+++ linux/arch/x86_64/kernel/time.c
@@ -44,6 +44,7 @@
 #include <asm/hpet.h>
 #include <asm/mpspec.h>
 #include <asm/nmi.h>
+#include <asm/vgtod.h>
 
 static char *timename = NULL;
 
Index: linux/include/asm-x86_64/vgtod.h
===================================================================
--- /dev/null
+++ linux/include/asm-x86_64/vgtod.h
@@ -0,0 +1,29 @@
+#ifndef _ASM_VGTOD_H
+#define _ASM_VGTOD_H 1
+
+#include <asm/vsyscall.h>
+#include <linux/clocksource.h>
+
+struct vsyscall_gtod_data {
+	seqlock_t	lock;
+
+	/* open coded 'struct timespec' */
+	time_t		wall_time_sec;
+	u32		wall_time_nsec;
+
+	int		sysctl_enabled;
+	struct timezone sys_tz;
+	struct { /* extract of a clocksource struct */
+		cycle_t (*vread)(void);
+		cycle_t	cycle_last;
+		cycle_t	mask;
+		u32	mult;
+		u32	shift;
+	} clock;
+	struct timespec wall_to_monotonic;
+};
+extern struct vsyscall_gtod_data __vsyscall_gtod_data
+__section_vsyscall_gtod_data;
+extern struct vsyscall_gtod_data vsyscall_gtod_data;
+
+#endif
Index: linux/arch/x86_64/vdso/voffset.h
===================================================================
--- /dev/null
+++ linux/arch/x86_64/vdso/voffset.h
@@ -0,0 +1 @@
+#define VDSO_TEXT_OFFSET 0x500

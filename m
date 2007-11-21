Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbXKUKZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbXKUKZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbXKUKZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:25:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbXKUKZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:25:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 5/5] x86: TLS cleanup
In-Reply-To: Roland McGrath's message of  Wednesday, 21 November 2007 02:19:28 -0800 <20071121101928.A08CF26F8BE@magilla.localdomain>
References: <20071121101928.A08CF26F8BE@magilla.localdomain>
X-Shopping-List: (1) Ridiculous sugar
   (2) Wax & Wear Rendezvous
   (3) Ecclesiastical rectums
   (4) Self-propelled gold
Message-Id: <20071121102511.08B8A26F8BE@magilla.localdomain>
Date: Wed, 21 Nov 2007 02:25:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This consolidates the four different places that implemented the same
encoding magic for the GDT-slot 32-bit TLS support.  The old tls32.c is
renamed and only slightly modified to be the shared implementation guts.

Signed-off-by: Roland McGrath <roland@redhat.com>

diff --git a/arch/x86/ia32/Makefile b/arch/x86/ia32/Makefile
index e2edda2..3c8b746 100644
--- a/arch/x86/ia32/Makefile
+++ b/arch/x86/ia32/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the ia32 kernel emulation subsystem.
 #
 
-obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o tls32.o \
+obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o \
 	ia32_binfmt.o fpu32.o ptrace32.o syscall32.o syscall32_syscall.o \
 	mmap32.o
 
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index df588f0..0a71fa9 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -644,8 +644,8 @@ ia32_sys_call_table:
 	.quad compat_sys_futex		/* 240 */
 	.quad compat_sys_sched_setaffinity
 	.quad compat_sys_sched_getaffinity
-	.quad sys32_set_thread_area
-	.quad sys32_get_thread_area
+	.quad sys_set_thread_area
+	.quad sys_get_thread_area
 	.quad compat_sys_io_setup	/* 245 */
 	.quad sys_io_destroy
 	.quad compat_sys_io_getevents
diff --git a/arch/x86/ia32/tls32.c b/arch/x86/ia32/tls32.c
deleted file mode 100644
index 5291596..0000000
--- a/arch/x86/ia32/tls32.c
+++ /dev/null
@@ -1,158 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/user.h>
-
-#include <asm/uaccess.h>
-#include <asm/desc.h>
-#include <asm/system.h>
-#include <asm/ldt.h>
-#include <asm/processor.h>
-#include <asm/proto.h>
-
-/*
- * sys_alloc_thread_area: get a yet unused TLS descriptor index.
- */
-static int get_free_idx(void)
-{
-	struct thread_struct *t = &current->thread;
-	int idx;
-
-	for (idx = 0; idx < GDT_ENTRY_TLS_ENTRIES; idx++)
-		if (desc_empty((struct n_desc_struct *)(t->tls_array) + idx))
-			return idx + GDT_ENTRY_TLS_MIN;
-	return -ESRCH;
-}
-
-/*
- * Set a given TLS descriptor:
- * When you want addresses > 32bit use arch_prctl()
- */
-int do_set_thread_area(struct thread_struct *t, struct user_desc __user *u_info)
-{
-	struct user_desc info;
-	struct n_desc_struct *desc;
-	int cpu, idx;
-
-	if (copy_from_user(&info, u_info, sizeof(info)))
-		return -EFAULT;
-
-	idx = info.entry_number;
-
-	/*
-	 * index -1 means the kernel should try to find and
-	 * allocate an empty descriptor:
-	 */
-	if (idx == -1) {
-		idx = get_free_idx();
-		if (idx < 0)
-			return idx;
-		if (put_user(idx, &u_info->entry_number))
-			return -EFAULT;
-	}
-
-	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
-		return -EINVAL;
-
-	desc = ((struct n_desc_struct *)t->tls_array) + idx - GDT_ENTRY_TLS_MIN;
-
-	/*
-	 * We must not get preempted while modifying the TLS.
-	 */
-	cpu = get_cpu();
-
-	if (LDT_empty(&info)) {
-		desc->a = 0;
-		desc->b = 0;
-	} else {
-		desc->a = LDT_entry_a(&info);
-		desc->b = LDT_entry_b(&info);
-	}
-	if (t == &current->thread)
-		load_TLS(t, cpu);
-
-	put_cpu();
-	return 0;
-}
-
-asmlinkage long sys32_set_thread_area(struct user_desc __user *u_info)
-{
-	return do_set_thread_area(&current->thread, u_info);
-}
-
-
-/*
- * Get the current Thread-Local Storage area:
- */
-
-#define GET_LIMIT(desc) ( \
-	((desc)->a & 0x0ffff) | \
-	 ((desc)->b & 0xf0000) )
-
-#define GET_32BIT(desc)		(((desc)->b >> 22) & 1)
-#define GET_CONTENTS(desc)	(((desc)->b >> 10) & 3)
-#define GET_WRITABLE(desc)	(((desc)->b >>  9) & 1)
-#define GET_LIMIT_PAGES(desc)	(((desc)->b >> 23) & 1)
-#define GET_PRESENT(desc)	(((desc)->b >> 15) & 1)
-#define GET_USEABLE(desc)	(((desc)->b >> 20) & 1)
-#define GET_LONGMODE(desc)	(((desc)->b >> 21) & 1)
-
-int do_get_thread_area(struct thread_struct *t, struct user_desc __user *u_info)
-{
-	struct user_desc info;
-	struct n_desc_struct *desc;
-	int idx;
-
-	if (get_user(idx, &u_info->entry_number))
-		return -EFAULT;
-	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
-		return -EINVAL;
-
-	desc = ((struct n_desc_struct *)t->tls_array) + idx - GDT_ENTRY_TLS_MIN;
-
-	memset(&info, 0, sizeof(struct user_desc));
-	info.entry_number = idx;
-	info.base_addr = get_desc_base(desc);
-	info.limit = GET_LIMIT(desc);
-	info.seg_32bit = GET_32BIT(desc);
-	info.contents = GET_CONTENTS(desc);
-	info.read_exec_only = !GET_WRITABLE(desc);
-	info.limit_in_pages = GET_LIMIT_PAGES(desc);
-	info.seg_not_present = !GET_PRESENT(desc);
-	info.useable = GET_USEABLE(desc);
-	info.lm = GET_LONGMODE(desc);
-
-	if (copy_to_user(u_info, &info, sizeof(info)))
-		return -EFAULT;
-	return 0;
-}
-
-asmlinkage long sys32_get_thread_area(struct user_desc __user *u_info)
-{
-	return do_get_thread_area(&current->thread, u_info);
-}
-
-
-int ia32_child_tls(struct task_struct *p, struct pt_regs *childregs)
-{
-	struct n_desc_struct *desc;
-	struct user_desc info;
-	struct user_desc __user *cp;
-	int idx;
-
-	cp = (void __user *)childregs->rsi;
-	if (copy_from_user(&info, cp, sizeof(info)))
-		return -EFAULT;
-	if (LDT_empty(&info))
-		return -EINVAL;
-
-	idx = info.entry_number;
-	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
-		return -EINVAL;
-
-	desc = (struct n_desc_struct *)(p->thread.tls_array) + idx - GDT_ENTRY_TLS_MIN;
-	desc->a = LDT_entry_a(&info);
-	desc->b = LDT_entry_b(&info);
-
-	return 0;
-}
diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index a7bc93c..e660584 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -10,6 +10,7 @@ obj-y	:= process_32.o signal_32.o entry_32.o traps_32.o irq_32.o \
 		pci-dma_32.o i386_ksyms_32.o i387_32.o bootflag.o e820_32.o\
 		quirks.o i8237.o topology.o alternative.o i8253.o tsc_32.o
 
+obj-y				+= tls.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index 5a88890..203a9d8 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -13,6 +13,8 @@ obj-y	:= process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
 		pci-dma_64.o pci-nommu_64.o alternative.o hpet.o tsc_64.o bugs_64.o \
 		i8253.o
 
+obj-$(CONFIG_IA32_EMULATION)	+= tls.o
+
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7b89958..1521e6f 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -55,6 +55,7 @@
 
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
+#include <asm/proto.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -480,33 +481,16 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long esp,
 		set_tsk_thread_flag(p, TIF_IO_BITMAP);
 	}
 
+	err = 0;
+
 	/*
 	 * Set a new TLS for the child thread?
 	 */
-	if (clone_flags & CLONE_SETTLS) {
-		struct desc_struct *desc;
-		struct user_desc info;
-		int idx;
-
-		err = -EFAULT;
-		if (copy_from_user(&info, (void __user *)childregs->esi, sizeof(info)))
-			goto out;
-		err = -EINVAL;
-		if (LDT_empty(&info))
-			goto out;
-
-		idx = info.entry_number;
-		if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
-			goto out;
-
-		desc = p->thread.tls_array + idx - GDT_ENTRY_TLS_MIN;
-		desc->a = LDT_entry_a(&info);
-		desc->b = LDT_entry_b(&info);
-	}
+	if (clone_flags & CLONE_SETTLS)
+		err = do_set_thread_area(p, -1,
+			(struct user_desc __user *)childregs->esi, 0);
 
-	err = 0;
- out:
-	if (err && p->thread.io_bitmap_ptr) {
+ 	if (err && p->thread.io_bitmap_ptr) {
 		kfree(p->thread.io_bitmap_ptr);
 		p->thread.io_bitmap_max = 0;
 	}
@@ -851,120 +835,6 @@ unsigned long get_wchan(struct task_struct *p)
 	return 0;
 }
 
-/*
- * sys_alloc_thread_area: get a yet unused TLS descriptor index.
- */
-static int get_free_idx(void)
-{
-	struct thread_struct *t = &current->thread;
-	int idx;
-
-	for (idx = 0; idx < GDT_ENTRY_TLS_ENTRIES; idx++)
-		if (desc_empty(t->tls_array + idx))
-			return idx + GDT_ENTRY_TLS_MIN;
-	return -ESRCH;
-}
-
-/*
- * Set a given TLS descriptor:
- */
-asmlinkage int sys_set_thread_area(struct user_desc __user *u_info)
-{
-	struct thread_struct *t = &current->thread;
-	struct user_desc info;
-	struct desc_struct *desc;
-	int cpu, idx;
-
-	if (copy_from_user(&info, u_info, sizeof(info)))
-		return -EFAULT;
-	idx = info.entry_number;
-
-	/*
-	 * index -1 means the kernel should try to find and
-	 * allocate an empty descriptor:
-	 */
-	if (idx == -1) {
-		idx = get_free_idx();
-		if (idx < 0)
-			return idx;
-		if (put_user(idx, &u_info->entry_number))
-			return -EFAULT;
-	}
-
-	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
-		return -EINVAL;
-
-	desc = t->tls_array + idx - GDT_ENTRY_TLS_MIN;
-
-	/*
-	 * We must not get preempted while modifying the TLS.
-	 */
-	cpu = get_cpu();
-
-	if (LDT_empty(&info)) {
-		desc->a = 0;
-		desc->b = 0;
-	} else {
-		desc->a = LDT_entry_a(&info);
-		desc->b = LDT_entry_b(&info);
-	}
-	load_TLS(t, cpu);
-
-	put_cpu();
-
-	return 0;
-}
-
-/*
- * Get the current Thread-Local Storage area:
- */
-
-#define GET_BASE(desc) ( \
-	(((desc)->a >> 16) & 0x0000ffff) | \
-	(((desc)->b << 16) & 0x00ff0000) | \
-	( (desc)->b        & 0xff000000)   )
-
-#define GET_LIMIT(desc) ( \
-	((desc)->a & 0x0ffff) | \
-	 ((desc)->b & 0xf0000) )
-	
-#define GET_32BIT(desc)		(((desc)->b >> 22) & 1)
-#define GET_CONTENTS(desc)	(((desc)->b >> 10) & 3)
-#define GET_WRITABLE(desc)	(((desc)->b >>  9) & 1)
-#define GET_LIMIT_PAGES(desc)	(((desc)->b >> 23) & 1)
-#define GET_PRESENT(desc)	(((desc)->b >> 15) & 1)
-#define GET_USEABLE(desc)	(((desc)->b >> 20) & 1)
-
-asmlinkage int sys_get_thread_area(struct user_desc __user *u_info)
-{
-	struct user_desc info;
-	struct desc_struct *desc;
-	int idx;
-
-	if (get_user(idx, &u_info->entry_number))
-		return -EFAULT;
-	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
-		return -EINVAL;
-
-	memset(&info, 0, sizeof(info));
-
-	desc = current->thread.tls_array + idx - GDT_ENTRY_TLS_MIN;
-
-	info.entry_number = idx;
-	info.base_addr = GET_BASE(desc);
-	info.limit = GET_LIMIT(desc);
-	info.seg_32bit = GET_32BIT(desc);
-	info.contents = GET_CONTENTS(desc);
-	info.read_exec_only = !GET_WRITABLE(desc);
-	info.limit_in_pages = GET_LIMIT_PAGES(desc);
-	info.seg_not_present = !GET_PRESENT(desc);
-	info.useable = GET_USEABLE(desc);
-
-	if (copy_to_user(u_info, &info, sizeof(info)))
-		return -EFAULT;
-	return 0;
-}
-
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b8d131d..3fdbf78 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -513,7 +513,8 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long rsp,
 	if (clone_flags & CLONE_SETTLS) {
 #ifdef CONFIG_IA32_EMULATION
 		if (test_thread_flag(TIF_IA32))
-			err = ia32_child_tls(p, childregs);
+			err = do_set_thread_area(p, -1,
+				(struct user_desc __user *)childregs->rsi, 0);
 		else
 #endif
 			err = do_arch_prctl(p, ARCH_SET_FS, childregs->r8);
diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index ff5431c..dd2e18b 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -24,6 +24,7 @@
 #include <asm/debugreg.h>
 #include <asm/ldt.h>
 #include <asm/desc.h>
+#include <asm/proto.h>
 
 /*
  * does not yet catch signals sent when the child dies.
@@ -276,85 +277,6 @@ void ptrace_disable(struct task_struct *child)
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 }
 
-/*
- * Perform get_thread_area on behalf of the traced child.
- */
-static int
-ptrace_get_thread_area(struct task_struct *child,
-		       int idx, struct user_desc __user *user_desc)
-{
-	struct user_desc info;
-	struct desc_struct *desc;
-
-/*
- * Get the current Thread-Local Storage area:
- */
-
-#define GET_BASE(desc) ( \
-	(((desc)->a >> 16) & 0x0000ffff) | \
-	(((desc)->b << 16) & 0x00ff0000) | \
-	( (desc)->b        & 0xff000000)   )
-
-#define GET_LIMIT(desc) ( \
-	((desc)->a & 0x0ffff) | \
-	 ((desc)->b & 0xf0000) )
-
-#define GET_32BIT(desc)		(((desc)->b >> 22) & 1)
-#define GET_CONTENTS(desc)	(((desc)->b >> 10) & 3)
-#define GET_WRITABLE(desc)	(((desc)->b >>  9) & 1)
-#define GET_LIMIT_PAGES(desc)	(((desc)->b >> 23) & 1)
-#define GET_PRESENT(desc)	(((desc)->b >> 15) & 1)
-#define GET_USEABLE(desc)	(((desc)->b >> 20) & 1)
-
-	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
-		return -EINVAL;
-
-	desc = child->thread.tls_array + idx - GDT_ENTRY_TLS_MIN;
-
-	info.entry_number = idx;
-	info.base_addr = GET_BASE(desc);
-	info.limit = GET_LIMIT(desc);
-	info.seg_32bit = GET_32BIT(desc);
-	info.contents = GET_CONTENTS(desc);
-	info.read_exec_only = !GET_WRITABLE(desc);
-	info.limit_in_pages = GET_LIMIT_PAGES(desc);
-	info.seg_not_present = !GET_PRESENT(desc);
-	info.useable = GET_USEABLE(desc);
-
-	if (copy_to_user(user_desc, &info, sizeof(info)))
-		return -EFAULT;
-
-	return 0;
-}
-
-/*
- * Perform set_thread_area on behalf of the traced child.
- */
-static int
-ptrace_set_thread_area(struct task_struct *child,
-		       int idx, struct user_desc __user *user_desc)
-{
-	struct user_desc info;
-	struct desc_struct *desc;
-
-	if (copy_from_user(&info, user_desc, sizeof(info)))
-		return -EFAULT;
-
-	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
-		return -EINVAL;
-
-	desc = child->thread.tls_array + idx - GDT_ENTRY_TLS_MIN;
-	if (LDT_empty(&info)) {
-		desc->a = 0;
-		desc->b = 0;
-	} else {
-		desc->a = LDT_entry_a(&info);
-		desc->b = LDT_entry_b(&info);
-	}
-
-	return 0;
-}
-
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
 	struct user * dummy = NULL;
@@ -601,13 +523,17 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	}
 
 	case PTRACE_GET_THREAD_AREA:
-		ret = ptrace_get_thread_area(child, addr,
-					(struct user_desc __user *) data);
+		if (addr < 0)
+			return -EIO;
+		ret = do_get_thread_area(child, addr,
+					 (struct user_desc __user *) data);
 		break;
 
 	case PTRACE_SET_THREAD_AREA:
-		ret = ptrace_set_thread_area(child, addr,
-					(struct user_desc __user *) data);
+		if (addr < 0)
+			return -EIO;
+		ret = do_set_thread_area(child, addr,
+					 (struct user_desc __user *) data, 0);
 		break;
 
 	default:
diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index 3ff7ddc..07de75d 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -474,23 +474,19 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		   64bit debugger to fully examine them too. Better
 		   don't use it against 64bit processes, use
 		   PTRACE_ARCH_PRCTL instead. */
-	case PTRACE_SET_THREAD_AREA: {
-		struct user_desc __user *p;
-		int old;
-		p = (struct user_desc __user *)data;
-		get_user(old,  &p->entry_number);
-		put_user(addr, &p->entry_number);
-		ret = do_set_thread_area(&child->thread, p);
-		put_user(old,  &p->entry_number);
-		break;
 	case PTRACE_GET_THREAD_AREA:
-		p = (struct user_desc __user *)data;
-		get_user(old,  &p->entry_number);
-		put_user(addr, &p->entry_number);
-		ret = do_get_thread_area(&child->thread, p);
-		put_user(old,  &p->entry_number);
+		if (addr < 0)
+			return -EIO;
+		ret = do_get_thread_area(child, addr,
+					 (struct user_desc __user *) data);
+
+		break;
+	case PTRACE_SET_THREAD_AREA:
+		if (addr < 0)
+			return -EIO;
+		ret = do_set_thread_area(child, addr,
+					 (struct user_desc __user *) data, 0);
 		break;
-	}
 #endif
 		/* normal 64bit interface to access TLS data.
 		   Works just like arch_prctl, except that the arguments
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
new file mode 100644
index 0000000..0a1a744
--- /dev/null
+++ b/arch/x86/kernel/tls.c
@@ -0,0 +1,139 @@
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/user.h>
+
+#include <asm/uaccess.h>
+#include <asm/desc.h>
+#include <asm/system.h>
+#include <asm/ldt.h>
+#include <asm/processor.h>
+#include <asm/proto.h>
+
+/*
+ * sys_alloc_thread_area: get a yet unused TLS descriptor index.
+ */
+static int get_free_idx(void)
+{
+	struct thread_struct *t = &current->thread;
+	int idx;
+
+	for (idx = 0; idx < GDT_ENTRY_TLS_ENTRIES; idx++)
+		if (desc_empty(&t->tls_array[idx]))
+			return idx + GDT_ENTRY_TLS_MIN;
+	return -ESRCH;
+}
+
+/*
+ * Set a given TLS descriptor:
+ */
+int do_set_thread_area(struct task_struct *p, int idx,
+		       struct user_desc __user *u_info,
+		       int can_allocate)
+{
+	struct thread_struct *t = &p->thread;
+	struct user_desc info;
+	u32 *desc;
+	int cpu;
+
+	if (copy_from_user(&info, u_info, sizeof(info)))
+		return -EFAULT;
+
+	if (idx == -1)
+		idx = info.entry_number;
+
+	/*
+	 * index -1 means the kernel should try to find and
+	 * allocate an empty descriptor:
+	 */
+	if (idx == -1 && can_allocate) {
+		idx = get_free_idx();
+		if (idx < 0)
+			return idx;
+		if (put_user(idx, &u_info->entry_number))
+			return -EFAULT;
+	}
+
+	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
+		return -EINVAL;
+
+	desc = (u32 *) &t->tls_array[idx - GDT_ENTRY_TLS_MIN];
+
+	/*
+	 * We must not get preempted while modifying the TLS.
+	 */
+	cpu = get_cpu();
+
+	if (LDT_empty(&info)) {
+		desc[0] = 0;
+		desc[1] = 0;
+	} else {
+		desc[0] = LDT_entry_a(&info);
+		desc[1] = LDT_entry_b(&info);
+	}
+	if (t == &current->thread)
+		load_TLS(t, cpu);
+
+	put_cpu();
+	return 0;
+}
+
+asmlinkage int sys_set_thread_area(struct user_desc __user *u_info)
+{
+	return do_set_thread_area(current, -1, u_info, 1);
+}
+
+
+/*
+ * Get the current Thread-Local Storage area:
+ */
+
+#define GET_LIMIT(desc) ( \
+	((desc)[0] & 0x0ffff) | \
+	 ((desc)[1] & 0xf0000) )
+
+#define GET_32BIT(desc)		(((desc)[1] >> 22) & 1)
+#define GET_CONTENTS(desc)	(((desc)[1] >> 10) & 3)
+#define GET_WRITABLE(desc)	(((desc)[1] >>  9) & 1)
+#define GET_LIMIT_PAGES(desc)	(((desc)[1] >> 23) & 1)
+#define GET_PRESENT(desc)	(((desc)[1] >> 15) & 1)
+#define GET_USEABLE(desc)	(((desc)[1] >> 20) & 1)
+#define GET_LONGMODE(desc)	(((desc)[1] >> 21) & 1)
+
+int do_get_thread_area(struct task_struct *p, int idx,
+		       struct user_desc __user *u_info)
+{
+	struct thread_struct *t = &p->thread;
+	struct user_desc info;
+	u32 *desc;
+
+	if (idx == -1 && get_user(idx, &u_info->entry_number))
+		return -EFAULT;
+	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
+		return -EINVAL;
+
+	desc = (u32 *) &t->tls_array[idx - GDT_ENTRY_TLS_MIN];
+
+	memset(&info, 0, sizeof(struct user_desc));
+	info.entry_number = idx;
+	info.base_addr = get_desc_base((void *)desc);
+	info.limit = GET_LIMIT(desc);
+	info.seg_32bit = GET_32BIT(desc);
+	info.contents = GET_CONTENTS(desc);
+	info.read_exec_only = !GET_WRITABLE(desc);
+	info.limit_in_pages = GET_LIMIT_PAGES(desc);
+	info.seg_not_present = !GET_PRESENT(desc);
+	info.useable = GET_USEABLE(desc);
+#ifdef CONFIG_X86_64
+	info.lm = GET_LONGMODE(desc);
+#endif
+
+	if (copy_to_user(u_info, &info, sizeof(info)))
+		return -EFAULT;
+	return 0;
+}
+
+asmlinkage int sys_get_thread_area(struct user_desc __user *u_info)
+{
+	return do_get_thread_area(current, -1, u_info);
+}
diff --git a/include/asm-x86/ia32.h b/include/asm-x86/ia32.h
index 0190b7c..363633b 100644
--- a/include/asm-x86/ia32.h
+++ b/include/asm-x86/ia32.h
@@ -159,12 +159,6 @@ struct ustat32 {
 #define IA32_STACK_TOP IA32_PAGE_OFFSET
 
 #ifdef __KERNEL__
-struct user_desc;
-struct siginfo_t;
-int do_get_thread_area(struct thread_struct *t, struct user_desc __user *info);
-int do_set_thread_area(struct thread_struct *t, struct user_desc __user *info);
-int ia32_child_tls(struct task_struct *p, struct pt_regs *childregs);
-
 struct linux_binprm;
 extern int ia32_setup_arg_pages(struct linux_binprm *bprm,
 				unsigned long stack_top, int exec_stack);
diff --git a/include/asm-x86/proto.h b/include/asm-x86/proto.h
index dabba55..a7aa17d 100644
--- a/include/asm-x86/proto.h
+++ b/include/asm-x86/proto.h
@@ -24,6 +24,11 @@ extern void ia32_syscall(void);
 extern void ia32_cstar_target(void); 
 extern void ia32_sysenter_target(void); 
 
+extern int do_get_thread_area(struct task_struct *p, int idx,
+			      struct user_desc __user *info);
+extern int do_set_thread_area(struct task_struct *p, int idx,
+			      struct user_desc __user *info, int can_allocate);
+
 extern void config_acpi_tables(void);
 extern void ia32_syscall(void);
 

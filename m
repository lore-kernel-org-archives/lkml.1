Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYAFAH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYAFAH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYAFAHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:07:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:22272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbYAFAHM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:07:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=u1BLD40IS0Gh9Z3Ts/B0g2zsvKHow8Lg7pbj2YUSfY9lKKyoi0vu7HrKe/4BvpMXtLm9XcexgUrvs67eCtqWLJw+7NpmKo49193PR39x3RDWAMvwn9204md/jCf10yqHP6+F54oN2YRmESG8NcvOeanzuKtmM2l78Lmc53fAm9U=
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: ioport_{32|64}.c unification
Date: Sun, 6 Jan 2008 00:59:48 +0100
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801060059.48333.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioport_{32|64}.c unification.

This patch unifies the code from the ioport_32.c and ioport_64.c files.

Tested and working fine with i386 and x86_64 kernels.

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0903bbf..5ed68b4 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -10,7 +10,7 @@ CFLAGS_vsyscall_64.o := $(PROFILING) -g0
 
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps_$(BITS).o irq_$(BITS).o
-obj-y			+= time_$(BITS).o ioport_$(BITS).o ldt.o
+obj-y			+= time_$(BITS).o ioport.o ldt.o
 obj-y			+= setup_$(BITS).o i8259_$(BITS).o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
new file mode 100644
index 0000000..be3d521
--- /dev/null
+++ b/arch/x86/kernel/ioport.c
@@ -0,0 +1,138 @@
+/*
+ * This contains the io-permission bitmap code - written by obz, with changes
+ * by Linus. 32/64 bits code unification by Miguel Botón.
+ */
+
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/capability.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/ioport.h>
+#include <linux/smp.h>
+#include <linux/stddef.h>
+#include <linux/slab.h>
+#include <linux/thread_info.h>
+#include <linux/syscalls.h>
+
+/* Set EXTENT bits starting at BASE in BITMAP to value TURN_ON. */
+static void set_bitmap(unsigned long *bitmap, unsigned int base,
+		       unsigned int extent, int new_value)
+{
+	unsigned int i;
+
+	for (i = base; i < base + extent; i++) {
+		if (new_value)
+			__set_bit(i, bitmap);
+		else
+			__clear_bit(i, bitmap);
+	}
+}
+
+/*
+ * this changes the io permissions bitmap in the current task.
+ */
+asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
+{
+	struct thread_struct *t = &current->thread;
+	struct tss_struct *tss;
+	unsigned int i, max_long, bytes, bytes_updated;
+
+	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
+		return -EINVAL;
+	if (turn_on && !capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	/*
+	 * If it's the first ioperm() call in this thread's lifetime, set the
+	 * IO bitmap up. ioperm() is much less timing critical than clone(),
+	 * this is why we delay this operation until now:
+	 */
+	if (!t->io_bitmap_ptr) {
+		unsigned long *bitmap = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
+
+		if (!bitmap)
+			return -ENOMEM;
+
+		memset(bitmap, 0xff, IO_BITMAP_BYTES);
+		t->io_bitmap_ptr = bitmap;
+		set_thread_flag(TIF_IO_BITMAP);
+	}
+
+	/*
+	 * do it in the per-thread copy and in the TSS ...
+	 *
+	 * Disable preemption via get_cpu() - we must not switch away
+	 * because the ->io_bitmap_max value must match the bitmap
+	 * contents:
+	 */
+	tss = &per_cpu(init_tss, get_cpu());
+
+	set_bitmap(t->io_bitmap_ptr, from, num, !turn_on);
+
+	/*
+	 * Search for a (possibly new) maximum. This is simple and stupid,
+	 * to keep it obviously correct:
+	 */
+	max_long = 0;
+	for (i = 0; i < IO_BITMAP_LONGS; i++)
+		if (t->io_bitmap_ptr[i] != ~0UL)
+			max_long = i;
+
+	bytes = (max_long + 1) * sizeof(unsigned long);
+	bytes_updated = max(bytes, t->io_bitmap_max);
+
+	t->io_bitmap_max = bytes;
+
+#ifdef CONFIG_X86_32
+	/*
+	 * Sets the lazy trigger so that the next I/O operation will
+	 * reload the correct bitmap.
+	 * Reset the owner so that a process switch will not set
+	 * tss->io_bitmap_base to IO_BITMAP_OFFSET.
+	 */
+	tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET_LAZY;
+	tss->io_bitmap_owner = NULL;
+#else
+	/* Update the TSS: */
+	memcpy(tss->io_bitmap, t->io_bitmap_ptr, bytes_updated);
+#endif
+
+	put_cpu();
+
+	return 0;
+}
+
+/*
+ * sys_iopl has to be used when you want to access the IO ports
+ * beyond the 0x3ff range: to get the full 65536 ports bitmapped
+ * you'd need 8kB of bitmaps/process, which is a bit excessive.
+ *
+ * Here we just change the flags value on the stack: we allow
+ * only the super-user to do it. This depends on the stack-layout
+ * on system-call entry - see also fork() and the signal handling
+ * code.
+ */
+#ifdef CONFIG_X86_32
+asmlinkage long sys_iopl(unsigned long regsp)
+#else
+asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
+#endif
+{
+#ifdef CONFIG_X86_32
+	volatile struct pt_regs *regs = (struct pt_regs *)&regsp;
+	unsigned int level = regs->bx;
+#endif
+	unsigned int old = (regs->flags >> 12) & 3;
+
+	if (level > 3)
+		return -EINVAL;
+	/* Trying to gain more privileges? */
+	if (level > old) {
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+	}
+	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);;
+
+	return 0;
+}
diff --git a/arch/x86/kernel/ioport_32.c b/arch/x86/kernel/ioport_32.c
deleted file mode 100644
index 9295e01..0000000
--- a/arch/x86/kernel/ioport_32.c
+++ /dev/null
@@ -1,129 +0,0 @@
-/*
- * This contains the io-permission bitmap code - written by obz, with changes
- * by Linus.
- */
-
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/capability.h>
-#include <linux/errno.h>
-#include <linux/types.h>
-#include <linux/ioport.h>
-#include <linux/smp.h>
-#include <linux/stddef.h>
-#include <linux/slab.h>
-#include <linux/thread_info.h>
-#include <linux/syscalls.h>
-
-/* Set EXTENT bits starting at BASE in BITMAP to value TURN_ON. */
-static void set_bitmap(unsigned long *bitmap, unsigned int base,
-		       unsigned int extent, int new_value)
-{
-	unsigned int i;
-
-	for (i = base; i < base + extent; i++) {
-		if (new_value)
-			__set_bit(i, bitmap);
-		else
-			__clear_bit(i, bitmap);
-	}
-}
-
-/*
- * this changes the io permissions bitmap in the current task.
- */
-asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
-{
-	struct thread_struct * t = &current->thread;
-	struct tss_struct * tss;
-	unsigned long i, max_long;
-
-	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
-		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
-	/*
-	 * If it's the first ioperm() call in this thread's lifetime, set the
-	 * IO bitmap up. ioperm() is much less timing critical than clone(),
-	 * this is why we delay this operation until now:
-	 */
-	if (!t->io_bitmap_ptr) {
-		unsigned long *bitmap = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
-
-		if (!bitmap)
-			return -ENOMEM;
-
-		memset(bitmap, 0xff, IO_BITMAP_BYTES);
-		t->io_bitmap_ptr = bitmap;
-		set_thread_flag(TIF_IO_BITMAP);
-	}
-
-	/*
-	 * do it in the per-thread copy and in the TSS ...
-	 *
-	 * Disable preemption via get_cpu() - we must not switch away
-	 * because the ->io_bitmap_max value must match the bitmap
-	 * contents:
-	 */
-	tss = &per_cpu(init_tss, get_cpu());
-
-	set_bitmap(t->io_bitmap_ptr, from, num, !turn_on);
-
-	/*
-	 * Search for a (possibly new) maximum. This is simple and stupid,
-	 * to keep it obviously correct:
-	 */
-	max_long = 0;
-	for (i = 0; i < IO_BITMAP_LONGS; i++)
-		if (t->io_bitmap_ptr[i] != ~0UL)
-			max_long = i;
-
-	t->io_bitmap_max = (max_long + 1) * sizeof(unsigned long);
-
-	/*
-	 * Sets the lazy trigger so that the next I/O operation will
-	 * reload the correct bitmap.
-	 * Reset the owner so that a process switch will not set
-	 * tss->io_bitmap_base to IO_BITMAP_OFFSET.
-	 */
-	tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET_LAZY;
-	tss->io_bitmap_owner = NULL;
-
-	put_cpu();
-
-	return 0;
-}
-
-/*
- * sys_iopl has to be used when you want to access the IO ports
- * beyond the 0x3ff range: to get the full 65536 ports bitmapped
- * you'd need 8kB of bitmaps/process, which is a bit excessive.
- *
- * Here we just change the flags value on the stack: we allow
- * only the super-user to do it. This depends on the stack-layout
- * on system-call entry - see also fork() and the signal handling
- * code.
- */
-
-asmlinkage long sys_iopl(unsigned long regsp)
-{
-	volatile struct pt_regs *regs = (struct pt_regs *)&regsp;
-	unsigned int level = regs->bx;
-	unsigned int old = (regs->flags >> 12) & 3;
-	struct thread_struct *t = &current->thread;
-
-	if (level > 3)
-		return -EINVAL;
-	/* Trying to gain more privileges? */
-	if (level > old) {
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
-	}
-
-	t->iopl = level << 12;
-	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | t->iopl;
-	set_iopl_mask(t->iopl);
-
-	return 0;
-}
diff --git a/arch/x86/kernel/ioport_64.c b/arch/x86/kernel/ioport_64.c
deleted file mode 100644
index ff7514b..0000000
--- a/arch/x86/kernel/ioport_64.c
+++ /dev/null
@@ -1,117 +0,0 @@
-/*
- * This contains the io-permission bitmap code - written by obz, with changes
- * by Linus.
- */
-
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/capability.h>
-#include <linux/errno.h>
-#include <linux/types.h>
-#include <linux/ioport.h>
-#include <linux/smp.h>
-#include <linux/stddef.h>
-#include <linux/slab.h>
-#include <linux/thread_info.h>
-#include <linux/syscalls.h>
-
-/* Set EXTENT bits starting at BASE in BITMAP to value TURN_ON. */
-static void set_bitmap(unsigned long *bitmap, unsigned int base, unsigned int extent, int new_value)
-{
-	int i;
-		if (new_value)
-		for (i = base; i < base + extent; i++) 
-			__set_bit(i, bitmap); 
-		else
-		for (i = base; i < base + extent; i++) 
-			clear_bit(i, bitmap); 
-}
-
-/*
- * this changes the io permissions bitmap in the current task.
- */
-asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
-{
-	unsigned int i, max_long, bytes, bytes_updated;
-	struct thread_struct * t = &current->thread;
-	struct tss_struct * tss;
-	unsigned long *bitmap;
-
-	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
-		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
-	/*
-	 * If it's the first ioperm() call in this thread's lifetime, set the
-	 * IO bitmap up. ioperm() is much less timing critical than clone(),
-	 * this is why we delay this operation until now:
-	 */
-	if (!t->io_bitmap_ptr) {
-		bitmap = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
-		if (!bitmap)
-			return -ENOMEM;
-
-		memset(bitmap, 0xff, IO_BITMAP_BYTES);
-		t->io_bitmap_ptr = bitmap;
-		set_thread_flag(TIF_IO_BITMAP);
-	}
-
-	/*
-	 * do it in the per-thread copy and in the TSS ...
-	 *
-	 * Disable preemption via get_cpu() - we must not switch away
-	 * because the ->io_bitmap_max value must match the bitmap
-	 * contents:
-	 */
-	tss = &per_cpu(init_tss, get_cpu());
-
-	set_bitmap(t->io_bitmap_ptr, from, num, !turn_on);
-
-	/*
-	 * Search for a (possibly new) maximum. This is simple and stupid,
-	 * to keep it obviously correct:
-	 */
-	max_long = 0;
-	for (i = 0; i < IO_BITMAP_LONGS; i++)
-		if (t->io_bitmap_ptr[i] != ~0UL)
-			max_long = i;
-
-	bytes = (max_long + 1) * sizeof(long);
-	bytes_updated = max(bytes, t->io_bitmap_max);
-
-	t->io_bitmap_max = bytes;
-
-	/* Update the TSS: */
-	memcpy(tss->io_bitmap, t->io_bitmap_ptr, bytes_updated);
-
-	put_cpu();
-
-	return 0;
-}
-
-/*
- * sys_iopl has to be used when you want to access the IO ports
- * beyond the 0x3ff range: to get the full 65536 ports bitmapped
- * you'd need 8kB of bitmaps/process, which is a bit excessive.
- *
- * Here we just change the flags value on the stack: we allow
- * only the super-user to do it. This depends on the stack-layout
- * on system-call entry - see also fork() and the signal handling
- * code.
- */
-
-asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
-{
-	unsigned int old = (regs->flags >> 12) & 3;
-
-	if (level > 3)
-		return -EINVAL;
-	/* Trying to gain more privileges? */
-	if (level > old) {
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
-	}
-	regs->flags = (regs->flags &~ X86_EFLAGS_IOPL) | (level << 12);
-	return 0;
-}


-- 
	Miguel Botón

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbXKUWjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbXKUWjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 17:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbXKUWjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 17:39:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbXKUWjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 17:39:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Zachary Amsden <zach@vmware.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [replacement PATCH 5/6] x86: tls32 moved
In-Reply-To: Zachary Amsden's message of  Wednesday, 21 November 2007 10:34:39 -0800 <1195670079.6352.252.camel@bodhitayantram.eng.vmware.com>
References: <20071121101928.A08CF26F8BE@magilla.localdomain>
	<20071121102511.08B8A26F8BE@magilla.localdomain>
	<1195670079.6352.252.camel@bodhitayantram.eng.vmware.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071121223822.114E326F8BE@magilla.localdomain>
Date: Wed, 21 Nov 2007 14:38:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This renames arch/x86/ia32/tls32.c to arch/x86/kernel/tls.c, which does
nothing now but paves the way to consolidate this code for 32-bit too.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/Makefile      |    2 +-
 arch/x86/ia32/tls32.c       |  158 -------------------------------------------
 arch/x86/kernel/Makefile_64 |    2 +
 arch/x86/kernel/tls.c       |  158 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 161 insertions(+), 159 deletions(-)

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
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
new file mode 100644
index 0000000..5291596
--- /dev/null
+++ b/arch/x86/kernel/tls.c
@@ -0,0 +1,158 @@
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
+		if (desc_empty((struct n_desc_struct *)(t->tls_array) + idx))
+			return idx + GDT_ENTRY_TLS_MIN;
+	return -ESRCH;
+}
+
+/*
+ * Set a given TLS descriptor:
+ * When you want addresses > 32bit use arch_prctl()
+ */
+int do_set_thread_area(struct thread_struct *t, struct user_desc __user *u_info)
+{
+	struct user_desc info;
+	struct n_desc_struct *desc;
+	int cpu, idx;
+
+	if (copy_from_user(&info, u_info, sizeof(info)))
+		return -EFAULT;
+
+	idx = info.entry_number;
+
+	/*
+	 * index -1 means the kernel should try to find and
+	 * allocate an empty descriptor:
+	 */
+	if (idx == -1) {
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
+	desc = ((struct n_desc_struct *)t->tls_array) + idx - GDT_ENTRY_TLS_MIN;
+
+	/*
+	 * We must not get preempted while modifying the TLS.
+	 */
+	cpu = get_cpu();
+
+	if (LDT_empty(&info)) {
+		desc->a = 0;
+		desc->b = 0;
+	} else {
+		desc->a = LDT_entry_a(&info);
+		desc->b = LDT_entry_b(&info);
+	}
+	if (t == &current->thread)
+		load_TLS(t, cpu);
+
+	put_cpu();
+	return 0;
+}
+
+asmlinkage long sys32_set_thread_area(struct user_desc __user *u_info)
+{
+	return do_set_thread_area(&current->thread, u_info);
+}
+
+
+/*
+ * Get the current Thread-Local Storage area:
+ */
+
+#define GET_LIMIT(desc) ( \
+	((desc)->a & 0x0ffff) | \
+	 ((desc)->b & 0xf0000) )
+
+#define GET_32BIT(desc)		(((desc)->b >> 22) & 1)
+#define GET_CONTENTS(desc)	(((desc)->b >> 10) & 3)
+#define GET_WRITABLE(desc)	(((desc)->b >>  9) & 1)
+#define GET_LIMIT_PAGES(desc)	(((desc)->b >> 23) & 1)
+#define GET_PRESENT(desc)	(((desc)->b >> 15) & 1)
+#define GET_USEABLE(desc)	(((desc)->b >> 20) & 1)
+#define GET_LONGMODE(desc)	(((desc)->b >> 21) & 1)
+
+int do_get_thread_area(struct thread_struct *t, struct user_desc __user *u_info)
+{
+	struct user_desc info;
+	struct n_desc_struct *desc;
+	int idx;
+
+	if (get_user(idx, &u_info->entry_number))
+		return -EFAULT;
+	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
+		return -EINVAL;
+
+	desc = ((struct n_desc_struct *)t->tls_array) + idx - GDT_ENTRY_TLS_MIN;
+
+	memset(&info, 0, sizeof(struct user_desc));
+	info.entry_number = idx;
+	info.base_addr = get_desc_base(desc);
+	info.limit = GET_LIMIT(desc);
+	info.seg_32bit = GET_32BIT(desc);
+	info.contents = GET_CONTENTS(desc);
+	info.read_exec_only = !GET_WRITABLE(desc);
+	info.limit_in_pages = GET_LIMIT_PAGES(desc);
+	info.seg_not_present = !GET_PRESENT(desc);
+	info.useable = GET_USEABLE(desc);
+	info.lm = GET_LONGMODE(desc);
+
+	if (copy_to_user(u_info, &info, sizeof(info)))
+		return -EFAULT;
+	return 0;
+}
+
+asmlinkage long sys32_get_thread_area(struct user_desc __user *u_info)
+{
+	return do_get_thread_area(&current->thread, u_info);
+}
+
+
+int ia32_child_tls(struct task_struct *p, struct pt_regs *childregs)
+{
+	struct n_desc_struct *desc;
+	struct user_desc info;
+	struct user_desc __user *cp;
+	int idx;
+
+	cp = (void __user *)childregs->rsi;
+	if (copy_from_user(&info, cp, sizeof(info)))
+		return -EFAULT;
+	if (LDT_empty(&info))
+		return -EINVAL;
+
+	idx = info.entry_number;
+	if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
+		return -EINVAL;
+
+	desc = (struct n_desc_struct *)(p->thread.tls_array) + idx - GDT_ENTRY_TLS_MIN;
+	desc->a = LDT_entry_a(&info);
+	desc->b = LDT_entry_b(&info);
+
+	return 0;
+}

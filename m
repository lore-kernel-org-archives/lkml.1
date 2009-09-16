Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbZIPMqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbZIPMqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbZIPMq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:46:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758933AbZIPMpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:45:44 -0400
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] core, x86: Add user return notifiers
Date: Wed, 16 Sep 2009 15:45:31 +0300
Message-Id: <1253105134-8862-2-git-send-email-avi@redhat.com>
In-Reply-To: <1253105134-8862-1-git-send-email-avi@redhat.com>
References: <1253105134-8862-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a general per-cpu notifier that is called whenever the kernel is
about to return to userspace.  The notifier uses a thread_info flag
and existing checks, so there is no impact on user return or context
switch fast paths.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/Kconfig                       |   10 ++++++++++
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/thread_info.h |    7 +++++--
 arch/x86/kernel/process.c          |    2 ++
 arch/x86/kernel/signal.c           |    3 +++
 kernel/Makefile                    |    1 +
 6 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 99193b1..2275b46 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -70,6 +70,13 @@ config KRETPROBES
 	def_bool y
 	depends on KPROBES && HAVE_KRETPROBES
 
+config USER_RETURN_NOTIFIER
+	bool
+	depends on HAVE_USER_RETURN_NOTIFIER
+	help
+	  Provide a kernel-internal notification when a cpu is about to
+	  switch to user mode.
+
 config HAVE_IOREMAP_PROT
 	bool
 
@@ -113,4 +120,7 @@ config HAVE_DMA_API_DEBUG
 config HAVE_DEFAULT_NO_SPIN_MUTEXES
 	bool
 
+config HAVE_USER_RETURN_NOTIFIER
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 13ffa5d..5fc4fae 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -50,6 +50,7 @@ config X86
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select HAVE_ARCH_KMEMCHECK
+	select HAVE_USER_RETURN_NOTIFIER
 
 config OUTPUT_FORMAT
 	string
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index fad7d40..a8f46de 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -83,6 +83,7 @@ struct thread_info {
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
+#define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
@@ -107,6 +108,7 @@ struct thread_info {
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
+#define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
@@ -141,13 +143,14 @@ struct thread_info {
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_NOTIFY_RESUME)
+	(_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |	\
+	 _TIF_USER_RETURN_NOTIFY)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
 	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_NOTSC)
 
-#define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
+#define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
 
 #define PREEMPT_ACTIVE		0x10000000
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 071166a..7ea6972 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -9,6 +9,7 @@
 #include <linux/pm.h>
 #include <linux/clockchips.h>
 #include <linux/random.h>
+#include <linux/user-return-notifier.h>
 #include <trace/power.h>
 #include <asm/system.h>
 #include <asm/apic.h>
@@ -227,6 +228,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		 */
 		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
 	}
+	propagate_user_return_notify(prev_p, next_p);
 }
 
 int sys_fork(struct pt_regs *regs)
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 4c57875..bc0db10 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -19,6 +19,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/uaccess.h>
+#include <linux/user-return-notifier.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
@@ -870,6 +871,8 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
 	}
+	if (thread_info_flags & _TIF_USER_RETURN_NOTIFY)
+		fire_user_return_notifiers();
 
 #ifdef CONFIG_X86_32
 	clear_thread_flag(TIF_IRET);
diff --git a/kernel/Makefile b/kernel/Makefile
index 2093a69..11c5de5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_SLOW_WORK) += slow-work.o
 obj-$(CONFIG_PERF_COUNTERS) += perf_counter.o
+obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
-- 
1.6.4.1


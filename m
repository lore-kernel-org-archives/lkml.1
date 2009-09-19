Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbZISGk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbZISGk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 02:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZISGk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 02:40:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbZISGkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 02:40:25 -0400
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2] core, x86: Add user return notifiers
Date: Sat, 19 Sep 2009 09:40:22 +0300
Message-Id: <1253342422-13811-1-git-send-email-avi@redhat.com>
In-Reply-To: <4AB3CDEC.5050902@zytor.com>
References: <4AB3CDEC.5050902@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a general per-cpu notifier that is called whenever the kernel is
about to return to userspace.  The notifier uses a thread_info flag
and existing checks, so there is no impact on user return or context
switch fast paths.

Signed-off-by: Avi Kivity <avi@redhat.com>
---

v2: include new files in patch


 arch/Kconfig                         |   10 +++++++
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/thread_info.h   |    7 +++-
 arch/x86/kernel/process.c            |    2 +
 arch/x86/kernel/signal.c             |    3 ++
 include/linux/user-return-notifier.h |   42 +++++++++++++++++++++++++++++++
 kernel/Makefile                      |    1 +
 kernel/user-return-notifier.c        |   46 ++++++++++++++++++++++++++++++++++
 8 files changed, 110 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/user-return-notifier.h
 create mode 100644 kernel/user-return-notifier.c

diff --git a/arch/Kconfig b/arch/Kconfig
index beea3cc..b1d0757 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -82,6 +82,13 @@ config KRETPROBES
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
 
@@ -125,4 +132,7 @@ config HAVE_DMA_API_DEBUG
 config HAVE_DEFAULT_NO_SPIN_MUTEXES
 	bool
 
+config HAVE_USER_RETURN_NOTIFIER
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fc20fdc..ed21d6a 100644
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
index d27d0a2..375c917 100644
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
@@ -142,13 +144,14 @@ struct thread_info {
 
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
index 81e5823..13aa99c 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -19,6 +19,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/uaccess.h>
+#include <linux/user-return-notifier.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
@@ -872,6 +873,8 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 		if (current->replacement_session_keyring)
 			key_replace_session_keyring();
 	}
+	if (thread_info_flags & _TIF_USER_RETURN_NOTIFY)
+		fire_user_return_notifiers();
 
 #ifdef CONFIG_X86_32
 	clear_thread_flag(TIF_IRET);
diff --git a/include/linux/user-return-notifier.h b/include/linux/user-return-notifier.h
new file mode 100644
index 0000000..ef04e2e
--- /dev/null
+++ b/include/linux/user-return-notifier.h
@@ -0,0 +1,42 @@
+#ifndef _LINUX_USER_RETURN_NOTIFIER_H
+#define _LINUX_USER_RETURN_NOTIFIER_H
+
+#ifdef CONFIG_USER_RETURN_NOTIFIER
+
+#include <linux/list.h>
+#include <linux/sched.h>
+
+struct user_return_notifier {
+	void (*on_user_return)(struct user_return_notifier *urn);
+	struct hlist_node link;
+};
+
+
+void user_return_notifier_register(struct user_return_notifier *urn);
+void user_return_notifier_unregister(struct user_return_notifier *urn);
+
+static inline void propagate_user_return_notify(struct task_struct *prev,
+						struct task_struct *next)
+{
+	if (test_tsk_thread_flag(prev, TIF_USER_RETURN_NOTIFY)) {
+		clear_tsk_thread_flag(prev, TIF_USER_RETURN_NOTIFY);
+		set_tsk_thread_flag(next, TIF_USER_RETURN_NOTIFY);
+	}
+}
+
+void fire_user_return_notifiers(void);
+
+#else
+
+struct user_return_notifier {};
+
+static inline propagate_user_return_notify(struct task_struct *prev,
+					   struct task_struct *next)
+{
+}
+
+static inline void fire_user_return_notifiers(void) {}
+
+#endif
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index 961379c..f6abe84 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -98,6 +98,7 @@ obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_SLOW_WORK) += slow-work.o
 obj-$(CONFIG_PERF_COUNTERS) += perf_counter.o
+obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/user-return-notifier.c b/kernel/user-return-notifier.c
new file mode 100644
index 0000000..530ccb8
--- /dev/null
+++ b/kernel/user-return-notifier.c
@@ -0,0 +1,46 @@
+
+#include <linux/user-return-notifier.h>
+#include <linux/percpu.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+
+static DEFINE_PER_CPU(struct hlist_head, return_notifier_list);
+
+#define URN_LIST_HEAD per_cpu(return_notifier_list, raw_smp_processor_id())
+
+/*
+ * Request a notification when the current cpu returns to userspace.  Must be
+ * called in atomic context.  The notifier will also be called in atomic
+ * context.
+ */
+void user_return_notifier_register(struct user_return_notifier *urn)
+{
+	set_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
+	hlist_add_head(&urn->link, &URN_LIST_HEAD);
+}
+EXPORT_SYMBOL_GPL(user_return_notifier_register);
+
+/*
+ * Removes a registered user return notifier.  Must be called from atomic
+ * context, and from the same cpu registration occured in.
+ */
+void user_return_notifier_unregister(struct user_return_notifier *urn)
+{
+	hlist_del(&urn->link);
+	if (hlist_empty(&URN_LIST_HEAD))
+		clear_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
+}
+EXPORT_SYMBOL_GPL(user_return_notifier_unregister);
+
+/* Calls registered user return notifiers */
+void fire_user_return_notifiers(void)
+{
+	struct user_return_notifier *urn;
+	struct hlist_node *tmp1, *tmp2;
+	struct hlist_head *head;
+
+	head = &get_cpu_var(return_notifier_list);
+	hlist_for_each_entry_safe(urn, tmp1, tmp2, head, link)
+		urn->on_user_return(urn);
+	put_cpu_var();
+}
-- 
1.6.4.1


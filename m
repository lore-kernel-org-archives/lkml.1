Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbZLCUxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbZLCUxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZLCUxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:53:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43754 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbZLCUxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:53:34 -0500
Date: Thu, 3 Dec 2009 21:53:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/entry for v2.6.33
Message-ID: <20091203205329.GA8591@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-entry-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-entry-for-linus

This new user-return-facility facility we guest-maintained in the x86 
tree hierarchy for the fine KVM folks, who are making use of it in the 
KVM devel tree. KVM uses it for an optimization to allow fast/lazy 
context switches to kernel-mode-only tasks without having to switch 
expensive user state.

out-of-topic modifications in x86-entry-for-linus:
--------------------------------------------------
arch/Kconfig                       # 7c68af6: core, x86: Add user return notifi
include/linux/user-return-notifier.h# 8e7cac7: core: Fix user return notifier on
                                   # 7c68af6: core, x86: Add user return notifi
kernel/Makefile                    # 7a04109: x86: Fix user return notifier bui
kernel/user-return-notifier.c      # 1786bf0: core: Clean up user return notife
                                   # 3c912b6: x86: Fix user return notifier put
                                   # 7c68af6: core, x86: Add user return notifi

 Thanks,

	Ingo

------------------>
Avi Kivity (4):
      core, x86: Add user return notifiers
      x86: Fix user return notifier build
      core: Fix user return notifier on fork()
      core: Clean up user return notifers use of per_cpu

Stephen Rothwell (1):
      x86: Fix user return notifier put_cpu_var() invocation


 arch/Kconfig                         |   10 +++++++
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/thread_info.h   |    7 +++-
 arch/x86/kernel/process.c            |    2 +
 arch/x86/kernel/signal.c             |    3 ++
 include/linux/user-return-notifier.h |   49 ++++++++++++++++++++++++++++++++++
 kernel/Makefile                      |    1 +
 kernel/fork.c                        |    2 +
 kernel/user-return-notifier.c        |   44 ++++++++++++++++++++++++++++++
 9 files changed, 117 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/user-return-notifier.h
 create mode 100644 kernel/user-return-notifier.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 7f418bb..4e312ff 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -83,6 +83,13 @@ config KRETPROBES
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
 
@@ -126,4 +133,7 @@ config HAVE_DMA_API_DEBUG
 config HAVE_DEFAULT_NO_SPIN_MUTEXES
 	bool
 
+config HAVE_USER_RETURN_NOTIFIER
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8da9374..1df175d 100644
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
index 5284cd2..e51b056 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -9,6 +9,7 @@
 #include <linux/pm.h>
 #include <linux/clockchips.h>
 #include <linux/random.h>
+#include <linux/user-return-notifier.h>
 #include <trace/events/power.h>
 #include <asm/system.h>
 #include <asm/apic.h>
@@ -224,6 +225,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		 */
 		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
 	}
+	propagate_user_return_notify(prev_p, next_p);
 }
 
 int sys_fork(struct pt_regs *regs)
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 6a44a76..c49f90f 100644
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
index 0000000..9c4a445
--- /dev/null
+++ b/include/linux/user-return-notifier.h
@@ -0,0 +1,49 @@
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
+static inline void clear_user_return_notifier(struct task_struct *p)
+{
+	clear_tsk_thread_flag(p, TIF_USER_RETURN_NOTIFY);
+}
+
+#else
+
+struct user_return_notifier {};
+
+static inline void propagate_user_return_notify(struct task_struct *prev,
+						struct task_struct *next)
+{
+}
+
+static inline void fire_user_return_notifiers(void) {}
+
+static inline void clear_user_return_notifier(struct task_struct *p) {}
+
+#endif
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index b8d4cd8..0ae57a8 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -95,6 +95,7 @@ obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_SLOW_WORK) += slow-work.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
+obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/fork.c b/kernel/fork.c
index 266c6af..1b7512d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -64,6 +64,7 @@
 #include <linux/magic.h>
 #include <linux/perf_event.h>
 #include <linux/posix-timers.h>
+#include <linux/user-return-notifier.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -249,6 +250,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 		goto out;
 
 	setup_thread_stack(tsk, orig);
+	clear_user_return_notifier(tsk);
 	stackend = end_of_stack(tsk);
 	*stackend = STACK_END_MAGIC;	/* for overflow detection */
 
diff --git a/kernel/user-return-notifier.c b/kernel/user-return-notifier.c
new file mode 100644
index 0000000..eb27fd3
--- /dev/null
+++ b/kernel/user-return-notifier.c
@@ -0,0 +1,44 @@
+
+#include <linux/user-return-notifier.h>
+#include <linux/percpu.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+
+static DEFINE_PER_CPU(struct hlist_head, return_notifier_list);
+
+/*
+ * Request a notification when the current cpu returns to userspace.  Must be
+ * called in atomic context.  The notifier will also be called in atomic
+ * context.
+ */
+void user_return_notifier_register(struct user_return_notifier *urn)
+{
+	set_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
+	hlist_add_head(&urn->link, &__get_cpu_var(return_notifier_list));
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
+	if (hlist_empty(&__get_cpu_var(return_notifier_list)))
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
+	put_cpu_var(return_notifier_list);
+}

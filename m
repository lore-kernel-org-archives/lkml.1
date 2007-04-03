Return-Path: <linux-kernel-owner+w=401wt.eu-S966167AbXDCNTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966167AbXDCNTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 09:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966173AbXDCNTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 09:19:42 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7530 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S966167AbXDCNTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 09:19:41 -0400
X-Greylist: delayed 1512 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 09:19:40 EDT
Message-ID: <46124E93.2000408@ru.mvista.com>
Date: Tue, 03 Apr 2007 16:54:43 +0400
From: Maxim Uvarov <muvarov@ru.mvista.com>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Performance Stats: Kernel patch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have idea to include to the user the following new per-process 
(thread) performance statistics:

    * Involuntary Context Switches
    * Voluntary Context Switches
    * Number of system calls

What do you think about it? Patch is bellow.

Best regards,
Max Uvarov.


Description:
    Patch adds Process Performance Statistics.

 arch/i386/kernel/entry.S       |    3 +++
 arch/mips/kernel/entry.S       |    3 +++
 arch/powerpc/kernel/entry_32.S |    3 +++
 arch/x86_64/kernel/entry.S     |    3 +++
 fs/proc/array.c                |   13 +++++++++++++
 include/linux/sched.h          |    3 +++
 kernel/fork.c                  |    3 +++
 kernel/sys.c                   |    8 ++++++++
 lib/Kconfig.debug              |   10 ++++++++++
 9 files changed, 49 insertions(+)

Index: linux-2.6.18/fs/proc/array.c
===================================================================
--- linux-2.6.18.orig/fs/proc/array.c
+++ linux-2.6.18/fs/proc/array.c
@@ -295,6 +295,18 @@ static inline char *task_cap(struct task
                            cap_t(p->cap_effective));
 }

+#ifdef THREAD_PERF_STAT
+static inline char *task_perf(struct task_struct *p, char *buffer)
+{
+    return buffer + sprintf(buffer, "Nvcsw:\t%lu\n"
+                           "Nivcsw:\t%lu\n"
+                           "Syscalls:\t%d\n",
+                           cap_t(p->nvcsw),
+                           cap_t(p->nivcsw),
+                           cap_t(p->sysc_cnt));
+}
+#endif /* THREAD_PERF_STAT */
+
 #define get_blocked_on(t)      (-1)

 static char *show_blocked_on(struct task_struct *task, char *buffer)
@@ -327,6 +339,7 @@ int proc_pid_status(struct task_struct *
        buffer = task_show_regs(task, buffer);
 #endif
        buffer = show_blocked_on(task,buffer);
+       buffer = task_perf(task, buffer);
        return buffer - orig;
 }

Index: linux-2.6.18/include/linux/sched.h
===================================================================
--- linux-2.6.18.orig/include/linux/sched.h
+++ linux-2.6.18/include/linux/sched.h
@@ -1193,6 +1193,9 @@ struct task_struct {
        ltt_facility_t ltt_facilities[LTT_FAC_PER_PROCESS];
 #endif //CONFIG_LTT_USERSPACE_GENERIC

+#ifdef THREAD_PERF_STAT
+       int sysc_cnt;           /* Syscall counter */
+#endif /* THREAD_PERF_STAT */
        /*
         * task-specic data
         * XXX: for a future release, MontaVista-only
Index: linux-2.6.18/kernel/sys.c
===================================================================
--- linux-2.6.18.orig/kernel/sys.c
+++ linux-2.6.18/kernel/sys.c
@@ -2071,3 +2071,11 @@ asmlinkage long sys_prctl(int option, un
        }
        return error;
 }
+#ifdef THREAD_PERF_STAT
+asmlinkage void inc_syscallcnt(void)
+{
+       current->sysc_cnt += 1;
+       return;
+}
+#endif /* THREAD_PERF_STAT */
+
Index: linux-2.6.18/kernel/fork.c
===================================================================
--- linux-2.6.18.orig/kernel/fork.c
+++ linux-2.6.18/kernel/fork.c
@@ -1079,6 +1079,9 @@ static struct task_struct *copy_process(
        p->wchar = 0;           /* I/O counter: bytes written */
        p->syscr = 0;           /* I/O counter: read syscalls */
        p->syscw = 0;           /* I/O counter: write syscalls */
+#ifdef THREAD_PERF_STAT
+       p->sysc_cnt = 0;        /* Syscall counter: total numbers of 
syscalls */
+#endif /* THREAD_PERF_STAT */
        acct_clear_integrals(p);

        p->it_virt_expires = cputime_zero;
Index: linux-2.6.18/arch/i386/kernel/entry.S
===================================================================
--- linux-2.6.18.orig/arch/i386/kernel/entry.S
+++ linux-2.6.18/arch/i386/kernel/entry.S
@@ -394,6 +394,9 @@ syscall_exit:
        cli                             # make sure we don't miss an 
interrupt
                                        # setting need_resched or sigpending
                                        # between sampling and the iret
+#ifdef THREAD_PERF_STAT
+       call inc_syscallcnt             # Increment syscalls counter 
current->sysc_cnt
+#endif /* THREAD_PERF_STAT */
        TRACE_IRQS_OFF
        movl TI_flags(%ebp), %ecx
        testw $_TIF_ALLWORK_MASK, %cx   # current->work
Index: linux-2.6.18/arch/x86_64/kernel/entry.S
===================================================================
--- linux-2.6.18.orig/arch/x86_64/kernel/entry.S
+++ linux-2.6.18/arch/x86_64/kernel/entry.S
@@ -388,6 +388,9 @@ ENTRY(int_ret_from_sys_call)
        /* edi: mask to check */
 int_with_check:
        GET_THREAD_INFO(%rcx)
+#ifdef THREAD_PERF_STAT
+       call inc_syscallcnt     # Increment syscalls counter 
current->sysc_cnt
+#endif /* THREAD_PERF_STAT */
        movl threadinfo_flags(%rcx),%edx
        andl %edi,%edx
        jnz   int_careful
Index: linux-2.6.18/arch/powerpc/kernel/entry_32.S
===================================================================
--- linux-2.6.18.orig/arch/powerpc/kernel/entry_32.S
+++ linux-2.6.18/arch/powerpc/kernel/entry_32.S
@@ -236,6 +236,9 @@ ret_from_syscall:
 #ifdef SHOW_SYSCALLS
        bl      do_show_syscall_exit
 #endif
+#ifdef THREAD_PERF_STAT
+       bl      inc_syscallcnt  /* Increment syscalls counter 
current->sysc_cnt */
+#endif /* THREAD_PERF_STAT */
 #ifdef CONFIG_MICROSTATE
        /* FIXME: this is too early since this might not return to
           user space just yet because of syscall_exit_work */
Index: linux-2.6.18/arch/mips/kernel/entry.S
===================================================================
--- linux-2.6.18.orig/arch/mips/kernel/entry.S
+++ linux-2.6.18/arch/mips/kernel/entry.S
@@ -75,6 +75,9 @@ FEXPORT(syscall_exit)
        raw_local_irq_disable   # make sure need_resched and
                                        # signals dont change between
                                        # sampling and return
+#ifdef THREAD_PERF_STAT
+       jal     inc_syscallcnt          # Increment syscalls counter 
current->sysc_cnt
+#endif /* THREAD_PERF_STAT */
        LONG_L  a2, TI_FLAGS($28)       # current->work
        li      t0, _TIF_ALLWORK_MASK
        and     t0, a2, t0
Index: linux-2.6.18/lib/Kconfig.debug
===================================================================
--- linux-2.6.18.orig/lib/Kconfig.debug
+++ linux-2.6.18/lib/Kconfig.debug
@@ -539,4 +539,14 @@ config RCU_TORTURE_TEST
          Say M if you want the RCU torture tests to build as a module.
          Say N if you are unsure.

+config THREAD_PERF_STAT
+       bool "Per-process (thread) performance statistics"
+       depends on (X86 || PPC || MIPS)
+       help
+         Make available to the user the following new per-process 
(thread) performance statistics:
+           * Involuntary Context Switches
+           * Voluntary Context Switches
+           * Number of system calls
+         This information is available via /proc/PID/status.
+
 source "lib/Kconfig.kgdb"

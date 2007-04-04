Return-Path: <linux-kernel-owner+w=401wt.eu-S1750992AbXDDNPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992AbXDDNPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 09:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbXDDNPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 09:15:23 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:9257 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750992AbXDDNPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 09:15:21 -0400
Message-ID: <4613A4FF.9030202@ru.mvista.com>
Date: Wed, 04 Apr 2007 17:15:43 +0400
From: Maxim Uvarov <muvarov@ru.mvista.com>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: Performance Stats: Kernel patch
References: <46124E93.2000408@ru.mvista.com> <16797.1175641303@turing-police.cc.vt.edu>
In-Reply-To: <16797.1175641303@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

Please see my answers bellow:

Valdis.Kletnieks@vt.edu wrote:

>On Tue, 03 Apr 2007 16:54:43 +0400, Maxim Uvarov said:
>
>  
>
>>What do you think about it? Patch is bellow.
>>    
>>
>
>Was this patch actually compile and run tested?
>  
>
Yes I have tested it on PPC, X86, X86_64, Mips targets.
It works.

>  
>
>>Index: linux-2.6.18/fs/proc/array.c
>>===================================================================
>>--- linux-2.6.18.orig/fs/proc/array.c
>>+++ linux-2.6.18/fs/proc/array.c
>>@@ -295,6 +295,18 @@ static inline char *task_cap(struct task
>>                            cap_t(p->cap_effective));
>> }
>>
>>+#ifdef THREAD_PERF_STAT
>>    
>>
>
>This needs to be CONFIG_THREAD_PERF_STAT everyplace except the Kconfig stuff.
>  
>
Yes you are right. I have not check it after adding ifdef :(

>  
>
>>+static inline char *task_perf(struct task_struct *p, char *buffer)
>>+{
>>+    return buffer + sprintf(buffer, "Nvcsw:\t%lu\n"
>>+                           "Nivcsw:\t%lu\n"
>>+                           "Syscalls:\t%d\n",
>>+                           cap_t(p->nvcsw),
>>+                           cap_t(p->nivcsw),
>>+                           cap_t(p->sysc_cnt));
>>+}
>>    
>>
>
>You might want a #else that defines a null body for this inline, to
>avoid a problem a bit later.
>
>  
>
>>+#endif /* THREAD_PERF_STAT */
>>+
>> #define get_blocked_on(t)      (-1)
>>
>> static char *show_blocked_on(struct task_struct *task, char *buffer)
>>@@ -327,6 +339,7 @@ int proc_pid_status(struct task_struct *
>>        buffer = task_show_regs(task, buffer);
>> #endif
>>        buffer = show_blocked_on(task,buffer);
>>+       buffer = task_perf(task, buffer);
>>    
>>
>
>What will this call if you don't have THREAD_PERF_STAT defined?
>
>Here's where you need the #else clause providing a null body for you....
>
>I don't see how this could possibly have built cleanly, since the CONFIG_
>issue above would have prevented you from defining a task_perf() function...
>
>
>  
>
New version of this patch. Please flay it.


Signed-off-by: Max Uvarov <muvarov@ru.mvista.com>
Description:
    Patch adds Process Performance Statistics.

 arch/i386/kernel/entry.S       |    3 +++
 arch/mips/kernel/entry.S       |    3 +++
 arch/powerpc/kernel/entry_32.S |    3 +++
 arch/x86_64/kernel/entry.S     |    3 +++
 fs/proc/array.c                |   17 +++++++++++++++++
 include/linux/sched.h          |    3 +++
 kernel/fork.c                  |    3 +++
 kernel/sys.c                   |    8 ++++++++
 lib/Kconfig.debug              |   17 +++++++++++++++++
 9 files changed, 60 insertions(+)

Index: linux-2.6.18/fs/proc/array.c
===================================================================
--- linux-2.6.18.orig/fs/proc/array.c
+++ linux-2.6.18/fs/proc/array.c
@@ -295,6 +295,20 @@ static inline char *task_cap(struct task
                            cap_t(p->cap_effective));
 }

+#ifdef CONFIG_THREAD_PERF_STAT
+static inline char *task_perf(struct task_struct *p, char *buffer)
+{
+#ifdef THREAD_PERF_STAT_SYSC
+       buffer += sprintf(buffer, "Syscalls:\t%d\n", cap_t(p->sysc_cnt));
+#endif /* THREAD_PERF_STAT_SYSC */
+
+       return buffer + sprintf(buffer, "Nvcsw:\t%lu\n"
+                           "Nivcsw:\t%lu\n",
+                           cap_t(p->nvcsw),
+                           cap_t(p->nivcsw));
+}
+#endif /* CONFIG_THREAD_PERF_STAT */
+
 #define get_blocked_on(t)      (-1)

 static char *show_blocked_on(struct task_struct *task, char *buffer)
@@ -327,6 +341,9 @@ int proc_pid_status(struct task_struct *
        buffer = task_show_regs(task, buffer);
 #endif
        buffer = show_blocked_on(task,buffer);
+#ifdef CONFIG_THREAD_PERF_STAT
+       buffer = task_perf(task, buffer);
+#endif /* CONFIG_THREAD_PERF_STAT */
        return buffer - orig;
 }

Index: linux-2.6.18/include/linux/sched.h
===================================================================
--- linux-2.6.18.orig/include/linux/sched.h
+++ linux-2.6.18/include/linux/sched.h
@@ -1193,6 +1193,9 @@ struct task_struct {
        ltt_facility_t ltt_facilities[LTT_FAC_PER_PROCESS];
 #endif //CONFIG_LTT_USERSPACE_GENERIC

+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+       int sysc_cnt;           /* Syscall counter */
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
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
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+asmlinkage void inc_syscallcnt(void)
+{
+       current->sysc_cnt += 1;
+       return;
+}
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
+
Index: linux-2.6.18/kernel/fork.c
===================================================================
--- linux-2.6.18.orig/kernel/fork.c
+++ linux-2.6.18/kernel/fork.c
@@ -1079,6 +1079,9 @@ static struct task_struct *copy_process(
        p->wchar = 0;           /* I/O counter: bytes written */
        p->syscr = 0;           /* I/O counter: read syscalls */
        p->syscw = 0;           /* I/O counter: write syscalls */
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+       p->sysc_cnt = 0;        /* Syscall counter: total numbers of 
syscalls */
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
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
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+       call inc_syscallcnt             # Increment syscalls counter 
current->sysc_cnt
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
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
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+       call inc_syscallcnt     # Increment syscalls counter 
current->sysc_cnt
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
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
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+       bl      inc_syscallcnt  /* Increment syscalls counter 
current->sysc_cnt */
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
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
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+       jal     inc_syscallcnt          # Increment syscalls counter 
current->sysc_cnt
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
        LONG_L  a2, TI_FLAGS($28)       # current->work
        li      t0, _TIF_ALLWORK_MASK
        and     t0, a2, t0
Index: linux-2.6.18/lib/Kconfig.debug
===================================================================
--- linux-2.6.18.orig/lib/Kconfig.debug
+++ linux-2.6.18/lib/Kconfig.debug
@@ -539,4 +539,21 @@ config RCU_TORTURE_TEST
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
+           * Number of system calls (option)
+         This information is available via /proc/PID/status.
+
+config THREAD_PERF_STAT_SYSC
+       bool "enable syscall counter"
+       depends on THREAD_PERF_STAT
+       help
+          This option add syscalls counter to  /proc/PID/status.
+
+
 source "lib/Kconfig.kgdb"


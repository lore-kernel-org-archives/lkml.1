Return-Path: <linux-kernel-owner+w=401wt.eu-S1751250AbXDDQwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbXDDQwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXDDQwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:52:10 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:9551 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751250AbXDDQwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:52:09 -0400
Message-ID: <4613D7D2.20806@ru.mvista.com>
Date: Wed, 04 Apr 2007 20:52:34 +0400
From: Maxim Uvarov <muvarov@ru.mvista.com>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: Performance Stats: Kernel patch
References: <46124E93.2000408@ru.mvista.com>	<16797.1175641303@turing-police.cc.vt.edu>	<4613A4FF.9030202@ru.mvista.com> <20070404154624.826578b1.dada1@cosmosbay.com>
In-Reply-To: <20070404154624.826578b1.dada1@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

I changed patch according to your comments.
Could you please take a look at it?

Eric Dumazet wrote:

>On Wed, 04 Apr 2007 17:15:43 +0400
>Maxim Uvarov <muvarov@ru.mvista.com> wrote:
>
>  
>
>>--- linux-2.6.18.orig/arch/i386/kernel/entry.S
>>+++ linux-2.6.18/arch/i386/kernel/entry.S
>>@@ -394,6 +394,9 @@ syscall_exit:
>>        cli                             # make sure we don't miss an 
>>interrupt
>>                                        # setting need_resched or sigpending
>>                                        # between sampling and the iret
>>+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
>>+       call inc_syscallcnt             # Increment syscalls counter 
>>current->sysc_cnt
>>+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
>>    
>>
>
>Please dont call a function to do one increment !
>  
>
Yes, you are right. I have changed it.

>You are touching one of the most critical part of the kernel...
>
>Also, dont do this while interrupts are masked, this is not necessary.
>
>Maybe better to place sysc_cnt in 'struct thread_info' because %ebp point to it.
>  
>

>Also you missed the fact that syscalls on i386 can use sysenter (around line 343)
>
>  
>
>>        TRACE_IRQS_OFF
>>        movl TI_flags(%ebp), %ecx
>>        testw $_TIF_ALLWORK_MASK, %cx   # current->work
>>
>>    
>>
I rewrote this patch for x86.   And I have question. Should /proc/PID/status
be used for these counters and this option be selectable or it will 
better to
create another file in /proc/PID/  directory?

I will include syscall counters for other arches later.

P.S.
Jesper Juhl, thank you.

Best regards,
Maxim.

Signed-off-by: Max Uvarov <muvarov@ru.mvista.com>
Description:
    Patch adds Process Performance Statistics.

 arch/i386/kernel/asm-offsets.c |    3 +++
 arch/i386/kernel/entry.S       |    6 ++++++
 fs/proc/array.c                |   14 ++++++++++++++
 include/asm/thread_info.h      |    3 +++
 kernel/fork.c                  |    3 +++
 lib/Kconfig.debug              |   16 ++++++++++++++++
 6 files changed, 45 insertions(+)

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
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+       buffer += sprintf(buffer, "Syscalls:\t%lu\n", 
cap_t(p->thread_info->sysc_cnt));
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
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
Index: linux-2.6.18/arch/i386/kernel/entry.S
===================================================================
--- linux-2.6.18.orig/arch/i386/kernel/entry.S
+++ linux-2.6.18/arch/i386/kernel/entry.S
@@ -334,6 +334,9 @@ sysenter_past_esp:
        jae syscall_badsys
        call *sys_call_table(,%eax,4)
        movl %eax,EAX(%esp)
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+       incl    TI_sysc_cnt(%ebp)       # Increment syscalls counter
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 #ifdef CONFIG_MICROSTATE
        call msa_end_syscall
 #endif
@@ -388,6 +391,9 @@ syscall_call:
        call *sys_call_table(,%eax,4)
        movl %eax,EAX(%esp)             # store the return value
 syscall_exit:
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+       incl    TI_sysc_cnt(%ebp)       # Increment syscalls counter 
current->sysc_cnt
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 #ifdef CONFIG_MICROSTATE
        call msa_end_syscall
 #endif
Index: linux-2.6.18/lib/Kconfig.debug
===================================================================
--- linux-2.6.18.orig/lib/Kconfig.debug
+++ linux-2.6.18/lib/Kconfig.debug
@@ -539,4 +539,20 @@ config RCU_TORTURE_TEST
          Say M if you want the RCU torture tests to build as a module.
          Say N if you are unsure.

+config THREAD_PERF_STAT
+       bool "Per-process (thread) performance statistics"
+       depends on X86
+       help
+         Make available to the user the following per-process (thread) 
performance statistics:
+            * Number of involuntary context switches
+            * Number of voluntary context switches
+            * Number of system calls (optional)
+         This information is available via /proc/PID/status.
+
+config THREAD_PERF_STAT_SYSC
+       bool "Enable syscall counter"
+       depends on THREAD_PERF_STAT
+       help
+         This option adds a syscall counter to /proc/PID/status.
+
 source "lib/Kconfig.kgdb"
Index: linux-2.6.18/include/asm/thread_info.h
===================================================================
--- linux-2.6.18.orig/include/asm/thread_info.h
+++ linux-2.6.18/include/asm/thread_info.h
@@ -44,6 +44,9 @@ struct thread_info {
                                                   of nested (IRQ) stacks
                                                */
        __u8                    supervisor_stack[0];
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+       unsigned long           sysc_cnt;           /* Syscall counter */
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 };

 #else /* !__ASSEMBLY__ */
Index: linux-2.6.18/kernel/fork.c
===================================================================
--- linux-2.6.18.orig/kernel/fork.c
+++ linux-2.6.18/kernel/fork.c
@@ -1079,6 +1079,9 @@ static struct task_struct *copy_process(
        p->wchar = 0;           /* I/O counter: bytes written */
        p->syscr = 0;           /* I/O counter: read syscalls */
        p->syscw = 0;           /* I/O counter: write syscalls */
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+       p->thread_info->sysc_cnt = 0;   /* Syscall counter: total 
numbers of syscalls */
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
        acct_clear_integrals(p);

        p->it_virt_expires = cputime_zero;
Index: linux-2.6.18/arch/i386/kernel/asm-offsets.c
===================================================================
--- linux-2.6.18.orig/arch/i386/kernel/asm-offsets.c
+++ linux-2.6.18/arch/i386/kernel/asm-offsets.c
@@ -56,6 +56,9 @@ void foo(void)
        OFFSET(TI_addr_limit, thread_info, addr_limit);
        OFFSET(TI_restart_block, thread_info, restart_block);
        OFFSET(TI_sysenter_return, thread_info, sysenter_return);
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+       OFFSET(TI_sysc_cnt, thread_info, sysc_cnt);
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
        BLANK();


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbXFIEF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbXFIEF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 00:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXFIEFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 00:05:51 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31918 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbXFIEFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 00:05:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent:from;
	b=PAi7MEGFURVD64XLi4hN174WeEnw9byr5MkYNUm8nNmeGv8EmTqKcIhO92sQv0Xgx
	/wBONvNHAEg2X8t5hnkJw==
Date: Fri, 8 Jun 2007 21:05:43 -0700
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Make i386 kernel show the unhandled signals
Message-ID: <20070609040542.GA20357@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: masouds@google.com (Masoud Asgharifard Sharbiani)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
This patch makes the i386 behave the same way that x86_64 does when a
segfault happens. A line gets printed to the kernel log so that tools
that need to check for failures can behave more uniformly between
different kernels. Like x86_64, it can be disabled by setting
debug.show_unhandled_signals sysctl variable to 0 (or by doing
echo 0 > /proc/sys/debug/show_unhandled_signals)

Also, all of the lines being printed are now using printk_ratelimit()
to deny the ability of DoS from a local user with a program like the
following:
main()
{
	while (1)
		if (!fork()) *(int *)0 = 0;
}


cheers, 
Masoud

Signed-off-by: Masoud Sharbiani <masouds@google.com>

 arch/i386/kernel/signal.c   |    5 +++++
 arch/i386/kernel/traps.c    |    7 +++++++
 arch/i386/mm/fault.c        |   11 +++++++++++
 arch/x86_64/kernel/signal.c |    2 +-
 arch/x86_64/kernel/traps.c  |    6 ++++--
 arch/x86_64/mm/fault.c      |   15 +++------------
 arch/x86_64/mm/init.c       |   35 -----------------------------------
 include/asm-x86_64/proto.h  |    2 --
 include/linux/signal.h      |    3 +++
 include/linux/sysctl.h      |    3 +++
 kernel/signal.c             |   10 ++++++++++
 kernel/sysctl.c             |   10 ++++++++++
 12 files changed, 57 insertions(+), 52 deletions(-)

diff --git a/arch/i386/kernel/signal.c b/arch/i386/kernel/signal.c
index d574e38..828dcb0 100644
--- a/arch/i386/kernel/signal.c
+++ b/arch/i386/kernel/signal.c
@@ -199,6 +199,11 @@ asmlinkage int sys_sigreturn(unsigned long __unused)
 	return eax;
 
 badframe:
+	if (show_unhandled_signals && printk_ratelimit())
+		printk("%s[%d] bad frame in sigreturn frame:%p eip:%lx esp:%lx oeax:%lx\n",
+		    current->comm, current->pid, frame, regs->eip, regs->esp,
+		    regs->orig_eax); 
+
 	force_sig(SIGSEGV, current);
 	return 0;
 }	
diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
index 90da057..bccc5b4 100644
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -610,6 +610,13 @@ fastcall void __kprobes do_general_protection(struct pt_regs * regs,
 
 	current->thread.error_code = error_code;
 	current->thread.trap_no = 13;
+	if (show_unhandled_signals && unhandled_signal(current, SIGSEGV) &&
+	    printk_ratelimit())
+		printk(KERN_INFO
+		       "%s[%d] general protection eip:%lx esp:%lx error:%lx\n",
+		       current->comm, current->pid,
+		       regs->eip, regs->esp, error_code); 
+
 	force_sig(SIGSEGV, current);
 	return;
 
diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
index 29d7d61..2aa4206 100644
--- a/arch/i386/mm/fault.c
+++ b/arch/i386/mm/fault.c
@@ -283,6 +283,8 @@ static inline int vmalloc_fault(unsigned long address)
 	return 0;
 }
 
+int show_unhandled_signals = 1;
+
 /*
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
@@ -465,6 +467,15 @@ bad_area_nosemaphore:
 		if (is_prefetch(regs, address, error_code))
 			return;
 
+		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit()) {
+			printk(
+		       "%s%s[%d]: segfault at %08lx eip %08lx esp %08lx error %lx\n",
+					tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
+					tsk->comm, tsk->pid, address, regs->eip,
+					regs->esp, error_code);
+		}
+ 
 		tsk->thread.cr2 = address;
 		/* Kernel addresses are always protection faults */
 		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
diff --git a/arch/i386/mm/init.c b/arch/i386/mm/init.c
diff --git a/arch/x86_64/kernel/signal.c b/arch/x86_64/kernel/signal.c
index 290f5d8..f9506f6 100644
--- a/arch/x86_64/kernel/signal.c
+++ b/arch/x86_64/kernel/signal.c
@@ -480,7 +480,7 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 { 
 	struct task_struct *me = current; 
-	if (exception_trace)
+	if (show_unhandled_signals && printk_ratelimit())
 		printk("%s[%d] bad frame in %s frame:%p rip:%lx rsp:%lx orax:%lx\n",
 	       me->comm,me->pid,where,frame,regs->rip,regs->rsp,regs->orig_rax); 
 
diff --git a/arch/x86_64/kernel/traps.c b/arch/x86_64/kernel/traps.c
index cb29fb9..4f46b4d 100644
--- a/arch/x86_64/kernel/traps.c
+++ b/arch/x86_64/kernel/traps.c
@@ -577,7 +577,8 @@ static void __kprobes do_trap(int trapnr, int signr, char *str,
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_no = trapnr;
 
-		if (exception_trace && unhandled_signal(tsk, signr))
+		if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
+		    printk_ratelimit())
 			printk(KERN_INFO
 			       "%s[%d] trap %s rip:%lx rsp:%lx error:%lx\n",
 			       tsk->comm, tsk->pid, str,
@@ -681,7 +682,8 @@ asmlinkage void __kprobes do_general_protection(struct pt_regs * regs,
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_no = 13;
 
-		if (exception_trace && unhandled_signal(tsk, SIGSEGV))
+		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit())
 			printk(KERN_INFO
 		       "%s[%d] general protection rip:%lx rsp:%lx error:%lx\n",
 			       tsk->comm, tsk->pid,
diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index bfb62a1..73917cf 100644
--- a/arch/x86_64/mm/fault.c
+++ b/arch/x86_64/mm/fault.c
@@ -221,16 +221,6 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
 	return 0;
 } 
 
-int unhandled_signal(struct task_struct *tsk, int sig)
-{
-	if (is_init(tsk))
-		return 1;
-	if (tsk->ptrace & PT_PTRACED)
-		return 0;
-	return (tsk->sighand->action[sig-1].sa.sa_handler == SIG_IGN) ||
-		(tsk->sighand->action[sig-1].sa.sa_handler == SIG_DFL);
-}
-
 static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
 				 unsigned long error_code)
 {
@@ -302,7 +292,7 @@ static int vmalloc_fault(unsigned long address)
 }
 
 int page_fault_trace = 0;
-int exception_trace = 1;
+int show_unhandled_signals = 1;
 
 /*
  * This routine handles page faults.  It determines the address,
@@ -489,7 +479,8 @@ bad_area_nosemaphore:
 		    (address >> 32))
 			return;
 
-		if (exception_trace && unhandled_signal(tsk, SIGSEGV)) {
+		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit()) {
 			printk(
 		       "%s%s[%d]: segfault at %016lx rip %016lx rsp %016lx error %lx\n",
 					tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
index 1ad5111..19a6f5b 100644
--- a/arch/x86_64/mm/init.c
+++ b/arch/x86_64/mm/init.c
@@ -690,41 +690,6 @@ int kern_addr_valid(unsigned long addr)
 	return pfn_valid(pte_pfn(*pte));
 }
 
-#ifdef CONFIG_SYSCTL
-#include <linux/sysctl.h>
-
-extern int exception_trace, page_fault_trace;
-
-static ctl_table debug_table2[] = {
-	{
-		.ctl_name	= 99,
-		.procname	= "exception-trace",
-		.data		= &exception_trace,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec
-	},
-	{}
-}; 
-
-static ctl_table debug_root_table2[] = { 
-	{
-		.ctl_name = CTL_DEBUG,
-		.procname = "debug",
-		.mode = 0555,
-		.child = debug_table2
-	},
-	{}
-}; 
-
-static __init int x8664_sysctl_init(void)
-{ 
-	register_sysctl_table(debug_root_table2);
-	return 0;
-}
-__initcall(x8664_sysctl_init);
-#endif
-
 /* A pseudo VMA to allow ptrace access for the vsyscall page.  This only
    covers the 64bit vsyscall page now. 32bit has a real VMA now and does
    not need special handling anymore. */
diff --git a/include/asm-x86_64/proto.h b/include/asm-x86_64/proto.h
index 85255db..4fad501 100644
--- a/include/asm-x86_64/proto.h
+++ b/include/asm-x86_64/proto.h
@@ -75,8 +75,6 @@ extern void setup_node_bootmem(int nodeid, unsigned long start, unsigned long en
 extern void early_quirks(void);
 extern void check_efer(void);
 
-extern int unhandled_signal(struct task_struct *tsk, int sig);
-
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 
 extern unsigned long table_start, table_end;
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 9a5eac5..aa2c243 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -238,12 +238,15 @@ extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
 extern long do_sigpending(void __user *, unsigned long);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
+extern int show_unhandled_signals;
 
 struct pt_regs;
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
 
 extern struct kmem_cache *sighand_cachep;
 
+int unhandled_signal(struct task_struct *tsk, int sig);
+
 /*
  * In POSIX a signal is sent either to a specific thread (Linux task)
  * or to the process as a whole (Linux thread group).  How the signal
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 47f1c53..a4fd7f1 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -835,6 +835,9 @@ enum {
 };
 
 /* CTL_DEBUG names: */
+enum {
+	DEBUG_UNHANDLED_SIGNALS = 1,
+};
 
 /* CTL_DEV names: */
 enum {
diff --git a/kernel/signal.c b/kernel/signal.c
index fe590e0..ce6085f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -255,6 +255,16 @@ flush_signal_handlers(struct task_struct *t, int force_default)
 	}
 }
 
+int unhandled_signal(struct task_struct *tsk, int sig)
+{
+	if (is_init(tsk))
+               return 1;
+	if (tsk->ptrace & PT_PTRACED)
+		return 0;
+	return (tsk->sighand->action[sig-1].sa.sa_handler == SIG_IGN) ||
+		(tsk->sighand->action[sig-1].sa.sa_handler == SIG_DFL);
+}
+
 
 /* Notify the system that a driver wants to block all signals for this
  * process, and wants to be notified if any signals at all were to be
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 30ee462..9486870 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1026,6 +1026,16 @@ static ctl_table fs_table[] = {
 };
 
 static ctl_table debug_table[] = {
+#ifdef CONFIG_X86
+	{
+		.ctl_name	= DEBUG_UNHANDLED_SIGNALS,
+		.procname	= "show-unhandled-signals",
+		.data		= &show_unhandled_signals,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
+#endif
 	{ .ctl_name = 0 }
 };
 

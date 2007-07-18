Return-Path: <linux-kernel-owner+w=401wt.eu-S933301AbXGRPsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbXGRPsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 11:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759991AbXGRPsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 11:48:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56579 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759841AbXGRPs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 11:48:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent:from;
	b=f38MtFy8zsHMCfcjcdSJLxiahDdUOSztGM2WEtb9x0EHdFAd0vBzkX+urNhJ7VJrU
	8w7wjqDndaDpbP/Rfm57Q==
Date: Wed, 18 Jul 2007 08:47:59 -0700
To: akpm@linux-foundation.org
Cc: ak@suse.de, linux-kernel@vger.kernel.org
Subject: i386-show-unhandled-signals-v3
Message-ID: <20070718154759.GA26425@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: masouds@google.com (Masoud Asgharifard Sharbiani)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
This patch makes the i386 behave the same way that x86_64 does when a
segfault happens.  A line gets printed to the kernel log so that tools
that
need to check for failures can behave more uniformly between
debug.show_unhandled_signals sysctl variable to 0 (or by doing echo 0 > 
/proc/sys/debug/exception-trace)

Also, all of the lines being printed are now using printk_ratelimit() to
deny the ability of DoS from a local user with a program like the
following:

main()
{
       while (1)
               if (!fork()) *(int *)0 = 0;
}

This new revision also includes the fix that Andrew did which got rid of
new sysctl that was added to the system in earlier versions of this.
Also, 'show-unhandled-signals' sysctl has been renamed back to the old
'exception-trace' to avoid breakage of people's scripts.

cheers,
Masoud Sharbiani

Signed-off-by: Masoud Sharbiani <masouds@google.com>
Cc: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/signal.c   |    7 +++++++
 arch/i386/kernel/traps.c    |    7 +++++++
 arch/i386/mm/fault.c        |   10 ++++++++++
 arch/x86_64/kernel/signal.c |    2 +-
 arch/x86_64/kernel/traps.c  |    6 ++++--
 arch/x86_64/mm/fault.c      |   15 +++------------
 arch/x86_64/mm/init.c       |   35 -----------------------------------
 include/asm-x86_64/proto.h  |    2 --
 include/linux/signal.h      |    3 +++
 kernel/signal.c             |   10 ++++++++++
 kernel/sysctl.c             |   10 ++++++++++
 11 files changed, 55 insertions(+), 52 deletions(-)

diff --git a/arch/i386/kernel/signal.c b/arch/i386/kernel/signal.c
index d574e38..f5dd856 100644
--- a/arch/i386/kernel/signal.c
+++ b/arch/i386/kernel/signal.c
@@ -199,6 +199,13 @@ asmlinkage int sys_sigreturn(unsigned long __unused)
 	return eax;
 
 badframe:
+	if (show_unhandled_signals && printk_ratelimit())
+		printk("%s%s[%d] bad frame in sigreturn frame:%p eip:%lx"
+		       " esp:%lx oeax:%lx\n",
+		    current->pid > 1 ? KERN_INFO : KERN_EMERG,
+		    current->comm, current->pid, frame, regs->eip,
+		    regs->esp, regs->orig_eax);
+
 	force_sig(SIGSEGV, current);
 	return 0;
 }	
diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
index 18c1c28..c20283c 100644
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -611,6 +611,13 @@ fastcall void __kprobes do_general_protection(struct pt_regs * regs,
 
 	current->thread.error_code = error_code;
 	current->thread.trap_no = 13;
+	if (show_unhandled_signals && unhandled_signal(current, SIGSEGV) &&
+	    printk_ratelimit())
+		printk(KERN_INFO
+		    "%s[%d] general protection eip:%lx esp:%lx error:%lx\n",
+		    current->comm, current->pid,
+		    regs->eip, regs->esp, error_code);
+
 	force_sig(SIGSEGV, current);
 	return;
 
diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
index 1ecb3e4..52c940b 100644
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
@@ -470,6 +472,14 @@ bad_area_nosemaphore:
 		if (is_prefetch(regs, address, error_code))
 			return;
 
+		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit()) {
+			printk("%s%s[%d]: segfault at %08lx eip %08lx "
+			    "esp %08lx error %lx\n",
+			    tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
+			    tsk->comm, tsk->pid, address, regs->eip,
+			    regs->esp, error_code);
+		}
 		tsk->thread.cr2 = address;
 		/* Kernel addresses are always protection faults */
 		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
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
index 74cbeb2..b9660c4 100644
--- a/arch/x86_64/kernel/traps.c
+++ b/arch/x86_64/kernel/traps.c
@@ -580,7 +580,8 @@ static void __kprobes do_trap(int trapnr, int signr, char *str,
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_no = trapnr;
 
-		if (exception_trace && unhandled_signal(tsk, signr))
+		if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
+		    printk_ratelimit())
 			printk(KERN_INFO
 			       "%s[%d] trap %s rip:%lx rsp:%lx error:%lx\n",
 			       tsk->comm, tsk->pid, str,
@@ -684,7 +685,8 @@ asmlinkage void __kprobes do_general_protection(struct pt_regs * regs,
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_no = 13;
 
-		if (exception_trace && unhandled_signal(tsk, SIGSEGV))
+		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit())
 			printk(KERN_INFO
 		       "%s[%d] general protection rip:%lx rsp:%lx error:%lx\n",
 			       tsk->comm, tsk->pid,
diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index 635e58d..0412824 100644
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
@@ -495,7 +485,8 @@ bad_area_nosemaphore:
 		    (address >> 32))
 			return;
 
-		if (exception_trace && unhandled_signal(tsk, SIGSEGV)) {
+		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit()) {
 			printk(
 		       "%s%s[%d]: segfault at %016lx rip %016lx rsp %016lx error %lx\n",
 					tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
index 9a0e98a..5096168 100644
--- a/arch/x86_64/mm/init.c
+++ b/arch/x86_64/mm/init.c
@@ -697,41 +697,6 @@ int kern_addr_valid(unsigned long addr)
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
index ea91abe..0ae3388 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -237,12 +237,15 @@ extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct
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
diff --git a/kernel/signal.c b/kernel/signal.c
index 39d1227..ef8156a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -255,6 +255,16 @@ flush_signal_handlers(struct task_struct *t, int force_default)
 	}
 }
 
+int unhandled_signal(struct task_struct *tsk, int sig)
+{
+	if (is_init(tsk))
+		return 1;
+	if (tsk->ptrace & PT_PTRACED)
+		return 0;
+	return (tsk->sighand->action[sig-1].sa.sa_handler == SIG_IGN) ||
+		(tsk->sighand->action[sig-1].sa.sa_handler == SIG_DFL);
+}
+
 
 /* Notify the system that a driver wants to block all signals for this
  * process, and wants to be notified if any signals at all were to be
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 7063ebc..af7002f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1153,6 +1153,16 @@ static ctl_table fs_table[] = {
 };
 
 static ctl_table debug_table[] = {
+#ifdef CONFIG_X86
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "exception-trace",
+		.data		= &show_unhandled_signals,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
+#endif
 	{ .ctl_name = 0 }
 };
 

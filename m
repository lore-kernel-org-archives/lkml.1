Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbXFEVxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbXFEVxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933760AbXFEVxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:53:06 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14586 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933644AbXFEVxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:53:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:to:subject:message-id:mime-version:
	content-type:content-disposition:user-agent:from;
	b=RxFAlJl59ktZaH/q5b6uNPO0rXbAmADKN8HjeOh7DVgpl+PuRYQ+yx5ZyARQVCXQP
	pwCpQ0acKCwZAtQJnMtYw==
Date: Tue, 5 Jun 2007 14:52:44 -0700
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Make i386 kernel show the segfaults in kernel dmesg, like x86_64.
Message-ID: <20070605215242.GA16967@google.com>
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
debug.exception-trace sysctl variable to 0 (or by doing
echo 0 > /proc/sys/debug/exception-trace)

Same behaviour can be extended to other architectures, if needed.
cheers,
Masoud.

Signed-off-by: Masoud Sharbiani <masouds@google.com>

diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
index 29d7d61..6aa56db 100644
--- a/arch/i386/mm/fault.c
+++ b/arch/i386/mm/fault.c
@@ -283,6 +283,8 @@ static inline int vmalloc_fault(unsigned long address)
 	return 0;
 }
 
+int exception_trace = 1;
+
 /*
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
@@ -464,7 +466,14 @@ bad_area_nosemaphore:
 		 */
 		if (is_prefetch(regs, address, error_code))
 			return;
-
+		if (exception_trace && unhandled_signal(tsk, SIGSEGV)) {
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
index b22ce8d..a300ff8 100644
--- a/arch/i386/mm/init.c
+++ b/arch/i386/mm/init.c
@@ -854,3 +854,39 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 }
 #endif
 
+#ifdef CONFIG_SYSCTL
+#include <linux/sysctl.h>
+
+extern int exception_trace;
+
+static ctl_table debug_table2[] = {
+	{
+		.ctl_name	= 99,
+		.procname	= "exception-trace",
+		.data		= &exception_trace,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
+	{}
+}; 
+
+static ctl_table debug_root_table2[] = { 
+	{
+		.ctl_name = CTL_DEBUG,
+		.procname = "debug",
+		.mode = 0555,
+		.child = debug_table2
+	},
+	{}
+}; 
+
+static __init int i386_sysctl_init(void)
+{ 
+	register_sysctl_table(debug_root_table2);
+	return 0;
+}
+__initcall(i386_sysctl_init);
+#endif
+
+
diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index bfb62a1..863189a 100644
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
index 9a5eac5..1ebe715 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -244,6 +244,8 @@ extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 
 extern struct kmem_cache *sighand_cachep;
 
+int unhandled_signal(struct task_struct *tsk, int sig);
+
 /*
  * In POSIX a signal is sent either to a specific thread (Linux task)
  * or to the process as a whole (Linux thread group).  How the signal
diff --git a/kernel/signal.c b/kernel/signal.c
index 364fc95..6ae6aac 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -174,6 +174,16 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 	return(q);
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
 static void __sigqueue_free(struct sigqueue *q)
 {
 	if (q->flags & SIGQUEUE_PREALLOC)

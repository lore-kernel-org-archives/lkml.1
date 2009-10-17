Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbZJQJ7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbZJQJ7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 05:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZJQJ7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 05:59:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:40409 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbZJQJ7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 05:59:20 -0400
Date: Sat, 17 Oct 2009 09:58:53 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, ananth@in.ibm.com, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: ananth@in.ibm.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, jkenisto@us.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20090908164755.24050.81182.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090908164755.24050.81182.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] kprobes/x86-32: Move irq-exit functions to kprobes section
Message-ID: <tip-a00e817f42663941ea0aa5f85a9d1c4f8b212839@git.kernel.org>
Git-Commit-ID: a00e817f42663941ea0aa5f85a9d1c4f8b212839
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 09:58:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a00e817f42663941ea0aa5f85a9d1c4f8b212839
Gitweb:     http://git.kernel.org/tip/a00e817f42663941ea0aa5f85a9d1c4f8b212839
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 8 Sep 2009 12:47:55 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 11 Sep 2009 03:59:35 +0200

kprobes/x86-32: Move irq-exit functions to kprobes section

Move irq-exit functions to .kprobes.text section to protect against
kprobes recursion.

When I ran kprobe stress test on x86-32, I found below symbols
cause unrecoverable recursive probing:

	ret_from_exception
	ret_from_intr
	check_userspace
	restore_all
	restore_all_notrace
	restore_nocheck
	irq_return

And also, I found some interrupt/exception entry points that
cause similar problems.

This patch moves those symbols (including their container functions)
to .kprobes.text section to prevent any kprobes probing.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20090908164755.24050.81182.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/entry_32.S |   24 ++++++++++++++++++++++++
 kernel/kprobes.c           |    2 ++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c097e7d..beb30da 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -334,6 +334,10 @@ ENTRY(ret_from_fork)
 END(ret_from_fork)
 
 /*
+ * Interrupt exit functions should be protected against kprobes
+ */
+	.pushsection .kprobes.text, "ax"
+/*
  * Return to user mode is not as complex as all this looks,
  * but we want the default path for a system call return to
  * go as quickly as possible which is why some of this is
@@ -383,6 +387,10 @@ need_resched:
 END(resume_kernel)
 #endif
 	CFI_ENDPROC
+/*
+ * End of kprobes section
+ */
+	.popsection
 
 /* SYSENTER_RETURN points to after the "sysenter" instruction in
    the vsyscall page.  See vsyscall-sysentry.S, which defines the symbol.  */
@@ -513,6 +521,10 @@ sysexit_audit:
 	PTGS_TO_GS_EX
 ENDPROC(ia32_sysenter_target)
 
+/*
+ * syscall stub including irq exit should be protected against kprobes
+ */
+	.pushsection .kprobes.text, "ax"
 	# system call handler stub
 ENTRY(system_call)
 	RING0_INT_FRAME			# can't unwind into user space anyway
@@ -705,6 +717,10 @@ syscall_badsys:
 	jmp resume_userspace
 END(syscall_badsys)
 	CFI_ENDPROC
+/*
+ * End of kprobes section
+ */
+	.popsection
 
 /*
  * System calls that need a pt_regs pointer.
@@ -814,6 +830,10 @@ common_interrupt:
 ENDPROC(common_interrupt)
 	CFI_ENDPROC
 
+/*
+ *  Irq entries should be protected against kprobes
+ */
+	.pushsection .kprobes.text, "ax"
 #define BUILD_INTERRUPT3(name, nr, fn)	\
 ENTRY(name)				\
 	RING0_INT_FRAME;		\
@@ -980,6 +1000,10 @@ ENTRY(spurious_interrupt_bug)
 	jmp error_code
 	CFI_ENDPROC
 END(spurious_interrupt_bug)
+/*
+ * End of kprobes section
+ */
+	.popsection
 
 ENTRY(kernel_thread_helper)
 	pushl $0		# fake return address for unwinder
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3267d90..00d01b0 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -91,6 +91,8 @@ static spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
 static struct kprobe_blackpoint kprobe_blacklist[] = {
 	{"preempt_schedule",},
 	{"native_get_debugreg",},
+	{"irq_entries_start",},
+	{"common_interrupt",},
 	{NULL}    /* Terminator */
 };
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751519AbZIHQqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbZIHQqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbZIHQqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:46:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbZIHQql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:46:41 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes] kprobes/x86-32: Move irq-exit functions to
	kprobes section
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 08 Sep 2009 12:47:55 -0400
Message-ID: <20090908164755.24050.81182.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move irq-exit functions to .kprobes.text section for protecting against
kprobes.

When I ran kprobe stress test on x86-32, I found below symbols causes
unrecoverable recursive probing:
ret_from_exception
ret_from_intr
check_userspace
restore_all
restore_all_notrace
restore_nocheck
irq_return

And also, I found some interrupt/exception entry points will cause
problems.

This patch moves those symbols (including its container functions)
to .kprobes.text section for protecting from kprobes probing.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
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
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

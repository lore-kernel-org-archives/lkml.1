Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZIVTlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZIVTlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZIVTiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:38:51 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49576 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZIVTiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pq2x4ydGsz0Ca/WKHVEjjqEVC/I22RJk1NFQsk+dn8dYZoWeU6AQxte4BvDWIPTFFN
         N/Xn3TIaw7XqfkCA2u/jNqFuYAWXr2HfBcEmGDxAXHBWKbF1sWH7CYOSvKpg5zhdHOU/
         xF6G74arqLWII/aWO6VF0Mmi2+0CYH1y0EnLY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 10/24] kprobes/x86-32: Move irq-exit functions to kprobes section
Date: Tue, 22 Sep 2009 21:38:08 +0200
Message-Id: <1253648302-5771-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

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
 
-- 
1.6.2.3


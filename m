Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZKJK0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZKJK0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZKJK0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:26:05 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:63374 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbZKJK0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:26:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NxfZgWu27ZVvzo2AA2t6P8NhW7tm/rvcLVl82c0gdBtUY39aswfuS+dndkycj6daS1
         OIPhKalWDJM5sxV+xQxcX3HsU1gk3ZZaPKhVYDiTGC4HxZ/vhl6TY6JfOqhSuSsHx5xq
         QmH1mD1e+gV8WDklQeWMTuGXAtI9ulxHZ64L0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 2/4] hw-breakpoints: Fix broken a.out format dump
Date: Tue, 10 Nov 2009 11:25:58 +0100
Message-Id: <1257848760-9407-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257848760-9407-1-git-send-email-fweisbec@gmail.com>
References: <1257848760-9407-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the broken a.out format dump. For now we only dump the ptrace
breakpoints.

TODO: Dump every perf breakpoints for the current thread, not only
ptrace based ones.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
---
 arch/x86/include/asm/a.out-core.h |   10 ++--------
 arch/x86/include/asm/debugreg.h   |    2 ++
 arch/x86/kernel/hw_breakpoint.c   |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/a.out-core.h b/arch/x86/include/asm/a.out-core.h
index fc4685d..7a15588 100644
--- a/arch/x86/include/asm/a.out-core.h
+++ b/arch/x86/include/asm/a.out-core.h
@@ -17,6 +17,7 @@
 
 #include <linux/user.h>
 #include <linux/elfcore.h>
+#include <asm/debugreg.h>
 
 /*
  * fill in the user structure for an a.out core dump
@@ -32,14 +33,7 @@ static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 			>> PAGE_SHIFT;
 	dump->u_dsize -= dump->u_tsize;
 	dump->u_ssize = 0;
-	dump->u_debugreg[0] = current->thread.debugreg[0];
-	dump->u_debugreg[1] = current->thread.debugreg[1];
-	dump->u_debugreg[2] = current->thread.debugreg[2];
-	dump->u_debugreg[3] = current->thread.debugreg[3];
-	dump->u_debugreg[4] = 0;
-	dump->u_debugreg[5] = 0;
-	dump->u_debugreg[6] = current->thread.debugreg6;
-	dump->u_debugreg[7] = current->thread.debugreg7;
+	aout_dump_debugregs(dump);
 
 	if (dump->start_stack < TASK_SIZE)
 		dump->u_ssize = ((unsigned long)(TASK_SIZE - dump->start_stack))
diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index 9a3333c..f1b673f 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -89,6 +89,8 @@ static inline void hw_breakpoint_disable(void)
 	set_debugreg(0UL, 3);
 }
 
+extern void aout_dump_debugregs(struct user *dump);
+
 #ifdef CONFIG_KVM
 extern void hw_breakpoint_restore(void);
 #endif
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index e622620..57dcee5 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -376,6 +376,41 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp,
 }
 
 /*
+ * Dump the debug register contents to the user.
+ * We can't dump our per cpu values because it
+ * may contain cpu wide breakpoint, something that
+ * doesn't belong to the current task.
+ *
+ * TODO: include non-ptrace user breakpoints (perf)
+ */
+void aout_dump_debugregs(struct user *dump)
+{
+	int i;
+	int dr7 = 0;
+	struct perf_event *bp;
+	struct arch_hw_breakpoint *info;
+	struct thread_struct *thread = &current->thread;
+
+	for (i = 0; i < HBP_NUM; i++) {
+		bp = thread->ptrace_bps[i];
+
+		if (bp && !bp->attr.disabled) {
+			dump->u_debugreg[i] = bp->attr.bp_addr;
+			info = counter_arch_bp(bp);
+			dr7 |= encode_dr7(i, info->len, info->type);
+		} else {
+			dump->u_debugreg[i] = 0;
+		}
+	}
+
+	dump->u_debugreg[4] = 0;
+	dump->u_debugreg[5] = 0;
+	dump->u_debugreg[6] = current->thread.debugreg6;
+
+	dump->u_debugreg[7] = dr7;
+}
+
+/*
  * Release the user breakpoints used by ptrace
  */
 void flush_ptrace_hw_breakpoint(struct task_struct *tsk)
-- 
1.6.2.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbYGQH3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbYGQH3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYGQH24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:28:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbYGQH2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:28:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 02/23] tracehook: exec
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Windows: all the problems and twice the bugs.
Message-Id: <20080717072820.B14E715411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:28:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves all the ptrace hooks related to exec into tracehook.h inlines.

This also lifts the calls for tracing out of the binfmt load_binary hooks
into search_binary_handler() after it calls into the binfmt module.  This
change has no effect, since all the binfmt modules' load_binary functions
did the call at the end on success, and now search_binary_handler() does
it immediately after return if successful.  We consolidate the repeated
code, and binfmt modules no longer need to import ptrace_notify().

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ia32_aout.c |    6 -----
 fs/binfmt_aout.c          |    6 -----
 fs/binfmt_elf.c           |    6 -----
 fs/binfmt_elf_fdpic.c     |    7 ------
 fs/binfmt_flat.c          |    3 --
 fs/binfmt_som.c           |    2 -
 fs/exec.c                 |   12 +++-------
 include/linux/tracehook.h |   46 +++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 50 insertions(+), 38 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 58cccb6..a0e1dbe 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -441,12 +441,6 @@ beyond_if:
 	regs->r8 = regs->r9 = regs->r10 = regs->r11 =
 	regs->r12 = regs->r13 = regs->r14 = regs->r15 = 0;
 	set_fs(USER_DS);
-	if (unlikely(current->ptrace & PT_PTRACED)) {
-		if (current->ptrace & PT_TRACE_EXEC)
-			ptrace_notify((PTRACE_EVENT_EXEC << 8) | SIGTRAP);
-		else
-			send_sig(SIGTRAP, current, 0);
-	}
 	return 0;
 }
 
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index ba4cddb..204cfd1 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -444,12 +444,6 @@ beyond_if:
 	regs->gp = ex.a_gpvalue;
 #endif
 	start_thread(regs, ex.a_entry, current->mm->start_stack);
-	if (unlikely(current->ptrace & PT_PTRACED)) {
-		if (current->ptrace & PT_TRACE_EXEC)
-			ptrace_notify ((PTRACE_EVENT_EXEC << 8) | SIGTRAP);
-		else
-			send_sig(SIGTRAP, current, 0);
-	}
 	return 0;
 }
 
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d48ff5f..66a2bdc 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -974,12 +974,6 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 #endif
 
 	start_thread(regs, elf_entry, bprm->p);
-	if (unlikely(current->ptrace & PT_PTRACED)) {
-		if (current->ptrace & PT_TRACE_EXEC)
-			ptrace_notify ((PTRACE_EVENT_EXEC << 8) | SIGTRAP);
-		else
-			send_sig(SIGTRAP, current, 0);
-	}
 	retval = 0;
 out:
 	kfree(loc);
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index d051a32..1280d5d 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -433,13 +433,6 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	entryaddr = interp_params.entry_addr ?: exec_params.entry_addr;
 	start_thread(regs, entryaddr, current->mm->start_stack);
 
-	if (unlikely(current->ptrace & PT_PTRACED)) {
-		if (current->ptrace & PT_TRACE_EXEC)
-			ptrace_notify((PTRACE_EVENT_EXEC << 8) | SIGTRAP);
-		else
-			send_sig(SIGTRAP, current, 0);
-	}
-
 	retval = 0;
 
 error:
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 2cb1acd..56372ec 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -920,9 +920,6 @@ static int load_flat_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	
 	start_thread(regs, start_addr, current->mm->start_stack);
 
-	if (current->ptrace & PT_PTRACED)
-		send_sig(SIGTRAP, current, 0);
-
 	return 0;
 }
 
diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
index fdc36bf..68be580 100644
--- a/fs/binfmt_som.c
+++ b/fs/binfmt_som.c
@@ -274,8 +274,6 @@ load_som_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	map_hpux_gateway_page(current,current->mm);
 
 	start_thread_som(regs, som_entry, bprm->p);
-	if (current->ptrace & PT_PTRACED)
-		send_sig(SIGTRAP, current, 0);
 	return 0;
 
 	/* error cleanup */
diff --git a/fs/exec.c b/fs/exec.c
index fd92343..346db53 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -43,7 +43,6 @@
 #include <linux/module.h>
 #include <linux/namei.h>
 #include <linux/proc_fs.h>
-#include <linux/ptrace.h>
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
@@ -51,6 +50,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
+#include <linux/tracehook.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1075,13 +1075,8 @@ EXPORT_SYMBOL(prepare_binprm);
 
 static int unsafe_exec(struct task_struct *p)
 {
-	int unsafe = 0;
-	if (p->ptrace & PT_PTRACED) {
-		if (p->ptrace & PT_PTRACE_CAP)
-			unsafe |= LSM_UNSAFE_PTRACE_CAP;
-		else
-			unsafe |= LSM_UNSAFE_PTRACE;
-	}
+	int unsafe = tracehook_unsafe_exec(p);
+
 	if (atomic_read(&p->fs->count) > 1 ||
 	    atomic_read(&p->files->count) > 1 ||
 	    atomic_read(&p->sighand->count) > 1)
@@ -1218,6 +1213,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			read_unlock(&binfmt_lock);
 			retval = fn(bprm, regs);
 			if (retval >= 0) {
+				tracehook_report_exec(fmt, bprm, regs);
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
 				if (bprm->file)
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index bea0f3e..6276353 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -48,5 +48,51 @@
 
 #include <linux/sched.h>
 #include <linux/ptrace.h>
+#include <linux/security.h>
+struct linux_binprm;
+
+/**
+ * tracehook_unsafe_exec - check for exec declared unsafe due to tracing
+ * @task:		current task doing exec
+ *
+ * Return %LSM_UNSAFE_* bits applied to an exec because of tracing.
+ *
+ * Called with task_lock() held on @task.
+ */
+static inline int tracehook_unsafe_exec(struct task_struct *task)
+{
+	int unsafe = 0;
+	int ptrace = task_ptrace(task);
+	if (ptrace & PT_PTRACED) {
+		if (ptrace & PT_PTRACE_CAP)
+			unsafe |= LSM_UNSAFE_PTRACE_CAP;
+		else
+			unsafe |= LSM_UNSAFE_PTRACE;
+	}
+	return unsafe;
+}
+
+/**
+ * tracehook_report_exec - a successful exec was completed
+ * @fmt:		&struct linux_binfmt that performed the exec
+ * @bprm:		&struct linux_binprm containing exec details
+ * @regs:		user-mode register state
+ *
+ * An exec just completed, we are shortly going to return to user mode.
+ * The freshly initialized register state can be seen and changed in @regs.
+ * The name, file and other pointers in @bprm are still on hand to be
+ * inspected, but will be freed as soon as this returns.
+ *
+ * Called with no locks, but with some kernel resources held live
+ * and a reference on @fmt->module.
+ */
+static inline void tracehook_report_exec(struct linux_binfmt *fmt,
+					 struct linux_binprm *bprm,
+					 struct pt_regs *regs)
+{
+	if (!ptrace_event(PT_TRACE_EXEC, PTRACE_EVENT_EXEC, 0) &&
+	    unlikely(task_ptrace(current) & PT_PTRACED))
+		send_sig(SIGTRAP, current, 0);
+}
 
 #endif	/* <linux/tracehook.h> */

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbZK0Dzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbZK0Dzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 22:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZK0Dzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 22:55:51 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57118 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZK0Dzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 22:55:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OalG0vAj8iSJxJwG0olqTWCOoQeUmJ0myZV7L/JJIgDMFPHMgdSe/UrPIMuWmcvIRx
         lhMrYlWI49Vqw3jFgCfPbK+UG/My6Lg5c0troNVrcHborShDZ5C8QFxOEd86g5PIdN4X
         n8oAQP3K5ZJSiYOcbK0hLywASdz76jVJESJ/0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>
Subject: [PATCH 1/2] hw-breakpoints: Use struct perf_event_attr to define user breakpoints
Date: Fri, 27 Nov 2009 04:55:53 +0100
Message-Id: <1259294154-5197-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In-kernel user breakpoints are created using functions in which we pass
breakpoint parameters as individual variables: address, length and
type.

Although it fits well for x86, this just does not scale across
archictectures that may support this api later as these may have
more or different needs. Pass in a perf_event_attr structure
instead because it is meant to evolve as much as possible into
a generic hardware breakpoint parameter structure.

Reported-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ptrace.c      |   74 +++++++++++++++++++---------------
 include/linux/hw_breakpoint.h |   36 +++++++---------
 kernel/hw_breakpoint.c        |   87 ++++++++--------------------------------
 3 files changed, 75 insertions(+), 122 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 75e0cd8..2941b32 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -593,6 +593,34 @@ static unsigned long ptrace_get_dr7(struct perf_event *bp[])
 	return dr7;
 }
 
+static struct perf_event *
+ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
+			 struct task_struct *tsk)
+{
+	int err;
+	int gen_len, gen_type;
+	DEFINE_BREAKPOINT_ATTR(attr);
+
+	/*
+	 * We shoud have at least an inactive breakpoint at this
+	 * slot. It means the user is writing dr7 without having
+	 * written the address register first
+	 */
+	if (!bp)
+		return ERR_PTR(-EINVAL);
+
+	err = arch_bp_generic_fields(len, type, &gen_len, &gen_type);
+	if (err)
+		return ERR_PTR(err);
+
+	attr = bp->attr;
+	attr.bp_len = gen_len;
+	attr.bp_type = gen_type;
+	attr.disabled = 0;
+
+	return modify_user_hw_breakpoint(bp, &attr, bp->callback, tsk);
+}
+
 /*
  * Handle ptrace writes to debug register 7.
  */
@@ -603,7 +631,6 @@ static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
 	int i, orig_ret = 0, rc = 0;
 	int enabled, second_pass = 0;
 	unsigned len, type;
-	int gen_len, gen_type;
 	struct perf_event *bp;
 
 	data &= ~DR_CONTROL_RESERVED;
@@ -634,33 +661,12 @@ restore:
 			continue;
 		}
 
-		/*
-		 * We shoud have at least an inactive breakpoint at this
-		 * slot. It means the user is writing dr7 without having
-		 * written the address register first
-		 */
-		if (!bp) {
-			rc = -EINVAL;
-			break;
-		}
-
-		rc = arch_bp_generic_fields(len, type, &gen_len, &gen_type);
-		if (rc)
-			break;
-
-		/*
-		 * This is a temporary thing as bp is unregistered/registered
-		 * to simulate modification
-		 */
-		bp = modify_user_hw_breakpoint(bp, bp->attr.bp_addr, gen_len,
-					       gen_type, bp->callback,
-					       tsk, true);
-		thread->ptrace_bps[i] = NULL;
+		bp = ptrace_modify_breakpoint(bp, len, type, tsk);
 
 		/* Incorrect bp, or we have a bug in bp API */
 		if (IS_ERR(bp)) {
 			rc = PTR_ERR(bp);
-			bp = NULL;
+			thread->ptrace_bps[i] = NULL;
 			break;
 		}
 		thread->ptrace_bps[i] = bp;
@@ -707,24 +713,26 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 {
 	struct perf_event *bp;
 	struct thread_struct *t = &tsk->thread;
+	DEFINE_BREAKPOINT_ATTR(attr);
 
 	if (!t->ptrace_bps[nr]) {
 		/*
 		 * Put stub len and type to register (reserve) an inactive but
 		 * correct bp
 		 */
-		bp = register_user_hw_breakpoint(addr, HW_BREAKPOINT_LEN_1,
-						 HW_BREAKPOINT_W,
-						 ptrace_triggered, tsk,
-						 false);
+		attr.bp_addr = addr;
+		attr.bp_len = HW_BREAKPOINT_LEN_1;
+		attr.bp_type = HW_BREAKPOINT_W;
+		attr.disabled = 1;
+
+		bp = register_user_hw_breakpoint(&attr, ptrace_triggered, tsk);
 	} else {
 		bp = t->ptrace_bps[nr];
 		t->ptrace_bps[nr] = NULL;
-		bp = modify_user_hw_breakpoint(bp, addr, bp->attr.bp_len,
-					       bp->attr.bp_type,
-					       bp->callback,
-					       tsk,
-					       bp->attr.disabled);
+
+		attr = bp->attr;
+		attr.bp_addr = addr;
+		bp = modify_user_hw_breakpoint(bp, &attr, bp->callback, tsk);
 	}
 	/*
 	 * CHECKME: the previous code returned -EIO if the addr wasn't a
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index c9f7f7c..5da472e 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -20,6 +20,14 @@ enum {
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 
+/* As it's for in-kernel or ptrace use, we want it to be pinned */
+#define DEFINE_BREAKPOINT_ATTR(name)	\
+struct perf_event_attr name = {		\
+	.type = PERF_TYPE_BREAKPOINT,	\
+	.size = sizeof(name),		\
+	.pinned = 1,			\
+};
+
 static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
 {
 	return bp->attr.bp_addr;
@@ -36,22 +44,16 @@ static inline int hw_breakpoint_len(struct perf_event *bp)
 }
 
 extern struct perf_event *
-register_user_hw_breakpoint(unsigned long addr,
-			    int len,
-			    int type,
+register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_callback_t triggered,
-			    struct task_struct *tsk,
-			    bool active);
+			    struct task_struct *tsk);
 
 /* FIXME: only change from the attr, and don't unregister */
 extern struct perf_event *
 modify_user_hw_breakpoint(struct perf_event *bp,
-			  unsigned long addr,
-			  int len,
-			  int type,
+			  struct perf_event_attr *attr,
 			  perf_callback_t triggered,
-			  struct task_struct *tsk,
-			  bool active);
+			  struct task_struct *tsk);
 
 /*
  * Kernel breakpoints are not associated with any particular thread.
@@ -89,20 +91,14 @@ static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
 #else /* !CONFIG_HAVE_HW_BREAKPOINT */
 
 static inline struct perf_event *
-register_user_hw_breakpoint(unsigned long addr,
-			    int len,
-			    int type,
+register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_callback_t triggered,
-			    struct task_struct *tsk,
-			    bool active)		{ return NULL; }
+			    struct task_struct *tsk)	{ return NULL; }
 static inline struct perf_event *
 modify_user_hw_breakpoint(struct perf_event *bp,
-			  unsigned long addr,
-			  int len,
-			  int type,
+			  struct perf_event_attr *attr,
 			  perf_callback_t triggered,
-			  struct task_struct *tsk,
-			  bool active)			{ return NULL; }
+			  struct task_struct *tsk)	{ return NULL; }
 static inline struct perf_event *
 register_wide_hw_breakpoint_cpu(unsigned long addr,
 				int len,
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 32e1018..2a47514 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -289,90 +289,32 @@ int register_perf_hw_breakpoint(struct perf_event *bp)
 	return __register_perf_hw_breakpoint(bp);
 }
 
-/*
- * Register a breakpoint bound to a task and a given cpu.
- * If cpu is -1, the breakpoint is active for the task in every cpu
- * If the task is -1, the breakpoint is active for every tasks in the given
- * cpu.
- */
-static struct perf_event *
-register_user_hw_breakpoint_cpu(unsigned long addr,
-				int len,
-				int type,
-				perf_callback_t triggered,
-				pid_t pid,
-				int cpu,
-				bool active)
-{
-	struct perf_event_attr *attr;
-	struct perf_event *bp;
-
-	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
-	if (!attr)
-		return ERR_PTR(-ENOMEM);
-
-	attr->type = PERF_TYPE_BREAKPOINT;
-	attr->size = sizeof(*attr);
-	attr->bp_addr = addr;
-	attr->bp_len = len;
-	attr->bp_type = type;
-	/*
-	 * Such breakpoints are used by debuggers to trigger signals when
-	 * we hit the excepted memory op. We can't miss such events, they
-	 * must be pinned.
-	 */
-	attr->pinned = 1;
-
-	if (!active)
-		attr->disabled = 1;
-
-	bp = perf_event_create_kernel_counter(attr, cpu, pid, triggered);
-	kfree(attr);
-
-	return bp;
-}
-
 /**
  * register_user_hw_breakpoint - register a hardware breakpoint for user space
- * @addr: is the memory address that triggers the breakpoint
- * @len: the length of the access to the memory (1 byte, 2 bytes etc...)
- * @type: the type of the access to the memory (read/write/exec)
+ * @attr: breakpoint attributes
  * @triggered: callback to trigger when we hit the breakpoint
  * @tsk: pointer to 'task_struct' of the process to which the address belongs
- * @active: should we activate it while registering it
- *
  */
 struct perf_event *
-register_user_hw_breakpoint(unsigned long addr,
-			    int len,
-			    int type,
+register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_callback_t triggered,
-			    struct task_struct *tsk,
-			    bool active)
+			    struct task_struct *tsk)
 {
-	return register_user_hw_breakpoint_cpu(addr, len, type, triggered,
-					       tsk->pid, -1, active);
+	return perf_event_create_kernel_counter(attr, -1, tsk->pid, triggered);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 
 /**
  * modify_user_hw_breakpoint - modify a user-space hardware breakpoint
  * @bp: the breakpoint structure to modify
- * @addr: is the memory address that triggers the breakpoint
- * @len: the length of the access to the memory (1 byte, 2 bytes etc...)
- * @type: the type of the access to the memory (read/write/exec)
+ * @attr: new breakpoint attributes
  * @triggered: callback to trigger when we hit the breakpoint
  * @tsk: pointer to 'task_struct' of the process to which the address belongs
- * @active: should we activate it while registering it
  */
 struct perf_event *
-modify_user_hw_breakpoint(struct perf_event *bp,
-			  unsigned long addr,
-			  int len,
-			  int type,
+modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr,
 			  perf_callback_t triggered,
-			  struct task_struct *tsk,
-			  bool active)
+			  struct task_struct *tsk)
 {
 	/*
 	 * FIXME: do it without unregistering
@@ -381,8 +323,7 @@ modify_user_hw_breakpoint(struct perf_event *bp,
 	 */
 	unregister_hw_breakpoint(bp);
 
-	return register_user_hw_breakpoint(addr, len, type, triggered,
-					   tsk, active);
+	return perf_event_create_kernel_counter(attr, -1, tsk->pid, triggered);
 }
 EXPORT_SYMBOL_GPL(modify_user_hw_breakpoint);
 
@@ -406,8 +347,16 @@ register_kernel_hw_breakpoint_cpu(unsigned long addr,
 				  int cpu,
 				  bool active)
 {
-	return register_user_hw_breakpoint_cpu(addr, len, type, triggered,
-					       -1, cpu, active);
+	DEFINE_BREAKPOINT_ATTR(attr);
+
+	attr.bp_addr = addr;
+	attr.bp_len = len;
+	attr.bp_type = type;
+
+	if (!active)
+		attr.disabled = 1;
+
+	return perf_event_create_kernel_counter(&attr, cpu, -1, triggered);
 }
 
 /**
-- 
1.6.2.3


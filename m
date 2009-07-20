Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZGTRIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZGTRIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZGTRIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:08:23 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:3150 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbZGTRIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sUc3zLI91bwfMWXbR1BeOEYBfPj6EA9zIduhNXvKBxLxB9fNmVAsj12yT0mUsB2YUP
         EFot3aQO+MYY93qkgBUgez4PcyLqG5cbX6t/j65re7xgW+8zQc0+HFinNxnADP5ZAE5m
         vBhehQraR/ugbeww2fezFlV+RLVqSNlFaTea4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linuxtronix.de>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC][PATCH 1/5] hw-breakpoints: Make kernel breakpoints API truly generic
Date: Mon, 20 Jul 2009 13:08:03 -0400
Message-Id: <1248109687-7808-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To define a kernel hardware breakpoint, one need to define the
address, type and length of the breakpoint using arch specific
operations and then register it using a core helper.

The first stage is truly not scalable with respect to the number of
archictures, because for each of them that support hardware
breakpoints, we would need a seperate specific field definition for
the breakpoint.

However, the supported breakpoint functionalities may be very different
between architectures.
Then this new API tries to compose with the following constraints:

- a given architecture may perhaps not support the triggering on one
  of the usual memory access (read-write/read/write/execute)

- a given architecture may perhaps not support the ability to trigger
  a breakpoint only on specific memory access size lower than the word
  size for this arch.

- a given architecture may perhaps not support breakpoints on addresses
  range.

The new API changes the following prototype for a kernel breakpoint
registration:

 int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)

into:

 int register_kernel_hw_breakpoint(struct hw_breakpoint *bp,
                                   unsigned long addr,
				   int len, enum breakpoint_type type)

The choice of passing the breakpoint settings as parameters of the
registration helper and not by adding generic fields into the breakpoint
structure is motivated by the need of a very specific per arch
representation of the breakpoint:

- the arch may only need an address, but could also need a couple for
  breakpoints in ranges.
- the type is subject to arch interpretation (values of debug registers)
- the length too.

Then, to get back these values from a generic breakpoint structure that have
specific encodings into the arch fields, this API comes along with abstract
accessors which implementation is arch specific:

- type hw_breakpoint_type(bp)
- addr hw_breakpoint_addr(bp)

However, open debates come along this RFC patch:

- the address could be a generic field in struct hw_breakpoint. If we
  are dealing with a range breakpoint, then we would just need to
  compute addr + length to get the end of the range.

- the length and type could also be generic fields of
  struct hw_breakpoint. It would then be up to the arch to get a
  translation between such generic values and per arch needs.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/hw_breakpoint.h    |    8 +++
 arch/x86/kernel/hw_breakpoint.c         |   62 +++++++++++++++++++
 include/asm-generic/hw_breakpoint.h     |   99 ++++++++++---------------------
 kernel/hw_breakpoint.c                  |   12 +++-
 kernel/trace/trace.h                    |    5 +-
 kernel/trace/trace_ksym.c               |   53 ++++++++--------
 kernel/trace/trace_selftest.c           |    2 +-
 samples/hw_breakpoint/data_breakpoint.c |    6 +--
 8 files changed, 142 insertions(+), 105 deletions(-)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 1acb4d4..5f5f67d 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -43,6 +43,8 @@ extern unsigned int hbp_user_refcount[HBP_NUM];
 extern void arch_install_thread_hw_breakpoint(struct task_struct *tsk);
 extern void arch_uninstall_thread_hw_breakpoint(void);
 extern int arch_check_va_in_userspace(unsigned long va, u8 hbp_len);
+extern int arch_fill_hw_breakpoint(struct hw_breakpoint *bp, unsigned long addr,
+				   int len, enum breakpoint_type type);
 extern int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
 						struct task_struct *tsk);
 extern void arch_update_user_hw_breakpoint(int pos, struct task_struct *tsk);
@@ -50,6 +52,12 @@ extern void arch_flush_thread_hw_breakpoint(struct task_struct *tsk);
 extern void arch_update_kernel_hw_breakpoint(void *);
 extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
 				     unsigned long val, void *data);
+/*
+ * Typical accessors
+ */
+extern enum breakpoint_type hw_breakpoint_type(struct hw_breakpoint *bp);
+extern unsigned long hw_breakpoint_addr(struct hw_breakpoint *bp);
+
 #endif	/* __KERNEL__ */
 #endif	/* _I386_HW_BREAKPOINT_H */
 
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 9316a9d..04c0661 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -68,6 +68,25 @@ static unsigned long encode_dr7(int drnum, unsigned int len, unsigned int type)
 	return bp_info;
 }
 
+enum breakpoint_type hw_breakpoint_type(struct hw_breakpoint *bp)
+{
+	switch (bp->info.type) {
+	case HW_BREAKPOINT_EXECUTE:
+		return BREAK_X;
+	case HW_BREAKPOINT_WRITE:
+		return BREAK_W;
+	case HW_BREAKPOINT_RW:
+		return BREAK_RW;
+	default:
+		return -EINVAL;
+	}
+}
+
+unsigned long hw_breakpoint_addr(struct hw_breakpoint *bp)
+{
+	return bp->info.address;
+}
+
 void arch_update_kernel_hw_breakpoint(void *unused)
 {
 	struct hw_breakpoint *bp;
@@ -198,6 +217,49 @@ static int arch_store_info(struct hw_breakpoint *bp, struct task_struct *tsk)
 	return -EINVAL;
 }
 
+int arch_fill_hw_breakpoint(struct hw_breakpoint *bp, unsigned long addr,
+			    int len, enum breakpoint_type type)
+{
+	bp->info.address = addr;
+	switch (len) {
+	case 1:
+		bp->info.len = HW_BREAKPOINT_LEN_1;
+		break;
+	case 2:
+		bp->info.len = HW_BREAKPOINT_LEN_2;
+		break;
+	case 4:
+		bp->info.len = HW_BREAKPOINT_LEN_4;
+		break;
+#ifdef CONFIG_X86_64
+	case 8:
+		bp->info.len = HW_BREAKPOINT_LEN_8;
+		break;
+#else
+		return -ENOSYS;
+#endif
+	default:
+		return -EINVAL;
+	}
+
+	switch (type) {
+	case BREAK_W:
+		bp->info.type = HW_BREAKPOINT_WRITE;
+		break;
+	case BREAK_X:
+		bp->info.type = HW_BREAKPOINT_EXECUTE;
+		break;
+	case BREAK_RW:
+		bp->info.type = HW_BREAKPOINT_RW;
+		break;
+	case BREAK_R:
+		return -ENOSYS;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
 /*
  * Validate the arch-specific HW Breakpoint register settings
  */
diff --git a/include/asm-generic/hw_breakpoint.h b/include/asm-generic/hw_breakpoint.h
index 9bf2d12..ad860d7 100644
--- a/include/asm-generic/hw_breakpoint.h
+++ b/include/asm-generic/hw_breakpoint.h
@@ -10,6 +10,13 @@
 #include <linux/types.h>
 #include <linux/kallsyms.h>
 
+enum breakpoint_type {
+	BREAK_X,
+	BREAK_W,
+	BREAK_R,
+	BREAK_RW,
+};
+
 /**
  * struct hw_breakpoint - unified kernel/user-space hardware breakpoint
  * @triggered: callback invoked after target address access
@@ -21,13 +28,11 @@
  * target address can be located in either kernel space or user space.
  *
  * The breakpoint's address, length, and type are highly
- * architecture-specific.  The values are encoded in the @info field; you
- * specify them when registering the breakpoint.  To examine the encoded
- * values use hw_breakpoint_get_{kaddress,uaddress,len,type}(), declared
- * below.
+ * architecture-specific.  The arch specific values are encoded in the @info
+ * field but are abstracted by the register helpers.  To examine the encoded
+ * values, use hw_breakpoint_{type,address}(), declared in
+ * arch/ * /include/asm/hw_breakpoint.h
  *
- * The address is specified as a regular kernel pointer (for kernel-space
- * breakponts) or as an %__user pointer (for user-space breakpoints).
  * With register_user_hw_breakpoint(), the address must refer to a
  * location in user space.  The breakpoint will be active only while the
  * requested task is running.  Conversely with
@@ -35,23 +40,23 @@
  * in kernel space, and the breakpoint will be active on all CPUs
  * regardless of the current task.
  *
+ * While calling a breakpoint register helper, you have to provide the type
+ * and the length of your breakpoint as parameters.
+ *
  * The length is the breakpoint's extent in bytes, which is subject to
- * certain limitations.  include/asm/hw_breakpoint.h contains macros
- * defining the available lengths for a specific architecture.  Note that
- * the address's alignment must match the length.  The breakpoint will
- * catch accesses to any byte in the range from address to address +
- * (length - 1).
+ * certain limitations. Note that the address's alignment must match the length.
+ * The breakpoint will catch accesses to any byte in the range from address to
+ * address + (length - 1).
  *
  * The breakpoint's type indicates the sort of access that will cause it
  * to trigger.  Possible values may include:
  *
- * 	%HW_BREAKPOINT_RW (triggered on read or write access),
- * 	%HW_BREAKPOINT_WRITE (triggered on write access), and
- * 	%HW_BREAKPOINT_READ (triggered on read access).
+ * 	%BREAK_RW (triggered on read or write access).
+ * 	%BREAK_W (triggered on write access).
+ * 	%BREAK_R (triggered on read access).
+ *	%BREAK_X (triggered on execute access).
  *
- * Appropriate macros are defined in include/asm/hw_breakpoint.h; not all
- * possibilities are available on all architectures.  Execute breakpoints
- * must have length equal to the special value %HW_BREAKPOINT_LEN_EXECUTE.
+ * Not all possibilities are available on all architectures.
  *
  * When a breakpoint gets hit, the @triggered callback is
  * invoked in_interrupt with a pointer to the %hw_breakpoint structure and the
@@ -60,45 +65,6 @@
  * Breakpoints are disabled during execution @triggered, to avoid
  * recursive traps and allow unhindered access to breakpointed memory.
  *
- * This sample code sets a breakpoint on pid_max and registers a callback
- * function for writes to that variable.  Note that it is not portable
- * as written, because not all architectures support HW_BREAKPOINT_LEN_4.
- *
- * ----------------------------------------------------------------------
- *
- * #include <asm/hw_breakpoint.h>
- *
- * struct hw_breakpoint my_bp;
- *
- * static void my_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
- * {
- * 	printk(KERN_DEBUG "Inside triggered routine of breakpoint exception\n");
- * 	dump_stack();
- *  	.......<more debugging output>........
- * }
- *
- * static struct hw_breakpoint my_bp;
- *
- * static int init_module(void)
- * {
- *	..........<do anything>............
- *	my_bp.info.type = HW_BREAKPOINT_WRITE;
- *	my_bp.info.len = HW_BREAKPOINT_LEN_4;
- *
- *	my_bp.installed = (void *)my_bp_installed;
- *
- *	rc = register_kernel_hw_breakpoint(&my_bp);
- *	..........<do anything>............
- * }
- *
- * static void cleanup_module(void)
- * {
- *	..........<do anything>............
- *	unregister_kernel_hw_breakpoint(&my_bp);
- *	..........<do anything>............
- * }
- *
- * ----------------------------------------------------------------------
  */
 struct hw_breakpoint {
 	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
@@ -106,19 +72,14 @@ struct hw_breakpoint {
 };
 
 /*
- * len and type values are defined in include/asm/hw_breakpoint.h.
- * Available values vary according to the architecture.  On i386 the
- * possibilities are:
+ * len and type supported values vary according to the architecture.
+ * On x86 the possibilities are:
  *
- *	HW_BREAKPOINT_LEN_1
- *	HW_BREAKPOINT_LEN_2
- *	HW_BREAKPOINT_LEN_4
- *	HW_BREAKPOINT_RW
- *	HW_BREAKPOINT_READ
+ *	Len: 1, 2, 4
+ *	Type: BREAK_RW, BREAK_W, BREAK_X
  *
- * On other architectures HW_BREAKPOINT_LEN_8 may be available, and the
- * 1-, 2-, and 4-byte lengths may be unavailable.  There also may be
- * HW_BREAKPOINT_WRITE.  You can use #ifdef to check at compile time.
+ * On other architectures, an 8 length may be available, and the
+ * 1-, 2-, and 4-byte lengths may be unavailable.
  */
 
 extern int register_user_hw_breakpoint(struct task_struct *tsk,
@@ -130,7 +91,9 @@ extern void unregister_user_hw_breakpoint(struct task_struct *tsk,
 /*
  * Kernel breakpoints are not associated with any particular thread.
  */
-extern int register_kernel_hw_breakpoint(struct hw_breakpoint *bp);
+extern int
+register_kernel_hw_breakpoint(struct hw_breakpoint *bp, unsigned long addr,
+			      int len, enum breakpoint_type type);
 extern void unregister_kernel_hw_breakpoint(struct hw_breakpoint *bp);
 
 extern unsigned int hbp_kernel_pos;
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index c1f64e6..015fec6 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -297,15 +297,21 @@ EXPORT_SYMBOL_GPL(unregister_user_hw_breakpoint);
 /**
  * register_kernel_hw_breakpoint - register a hardware breakpoint for kernel space
  * @bp: the breakpoint structure to register
- *
- * @bp.info->name or @bp.info->address, @bp.info->len, @bp.info->type and
+ * @addr: the address where we want to set the breakpoint
+ * @len: length of the value in memory to break in
+ * @type: the type of the breakpoint (read/write/execute)
  * @bp->triggered must be set properly before invocation
  *
  */
-int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
+int register_kernel_hw_breakpoint(struct hw_breakpoint *bp, unsigned long addr,
+				  int len, enum breakpoint_type type)
 {
 	int rc;
 
+	rc = arch_fill_hw_breakpoint(bp, addr, len, type);
+	if (rc)
+		return rc;
+
 	rc = arch_validate_hwbkpt_settings(bp, NULL);
 	if (rc)
 		return rc;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 06886a0..0253691 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -213,12 +213,13 @@ struct syscall_trace_exit {
 };
 
 #define KSYM_SELFTEST_ENTRY "ksym_selftest_dummy"
-extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
+extern int process_new_ksym_entry(char *ksymname, enum breakpoint_type type,
+				  unsigned long addr);
 
 struct ksym_trace_entry {
 	struct trace_entry	ent;
 	unsigned long		ip;
-	unsigned char		type;
+	enum breakpoint_type	type;
 	char			ksym_name[KSYM_NAME_LEN];
 	char			cmd[TASK_COMM_LEN];
 };
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 1256a6e..7829a9b 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -95,12 +95,12 @@ void ksym_hbp_handler(struct hw_breakpoint *hbp, struct pt_regs *regs)
 
 	entry		= ring_buffer_event_data(event);
 	entry->ip	= instruction_pointer(regs);
-	entry->type	= hbp->info.type;
+	entry->type	= hw_breakpoint_type(hbp);
 	strlcpy(entry->ksym_name, hbp->info.name, KSYM_SYMBOL_LEN);
 	strlcpy(entry->cmd, current->comm, TASK_COMM_LEN);
 
 #ifdef CONFIG_PROFILE_KSYM_TRACER
-	ksym_collect_stats(hbp->info.address);
+	ksym_collect_stats(hw_breakpoint_addr(hbp));
 #endif /* CONFIG_PROFILE_KSYM_TRACER */
 
 	trace_buffer_unlock_commit(tr, event, 0, pc);
@@ -117,6 +117,7 @@ void ksym_hbp_handler(struct hw_breakpoint *hbp, struct pt_regs *regs)
 static int ksym_trace_get_access_type(char *str)
 {
 	int access = 0;
+	enum breakpoint_type type;
 
 	if (str[0] == 'r')
 		access += 4;
@@ -133,14 +134,16 @@ static int ksym_trace_get_access_type(char *str)
 
 	switch (access) {
 	case 6:
-		access = HW_BREAKPOINT_RW;
+		type = BREAK_RW;
 		break;
 	case 2:
-		access = HW_BREAKPOINT_WRITE;
+		type = BREAK_W;
 		break;
+	default:
+		type = -EINVAL;
 	}
 
-	return access;
+	return type;
 }
 
 /*
@@ -176,7 +179,8 @@ static int parse_ksym_trace_str(char *input_string, char **ksymname,
 	return ret;
 }
 
-int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
+int process_new_ksym_entry(char *ksymname, enum breakpoint_type type,
+			   unsigned long addr)
 {
 	struct trace_ksym *entry;
 	int ret = -ENOMEM;
@@ -200,14 +204,10 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 	if (!entry->ksym_hbp->info.name)
 		goto err;
 
-	entry->ksym_hbp->info.type = op;
-	entry->ksym_addr = entry->ksym_hbp->info.address = addr;
-#ifdef CONFIG_X86
-	entry->ksym_hbp->info.len = HW_BREAKPOINT_LEN_4;
-#endif
+	entry->ksym_addr = addr;
 	entry->ksym_hbp->triggered = (void *)ksym_hbp_handler;
 
-	ret = register_kernel_hw_breakpoint(entry->ksym_hbp);
+	ret = register_kernel_hw_breakpoint(entry->ksym_hbp, addr, 4, type);
 	if (ret < 0) {
 		printk(KERN_INFO "ksym_tracer request failed. Try again"
 					" later!!\n");
@@ -243,9 +243,9 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
 		ret = trace_seq_printf(s, "%s:", entry->ksym_hbp->info.name);
-		if (entry->ksym_hbp->info.type == HW_BREAKPOINT_WRITE)
+		if (hw_breakpoint_type(entry->ksym_hbp) == BREAK_W)
 			ret = trace_seq_puts(s, "-w-\n");
-		else if (entry->ksym_hbp->info.type == HW_BREAKPOINT_RW)
+		else if (hw_breakpoint_type(entry->ksym_hbp) == BREAK_RW)
 			ret = trace_seq_puts(s, "rw-\n");
 		WARN_ON_ONCE(!ret);
 	}
@@ -267,7 +267,8 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	struct hlist_node *node;
 	char *input_string, *ksymname = NULL;
 	unsigned long ksym_addr = 0;
-	int ret, op, changed = 0;
+	int ret, changed = 0;
+	enum breakpoint_type type;
 
 	input_string = kzalloc(count + 1, GFP_KERNEL);
 	if (!input_string)
@@ -279,7 +280,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	}
 	input_string[count] = '\0';
 
-	ret = op = parse_ksym_trace_str(input_string, &ksymname, &ksym_addr);
+	ret = type = parse_ksym_trace_str(input_string, &ksymname, &ksym_addr);
 	if (ret < 0) {
 		kfree(input_string);
 		return ret;
@@ -291,7 +292,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
 		if (entry->ksym_addr == ksym_addr) {
 			/* Check for malformed request: (6) */
-			if (entry->ksym_hbp->info.type != op)
+			if (hw_breakpoint_type(entry->ksym_hbp) != type)
 				changed = 1;
 			else
 				goto out;
@@ -300,9 +301,9 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	}
 	if (changed) {
 		unregister_kernel_hw_breakpoint(entry->ksym_hbp);
-		entry->ksym_hbp->info.type = op;
-		if (op > 0) {
-			ret = register_kernel_hw_breakpoint(entry->ksym_hbp);
+		if (type >= 0) {
+			ret = register_kernel_hw_breakpoint(entry->ksym_hbp,
+							    ksym_addr, 4, type);
 			if (ret == 0)
 				goto out;
 		}
@@ -315,9 +316,9 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 		goto out;
 	} else {
 		/* Check for malformed request: (4) */
-		if (op == 0)
+		if (type < 0)
 			goto out;
-		ret = process_new_ksym_entry(ksymname, op, ksym_addr);
+		ret = process_new_ksym_entry(ksymname, type, ksym_addr);
 	}
 out:
 	mutex_unlock(&ksym_tracer_mutex);
@@ -398,10 +399,10 @@ static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	switch (field->type) {
-	case HW_BREAKPOINT_WRITE:
+	case BREAK_W:
 		ret = trace_seq_printf(s, " W  ");
 		break;
-	case HW_BREAKPOINT_RW:
+	case BREAK_RW:
 		ret = trace_seq_printf(s, " RW ");
 		break;
 	default:
@@ -464,13 +465,13 @@ static int ksym_tracer_stat_show(struct seq_file *m, void *v)
 {
 	struct hlist_node *stat = v;
 	struct trace_ksym *entry;
-	int access_type = 0;
+	enum breakpoint_type access_type = -1;
 	char fn_name[KSYM_NAME_LEN];
 
 	entry = hlist_entry(stat, struct trace_ksym, ksym_hlist);
 
 	if (entry->ksym_hbp)
-		access_type = entry->ksym_hbp->info.type;
+		access_type = hw_breakpoint_type(entry->ksym_hbp);
 
 	switch (access_type) {
 	case HW_BREAKPOINT_WRITE:
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 71f2edb..01cfdd9 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -827,7 +827,7 @@ trace_selftest_startup_ksym(struct tracer *trace, struct trace_array *tr)
 
 	ksym_selftest_dummy = 0;
 	/* Register the read-write tracing request */
-	ret = process_new_ksym_entry(KSYM_SELFTEST_ENTRY, HW_BREAKPOINT_RW,
+	ret = process_new_ksym_entry(KSYM_SELFTEST_ENTRY, BREAK_RW,
 					(unsigned long)(&ksym_selftest_dummy));
 
 	if (ret < 0) {
diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
index 9cbdbb8..9f0e210 100644
--- a/samples/hw_breakpoint/data_breakpoint.c
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -51,14 +51,10 @@ static int __init hw_break_module_init(void)
 
 #ifdef CONFIG_X86
 	sample_hbp.info.name = ksym_name;
-	sample_hbp.info.type = HW_BREAKPOINT_WRITE;
-	sample_hbp.info.len = HW_BREAKPOINT_LEN_4;
 #endif /* CONFIG_X86 */
-
 	sample_hbp.triggered = (void *)sample_hbp_handler;
 
-	ret = register_kernel_hw_breakpoint(&sample_hbp);
-
+	ret = register_kernel_hw_breakpoint(&sample_hbp, 0, 4, BREAK_W);
 	if (ret < 0) {
 		printk(KERN_INFO "Breakpoint registration failed\n");
 		return ret;
-- 
1.6.2.3


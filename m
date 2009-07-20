Return-Path: <linux-kernel-owner+w=401wt.eu-S1751919AbZGTROB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbZGTROB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZGTROA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:14:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:62245 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbZGTRN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:13:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K7fciTfHlQvVJsKg3950smipcQg/vjbTh1joqM+3YOyMPewDna/+PEYkYmHUQlWLPK
         CIud067CNHZuNoul+E1eoj7ZD5X3bslP5sQiXjDGiPCkFSVYvtB6RjvYAzNOO8L70WUC
         jCORktq+f1kVpqRvsBUE1DA3Sty5ybO/sWRCw=
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
Subject: [RFC][PATCH 2/5] hw-breakpoints: Pull up the target symbol in a generic field
Date: Mon, 20 Jul 2009 13:08:04 -0400
Message-Id: <1248109687-7808-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The target symbol of a breakpoint doesn't need to be arch specific.
It can be resolved back from the core, then this patch pulls
up this job to the core, avoiding the need to implement that from
arch.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/hw_breakpoint.h    |    1 -
 arch/x86/kernel/hw_breakpoint.c         |   35 ++++--------------------------
 include/asm-generic/hw_breakpoint.h     |    1 +
 kernel/hw_breakpoint.c                  |   17 +++++++++++++++
 kernel/trace/trace_ksym.c               |   14 ++++++------
 samples/hw_breakpoint/data_breakpoint.c |    4 +--
 6 files changed, 31 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 5f5f67d..a51c5ff 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -5,7 +5,6 @@
 #define	__ARCH_HW_BREAKPOINT_H
 
 struct arch_hw_breakpoint {
-	char		*name; /* Contains name of the symbol to set bkpt */
 	unsigned long	address;
 	u8		len;
 	u8		type;
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 04c0661..65754c9 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -195,28 +195,9 @@ static int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
 }
 
 /*
- * Store a breakpoint's encoded address, length, and type.
+ * Pick breakpoint's generic address, length, and type and convert them
+ * into x86 specific debug register values.
  */
-static int arch_store_info(struct hw_breakpoint *bp, struct task_struct *tsk)
-{
-	/*
-	 * User-space requests will always have the address field populated
-	 * Symbol names from user-space are rejected
-	 */
-	if (tsk && bp->info.name)
-		return -EINVAL;
-	/*
-	 * For kernel-addresses, either the address or symbol name can be
-	 * specified.
-	 */
-	if (bp->info.name)
-		bp->info.address = (unsigned long)
-					kallsyms_lookup_name(bp->info.name);
-	if (bp->info.address)
-		return 0;
-	return -EINVAL;
-}
-
 int arch_fill_hw_breakpoint(struct hw_breakpoint *bp, unsigned long addr,
 			    int len, enum breakpoint_type type)
 {
@@ -267,7 +248,6 @@ int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
 						struct task_struct *tsk)
 {
 	unsigned int align;
-	int ret = -EINVAL;
 
 	switch (bp->info.type) {
 	/*
@@ -279,14 +259,14 @@ int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
 		if ((!arch_check_va_in_userspace(bp->info.address,
 							bp->info.len)) &&
 			bp->info.len != HW_BREAKPOINT_LEN_EXECUTE)
-			return ret;
+			return -EINVAL;
 		break;
 	case HW_BREAKPOINT_WRITE:
 		break;
 	case HW_BREAKPOINT_RW:
 		break;
 	default:
-		return ret;
+		return -EINVAL;
 	}
 
 	switch (bp->info.len) {
@@ -305,14 +285,9 @@ int arch_validate_hwbkpt_settings(struct hw_breakpoint *bp,
 		break;
 #endif
 	default:
-		return ret;
+		return -EINVAL;
 	}
 
-	if (bp->triggered)
-		ret = arch_store_info(bp, tsk);
-
-	if (ret < 0)
-		return ret;
 	/*
 	 * Check that the low-order bits of the address are appropriate
 	 * for the alignment implied by len.
diff --git a/include/asm-generic/hw_breakpoint.h b/include/asm-generic/hw_breakpoint.h
index ad860d7..300fe4c 100644
--- a/include/asm-generic/hw_breakpoint.h
+++ b/include/asm-generic/hw_breakpoint.h
@@ -67,6 +67,7 @@ enum breakpoint_type {
  *
  */
 struct hw_breakpoint {
+	char	*name; /* Contains name of the symbol to set breakpoint */
 	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
 	struct arch_hw_breakpoint info;
 };
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 015fec6..0301245 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -225,6 +225,13 @@ int register_user_hw_breakpoint(struct task_struct *tsk,
 	struct thread_struct *thread = &(tsk->thread);
 	int i, rc = -ENOSPC;
 
+	/*
+	 * User-space requests will always have the address field populated
+	 * Symbol names from user-space are rejected
+	 */
+	if (bp->name || !bp->triggered)
+		return -EINVAL;
+
 	spin_lock_bh(&hw_breakpoint_lock);
 
 	for (i = 0; i < hbp_kernel_pos; i++) {
@@ -308,6 +315,16 @@ int register_kernel_hw_breakpoint(struct hw_breakpoint *bp, unsigned long addr,
 {
 	int rc;
 
+	/*
+	 * For kernel-addresses, either the address or symbol name can be
+	 * specified.
+	 */
+	if (bp->name)
+		addr = (unsigned long) kallsyms_lookup_name(bp->name);
+
+	if (!addr || !bp->triggered)
+		return -EINVAL;
+
 	rc = arch_fill_hw_breakpoint(bp, addr, len, type);
 	if (rc)
 		return rc;
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 7829a9b..9bd2845 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -96,7 +96,7 @@ void ksym_hbp_handler(struct hw_breakpoint *hbp, struct pt_regs *regs)
 	entry		= ring_buffer_event_data(event);
 	entry->ip	= instruction_pointer(regs);
 	entry->type	= hw_breakpoint_type(hbp);
-	strlcpy(entry->ksym_name, hbp->info.name, KSYM_SYMBOL_LEN);
+	strlcpy(entry->ksym_name, hbp->name, KSYM_SYMBOL_LEN);
 	strlcpy(entry->cmd, current->comm, TASK_COMM_LEN);
 
 #ifdef CONFIG_PROFILE_KSYM_TRACER
@@ -200,8 +200,8 @@ int process_new_ksym_entry(char *ksymname, enum breakpoint_type type,
 	if (!entry->ksym_hbp)
 		goto err;
 
-	entry->ksym_hbp->info.name = kstrdup(ksymname, GFP_KERNEL);
-	if (!entry->ksym_hbp->info.name)
+	entry->ksym_hbp->name = kstrdup(ksymname, GFP_KERNEL);
+	if (!entry->ksym_hbp->name)
 		goto err;
 
 	entry->ksym_addr = addr;
@@ -219,7 +219,7 @@ int process_new_ksym_entry(char *ksymname, enum breakpoint_type type,
 	return 0;
 err:
 	if (entry->ksym_hbp)
-		kfree(entry->ksym_hbp->info.name);
+		kfree(entry->ksym_hbp->name);
 	kfree(entry->ksym_hbp);
 	kfree(entry);
 	return ret;
@@ -242,7 +242,7 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 	mutex_lock(&ksym_tracer_mutex);
 
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
-		ret = trace_seq_printf(s, "%s:", entry->ksym_hbp->info.name);
+		ret = trace_seq_printf(s, "%s:", entry->ksym_hbp->name);
 		if (hw_breakpoint_type(entry->ksym_hbp) == BREAK_W)
 			ret = trace_seq_puts(s, "-w-\n");
 		else if (hw_breakpoint_type(entry->ksym_hbp) == BREAK_RW)
@@ -310,7 +310,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
-		kfree(entry->ksym_hbp->info.name);
+		kfree(entry->ksym_hbp->name);
 		kfree(entry->ksym_hbp);
 		kfree(entry);
 		goto out;
@@ -350,7 +350,7 @@ static void ksym_trace_reset(struct trace_array *tr)
 		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
-		kfree(entry->ksym_hbp->info.name);
+		kfree(entry->ksym_hbp->name);
 		kfree(entry->ksym_hbp);
 		kfree(entry);
 	}
diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
index 9f0e210..3901e98 100644
--- a/samples/hw_breakpoint/data_breakpoint.c
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -49,9 +49,7 @@ static int __init hw_break_module_init(void)
 {
 	int ret;
 
-#ifdef CONFIG_X86
-	sample_hbp.info.name = ksym_name;
-#endif /* CONFIG_X86 */
+	sample_hbp.name = ksym_name;
 	sample_hbp.triggered = (void *)sample_hbp_handler;
 
 	ret = register_kernel_hw_breakpoint(&sample_hbp, 0, 4, BREAK_W);
-- 
1.6.2.3


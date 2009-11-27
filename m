Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbZK0Ftz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbZK0Ftz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 00:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbZK0Ftz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 00:49:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:57866 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZK0Ftv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 00:49:51 -0500
Date: Fri, 27 Nov 2009 05:49:17 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <1259294154-5197-2-git-send-regression-fweisbec@gmail.com>
References: <1259294154-5197-2-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw-breakpoints: Use struct perf_event_attr to define kernel breakpoints
Message-ID: <tip-dd1853c3f493f6d22d9e5390b192a07b73d2ac0a@git.kernel.org>
Git-Commit-ID: dd1853c3f493f6d22d9e5390b192a07b73d2ac0a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd1853c3f493f6d22d9e5390b192a07b73d2ac0a
Gitweb:     http://git.kernel.org/tip/dd1853c3f493f6d22d9e5390b192a07b73d2ac0a
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 27 Nov 2009 04:55:54 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 27 Nov 2009 06:22:59 +0100

hw-breakpoints: Use struct perf_event_attr to define kernel breakpoints

Kernel breakpoints are created using functions in which we pass
breakpoint parameters as individual variables: address, length
and type.

Although it fits well for x86, this just does not scale across
architectures that may support this api later as these may have
more or different needs. Pass in a perf_event_attr structure
instead because it is meant to evolve as much as possible into
a generic hardware breakpoint parameter structure.

Reported-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1259294154-5197-2-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/hw_breakpoint.h           |   35 +++++++++++--------------
 kernel/hw_breakpoint.c                  |   35 +++----------------------
 kernel/trace/trace_ksym.c               |   42 ++++++++++++++----------------
 samples/hw_breakpoint/data_breakpoint.c |   10 +++---
 4 files changed, 44 insertions(+), 78 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 5da472e..a03daed 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -28,6 +28,13 @@ struct perf_event_attr name = {		\
 	.pinned = 1,			\
 };
 
+static inline void hw_breakpoint_init(struct perf_event_attr *attr)
+{
+	attr->type = PERF_TYPE_BREAKPOINT;
+	attr->size = sizeof(*attr);
+	attr->pinned = 1;
+}
+
 static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
 {
 	return bp->attr.bp_addr;
@@ -59,19 +66,13 @@ modify_user_hw_breakpoint(struct perf_event *bp,
  * Kernel breakpoints are not associated with any particular thread.
  */
 extern struct perf_event *
-register_wide_hw_breakpoint_cpu(unsigned long addr,
-				int len,
-				int type,
+register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_callback_t triggered,
-				int cpu,
-				bool active);
+				int cpu);
 
 extern struct perf_event **
-register_wide_hw_breakpoint(unsigned long addr,
-			    int len,
-			    int type,
-			    perf_callback_t triggered,
-			    bool active);
+register_wide_hw_breakpoint(struct perf_event_attr *attr,
+			    perf_callback_t triggered);
 
 extern int register_perf_hw_breakpoint(struct perf_event *bp);
 extern int __register_perf_hw_breakpoint(struct perf_event *bp);
@@ -100,18 +101,12 @@ modify_user_hw_breakpoint(struct perf_event *bp,
 			  perf_callback_t triggered,
 			  struct task_struct *tsk)	{ return NULL; }
 static inline struct perf_event *
-register_wide_hw_breakpoint_cpu(unsigned long addr,
-				int len,
-				int type,
+register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_callback_t triggered,
-				int cpu,
-				bool active)		{ return NULL; }
+				int cpu)		{ return NULL; }
 static inline struct perf_event **
-register_wide_hw_breakpoint(unsigned long addr,
-			    int len,
-			    int type,
-			    perf_callback_t triggered,
-			    bool active)		{ return NULL; }
+register_wide_hw_breakpoint(struct perf_event_attr *attr,
+			    perf_callback_t triggered)	{ return NULL; }
 static inline int
 register_perf_hw_breakpoint(struct perf_event *bp)	{ return -ENOSYS; }
 static inline int
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 2a47514..cf5ee16 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -339,42 +339,16 @@ void unregister_hw_breakpoint(struct perf_event *bp)
 }
 EXPORT_SYMBOL_GPL(unregister_hw_breakpoint);
 
-static struct perf_event *
-register_kernel_hw_breakpoint_cpu(unsigned long addr,
-				  int len,
-				  int type,
-				  perf_callback_t triggered,
-				  int cpu,
-				  bool active)
-{
-	DEFINE_BREAKPOINT_ATTR(attr);
-
-	attr.bp_addr = addr;
-	attr.bp_len = len;
-	attr.bp_type = type;
-
-	if (!active)
-		attr.disabled = 1;
-
-	return perf_event_create_kernel_counter(&attr, cpu, -1, triggered);
-}
-
 /**
  * register_wide_hw_breakpoint - register a wide breakpoint in the kernel
- * @addr: is the memory address that triggers the breakpoint
- * @len: the length of the access to the memory (1 byte, 2 bytes etc...)
- * @type: the type of the access to the memory (read/write/exec)
+ * @attr: breakpoint attributes
  * @triggered: callback to trigger when we hit the breakpoint
- * @active: should we activate it while registering it
  *
  * @return a set of per_cpu pointers to perf events
  */
 struct perf_event **
-register_wide_hw_breakpoint(unsigned long addr,
-			    int len,
-			    int type,
-			    perf_callback_t triggered,
-			    bool active)
+register_wide_hw_breakpoint(struct perf_event_attr *attr,
+			    perf_callback_t triggered)
 {
 	struct perf_event **cpu_events, **pevent, *bp;
 	long err;
@@ -386,8 +360,7 @@ register_wide_hw_breakpoint(unsigned long addr,
 
 	for_each_possible_cpu(cpu) {
 		pevent = per_cpu_ptr(cpu_events, cpu);
-		bp = register_kernel_hw_breakpoint_cpu(addr, len, type,
-					triggered, cpu, active);
+		bp = perf_event_create_kernel_counter(attr, cpu, -1, triggered);
 
 		*pevent = bp;
 
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index c538b15..ddfa0fd 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -42,9 +42,7 @@
 
 struct trace_ksym {
 	struct perf_event	**ksym_hbp;
-	unsigned long		ksym_addr;
-	int			type;
-	int			len;
+	struct perf_event_attr	attr;
 #ifdef CONFIG_PROFILE_KSYM_TRACER
 	unsigned long		counter;
 #endif
@@ -71,7 +69,7 @@ void ksym_collect_stats(unsigned long hbp_hit_addr)
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(entry, node, &ksym_filter_head, ksym_hlist) {
-		if ((entry->ksym_addr == hbp_hit_addr) &&
+		if ((entry->attr.bp_addr == hbp_hit_addr) &&
 		    (entry->counter <= MAX_UL_INT)) {
 			entry->counter++;
 			break;
@@ -192,14 +190,15 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 	if (!entry)
 		return -ENOMEM;
 
-	entry->type = op;
-	entry->ksym_addr = addr;
-	entry->len = HW_BREAKPOINT_LEN_4;
+	hw_breakpoint_init(&entry->attr);
+
+	entry->attr.bp_type = op;
+	entry->attr.bp_addr = addr;
+	entry->attr.bp_len = HW_BREAKPOINT_LEN_4;
 
 	ret = -EAGAIN;
-	entry->ksym_hbp = register_wide_hw_breakpoint(entry->ksym_addr,
-					entry->len, entry->type,
-					ksym_hbp_handler, true);
+	entry->ksym_hbp = register_wide_hw_breakpoint(&entry->attr,
+					ksym_hbp_handler);
 
 	if (IS_ERR(entry->ksym_hbp)) {
 		ret = PTR_ERR(entry->ksym_hbp);
@@ -236,12 +235,12 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 	mutex_lock(&ksym_tracer_mutex);
 
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
-		ret = trace_seq_printf(s, "%pS:", (void *)entry->ksym_addr);
-		if (entry->type == HW_BREAKPOINT_R)
+		ret = trace_seq_printf(s, "%pS:", (void *)entry->attr.bp_addr);
+		if (entry->attr.bp_type == HW_BREAKPOINT_R)
 			ret = trace_seq_puts(s, "r--\n");
-		else if (entry->type == HW_BREAKPOINT_W)
+		else if (entry->attr.bp_type == HW_BREAKPOINT_W)
 			ret = trace_seq_puts(s, "-w-\n");
-		else if (entry->type == (HW_BREAKPOINT_W | HW_BREAKPOINT_R))
+		else if (entry->attr.bp_type == (HW_BREAKPOINT_W | HW_BREAKPOINT_R))
 			ret = trace_seq_puts(s, "rw-\n");
 		WARN_ON_ONCE(!ret);
 	}
@@ -317,9 +316,9 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 
 	ret = -EINVAL;
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
-		if (entry->ksym_addr == ksym_addr) {
+		if (entry->attr.bp_addr == ksym_addr) {
 			/* Check for malformed request: (6) */
-			if (entry->type != op)
+			if (entry->attr.bp_type != op)
 				changed = 1;
 			else
 				goto out;
@@ -328,13 +327,12 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	}
 	if (changed) {
 		unregister_wide_hw_breakpoint(entry->ksym_hbp);
-		entry->type = op;
+		entry->attr.bp_type = op;
 		ret = 0;
 		if (op > 0) {
 			entry->ksym_hbp =
-				register_wide_hw_breakpoint(entry->ksym_addr,
-					entry->len, entry->type,
-					ksym_hbp_handler, true);
+				register_wide_hw_breakpoint(&entry->attr,
+					ksym_hbp_handler);
 			if (IS_ERR(entry->ksym_hbp))
 				ret = PTR_ERR(entry->ksym_hbp);
 			else
@@ -489,7 +487,7 @@ static int ksym_tracer_stat_show(struct seq_file *m, void *v)
 
 	entry = hlist_entry(stat, struct trace_ksym, ksym_hlist);
 
-	access_type = entry->type;
+	access_type = entry->attr.bp_type;
 
 	switch (access_type) {
 	case HW_BREAKPOINT_R:
@@ -505,7 +503,7 @@ static int ksym_tracer_stat_show(struct seq_file *m, void *v)
 		seq_puts(m, "  NA          ");
 	}
 
-	if (lookup_symbol_name(entry->ksym_addr, fn_name) >= 0)
+	if (lookup_symbol_name(entry->attr.bp_addr, fn_name) >= 0)
 		seq_printf(m, "  %-36s", fn_name);
 	else
 		seq_printf(m, "  %-36s", "<NA>");
diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
index ee7f9fb..2952550 100644
--- a/samples/hw_breakpoint/data_breakpoint.c
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -51,13 +51,13 @@ static void sample_hbp_handler(struct perf_event *temp, void *data)
 static int __init hw_break_module_init(void)
 {
 	int ret;
-	unsigned long addr;
+	DEFINE_BREAKPOINT_ATTR(attr);
 
-	addr = kallsyms_lookup_name(ksym_name);
+	attr.bp_addr = kallsyms_lookup_name(ksym_name);
+	attr.bp_len = HW_BREAKPOINT_LEN_4;
+	attr.bp_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
 
-	sample_hbp = register_wide_hw_breakpoint(addr, HW_BREAKPOINT_LEN_4,
-						 HW_BREAKPOINT_W | HW_BREAKPOINT_R,
-						 sample_hbp_handler, true);
+	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler);
 	if (IS_ERR(sample_hbp)) {
 		ret = PTR_ERR(sample_hbp);
 		goto fail;

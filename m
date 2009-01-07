Return-Path: <linux-kernel-owner+w=401wt.eu-S932390AbZAGW72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbZAGW72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761499AbZAGW6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:58:06 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:3755 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759298AbZAGW6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:58:01 -0500
X-BigFish: VPS7(zz541L78fbpzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KD4IG4-01-LSG-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/9] oprofile: rework implementation of cpu buffer events
Date: Wed, 7 Jan 2009 23:45:19 +0100
Message-ID: <1231368325-19246-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
References: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:57:46.0429 (UTC) FILETIME=[5B29C6D0:01C9711B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Special events such as task or context switches are marked with an
escape code in the cpu buffer followed by an event code or a task
identifier. There is one escape code per event. To make escape
sequences also available for data samples the internal cpu buffer
format must be changed. The current implementation does not allow the
extension of event codes since this would lead to collisions with the
task identifiers. To avoid this, this patch introduces an event mask
that allows the storage of multiple events with one escape code. Now,
task identifiers are stored in the data section of the sample. The
implementation also allows the usage of custom data in a sample. As a
side effect the new code is much more readable and easier to
understand.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    8 +-
 drivers/oprofile/buffer_sync.c   |   42 ++++++------
 drivers/oprofile/cpu_buffer.c    |  139 ++++++++++++++++++++-----------------
 drivers/oprofile/cpu_buffer.h    |   12 ++--
 4 files changed, 106 insertions(+), 95 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 423a954..f101724 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -2,7 +2,7 @@
  * @file op_model_amd.c
  * athlon / K7 / K8 / Family 10h model-specific MSR operations
  *
- * @remark Copyright 2002-2008 OProfile authors
+ * @remark Copyright 2002-2009 OProfile authors
  * @remark Read the file COPYING
  *
  * @author John Levon
@@ -10,7 +10,7 @@
  * @author Graydon Hoare
  * @author Robert Richter <robert.richter@amd.com>
  * @author Barry Kasindorf
-*/
+ */
 
 #include <linux/oprofile.h>
 #include <linux/device.h>
@@ -62,8 +62,8 @@ static unsigned long reset_value[NUM_COUNTERS];
 
 /* Codes used in cpu_buffer.c */
 /* This produces duplicate code, need to be fixed */
-#define IBS_FETCH_BEGIN 3
-#define IBS_OP_BEGIN    4
+#define IBS_FETCH_BEGIN         (1UL << 4)
+#define IBS_OP_BEGIN            (1UL << 5)
 
 /*
  * The function interface needs to be fixed, something like add
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 908202a..d969bb1 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -1,11 +1,12 @@
 /**
  * @file buffer_sync.c
  *
- * @remark Copyright 2002 OProfile authors
+ * @remark Copyright 2002-2009 OProfile authors
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
  * @author Barry Kasindorf
+ * @author Robert Richter <robert.richter@amd.com>
  *
  * This is the core of the buffer management. Each
  * CPU buffer is processed and entered into the
@@ -529,6 +530,7 @@ void sync_buffer(int cpu)
 	sync_buffer_state state = sb_buffer_start;
 	unsigned int i;
 	unsigned long available;
+	unsigned long flags;
 	struct op_entry entry;
 	struct op_sample *sample;
 
@@ -545,38 +547,34 @@ void sync_buffer(int cpu)
 			break;
 
 		if (is_code(sample->eip)) {
-			switch (sample->event) {
-			case 0:
-			case CPU_IS_KERNEL:
+			flags = sample->event;
+			if (flags & TRACE_BEGIN) {
+				state = sb_bt_start;
+				add_trace_begin();
+			}
+			if (flags & KERNEL_CTX_SWITCH) {
 				/* kernel/userspace switch */
-				in_kernel = sample->event;
+				in_kernel = flags & IS_KERNEL;
 				if (state == sb_buffer_start)
 					state = sb_sample_start;
-				add_kernel_ctx_switch(sample->event);
-				break;
-			case CPU_TRACE_BEGIN:
-				state = sb_bt_start;
-				add_trace_begin();
-				break;
-#ifdef CONFIG_OPROFILE_IBS
-			case IBS_FETCH_BEGIN:
-				add_ibs_begin(cpu, IBS_FETCH_CODE, mm);
-				break;
-			case IBS_OP_BEGIN:
-				add_ibs_begin(cpu, IBS_OP_CODE, mm);
-				break;
-#endif
-			default:
+				add_kernel_ctx_switch(flags & IS_KERNEL);
+			}
+			if (flags & USER_CTX_SWITCH) {
 				/* userspace context switch */
 				oldmm = mm;
-				new = (struct task_struct *)sample->event;
+				new = (struct task_struct *)sample->data[0];
 				release_mm(oldmm);
 				mm = take_tasks_mm(new);
 				if (mm != oldmm)
 					cookie = get_exec_dcookie(mm);
 				add_user_ctx_switch(new, cookie);
-				break;
 			}
+#ifdef CONFIG_OPROFILE_IBS
+			if (flags & IBS_FETCH_BEGIN)
+				add_ibs_begin(cpu, IBS_FETCH_CODE, mm);
+			if (flags & IBS_OP_BEGIN)
+				add_ibs_begin(cpu, IBS_OP_CODE, mm);
+#endif
 			continue;
 		}
 
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 400f7fc..e859d23 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -212,6 +212,59 @@ unsigned long op_cpu_buffer_entries(int cpu)
 		+ ring_buffer_entries_cpu(op_ring_buffer_write, cpu);
 }
 
+static int
+op_add_code(struct oprofile_cpu_buffer *cpu_buf, unsigned long backtrace,
+	    int is_kernel, struct task_struct *task)
+{
+	struct op_entry entry;
+	struct op_sample *sample;
+	unsigned long flags;
+	int size;
+
+	flags = 0;
+
+	if (backtrace)
+		flags |= TRACE_BEGIN;
+
+	/* notice a switch from user->kernel or vice versa */
+	is_kernel = !!is_kernel;
+	if (cpu_buf->last_is_kernel != is_kernel) {
+		cpu_buf->last_is_kernel = is_kernel;
+		flags |= KERNEL_CTX_SWITCH;
+		if (is_kernel)
+			flags |= IS_KERNEL;
+	}
+
+	/* notice a task switch */
+	if (cpu_buf->last_task != task) {
+		cpu_buf->last_task = task;
+		flags |= USER_CTX_SWITCH;
+	}
+
+	if (!flags)
+		/* nothing to do */
+		return 0;
+
+	if (flags & USER_CTX_SWITCH)
+		size = 1;
+	else
+		size = 0;
+
+	sample = op_cpu_buffer_write_reserve(&entry, size);
+	if (!sample)
+		return -ENOMEM;
+
+	sample->eip = ESCAPE_CODE;
+	sample->event = flags;
+
+	if (size)
+		sample->data[0] = (unsigned long)task;
+
+	op_cpu_buffer_write_commit(&entry);
+
+	return 0;
+}
+
 static inline int
 op_add_sample(struct oprofile_cpu_buffer *cpu_buf,
 	      unsigned long pc, unsigned long event)
@@ -229,26 +282,18 @@ op_add_sample(struct oprofile_cpu_buffer *cpu_buf,
 	return op_cpu_buffer_write_commit(&entry);
 }
 
-static inline int
-add_code(struct oprofile_cpu_buffer *buffer, unsigned long value)
-{
-	return op_add_sample(buffer, ESCAPE_CODE, value);
-}
-
-/* This must be safe from any context. It's safe writing here
- * because of the head/tail separation of the writer and reader
- * of the CPU buffer.
+/*
+ * This must be safe from any context.
  *
  * is_kernel is needed because on some architectures you cannot
  * tell if you are in kernel or user space simply by looking at
  * pc. We tag this in the buffer by generating kernel enter/exit
  * events whenever is_kernel changes
  */
-static int log_sample(struct oprofile_cpu_buffer *cpu_buf, unsigned long pc,
-		      int is_kernel, unsigned long event)
+static int
+log_sample(struct oprofile_cpu_buffer *cpu_buf, unsigned long pc,
+	   unsigned long backtrace, int is_kernel, unsigned long event)
 {
-	struct task_struct *task;
-
 	cpu_buf->sample_received++;
 
 	if (pc == ESCAPE_CODE) {
@@ -256,23 +301,8 @@ static int log_sample(struct oprofile_cpu_buffer *cpu_buf, unsigned long pc,
 		return 0;
 	}
 
-	is_kernel = !!is_kernel;
-
-	task = current;
-
-	/* notice a switch from user->kernel or vice versa */
-	if (cpu_buf->last_is_kernel != is_kernel) {
-		cpu_buf->last_is_kernel = is_kernel;
-		if (add_code(cpu_buf, is_kernel))
-			goto fail;
-	}
-
-	/* notice a task switch */
-	if (cpu_buf->last_task != task) {
-		cpu_buf->last_task = task;
-		if (add_code(cpu_buf, (unsigned long)task))
-			goto fail;
-	}
+	if (op_add_code(cpu_buf, backtrace, is_kernel, current))
+		goto fail;
 
 	if (op_add_sample(cpu_buf, pc, event))
 		goto fail;
@@ -286,7 +316,6 @@ fail:
 
 static inline void oprofile_begin_trace(struct oprofile_cpu_buffer *cpu_buf)
 {
-	add_code(cpu_buf, CPU_TRACE_BEGIN);
 	cpu_buf->tracing = 1;
 }
 
@@ -300,21 +329,21 @@ __oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 			  unsigned long event, int is_kernel)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
-
-	if (!oprofile_backtrace_depth) {
-		log_sample(cpu_buf, pc, is_kernel, event);
-		return;
-	}
-
-	oprofile_begin_trace(cpu_buf);
+	unsigned long backtrace = oprofile_backtrace_depth;
 
 	/*
 	 * if log_sample() fail we can't backtrace since we lost the
 	 * source of this event
 	 */
-	if (log_sample(cpu_buf, pc, is_kernel, event))
-		oprofile_ops.backtrace(regs, oprofile_backtrace_depth);
+	if (!log_sample(cpu_buf, pc, backtrace, is_kernel, event))
+		/* failed */
+		return;
 
+	if (!backtrace)
+		return;
+
+	oprofile_begin_trace(cpu_buf);
+	oprofile_ops.backtrace(regs, backtrace);
 	oprofile_end_trace(cpu_buf);
 }
 
@@ -339,29 +368,14 @@ void oprofile_add_ibs_sample(struct pt_regs * const regs,
 {
 	int is_kernel = !user_mode(regs);
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
-	struct task_struct *task;
 	int fail = 0;
 
 	cpu_buf->sample_received++;
 
-	/* notice a switch from user->kernel or vice versa */
-	if (cpu_buf->last_is_kernel != is_kernel) {
-		if (add_code(cpu_buf, is_kernel))
-			goto fail;
-		cpu_buf->last_is_kernel = is_kernel;
-	}
+	/* backtraces disabled for ibs */
+	fail = fail || op_add_code(cpu_buf, 0, is_kernel, current);
 
-	/* notice a task switch */
-	if (!is_kernel) {
-		task = current;
-		if (cpu_buf->last_task != task) {
-			if (add_code(cpu_buf, (unsigned long)task))
-				goto fail;
-			cpu_buf->last_task = task;
-		}
-	}
-
-	fail = fail || add_code(cpu_buf, ibs_code);
+	fail = fail || op_add_sample(cpu_buf, ESCAPE_CODE,   ibs_code);
 	fail = fail || op_add_sample(cpu_buf, ibs_sample[0], ibs_sample[1]);
 	fail = fail || op_add_sample(cpu_buf, ibs_sample[2], ibs_sample[3]);
 	fail = fail || op_add_sample(cpu_buf, ibs_sample[4], ibs_sample[5]);
@@ -372,11 +386,8 @@ void oprofile_add_ibs_sample(struct pt_regs * const regs,
 		fail = fail || op_add_sample(cpu_buf, ibs_sample[10], ibs_sample[11]);
 	}
 
-	if (!fail)
-		return;
-
-fail:
-	cpu_buf->sample_lost_overflow++;
+	if (fail)
+		cpu_buf->sample_lost_overflow++;
 }
 
 #endif
@@ -384,7 +395,7 @@ fail:
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
-	log_sample(cpu_buf, pc, is_kernel, event);
+	log_sample(cpu_buf, pc, 0, is_kernel, event);
 }
 
 void oprofile_add_trace(unsigned long pc)
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index d7c0545..e634dcf 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -78,10 +78,12 @@ int op_cpu_buffer_write_commit(struct op_entry *entry);
 struct op_sample *op_cpu_buffer_read_entry(struct op_entry *entry, int cpu);
 unsigned long op_cpu_buffer_entries(int cpu);
 
-/* transient events for the CPU buffer -> event buffer */
-#define CPU_IS_KERNEL 1
-#define CPU_TRACE_BEGIN 2
-#define IBS_FETCH_BEGIN 3
-#define IBS_OP_BEGIN    4
+/* extra data flags */
+#define KERNEL_CTX_SWITCH	(1UL << 0)
+#define IS_KERNEL		(1UL << 1)
+#define TRACE_BEGIN		(1UL << 2)
+#define USER_CTX_SWITCH		(1UL << 3)
+#define IBS_FETCH_BEGIN		(1UL << 4)
+#define IBS_OP_BEGIN		(1UL << 5)
 
 #endif /* OPROFILE_CPU_BUFFER_H */
-- 
1.6.0.1



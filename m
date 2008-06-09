Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbYFISQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbYFISQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYFISQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:16:41 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:42227 "EHLO
	mail187-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbYFISQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:16:39 -0400
X-BigFish: VPS13(z6f5iz78fbpzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K27IWK-03-V3B-01
From: Barry Kasindorf <barry.kasindorf@amd.com>
To: linux-kernel@vger.kernel.org, barry.kasindorf@amd.com
Cc: Barry Kasindorf <barry.kasindorf@amd.com>
Message-Id: <20080609175052.2844.12167.sendpatchset@localhost.localdomain>
In-Reply-To: <20080609175030.2844.77365.sendpatchset@localhost.localdomain>
References: <20080609175030.2844.77365.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/3] AMD Family10h+ IBS support for oProfile driver: buffer management
X-OriginalArrivalTime: 09 Jun 2008 17:50:48.0582 (UTC) FILETIME=[59B25A60:01C8CA59]
Date: 9 Jun 2008 13:50:48 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>

---
 drivers/oprofile/buffer_sync.c |  140 ++++++++++++++++++++++++++++++-----------
 drivers/oprofile/cpu_buffer.c  |  102 +++++++++++++++++++++++++++--
 drivers/oprofile/cpu_buffer.h  |    3
 include/linux/oprofile.h       |   13 +++
 4 files changed, 213 insertions(+), 45 deletions(-)
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 9304c45..d6f3305 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -5,6 +5,7 @@
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
+ * @author Barry Kasindorf
  *
  * This is the core of the buffer management. Each
  * CPU buffer is processed and entered into the
@@ -33,7 +34,7 @@
 #include "event_buffer.h"
 #include "cpu_buffer.h"
 #include "buffer_sync.h"
-
+
 static LIST_HEAD(dying_tasks);
 static LIST_HEAD(dead_tasks);
 static cpumask_t marked_cpus = CPU_MASK_NONE;
@@ -99,7 +100,7 @@ static int munmap_notify(struct notifier_block * self, unsigned long val, void *
 	return 0;
 }

-
+
 /* We need to be told about new modules so we don't attribute to a previously
  * loaded module, or drop the samples on the floor.
  */
@@ -118,7 +119,7 @@ static int module_load_notify(struct notifier_block * self, unsigned long val, v
 	return 0;
 }

-
+
 static struct notifier_block task_free_nb = {
 	.notifier_call	= task_free_notify,
 };
@@ -135,7 +136,7 @@ static struct notifier_block module_load_nb = {
 	.notifier_call = module_load_notify,
 };

-
+
 static void end_sync(void)
 {
 	end_cpu_work();
@@ -212,10 +213,10 @@ static unsigned long get_exec_dcookie(struct mm_struct * mm)
 {
 	unsigned long cookie = NO_COOKIE;
 	struct vm_area_struct * vma;
-
+
 	if (!mm)
 		goto out;
-
+
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (!vma->vm_file)
 			continue;
@@ -241,7 +242,7 @@ static unsigned long lookup_dcookie(struct mm_struct * mm, unsigned long addr, o
 	struct vm_area_struct * vma;

 	for (vma = find_vma(mm, addr); vma; vma = vma->vm_next) {
-
+
 		if (addr < vma->vm_start || addr >= vma->vm_end)
 			continue;

@@ -263,9 +264,19 @@ static unsigned long lookup_dcookie(struct mm_struct * mm, unsigned long addr, o
 	return cookie;
 }

+static void increment_tail(struct oprofile_cpu_buffer *b)
+{
+	unsigned long new_tail = b->tail_pos + 1;
+
+	rmb();	/* be sure fifo pointers are synchromized */

+	if (new_tail < b->buffer_size)
+		b->tail_pos = new_tail;
+	else
+		b->tail_pos = 0;
+}
 static unsigned long last_cookie = INVALID_COOKIE;
-
+
 static void add_cpu_switch(int i)
 {
 	add_event_entry(ESCAPE_CODE);
@@ -278,16 +289,16 @@ static void add_kernel_ctx_switch(unsigned int in_kernel)
 {
 	add_event_entry(ESCAPE_CODE);
 	if (in_kernel)
-		add_event_entry(KERNEL_ENTER_SWITCH_CODE);
+		add_event_entry(KERNEL_ENTER_SWITCH_CODE);
 	else
-		add_event_entry(KERNEL_EXIT_SWITCH_CODE);
+		add_event_entry(KERNEL_EXIT_SWITCH_CODE);
 }
-
+
 static void
 add_user_ctx_switch(struct task_struct const * task, unsigned long cookie)
 {
 	add_event_entry(ESCAPE_CODE);
-	add_event_entry(CTX_SWITCH_CODE);
+	add_event_entry(CTX_SWITCH_CODE);
 	add_event_entry(task->pid);
 	add_event_entry(cookie);
 	/* Another code for daemon back-compat */
@@ -296,7 +307,7 @@ add_user_ctx_switch(struct task_struct const * task, unsigned long cookie)
 	add_event_entry(task->tgid);
 }

-
+
 static void add_cookie_switch(unsigned long cookie)
 {
 	add_event_entry(ESCAPE_CODE);
@@ -304,13 +315,74 @@ static void add_cookie_switch(unsigned long cookie)
 	add_event_entry(cookie);
 }

-
+
 static void add_trace_begin(void)
 {
 	add_event_entry(ESCAPE_CODE);
 	add_event_entry(TRACE_BEGIN_CODE);
 }

+/*
+ * Add IBS fetch and op entries to event buffer
+ */
+static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
+	int in_kernel, struct mm_struct *mm)
+{
+	unsigned long rip;
+	int i, count;
+	unsigned long ibs_cookie = 0;
+	off_t offset;
+
+	increment_tail(cpu_buf);	/* move to RIP entry */
+
+	rip = ((struct op_sample *)&cpu_buf->buffer[cpu_buf->tail_pos])->eip;
+
+#ifdef __LP64__
+	rip +=
+	((struct op_sample *)&cpu_buf->buffer[cpu_buf->tail_pos])->event << 32;
+#endif
+
+	if (mm) {
+		ibs_cookie = lookup_dcookie(mm, rip, &offset);
+
+		if (ibs_cookie == NO_COOKIE)
+			offset = rip;
+		if (ibs_cookie == INVALID_COOKIE) {
+			atomic_inc(&oprofile_stats.sample_lost_no_mapping);
+			offset = rip;
+		}
+		if (ibs_cookie != last_cookie) {
+			add_cookie_switch(ibs_cookie);
+			last_cookie = ibs_cookie;
+		}
+	}
+
+	else
+		offset = rip;
+
+	add_event_entry(ESCAPE_CODE);
+	add_event_entry(code);
+	add_event_entry(offset);	/* Offset from Dcookie */
+
+	/* we send the Dcookie offset, but send the raw Linear Add also*/
+	add_event_entry(
+		((struct op_sample *)&cpu_buf->buffer[cpu_buf->tail_pos])->eip);
+	add_event_entry(
+		((struct op_sample *)&cpu_buf->buffer[cpu_buf->tail_pos])->event);
+
+	if (code == IBS_FETCH_CODE)
+		count = 2;
+	else
+		count = 5;	/*IBS OP is 5 int64s long */
+
+	for (i = 0; i < count; i++) {
+		increment_tail(cpu_buf);
+		add_event_entry(
+		((struct op_sample *)&cpu_buf->buffer[cpu_buf->tail_pos])->eip);
+		add_event_entry(
+		((struct op_sample *)&cpu_buf->buffer[cpu_buf->tail_pos])->event);
+	}
+}

 static void add_sample_entry(unsigned long offset, unsigned long event)
 {
@@ -323,9 +395,9 @@ static int add_us_sample(struct mm_struct * mm, struct op_sample * s)
 {
 	unsigned long cookie;
 	off_t offset;
-
+
  	cookie = lookup_dcookie(mm, s->eip, &offset);
-
+
 	if (cookie == INVALID_COOKIE) {
 		atomic_inc(&oprofile_stats.sample_lost_no_mapping);
 		return 0;
@@ -341,7 +413,7 @@ static int add_us_sample(struct mm_struct * mm, struct op_sample * s)
 	return 1;
 }

-
+
 /* Add a sample to the global event buffer. If possible the
  * sample is converted into a persistent dentry/offset pair
  * for later lookup from userspace.
@@ -359,7 +431,7 @@ add_sample(struct mm_struct * mm, struct op_sample * s, int in_kernel)
 	}
 	return 0;
 }
-
+

 static void release_mm(struct mm_struct * mm)
 {
@@ -383,7 +455,7 @@ static inline int is_code(unsigned long val)
 {
 	return val == ESCAPE_CODE;
 }
-
+

 /* "acquire" as many cpu buffer slots as we can */
 static unsigned long get_slots(struct oprofile_cpu_buffer * b)
@@ -412,19 +484,6 @@ static unsigned long get_slots(struct oprofile_cpu_buffer * b)
 }


-static void increment_tail(struct oprofile_cpu_buffer * b)
-{
-	unsigned long new_tail = b->tail_pos + 1;
-
-	rmb();
-
-	if (new_tail < b->buffer_size)
-		b->tail_pos = new_tail;
-	else
-		b->tail_pos = 0;
-}
-
-
 /* Move tasks along towards death. Any tasks on dead_tasks
  * will definitely have no remaining references in any
  * CPU buffers at this point, because we use two lists,
@@ -496,21 +555,20 @@ void sync_buffer(int cpu)
 	struct task_struct * new;
 	unsigned long cookie = 0;
 	int in_kernel = 1;
-	unsigned int i;
 	sync_buffer_state state = sb_buffer_start;
 	unsigned long available;

 	mutex_lock(&buffer_mutex);
-
+
 	add_cpu_switch(cpu);

 	/* Remember, only we can modify tail_pos */

 	available = get_slots(cpu_buf);

-	for (i = 0; i < available; ++i) {
-		struct op_sample * s = &cpu_buf->buffer[cpu_buf->tail_pos];
-
+	while (get_slots(cpu_buf)) {
+		struct op_sample *s = &cpu_buf->buffer[cpu_buf->tail_pos];
+
 		if (is_code(s->eip)) {
 			if (s->event <= CPU_IS_KERNEL) {
 				/* kernel/userspace switch */
@@ -521,6 +579,14 @@ void sync_buffer(int cpu)
 			} else if (s->event == CPU_TRACE_BEGIN) {
 				state = sb_bt_start;
 				add_trace_begin();
+			} else if (s->event == IBS_FETCH_BEGIN) {
+				state = sb_bt_start;
+				add_ibs_begin(cpu_buf,
+					IBS_FETCH_CODE, in_kernel, mm);
+			} else if (s->event == IBS_OP_BEGIN) {
+				state = sb_bt_start;
+				add_ibs_begin(cpu_buf,
+					IBS_OP_CODE, in_kernel, mm);
 			} else {
 				struct mm_struct * oldmm = mm;

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 2450b3a..b08b11d 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -5,6 +5,7 @@
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
+ * @author Barry Kasindorf <barry.kasindorf@amd.com>
  *
  * Each CPU has a local buffer that stores PC value/event
  * pairs. We also log context switches when we notice them.
@@ -21,7 +22,7 @@
 #include <linux/oprofile.h>
 #include <linux/vmalloc.h>
 #include <linux/errno.h>
-
+
 #include "event_buffer.h"
 #include "cpu_buffer.h"
 #include "buffer_sync.h"
@@ -37,7 +38,7 @@ static int work_enabled;
 void free_cpu_buffers(void)
 {
 	int i;
-
+
 	for_each_online_cpu(i)
 		vfree(per_cpu(cpu_buffer, i).buffer);
 }
@@ -45,17 +46,17 @@ void free_cpu_buffers(void)
 int alloc_cpu_buffers(void)
 {
 	int i;
-
+
 	unsigned long buffer_size = fs_cpu_buffer_size;
-
+
 	for_each_online_cpu(i) {
 		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
-
+
 		b->buffer = vmalloc_node(sizeof(struct op_sample) * buffer_size,
 			cpu_to_node(i));
 		if (!b->buffer)
 			goto fail;
-
+
 		b->last_task = NULL;
 		b->last_is_kernel = -1;
 		b->tracing = 0;
@@ -202,12 +203,55 @@ static int log_sample(struct oprofile_cpu_buffer * cpu_buf, unsigned long pc,
 		cpu_buf->last_task = task;
 		add_code(cpu_buf, (unsigned long)task);
 	}
-
+
 	add_sample(cpu_buf, pc, event);
 	return 1;
 }

-static int oprofile_begin_trace(struct oprofile_cpu_buffer * cpu_buf)
+static int log_ibs_sample(struct oprofile_cpu_buffer *cpu_buf,
+	unsigned long pc, int is_kernel, unsigned  int *ibs, int ibs_code)
+{
+	struct task_struct *task;
+
+	cpu_buf->sample_received++;
+
+	if (nr_available_slots(cpu_buf) < 14) {
+		cpu_buf->sample_lost_overflow++;
+		return 0;
+	}
+
+	is_kernel = !!is_kernel;
+
+	/* notice a switch from user->kernel or vice versa */
+	if (cpu_buf->last_is_kernel != is_kernel) {
+		cpu_buf->last_is_kernel = is_kernel;
+		add_code(cpu_buf, is_kernel);
+	}
+
+	/* notice a task switch */
+	if (!is_kernel) {
+		task = current;
+
+		if (cpu_buf->last_task != task) {
+			cpu_buf->last_task = task;
+			add_code(cpu_buf, (unsigned long)task);
+		}
+	}
+
+	add_code(cpu_buf, ibs_code);
+	add_sample(cpu_buf, ibs[0], ibs[1]);
+	add_sample(cpu_buf, ibs[2], ibs[3]);
+	add_sample(cpu_buf, ibs[4], ibs[5]);
+
+	if (ibs_code == IBS_OP_BEGIN) {
+	add_sample(cpu_buf, ibs[6], ibs[7]);
+	add_sample(cpu_buf, ibs[8], ibs[9]);
+	add_sample(cpu_buf, ibs[10], ibs[11]);
+	}
+
+	return 1;
+}
+static int oprofile_begin_trace(struct oprofile_cpu_buffer *cpu_buf)
 {
 	if (nr_available_slots(cpu_buf) < 4) {
 		cpu_buf->sample_lost_overflow++;
@@ -252,6 +296,48 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 	oprofile_add_ext_sample(pc, regs, event, is_kernel);
 }

+void oprofile_add_ibs_fetch_sample(struct pt_regs *const regs,
+				unsigned int * const ibs_fetch)
+{
+	int is_kernel = !user_mode(regs);
+	unsigned long pc = profile_pc(regs);
+
+	struct oprofile_cpu_buffer *cpu_buf =
+			 &per_cpu(cpu_buffer, smp_processor_id());
+
+	if (!backtrace_depth) {
+		log_ibs_sample(cpu_buf, pc, is_kernel,
+			ibs_fetch, IBS_FETCH_BEGIN);
+		return;
+	}
+
+	/* if log_sample() fails we can't backtrace since we lost the source
+	 * of this event */
+	if (log_ibs_sample(cpu_buf, pc, is_kernel, ibs_fetch, IBS_FETCH_BEGIN))
+		oprofile_ops.backtrace(regs, backtrace_depth);
+}
+
+
+void oprofile_add_ibs_op_sample(struct pt_regs *const regs,
+				unsigned int * const ibs_op)
+{
+	int is_kernel = !user_mode(regs);
+	unsigned long pc = profile_pc(regs);
+
+	struct oprofile_cpu_buffer *cpu_buf =
+			 &per_cpu(cpu_buffer, smp_processor_id());
+
+	if (!backtrace_depth) {
+		log_ibs_sample(cpu_buf, pc, is_kernel, ibs_op, IBS_OP_BEGIN);
+		return;
+	}
+
+	/* if log_sample() fails we can't backtrace since we lost the source
+	* of this event */
+	if (log_ibs_sample(cpu_buf, pc, is_kernel, ibs_op, IBS_OP_BEGIN))
+		oprofile_ops.backtrace(regs, backtrace_depth);
+}
+
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index c3e366b..4fa475f 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -53,7 +53,10 @@ DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 void cpu_buffer_reset(struct oprofile_cpu_buffer * cpu_buf);

 /* transient events for the CPU buffer -> event buffer */
+#define CPU_IS_USER	0
 #define CPU_IS_KERNEL 1
 #define CPU_TRACE_BEGIN 2
+#define IBS_FETCH_BEGIN 3
+#define IBS_OP_BEGIN    4

 #endif /* OPROFILE_CPU_BUFFER_H */
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 041bb31..6fe46f7 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -36,6 +36,9 @@
 #define XEN_ENTER_SWITCH_CODE		10
 #define SPU_PROFILING_CODE		11
 #define SPU_CTX_SWITCH_CODE		12
+#define IBS_FETCH_CODE			13
+#define IBS_OP_CODE			14
+

 struct super_block;
 struct dentry;
@@ -106,6 +109,16 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event);
 void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 				unsigned long event, int is_kernel);

+/**
+ * Add an AMD IBS  sample. This may be called from any context. Pass
+ * smp_processor_id() as cpu. PAsses IBS registers as a unsigned int[8]
+ */
+void oprofile_add_ibs_op_sample(struct pt_regs * const regs,
+				unsigned int * const ibs_op);
+
+void oprofile_add_ibs_fetch_sample(struct pt_regs * const regs,
+				unsigned int * const ibs_fetch);
+
 /* Use this instead when the PC value is not from the regs. Doesn't
  * backtrace. */
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event);


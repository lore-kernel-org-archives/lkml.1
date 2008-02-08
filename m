Return-Path: <linux-kernel-owner+w=401wt.eu-S935177AbYBHUF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935177AbYBHUF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934932AbYBHUEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:04:24 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:11582 "EHLO
	outbound4-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934855AbYBHUEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:04:22 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Message-ID: <47ACB582.5000000@amd.com>
Date: Fri, 08 Feb 2008 15:03:14 -0500
From: "Barry Kasindorf" <barry.kasindorf@amd.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
cc: barry.kasindorf@amd.com
Subject: [PATCH 3/3] AMD Family10h IBS support for oProfile driver
X-OriginalArrivalTime: 08 Feb 2008 20:03:15.0219 (UTC)
 FILETIME=[A3DD6E30:01C86A8D]
X-WSS-ID: 6BB26A3D2IW10897686-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
---
  drivers/oprofile/buffer_sync.c |  101 ++++++++++++++++++++++++++++++++++-------
  drivers/oprofile/cpu_buffer.c  |   86 ++++++++++++++++++++++++++++++++++
  drivers/oprofile/cpu_buffer.h  |    3 +
  include/linux/oprofile.h       |   13 +++++
  4 files changed, 185 insertions(+), 18 deletions(-)
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 8134c7e..ff4d6a5 100644
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
@@ -266,7 +267,17 @@ static unsigned long lookup_dcookie(struct mm_struct * mm, unsigned long addr, o
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

  static void add_cpu_switch(int i)
@@ -314,6 +325,66 @@ static void add_trace_begin(void)
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
+	rip += ((struct op_sample *)&cpu_buf->buffer[cpu_buf->tail_pos])->event << 32;
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
@@ -415,19 +486,6 @@ static unsigned long get_slots(struct oprofile_cpu_buffer * b)
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
@@ -499,7 +557,6 @@ void sync_buffer(int cpu)
  	struct task_struct * new;
  	unsigned long cookie = 0;
  	int in_kernel = 1;
-	unsigned int i;
  	sync_buffer_state state = sb_buffer_start;
  	unsigned long available;

@@ -511,9 +568,10 @@ void sync_buffer(int cpu)

  	available = get_slots(cpu_buf);

-	for (i = 0; i < available; ++i) {
-		struct op_sample * s = &cpu_buf->buffer[cpu_buf->tail_pos];
-
+
+	while (get_slots(cpu_buf)) {
+		struct op_sample *s = &cpu_buf->buffer[cpu_buf->tail_pos];
+
  		if (is_code(s->eip)) {
  			if (s->event <= CPU_IS_KERNEL) {
  				/* kernel/userspace switch */
@@ -524,6 +582,14 @@ void sync_buffer(int cpu)
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
index c93d3d2..a6434dc 100644
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
@@ -207,7 +208,50 @@ static int log_sample(struct oprofile_cpu_buffer * cpu_buf, unsigned long pc,
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
@@ -252,6 +296,46 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
  	oprofile_add_ext_sample(pc, regs, event, is_kernel);
  }

+void oprofile_add_ibs_fetch_sample(struct pt_regs *const regs,
+				unsigned int * const ibs_fetch)
+{
+	int is_kernel = !user_mode(regs);
+	unsigned long pc = profile_pc(regs);
+
+	struct oprofile_cpu_buffer *cpu_buf = &cpu_buffer[smp_processor_id()];
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
+	struct oprofile_cpu_buffer *cpu_buf = &cpu_buffer[smp_processor_id()];
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
  	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[smp_processor_id()];
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index c66c025..941e023 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -52,7 +52,10 @@ extern struct oprofile_cpu_buffer cpu_buffer[];
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



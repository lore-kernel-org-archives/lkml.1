Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbYGVT1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbYGVT1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYGVTYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:24:06 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:19268 "EHLO
	WA2EHSNDR006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754222AbYGVTX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:23:58 -0400
X-BigFish: VPS30(zz78fbpzz10d3izzz32i87il)
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: 30
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VC-01-8PM-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Barry Kasindorf <barry.kasindorf@amd.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 10/24] x86/oprofile: Add IBS support for AMD CPUs, IBS buffer handling routines
Date: Tue, 22 Jul 2008 21:08:54 +0200
Message-ID: <1216753748-11261-11-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:39.0620 (UTC) FILETIME=[720E8A40:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Reply-To: <rrichter@elbe.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Kasindorf <barry.kasindorf@amd.com>

This patchset supports the new profiling hardware available in the
latest AMD CPUs in the oProfile driver.

Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |   72 +++++++++++++++++++++++++++++++++++++++-
 drivers/oprofile/cpu_buffer.c  |   68 +++++++++++++++++++++++++++++++++++++-
 drivers/oprofile/cpu_buffer.h  |    2 +
 3 files changed, 140 insertions(+), 2 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 615929f..e1782d2 100644
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
@@ -272,7 +273,7 @@ static void increment_tail(struct oprofile_cpu_buffer *b)
 {
 	unsigned long new_tail = b->tail_pos + 1;
 
-	rmb();
+	rmb();	/* be sure fifo pointers are synchromized */
 
 	if (new_tail < b->buffer_size)
 		b->tail_pos = new_tail;
@@ -327,6 +328,67 @@ static void add_trace_begin(void)
 	add_event_entry(TRACE_BEGIN_CODE);
 }
 
+#define IBS_FETCH_CODE_SIZE	2
+#define IBS_OP_CODE_SIZE	5
+#define IBS_EIP(offset)				\
+	(((struct op_sample *)&cpu_buf->buffer[(offset)])->eip)
+#define IBS_EVENT(offset)				\
+	(((struct op_sample *)&cpu_buf->buffer[(offset)])->event)
+
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
+	rip = IBS_EIP(cpu_buf->tail_pos);
+
+#ifdef __LP64__
+	rip += IBS_EVENT(cpu_buf->tail_pos) << 32;
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
+	} else
+		offset = rip;
+
+	add_event_entry(ESCAPE_CODE);
+	add_event_entry(code);
+	add_event_entry(offset);	/* Offset from Dcookie */
+
+	/* we send the Dcookie offset, but send the raw Linear Add also*/
+	add_event_entry(IBS_EIP(cpu_buf->tail_pos));
+	add_event_entry(IBS_EVENT(cpu_buf->tail_pos));
+
+	if (code == IBS_FETCH_CODE)
+		count = IBS_FETCH_CODE_SIZE;	/*IBS FETCH is 2 int64s*/
+	else
+		count = IBS_OP_CODE_SIZE;	/*IBS OP is 5 int64s*/
+
+	for (i = 0; i < count; i++) {
+		increment_tail(cpu_buf);
+		add_event_entry(IBS_EIP(cpu_buf->tail_pos));
+		add_event_entry(IBS_EVENT(cpu_buf->tail_pos));
+	}
+}
 
 static void add_sample_entry(unsigned long offset, unsigned long event)
 {
@@ -524,6 +586,14 @@ void sync_buffer(int cpu)
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
 				struct mm_struct *oldmm = mm;
 
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 2450b3a..c9ac4e1 100644
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
@@ -207,7 +208,7 @@ static int log_sample(struct oprofile_cpu_buffer * cpu_buf, unsigned long pc,
 	return 1;
 }
 
-static int oprofile_begin_trace(struct oprofile_cpu_buffer * cpu_buf)
+static int oprofile_begin_trace(struct oprofile_cpu_buffer *cpu_buf)
 {
 	if (nr_available_slots(cpu_buf) < 4) {
 		cpu_buf->sample_lost_overflow++;
@@ -252,6 +253,71 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 	oprofile_add_ext_sample(pc, regs, event, is_kernel);
 }
 
+#define MAX_IBS_SAMPLE_SIZE	14
+static int log_ibs_sample(struct oprofile_cpu_buffer *cpu_buf,
+	unsigned long pc, int is_kernel, unsigned  int *ibs, int ibs_code)
+{
+	struct task_struct *task;
+
+	cpu_buf->sample_received++;
+
+	if (nr_available_slots(cpu_buf) < MAX_IBS_SAMPLE_SIZE) {
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
+
+void oprofile_add_ibs_sample(struct pt_regs *const regs,
+				unsigned int * const ibs_sample, u8 code)
+{
+	int is_kernel = !user_mode(regs);
+	unsigned long pc = profile_pc(regs);
+
+	struct oprofile_cpu_buffer *cpu_buf =
+			 &per_cpu(cpu_buffer, smp_processor_id());
+
+	if (!backtrace_depth) {
+		log_ibs_sample(cpu_buf, pc, is_kernel, ibs_sample, code);
+		return;
+	}
+
+	/* if log_sample() fails we can't backtrace since we lost the source
+	* of this event */
+	if (log_ibs_sample(cpu_buf, pc, is_kernel, ibs_sample, code))
+		oprofile_ops.backtrace(regs, backtrace_depth);
+}
+
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index c3e366b..9c44d00 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -55,5 +55,7 @@ void cpu_buffer_reset(struct oprofile_cpu_buffer * cpu_buf);
 /* transient events for the CPU buffer -> event buffer */
 #define CPU_IS_KERNEL 1
 #define CPU_TRACE_BEGIN 2
+#define IBS_FETCH_BEGIN 3
+#define IBS_OP_BEGIN    4
 
 #endif /* OPROFILE_CPU_BUFFER_H */
-- 
1.5.5.4



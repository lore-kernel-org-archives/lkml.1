Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbYLKQzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbYLKQzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbYLKQtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:49:35 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:25322 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003AbYLKQtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:49:33 -0500
X-BigFish: VPS3(zzzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KBQ1DK-01-7Q2-01
From: Robert Richter <robert.richter@amd.com>
To: LKML <linux-kernel@vger.kernel.org>
CC: oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 6/9] oprofile: port to the new ring_buffer
Date: Thu, 11 Dec 2008 17:42:00 +0100
Message-ID: <1229013723-8191-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:57.0119 (UTC) FILETIME=[5BE9CAF0:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the current oprofile cpu buffer implementation
with the ring buffer provided by the tracing framework. The motivation
here is to leave the pain of implementing ring buffers to others. Oh,
no, there are more advantages. Main reason is the support of different
sample sizes that could be stored in the buffer. Use cases for this
are IBS and Cell spu profiling. Using the new ring buffer ensures
valid and complete samples and allows copying the cpu buffer stateless
without knowing its content. Second it will use generic kernel API and
also reduce code size. And hopefully, there are less bugs.

Since the new tracing ring buffer implementation uses spin locks to
protect the buffer during read/write access, it is difficult to use
the buffer in an NMI handler. In this case, writing to the buffer by
the NMI handler (x86) could occur also during critical sections when
reading the buffer. To avoid this, there are 2 buffers for independent
read and write access. Read access is in process context only, write
access only in the NMI handler. If the read buffer runs empty, both
buffers are swapped atomically. There is potentially a small window
during swapping where the buffers are disabled and samples could be
lost.

Using 2 buffers is a little bit overhead, but the solution is clear
and does not require changes in the ring buffer implementation. It can
be changed to a single buffer solution when the ring buffer access is
implemented as non-locking atomic code.

The new buffer requires more size to store the same amount of samples
because each sample includes an u32 header. Also, there is more code
to execute for buffer access. Nonetheless, the buffer implementation
is proven in the ftrace environment and worth to use also in oprofile.

Patches that changes the internal IBS buffer usage will follow.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |   65 ++++++++++++++----------------------
 drivers/oprofile/cpu_buffer.c  |   63 +++++++++++++++++++++++++++--------
 drivers/oprofile/cpu_buffer.h  |   71 +++++++++++++++++++++++-----------------
 3 files changed, 114 insertions(+), 85 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 944a583..737bd94 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -268,18 +268,6 @@ lookup_dcookie(struct mm_struct *mm, unsigned long addr, off_t *offset)
 	return cookie;
 }
 
-static void increment_tail(struct oprofile_cpu_buffer *b)
-{
-	unsigned long new_tail = b->tail_pos + 1;
-
-	rmb();	/* be sure fifo pointers are synchronized */
-
-	if (new_tail < b->buffer_size)
-		b->tail_pos = new_tail;
-	else
-		b->tail_pos = 0;
-}
-
 static unsigned long last_cookie = INVALID_COOKIE;
 
 static void add_cpu_switch(int i)
@@ -331,26 +319,25 @@ static void add_trace_begin(void)
 
 #define IBS_FETCH_CODE_SIZE	2
 #define IBS_OP_CODE_SIZE	5
-#define IBS_EIP(cpu_buf)	((cpu_buffer_read_entry(cpu_buf))->eip)
-#define IBS_EVENT(cpu_buf)	((cpu_buffer_read_entry(cpu_buf))->event)
 
 /*
  * Add IBS fetch and op entries to event buffer
  */
-static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
-			  struct mm_struct *mm)
+static void add_ibs_begin(int cpu, int code, struct mm_struct *mm)
 {
 	unsigned long rip;
 	int i, count;
 	unsigned long ibs_cookie = 0;
 	off_t offset;
+	struct op_sample *sample;
 
-	increment_tail(cpu_buf);	/* move to RIP entry */
-
-	rip = IBS_EIP(cpu_buf);
+	sample = cpu_buffer_read_entry(cpu);
+	if (!sample)
+		goto Error;
+	rip = sample->eip;
 
 #ifdef __LP64__
-	rip += IBS_EVENT(cpu_buf) << 32;
+	rip += sample->event << 32;
 #endif
 
 	if (mm) {
@@ -374,8 +361,8 @@ static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
 	add_event_entry(offset);	/* Offset from Dcookie */
 
 	/* we send the Dcookie offset, but send the raw Linear Add also*/
-	add_event_entry(IBS_EIP(cpu_buf));
-	add_event_entry(IBS_EVENT(cpu_buf));
+	add_event_entry(sample->eip);
+	add_event_entry(sample->event);
 
 	if (code == IBS_FETCH_CODE)
 		count = IBS_FETCH_CODE_SIZE;	/*IBS FETCH is 2 int64s*/
@@ -383,10 +370,17 @@ static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
 		count = IBS_OP_CODE_SIZE;	/*IBS OP is 5 int64s*/
 
 	for (i = 0; i < count; i++) {
-		increment_tail(cpu_buf);
-		add_event_entry(IBS_EIP(cpu_buf));
-		add_event_entry(IBS_EVENT(cpu_buf));
+		sample = cpu_buffer_read_entry(cpu);
+		if (!sample)
+			goto Error;
+		add_event_entry(sample->eip);
+		add_event_entry(sample->event);
 	}
+
+	return;
+
+Error:
+	return;
 }
 
 #endif
@@ -530,33 +524,26 @@ typedef enum {
  */
 void sync_buffer(int cpu)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
 	struct mm_struct *mm = NULL;
 	struct mm_struct *oldmm;
 	struct task_struct *new;
 	unsigned long cookie = 0;
 	int in_kernel = 1;
 	sync_buffer_state state = sb_buffer_start;
-#ifndef CONFIG_OPROFILE_IBS
 	unsigned int i;
 	unsigned long available;
-#endif
 
 	mutex_lock(&buffer_mutex);
 
 	add_cpu_switch(cpu);
 
-	/* Remember, only we can modify tail_pos */
-
 	cpu_buffer_reset(cpu);
-#ifndef CONFIG_OPROFILE_IBS
-	available = cpu_buffer_entries(cpu_buf);
+	available = cpu_buffer_entries(cpu);
 
 	for (i = 0; i < available; ++i) {
-#else
-	while (cpu_buffer_entries(cpu_buf)) {
-#endif
-		struct op_sample *s = cpu_buffer_read_entry(cpu_buf);
+		struct op_sample *s = cpu_buffer_read_entry(cpu);
+		if (!s)
+			break;
 
 		if (is_code(s->eip)) {
 			switch (s->event) {
@@ -575,11 +562,11 @@ void sync_buffer(int cpu)
 #ifdef CONFIG_OPROFILE_IBS
 			case IBS_FETCH_BEGIN:
 				state = sb_bt_start;
-				add_ibs_begin(cpu_buf, IBS_FETCH_CODE, mm);
+				add_ibs_begin(cpu, IBS_FETCH_CODE, mm);
 				break;
 			case IBS_OP_BEGIN:
 				state = sb_bt_start;
-				add_ibs_begin(cpu_buf, IBS_OP_CODE, mm);
+				add_ibs_begin(cpu, IBS_OP_CODE, mm);
 				break;
 #endif
 			default:
@@ -600,8 +587,6 @@ void sync_buffer(int cpu)
 				atomic_inc(&oprofile_stats.bt_lost_no_mapping);
 			}
 		}
-
-		increment_tail(cpu_buf);
 	}
 	release_mm(mm);
 
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 5cf7efe..eb280ec 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -28,6 +28,25 @@
 #include "buffer_sync.h"
 #include "oprof.h"
 
+#define OP_BUFFER_FLAGS	0
+
+/*
+ * Read and write access is using spin locking. Thus, writing to the
+ * buffer by NMI handler (x86) could occur also during critical
+ * sections when reading the buffer. To avoid this, there are 2
+ * buffers for independent read and write access. Read access is in
+ * process context only, write access only in the NMI handler. If the
+ * read buffer runs empty, both buffers are swapped atomically. There
+ * is potentially a small window during swapping where the buffers are
+ * disabled and samples could be lost.
+ *
+ * Using 2 buffers is a little bit overhead, but the solution is clear
+ * and does not require changes in the ring buffer implementation. It
+ * can be changed to a single buffer solution when the ring buffer
+ * access is implemented as non-locking atomic code.
+ */
+struct ring_buffer *op_ring_buffer_read;
+struct ring_buffer *op_ring_buffer_write;
 DEFINE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 
 static void wq_sync_buffer(struct work_struct *work);
@@ -37,12 +56,12 @@ static int work_enabled;
 
 void free_cpu_buffers(void)
 {
-	int i;
-
-	for_each_possible_cpu(i) {
-		vfree(per_cpu(cpu_buffer, i).buffer);
-		per_cpu(cpu_buffer, i).buffer = NULL;
-	}
+	if (op_ring_buffer_read)
+		ring_buffer_free(op_ring_buffer_read);
+	op_ring_buffer_read = NULL;
+	if (op_ring_buffer_write)
+		ring_buffer_free(op_ring_buffer_write);
+	op_ring_buffer_write = NULL;
 }
 
 unsigned long oprofile_get_cpu_buffer_size(void)
@@ -64,14 +83,16 @@ int alloc_cpu_buffers(void)
 
 	unsigned long buffer_size = fs_cpu_buffer_size;
 
+	op_ring_buffer_read = ring_buffer_alloc(buffer_size, OP_BUFFER_FLAGS);
+	if (!op_ring_buffer_read)
+		goto fail;
+	op_ring_buffer_write = ring_buffer_alloc(buffer_size, OP_BUFFER_FLAGS);
+	if (!op_ring_buffer_write)
+		goto fail;
+
 	for_each_possible_cpu(i) {
 		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
 
-		b->buffer = vmalloc_node(sizeof(struct op_sample) * buffer_size,
-			cpu_to_node(i));
-		if (!b->buffer)
-			goto fail;
-
 		b->last_task = NULL;
 		b->last_is_kernel = -1;
 		b->tracing = 0;
@@ -140,10 +161,22 @@ static inline void
 add_sample(struct oprofile_cpu_buffer *cpu_buf,
 	   unsigned long pc, unsigned long event)
 {
-	struct op_sample *entry = cpu_buffer_write_entry(cpu_buf);
-	entry->eip = pc;
-	entry->event = event;
-	cpu_buffer_write_commit(cpu_buf);
+	struct op_entry entry;
+
+	if (cpu_buffer_write_entry(&entry))
+		goto Error;
+
+	entry.sample->eip = pc;
+	entry.sample->event = event;
+
+	if (cpu_buffer_write_commit(&entry))
+		goto Error;
+
+	return;
+
+Error:
+	cpu_buf->sample_lost_overflow++;
+	return;
 }
 
 static inline void
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index 895763f..aacb0f0 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -15,6 +15,7 @@
 #include <linux/workqueue.h>
 #include <linux/cache.h>
 #include <linux/sched.h>
+#include <linux/ring_buffer.h>
 
 struct task_struct;
 
@@ -32,6 +33,12 @@ struct op_sample {
 	unsigned long event;
 };
 
+struct op_entry {
+	struct ring_buffer_event *event;
+	struct op_sample *sample;
+	unsigned long irq_flags;
+};
+
 struct oprofile_cpu_buffer {
 	volatile unsigned long head_pos;
 	volatile unsigned long tail_pos;
@@ -39,7 +46,6 @@ struct oprofile_cpu_buffer {
 	struct task_struct *last_task;
 	int last_is_kernel;
 	int tracing;
-	struct op_sample *buffer;
 	unsigned long sample_received;
 	unsigned long sample_lost_overflow;
 	unsigned long backtrace_aborted;
@@ -48,6 +54,8 @@ struct oprofile_cpu_buffer {
 	struct delayed_work work;
 };
 
+extern struct ring_buffer *op_ring_buffer_read;
+extern struct ring_buffer *op_ring_buffer_write;
 DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 
 /*
@@ -64,46 +72,49 @@ static inline void cpu_buffer_reset(int cpu)
 	cpu_buf->last_task = NULL;
 }
 
-static inline
-struct op_sample *cpu_buffer_write_entry(struct oprofile_cpu_buffer *cpu_buf)
+static inline int cpu_buffer_write_entry(struct op_entry *entry)
 {
-	return &cpu_buf->buffer[cpu_buf->head_pos];
-}
+	entry->event = ring_buffer_lock_reserve(op_ring_buffer_write,
+						sizeof(struct op_sample),
+						&entry->irq_flags);
+	if (entry->event)
+		entry->sample = ring_buffer_event_data(entry->event);
+	else
+		entry->sample = NULL;
 
-static inline
-void cpu_buffer_write_commit(struct oprofile_cpu_buffer *b)
-{
-	unsigned long new_head = b->head_pos + 1;
+	if (!entry->sample)
+		return -ENOMEM;
 
-	/*
-	 * Ensure anything written to the slot before we increment is
-	 * visible
-	 */
-	wmb();
+	return 0;
+}
 
-	if (new_head < b->buffer_size)
-		b->head_pos = new_head;
-	else
-		b->head_pos = 0;
+static inline int cpu_buffer_write_commit(struct op_entry *entry)
+{
+	return ring_buffer_unlock_commit(op_ring_buffer_write, entry->event,
+					 entry->irq_flags);
 }
 
-static inline
-struct op_sample *cpu_buffer_read_entry(struct oprofile_cpu_buffer *cpu_buf)
+static inline struct op_sample *cpu_buffer_read_entry(int cpu)
 {
-	return &cpu_buf->buffer[cpu_buf->tail_pos];
+	struct ring_buffer_event *e;
+	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
+	if (e)
+		return ring_buffer_event_data(e);
+	if (ring_buffer_swap_cpu(op_ring_buffer_read,
+				 op_ring_buffer_write,
+				 cpu))
+		return NULL;
+	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
+	if (e)
+		return ring_buffer_event_data(e);
+	return NULL;
 }
 
 /* "acquire" as many cpu buffer slots as we can */
-static inline
-unsigned long cpu_buffer_entries(struct oprofile_cpu_buffer *b)
+static inline unsigned long cpu_buffer_entries(int cpu)
 {
-	unsigned long head = b->head_pos;
-	unsigned long tail = b->tail_pos;
-
-	if (head >= tail)
-		return head - tail;
-
-	return head + (b->buffer_size - tail);
+	return ring_buffer_entries_cpu(op_ring_buffer_read, cpu)
+		+ ring_buffer_entries_cpu(op_ring_buffer_write, cpu);
 }
 
 /* transient events for the CPU buffer -> event buffer */
-- 
1.6.0.1


